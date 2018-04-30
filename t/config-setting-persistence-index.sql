--
-- this will test if current_setting and set_setting
-- provide a way to persist data when used in a function
-- that is used to build an expression index using CREATE INDEX
--
-- (the function that's going to call current_setting and
--  set_setting will be the same one that's going to be used
--  to create an expression index)
--
-- the main versions to be tested here are 9.6.2 and 9.6.8
-- but also other versions as well.
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


