--
-- this will test if current_setting and set_setting
-- provide a way to persist settings in the same session
-- inside of a CREATE INDEX statement
-- (the function that's going to call current_setting and
--  set_setting will be the same one that's going to be used
--  to create an expression index)
--
-- the main versions to be tested here will be 9.6.2 and 9.6.8
-- but also other versions as well.


