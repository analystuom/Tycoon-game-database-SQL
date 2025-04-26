CREATE VIEW leaderboard AS
SELECT
	p.player_name AS name,
	CASE
		WHEN s.special_id IS NULL THEN LOWER(REPLACE(b.building_name, ' ', '_'))
		WHEN s.building_id IS NULL THEN LOWER(REPLACE(sp.special_name, ' ', '_'))
	END AS location,
	p.credit_balance AS credits,

	(SELECT GROUP_CONCAT(LOWER(REPLACE(bn.building_name, ' ', '_')), ', ')
	FROM building AS bn
	WHERE bn.player_id = p.player_id
	ORDER BY bn.building_id ASC
	) AS buildings,

	(SELECT SUM(bn.price) + p.credit_balance
	FROM building AS bn
	WHERE bn.player_id = p.player_id
	) AS net_worth

FROM player AS p
LEFT JOIN space AS s ON s.space_id = p.space_id
LEFT JOIN special AS sp ON s.special_id = sp.special_id
LEFT JOIN building AS b ON s.building_id = b.building_id

ORDER BY net_worth DESC;
