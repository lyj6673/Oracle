2024-0311-02) 연산자
 - 산술연산자(+, -, /, *)
   비교(관계)연산자(>, <, ==, >=, <=, !=(<>))
   논리연산자(NOT, AND, OR)
   기타연산자(IN, ANY, SOME, ALL, EXISTS, BETWEEN, LIKE)
 - WHERE절에 사용될 조건문 구성이나 표현식의 조건문에 사용
 - FROM->WHERE->SELECT절 순서로 수행
 
 사용 예) 회원테이블에서 마일리지가 3000이상인 회원의 정보를 조회하시오
        Alias는 회원번호, 회원명, 직업, 성별, 마일리지
    (조건 : 마일리지가 3000이상)
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN('2','4') THEN '여성회원'
                ELSE '남성회원' END AS 성별,
           MEM_MILEAGE AS 마일리지
    FROM MEMBER
    WHERE MEM_MILEAGE>=3000
    ORDER BY 4;

 사용 예) 상품테이블에서 매출가격이 50만원 이상인 상품을 조회하시오
        Alias는 상품번호, 상품명, 분류코드, 매출가격
        단, 분류코드별로 조회하시오.
    (조건 : 매출가격이 50만원 이상)
    
    SELECT PROD_ID AS 상품번호,
           PROD_NAME AS 상품명,
           PROD_LGU AS 분류코드,
           PROD_PRICE AS 매출가격
      FROM PROD
      WHERE PROD_PRICE>=500000
      ORDER BY 3;
      
1. 산술연산자(+, -, /, *)
  - 연산결과는 수치데이터
  
사용 예) 이번달 급여를 계산하여 출력하시오.
        급여는 기본급(SALARY)+보너스이다
        보너스는 기본급(SALARY)*영업실적(COMMISSION_PCT)의 50%이다
        Alias는 사원번호(EMPLOYEE_ID), 사원명(EMP_NAME), 기본급(SALARY),
        보너스(BONUS), 지급액(SLAARY_AMT)이다
        
        SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명, 
               SALARY AS 기본급,
               NVL(COMMISSION_PCT,0) AS 영업실적,
               NVL(SALARY*COMMISSION_PCT*0.5,0) AS 보너스, 
               SALARY+NVL(SALARY*COMMISSION_PCT*0.5,0) AS 지급액
          FROM HR.EMPLOYEES;
          
2. 관계연산자(>, <, ==, >=, <=, !=(<>))와 논리연산자(NOT, AND, OR)
  - 연산결과는 참(true) 또는 거짓(false)
  - 조건문 구성에 사용
  - 논리연산자는 하나 이상의 조건문을 결합할 때 사용
  -------------------------------------------
        입력              출력
  -------------------------------------------
     A       B     AND      OR     EX-OR
  -------------------------------------------
     0       0      0        0        0
     0       1      0        1        1   
     1       0      0        1        1
     1       1      1        1        0
  -------------------------------------------
  
사용 예) 매입정보(BUYPROD)테이블에서 2020년 1월 매입수량이 10개 이상인
        정보만 출력하시오
        Alias는 매입일자, 매입상품코드, 수량
        SELECT BUY_DATE AS 매입일자,
               BUY_PROD AS 매입상품코드,
               BUY_QTY AS 수량
          FROM BUYPROD
         WHERE BUY_DATE>=TO_DATE('20200101') AND BUY_DATE<=TO_DATE('20200131')
           AND BUY_QTY>=10;
        
사용 예) 매입정보(BUYPROD)테이블에서 2020년 1월 매입금액을 계산하시오
        Alias는 매입일자, 매입상품코드, 수량, 단가, 금액
        SELECT BUY_DATE AS 매입일자,
               BUY_PROD AS 매입상품코드,
               BUY_QTY AS 수량,
               BUY_COST AS 단가,
               BUY_QTY*BUY_COST AS 매입금액
          FROM BUYPROD
         WHERE BUY_DATE>=TO_DATE('20200101') AND BUY_DATE<=TO_DATE('20200131')

           
사용 예) 매입정보(BUYPROD)테이블에서 2020년 1월 매입금액이 100만원 이상인
        매입만 조회하시오
        Alias는 매입일자, 매입상품코드, 수량, 단가, 금액
        SELECT BUY_DATE AS 매입일자,
               BUY_PROD AS 매입상품코드,
               BUY_QTY AS 수량,
               BUY_COST AS 단가,
               BUY_QTY*BUY_COST AS 매입금액
          FROM BUYPROD
         WHERE BUY_DATE>=TO_DATE('20200101') AND BUY_DATE<=TO_DATE('20200131')
           AND BUY_QTY*BUY_COST>=1000000;
        
사용 예) 회원테이블에서 직업이 '주부'이면서 마일리지가 2000이상인 회원의
        회원번호, 회원명, 직업, 마일리지를 조회하시오.
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
                MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER 
          WHERE MEM_JOB='주부'
            AND MEM_MILEAGE>=2000;

사용 예) 2020년 6월 제품을 구매하지 않은 회원을 조회하시오
        Alias는 회원번호
     (6월에 구매한 회원번호)
        SELECT CART_MEMBER AS 회원번호,
               MEM_NAME AS 이름
            FROM MEMBER
            WHERE MEM_ID NOT IN(SELECT DISTINCT CART_MEMBER AS 회원번호
                                    FROM CART 
                                    WHERE CART_NO LIKE '202006%');
          
사용 예) HR계정 사원테이블에서 영업실적이 없는 사원들을 조회하시오
        Alias는 사원번호, 사원명, 부서코드
         SELECT EMPLOYEE_ID AS 사원번호,
                EMP_NAME AS 사원명,
                DEPARTMENT_ID AS 부서코드
                FROM HR.EMPLOYEES
                WHERE NVL(COMMISSION_PCT,0)=0;

        
사용 예) HR계정 사원테이블에서 소속부서가 없는 사원들을 조회하시오
        Alias는 사원번호, 사원명, 입사일, 급여, 직무코드
        SELECT EMPLOYEE_ID AS 사원번호,
                EMP_NAME AS 사원명,
                HIRE_DATE AS 입사일,
                SALARY+NVL(SALARY*NVL(COMMISSION_PCT,0)*0.5,0) AS 급여,
                DEPARTMENT_ID AS 직무코드
                FROM HR.EMPLOYEES
                WHERE DEPARTMENT_ID IS NULL;
                
               
  
  
  
  
  