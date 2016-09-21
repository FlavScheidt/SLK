CREATE OR REPLACE FUNCTION return_plots_avg ( p_query VARCHAR(50), p_service VARCHAR(50), p_node VARCHAR(50)  ) 
	RETURNS TABLE (t BIGINT, mean DOUBLE PRECISION) AS $$
DECLARE
	points INT;
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
	
	DROP TABLE IF EXISTS temp_slk_plots_lines;
	
	CREATE TEMPORARY TABLE temp_slk_plots_lines AS
		SELECT
			row_number() OVER (PARTITION BY slk_plots.id_exec ORDER BY slk_plots.timest)	AS nlines,
			slk_plots.timest																AS t,
			slk_plots.id_exec																AS id_exec,
			slk_plots.val																	AS val
		FROM 	temp_slk_execs left join
				slk_plots
					on (temp_slk_execs.id_exec = slk_plots.id_exec)
		ORDER BY slk_plots.id_exec, slk_plots.timest
		;

	RETURN QUERY SELECT
		(nlines*5)									AS t,
		AVG(temp_slk_plots_lines.val) 				AS mean
	FROM 	temp_slk_execs left join
			temp_slk_plots_lines
				on (temp_slk_execs.id_exec = temp_slk_plots_lines.id_exec)
	GROUP BY temp_slk_plots_lines.nlines
	ORDER BY temp_slk_plots_lines.nlines ASC 
	;

END;
$$ LANGUAGE plpgsql;
