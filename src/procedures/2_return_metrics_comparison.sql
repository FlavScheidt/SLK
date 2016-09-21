CREATE OR REPLACE FUNCTION return_metrics_comparison (p_metric VARCHAR(50)) 
	RETURNS TABLE (query VARCHAR(50), unit VARCHAR(10), mean DOUBLE PRECISION, stddev DOUBLE PRECISION) as $$
BEGIN

CREATE TEMPORARY TABLE temp_line AS
		SELECT DISTINCT
			slk_exec_time.id_query				as id_query,
			slk_exec_time.id					as id_exec_time,
			row_number() OVER (PARTITION BY slk_exec_time.id_query ORDER BY slk_exec_time.id DESC)	as nline
		FROM 	slk_exec_time
		ORDER BY id_query, id_exec_time
	;
	
	CREATE TEMPORARY TABLE temp_time AS
		SELECT 
			id_query,
			id_exec_time
		FROM temp_line
		WHERE nline <= 7
		ORDER BY id_query, id_exec_time
	;

	CREATE TEMPORARY TABLE temp_slk_execs AS
		SELECT DISTINCT
			slk_exec.id				as id_exec,
			temp_time.id_query  	as id_query
		FROM	temp_time	left join
				slk_exec
					on (temp_time.id_exec_time = slk_exec.id_exec_time)
		ORDER BY id_query, id_exec
	;

	RETURN QUERY
		SELECT
			slk_query.name					AS query,
			slk_metric.unit					AS unit,
			AVG(slk_metric_values.val) 		AS mean,
			stddev(slk_metric_values.val)	AS variance
		FROM 	temp_slk_execs 		left join
				slk_metric_values
					on (temp_slk_execs.id_exec = slk_metric_values.id_exec) left join
				slk_metric
					on (slk_metric_values.id_metric = slk_metric.id) left join
				slk_query
					on (temp_slk_execs.id_query = slk_query.id)
		WHERE slk_metric.name = p_metric
		GROUP BY slk_query.name, slk_metric.unit
		ORDER BY mean DESC
	;

END;
$$ LANGUAGE plpgsql;
