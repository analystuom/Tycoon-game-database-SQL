--Round 2 - Move 3: Pradyum rolls 2
--Expected results: space_id = 8,is_suspended = Yes, credit_balance = 415

INSERT INTO audit_log (`game_round`, `player_id`, `space_id`, `initial_credit_balance`)
VALUES (2, 3, 18, 415);
