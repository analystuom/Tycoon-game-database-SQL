--Round 2 - Move 1: Gareth rolls a 4 and he is fined
-- Expected_results: space_id = 7, credit_balance = 445 + 15 = 460

INSERT INTO audit_log (`game_round`, `player_id`, `space_id`, `initial_credit_balance`)
VALUES
(2, 1, 7, 445);
