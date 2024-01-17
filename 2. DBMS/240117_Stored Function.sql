-- 스토어드 함수
-- > 스토어드 프로시저와 비슷하지만 사용방법과 용도가 조금 다름

-- 스토어드 함수의 개념과 형식
-- > 사용자가 직접 만들어서 사용하는 함수를 스토어드 함수(STORED FUNCTION)이라고 함
DELIMITER $$
CREATE FUNCTION 스토어드_함수_이름(매개변수)
	RETURNS 반환형식
BEGIN
	프로그래밍 코딩
	RETURN 반환값;
END $$
DELIMITER ;

SELECT 스토어드_함수_이름();

-- 스토어드 함수와 스토어드 프로시저의 차이점
-- > 스토어드 함수는 RETURNS로 반환값의 데이터 형식을 지정하고, 본문 안에서는 RETURN으로 하나의 값을 반환
-- > 스토어드 함수의 매개변수는 모두 입력 매개변수
-- > 스토어드 프로시저는 CALL로 호출하지만, 스토어드 함수는 SELECT문 안에서 호출됨
-- > 스토어드 프로시저 안에서는 SELECT문을 사용할 수 있지만, 스토어드 함수 안에서는 SELECT를 사용할 수 없음
-- > 스토어드 프로시저는 여러 SQL문이나 숫자 계산 등의 다양한 용도로 사용하지만, 스토어드 함수는 어떤 계산을 통해서 하나의 값을 반환하는데 주로 사용

-- 스토어드 함수의 사용
-- > 스토어드 함수를 사용하기 위해서는 먼저 스토어드 함수 생성 권한을 허용해줘야 함
SET GLOBAL log_bin_trust_function_creators = 1;

-- 숫자 2개의 합계를 계산하는 스토어드 함수
DROP FUNCTION IF EXISTS sumFunc;
DELIMITER $$
CREATE FUNCTION sumFunc(number1 INT, number2 INT) -- 2개의 정수형 매개변수를 전달받음
	RETURNS INT -- 반환 데이터의 형식을 정수로 지정
BEGIN
	RETURN number1 + number2; -- 정수형 결과를 반환
END $$
DELIMITER ;

SELECT sumFunc(100, 200) AS '합계'; -- SELECT문에서 호출하면서 2개의 매개변수를 전달


-- 데뷔 연도를 입력하면 활동기간이 얼마나 되었는지 출력해주는 함수
DROP FUNCTION IF EXISTS calcYearFunc;
DELIMITER $$
CREATE FUNCTION calcYearFunc(dYear INT) -- 데뷔연도를 매개변수로 받음
	RETURNS INT
BEGIN
	DECLARE runYear INT; -- 활동기간(연도)
	SET runYear = YEAR(CURDATE()) - dYear; -- 오늘 날짜에서 연도 부분만 추출/ 실제로 계산을 진행(현재연도 - 데뷔연도)
	RETURN runYear; -- 계산된 결과를 반환
END $$
DELIMITER ;

SELECT calcYearFunc(2010) AS '활동 햇수';

-- 함수의 반환값을 SELECT ~ INTO ~ 로 저장했다가 사용할 수도 있음
SELECT calcYearFunc(2007) INTO @debut2007;
SELECT calcYearFunc(2013) INTO @debut2013;
SELECT @debut2007 - @debut2013 as '2007과 2013 차이';

-- member 테이블에서 모든 회원이 데뷔한 지 몇 년이 되었는지 조회하기
SELECT mem_id, mem_name, calcYearFunc(YEAR(debut_date)) AS '활동 햇수'
FROM member;

-- 함수의 삭제
DROP FUNCTION calcYearFunc;
