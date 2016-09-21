ALTER TABLE slk_metric ADD COLUMN UNIT	VARCHAR(10);

UPDATE slk_metric SET unit = '[s]' WHERE name = 'Runtime';
UPDATE slk_metric SET unit = '[s]' WHERE name = 'Runtime Unhalted';
UPDATE slk_metric SET unit = '[MHz]' WHERE name = 'Clock Uhalted';
UPDATE slk_metric SET unit = '[MHz]' WHERE name = 'Clock Unhalted Ref';
UPDATE slk_metric SET unit = '[C]' WHERE name = 'Temperature';
UPDATE slk_metric SET unit = '[J]' WHERE name = 'Energy PKG';
UPDATE slk_metric SET unit = '[J]' WHERE name = 'Energy PP0';
