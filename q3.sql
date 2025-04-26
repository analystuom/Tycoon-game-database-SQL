--Round 1 - Move 3: Pradyumn rolls a 6
-- Expected results: space_id = 12, credit_balance = 465 because he rolls 6

INSERT INTO audit_log (`game_round`, `player_id`, `space_id`, `initial_credit_balance`, `did_roll_six`)
VALUES
(1, 3, 12, 465, "Yes");

--Round 1 - Move 3: Pradyumn rolls a 4, buys Sam Alex
--Expected results: space_id = 16, credit_balance = 465 - 80 = 385

INSERT INTO audit_log (`game_round`, `player_id`, `space_id`, `initial_credit_balance`)
VALUES
(1, 3, 16, 465);
