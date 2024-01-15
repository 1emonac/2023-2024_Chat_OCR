-- 제약조건
-- > 테이블을 만들 때는 테이블의 구조에 필요한 제약조건을 설정해야 함
-- > 앞에서 배운 기본키(PRIMARY KEY)와 외래키(FOREIGN KEY)가 대표적인 제약조건

-- 제약조건의 기본 개념
-- > 제약조건(CONSTRAINT)은 데이터의 무결성을 지키기 위해 제한하는 조건
-- -- > 데이터의 무결성은 데이터의 결함이 없다는 의미
-- -- -- > 예) 네이버의 회원 아이디가 중복되면 네이버의 모든 서비스 이용에 혼란이 일어남
-- -- -- > 위의 예시와 같은 결함이 없는 것을 데이터의 무결성 이라고 표현
-- -- -- > 예시 상황에서는 데이터의 무결성을 위해 회원 테이블의 아이디를 기본키로 지정할 수 있음
-- -- -- > 기본키로 설정하면 중복된 아이디를 실수로라도 입력하려고 해도 입력이 불가능

-- 제약조건의 종류
-- > PRIMARY KEY
-- > FOREIGN KEY
-- > UNIQUE
-- > CHECK
-- > DEFAULT 정의
-- > NULL 값 허용

-- 기본키
-- > 테이블의 많은 데이터 중에 데이터를 구분할 수 있는 식별자
-- > 예) 회원 아이디, 학생의 학번, 직원의 사번
-- > 기본키의 값은 중복될 수 없으며, NULL값이 입력될 수 없음

-- 대부분의 테이블은 기본키를 가져야함
-- 테이블은 기본키를 1개만 가질 수 있음
-- > 아이디, 주민등록번호, 이메일처럼 기본키로 설정할 수 있는 열이 여러 개인 경우에는 
-- > 테이블의 특성을 가장 잘 반영하는 열을 선택하는 것이 좋음

-- CREATE TABLE 에서 기본키 제약조건 설정
USE naver_db;
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member
( mem_id		CHAR(8) NOT NULL PRIMARY KEY,
  mem_name		VARCHAR(10) NOT NULL,
  height		TINYINT UNSIGNED NULL
);

DESCRIBE member;

-- CREATE TABLE 의 마지막 행에 primary key를 추가할 수도 있음
DROP TABLE IF EXISTS member;
CREATE TABLE member
( mem_id		CHAR(8) NOT NULL,
  mem_name		VARCHAR(10) NOT NULL,
  height		TINYINT UNSIGNED NULL,
  PRIMARY KEY (mem_id)
);

DESC member;

-- ALTER TABLE에서 기본키 제약조건 설정
-- 이미 만들어진 테이블을 ALTER TABLE을 통해 수정하여 기본키를 설정하는 방법
DROP TABLE IF EXISTS member;
CREATE TABLE member
( mem_id		CHAR(8) NOT NULL,
  mem_name		VARCHAR(10) NOT NULL,
  height		TINYINT UNSIGNED NULL
);
DESC member;

ALTER TABLE member -- member 테이블을 수정
	ADD CONSTRAINT -- 제약조건을 추가
	PRIMARY KEY (mem_id); -- mem_id 열에 기본키 제약조건을 설정
	
DESC member;