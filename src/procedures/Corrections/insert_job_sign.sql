CREATE TEMPORARY TABLE tmp_code_sign
	(query	INT,
	code 	VARCHAR(250))
;

COPY tmp_code_sign FROM '/home/flav/salaak/bin/data/code-signatures-30GB.csv' DELIMITER ';' CSV;

select * from tmp_code_sign
;
	
