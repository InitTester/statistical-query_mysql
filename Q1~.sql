
# 1. 각 [도/관역시]별 [시/군/구]의 개수를 조회하라

SELECT a.prvn_name AS '도/광역시',
       COUNT(b.distc_cd) AS '시/군/구'
FROM province a
INNER JOIN district b ON a.prvn_cd = b.prvn_cd
GROUP BY a.prvn_cd;

# 2. 각 [도/광역시]의 [시/군/구]별 관광지 개수를 조회

SELECT a.prvn_cd,
       a.prvn_name AS '도/광역시',
       b.distc_cd,
       b.distc_name AS '시/군/구',
       COUNT(c.attrc_cd) AS '관광지 개수'
FROM province a
INNER JOIN district b ON a.prvn_cd = b.prvn_cd 
INNER JOIN attraction c ON a.prvn_cd = c.prvn_cd AND b.distc_cd = c.distc_cd
GROUP BY a.prvn_cd , b.distc_cd ;

# 3. 경기도 수원시의 2017년 1분기 내국인 방문자 평균을 조회

SELECT a.prvn_name AS '도/광역시',
       b.distc_name AS '시/군/구',
       ROUND(AVG(c.native_cnt)) AS '2017년 1분기 내국인 방문자 평균'
FROM province a
INNER JOIN district b ON a.prvn_cd = b.prvn_cd 
INNER JOIN figure c ON a.prvn_cd = c.prvn_cd AND b.distc_cd = c.distc_cd
WHERE b.distc_name ='수원시'
AND c.basis_date BETWEEN '20170101' AND LAST_DAY(20170301);

#-- 2017년, 경기도 수원시의 관광지 별 평균 내국인 방문객 수

# 4. 경기도 수원시의 2017년 하반기 내국인 방문자 합계를 조회

SELECT a.prvn_name AS '도/광역시',
       b.distc_name AS '시/군/구',
       SUM(c.native_cnt) AS '2017년 하반기 내국인 방문자 합계'
FROM province a
INNER JOIN district b ON a.prvn_cd = b.prvn_cd 
INNER JOIN figure c ON a.prvn_cd = c.prvn_cd AND b.distc_cd = c.distc_cd
WHERE b.distc_name ='수원시'
AND c.basis_date BETWEEN '20170701' AND LAST_DAY(20171201);

# 5. 2017년, 경기도 수원시의 관광지 중 평균 내국인 방문객 수가 가장 많은 관광지 3개와 그 방문자 수를 조회

SELECT b.prvn_name AS '도/광역시',
	   c.distc_name AS '시/군/구',
	   d.attrc_name AS '관광지',
	   ROUND(AVG(a.native_cnt)) AS '평균 방문자수' 
FROM figure a 
INNER JOIN province b ON a.prvn_cd = b.prvn_cd
INNER JOIN district c ON a.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
WHERE c.distc_name ='수원시'
AND SUBSTRING(a.basis_date,1,4)= '2017' 
GROUP BY a.prvn_cd, a.distc_cd, a.attrc_cd 
ORDER BY ROUND(AVG(a.native_cnt)) DESC LIMIT 3;

# 6. 2017년, 경기도 관광지 중 내국인 방문객 수가 가장 많은 관광지명과 관광지가 속한 도시명, 방문객 수 조회

SELECT b.prvn_name AS '도/광역시',
	   c.distc_name AS '시/군/구',
	   d.attrc_name AS '관광지',
	   SUM(a.native_cnt) AS '방문객 수' 
FROM figure a 
INNER JOIN province b ON a.prvn_cd = b.prvn_cd
INNER JOIN district c ON a.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
WHERE SUBSTRING(a.basis_date,1,4)= '2017' 
GROUP BY a.prvn_cd, a.distc_cd, a.attrc_cd
ORDER BY SUM(a.native_cnt) DESC LIMIT 1;

SELECT A.prvn_name AS '도/광역시',
	   A.distc_name AS '시/군/구',
	   A.attrc_name AS '관광지',
	   MAX(sum_native_cnt) AS '방문객 수'
FROM (SELECT b.prvn_name,
		     c.distc_name,
		     d.attrc_name,
		     SUM(a.native_cnt) AS sum_native_cnt
	  FROM figure a 
	  INNER JOIN province b ON a.prvn_cd = b.prvn_cd
	  INNER JOIN district c ON a.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
	  INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
	  WHERE SUBSTRING(a.basis_date,1,4)= '2017' 
	  GROUP BY a.prvn_cd, a.distc_cd, a.attrc_cd
	  ORDER BY SUM(a.native_cnt) DESC) A;

# 7. 2017년, 경기도에 속한 도시의 관광지별 내국인 방문객 수 합계를 각 도시 코드 별 오름차순 후 합계를 내림차순하여 조회

SELECT b.prvn_name AS '도/광역시',
	   c.distc_name AS '시/군/구',
	   d.attrc_name AS '관광지',
	   SUM(a.native_cnt) AS '방문객 수' 
FROM figure a 
INNER JOIN province b ON a.prvn_cd = b.prvn_cd
INNER JOIN district c ON a.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
WHERE YEAR(a.basis_date) =2017
GROUP BY a.prvn_cd, a.distc_cd, a.attrc_cd
ORDER BY b.prvn_cd, c.distc_cd, SUM(a.native_cnt) DESC;

# 8. 2017년, 경기도에 속한 도시의 관광지 중 내국인 방문객 수가 가장 많은 관광지와 방문객 수를 조회

SELECT A.prvn_name AS '도/광역시',
	   A.distc_name AS '시/군/구',
	   A.attrc_name AS '관광지',
	   MAX(A.sum_native_cnt) AS '방문객 수'
FROM( SELECT b.prvn_name,
		     c.distc_name,
		     d.attrc_name,
	         SUM(a.native_cnt) AS sum_native_cnt
	  FROM figure a 
	  INNER JOIN province b ON a.prvn_cd = b.prvn_cd
	  INNER JOIN district c ON b.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
	  INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
	  WHERE YEAR(a.basis_date)=2017
	  AND b.prvn_name ='경기도'
	  GROUP BY a.prvn_cd, a.distc_cd, a.attrc_cd
	  ORDER BY SUM(a.native_cnt) DESC) A
GROUP BY A.prvn_name, A.distc_name
ORDER BY MAX(A.sum_native_cnt) DESC;

# 9. 경기도 김포시의 관광지 중 각 년도 별 평균 내국인 방문객 수가 높은 1~3위를 조회하라

WITH RankedVisits AS (
    SELECT 
        b.prvn_name,
        c.distc_name,
        d.attrc_name,
        YEAR(a.basis_date) AS year,
        ROUND(AVG(a.native_cnt)) AS 방문객수,
        ROW_NUMBER() OVER (PARTITION BY YEAR(a.basis_date) ORDER BY SUM(a.native_cnt) DESC) AS rn
    FROM figure a 
    INNER JOIN province b ON a.prvn_cd = b.prvn_cd
    INNER JOIN district c ON b.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
    INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
    WHERE b.prvn_name = '경기도'
    AND c.distc_name = '김포시'
    GROUP BY b.prvn_name, c.distc_name, d.attrc_name, YEAR(a.basis_date)
)
SELECT
    prvn_name AS '도/광역시',
    distc_name AS '시/군/구',
    attrc_name AS '관광지',
    year AS '년도',
    방문객수 AS '방문객 수'
FROM RankedVisits
WHERE rn <= 3
ORDER BY year, 방문객수 DESC;

# 10. 경기도 과천시 관광지의 각 년도 별 평균 내국인 방문객 수를 조회하라









SELECT * FROM province;

SELECT * FROM district;

SELECT * FROM attraction;

SELECT * FROM figure;

SELECT * FROM org_data;


