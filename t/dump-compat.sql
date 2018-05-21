
DROP TABLE IF EXISTS test_table;
CREATE TABLE test_table (
    c1 TEXT
); 

INSERT INTO test_table(c1) VALUES('a');
INSERT INTO test_table(c1) VALUES('ab');
INSERT INTO test_table(c1) VALUES('abc');
INSERT INTO test_table(c1) VALUES('abcd');
INSERT INTO test_table(c1) VALUES('abcde');
INSERT INTO test_table(c1) VALUES('abcdef');

CREATE INDEX test_idx ON test_table (c1);

