CREATE TABLE IF NOT EXISTS slk_job_sign (
	ID_CODE		INT		REFERENCES	slk_code_sign(ID),
	ID_JOB		INT		REFERENCES	slk_job(ID),
	SZ			BIGINT
);

