events = LOAD 'd3pigex/events.csv' USING PigStorage(',') AS
  (datetime: chararray, user_id: int, event: chararray);
premium_accounts = LOAD 'd3pigex/premium.csv' USING PigStorage(',') AS
  (user_id: int, account_type: chararray);


