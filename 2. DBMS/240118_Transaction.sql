-- TCL 연습할 mem_TCL 테이블 만들기
CREATE TABLE mem_tcl AS SELECT mem_id, mem_name, mem_number FROM member;
SELECT * FROM mem_tcl;

-- mem_TCL 테이블에 데이터를 입력, 수정, 삭제 # 트랜젝션 part
INSERT INTO mem_tcl VALUES ('ASP', '에스파', 4);

UPDATE mem_tcl SET mem_number = 5 WHERE mem_name = '에스파';

DELETE FROM mem_tcl WHERE mem_name = '에이핑크';

-- ROLLBACK으로 명령어 실행 취소
-- > ROLLBACK : 현재 트랜잭션에 포함된 데이터 조작 관련 명령어의 수행을 모두 취소
ROLLBACK;

SELECT * FROM mem_tcl;


-- mem_tcl 테이블에 데이터를 입력, 수정, 삭제 # Transction part
INSERT INTO mem_tcl VALUES('IVE', '아이브', 6);

UPDATE mem_tcl SET mem_id = 'PNK' WHERE mem_id = 'APN';

DELETE FROM mem_tcl WHERE mem_id = 'BLK';

-- COMMIT 으로 명령어 반영
COMMIT; -- None으로 반영

-- -- COMMIT 명령어는 지금까지 트랜잭션에서 데이터 조작 관련 명령어를 통해 변경된 데이터를 모두 데이터베이스에
-- -- 영구적으로 반영
-- -- COMMIT을 사용한 후로는 ROLLBACK으로도 되돌릴 수 없음

-- 세션 실습
SELECT  * FROM mem_tcl;
-- > dbeaver와 터미널 모두 같은 결과가 조회됨

-- -- dbeaver에서 데이터 삭제 후 다시 데이터 조회
DELETE FROM mem_tcl WHERE mem_id = 'IVE';

SELECT * FROM mem_tcl; -- 아직 dbeaver에서 commit되지 않았기 때문에 docker에는 IVE가 남아 있음

-- > dbeaver에서는 아이브가 삭제된 상태로 조회되고
-- > 터미널에서는 아이브가 삭제되기 전 상태로 출력됨

-- > dbeaver에서 실행한 DELETE문의 실행 결과가 아직 데이터베이스에 반영되지 않았기 때문(COMMIT 되지 않았기 때문)
-- > 어떤 데이터 조작이 포함된 트랜잭션이 완료되기 전까지는 데이터를 직접 조작하는 세션 외의 다른 세션에서는
-- > 데이터 조작 전의 상태가 일관적으로 조회, 출력, 검색되는 특성이 읽기 일관성(Read Consistency)

COMMIT;
SELECT * FROM mem_tcl;
-- > COMMIT을 실행한 후에는 DELETE문 실행 결과가 데이터베이스에 완전히 반영되어서
-- > 다른 세션에서도 아이브가 삭제된 상태로 조회됨

-- DBEAVER에서 데이터를 변경
UPDATE mem_tcl SET mem_id = 'GIRL' WHERE mem_name = '소녀시대';
SELECT * FROM mem_tcl;
-- > dbeaver에서는 소녀시대의 mem_id가 'GIRL'로 변경되었지만 COMMIT 되기 전이기 때문에
-- > 터미널에서는 소녀시대의 mem_id에 변화가 없음

-- -- COMMIT전에 터미널에서 데이터 수정
-- -- > 터미널에서 UPDATE문을 실행하면 아무 동작이 일어나지 않고 화면이 멈춘듯이 가만히 있음
-- -- > dbeaver에서 commit 또는 rollback을 수행하기 전까지 소녀시대 행 데이터를 조작하려는 다른 세션은 작업을 대기하게 됨

-- -- > 이렇게 데이터 조작이 완료될 때까지 다른 세션에서 해당 데이터 조작을 기다리는 현상을 HANG(행) 이라고 함
-- -- > dbeaver에서 commit이나 rollback을 사용해서 소녀시대 데이터의 LOCK을 풀면 그 즉시 터미널은 UPDATE문을 실행
COMMIT;

-- COMMIT을 실행하는 순간 터미널에서 UPDATE문이 실행됨
SELECT * FROM mem_tcl;
-- > dbeaver와 터미널 양쪽의 결과가 같게 나옴
-- > mysql터미널에서는 기본적으로 autocommit을 사용하기 때문에 데이터 조작을 하는 순간 commit이 자동으로 처리됨
