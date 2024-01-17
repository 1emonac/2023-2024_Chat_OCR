-- 인덱스의 실제 사용

-- 인덱스 생성
CREATE [UNIQUE] INDEX 인덱스이름
	ON 테이블이름 (열이름) [ASC | DESC];
	
-- CREATE INDEX로 생성되는 보조 인덱스임
-- UNIQUE는 중복이 안되는 고유 인덱스를 생성하는 것. 생략하면 중복을 허용함
-- > UNIQUE 인덱스를 생성하려면 기존에 입력된 값들 중에 중복이 있으면 안됨
-- > 인덱스를 생성한 후에 입력되는 데이터와는 중복될 수 없음
-- -- 회원 이름은 중복이 있을 수도 있기 때문에 UNIQUE를 지정하면 안되지만, 휴대폰 번호나 이메일 등은 사람마다 모두 
-- -- 다르기 때문에 UNIQUE로 지정해도 문제 없음
-- ASC 또는 DESC는 인덱스를 오름차순 또는 내림차순으로 만들어줌
-- > 기본은 ASC로 만들어지며, 굳이 DESC로 만드는 경우는 거의 없음

-- 인덱스 제거
DROP INDEX 인덱스이름 ON 테이블이름;
-- > 기본키, 고유키로 자동 생성된 인덱스는 DROP INDEX로 제거하지 못함
-- -- 자동 생성된 인덱스는 ALTER TABLE로 기본키나 고유키를 제거하면 함꼐 제거됨

-- > 하나의 테이블에 클러스터형 인덱스와 보조 인덱스가 모두 있는 경우에는 인덱스를 제거할 때 보조인덱스부터 제거하는 것이 더 좋음
-- -- 클러스터형 인덱스가 제거되면 내부적으로 데이터가 재구성되기 때문

-- 인덱스가 많이 생성되어 있는 테이블은 사용하지 않는 인덱스를 제거해주는 것이 오히려 성등 향상에 도움이 됨

SELECT * FROM member;

SHOW INDEX FROM member;
-- 현재 member 테이블에는 mem_id 열에 클러스터형 인덱스 1개만 설정되어 있음

-- 인덱스 크기 확인
SHOW TABLE STATUS LIKE 'member'; -- LIKE 'member' : member라는 글자가 들어간 테이블의 정보 라는 의미
-- > data_length는 클러스터형 인덱스의 크기를 byte 단위로 표기한 것
-- -- 1페이지는 기본적으로 16KB인데 1KB는 1024byte 이므로 16 * 1024 = 16384
-- -- member 테이블의 인덱스는 1페이지가 할당되어 있음
-- > index_length는 보조 인덱스의 크기인데 member 테이블에는 보조 인덱스가 없기 때문에 표기하지 않음

-- addr열에 중복을 허용하는 단순 보조 인덱스 생성
CREATE INDEX idx_member_addr -- idx_테이블_열
	ON member (addr);
-- UNIQUE를 사용하면 중복을 허용하지 않음

SHOW INDEX FROM member;
-- > Non_unique 가 1로 설정되어 중복된 데이터를 허용함

-- 전체 인덱스의 크기를 다시 확인
SHOW TABLE STATUS LIKE 'member';
-- > 보조 인덱스 idx_member_addr을 생성했음에도 Index_length가 0임
-- -- 생성한 인덱스를 실제로 적용시키려면 ANALYZE TABLE 문을 먼저 실행해줘야함
ANALYZE TABLE member;
SHOW TABLE STATUS LIKE 'member';

-- mem_number에 중복을 허용하지 않는 고유 보조 인덱스 생성
CREATE UNIQUE INDEX idx_member_mem_number
	ON member (mem_unmber);
-- > mem_number는 인원 수가 중복된 값이 있기 때문에 고유 보조 인덱스를 생성할 수 없음

-- mem_name에 고유 보조 인덱스 생성
CREATE UNIQUE INDEX idx_member_mem_name
	ON member (mem_name);

SHOW INDEX FROM member;

INSERT INTO member VALUES('MOO', '마마무', 2, '태국', '001', '12341234', 155, '2020.10.10');
-- > mem_name에 고유 보조 인덱스를 생성했기 때문에 mem_name에 중복된 값을 입력할 수 없음
-- -- 실제 서비스에서 이름이 중복되어서 회원가입이 안된다면 심각한 문제가 발생할 수 있기 때문에 고유 보조 인덱스는
-- -- 업무상 절대로 중복되지 않는 열에만 생성해야함

ANALYZE TABLE member; -- 지금까지 만든 인덱스를 모두 적용
SHOW INDEX FROM member;

SELECT * FROM member;
-- > 인덱스가 생성된 열 이름이 sql문에 있지 않으면 인덱스를 사용하지 않음

SELECT mem_id, mem_name, addr FROM member;
-- > 열 이름이 SELECT 다음에 나와도 인덱스를 사용하지 않음

SELECT mem_id, mem_name, addr
FROM member
WHERE mem_name = '에이핑크';
-- > WHERE 절에 열이름이 들어있어야 인덱스를 사용함

SELECT mem_name, mem_number
FROM member
WHERE mem_number >= 7;

CREATE INDEX idx_member_mem_number
	ON member (mem_number);
ANALYZE TABLE member;

SELECT mem_name, mem_number
FROM member
WHERE mem_number >= 7;
-- > 숫자의 범위로 조회하는 것도 인덱스를 사용


-- 인덱스를 사용하지 않는 경우
-- > 인덱스가 있고 WHERE 절에 열이름이 나와도 인덱스를 사용하지 않는 경우가 있음
SELECT mem_name, mem_number
FROM member
WHERE mem_number >= 1;
-- > MYSQL이 인덱스 검색보다 전체 테이블 검색이 낫다고 판단해서 전체 테이블 검색을 수행함
-- -- 대부분의 행을 가져와야 하므로 그냥 전체 데이터를 읽는 것이 효율적인 상황

SELECT mem_name, mem_number
FROM member
WHERE mem_number * 2 >= 14;
-- > WHERE mem_number >= 7 로 조회할 때는 인덱스 검색을 했는데 지금은 전체 테이블 검색을 수행함
-- -- WHERE 절에서 열에 연산을 가하면 인덱스를 사용하지 않음 (mem_number * 2)

SELECT mem_name, mem_number
FROM member
WHERE mem_number >= 14/2;
-- > 인덱스를 사용함
-- -- WHERE 절에 나온 열에는 아무 연산을 하지 않는 것이 좋음
-- (mem_number >= 14/2 -> WHERE절에 아무 연산도 사용하지 않음)

-- 인덱스 제거 실습
SHOW INDEX FROM member;

-- > 클러스터형 인덱스와 보조 인덱스가 섞여 있을 때는 보조 인덱스를 먼저 제거하는 것이 좋음
-- > 보조 인덱스 중에는 어떤 것을 먼저 제거해도 상관없음
DROP INDEX idx_member_mem_name ON member;
DROP INDEX idx_member_addr ON member;
DROP INDEX idx_member_mem_number ON member;

-- 기본키 지정으로 자동 생성된 클러스터형 인덱스는 DROP INDEX로 제거되지 않고 ALTER TABLE로만 제거됨
ALTER TABLE member
	DROP PRIMARY KEY;
-- > mem_id 열을 buy가 참조하고 있기 때문에 에러 발생
-- -- 기본키를 제거하기 전에 외래키 관계를 먼저 제거해야함

-- 테이블에는 여러 개의 외래키가 있을 수 있기 때문에 먼저 외래키의 이름을 파악해야함
SELECT table_name, constraint_name
FROM information_schema.referential_constraints
WHERE constraint_schema = 'market_db';
-- > information_schema 데이터베이스의 referential constraints 테이블은 mysql에 포함된 시스템 데이터 베이스와 테이블
-- -- mysql 전체의 외래키 정보가 들어 있음

-- 외래키를 먼저 제거하고 기본키 제거
ALTER TABLE buy
	DROP FOREIGN KEY buy_ibfk_1;
ALTER TABLE member
	DROP PRIMARY KEY;
	

-- 인덱스를 효과적으로 사용하는 방법 정리
-- 1. 인덱스는 열 단위에 생성
-- 2. WHERE 절에서 사용되는 열에 인덱스를 생성
-- 3. WHERE 절에 사용되더라도 자주 사용될수록 인덱스의 가치가 있음
-- -- 만약 SELECT문은 1년에 한 번만 사용되고, INSERT문이 주로 사용된다면 오히려 인덱스로 인해 성능이 나빠짐
-- 4. 데이터의 중복이 많은 열은 인덱스를 만들어도 효과가 없을 수 있음
-- 5. 클러스터형 인덱스는 테이블당 하나만 생성할 수 있음
-- -- 클러스터형 인덱스는 보조 인덱스보다 성능이 더 우수함
-- -- 따라서 클러스터형 인덱스는 조회 시에 가장 많이 사용되는 열에 지정하는 것이 가장 효과적
-- 6. 사용하지 않는 인덱스는 제거
-- -- 공간확보 뿐만 아니라 데이터 입력 시에 발생하는 부하도 줄일 수 있음
