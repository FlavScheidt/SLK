CREATE TABLE IF NOT EXISTS slk_metric_values (
	ID_EXEC				INT		REFERENCES slk_exec(ID),
	ID_METRIC			INT		REFERENCES slk_metric(ID),
	VAL							DOUBLE PRECISION		NOT NULL,
	PRIMARY KEY (ID_EXEC, ID_METRIC)
);
