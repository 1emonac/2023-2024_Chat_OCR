-- INSERT(데이터 입력)

-- INSERT문의 기본 문법
INSERT INTO 테이블 (열1, 열2, 열3.....) VALUES (값1, 값2, 값3...);

-- > 테이블 이름 다음에 나오는 열은 생략 가능함
-- --> 다만, 생략할 시에는 VALUES 다음에 나오는 값들의 순서와 개수는 열의 순서 및 개수와 동일해야함
CREATE TABLE toy_shop(toy_id INT, toy_name CHAR(4), age INT);
INSERT INTO toy_shop VALUES (1, '우디', 25);

SELECT * FROM toy_shop;
-- SELECT *(aster) FROM (TABLE)

-- 아이디와 이름만 입력하고 나이는 입력하고 싶지 않다면
INSERT INTO toy_shop (toy_id, toy_name) VALUES (2, '버즈');

-- 열의 순서를 바꿔서 입력하는 것도 가능함
INSERT INTO toy_shop (toy_name, age, toy_id) VALUES ('제시', 20, 3);

-- 테이블 삭제
DROP TABLE toy_shop;

-- AUTO_INCREMENT -- 테이블 생성 때 넣어두는 것이 좋다!
-- > 자동으로 증가하는 값 입력
-- > INSERT를 사용할 때 해당 열은 입력하지 않아도 자동으로 증가하는 값이 입력됨

-- 주의점
-- -- AUTO_INCREMENT로 지정하는 열은 반드시 PRIMARY KEY로 지정해줘야 함
-- -- PRIMARY KEY : 각 행을 구분하는 유일한 값

CREATE TABLE toy_shop2 (
	toy_id INT AUTO_INCREMENT PRIMARY KEY,
	toy_name CHAR(4),
	age INT);

-- AUTO_INCREMENT 열은 비워두고 데이터 입력 해보기
INSERT INTO toy_shop2 (toy_name, age) VALUES ('보핍', 25);
INSERT INTO toy_shop2 (toy_name, age) VALUES ('슬링키', 22);
INSERT INTO toy_shop2 (toy_name, age) VALUES ('렉스', 21);

SELECT * FROM toy_shop2;

-- AUTO_INCREMENT로 입력되는 다음 값을 100부터 시작하도록 변경하고 싶다면
ALTER TABLE toy_shop2 AUTO_INCREMENT = 100;
INSERT INTO toy_shop2 (toy_name, age) VALUES ('햄', 35);

-- AUTO_INCREMENT로 입력되는 값을 1000으로 지정하고, 3씩 증가하도록 설정
TRUNCATE TABLE toy_shop2; -- 테이블 안의 데이터 초기화
ALTER TABLE toy_shop2 AUTO_INCREMENT = 1000;
SET @@auto_increment_increment = 3;

SELECT * FROM toy_shop2;
INSERT INTO toy_shop2 (toy_name, age) VALUES ('포테이토', 20);
INSERT INTO toy_shop2 (toy_name, age) VALUES ('앤디', 23);
INSERT INTO toy_shop2 (toy_name, age) VALUES ('알린', 25);

-- 여러 건을 한 번에 입력
INSERT INTO toy_shop2 (toy_name, age) VALUES ('아미맨', 92), ('빌리', 77);

-- INSERT INTO ~ SELECT ~
-- > 다른 테이블의 데이터를 한 번에 입력
INSERT INTO 테이블이름 (열이름1, 열이름2...) SELECT ~;

-- 주의점
-- > SELECT문의 결과 데이터의 열 개수는 INSERT할 테이블의 열 개수와 같아야 함

-- WORLD 데이터베이스 city 테이블의 데이터 개수 조회
SELECT COUNT(*) FROM world.city;

-- world.city 테이블 프로퍼티 보기
DESC world.city;

-- 데이터 살펴보기
SELECT * FROM world.city LIMIT 5;

-- 도시 이름과 인구를 가져와 테이블 구성하기
CREATE TABLE city_popul (city_name CHAR(35), population INT);
INSERT INTO city_popul SELECT name, population FROM world.city;

SELECT * FROM city_popul;

-- UPDATE (데이터 수정)
-- UPDATE문의 기본 문법
UPDATE 테이블이름 SET 열1 = 값1, 열2 = 값2 ... WHERE 조건;

-- city_popul 테이블의 도시이름 중에서 Seoul을 서울로 변경하기
SELECT * FROM city_popul WHERE city_name = 'Seoul';
UPDATE city_popul SET city_name = '서울' WHERE city_name = 'Seoul';
SELECT * FROM city_popul WHERE city_name = '서울';

-- 한꺼번에 여러 열 변경하기
-- > 도시 이름 New York 을 뉴욕으로 바꾸면서 인구는 0으로 수정
SELECT * FROM city_popul WHERE city_name = 'New York';
UPDATE city_popul SET city_name = '뉴욕', population = 0 WHERE city_name = 'New York';
SELECT * FROM city_popul WHERE city_name = '뉴욕';

-- 주의점
-- > UPDATE문에서 WHERE절은 생략가능하지만, WHERE절을 생략하면 모든 행의 값이 바뀜
-- > city_popul 테이블의 인구를 10000명 단위로 변경하는 등의 특수한 경우가 아니라면 주의해야함
UPDATE city_popul SET population = population / 10000;
SELECT * FROM city_popul LIMIT 5;

-- DELETE (데이터 삭제)
-- DELETE문의 기본 문법
DELETE FROM 테이블이름 WHERE 조건;

-- city_popul 테이블에서 'New'로 시작하는 도시를 삭제하고 싶다면
SELECT * FROM city_popul WHERE city_name LIKE 'New%';
DELETE FROM city_popul WHERE city_name LIKE 'New%';

-- 만약에 'New'로 시작하는 도시 중 상위 몇 건만 삭제하려면 LIMIT과 함께 사용할 수 있음
DELETE FROM city_popul WHERE city_name LIKE 'New%' LIMIT 5;
