--Round 2 - Move 2: Uli rolls a 4
-- Expected results: space_id = 11, credit balance remain the same

INSERT INTO audit_log (`game_round`, `player_id`, `space_id`, `initial_credit_balance`)
VALUES
(2, 2, 11, 605);
