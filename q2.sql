--Round 1 - Move 2: Uli rolls a 5
--Expected results: space_id = 7, credit_balance = 590 + 15 = 605

INSERT INTO audit_log (`game_round`, `player_id`, `space_id`, `initial_credit_balance`)
VALUES
(1, 2, 7, 590);
