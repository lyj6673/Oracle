2024-0314-01)숫자함수

ABS(), SIGN(), POWER(), SQRT() (수학적 함수)
GREATEST(), LEAST() (주어진 데이터의 최대. 최소값을 반환)
ROUND(), TRUNC() (반올림, 올림)
FLOOR(), CEIL() (내림함수, 올림함수 FLOOR은 바닥이니까 7.6 을 7로 CEIL은 천장이니까 8로)
MOD() (나머지 함수)
WIDTH_BUCKET() (주어진 값을 구간으로 나누고 그 구간의 순번을 반환)

1. 수학적 함수
 - ABS(), SIGN(), POWER(), SQRT()
 - ABS(n1) : 주어진 숫자 자료 n1의 절대값 반환
 - SIGN(n1) : 주어진 숫자 자료 n1의 부호가 음수이면 -1, 0이면 0, 양수이면 1을 반환
 - POWER(n1,n2) : n1을 n2번 거듭 곱한결과(n1의 n2승)
 - SQRT(n1) : n1의 평방근 반환
 
사용 예)
    SELECT ABS(-10), ABS(200),
           SIGN(-100000), SIGN(0.000001), SIGN(0),
           POWER(2,10), POWER(10,10),
           SQRT(3.3)
        FROM DUAL;
        
2. GREATEST(n1,n2,...n), LEAST(n1,n2,...n)
  - 주어진 데이터 n1 ~ n 값 중 가장 큰값(GREATEST) 또는 가장 작은 값(LEAST) 반환
  - GREATEST와 LEAST는 한 행에서 큰값, 작은 값을 구할 때 사용하고
    MAX(컬럼명), MIN(컬럼명)은 한 컬럼에서 최대(최소) 값을 구할 때 사용
  - 문자열도 적용할 수 있음
    
사용 예)
    SELECT GREATEST(100,50,900),
    ASCII('홍'),
           GREATEST('홍길동',23000,'대한민국')
      FROM DUAL;
    
    SELECT LEAST(PROD_COST,PROD_PRICE,PROD_SALE)
      FROM PROD;
      
문제]회원테이블에서 회원들의 마일리지를 조회하여 1000미만인 회원의 마일리지를
    1000으로, 1000이상인 회원 마일리지는 해당 회원의 마일리지를 그대로
    출력하시오.
    Alias는 회원번호, 회원명, 보유마일리지, 변경마일리지
    
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_MILEAGE AS 보유마일리지,
           GREATEST(MEM_MILEAGE,1000) AS 변경마일리지
      FROM MEMBER
      
2. ROUND(n1, loc), TRUNC(n1, loc)
 - 주어진 수 n1에서 소숫점 이하 loc+1번째 자리에서 반올림(ROUND) 또는
   자리버림(TRUNC)을 하여 loc자리까지 반환
 - loc가 생략되면 0으로 간주되어 소숫점 이하를 잘라버림
 - loc가 음수이면 정수부분의 loc자리에서 반올림(ROUND) 또는 자리버림(TRUNC)을
   수행함
   
사용 예)HR계정의 사원테이블에서 각 부서별 평균임금을 구하시오.
       Alias는 부서번호, 부서명, 평균임금
       평균임금은 소숫점 1자리까지 출력
    SELECT A.DEPARTMENT_ID AS 부서번호,
           B.DEPARTMENT_NAME AS 부서명,
           ROUND(AVG(SALARY),1) AS 평균임금1,
           TRUNC(AVG(SALARY),1) AS 평균임금2,
           ROUND(AVG(SALARY),-2) AS 평균임금3,
           TRUNC(AVG(SALARY),-2) AS 평균임금4
      FROM HR.EMPLOYEES A,  HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
     GROUP BY A.DEPARTMENT_ID,B.DEPARTMENT_NAME
     ORDER BY 1;
     
4. FLOOR(n1), CEIL(n1)
 - FLOOR : 주어진 수 n1보다 같거나(n1이 정수) n1 보다 큰 가장 작은 정수
 - CELL : 주어진 수 n1보다 같거나(n1이 정수) n1 보다 작은 가장 큰 정수
 
 사용 예) SELECT FLOOR(123.5678), FLOOR(23), FLOOR(-123.4567),
                CEIL(123.5678), CEIL(23), CEIL(-123.4567)
           FROM DUAL;
           
5. MOD(n1, n2)
 - 주어진 수 n1을 n2로 나눔 나머지 반환
 - 자바의 '%'연산자와 동일
 - 내부 연산방식 : 나머지 = n1 - n2 * FLOOR(n1/n2)
 
 사용 예)
 SELECT MOD(21,5), MOD(21,8) FROM DUAL;
 
 사용 예)키보드로 년도를 입력받아 윤년과 평년을 구별하시오
        윤년 : ((4의 배수이면서) (100의 배수가 아니거나)) 또는 (400의 배수)가 되는 해
        
    ACCEPT P_YEAR PROMPT '년도입력 : ';
    DECLARE
        L_YEAR NUMBER := TO_NUMBER('&P_YEAR'),
        L_RESULT VARCHAR2(500),
        L_FLAG BOOLEAN := FALSE;
    BEGIN
        L_FLAG:=MOD(L_YEAR,4)=0 AND MOD(L_YEAR, 100)!=0 OR (MOD(L_YEAR,400)=0);
        IF L_FLAG=FALSE THEN
           L_RESULT:=L_YEAR||'년은 평년입니다...'
        ELSE
           L_RESULT:=L_YEAR||'년은 윤년입니다...' 
        END IF;
        DBMS_OUTPUT.PUT_LINE(L_RESULT);
        END;
        
6. WIDTH_BUCKET(n1, min_val, max_val, block_count)
 - min_val에서 max_val 까지의 구간을 block_count 개수의 그룹으로 나누었을 때
   주어진 값 n1이 그 중 어느 구간에 포함되었는지를 구간의 순벌을 반환
  - 각 구간의 범위는 구간하한값<=구간<'구간 상한값'으로 구간 상한값은 해당 구간에
  - 표현하는 구간의 수는 block_count+2개임('max,val'보다 큰 구간,
                                        'mun_val'미만 구간 표현)

사용 예)회원테이블에서 회원들의 마일리지를 조회하여 회원 등급을 부여하시오.
       회원 등급은 1000~8000까지 7로 구분하고 등급명은 다음과 같다.
       1 이하 : 새싹회원
       1-2등급 : 열심회원
       3-5등급 : 평회원
       6 이상 등급 : VIP회원
       Alias는 회원번호, 회원명, 마일리지, 등급, 회원등급명이다.
    
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_MILEAGE AS 마일리지,
           WIDTH_BUCKET(MEM_MILEAGE,1000,8000,7) AS 등급, 
          CASE WHEN WIDTH_BUCKET(MEM_MILEAGE,1000,8000,7)<1 THEN '새싹회원'
               WHEN WIDTH_BUCKET(MEM_MILEAGE,1000,8000,7) IN(1,2) THEN '열심회원'
               WHEN WIDTH_BUCKET(MEM_MILEAGE,1000,8000,7) BETWEEN 3 AND 5 THEN '평회원'
               ELSE 'VIP회원'
            END AS 회원등급명
        FROM MEMBER;
        
        
    UPDATE MEMBER
        SET MEM_MILEAGE=7500
    WHERE LOWER(MEM_ID)='s001';
    
    COMMIT;
    
 사용 예)회원테이블에서 회원들의 마일리지를 조회하여 회원 등급을 부여하시오
        회원등급은 1000~8000까지 7로 구분하고 마일리지가 많은 회원부터
         1 등급에서 등급값이 큰 등급을 순차적으로 부여하시오.
         
         Alias는 회원번호, 회원명, 마일리지, 등급이다.
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_MILEAGE AS 마일리지,
           9-WIDTH_BUCKET(MEM_MILEAGE,1000,8000,7) AS 등급
        FROM MEMBER;
 
     
       