SELECT
u.id AS user_id,
u.country,
u.gender,
COALESCE(g.device, 'Unknown') AS device,
g.group AS test_group,
CASE WHEN total_spent > 0 THEN true ELSE false END AS converted, COALESCE(total_spent, 0) AS total_spent, COALESCE(group_a_total_spent, 0) AS group_a_total_spent, COALESCE(group_b_total_spent, 0) AS group_b_total_spent
FROM users u
LEFT JOIN
groups g ON u.id = g.uid
LEFT JOIN (
SELECT uid, COALESCE(SUM(spent), 0) AS total_spent FROM activity
GROUP BY uid
) a ON u.id = a.uid LEFT JOIN
(
SELECT g.uid, COALESCE(SUM(a.spent), 0) AS group_a_total_spent FROM groups g
LEFT JOIN activity a ON g.uid = a.uid
WHERE g.group = 'A'
GROUP BY g.uid
) group_a ON u.id = group_a.uid LEFT JOIN
(
SELECT g.uid, COALESCE(SUM(a.spent), 0) AS group_b_total_spent FROM groups g
LEFT JOIN activity a ON g.uid = a.uid
WHERE g.group = 'B'
GROUP BY g.uid
) group_b ON u.id = group_b.uid;
