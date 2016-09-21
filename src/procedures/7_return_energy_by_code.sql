CREATE OR REPLACE FUNCTION return_energy_by_code () 
	RETURNS TABLE (signature INT, mean DOUBLE PRECISION, stddev DOUBLE PRECISION) as $$
DECLARE
	nQueries INT;
BEGIN

	SELECT count(id) INTO nQueries FROM slk_query;
	
	DROP TABLE IF EXISTS temp_slk_exec_time;
	CREATE TEMPORARY TABLE temp_slk_exec_time AS
		SELECT
			slk_exec_time.id	as id_exec_time
		FROM 	slk_exec_time
		ORDER BY id_exec_time DESC LIMIT (7*nQueries)
	;

	DROP TABLE IF EXISTS temp_slk_jobs;
	CREATE TABLE temp_slk_jobs AS
		SELECT
			temp_slk_exec_time.id_exec_time		as id_exec_time,
			slk_code_sign.id					as signature,
			slk_job.id							as id_job
		FROM	temp_slk_exec_time left join
				slk_job
					on (temp_slk_exec_time.id_exec_time = slk_job.id_exec_time) left join
				slk_job_sign
					on (slk_job.id = slk_job_sign.id_job) left join
				slk_code_sign
					on (slk_job_sign.id_code = slk_code_sign.id)
	;
	
	DROP TABLE IF EXISTS temp_slk_plots_mean;
	CREATE TEMPORARY TABLE temp_slk_plots_mean AS
		SELECT
			temp_slk_jobs.signature,
			AVG(slk_plots.val)			as mean_plots
		FROM 	temp_slk_jobs	left join
				slk_exec
					on (temp_slk_jobs.id_exec_time = slk_exec.id_exec_time) left join
				slk_plots
					on (slk_exec.id = slk_plots.id_exec)
		GROUP BY temp_slk_jobs.signature, temp_slk_jobs.id_job, temp_slk_jobs.id_exec_time
		ORDER BY mean DESC
	;

	RETURN QUERY
		SELECT
			temp_slk_plots_mean.signature			as signature,
			AVG(temp_slk_plots_mean.mean_plots)		as mean,
			STDDEV(temp_slk_plots_mean.mean_plots)	as stddev
		FROM temp_slk_plots_mean
		WHERE temp_slk_plots_mean.signature IS NOT NULL
		GROUP BY temp_slk_plots_mean.signature
		ORDER BY mean DESC
	;

END;
$$ LANGUAGE plpgsql;


