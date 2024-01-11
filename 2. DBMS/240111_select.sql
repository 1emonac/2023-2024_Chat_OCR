-- 데이터 조회(SELECT 문)

-- USE 문
-- -- 사용할 데이터 베이스를 지정
-- -- USE(데이터베이스 이름);
USE market_db;

-- DML(Data Manipulation Language, 데이터 조작어)
-- 정의된 데이터베이스에 입력된 레코드를 조회, 수정, 삭제 하는 등의 역할을 하는 언어
-- DML의 종류
-- -- SELECT : 데이터를 조회
-- -- INSERT : 데이터를 삽입
-- -- UPDATE : 데이터를 수정
-- -- DELETE : 데이터를 삭제

-- SELECT 문의 기본 형식 
SELECT   (열 이름) -- 절
FROM     (테이블 이름) -- 절
WHERE    (조건식) -- 절
GROUP BY (열 이름) -- 절
HAVING   (조건식) -- 절
ORDER BY (열 이름) -- 절
LIMIT 	 (숫자); -- 절

-- SELECT 문은 키워드에 의해 구분되어 여러 개의 절로 구성됨

-- SELECT ~ FROM ~
SELECT * FROM member;
-- SELECT : 테이블에서 데이터를 가져올 때 사용하는 예약어
-- * : asterisk. 일반적으로 "모든 것"을 의미함. 위 예시에서는 열 이름이 들어갈 자리에 사용되어 "모든 열"을 뜻함
-- FROM : 데이터를 가져올 테이블을 지정
-- member : 조회할 테이블 이름
-- 입력이 끝나면 명령의 마지막을 나타내는 세미콜론을 넣음
-- > member테이블에서 모든 열의 내용을 가져와라

-- SELECT와 * 그리고 FROM과 테이블명 사이에는 스페이스를 넣어 구분
-- 모든 명령어를 붙여서 입력하면 에러가 발생할 수 있음

-- 값이 없는 데이터는 NULL로 표시됨(아무 것도 저장되지 않은 상태)

-- 원칙적으로는 FROM 데이터베이스.테이블 의 형식으로 표현해야 함
SELECT * FROM market_db.member;

-- 필요한 열만 가져오기
SELECT mem_name FROM member;

-- 여러 열을 가져오고 싶으면 콤마로 연결
-- > 기존 테이블의 열 순서는 관계없이 보고싶은 순서대로 열을 나열
-- 동일한 열을 중복해서 지정해도 무관
SELECT addr, debut_date, mem_name FROM member;

-- 열 이름에 별칭 지정
-- > 열 이름 다음에 지정하고 싶은 별칭 입력
-- > 별칭에 공백이 포함되어 있다면 따옴표로 묶음
SELECT addr 주소, debut_date "데뷔 일자", mem_name FROM member;

-- SELECT문에서 사칙연산을 사용하는 경우, 계산식이 열 이름에 나타나 열 이름이 너무 길고 알아보기 힘들어지는 경우
-- > 위와 같은 경우에 별칭을 주로 사용
SELECT mem_id, prod_name, price, amount, price * amount "총 구매액"
FROM buy;

-- SELECT ~ FROM ~ WHERE ~
-- > 특정 조건만 조회하기
-- > 부하 문제 때문에 실무에서는 보통 WHERE를 함께 사용하거나 LIMIT을 사용함

-- 기본적인 WHERE절 구조
SELECT (열 이름) FROM (테이블 이름) WHERE 조건식;

-- 조건식 구조
-- > (열 이름) (연산자) (값)

-- 동등비교(=)
-- > "=" 연산자를 기준으로 좌변과 우변의 항목을 비교하고 서로 같은 값이면 TRUE, 같지 않으면 FALSE를 반환
SELECT * FROM member WHERE mem_name = '블랙핑크';
-- 문자열 데이터를 비교할 때는 따옴표로 감싸서 표기

SELECT * FROm member WHERE mem_number = 4;

-- 부등비교(!=, <>)
-- 연산자의 좌변과 우변의 값이 다를 경우 TRUE, 같을 경우 FALSE
SELECT * FROm member WHERE mem_number != 4;
SELECT * FROm member WHERE mem_number <> 4;

-- 관계 연산자, 논리 연산자
-- > 숫자로 표현된 데이터라면 범위를 지정할 수 있음
SELECT mem_id, mem_name, height FROM member WHERE height <= 162;

-- where 절에서 사칙연산을 사용하는 것도 가능
SELECT mem_id, prod_name, price * amount "총 구매액"
FROM buy
WHERE price * amount >= 800;
-- 이때 SELECT절에서 지정한 별명은 WHERE절 안에서 사용할 수 없음
-- SELECT mem_id, prod_name, price * amount "총 구매액"
-- FROM buy
-- WHERE "총 구매액" * amount >= 800; -- 데이터 값이 안 나옴

-- SELECT mem_id, prod_name, price * amount 총 구매액
-- FROM buy
-- WHERE "총 구매액" * amount >= 800; -- 총 구매액(select 절)이라는 컬럼이 없다는 오류 발생

-- 논리연산자를 이요하여 여러 조건을 만족하도록 할 수 있음
SELECT mem_name, height, mem_number
FROM member
WHERE height >= 165 AND mem_number > 6;

SELECT mem_name, height, mem_number
FROM member
WHERE height >= 165 OR mem_number > 6;

-- 특정 범위에 있는 값을 구하는 경우
SELECT mem_name, mem_number, height
FROM member
-- WHERE 163 >= height <= 165; -- 파이썬에서는 가능해도, SQL에서는 안됨
WHERE height >= 163 AND height <= 165;

-- BETWEEN
SELECT mem_name, height 
FROM member
WHERE height BETWEEN 163 AND 165;

-- IN
SELECT mem_name, addr
FROM member
WHERE addr IN('경기', '전남', '경남');

-- 문자열 패턴 검색(LIKE)
-- > "=" 연산자로 비교하면 값이 완전히 동일한지를 비교
-- > 하지만 특정 문자열이 포함되어 있는지를 검색하고 싶다면 패턴 검색을 활용
SELECT *
FROM member
WHERE mem_name LIKE '우%'; -- 첫번째 글자만 검색 가능함, '%우%'면 전체에서 '우'라는 글자가 포함되어 있는 모든 문자 조회 가능
-- '%'는 임의의 문자열을 뜻하며, 빈문자열에도 매치함

-- 글자 수 매치
SELECT *
FROM member
WHERE mem_name LIKE '__핑크'; -- 글자수가 정확해야함 '_핑크', '__핑크_'면 검색이 안됨

-- NULL값 검색(IS NULL)
-- > member 테이블에서 phone1이 null인 데이터 검색
SELECT *
FROM member
WHERE phone1 = null; -- 알 수 없는 값과는 절대 일치할 수 없음

-- "=" 연산자로는 null을 검색할 수 없음
-- null값을 검색할 때는 IS NULL 연산자를 사용
SELECT *
FROM member
WHERE phone1 IS NULL;

-- NULL이 아닌 행을 검색하고 싶다면 IS NOT NULL을 사용
SELECT *
FROM member
WHERE phone1 IS NOT NULL;

-- NULL값의 연산
-- SQL에서 NULL은 0으로 처리되지 않기 때문에 NULL을 사용한 연산은 항상 NULL이 됨
SELECT NULL + 1, 1 + NULL, 1 + 2 * NULL, 1 / NULL;

-- 연산자의 우선순위
-- MYSQL에서는 AND가 OR보다 우선순위가 높음
SELECT *
FROM member
WHERE mem_number = 8 OR mem_number = 4 AND addr = '경남' OR addr = '서울';

-- 위의 코드는
SELECT *
FROM member
WHERE mem_number = 8 OR (mem_number = 4 AND addr = '경남') OR addr = '서울';
-- 과 같음

-- 일반적으로 OR 조건식은 괄호로 묶어 지정하는 경우가 많음
SELECT *
FROM member
WHERE (mem_number = 8 OR mem_number = 4) 
	AND (addr = '경남' OR addr = '서울');
	
-- 연습문제
-- 1. buy 테이블에서 amount가 4 이상인 모든 열 데이터 조회하기
SELECT * FROM buy WHERE amount >= 4;

-- 2. buy 테이블에서 prod_name이 지갑 또는 청바지에 해당하는 모든 열 데이터 조회하기
SELECT * FROM buy WHERE prod_name = '지갑' OR prod_name = '청바지';
SELECT * FROM buy WHERE prod_name IN ('지갑', '청바지');

-- ORDER BY, LIMIT, DISTINCT, GROUP BY, HAVING

-- 정렬(결과가 출력되는 순서를 조절) ORDER BY
-- > 정렬 순서를 정하지 않으면 데이터베이스 내부에 저장된 순서로 반환
SELECT mem_id, mem_name, debut_date
FROM member
ORDER BY debut_date;

-- 정렬옵션
-- > ASC : 오름차순
-- > DESC : 내림차순
-- --> 생략하면 ASC로 받아들임

SELECT mem_id, mem_name, debut_date
FROM member
ORDER BY debut_date DESC;

-- 평균키나 164이상인 회원들을 키의 내림차순으로 조회할 때
SELECT mem_id, mem_name, debut_date, height
FROM member
WHERE height >= 164
ORDER BY height DESC;

-- 문자열 자료형의 데이터 대소관계는 사전식 순서에 의해 결정
SELECT mem_id, mem_name
FROM member
ORDER BY mem_name ASC; -- 가(가장 작은 값) ~ 힣(가장 큰 값)

-- SQL에서는 명령어의 순서가 정해져 있어서 순서를 바꿀 수 없음
-- 순서를 바꿔서 사용하면 에러 발생
SELECT mem_id, mem_name, debut_date
FROM member
ORDER BY height DESC
WHERE height >= 164; -- 에러 뜸~

-- 정렬 기준을 여러 열로 지정하기
-- > 데이터 양이 많은 경우 하나의 열만으로는 행을 특정짓기 어려운 때가 많음
-- > ORDER BY로 정렬할 때 같은 값을 가진 행의 순서는 
-- > 데이터베이스 서버의 상황에 따라 어떤 행을 반환할지 결정하여 일정하지 않음
SELECT mem_id, mem_name, debut_date, height
FROM member
WHERE height >= 164
ORDER BY height DESC, debut_date ASC;

-- NULL 값의 정렬순서
-- > NULL은 대소비교를 할 수 없어서 각 DBMS마다 기준이 다르지만 가장 작은 값 또는 가장 큰 값으로 처리
-- > MYSQL에서는 가장 작은 값으로 취급
SELECT mem_id, mem_name, phone1, phone2
FROM member
ORDER BY phone1 ASC;

SELECT mem_id, mem_name, phone1, phone2
FROM member
ORDER BY phone1 DESC;

-- ORDER BY 에서는 SELECT절에서 지정한 별명을 사용할 수 있음
SELECT mem_id, prod_name, price * amount 총구매액
FROM buy
ORDER BY 총구매액 DESC;

-- 출력 개수 제한(LIMIT)
-- > LIMIT은 표준 SQL이 아니라 MYSQL과 PostgreSQL에서 사용할 수 있는 문법
-- -- > SQL Server에서는 LIMIT과 비슷한 TOP 명령어를 사용
-- -- > ORACLE에서는 ROWNUM을 WHERE 절에서 사용해 출력 개수를 제한
SELECT * FROM member LIMIT 3; -- 위에서 3개만 출력

-- 데뷔 일자가 가장 빠른 3건만 조회
SELECT *
FROM member
ORDER BY debut_date ASC
LIMIT 3;

-- > 오프셋 지정
-- > OFFSET을 통한 시작 위치 지정 기능. 기본값은 0
SELECT *
FROM member
ORDER BY debut_date ASC
LIMIT 3 OFFSET 2;

-- > OFFSET키워드를 생략하고 숫자를 나열하여 오프셋을 지정할 수 있음
-- > 이 경우에는 LIMIT(시작 위치), (데이터 개수)
SELECT *
FROM member
ORDER BY debut_date ASC
LIMIT 2, 3;

-- 중복 제거(DISTINCT)
SELECT addr
FROM member;

SELECT addr
FROM member
ORDER BY addr ASC;

SELECT DISTINCT addr
FROM member
ORDER BY addr ASC;


-- 집계 함수
-- -- > 집계함수는 인수로 집합을 지정하면 결괏값을 반환

-- 집계 함수의 종류
-- -- COUNT(집합) : 데이터 개수 세기
-- -- SUM(집합) : 합계
-- -- AVG(집합) : 평균
-- -- MIN(집합) : 최솟값
-- -- MAX(집합) : 최댓값

-- COUNT 데이터 개수 세기
-- > 전체 회원 수를 알고 싶은 경우
SELECT COUNT(*)
FROM member; -- 10

-- > 연락처가 있는 회원 수만 알고 싶은 경우
SELECT COUNT(phone1) "연락처가 있는 회원"
FROM member; -- 8

-- 집계함수에서의 DISTINCT
-- > 집계함수의 인수에 DISTINCT를 사용하면 집합에서 중복을 제거한 뒤 집계함수를 적용
SELECT COUNT(addr), COUNT(DISTINCT addr) -- 10 5
FROM member;

-- GROUP BY
-- > 그룹으로 묶어주는 역할
-- > 예) 각 회원이 구매한 물품의 총 개수를 알고 싶은 경우
SELECT mem_id, amount
FROM buy
ORDER BY mem_id;

SELECT mem_id, SUM(amount)
FROM buy
GROUP BY mem_id;

-- > 예) 각 회원이 구매한 금액의 총합을 알고 싶은 경우
SELECT mem_id "회원 아이디", SUM(price * amount) "총 구매 금액"
FROM buy
GROUP BY mem_id;

-- > 예) 한 거래 당 구매하는 물품 수 평균
SELECT AVG(amount) "평균 구매 개수"
FROM buy;

-- > 예) 각 회원이 한 거래 당 구매하는 물품 수 평균
SELECT mem_id, AVG(amount) "평균 구매 개수"
FROM buy
GROUP BY mem_id;


-- HAVING
SELECT mem_id "회원 아이디", SUM(price * amount) "총 구매 금액"
FROM buy
GROUP BY mem_id;

-- > 위 데이터에서 총 구매액이 1000이상인 회원에게만 사은품을 증정하려고 한다면
SELECT mem_id "회원 아이디", SUM(price * amount) "총 구매 금액"
FROM buy
WHERE SUM(price * amount) >= 1000
GROUP BY mem_id;
-- 집계함수는 WHERE 절에서 사용할 수 없음

SELECT mem_id "회원 아이디", SUM(price * amount) "총 구매 금액"
FROM buy
GROUP BY mem_id
HAVING SUM(price * amount) >= 1000;

-- 위 데이터에서 총 구매액이 큰 사용자부터 나타내려면
SELECT mem_id "회원 아이디", SUM(price * amount) "총 구매 금액"
FROM buy
GROUP BY mem_id
HAVING SUM(price * amount) >= 1000
ORDER BY SUM(price * amount) DESC;

-- MYSQL의 SELECT 문법 작성순서
SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY

-- MYSQL의 SELECT 문법 실행순서
FROM - WHERE - GROUP BY - HAVING - SELECT - ORDER BY - LIMIT

-- 연습문제
-- 1. member 테이블에서 회원들을 height의 오름차순으로 조회하기
SELECT *
FROM member
ORDER BY height ASC;

-- 2. member 테이블에서 5번째 회원부터 2명 조회하기
SELECT *
FROM member
LIMIT 5, 2;

-- 3. member 테이블의 phone1을 중복 없이 조회하기
SELECT DISTINCT phone1
FROM member;

-- 4. 동물 보호소에 들어온 모든 동물의 정보를 animal_id의 오름차순으로 조회하기
-- 조회할 열 : animal_id, animal_type, datetime, intake_condition, name, sex_upon_intake
SELECT animal_id, animal_type, datetime, intake_condition, name, sex_upon_intake
FROM aac_intakes
ORDER BY animal_id ASC;

-- 5. 동물 보호소에 들어온 동물 중 intake_condition이 sick인 동물의 데이터를 animal_id의 오름차순으로 조회하기
-- 조회할 열: animal_id, intake_condition, name
SELECT animal_id, intake_condition, name
FROM aac_intakes
WHERE intake_condition = 'sick'
ORDER BY animal_id ASC;

-- 6. 동물보호소에 들어온 모든 동물의 데이터를 이름의 내림차순으로 조회하는 SQL문 작성하기
-- 이름이 같은 동물 중에서는 최근에 동물 보호소에 들어온 동물을 먼저 보여주기
-- 조회할 열 : animal_id, datetime, name
SELECT animal_id, datetime, name
FROM aac_intakes
ORDER BY name DESC, datetime DESC;

-- 7. 동물 보호소에 가장 먼저 들어온 동물의 데이터 조회하기
-- 조회할 열 : name, datetime
SELECT name, datetime
FROM aac_intakes
ORDER BY datetime ASC
LIMIT 1;

-- 8. 동물 보호소에 들어온 "동물의 이름이 <총 몇 종류> 있는지" 조회하기
-- 이 때, 이름이 ""인 경우는 집계하지 않음
SELECT COUNT(DISTINCT name)
FROM aac_intakes
WHERE name != "";

-- 9. 동물 보호소에 들어온 동물 종(animal_type) 별로 각각 몇 마리인지 조회하기
-- 이 때, 고양이가 개보다 먼저 등장하도록 정렬하기
-- 조회할 열 : animal_type, cnt(마리 수)

SELECT animal_type, COUNT(*) "cnt(마리 수)" -- count(anumal_type) 보다 (*)을 넣어 전체 계산을 해 주는게 더 나음
FROM aac_intakes
GROUP BY animal_type
ORDER BY animal_type ASC;

-- MYSQL의 SELECT 문법 작성순서
SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY

-- 10. 동물 보호소에 들어온 동물 이름 중 두 번 이상 쓰인 이름과 해당 이름이 쓰인 횟수를 조회하기
-- 이 때, 이름이 ""인 동물과 이름이 "*"로 시작하는 동물은 집계에서 제외하며, 이름의 오름차순으로 조회하기
-- 조회할 열 : name, cnt(이름이 쓰인 횟수)

-- 한 번 쓰인 애들 제외 하기
SELECT name, COUNT(name) "cnt(마리 수)"
FROM aac_intakes
WHERE name != "" AND name != '*%'
GROUP BY name
HAVING COUNT(name) >= 2
ORDER BY name ASC;

