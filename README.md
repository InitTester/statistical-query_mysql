# 📊 통계쿼리란? 
 데이터 집합에서 통계적인 정보를 추출하고 쿼리를 통해 데이터의 분포, 평균, 합계, 표준 편차, 최솟값, 최대값 등 통계적 지표를 계산하는 것, 해당 데이터를 통해서 모니터링 또는 데이터 분석으로 보고서 작성 하기에 좋다 
- 데이터를 정규화하기
- 예제를 통해 쿼리 구문

# ✍️ 학습목표
- [년도], [도/광역시], [시/군/구] 관광지의 관광객 수를 통계를 쿼리로 나타내여 작성

# 📖 테이블
- org_data : 년도, 지역별 관광객 통계 데이터 

# 📚 정규화 테이블
- province : 도/광역시 정보 테이블
- district : 시/군/구 정보 테이블
- attraction : 관광지 정보 테이블
- figure : 관광객 수 데이터 테이블

# 🔗 JOIN 구문
JOIN 하는 이유는 데이터를 하나로 통합하여 분석 및 보고서 생성, 데이터 일관성 유지에 좋다  
<img src="https://github.com/InitTester/statistical-query_mysql/assets/143479869/c27d85c9-86ed-4aa7-92b0-9dde7a0f14ff" width=300 height=300>
- INNER JOIN
- LEFT (OUTER) JOIN
- RIGHT (OUTER) JOIN
- FULL (OUTER) JOIN

# 🗃️ 집계함수(Aggregation Function), GROUP BY 구문
GROUP BY와 함께 사용 하는 이유는 데이터의 특정 그룹별로 통계적 지표를 계산하기 위해서이다.
- COUNT()
- SUM()
- AVG()
- MAX()
- MIN()

# 📆 날짜, ⏰ 시간 구문
날짜 및 시간 관련 작업을 할때 사용된다.
- NOW(), SYSDATE(), CURRENT_TIMESTAMP()
- DATE_FORAMT()
- TO_DAYS()
- LAST_DAY()
- QUARTER()
- YEAR()
  ... 등

# 🔠 문자 구문
문자관련 작업을 처리 할때 사용된다.
- CONCAT(문자열1, 문자열2, 문자열3)
- SUBSTR(문자열, 시작, n개)
- LENGTH()
- UPPPER(), LOWER()
- REPLACE()
- TRIM(), LTRIM(), RTRIM()
  ... 등

