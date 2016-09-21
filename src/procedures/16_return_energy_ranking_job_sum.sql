CREATE OR REPLACE FUNCTION return_energy_ranking_job_sum ( p_signature INT ) 
	RETURNS TABLE ( query VARCHAR(50), job BIGINT, sz BIGINT, sm DOUBLE PRECISION, peak DOUBLE PRECISION ) as $$	
DECLARE 
	q VARCHAR(50);
BEGIN

	DROP TABLE IF EXISTS temp_slk_sign;
	CREATE TEMPORARY TABLE temp_slk_sign AS
		SELECT
			slk_job_sign.id_job,
			slk_job_sign.sz
		FROM slk_job_sign
		WHERE slk_job_sign.id_code = p_signature
	;
	
	DROP TABLE IF EXISTS temp_slk_job;
	CREATE TEMPORARY TABLE temp_slk_job	AS
		SELECT
			slk_job.id_exec_time		as id_exec_time,
			slk_job.id					as id_job,
			slk_job.time_init			as time_init,
			slk_job.time_end			as time_end,
			row_number() OVER (PARTITION BY slk_job.id_exec_time ORDER BY slk_job.id DESC)	as job
		FROM slk_job
	;

	DROP TABLE IF EXISTS temp_slk_exec_time;
	CREATE TEMPORARY TABLE temp_slk_exec_time AS
		SELECT 
			temp_slk_job.id_exec_time,
			slk_query.name					as query,
			temp_slk_job.job,
			temp_slk_sign.sz,
			temp_slk_job.time_init,
			temp_slk_job.time_end
		FROM 	temp_slk_sign left join
				temp_slk_job
					on (temp_slk_sign.id_job = temp_slk_job.id_job) left join
				slk_exec_time
					on (temp_slk_job.id_exec_time = slk_exec_time.id) left join
				slk_query
					on (slk_query.id = slk_exec_time.id_query)
	;

	DROP TABLE IF EXISTS temp_slk_plots;
	CREATE TEMPORARY TABLE temp_slk_plots AS
		SELECT 
			temp_slk_exec_time.id_exec_time		as id_exec_time,
			slk_exec.id							as id_exec,
			temp_slk_exec_time.query			as query,
			temp_slk_exec_time.job				as job,		
			temp_slk_exec_time.time_init		as time_init,
			temp_slk_exec_time.time_end			as time_end,
			temp_slk_exec_time.sz				as sz,
			coalesce(slk_plots.val,0.0)			as val,
			slk_plots.timest					as timest,
			row_number() OVER (PARTITION BY slk_exec.id ORDER BY slk_plots.timest)	as n_line
		FROM 	temp_slk_exec_time	left join
				slk_exec
					on (temp_slk_exec_time.id_exec_time = slk_exec.id_exec_time) left join
				slk_plots
					on (slk_exec.id = slk_plots.id_exec and (slk_plots.timest BETWEEN temp_slk_exec_time.time_init AND temp_slk_exec_time.time_end))
		--WHERE slk_plots.timest BETWEEN temp_slk_exec_time.time_init AND temp_slk_exec_time.time_end
	;
	
	DROP TABLE IF EXISTS temp_slk_plots_sum;
	CREATE TABLE temp_slk_plots_sum AS
		SELECT DISTINCT
			temp_slk_plots.query				as query,
			temp_slk_plots.job					as job,
			temp_slk_plots.sz					as sz,
			SUM(temp_slk_plots.val)				as sm,
			MAX(temp_slk_plots.val)				as peak
		FROM	temp_slk_plots
		--WHERE 	(timest BETWEEN time_init AND time_end)
		GROUP BY temp_slk_plots.id_exec_time, temp_slk_plots.query, temp_slk_plots.job, temp_slk_plots.sz
		ORDER BY sm DESC
	;
	
	RETURN QUERY
		SELECT DISTINCT
			temp_slk_plots_sum.query				as query,
			temp_slk_plots_sum.job					as job,
			temp_slk_plots_sum.sz					as sz,
			AVG(temp_slk_plots_sum.sm)				as sm,
			AVG(temp_slk_plots_sum.peak)			as peak
		FROM	temp_slk_plots_sum
		GROUP BY temp_slk_plots_sum.query, temp_slk_plots_sum.job,  temp_slk_plots_sum.sz
		ORDER BY sm DESC
	;
	
END;
$$ LANGUAGE plpgsql;


