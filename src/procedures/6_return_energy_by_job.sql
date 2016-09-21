CREATE OR REPLACE FUNCTION return_energy_by_job ( p_query VARCHAR(50) ) 
	RETURNS TABLE (job BIGINT, node VARCHAR(50), service VARCHAR(50), mean DOUBLE PRECISION, stddev DOUBLE PRECISION) as $$
BEGIN

	DROP TABLE IF EXISTS temp_slk_exec_time;
	CREATE TEMPORARY TABLE temp_slk_exec_time AS
		SELECT
			slk_exec_time.id	as id_exec_time
		FROM slk_exec_time
		WHERE slk_exec_time.id_query = (SELECT id FROM slk_query WHERE slk_query.name = p_query)
		ORDER BY id_exec_time DESC LIMIT 7
	;
	
	DROP TABLE IF EXISTS temp_slk_execs;	
	CREATE TEMPORARY TABLE temp_slk_execs AS
		SELECT 
			slk_exec.id_exec_time	as id_exec_time,
			slk_exec.id				as id_exec,
			slk_service.name		as service,
			slk_node.name			as node
		FROM 	slk_exec	left join
				slk_service
					on (slk_exec.id_service = slk_service.id) left join
				slk_node
					on (slk_exec.id_node = slk_node.id)
		WHERE 	slk_exec.id_exec_time 	IN (SELECT 	temp_slk_exec_time.id_exec_time
											FROM temp_slk_exec_time)
	;
	
	DROP TABLE IF EXISTS temp_slk_jobs;
	CREATE TEMPORARY TABLE  temp_slk_jobs AS
		SELECT DISTINCT
			temp_slk_execs.id_exec_time,
			temp_slk_execs.id_exec,
			temp_slk_execs.service,
			temp_slk_execs.node,
			slk_job.id						as id_job,
			slk_job.time_init				as job_init,
			slk_job.time_end				as job_end
		FROM 	temp_slk_execs left join
				slk_job
					on (temp_slk_execs.id_exec_time = slk_job.id_exec_time)
		ORDER BY temp_slk_execs.id_exec, slk_job.id
	;

	DROP TABLE IF EXISTS temp_slk_job_num;
	CREATE TEMPORARY TABLE temp_slk_job_num AS
		SELECT DISTINCT
			row_number() OVER (PARTITION BY temp_slk_jobs.id_exec ORDER BY temp_slk_jobs.id_job DESC)	as job,
			temp_slk_jobs.id_exec,
			temp_slk_jobs.node,
			temp_slk_jobs.service,
			temp_slk_jobs.job_init,
			temp_slk_jobs.job_end
		FROM temp_slk_jobs
		ORDER BY temp_slk_jobs.id_exec, job
	;

	DROP TABLE IF EXISTS temp_slk_plots;
	CREATE TEMPORARY TABLE temp_slk_plots AS
		SELECT
			temp_slk_job_num.job,
			temp_slk_job_num.id_exec,
			temp_slk_job_num.node,
			temp_slk_job_num.service,
			temp_slk_job_num.job_init,
			temp_slk_job_num.job_end,
			coalesce(slk_plots.val, 0.0)	as val,
			slk_plots.timest
		FROM  	temp_slk_job_num left join
				slk_plots
				On( slk_plots.id_exec = temp_slk_job_num.id_exec
					and slk_plots.timest >= temp_slk_job_num.job_init and slk_plots.timest <= temp_slk_job_num.job_end)
		ORDER BY job, id_exec
	;

	RETURN QUERY
		SELECT
			temp_slk_plots.job,
			temp_slk_plots.node,
			temp_slk_plots.service,
			AVG(temp_slk_plots.val),
			coalesce(STDDEV(temp_slk_plots.val), 0.0)
		FROM 	temp_slk_plots
		GROUP BY temp_slk_plots.job, temp_slk_plots.node, temp_slk_plots.service
		ORDER BY temp_slk_plots.node, temp_slk_plots.service, temp_slk_plots.job
	;

END;
$$ LANGUAGE plpgsql;

