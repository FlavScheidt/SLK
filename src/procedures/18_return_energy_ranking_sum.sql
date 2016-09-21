CREATE OR REPLACE FUNCTION return_energy_ranking_sum () 
	RETURNS TABLE ( query VARCHAR(50), sm DOUBLE PRECISION) as $$	
BEGIN

	DROP TABLE IF EXISTS temp_line;
	CREATE TEMPORARY TABLE temp_line AS
		SELECT DISTINCT
			slk_exec_time.id_query				as id_query,
			slk_exec_time.id					as id_exec_time,
			row_number() OVER (PARTITION BY slk_exec_time.id_query ORDER BY slk_exec_time.id DESC)	as nline
		FROM 	slk_exec_time
		ORDER BY id_query, id_exec_time
	;
	
	DROP TABLE IF EXISTS temp_time;
	CREATE TEMPORARY TABLE temp_time AS
		SELECT 
			id_query,
			id_exec_time
		FROM temp_line
		WHERE nline <= 7
		ORDER BY id_query, id_exec_time
	;
	
	DROP TABLE IF EXISTS temp_slk_exec;
	CREATE TEMPORARY TABLE temp_slk_exec AS
		SELECT
			temp_time.id_query,
			temp_time.id_exec_time,
			slk_plots.val
		FROM 	temp_time	left join
				slk_exec
					on (slk_exec.id_exec_time = temp_time.id_exec_time) left join
				slk_plots
					on (slk_exec.id = slk_plots.id_exec)
	;
	
	DROP TABLE IF EXISTS temp_slk_sum;
	CREATE TEMPORARY TABLE temp_slk_sum AS
		SELECT
			temp_slk_exec.id_query,
			temp_slk_exec.id_exec_time,
			sum(temp_slk_exec.val)			as sm
		FROM temp_slk_exec
		GROUP  BY temp_slk_exec.id_exec_time, temp_slk_exec.id_query
	;
	
	RETURN QUERY
		SELECT
			slk_query.name,
			avg(temp_slk_sum.sm)		as sm
		FROM 	temp_slk_sum left join
				slk_query
					on (temp_slk_sum.id_query = slk_query.id)
		GROUP BY slk_query.name
		ORDER BY sm DESC
	;
	
END;
$$ LANGUAGE plpgsql;



