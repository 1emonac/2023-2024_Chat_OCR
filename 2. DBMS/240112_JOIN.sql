-- 조인
-- 두 개의 테이블을 서로 묶어서 하나의 결과를 만들어 내는 것
-- 예) 인터넷 마켓 데이터베이스의 회원 테이블과 구매 테이블
-- > 회원 테이블에는 회원의 이름, 연락처
-- > 구매 테이블에는 구매한 물건에 대한 정보

-- 관계형 db에서 데이터는 주제에 따라 분리해서 저장하고 있고 이 분리된 테이블은 서로 관계를 맺고 있음

-- 테이블의 조인을 위해서는 테이블이 일대다 관계로 연결되어야 함
-- > 일대다 관계 : 회원 테이블의 아이디에는 하나의 값이 한 번 만 등장해야하지만 다른 테이블에서는 여러 개의 값이 존재할 수 있는 관계
-- -- > 예) 회원테이블에서 회원아이디는 한 번 만 등장하지만, 구매 테이블에서는 한 아이디를 여러 번 찾을 수 있음
-- -- > 이때, 회원 테이블의 아이디를 기본키(Primary Key), 구매 테이블의 아이디를 외래키(Foreign Key)로 지정

-- 기본키 : 테이블에서 유일한 값으로, 각 행의 데이터를 유일하게 확인할 수 있는 값
-- 외래키 : 두 테이블을 서로 연결하는데 사용하는 키.
-- -- 외래키가 포함된 테이블을 자식 테이블, 외래키 값을 제공하는 테이블을 부모 테이블이라 함

-- 내부조인
-- > 결합 조건을 만족하는 데이터만 선택해 결합하는 것
-- > 조인 중에서 가장 많이 사용되는 조인

-- 내부조인의 형식
SELECT 열목록
FROM 첫 번째 테이블
	INNER JOIN 두 번째 테이블
	ON 조인될 조건
WHERE 검색조건;

-- 구매 테이블에서 GRL이라는 아이디를 가진 사람이 구매한 물건을 발송하기 위해서 구매자 이름과 주소, 연락처를 알아야한다면
SELECT *
FROM buy
	INNER JOIN member
	ON buy.mem_id = member.mem_id
WHERE buy.mem_id = 'GRL';

-- WHERE 조건절을 생략한다면
SELECT *
FROM buy
	INNER JOIN member
	ON buy.mem_id = member.mem_id;
	
-- 필요한 정보만 추출하기
SELECT mem_id, mem_name, prod_name, addr, concat(phone1, phone2) 연락처
FROM buy
	INNER JOIN member
	ON buy.mem_id = member.mem_id;
-- mem_id가 양쪽 테이블에 다 존재해서 에러

SELECT buy.mem_id, mem_name, prod_name, addr, concat(phone1, phone2) 연락처
FROM buy
	INNER JOIN member
	ON buy.mem_id = member.mem_id;
-- SQL문을 더 명확하게 하기 위해서 테이블이름.열이름 형식으로 작성하는 것이 좋음

SELECT buy.mem_id, member.mem_name, buy.prod_name, member.addr, 
concat(member.phone1, member.phone2) 연락처
FROM buy
	INNER JOIN member
	ON buy.mem_id = member.mem_id;

-- 코드가 너무 길어지는 문제를 별칭으로 해결
SELECT b.mem_id, m.mem_name, b.prod_name, m.addr, concat(m.phone1, m.phone2) 연락처
FROM buy b
	INNER JOIN member m
	ON b.mem_id = m.mem_id;

-- 결과를 회원 아이디순으로 정렬
SELECT b.mem_id, m.mem_name, b.prod_name, m.addr, concat(m.phone1, m.phone2) 연락처
FROM buy b
	INNER JOIN member m
	ON b.mem_id = m.mem_id
ORDER BY m.mem_id ASC;
-- 현재는 구매한 기록이 있는 회원들의 목록임
-- > 내부 조인 : 두 테이블에 모두 있는 내용만 조인되는 방식
-- > 외부 조인 : 양쪽 중 한 곳이라도 내용이 있을 때 조인

-- 외부 조인의 형식
SELECT 열 목록 
FROM 첫번째테이블(LEFT)
	<LEFT|RIGHT> OUTER JOIN 두번째테이블(RIGHT)
	ON 조인될 조건
WHERE 검색조건;

-- 구매 기록이 없는 회원을 포함한 전체 회원의 구매 기록 출력
SELECT m.mem_id, m.mem_name, b.prod_name, m.addr
FROM member m
	LEFT OUTER JOIN buy b
	ON m.mem_id = b.mem_id
ORDER BY m.mem_id ASC;

-- 회원가입만 하고 한 번도 구매한 적이 없는 회원의 목록 추출
SELECT DISTINCT m.mem_id, b.prod_name, m.mem_name, m.addr
FROM member m
	LEFT OUTER JOIN buy b
	ON m.mem_id = b.mem_id
WHERE b.prod_name IS NULL
ORDER BY m.mem_id ASC;

-- 상호조인(cross join)
-- > 한 쪽 테이블의 모든 행과 다른 쪽 테이블의 모든 행을 조인
-- > 상호 조인 결과의 전체 행 수는 두 테이블의 각 행 수의 곱
SELECT * 
FROM buy
	CROSS JOIN member;

-- 자체조인(self join)
-- > 자신이 자신과 조인
-- > 테이블은 1개만 사용
-- > 예) 회사의 조직 관계

CREATE TABLE emp_table (emp CHAR(4), manager CHAR(4), phone VARCHAR(8));

INSERT INTO emp_table VALUES('대표', NULL, '0000');
INSERT INTO emp_table VALUES('영업이사', '대표', '1111');
INSERT INTO emp_table VALUES('관리이사', '대표', '2222');
INSERT INTO emp_table VALUES('정보이사', '대표', '3333');
INSERT INTO emp_table VALUES('영업과장', '영업이사', '1111-1');
INSERT INTO emp_table VALUES('경리부장', '관리이사', '2222-1');
INSERT INTO emp_table VALUES('인사부장', '관리이사', '2222-2');
INSERT INTO emp_table VALUES('개발팀장', '정보이사', '3333-1');
INSERT INTO emp_table VALUES('개발주임', '정보이사', '3333-1-1');

-- 자체 조인의 기본 형식
SELECT 열목록
FROM 테이블 별칭A
	INNER JOIN 테이블 별칭B
	ON 조인될 조건
WHERE 검색조건;

-- 경리부장의 직속 상관 연락처를 알고 싶다면
SELECT a.emp 직원, b.emp 직속상관, b.phone 직속상관연락처
FROM emp_table a
	INNER JOIN emp_table b
	ON a.manager = b.emp
WHERE a.emp = '경리부장';

SELECT * FROM emp_table;

-- 연습문제
-- 1. 한 번이라도 구매 기록이 있는 회원들 리스트 출력하기
-- 중복없이 회원id, 주소를 조회
SELECT DISTINCT m.mem_id, m.addr
FROM member m
	LEFT OUTER JOIN buy b
	ON m.mem_id = b.mem_id
WHERE b.prod_name IS NOT NULL;

SELECT DISTINCT m.mem_id, m.addr
FROM buy b
	INNER JOIN member m
	ON m.mem_id = b.mem_id

-- 2번 문제 데이터 준비
CREATE TABLE aac_outcomes (
age_upon_outcome varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
animal_id char(7) COLLATE utf8mb4_general_ci NOT NULL,
animal_type varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
breed varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
color varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
date_of_birth datetime NOT NULL,
datetime datetime NOT NULL,
monthyear varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
name varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
outcome_subtype varchar(25) COLLATE utf8mb4_general_ci NOT NULL,
outcome_type varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
sex_upon_outcome varchar(20) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. 천재지변으로 인해 데이터가 유실되었음. 
-- 입양을 간(=outcomes) 기록은 있는데, // 보호소에 들어온 기록(intakes)이 (WHERE)없는 동물의 
-- (ON?)id의 이름을 (ORDER BY)id의 오름차순으로 조회하기
-- 조회할 열 : animal_id, name, outcomes의 datetime, intake의 datetime
SELECT ao.animal_id, ao.name, ao.datetime outcome_datetime, ai.datetime intake_datetime
FROM aac_outcomes ao 
	LEFT OUTER JOIN aac_intakes ai 
	ON ao.animal_id = ai.animal_id
WHERE ai.datetime IS NULL
ORDER BY ao.animal_id ASC;

-- 3. 관리자의 실수로 일부 동물이 나간 날짜가 잘못 입력되었음.
-- 보호시작일보다 나간 날짜가 더 빠른 동물의 아이디와 이름을 조회하는 SQL문 작성하기
-- 단, 보호시작일이 빠른 순으로 조회해야함
-- 조회할 열 : animal_id, name, outcomes의 datetime, intakes의 datertime
SELECT ao.animal_id, ao.name, ao.datetime out_datetime, ai.datetime in_datetime
FROM aac_outcomes ao
	INNER JOIN aac_intakes ai
	ON ai.animal_id  = ao.animal_id
WHERE ao.datetime <= ai.datetime
ORDER BY ai.datetime ASC
