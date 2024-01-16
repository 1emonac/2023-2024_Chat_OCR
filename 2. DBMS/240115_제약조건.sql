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

-- 외래 키 제약조건
-- > 외래키(FOREIGN KEY) : 두 테이블 사이의 관계를 연결해주고, 그 결과 데이터의 무결성을 보장
-- > 외래키가 설정된 열은 다른 테이블의 기본키와 연결됨 
-- -- > member 테이블과 buy 테이블이 기본 키 - 외래키 관계
-- -- -- > 이 경우 기본키가 있는 member 테이블을 기준 테이블이라고 하며, buy테이블을 참조테이블이라고 함
-- -- -- > 구매 테이블의 FK는 반드시 회원테이블의 PK로 존재함
-- -- -- -- > 예) 네이버 쇼핑에서 제품을 구매한 기록이 있는 사람은 네이버 쇼핑의 회원이어야 함

-- 외래키를 사용하면 구매한 기록은 있지만 구매한 사람이 누구인지 알 수 없는 상황은 발생하지 않음
-- > 따라서 구매 테이블의 모든 데이터는 누가 구매했는지 확실하게 알 수 있는 무결한 데이터가 됨

-- CREATE TABLE에서 외래키 제약조건 설정
-- 기본 형식 : FOREIGN KEY(열 이름) REFERENCES 기준테이블(열 이름)
-- > BUY 테이블의 열(mem_id)이 참조(REFERENCES) 하는 기준 테이블(member)의 열(mem_id)
-- > 기준 테이블의 열이 PRIMARY KEY 또는 UNIQUE가 아니라면 외래키 관계는 설정되지 않음

DROP TABLE IF EXISTS buy;
CREATE TABLE buy
( num			INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  mem_id		CHAR(8) NOT NULL,
  prod_name		CHAR(6) NOT NULL,
  FOREIGN KEY(mem_id) REFERENCES member(mem_id)
);
DESC buy;

-- ALTER TABLE에서 외래키 제약조건 설정
DROP TABLE IF EXISTS buy;
CREATE TABLE buy
( num			INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  mem_id		CHAR(8) NOT NULL,
  prod_name		CHAR(6) NOT NULL
);
ALTER TABLE buy -- buy 테이블을 수정
	ADD CONSTRAINT -- 제약조건을 추가
	FOREIGN KEY(mem_id) -- 외래키 제약조건을 buy 테이블의 mem_id에 설정
	REFERENCES member(mem_id); -- 참조할 기준 테이블은 member 테이블의 mem_id 열
	
-- 기준 테이블의 열이 변결될 경우
INSERT INTO member VALUES ('BLK', '블랙핑크', 163);
INSERT INTO buy (mem_id, prod_name) VALUES ('BLK', '지갑');
INSERT INTO buy (mem_id, prod_name) VALUES ('BLK', '맥북');

-- -- 내부조인을 사용해서 물품 정보 및 사용자 정보를 확인
SELECT m.mem_id, m.mem_name, b.prod_name
FROM buy b
	INNER JOIN member m
	ON b.mem_id = m.mem_id;

-- -- BLK의 아이디를 PNK로 변경
UPDATE member SET mem_id = 'PNK' WHERE mem_id = 'BLK';
-- -- 기본키 - 외래키로 맺어진 후에는 기준 테이블의 열 이름이 변경되지 않음
-- -- 열 이름이 변경되면 참조 테이블의 데이터에 문제가 발생하기 때문에
-- -- -- 지금은 회원 테이블의 BLK가 물건을 구매한 구매 기록이 테이블에 존재하기 때문에 변경 불가한 것
-- -- -- 만약 BLK가 물건을 구매한 적이 없다면 (구매 테이블에 데이터가 없다면) 회원 테이블의 BLK는 변경 가능

-- -- BLK를 삭제
DELETE FROM member WHERE mem_id = 'BLK';

-- 기본키-외래키 관계가 설정되면 기준 테이블의 열은 변경되거나 삭제되지 않음
-- > 하지만 기준 테이블의 열 이름이 변경될 때 참조 테이블의 열 이름이 자동으로 함께 변경된다면 더 효율적일 것 임
-- > 즉, 회원 테이블의 BLK가 PNK로 변경되면 자동으로 구매 테이블의 BLK도 PNK로 변경되는 것

-- 위와 같은 기능을 위해 ON UPDATE CASCADE와 ON DELETE CASCADE를 사용할 수 있음
-- > 기준 테이블의 데이터가 수정되거나 삭제되면 참조 테이블의 데이터도 함께 변경되는 기능

DROP TABLE IF EXISTS buy;
CREATE TABLE buy
( num			INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  mem_id		CHAR(8) NOT NULL,
  prod_name		CHAR(6) NOT NULL
);
ALTER TABLE buy
	ADD CONSTRAINT
	FOREIGN KEY(mem_id)
	REFERENCES member(mem_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE;

INSERT INTO buy (mem_id, prod_name) VALUES ('BLK', '지갑');
INSERT INTO buy (mem_id, prod_name) VALUES ('BLK', '맥북');

-- 내부조인
SELECT m.mem_id, m.mem_name, b.prod_name
FROM buy b
	INNER JOIN member m
	ON b.mem_id = m.mem_id;
	
-- -- member 테이블의 BLK를 PNK로 변경
UPDATE member SET mem_id = 'PNK' WHERE mem_id = 'BLK';

-- 내부조인
SELECT m.mem_id, m.mem_name, b.prod_name
FROM buy b
	INNER JOIN member m
	ON b.mem_id = m.mem_id;
	
-- -- PNK를 기준 테이블에서 삭제
DELETE FROM member WHERE mem_id = 'PNK';

-- -- 구매 테이블을 확인하면 PNK의 데이터가 함께 삭제되었음
SELECT * FROM buy;


-- 기타 제약 조건
-- -- 고유키 제약조건
-- -- > 고유키(UNIQUE) 제약조건 : 중복되지 않는 유일한 값을 입력해야하는 조건
-- -- > 기본키 제약 조건과 거의 비슷하지만 고유키 제약조건은 NULL값을 허용한다는 것이 차이점
-- -- -- NULL값은 여러 개가 입력되어도 상관없음
-- -- > 또 다른 차이점은 기본키는 테이블에 1개만 설정할 수 있지만 고유키는 여러 개를 설정할 수 있음
-- -- -- 예) 회원 테이블에 email 주소가 있다면 중복되지 않으므로 고유키로 설정할 수 있음
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member
( mem_id		CHAR(8) NOT NULL PRIMARY KEY,
  mem_name		VARCHAR(10) NOT NULL,
  height		TINYINT UNSIGNED NULL,
  email			CHAR(30) NULL UNIQUE
);

-- 중복된 데이터 입력
INSERT INTO member VALUES('BLK', '블랙핑크', 163, 'pink@gmail.com');
INSERT INTO member VALUES('TWC', '트와이스', 167, NULL); 
INSERT INTO member VALUES('APN', '에이핑크', 164, 'pink@gmail.com'); -- 이메일이 중복되기 때문에 오류 발생

-- 체크 제약 조건
-- > 체크(CHECK) 제약 조건 : 입력되는 데이터를 점검하는 기능
-- -- 예) height에 마이너스 값이 입력되지 않도록 하거나, 연락처의 국번에 02, 031, 041, 055 중 하나만 입력되도록 함

-- height는 반드시 100 이상의 값만 입력되도록 체크 제약조건을 설정하는 예시
DROP TABLE IF EXISTS member;
CREATE TABLE member
( mem_id		CHAR(8) NOT NULL PRIMARY KEY,
  mem_name		VARCHAR(10) NOT NULL,
  height		TINYINT UNSIGNED NULL CHECK(height >= 100),
  phone1		CHAR(3) NULL
);
-- 열 정의 뒤에 CHECK(조건)을 추가하면 됨

-- 데이터 입력
INSERT INTO member VALUES('BLK', '블랙핑크', 163, NULL);
INSERT INTO member VALUES('TWC', '트와이스', 99, NULL);

-- -- 테이블을 만든 후에 ALTER TABLE로 체크 제약조건을 추가하는 것도 가능
ALTER TABLE member
	ADD CONSTRAINT
	CHECK(phone1 IN ('02', '031', '032', '054', '055', '061'));
	
-- 데이터 입력
INSERT INTO member VALUES('TWC', '트와이스', 167, '02');
INSERT INTO member VALUES('OMY', '오마이걸', 167, '010'); -- 010은 컬럼에 없기 때문에 오류 남
INSERT INTO member VALUES('OMY', '오마이걸', 167, NULL);


-- 기본값 정의
-- > 기본값(DEFAULT) 정의 : 값을 입력하지 않았을 때 자동으로 입력될 값을 미리 지정하는 방법
-- -- 예) height를 입력하지 않고 기본적으로 160이라고 입력되도록 하고 싶다면
DROP TABLE IF EXISTS member;
CREATE TABLE member
( mem_id		CHAR(8) NOT NULL PRIMARY KEY,
  mem_name		VARCHAR(10) NOT NULL,
  height		TINYINT UNSIGNED NULL DEFAULT 160,
  phone1		CHAR(3) NULL
);

-- ALTER TABLE로 DEFAULT를 지정하기 위해서는 ALTER COLMN을 사용
-- > 예) 연락처의 국번을 입력하지 않으면 자동으로 02가 입력되도록 하려면
ALTER TABLE member
	ALTER COLUMN phone1 SET DEFAULT '02';

-- -- 기본값이 설정된 열에 기본값을 입력하려면 DEFAULT 라고 입력
INSERT INTO member VALUES('RED', '레드벨벳', 161, '054');
INSERT INTO member VALUES('SPC', '우주소녀', DEFAULT, DEFAULT);
INSERT INTO member VALUES('BLK', '블랙핑크', NULL, NULL);
INSERT INTO member(mem_id, mem_name) VALUES ('APN', '에이핑크');

SELECT * FROM member;


-- NULL 값 허용
-- > NULL 값을 허용하려면 생략하거나 NULL을 입력하고, 허용하지 않으려면 NOT NULL을 입력
-- > PRIMARY KEY가 설정된 열에는 NULL 값이 있을 수 없으므로 생략하면 자동으로 NOT NULL로 인식함
-- > NULL은 '아무것도 없다' 라는 의미이므로 공백('')이나 0과는 다름