-- This is a MySQL database
DROP TABLE IF EXISTS day2;
CREATE OR REPLACE TABLE day2 (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    line VARCHAR(20) NOT NULL
)

CREATE OR REPLACE VIEW V_MVT AS (SELECT id, IF(dir = 'forward', amt, 0) AS fwd, IF(dir = 'up', -amt, IF(dir = 'down', amt, 0)) AS dpt
FROM (
    SELECT c.id, SUBSTRING_INDEX(c.line, ' ', 1) AS dir, SUBSTRING_INDEX(c.line, ' ', -1) AS amt FROM day2 c
) AS d);

-- part 1
SELECT SUM(fwd) * SUM(dpt) AS result_part1 FROM V_MVT;

-- part2
SELECT SUM(fwd) * SUM(fwd * aim) AS result_part2 FROM (
    SELECT id, fwd, dpt, IFNULL((SELECT SUM(dpt) FROM V_MVT WHERE id <= d.id), 0) AS aim FROM V_MVT d
) AS solver;