fs -rmr d3pigex/output/premium_count;
fs -rmr d3pigex/output/premium_failure_count;

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
SPLIT events INTO
  failure_events IF event == 'save Failure',
  other_events OTHERWISE; -- Add a filter for start save events

-- join against premium accounts
premium_failures = JOIN failure_events BY user_id,
  premium_accounts BY user_id;

-- Count the failures on premium accounts
failure_group = GROUP premium_failures ALL;
premium_failure_count = FOREACH failure_group GENERATE COUNT(premium_failures);

STORE premium_failure_count INTO 'd3pigex/output/premium_failure_count' USING PigStorage(',');
-- Observation: There are no (0) premium accounts which experienced failures. @DavidGinzberg

