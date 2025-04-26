CREATE TABLE token (
	token_id INTEGER PRIMARY KEY AUTOINCREMENT,
	token_name TEXT NOT NULL
);

CREATE TABLE player (
	player_id INTEGER PRIMARY KEY AUTOINCREMENT,
	player_name TEXT NOT NULL,
	credit_balance INTEGER NOT NULL,
	token_id INTEGER NOT NULL,
	space_id INTEGER NOT NULL,
	is_suspended TEXT DEFAULT "No",
	FOREIGN KEY (token_id) REFERENCES token (token_id),
	FOREIGN KEY (space_id) REFERENCES space (space_id)
);


CREATE TABLE special (
	special_id INTEGER PRIMARY KEY NOT NULL,
	special_name TEXT NOT NULL,
	special_description TEXT NOT NULL,
	colour TEXT NOT NULL
);

CREATE TABLE building (
	building_id INTEGER PRIMARY KEY NOT NULL,
	building_name TEXT NOT NULL,
	tuition_fee INTEGER NOT NULL,
	price INTEGER NOT NULL,
	colour TEXT NOT NULL,
	shape TEXT NOT NULL,
	player_id INTEGER DEFAULT NULL, 
	FOREIGN KEY (player_id) REFERENCES player (player_id)
);


CREATE TABLE space (
	space_id INTEGER PRIMARY KEY NOT NULL,
	building_id INTEGER,
	special_id INTEGER,
	FOREIGN KEY (building_id) REFERENCES building (building_id),
	FOREIGN KEY (special_id) REFERENCES special (special_id)
);


CREATE TABLE audit_log (
	log_id INTEGER PRIMARY KEY  AUTOINCREMENT,
	game_round INTEGER NOT NULL,
	player_id INTEGER NOT NULL,
	space_id INTEGER NOT NULL,
	initial_credit_balance INTEGER NOT NULL,
	updated_credit_balance INTEGER,
	is_suspended TEXT NOT NULL DEFAULT "No",
	did_roll_six TEXT DEFAULT "No",
	FOREIGN KEY (player_id) REFERENCES player (player_id),
	FOREIGN KEY (space_id) REFERENCES space (space_id)
);


---------TRIGGERS----------
--Trigger when a player lands on or walks past Welcome Week
CREATE TRIGGER past_welcome_week
AFTER INSERT ON audit_log
WHEN NEW.space_id IN (1, 2, 3, 4, 5, 6, 7)
				AND (SELECT space_id FROM player WHERE player_id = NEW.player_id ) IN (15, 16, 17, 18, 19, 20)
BEGIN
	UPDATE audit_log
	SET
		updated_credit_balance = NEW.initial_credit_balance + 100
		WHERE log_id = NEW.log_id;

	UPDATE player
	SET
		credit_balance = NEW.initial_credit_balance + 100,
		space_id = NEW.space_id
	WHERE player_id = NEW.player_id;
END;

--Trigger when a player enters RAG 1
CREATE TRIGGER rag_1
AFTER INSERT ON audit_log
WHEN (SELECT special_id FROM space WHERE space_id = NEW.space_id) = 7 
				AND NEW.did_roll_six = "No"
BEGIN
	UPDATE audit_log
	SET 
		updated_credit_balance = NEW.initial_credit_balance + 15
	WHERE log_id = NEW.log_id;
	
	UPDATE player
	SET
		credit_balance = NEW.initial_credit_balance + 15,
		space_id = NEW.space_id
	WHERE player_id = NEW.player_id;
END;

--Trigger when a player enters Visitor/Suspension and he/she is not suspended
CREATE TRIGGER visitor_check
AFTER INSERT ON audit_log
WHEN (SELECT special_id FROM space WHERE space_id = NEW.space_id) = 8 
				AND (SELECT is_suspended FROM player where player_id = NEW.player_id) = "No"
				AND NEW.did_roll_six = "No"
BEGIN

	UPDATE audit_log
	SET
		updated_credit_balance = NEW.initial_credit_balance
	WHERE log_id = NEW.log_id;
	
	UPDATE player
	SET
		space_id = NEW.space_id
	WHERE player_id = NEW.player_id;
END;

--Trigger when a player buys a building which is not owned by any player
CREATE TRIGGER buying_building
AFTER INSERT ON audit_log
WHEN (SELECT building_id FROM space WHERE space_id = NEW.space_id) IS NOT NULL
				AND (SELECT player_id FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id)) IS NULL
				AND NEW.did_roll_six = "No"
BEGIN
	UPDATE audit_log
	SET 
		updated_credit_balance =  NEW.initial_credit_balance - (SELECT price FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id))
	WHERE log_id = NEW.log_id;

	UPDATE building
	SET
		player_id = NEW.player_id
	WHERE
		building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id);
	
	UPDATE player
	SET
		credit_balance = NEW.initial_credit_balance - (SELECT price FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id)),
		space_id = NEW.space_id
	WHERE player_id = NEW.player_id;
END;

--Trigger when a player enter Ali G, only their space is changed
CREATE TRIGGER ali_g
AFTER INSERT ON audit_log
WHEN (SELECT special_id FROM space WHERE space_id = NEW.space_id) = 11 AND NEW.did_roll_six = "No"
BEGIN
	UPDATE audit_log
	SET 
		updated_credit_balance = NEW.initial_credit_balance
	WHERE log_id = NEW.log_id;

	UPDATE player
	SET
		space_id = NEW.space_id
	WHERE player_id = NEW.player_id;
END;

--Trigger when a player enter "You're suspended' zone and he/she is suspended and move to Suspension/Visitor zone
CREATE TRIGGER suspension
AFTER INSERT ON audit_log
WHEN (SELECT special_id FROM space WHERE space_id = NEW.space_id) = 18
				AND NEW.did_roll_six = "No"
BEGIN
	UPDATE audit_log
	SET
		is_suspended = "Yes",
		space_id = 8
	WHERE log_id = NEW.log_id;
	
	UPDATE player
	SET
		is_suspended = "Yes",
		space_id = 8
	WHERE player_id = NEW.player_id;
END;

--Trigger when a player entering the building which he/she does not own. The player pays the Owner the amount of the tuition_fee
CREATE TRIGGER get_fined
AFTER INSERT ON audit_log
WHEN (SELECT building_id FROM space WHERE space_id = NEW.space_id) IS NOT NULL
				AND (SELECT player_id FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id)) IS NOT NULL
				AND (SELECT player_id FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id)) != NEW.player_id
				AND (SELECT COUNT(player_id)
							FROM building
							WHERE colour = (SELECT colour FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id =NEW.space_id))
							AND player_id = (SELECT player_id FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id =NEW.space_id))) < 2
				AND NEW.did_roll_six = "No"
BEGIN
	UPDATE audit_log
	SET 
		updated_credit_balance =  NEW.initial_credit_balance - (SELECT tuition_fee FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id))
	WHERE log_id = NEW.log_id;
		
	UPDATE player
	SET
		credit_balance = NEW.initial_credit_balance - (SELECT tuition_fee FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id)),
		space_id = NEW.space_id
	WHERE player_id = NEW.player_id;
	
	UPDATE player
	SET
		credit_balance = credit_balance + (SELECT tuition_fee FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id))
	WHERE player_id = (SELECT player_id FROM building WHERE building_id = (SELECT building_id from space WHERE space_id = NEW.space_id));
END;


--Trigger when a player entering the building which he/she does not own anh the owner owns all buillding with the same colour. The player pays the Owner twice the amount of the tuition_fee
CREATE TRIGGER get_fined_twice
AFTER INSERT ON audit_log
WHEN (SELECT building_id FROM space WHERE space_id = NEW.space_id) IS NOT NULL
				AND (SELECT player_id FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id)) IS NOT NULL
				AND (SELECT player_id FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id)) != NEW.player_id
				AND (SELECT COUNT(player_id)
							FROM building
							WHERE
								colour = (SELECT colour FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id))
								AND player_id = (SELECT player_id FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id))) = 2
				AND NEW.did_roll_six = "No"
BEGIN
	UPDATE audit_log
	SET 
		updated_credit_balance =  NEW.initial_credit_balance - (SELECT tuition_fee * 2 FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id))
	WHERE log_id = NEW.log_id;
		
	UPDATE player
	SET
		credit_balance = NEW.initial_credit_balance - (SELECT tuition_fee * 2 FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id)),
		space_id = NEW.space_id
	WHERE player_id = NEW.player_id;
	
	UPDATE player
	SET
		credit_balance = credit_balance + (SELECT tuition_fee * 2 FROM building WHERE building_id = (SELECT building_id FROM space WHERE space_id = NEW.space_id))
	WHERE player_id = (SELECT player_id FROM building WHERE building_id = (SELECT building_id from space WHERE space_id = NEW.space_id));
END;

--Trigger when a player rolls 6, only their space is changed while the location they lands on has no effect
CREATE TRIGGER roll_six
AFTER INSERT ON audit_log
WHEN NEW.did_roll_six = "Yes"
BEGIN
	UPDATE audit_log
	SET
		updated_credit_balance =  NEW.initial_credit_balance
	WHERE log_id = NEW.log_id;
	
	UPDATE player
	SET
		space_id = NEW.space_id
	WHERE player_id = NEW.player_id;
END;

-------ADDITIONAL TRIGGER---------

--Trigger when a player enter hearing_1
CREATE TRIGGER hearing_1
AFTER INSERT ON audit_log
WHEN (SELECT special_id FROM space WHERE space_id = NEW.space_id) = 4
				AND NEW.did_roll_six = "No"
BEGIN
		UPDATE audit_log
	SET 
		updated_credit_balance = NEW.initial_credit_balance - 20
	WHERE log_id = NEW.log_id;
	
	UPDATE player
	SET
		credit_balance = NEW.initial_credit_balance - 20,
		space_id = NEW.space_id
	WHERE player_id = NEW.player_id;
END;

--Trigger when a player enters hearing 2
CREATE TRIGGER hearing_2
AFTER INSERT ON audit_log
WHEN (SELECT special_id FROM space WHERE space_id = NEW.space_id) = 17
				AND NEW.did_roll_six = "No"
BEGIN
	UPDATE audit_log
	SET 
		updated_credit_balance = NEW.initial_credit_balance - 25
	WHERE log_id = NEW.log_id;
	
	UPDATE player
	SET
		credit_balance = NEW.initial_credit_balance - 25,
		space_id = NEW.space_id
	WHERE player_id = NEW.player_id;
END;

--Trigger when a player enters rag_2
CREATE TRIGGER rag_2
AFTER INSERT ON audit_log
WHEN (SELECT special_id FROM space WHERE space_id = NEW.space_id) = 14
				AND NEW.did_roll_six = "No"
BEGIN
	UPDATE audit_log
	SET 
		updated_credit_balance = NEW.initial_credit_balance
	WHERE log_id = NEW.log_id;
	
	UPDATE player
	SET
		credit_balance = NEW.initial_credit_balance + 10
	WHERE player_id <> NEW.player_id;
END;



