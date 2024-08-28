/*
https://www.freecodecamp.org/learn/relational-database/build-a-periodic-table-database-project/build-a-periodic-table-database
psql --username=freecodecamp --dbname=periodic_table
*/

ALTER TABLE properties RENAME weight TO atomic_mass;

ALTER TABLE properties RENAME melting_point TO melting_point_celsius;

ALTER TABLE properties RENAME boiling_point TO boiling_point_celsius;

ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;

ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;

ALTER TABLE elements ADD CONSTRAINT unique_symbol UNIQUE (symbol);

ALTER TABLE elements ADD CONSTRAINT unique_name UNIQUE (name);

ALTER TABLE elements ALTER COLUMN name SET NOT NULL;

ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;

ALTER TABLE properties ADD CONSTRAINT foreign_atomic_number FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);

CREATE TABLE types (
  type_id SERIAL PRIMARY KEY,
  type VARCHAR(50) NOT NULL
);

INSERT INTO types(type) 
VALUES ('nonmetal'), ('metal'), ('metalloid');

ALTER TABLE properties ADD type_id INT;

UPDATE properties SET type_id = (SELECT type_id FROM types WHERE type='nonmetal') WHERE type = 'nonmetal';
UPDATE properties SET type_id = (SELECT type_id FROM types WHERE type='metal') WHERE type = 'metal';
UPDATE properties SET type_id = (SELECT type_id FROM types WHERE type='metalloid') WHERE type = 'metalloid';

ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;

ALTER TABLE properties ADD CONSTRAINT foreign_type_id FOREIGN KEY (type_id) REFERENCES types(type_id);

UPDATE elements SET symbol = INITCAP(symbol);

ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;

UPDATE properties SET atomic_mass = CAST(REGEXP_REPLACE(TO_CHAR(atomic_mass, 'FM999999999.999999'), '(\.\d*?)0+$', '\1') AS numeric);

INSERT INTO elements(atomic_number,symbol,name) VALUES (9,'F','Fluorine');
INSERT INTO properties(atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius,type_id) VALUES (9,'nonmetal',18.998, -220, -188.1, 1);

INSERT INTO elements(atomic_number,symbol,name) VALUES (10,'Ne','Neon');
INSERT INTO properties(atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius,type_id) VALUES (10,'nonmetal',20.18,-248.6,-246.1, 1);

DELETE FROM properties WHERE atomic_number = 1000;
DELETE FROM elements WHERE atomic_number = 1000;

ALTER TABLE properties DROP COLUMN type;
