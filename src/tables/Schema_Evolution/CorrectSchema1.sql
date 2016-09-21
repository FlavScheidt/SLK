ALTER TABLE slk_exec 	DROP COLUMN id_exec_time;
;

CREATE TEMPORARY TABLE temp_slk_exec AS
	SELECT DISTINCT 
		id_query,
		time_init
	FROM slk_exec_time
;

SELECT * FROM temp_slk_exec order by id_query, time_init
;

TRUNCATE slk_exec_time;

INSERT INTO slk_exec_time (id_query, time_init)
	SELECT DISTINCT
		id_query,
		time_init
	FROM temp_slk_exec
;
	
ALTER TABLE slk_exec ADD COLUMN ID_EXEC_TIME INT REFERENCES slk_exec_time(ID)
;
	
UPDATE slk_exec set ID_EXEC_TIME = (
	SELECT 
		slk_exec_time.ID
	FROM slk_exec_time
	WHERE 	slk_exec_time.id_query = slk_exec.id_query AND
			slk_exec_time.time_init = slk_exec.time_init)
;
