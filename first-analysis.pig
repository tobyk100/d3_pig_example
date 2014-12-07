events = LOAD 'd3pigex/events.csv' USING PigStorage(',') AS
  (datetime: chararray, user_id: int, event: chararray);
premium_accounts = LOAD 'd3pigex/premium.csv' USING PigStorage(',') AS
  (user_id: int, account_type: chararray);

-- Aggregate premium accounts for counting
premium_group = GROUP premium_accounts ALL;
premium_count = FOREACH premium_group GENERATE COUNT(premium_accounts);
-- store the result of the premium accounts count.
STORE premium_count INTO 'd3pigex/output.csv' USING PigStorage(',');
