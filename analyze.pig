events = LOAD 'wix/data/events.csv' USING PigStorage(',') AS
  (datetime: chararray, user_id: int, event: chararray);
premium_accounts = LOAD 'wix/data/premium.csv' USING PigStorage(',') AS
  (user_id: int, account_type: chararray);
