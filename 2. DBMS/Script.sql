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
SELECT   (열 이름)
FROM     (테이블 이름)
WHERE    (조건식)
GROUP BY (열 이름)
HAVING   (조건식)
ORDER BY (열 이름)
LIMIT 	 (숫자);

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