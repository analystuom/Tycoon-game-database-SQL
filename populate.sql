INSERT INTO token (`token_name`)
VALUES
("Certificate"),
("Mortarboard"),
("Book"),
("Pen");

INSERT INTO special (`special_id`, `special_name`, `special_description`, `colour`)
VALUES
(1, "Welcome Week", "Awarded 100cr", "Purple"),
(4, "Hearing 1", "You are found guilty of academic malpractice. Fined 20cr",  "Purple"),
(7, "RAG 1", "You win a fancy dress competition. Awarded 15cr", "Purple"),
(8, "Visitor or Suspension", "Visitor or Suspension", "Red"),
(11, "Ali G", "Free resting", "Yellow"),
(14, "RAG 2", "You will receive a bursary and share it with your friends. Give all other players 10cr.", "Purple"),
(17, "Hearing 2", "You are in rent arrears. Fined 25cr.", "Purple"),
(18, "You are suspended", "You are suspended", "Red");

INSERT INTO building (`building_id`, `building_name`, `tuition_fee`, `price`, `colour`, `shape`)
VALUES
(2, "Kilburn", 15, 30, "Green", "Triangle"),
(3, "IT", 15, 30, "Green", "Triangle"),
(5, "Uni Place", 25, 50, "Orange", "Square"),
(6, "AMBS", 25, 50, "Orange", "Square"),
(9, "Crawford", 30, 60, "Blue", "Circle"),
(10, "Sugden", 30, 60, "Blue", "Circle"),
(12, "Shopping Precinct", 35, 70, "Brown","Diamond"),
(13, "MECD", 35, 70, "Brown", "Diamond"),
(15, "Library", 40, 80, "Grey", "Cross"),
(16, "Sam Alex", 40, 80, "Grey", "Cross"),
(19, "Museum", 50, 100, "Black", "Ring"),
(20, "Whitworth Hall", 50, 100, "Black", "Ring");

INSERT INTO space (`space_id`, `building_id`, `special_id`)
VALUES
(1, NULL, 1),
(2, 2, NULL),
(3, 3, NULL),
(4, NULL, 4),
(5, 5, NULL),
(6, 6, NULL),
(7, NULL, 7),
(8, NULL, 8),
(9, 9, NULL),
(10, 10, NULL),
(11, NULL, 11),
(12, 12, NULL),
(13, 13, NULL),
(14, NULL, 14),
(15, 15, NULL),
(16, 16, NULL),
(17, NULL, 17),
(18, NULL, 18),
(19, 19, NULL),
(20, 20, NULL);

INSERT INTO player (`player_name`, `credit_balance`, `token_id`, `space_id`)
VALUES
("Gareth", 345, 1, 19),
("Uli", 590, 2, 2),
("Pradyumn", 465, 3, 6),
("Ruth", 360, 4, 4);

UPDATE building
SET player_id = 1
WHERE building_id IN ( 3, 5, 10);

UPDATE building
SET player_id = 2
WHERE building_id IN (6, 13);

UPDATE building
SET player_id = 3
WHERE building_id IN (9, 15, 19);

UPDATE building
SET player_id = 4
WHERE building_id IN (2, 20);
