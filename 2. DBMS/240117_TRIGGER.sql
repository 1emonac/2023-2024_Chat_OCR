-- 트리거
-- > 테이블에 어떠한 일이 일어날 때 자동으로 실행되는 프로그래밍 가능

-- 트리거의 개요
-- > 테이블에 INSERT, UPDATE, DELETE 작업이 발생하면 실행되는 코드
-- -- 예) market_db의 회원 중 '블랙핑크'가 탈퇴한다면 member테이블에서 블랙핑크의 정보를 삭제하면 됨
-- -- 하지만 나중에 탈퇴한 사람의 정보를 알야아 한다면 데이터베이스에서 삭제했기 때문에 알 수 있는 방법이 없음
-- -- 이를 방지하기 위해서 블랙핑크의 행을 삭제하기 전에 그 내용을 다른 곳에 복사하면 됨
-- -- 이런 작업을 매번 수작업으로 하면 데이터를 복사하는 것을 잊어버릴 수도 있음
-- -- 따라서 member에서 delete 작업이 일어날 경우 데이터가 삭제되기 전에 다른 곳에 자동으로 저장해주는 기능 구현에
-- -- 사용되는 것이 트리거

-- 트리거의 기본 작동
-- > 트리거는 INSERT, UPDATE, DELETE 등의 DML 이벤트가 발생할 때 작동
-- > 테이블에 미리 부착되어 있는 프로그램 코드라고 볼수도 있음

-- 스토어드 프로시저와의 차이점
-- > 트리거는 스토어드 프로시저와 문법이 비슷하지만 CALL로 직접 실행 시킬 수 없고, 오직 테이블에 이벤트가 발생할
-- > 경우에만 자동으로 실행됨

-- 트리거 테스트용 테이블 생성
CREATE TABLE IF NOT EXISTS trigger_table(id INT, txt VARCHAR(10));
INSERT INTO trigger_table VALUES(1, '레드벨벳');
INSERT INTO trigger_table VALUES(2, '잇지');
INSERT INTO trigger_table VALUES(3, '블랙핑크');

SELECT * FROM trigger_table;

-- > 테이블에 트리거를 부착
DROP TRIGGER IF EXISTS myTrigger;
DELIMITER $$
CREATE TRIGGER myTrigger -- 트리거 이름을 myTreigger로 지정
	AFTER DELETE -- DELETE문이 발생된 이후에 작동하라는 의미
	ON trigger_table -- 트리거를 부착할 테이블
	FOR EACH ROW -- 각 행마다 적용시킨다는 의미. 트리거는 항상 써주는 코드
BEGIN
	SET @msg = '가수 그룹이 삭제됨'; -- 트리거 실행 시 작동되는 코드들
END $$
DELIMITER ;

SET @msg = '';
INSERT INTO trigger_table VALUES(4, '마마무');
SELECT @msg;

UPDATE trigger_table SET txt = '블핑' WHERE id = 3;
SELECT @msg;
-- triggere_table에는 DELETE에만 작동하는 트리거를 부착했기 때문에 INSERT문이나 UPDATE문에서는 트리거가 작동하지 않음

DELETE FROM trigger_table WHERE id = 4;
SELECT @msg;
-- DELETE문을 실행하면 트리거가 작동해서 @msg 변수에 트리거에서 설정한 내용 입력

-- 트리거 활용
-- > 트리거는 테이블에 입력/수정/삭제 되는 정보를 백업하는 용도로 활용할 수 있음
-- > 예) 은행에서 계좌를 만드는 것은 INSERT, 입금이나 출금은 UPDATE, 폐기는 DELETE가 작동한다고 할 때
-- > 누가 계좌를 생성/수정/삭제 했는지 알 수 없다면 계좌에 문제가 발생했을 때 원인을 파악하기 힘듦
-- > 이런 상황에 대비해서 데이터에 입력/수정/삭제가 발생할 때 트리거를 자동으로 작동시켜 데이터를 변경한 사용자와 시간 등을 기록

-- market_db의 member에 회원의 정보가 변경될 때 변경한 사용자, 시간, 변경 전의 데이터 등을 기록하는 트리거 작성
CREATE TABLE singer (SELECT mem_id, mem_name, mem_number, addr FROM member);
SELECT * FROM singer;

-- singer 테이블에 INSERT나 UPDATE 작업이 일어나는 경우, 변경되기 전의 데이터를 저장할 백업 테이블 생성
CREATE TABLE backup_singer
( mem_id		CHAR(8) NOT NULL,
  mem_name		VARCHAR(10) NOT NULL,
  mem_number	INT NOT NULL,
  addr			CHAR(2) NOT NULL,
  modType		CHAR(2), -- 변경된 타입, '수정' 또는 '삭제'
  modDate		DATE, -- 변경된 날짜
  modUser		VARCHAR(30) -- 변경한 사용자
);

-- UPDATE와 DELETE가 발생할 때 작동하는 트리거를 SINGER테이블에 부착
DROP TRIGGER IF EXISTS singer_updateTrg;
DELIMITER $$
CREATE TRIGGER singer_updateTrg -- 트리거 이름
	AFTER UPDATE -- 수정 후에 작동하도록 지정
	ON singer -- 트리거를 부착할 테이블
	FOR EACH ROW 
BEGIN 
	INSERT INTO backup_singer VALUES(OLD.mem_id,
	OLD,mem_name, OLD.mem_number, OLD.addr, '수정', CURDATE(), CURRENT_USER());
END $$
DELIMITER ;
-- OLD테이블은 UPDATE나 DELETE가 수행될 때 변경되기 전의 데이터가 잠깐 저장되는 임시테이블
-- > singer 테이블에 UPDATE문이 작동되면 원래의 데이터가 백업테이블(backup_singer)에 입력됨
-- > CURDATE() : 현재 날짜
-- > CURRENT_USER() : 현재 작업 중인 사용자

DROP TRIGGER IF EXISTS singer_deleteTrg;
DELIMITER $$
CREATE TRIGGER singer_deleteTrg -- 트리거 이름
	AFTER DELETE  -- 삭제 후에 작동하도록 지정
	ON singer -- 트리거를 부착할 테이블
	FOR EACH ROW 
BEGIN 
	INSERT INTO backup_singer VALUES(OLD.mem_id,
	OLD,mem_name, OLD.mem_number, OLD.addr, '삭제', CURDATE(), CURRENT_USER());
END $$
DELIMITER ;

-- 데이터 수정, 삭제
UPDATE singer SET addr = '영국' WHERE mem_id = 'BLK';
DELETE FROM singer WHERE mem_number >= 7;

-- 백업 테이블 조회
SELECT * FROM backup_singer;

SELECT * FROM singer;

-- 테이블 초기화 테스트
TRUNCATE TABLE singer;
-- > TRUNCATE TABLE 로 데이터 삭제 시에는 트리거가 작동하지 않음
-- > DELETE 트리거는 오직 DELETE문에서만 작동

-- 트리거가 사용하는 임시 테이블
-- > 테이블에 INSERT, UPDATE, DELETE 작업이 수행되면 임시로 사용하는 시스템 테이블이 2개(NEW, OLD)
-- > 임시 테이블은 MYSQL이 알아서 생성하고 관리하므로 신경 쓸 필요는 없음

-- NEW테이블은 INSERT문이 실행되면 새 값을 NEW 테이블에 넣었다가 NEW 테이블에서 목표 테이블로 옮김
-- DELETE 문이 실행되면 목표 테이블에서 OLD테이블로 예전값을 잠깐 옮겨둠
-- > 따라서 AFTER DELETE 트리거로 삭제된 후에 OLD.열이름 형식으로 예전 값에 접근할 수 있음

-- UPDATE를 사용하면 새 값을 NEW 테이블에 잠깐 넣어뒀다가 목표 테이블로 옮기고 목표 테이블에 있던 예전 값은
-- OLD 테이블로 잠깐 옮겨둠

