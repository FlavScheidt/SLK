-- Plots
CREATE TEMPORARY TABLE temp_lines AS
	SELECT 
		id_exec,
		row_number() OVER (PARTITION BY id_exec ORDER BY timest DESC)	as line,
		timest,
		val
	FROM slk_plots
;

CREATE TEMPORARY TABLE temp_wrong_val AS
	SELECT
		id_exec,
		line,
		timest,
		val
	FROM temp_lines
	WHERE val > 30 or val < 0
;

CREATE TEMPORARY TABLE temp_around_ant AS
	SELECT
		t1.id_exec,
		t1.line,
		(t1.line-1)		as line_ant,
		t2.val			as val
	FROM 	temp_wrong_val	t1 left join
			temp_lines		t2
				on (t1.id_exec = t2.id_exec and t2.line = (t1.line-1))
;
	
CREATE TEMPORARY TABLE temp_around_post AS
	SELECT
		t1.id_exec,
		t1.line,
		(t1.line+1)		as line_post,
		t2.val			as val
	FROM 	temp_wrong_val	t1 left join
			temp_lines		t2
				on (t1.id_exec = t2.id_exec and t2.line = (t1.line+1))
;

CREATE TEMPORARY TABLE temp_around AS 
	SELECT
		t1.id_exec												as id_exec,
		t1.timest												as timest,
		t1.line													as line,
		t1.val													as original_val,
		coalesce(t2.val, t3.val)								as val_ant,
		coalesce(t3.val, t2.val)								as val_post,
		(coalesce(t2.val, t3.val)+coalesce(t3.val, t2.val))/2	as val_new
	FROM 	temp_wrong_val	t1	left join
			temp_around_ant	t2
				on (t1.id_exec = t2.id_exec and t1.line = t2.line) left join
			temp_around_post t3
				on (t1.id_exec = t3.id_exec and t1.line = t3.line)
;

UPDATE slk_plots SET val = temp_around.val_new
	FROM 	temp_around
	WHERE slk_plots.id_exec = temp_around.id_exec and slk_plots.timest = temp_around.timest
;


--Metrics
--CREATE TEMPORARY TABLE temp_lines_metrics AS
	--SELECT 
		--slk_metric_values.id_exec,
		--slk_exec_time.id_query,
		--slk_metric_values.id_metric,
		--val
	--FROM 	slk_metric_values left join
			--slk_exec
				--on (slk_exec.id = slk_metric_values.id_exec) left join
			--slk_exec_time
				--on (slk_exec_time.id = slk_exec.id_exec_time)
	--WHERE id_metric in (8,9) and (val < 1000000 or val > 1)
--;

--CREATE TEMPORARY TABLE temp_avg AS 
--SELECT
	--id_query,
	--id_metric,
	--avg(val)		as val
--FROM temp_lines_metrics
--GROUP BY id_query, id_metric
--;

--CREATE TEMPORARY TABLE temp_id_exec AS
--SELECT
	--temp_lines_metrics.id_exec,
	--temp_avg.id_query,
	--temp_avg.id_metric,
	--temp_avg.val
--FROM	temp_avg 			left join
		--temp_lines_metrics
			--on (temp_avg.id_query = temp_lines_metrics.id_query and temp_avg.id_metric = temp_lines_metrics.id_metric)
--;

--CREATE TEMPORARY TABLE temp_wrong AS
--SELECT
	--slk_metric_values.id_exec,
	--slk_exec_time.id_query,
	--slk_metric_values.id_metric,
	--slk_metric_values.val
--FROM 	slk_metric_values	left join
		--slk_exec	
			--on (slk_metric_values.id_exec = slk_exec.id) left join
		--slk_exec_time
			--on (slk_exec.id_exec_time = slk_exec_time.id)
--WHERE (slk_metric_values.val > 100000 or slk_metric_values.val < 1) and id_metric in (8,9)
--;

--CREATE TEMPORARY TABLE temp_final AS
--SELECT
	--temp_wrong.id_exec,
	--temp_wrong.id_metric,
	--temp_wrong.val			as old_val,
	--temp_id_exec.val
--FROM 	temp_wrong left join
		--temp_id_exec
			--On (temp_wrong.id_query = temp_id_exec.id_query)
--;

--UPDATE slk_metric_values SET val = temp_final.val
	--FROM temp_final
	--WHERE slk_metric_values.id_exec = temp_final.id_exec 
		--and slk_metric_values.id_metric = temp_final.id_metric
--;
