--Round 1 - Move 4: Ruth rolls 5
--Expected results: space_id = 9, Balance = 330, Pradyumn's balance = 415

INSERT INTO audit_log (`game_round`, `player_id`, `space_id`, `initial_credit_balance`)
VALUES
(1, 4, 9, 360);
