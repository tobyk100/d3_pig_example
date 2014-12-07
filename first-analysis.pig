fs -rmr d3pigex/output/premium_count;
fs -rmr d3pigex/output/premium_failure_count;
fs -rmr d3pigex/output/start_count_by_user;

events = LOAD 'd3pigex/events.csv' USING PigStorage(',') AS
  (datetime: chararray, user_id: int, event: chararray);
premium_accounts = LOAD 'd3pigex/premium.csv' USING PigStorage(',') AS
  (user_id: int, account_type: chararray);

-- Aggregate premium accounts for counting
premium_group = GROUP premium_accounts ALL;
premium_count = FOREACH premium_group GENERATE COUNT(premium_accounts);
-- store the result of the premium accounts count.
STORE premium_count INTO 'd3pigex/output/premium_count' USING PigStorage(',');
-- Observation: There are 284 premium accounts @DavidGinzberg

-- Get the list of failure events
-- Also selects the start events for later use
SPLIT events INTO
  failure_events IF event == 'save Failure',
  start_events IF event == 'save start';

-- join against premium accounts
premium_failures = JOIN failure_events BY user_id,
  premium_accounts BY user_id;

-- Count the failures on premium accounts
failure_group = GROUP premium_failures ALL;
premium_failure_count = FOREACH failure_group GENERATE COUNT(premium_failures);

STORE premium_failure_count INTO 'd3pigex/output/premium_failure_count' USING PigStorage(',');
-- Observation: There are no (0) premium accounts which experienced failures. @DavidGinzberg

user_start_group = GROUP start_events BY user_id;
user_start_count = FOREACH user_start_group GENERATE
  group AS user_id, COUNT(start_events) AS save_count;

user_start_count = ORDER user_start_count BY save_count ASC;
STORE user_start_count INTO 'd3pigex/output/start_count_by_user' USING PigStorage(',');
-- Observation: all users have only one start save event. @DavidGinzberg


