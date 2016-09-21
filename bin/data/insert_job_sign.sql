CREATE TEMPORARY TABLE tmp_code_sign
	(query	INT,
	code 	VARCHAR(250),
	sz		BIGINT)
;

COPY tmp_code_sign FROM '/home/flav/salaak/bin/data/code-signatures-30GB.csv' DELIMITER ';' CSV;

CREATE TEMPORARY TABLE temp_id_code_sign AS
	SELECT
		(CASE 
			WHEN tmp_code_sign.query < 10 THEN 'q0' || tmp_code_sign.query		
			ELSE 'q' || tmp_code_sign.query
		END)														as query,
		row_number() OVER (PARTITION BY tmp_code_sign.query)	as job,
		slk_code_sign.id		as id_sign,
		tmp_code_sign.code		as code,
		tmp_code_sign.sz		as sz
	FROM 	tmp_code_sign left join
			slk_code_sign 
				on (tmp_code_sign.code = slk_code_sign.sign)
;

CREATE TEMPORARY TABLE temp_query_job AS
	SELECT
		slk_query.name		as query,
		slk_exec_time.id	as id_exec_time,
		slk_job.id			as id_job
	FROM 	slk_query	left join
			slk_exec_time
				on (slk_query.id = slk_exec_time.id_query) left join
			slk_job
				on (slk_exec_time.id = slk_job.id_exec_time)
	ORDER BY id_exec_time, id_job DESC
;

CREATE TEMPORARY TABLE temp_job_num AS
	SELECT
		query,
		id_job,
		id_exec_time,
		row_number() OVER (PARTITION BY id_exec_time ORDER BY id_job DESC)	as job
	FROM temp_query_job
;

select * from temp_query_job;
 
CREATE TEMPORARY TABLE temp_job_code AS
	SELECT
		temp_job_num.query				as query_base,
		temp_id_code_sign.query			as query_file,
		temp_job_num.id_job				as id_job,
		temp_job_num.id_exec_time		as id_exec_time,
		temp_job_num.job				as job_base,
		temp_id_code_sign.job			as job_file,
		temp_id_code_sign.id_sign		as id_sign,
		temp_id_code_sign.sz			as sz
	FROM 	temp_id_code_sign	left join
			temp_job_num
				on (temp_id_code_sign.query = temp_job_num.query
					and temp_id_code_sign.job = temp_job_num.job)
;

INSERT INTO slk_job_sign 
	SELECT DISTINCT
		id_sign		as id_sign,
		id_job		as id_job,
		sz			as sz
	FROM temp_job_code
;

