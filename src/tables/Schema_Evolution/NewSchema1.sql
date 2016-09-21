drop table slk_profile;

--Create exec_time
CREATE TABLE IF NOT EXISTS slk_exec_time (
	ID				SERIAL			UNIQUE							NOT NULL,
	ID_QUERY		INT 			REFERENCES slk_query(ID),
	TIME_INIT		INT,
	PRIMARY KEY(ID))
;

-- Create job
CREATE TABLE IF NOT EXISTS slk_job (
	ID				SERIAL		UNIQUE,
	ID_EXEC_TIME	INT			REFERENCES slk_exec_time(ID),
	TIME_INIT		INT,
	TIME_END		INT,
	PRIMARY KEY(ID))
;

-- Fill slk_exec_time

--CREATE TEMPORARY TABLE temp_slk_exec_time AS
	--SELECT DISTINCT
		--slk_exec.ID_QUERY,
		--slk_exec.TIME_INIT
	--FROM slk_exec
	--ORDER BY id_query, time_init
--;

--INSERT INTO slk_exec_time (ID_QUERY, TIME_INIT) 
	--SELECT DISTINCT
		--ID_QUERY,
		--TIME_INIT
	--FROM temp_slk_exec_time
	--ORDER BY id_query, time_init
--;

--SELECT * FROM slk_exec_time ORDER BY id_query, time_init;

-- Alter exec. Add column id_exec_time
--ALTER TABLE slk_exec ADD COLUMN ID_EXEC_TIME INT REFERENCES slk_exec_time(ID);

--UPDATE slk_exec set ID_EXEC_TIME = (
	--SELECT 
		--slk_exec_time.ID
	--FROM slk_exec_time
	--WHERE 	slk_exec_time.id_query = slk_exec.id_query AND
			--slk_exec_time.time_init = slk_exec.time_init)
--;

-- Drop columns from exec
ALTER TABLE slk_exec 	DROP COLUMN ID_QUERY,
						DROP COLUMN TIME_INIT
;

SELECT * FROM slk_exec
;
