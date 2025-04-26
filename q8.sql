--Round 2 - Move 4: Uli rolls 6, then 1
--Expected results: space_id = 16, credit_balance = 170, Pradyum's credit_balance = 575

--Roll 6
INSERT INTO audit_log (`game_round`, `player_id`, `space_id`, `initial_credit_balance`, `did_roll_six`)
VALUES (2, 4, 15, 330, "Yes");

-- Roll 1
INSERT INTO audit_log (`game_round`, `player_id`, `space_id`, `initial_credit_balance`)
VALUES (2, 4, 16, 330);
