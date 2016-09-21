CREATE OR REPLACE FUNCTION return_metrics_avg ( p_query VARCHAR(50), p_service VARCHAR(50), p_node VARCHAR(50)  ) 
	RETURNS TABLE (metric VARCHAR(50), unit VARCHAR(10), mean DOUBLE PRECISION, max DOUBLE PRECISION, min DOUBLE PRECISION, stddev DOUBLE PRECISION) as $$
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
			slk_exec.id		as id_exec
		FROM slk_exec	
		WHERE 	slk_exec.id_exec_time 	IN (SELECT 	temp_slk_exec_time.id_exec_time
											FROM temp_slk_exec_time)
			AND slk_exec.id_service 	= (SELECT ID FROM slk_service 	WHERE name = p_service)
			AND slk_exec.id_node 		= (SELECT ID FROM slk_node 		WHERE name = p_node)
	;

	RETURN QUERY SELECT DISTINCT
		slk_metric.name					AS metric,
		slk_metric.unit					AS unit,
		AVG(slk_metric_values.val) 		AS mean,
		MAX(slk_metric_values.val) 		AS min, 
		MIN(slk_metric_values.val) 		AS max, 
		STDDEV(slk_metric_values.val) 	AS stddev
	FROM 	temp_slk_execs 		left join
			slk_metric_values
				on (temp_slk_execs.id_exec = slk_metric_values.id_exec) left join
			slk_metric
				on (slk_metric_values.id_metric = slk_metric.id)
	GROUP BY metric, slk_metric.unit
	ORDER BY metric;

END;
$$ LANGUAGE plpgsql;
