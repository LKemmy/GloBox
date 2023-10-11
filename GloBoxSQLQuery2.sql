SELECT
u.id AS user_id,
COALESCE(u.country, 'Unknown') AS country,
COALESCE(u.gender, 'Unknown') AS gender,
COALESCE(g.device, 'Unknown') AS device,
COALESCE(g.group, 'Unknown') AS test_group,
g.join_dt AS join_date,
CASE WHEN a.spent > 0 THEN true ELSE false END AS converted, COALESCE(a.spent, 0) AS total_spent,
a.dt AS activity_date,
CASE WHEN g.group = 'A' THEN COALESCE(a.spent, 0) ELSE 0 END AS total_spent_a, CASE WHEN g.group = 'B' THEN COALESCE(a.spent, 0) ELSE 0 END AS total_spent_b
FROM users u
LEFT JOIN
groups g ON u.id = g.uid
LEFT JOIN (
SELECT uid, device, SUM(spent) AS spent, MAX(dt) AS dt FROM activity
GROUP BY uid, device
) a ON u.id = a.uid;
