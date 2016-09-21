CREATE OR REPLACE FUNCTION return_query_job_by_sign ( p_signature INT )
	RETURNS TABLE ( query VARCHAR(50), job BIGINT ) as $$
BEGIN

	DROP TABLE IF EXISTS temp_slk_sign;
	CREATE TEMPORARY TABLE temp_slk_sign AS
		SELECT
			slk_job_sign.id_job
		FROM slk_job_sign
		WHERE slk_job_sign.id_code = p_signature
	;
	
	DROP TABLE IF EXISTS temp_slk_job;
	CREATE TEMPORARY TABLE temp_slk_job	AS
		SELECT
			slk_job.id_exec_time		as id_exec_time,
			slk_job.id					as id_job,
			row_number() OVER (PARTITION BY slk_job.id_exec_time ORDER BY slk_job.id DESC)	as job
		FROM slk_job
	;

	DROP TABLE IF EXISTS temp_slk_exec_time;
	CREATE TEMPORARY TABLE temp_slk_exec_time AS
		SELECT 
			temp_slk_job.id_exec_time,
			temp_slk_job.job
		FROM 	temp_slk_sign left join
				temp_slk_job
					on (temp_slk_sign.id_job = temp_slk_job.id_job)
	;

	RETURN QUERY
		SELECT DISTINCT
			slk_query.name			as query,
			temp_slk_exec_time.job	as job
		FROM	temp_slk_exec_time	left join
				slk_exec_time
					on (temp_slk_exec_time.id_exec_time = slk_exec_time.id) left join
				slk_query
					on (slk_exec_time.id_query = slk_query.id)
	;
	
END;
$$ LANGUAGE plpgsql;
