CREATE OR REPLACE FUNCTION return_energy_ranking_by_size ( p_sz BIGINT ) 
	RETURNS TABLE ( query VARCHAR(50), job BIGINT, sign INT, mean DOUBLE PRECISION, stddev DOUBLE PRECISION ) as $$	
DECLARE 
	q VARCHAR(50);
BEGIN

	DROP TABLE IF EXISTS temp_slk_sign;
	CREATE TEMPORARY TABLE temp_slk_sign AS
		SELECT
			slk_job_sign.id_job,
			slk_job_sign.id_code		as sign
		FROM 	slk_job_sign
		WHERE slk_job_sign.sz = p_sz
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
			temp_slk_sign.sign,
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

	DROP TABLE IF EXISTS temp_slk_job_exec;
	CREATE TEMPORARY TABLE temp_slk_job_exec (
		query		VARCHAR(50),
		t_init		INT,
		t_end		INT)
	;
	
	FOR q IN SELECT DISTINCT temp_slk_exec_time.query FROM temp_slk_exec_time LOOP
		INSERT INTO temp_slk_job_exec
			SELECT 
				q				as query,
				time_init		as t_init,
				time_end		as t_end
			FROM return_job_avg_time(q)
		;
	END LOOP
	;
	
	DROP TABLE IF EXISTS temp_slk_job_n;
	CREATE TEMPORARY TABLE temp_slk_job_n AS
		SELECT 
			temp_slk_job_exec.query,
			row_number() OVER (PARTITION BY temp_slk_job_exec.query ORDER BY temp_slk_job_exec.t_init)	as job,
			temp_slk_job_exec.t_init,
			temp_slk_job_exec.t_end
		FROM temp_slk_job_exec
	;	

	DROP TABLE IF EXISTS temp_slk_job_init;
	CREATE TEMPORARY TABLE temp_slk_job_init AS
		SELECT
			temp_slk_exec_time.id_exec_time,
			temp_slk_job_n.query,
			temp_slk_job_n.job,
			temp_slk_job_n.t_init,
			temp_slk_job_n.t_end,
			temp_slk_exec_time.sign,
			temp_slk_exec_time.time_init,
			temp_slk_exec_time.time_end
		FROM 	temp_slk_exec_time join
				temp_slk_job_n
					on (temp_slk_exec_time.query = temp_slk_job_n.query and temp_slk_exec_time.job = temp_slk_job_n.job)
	;
	
	DROP TABLE IF EXISTS temp_slk_plots;
	CREATE TEMPORARY TABLE temp_slk_plots AS
		SELECT 
			temp_slk_job_init.id_exec_time		as id_exec_time,
			slk_exec.id							as id_exec,
			temp_slk_job_init.query				as query,
			temp_slk_job_init.job				as job,
			temp_slk_job_init.t_init			as t_init,
			temp_slk_job_init.t_end				as t_end,		
			temp_slk_job_init.time_init			as time_init,
			temp_slk_job_init.time_end			as time_end,
			temp_slk_job_init.sign				as sign,
			slk_plots.val						as val,
			slk_plots.timest					as timest,
			row_number() OVER (PARTITION BY slk_exec.id ORDER BY slk_plots.timest)	as n_line
		FROM 	temp_slk_job_init	left join
				slk_exec
					on (temp_slk_job_init.id_exec_time = slk_exec.id_exec_time) left join
				slk_plots
					on (slk_exec.id = slk_plots.id_exec)
		--WHERE slk_plots.timest BETWEEN temp_slk_exec_time.time_init AND temp_slk_exec_time.time_end
	;
	
	DROP TABLE IF EXISTS temp_slk_final;
	CREATE TEMPORARY TABLE temp_slk_final AS
		SELECT DISTINCT
			temp_slk_plots.query				as query,
			temp_slk_plots.job					as job,
			temp_slk_plots.sign					as sign,
			AVG(temp_slk_plots.val)				as mean,
			STDDEV(temp_slk_plots.val)			as stddev
		FROM	temp_slk_plots
		WHERE 	(timest BETWEEN time_init AND time_end)
		GROUP BY temp_slk_plots.query, temp_slk_plots.job,  temp_slk_plots.sign
		ORDER BY mean DESC
	;
	
	RETURN QUERY
		SELECT DISTINCT
			temp_slk_job_init.query,
			temp_slk_job_init.job,
			temp_slk_job_init.sign,
			coalesce(temp_slk_final.mean, 0.0)			as mean,
			coalesce(temp_slk_final.stddev, 0.0)
		FROM 	temp_slk_job_init left join
				temp_slk_final
					on (temp_slk_job_init.query = temp_slk_final.query and temp_slk_job_init.job = temp_slk_final.job)
		ORDER BY mean DESC
	;
	
END;
$$ LANGUAGE plpgsql;



