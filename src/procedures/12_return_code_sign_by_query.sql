CREATE OR REPLACE FUNCTION return_code_sign_by_query ( p_query VARCHAR(50) ) 
	RETURNS TABLE ( job BIGINT, sign VARCHAR(250), sz BIGINT ) as $$
BEGIN

	DROP TABLE IF EXISTS temp_slk_exec_time;
	CREATE TEMPORARY TABLE temp_slk_exec_time AS
		SELECT
			slk_exec_time.id	as id_exec_time
		FROM 	slk_exec_time	left join
				slk_query
					on (slk_exec_time.id_query = slk_query.id)
		WHERE slk_query.name = p_query
		ORDER BY id_exec_time DESC LIMIT 1
	;
	
	DROP TABLE IF EXISTS temp_slk_job;
	CREATE TEMPORARY TABLE temp_slk_job AS
		SELECT
			temp_slk_exec_time.id_exec_time,
			slk_job.id			as id_job
		FROM	temp_slk_exec_time  left join
				slk_job
					on (slk_job.id_exec_time = temp_slk_exec_time.id_exec_time)
		ORDER BY slk_job.id DESC
	;
	
	RETURN QUERY
		SELECT
			row_number() OVER (ORDER BY temp_slk_job.id_job DESC),
			slk_code_sign.sign,
			slk_job_sign.sz
		FROM 	temp_slk_job	left join
				slk_job_sign
					on (temp_slk_job.id_job = slk_job_sign.id_job) left join
				slk_code_sign
					on (slk_job_sign.id_code = slk_code_sign.id)
	;
	
END;
$$ LANGUAGE plpgsql;
