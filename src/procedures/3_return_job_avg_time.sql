CREATE OR REPLACE FUNCTION return_job_avg_time (p_query VARCHAR(50)) 
	RETURNS TABLE (time_init INT, time_end INT) as $$
BEGIN
	
	DROP TABLE IF EXISTS temp_exec_time;
	CREATE TEMPORARY TABLE temp_exec_time AS
		SELECT
			slk_exec_time.id			as id_exec_time,
			slk_exec_time.time_init		as time_init
		FROM 	slk_exec_time
		WHERE id_query = (SELECT id from slk_query WHERE name = p_query)
		ORDER BY id_exec_time DESC LIMIT 7
	;

	DROP TABLE IF EXISTS temp_job_info;
	CREATE TEMPORARY TABLE temp_job_info AS
		SELECT
			temp_exec_time.id_exec_time		as id_exec_time,
			slk_job.id						as id_job,
			row_number() OVER (PARTITION BY temp_exec_time.id_exec_time ORDER BY slk_job.id DESC)	as nr_job,
			temp_exec_time.time_init		as time_init,
			slk_job.time_init				as job_init,
			slk_job.time_end				as job_end
		FROM 	temp_exec_time left join
				slk_job
					On (slk_job.id_exec_time = temp_exec_time.id_exec_time)
	;

	DROP TABLE IF EXISTS temp_dif_time;
	CREATE TEMPORARY TABLE temp_dif_time AS
		SELECT
			temp_job_info.nr_job								as nr_job,
			job_init,
			job_end,
			(temp_job_info.job_init -temp_job_info.time_init)	as init_dif,
			(temp_job_info.job_end - temp_job_info.time_init)	as end_dif
		FROM temp_job_info
	;

	RETURN QUERY
		SELECT DISTINCT
				CAST(min(temp_dif_time.init_dif)	AS INT)	as time_init,
				CAST(min(temp_dif_time.end_dif)		AS INT)	as time_end	
			FROM temp_dif_time
			GROUP BY nr_job
			ORDER BY time_init
	;
	
END;
$$ LANGUAGE plpgsql;


