--Round 1 - Move 1: Garth rolls a 4
--Expected results: space_id = 3, updated_credit_balance = 445

INSERT INTO audit_log (`game_round`, `player_id`, `space_id`, `initial_credit_balance`)
VALUES
(1, 1, 3, 345);
