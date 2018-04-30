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


CREATE OR REPLACE FUNCTION public.isempty(p_string character varying) RETURNS boolean
LANGUAGE sql IMMUTABLE
AS $$
SELECT input IS NULL OR input = '';
$$



CREATE OR REPLACE FUNCTION public.test1(p_string character varying) RETURNS character varying
LANGUAGE plpgsql IMMUTABLE
AS $$

persist TEXT;
DECLARE

BEGIN

    BEGIN
        SELECT current_setting('prefix.persist') INTO STRICT persist;
        IF isempty('persist')
            RAISE EXCEPTION 'persist session variable not set';
        END IF;
    EXCEPTION
        PERFORM set_config('prefix.persist', 'value',false);
    END;

END;
$$;


