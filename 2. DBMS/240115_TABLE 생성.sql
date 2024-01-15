-- 테이블 (Table)
-- > 표 형태로 구성된 2차원 구조로, 행과 열로 구성됨
-- > 행은 로우(row)나 레코드(record)라고 부르며
-- > 열은 컬럼(column) 또는 필드(field)라고 부름
-- > 엑셀과 유사한 형태

-- 테이블 만들기
CREATE DATABASE naver_db;

-- SQL로 테이블 만들기
DROP DATABASE IF EXISTS naver_db;
CREATE DATABASE naver_db;

-- member 테이블
USE naver_db; -- naver_db 데이터베이스를 사용하겠다
DROP TABLE IF EXISTS member; -- 기존에 member 테이블이 있다면 삭제한다

CREATE TABLE member
( mem_id		CHAR(3) NOT NULL PRIMARY KEY, -- 회원 아이디(PK)
  mem_name		VARCHAR(10) NOT NULL, -- 이름
  mem_number	TINYINT NOT NULL, -- 인원 수
  addr			CHAR(2) NOT NULL, -- 주소
  phone1		CHAR(3) NULL, -- 연락처의 국번
  phone2		CHAR(8) NULL, -- 연락처의 나머지 전화번호
  height		TINYINT UNSIGNED NULL, -- 평균 키
  debut_date	DATE NULL -- 데뷔일자
) COMMENT='member 테이블';
-- NULL : 기본값. NULL값을 허용한다
-- NOT NULL : NULL을 허용하지 않는다. 반드시 값을 넣어야 함

INSERT INTO member VALUES ('TWC', '트와이스', 9, '서울', '02', '1111111', 167, '2015-10-19');
INSERT INTO member VALUES ('BLK', '블랙핑크', 4, '경남', '055', '2222222', 163, '2016-8-8');
INSERT INTO member VALUES ('WMN', '여자친구', 6, '경기', '031', '3333333', 166, '2015-1-15');

SELECT * FROM member;

-- buy 테이블
-- AUTO_INCREMENT 열은 반드시 PRIMARY KEY 또는  UNIQUE로 지정해야함
DROP TABLE IF EXISTS buy; -- 기존에 buy 테이블이 있으면 삭제
CREATE TABLE buy
( num			INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
  mem_id		CHAR(8) NOT NULL, -- 회원 아이디(FK)
  prod_name		CHAR(6) NOT NULL, -- 제품 이름
  group_name	CHAR(4) NULL, -- 분류
  price			INT UNSIGNED NOT NULL, -- 가격
  amount		SMALLINT UNSIGNED NOT NULL, -- 수량
  FOREIGN KEY (mem_id) REFERENCES member (mem_id)
) COMMENT='buy테이블';

INSERT INTO buy(mem_id, prod_name, group_name, price, amount)
VALUES('BLK', '지갑', NULL, 30, 2);
INSERT INTO buy(mem_id, prod_name, group_name, price, amount)
VALUES('BLK', '맥북프로', '디지털', 1000, 1);
INSERT INTO buy(mem_id, prod_name, group_name, price, amount)
VALUES('APN', '아이폰', '디지털', 200, 1);
-- APN은 아직 회원 테이블에 존재하지 않아서 오류 발생
