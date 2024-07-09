
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

SELECT A.prvn_name AS '도/광역시',
	A.distc_name AS '시/군/구',
	A.attrc_name AS '관광지',
	A.sumCnt '방문객 수'  
FROM 
(SELECT b.prvn_name,
	   c.distc_name,
	   d.attrc_name,
	   SUM(a.native_cnt) AS sumCnt
FROM figure a 
INNER JOIN province b ON a.prvn_cd = b.prvn_cd
INNER JOIN district c ON a.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
WHERE SUBSTRING(a.basis_date,1,4)= '2017' 
GROUP BY a.prvn_cd, a.distc_cd, a.attrc_cd) A
ORDER BY A.sumCnt DESC LIMIT 1;

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
FROM(SELECT b.prvn_name,
		     c.distc_name,
		     d.attrc_name,
	         SUM(a.native_cnt) AS sum_native_cnt
	  FROM figure a 
	  INNER JOIN province b ON a.prvn_cd = b.prvn_cd
	  INNER JOIN district c ON b.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
	  INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
	  WHERE YEAR(a.basis_date)=2017
	  AND b.prvn_name ='경기도'
	  GROUP BY a.prvn_cd, a.distc_cd, a.attrc_cd) A
	  /*ORDER BY SUM(a.native_cnt) DESC) A*/
GROUP BY A.prvn_name, A.distc_name, A.attrc_name
ORDER BY MAX(A.sum_native_cnt) DESC;

SELECT A.*
FROM 
(SELECT p.prvn_name,
       d.distc_name,
       a.attrc_name,
       SUM(f.native_cnt) sumCnt 
FROM province p 
INNER JOIN district d ON p.prvn_cd = d.prvn_cd
INNER JOIN attraction a ON p.prvn_cd = a.prvn_cd  AND d.distc_cd = a.distc_cd
INNER JOIN figure f ON p.prvn_cd = f.prvn_cd AND d.distc_cd = f.distc_cd AND a.attrc_cd = f.attrc_cd 
WHERE YEAR(f.basis_date) = 2017
GROUP BY p.prvn_name,
       d.distc_name,
       a.attrc_name) A
ORDER BY A.sumCnt DESC;

# 9. 경기도 김포시의 관광지 중 각 년도 별 평균 내국인 방문객 수가 높은 1~3위를 조회하라

WITH RankedVisits AS (
    SELECT b.prvn_name,
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
	   GROUP BY b.prvn_name, c.distc_name, d.attrc_name, YEAR(a.basis_date))
SELECT 
	prvn_name AS '도/광역시',
    distc_name AS '시/군/구',
    attrc_name AS '관광지',
    year AS '년도',
    방문객수 AS '방문객 수'
FROM RankedVisits
WHERE rn <= 3
ORDER BY year, 방문객수 DESC;

SELECT A.prvn_name,
       A.distc_name,
       A.attrc_name,
       A.year,
       A.avg
FROM (SELECT p.prvn_name,
	       d.distc_name,
	       a.attrc_name,
	       YEAR(f.basis_date) AS year,
	       ROUND(AVG(f.native_cnt)) avg,
	       ROW_NUMBER() OVER (PARTITION BY YEAR(f.basis_date) ORDER BY ROUND(AVG(f.native_cnt)) DESC) AS rn
	FROM province p 
	INNER JOIN district d ON p.prvn_cd = d.prvn_cd
	INNER JOIN attraction a ON p.prvn_cd = a.prvn_cd  AND d.distc_cd = a.distc_cd
	INNER JOIN figure f ON p.prvn_cd = f.prvn_cd AND d.distc_cd = f.distc_cd AND a.attrc_cd = f.attrc_cd 
	WHERE p.prvn_name ='경기도'
	AND d.distc_name = '김포시'
	GROUP BY p.prvn_name, d.distc_name, a.attrc_name, YEAR(f.basis_date))A
WHERE A.rn <= 3;

SELECT F.*
FROM ( SELECT (CASE @basis WHEN year THEN @rownum:=@rownum+1 ELSE @rownum:=1 END) rn,
		(@basis:= year) AS year,
		prvn_name,
		distc_name,
		attrc_name,
		avg
	FROM
	( SELECT p.prvn_name,
		       d.distc_name,
		       a.attrc_name,
		       YEAR(f.basis_date) AS year,
		       ROUND(AVG(f.native_cnt)) avg
		FROM province p 
		INNER JOIN district d ON p.prvn_cd = d.prvn_cd
		INNER JOIN attraction a ON p.prvn_cd = a.prvn_cd  AND d.distc_cd = a.distc_cd
		INNER JOIN figure f ON p.prvn_cd = f.prvn_cd AND d.distc_cd = f.distc_cd AND a.attrc_cd = f.attrc_cd 
		WHERE p.prvn_name ='경기도'
		AND d.distc_name = '김포시'
		GROUP BY p.prvn_name, d.distc_name, a.attrc_name, YEAR(f.basis_date)
		ORDER BY YEAR(f.basis_date), ROUND(AVG(f.native_cnt)) DESC) r,
		(SELECT @ROWNUM:=0, @basis:='' FROM dual) t) F
WHERE F.rn <=3;

# 10. 경기도 과천시 관광지의 각 년도 별 평균 내국인 방문객 수를 조회하라

SELECT CONCAT(b.prvn_name,' ', c.distc_name,' ', d.attrc_name) '경기도 과천시 광광지',
       YEAR(a.basis_date) AS 년도,
       ROUND(AVG(a.native_cnt)) AS 방문객수
FROM figure a 
INNER JOIN province b ON a.prvn_cd = b.prvn_cd
INNER JOIN district c ON b.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
WHERE b.prvn_name = '경기도'
AND c.distc_name = '과천시'
GROUP BY CONCAT(b.prvn_name,' ', c.distc_name,' ', d.attrc_name),YEAR(a.basis_date)
ORDER BY YEAR(a.basis_date), ROUND(AVG(a.native_cnt)) DESC;

# 11. [10]의 결과를 시계열로 표시하라.

SELECT CONCAT(A.prvn_name, ' ', A.distc_name, ' ', A.attrc_name) AS '경기도 과천시 관광지',
       MAX(CASE WHEN A.year = 2010 THEN A.avg_native_cnt ELSE 0 END) AS '2010',
       MAX(CASE WHEN A.year = 2011 THEN A.avg_native_cnt ELSE 0 END) AS '2011',
       MAX(CASE WHEN A.year = 2012 THEN A.avg_native_cnt ELSE 0 END) AS '2012',
       MAX(CASE WHEN A.year = 2013 THEN A.avg_native_cnt ELSE 0 END) AS '2013',
       MAX(CASE WHEN A.year = 2014 THEN A.avg_native_cnt ELSE 0 END) AS '2014',
       MAX(CASE WHEN A.year = 2015 THEN A.avg_native_cnt ELSE 0 END) AS '2015',
       MAX(CASE WHEN A.year = 2016 THEN A.avg_native_cnt ELSE 0 END) AS '2016',
       MAX(CASE WHEN A.year = 2017 THEN A.avg_native_cnt ELSE 0 END) AS '2017'
FROM (
    SELECT b.prvn_name,
           c.distc_name,
           d.attrc_name,
           YEAR(a.basis_date) AS year,
           ROUND(AVG(a.native_cnt)) AS avg_native_cnt
    FROM figure a
    INNER JOIN province b ON a.prvn_cd = b.prvn_cd
    INNER JOIN district c ON b.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
    INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
    WHERE b.prvn_name = '경기도'
      AND c.distc_name = '과천시'
    GROUP BY b.prvn_name, c.distc_name, d.attrc_name, YEAR(a.basis_date)
) A
GROUP BY CONCAT(A.prvn_name, ' ', A.distc_name, ' ', A.attrc_name);

SELECT  CONCAT(A.prvn_name, ' ', A.distc_name, ' ', A.attrc_name) '관광지',
		MAX(IF(A.year=2010,A.figure,0)) AS '2010',
		MAX(IF(A.year=2011,A.figure,0)) AS '2011',
		MAX(IF(A.year=2012,A.figure,0)) AS '2012',
		MAX(IF(A.year=2013,A.figure,0)) AS '2013',
		MAX(IF(A.year=2014,A.figure,0)) AS '2014',
		MAX(IF(A.year=2015,A.figure,0)) AS '2015',
		MAX(IF(A.year=2016,A.figure,0)) AS '2016',
		MAX(IF(A.year=2017,A.figure,0)) AS '2017'
FROM 
(SELECT p.prvn_name,
       d.distc_name,
       a.attrc_name,
       YEAR(f.basis_date) AS year,
       ROUND(AVG(f.native_cnt)) figure
FROM province p 
INNER JOIN district d ON p.prvn_cd = d.prvn_cd
INNER JOIN attraction a ON p.prvn_cd = a.prvn_cd  AND d.distc_cd = a.distc_cd
INNER JOIN figure f ON p.prvn_cd = f.prvn_cd AND d.distc_cd = f.distc_cd AND a.attrc_cd = f.attrc_cd 
WHERE p.prvn_name ='경기도'
AND d.distc_name = '과천시'
GROUP BY p.prvn_name, d.distc_name, a.attrc_name, YEAR(f.basis_date)) A
GROUP BY 관광지;

# 12. 2017년, 경기도 각 시/군/구의 분기별 평균 내국인 방문객 수를 시계열로 표현하라

SELECT CONCAT(A.prvn_name, ' ', A.distc_name) AS '경기도 시/군별',
       MAX(CASE WHEN A.QUART = 1 THEN A.avg_native_cnt ELSE 0 END) AS '1분기',
       MAX(CASE WHEN A.QUART = 2 THEN A.avg_native_cnt ELSE 0 END) AS '2분기',
       MAX(CASE WHEN A.QUART = 3 THEN A.avg_native_cnt ELSE 0 END) AS '3분기',
       MAX(CASE WHEN A.QUART = 4 THEN A.avg_native_cnt ELSE 0 END) AS '4분기'
FROM (
    SELECT b.prvn_name,
           c.distc_name,
           QUARTER(a.basis_date) AS QUART,
           ROUND(AVG(a.native_cnt)) AS avg_native_cnt
    FROM figure a
    INNER JOIN province b ON a.prvn_cd = b.prvn_cd
    INNER JOIN district c ON b.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
    INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
    WHERE b.prvn_name = '경기도'
    AND YEAR(a.basis_date) = '2017'
    GROUP BY b.prvn_name, c.distc_name, QUARTER(a.basis_date)
) A
GROUP BY CONCAT(A.prvn_name, ' ', A.distc_name);

SELECT A.관광지,
  		MAX(IF(A.quar=1,A.figure,0)) AS '1분기',
		MAX(IF(A.quar=2,A.figure,0)) AS '2분기',
		MAX(IF(A.quar=3,A.figure,0)) AS '3분기',
		MAX(IF(A.quar=3,A.figure,0)) AS '4분기'
FROM (
SELECT CONCAT(p.prvn_name, ' ', d.distc_name) AS '관광지',
	   QUARTER(f.basis_date) AS quar, 
       ROUND(AVG(f.native_cnt)) AS figure
FROM province p 
INNER JOIN district d ON p.prvn_cd = d.prvn_cd
INNER JOIN attraction a ON p.prvn_cd = a.prvn_cd  AND d.distc_cd = a.distc_cd
INNER JOIN figure f ON p.prvn_cd = f.prvn_cd AND d.distc_cd = f.distc_cd AND a.attrc_cd = f.attrc_cd 
WHERE YEAR(f.basis_date) = 2017
GROUP BY p.prvn_name, d.distc_name, QUARTER(f.basis_date)) A
GROUP BY A.관광지 
ORDER BY A.관광지;

# 13. 2017년, 경기도 각 관광지 별 방문객이 가장 많이 방문한 월의 방문객 수와 가장 적게 방문한 월의 방문객 수 차이를 구하라.

SELECT b.prvn_name AS '도/광역시',
	   c.distc_name AS '시/군/구',
	   d.attrc_name AS '관광지',
       MAX(a.native_cnt) - MIN(a.native_cnt) AS '월방문객 (많은수 - 적은수) 총합'
FROM figure a
INNER JOIN province b ON a.prvn_cd = b.prvn_cd
INNER JOIN district c ON b.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
WHERE b.prvn_name = '경기도'
AND YEAR(a.basis_date) = '2017'
GROUP BY b.prvn_name, c.distc_name, d.attrc_name
ORDER BY b.prvn_name, c.distc_name, d.attrc_name;

SELECT p.prvn_name,
	   d.distc_name,
	   a.attrc_name,
	   MAX(f.native_cnt) - MIN(f.native_cnt) AS subtract
FROM province p 
INNER JOIN district d ON p.prvn_cd = d.prvn_cd
INNER JOIN attraction a ON p.prvn_cd = a.prvn_cd  AND d.distc_cd = a.distc_cd
INNER JOIN figure f ON p.prvn_cd = f.prvn_cd AND d.distc_cd = f.distc_cd AND a.attrc_cd = f.attrc_cd 
WHERE YEAR(f.basis_date) = 2017
GROUP BY p.prvn_name, d.distc_name, a.attrc_name
ORDER BY p.prvn_name, d.distc_name, a.attrc_name;

# 14. 2017년, 경기도 각 관광지 별 가장 많이 방문한 월과 방문객 수, 가장 적게 방문한 월과 방문객 수를 구하라.

SELECT CONCAT(b.prvn_name, ' ', c.distc_name, ' ', d.attrc_name) AS '경기도 시/군/구별 관광지', 
       (SELECT CASE WHEN native_cnt = 0 THEN CONCAT(MAX(SUBSTRING(basis_date, 1, 6)) - 1) 
                    ELSE MAX(SUBSTRING(basis_date, 1, 6)) END
        FROM figure 
        WHERE prvn_cd = a.prvn_cd 
        AND distc_cd = a.distc_cd
        AND attrc_cd = a.attrc_cd 
        AND native_cnt = MAX(a.native_cnt) 
        AND YEAR(basis_date) = 2017) '2017년 월별 최대인원',
       MAX(a.native_cnt) '2017년 월별 최대인원',
      (SELECT CASE WHEN native_cnt = 0 THEN CONCAT(MIN(SUBSTRING(basis_date, 1, 6)) + 1)
                    ELSE MIN(SUBSTRING(basis_date, 1, 6)) END
       FROM figure 
       WHERE prvn_cd = a.prvn_cd 
       AND distc_cd = a.distc_cd
       AND attrc_cd = a.attrc_cd 
       AND native_cnt = MIN(a.native_cnt) 
       AND YEAR(basis_date) = 2017) '2017년 월별 최소인원',
       MIN(a.native_cnt) '2017년 월별 최소인원'
FROM figure a
INNER JOIN province b ON a.prvn_cd = b.prvn_cd
INNER JOIN district c ON b.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
WHERE b.prvn_name = '경기도'
AND YEAR(a.basis_date) = '2017'
GROUP BY b.prvn_name, c.distc_name, d.attrc_name, a.prvn_cd, a.distc_cd, a.attrc_cd
ORDER BY b.prvn_name, c.distc_name, d.attrc_name;

SELECT 관광지,
	   MAX(IF(rn=1,mon,0)) AS max_mon,
	   MAX(IF(rn=1,figure,0)) AS max_figure,
	   MAX(IF(rn=12,mon,0)) AS min_mon,
	   MAX(IF(rn=12,figure,0)) AS min_figure
FROM 
(SELECT (CASE @basis WHEN 관광지 THEN @rownum:=@rownum+1 ELSE @rownum:=1 END ) rn,
		@basis:=관광지 AS 관광지,
		figure,
		mon
FROM
(SELECT CONCAT(p.prvn_name, ' ', d.distc_name, ' ', a.attrc_name) AS '관광지',
	   SUBSTR(f.basis_date,1,6) AS mon,
	   f.native_cnt AS figure
FROM province p 
INNER JOIN district d ON p.prvn_cd = d.prvn_cd
INNER JOIN attraction a ON p.prvn_cd = a.prvn_cd  AND d.distc_cd = a.distc_cd
INNER JOIN figure f ON p.prvn_cd = f.prvn_cd AND d.distc_cd = f.distc_cd AND a.attrc_cd = f.attrc_cd 
WHERE YEAR(f.basis_date) = 2017
AND p.prvn_name = '경기도'
GROUP BY p.prvn_name, d.distc_name, a.attrc_name, SUBSTR(f.basis_date,1,6),f.native_cnt
ORDER BY p.prvn_name, d.distc_name, a.attrc_name, f.native_cnt DESC
LIMIT 23908239234234) F,
(SELECT @ROWNUM:=0, @basis:='' FROM dual) t
	GROUP BY 관광지,mon,figure) L
WHERE L.rn =1 OR L.rn = 12
GROUP BY 관광지; 

-- 인원이 0 인 경우 월이 제대로 가져와 지지 않는 문제, 모든 값이 0인 경우는 MON 신경 NO!

# 15. 각 도의 시/군/구를 방문한 연도별 평균 내국인 방문객 수를 시계열로 표현하라

SELECT CONCAT(A.prvn_name,' ', A.distc_name) '각 도의 시/군/구',
       MAX(CASE WHEN A.basis_date = 2010 THEN A.native_cnt ELSE 0 END) AS '2010',
       MAX(CASE WHEN A.basis_date = 2011 THEN A.native_cnt ELSE 0 END) AS '2011',
       MAX(CASE WHEN A.basis_date = 2012 THEN A.native_cnt ELSE 0 END) AS '2012',
       MAX(CASE WHEN A.basis_date = 2013 THEN A.native_cnt ELSE 0 END) AS '2013',
       MAX(CASE WHEN A.basis_date = 2014 THEN A.native_cnt ELSE 0 END) AS '2014',
       MAX(CASE WHEN A.basis_date = 2015 THEN A.native_cnt ELSE 0 END) AS '2015',
       MAX(CASE WHEN A.basis_date = 2016 THEN A.native_cnt ELSE 0 END) AS '2016',
       MAX(CASE WHEN A.basis_date = 2017 THEN A.native_cnt ELSE 0 END) AS '2017'
FROM (       
SELECT b.prvn_name,
	   c.distc_name,
	   YEAR(a.basis_date) AS basis_date,
	   ROUND(AVG(a.native_cnt))	AS native_cnt   
FROM figure a
INNER JOIN province b ON a.prvn_cd = b.prvn_cd
INNER JOIN district c ON b.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd
INNER JOIN attraction d ON a.prvn_cd = d.prvn_cd AND a.distc_cd = d.distc_cd AND a.attrc_cd = d.attrc_cd
GROUP BY b.prvn_name, c.distc_name, YEAR(a.basis_date)) A
GROUP BY A.prvn_name, A.distc_name
ORDER BY A.prvn_name, A.distc_name;

SELECT 관광지,
       MAX(IF(year=2010,figure,0)) AS '2010',
       MAX(IF(year=2011,figure,0)) AS '2011',
       MAX(IF(year=2012,figure,0)) AS '2012',
       MAX(IF(year=2013,figure,0)) AS '2013',
       MAX(IF(year=2014,figure,0)) AS '2014',
       MAX(IF(year=2015,figure,0)) AS '2015',
       MAX(IF(year=2016,figure,0)) AS '2016',
       MAX(IF(year=2017,figure,0)) AS '2017'
FROM (       
SELECT CONCAT(p.prvn_name,' ', d.distc_name) '관광지',
	   YEAR(f.basis_date) AS year,
	   ROUND(AVG(f.native_cnt)) AS figure
FROM province p 
INNER JOIN district d ON p.prvn_cd = d.prvn_cd
INNER JOIN attraction a ON p.prvn_cd = a.prvn_cd  AND d.distc_cd = a.distc_cd
INNER JOIN figure f ON p.prvn_cd = f.prvn_cd AND d.distc_cd = f.distc_cd AND a.attrc_cd = f.attrc_cd 
GROUP BY 관광지, YEAR(f.basis_date)
ORDER BY 관광지, YEAR(f.basis_date)) A
GROUP BY 관광지;

# 16. 각 도의 시/군/구를 방문한 내국인 방문객 합계를 이용해 연도별 각 도의 방문객 최대 도시, 최저 도시를 조회하라.

WITH YearVisitsCity AS (
	SELECT b.prvn_name,
		   a.prvn_cd,
		   c.distc_name,
		   a.distc_cd,  	   
		   YEAR(a.basis_date) year,	  
	  	   SUM(a.native_cnt) cnt 
	FROM figure a
	LEFT JOIN province b ON a.prvn_cd = b.prvn_cd 
	LEFT JOIN district c ON a.prvn_cd = c.prvn_cd AND a.distc_cd = c.distc_cd 
-- 	WHERE b.prvn_name LIKE '%도%'
	GROUP BY a.prvn_cd, a.distc_cd, YEAR(a.basis_date))
SELECT a.prvn_name,
	   a.year,
-- 	   MAX(a.cnt) max_cnt,
	   (SELECT distc_name
	   	FROM YearVisitsCity 
	   	WHERE prvn_name = a.prvn_name
	   	AND year = a.year
	   	AND cnt = MAX(a.cnt)) max_distNm,
-- 	   MIN(a.cnt) min_cnt,
   	   (SELECT distc_name
	   	FROM YearVisitsCity 
	   	WHERE prvn_name = a.prvn_name
	   	AND year = a.year
	   	AND cnt = MIN(a.cnt)) min_distNm
FROM YearVisitsCity a
GROUP BY a.prvn_name, a.year;

WITH maxminValue AS (
    SELECT 
        @rownum := IF(@basis = year, @rownum + 1, 1) AS rn,
        @basis := year AS year,
        prvn_name,
        distc_name,
        figure
    FROM (
        SELECT 
            p.prvn_name,
            d.distc_name,
            YEAR(f.basis_date) AS year,
            SUM(f.native_cnt) AS figure
        FROM 
            province p 
        INNER JOIN 
            district d ON p.prvn_cd = d.prvn_cd
        INNER JOIN 
            attraction a ON p.prvn_cd = a.prvn_cd AND d.distc_cd = a.distc_cd
        INNER JOIN 
            figure f ON p.prvn_cd = f.prvn_cd AND d.distc_cd = f.distc_cd AND a.attrc_cd = f.attrc_cd 
        GROUP BY 
            p.prvn_name, d.distc_name, YEAR(f.basis_date)
        ORDER BY 
            p.prvn_name, YEAR(f.basis_date), SUM(f.native_cnt) DESC
    ) F, 
    (SELECT @rownum := 0, @basis := '') t
),
ranked AS (
    SELECT 
        prvn_name,
        year,
        distc_name,
        rn,
        figure
    FROM maxminValue
)
SELECT 
    A.prvn_name,
    A.year,
    C.distc_name AS min_distc_name,
    B.distc_name AS max_distc_name
FROM (
    SELECT 
        prvn_name,
        year,
        MAX(rn) AS min_rn,
        MIN(rn) AS max_rn
    FROM ranked
    GROUP BY prvn_name, year
) A
LEFT JOIN ranked B ON A.prvn_name = B.prvn_name AND A.year = B.year AND A.min_rn = B.rn
LEFT JOIN ranked C ON A.prvn_name = C.prvn_name AND A.year = C.year AND A.max_rn = C.rn;


-- 16. 각 도의 시/군/구를 방문한 내국인 방문객 합계를 년도별 각 도의 방문객 최대 도시, 최저도시를 조회
SELECT A.prvn_name, A.year, 
       MAX(IF(A.rank = 1, A.distc_name, 0)) AS '방문객 최대',
       MAX(IF(A.rank = B.max_rank, A.distc_name, 0)) AS '방문객 최저'
  FROM (
		-- 각 년도별 도시 방문객 합계를 구한 뒤 순위를 구함. (방문객 높으면 1위, 내림차순)
		SELECT prvn_name, distc_name,
			   (CASE @year WHEN year THEN @rnum:=@rnum+1 ELSE @rnum:=1 END) AS rank,
			   (@year:=year) as year
		  FROM (
			SELECT p.prvn_name, d.distc_name, SUBSTR(f.basis_date, 1, 4) as year, ROUND(SUM(f.native_cnt)) AS figure
			  FROM province p
			  JOIN district d ON p.prvn_cd = d.prvn_cd
			  JOIN attraction a ON d.prvn_cd = a.prvn_cd AND d.distc_cd = a.distc_cd
			  JOIN figure f ON f.prvn_cd = a.prvn_cd AND f.distc_cd = a.distc_cd AND f.attrc_cd = a.attrc_cd
			WHERE 1=1
			GROUP BY p.prvn_name, d.distc_name, SUBSTR(f.basis_date, 1, 4)
			ORDER BY p.prvn_name, SUBSTR(f.basis_date, 1, 4), figure DESC, d.distc_name
		  ) A,
		  (SELECT @rnum:=0, @year:=0 FROM DUAL) B
  ) A,
  (   
		-- 각 년도별 최저 방문 순위 구하기 (즉, rank가 제일 높은 것...)
		SELECT prvn_name, year, MAX(RANK) as max_rank
		  FROM (
			SELECT prvn_name, distc_name,
				   (CASE @year WHEN year THEN @rnum:=@rnum+1 ELSE @rnum:=1 END) AS rank,
				   (@year:=year) as year
			  FROM (
				SELECT p.prvn_name, d.distc_name, SUBSTR(f.basis_date, 1, 4) as year, ROUND(SUM(f.native_cnt)) AS figure
				  FROM province p
				  JOIN district d ON p.prvn_cd = d.prvn_cd
				  JOIN attraction a ON d.prvn_cd = a.prvn_cd AND d.distc_cd = a.distc_cd
				  JOIN figure f ON f.prvn_cd = a.prvn_cd AND f.distc_cd = a.distc_cd AND f.attrc_cd = a.attrc_cd
				WHERE 1=1
				GROUP BY p.prvn_name, d.distc_name, SUBSTR(f.basis_date, 1, 4)
				ORDER BY p.prvn_name, SUBSTR(f.basis_date, 1, 4), figure DESC, d.distc_name
			) A,
			(SELECT @rnum:=0, @year:=0 FROM DUAL) B
		) A
		GROUP BY prvn_name, year
  ) B
  WHERE A.prvn_name = B.prvn_name AND A.year = B.year AND A.rank = B.Max_rank OR A.rank = 1
GROUP BY A.prvn_name, A.year;
;

```