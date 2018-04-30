--
--
--
--
-- This will test if current_setting and set_setting
-- provide a way to persist data when used in a function
-- that is used to build an expression index using CREATE INDEX
--
-- (the function that's going to call current_setting and
--  set_setting will be the same one that's going to be used
--  to create an expression index)
--
-- What ends up happening here is that
-- CREATE INDEX will run your function in a different way on 9.6.8 (than on previous 9.6.x and 9.5.x)
-- on pg_restore than if you would run it yourself manually inside of a psql session.
-- 
-- So if you were relying upon current_setting/set_config to persist your
-- settings throughout the CREATE INDEX statement in pg_restore, you'll find out
-- that's actually not true in version 9.6.8
-- 
-- Another reason this is wrong is because of this quote in the PostgreSQL manual
-- 
-- "A common error is to label a function IMMUTABLE when its results
-- depend on a configuration parameter. For example, a function that
-- manipulates timestamps might well have results that depend on the TimeZone
-- setting. For safety, such functions should be labeled STABLE instead."
-- 
--   -- https://www.postgresql.org/docs/9.6/static/xfunc-volatility.html
--
-- Another quote that recommends against the usage of set_config/current_setting is
--
-- "All functions and operators used in an index definition must be
-- "immutable", that is, their results must depend only on their arguments
-- and never on any outside influence (such as the contents of another
-- table or the current time). This restriction ensures that the behavior
-- of the index is well-defined. To use a user-defined function in an index
-- expression or WHERE clause, remember to mark the function immutable when
-- you create it."
--
--   -- https://www.postgresql.org/docs/9.6/static/sql-createindex.html
--
--
--
CREATE OR REPLACE FUNCTION public.isempty(input character varying) RETURNS boolean
LANGUAGE sql IMMUTABLE
AS $$
SELECT input IS NULL OR input = ''; 
$$;



CREATE OR REPLACE FUNCTION public.test1(p_string character varying) RETURNS character varying
LANGUAGE plpgsql IMMUTABLE
AS $$

DECLARE
persist TEXT;
BEGIN

    BEGIN
        SELECT current_setting('prefix.persist') INTO STRICT persist;
        IF isempty(persist) THEN
            RAISE EXCEPTION 'persist session variable not set';
        ELSE
            RAISE NOTICE 'prefix.persist was set';
            RAISE LOG 'prefix.persist was set';
        END IF; 

        RETURN ''; 
    EXCEPTION
        WHEN OTHERS THEN

        RAISE LOG 'prefix.persist was not set';
        RAISE NOTICE 'prefix.persist was not set';
        PERFORM set_config('prefix.persist', 'value',false);
        RETURN ''; 
    END;

END;
$$;


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

CREATE INDEX test_idx ON test_table (test1(c1));


