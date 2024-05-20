2024-0319-02) 집계함수
  - SUM(), AVG(), COUNT(), MAX, MIN
  - 특정 컬럼을 기준으로 같은 값을 갖는 행들을 그룹으로 묶고 각 그룹마다
    합, 평균, 갯수 등을 구하는 함수
  - 집계함수는 다른 집계함수를 포함할 수 없음
    
(사용형식)
    SELECT 컬럼1,...컬럼n,
            SUM(컬럼명)|AVG(컬럼명)|COUNT(컬럼명)|MAX(컬럼명)|MIN(컬럼명)
      FROM 테이블명
    [WHERE 조건]
    GROUP BY 컬럼1[,...컬럼n]
   [HAVING 조건]
    [ORDER BY 컬럼명|컬럼인덱스 [ASC|DESC],...]
    . SELECT 절에 집계함수만 사용되면 GROUP BY절 생략
    . GROUP BY절에는 SELECT절에 사용된 일반컬럼을 모두 다 기술해야 함
    . GROUP BY절에 하나 이상의 컬럼이 기술되면 가장 왼쪽에 기술된 컬럼을 기준으로
      그룹을 묶고(대분류), 다음에 기술된 컬럼으로 각 그룹 내에서 다시 그룹(중분류)을
      묶는다.
    . GROUP BY절은 기술된 컬럼 외에 테이블 안에 있는 다른 컬럼도 사용가능
    . HAVING 조건은 집계함수에 대한 조건을 부여할 때 반드시 사용
            (집계함수 자체가 조건이 될때 HAVING)
    . 기술순서 : WHERE -> GROUP BY -> HAVING -> ORDER BY
    
 사용 예)사원테이블에서 모든 사원 수를 조회하시오
   SELECT COUNT (*) AS 사원수,
          AVG(SALARY) AS 평균급여,
          SUM(SALARY) AS 급여합계,
          MAX(SALARY) AS 최고급여액,
          MIN(SALARY) AS 최저급여액
     FROM HR.EMPLOYEES;
 
 사용 예)상품테이블에서 모든 상품의 수를 조회하시오
 
 사용 예)회원테이블에서 회원 수를 조회하시오
 
 사용 예)사원테이블에서 부서별 사원수, 평균급여를 조회하시오
   SELECT DEPARTMENT_ID AS 부서코드,
          COUNT(*) AS 사원수,
          ROUND(AVG(SALARY)) AS 평균급여
     FROM HR.EMPLOYEES
     GROUP BY DEPARTMENT_ID
     ORDER BY 1;
 사용 예)상품테이블에서 분류별 매출가가 10만원 이상인 상품의 수를 조회하시오.
   SELECT PROD_LGU AS 분류코드,
          PROD_NAME AS 상품명,
          COUNT(*) AS "상품의수"
     FROM PROD
     WHERE PROD_PRICE>=100000
     GROUP BY PROD_LGU,PROD_NAME
     ORDER BY 1;
     
 사용 예)상품테이블에서 각 분류별 최대판매가격과, 최소판매가격을 조회하시오.
    SELECT PROD_LGU AS 분류코드,
           PROD_NAME AS 상품명,
           
           
    SELECT PROD_LGU AS 분류코드,
           MAX(PROD_PRICE) AS 최대판매가격,
           MIN(PROD_PRICE) AS 최소판매가격
      FROM PROD
     GROUP BY PROD_LGU
     ORDER BY 1; 
 
 사용 예)매입테이블에서 2020년 월별 매입수량합계를 조회하시오.
    SELECT EXTRACT(MONTH FROM BUY_DATE) AS 월,
           SUM(BUY_QTY) AS 매입수량합계
      FROM BUYPROD
     WHERE EXTRACT(YEAR FROM BUY_DATE) = 2020
     GROUP BY EXTRACT(MONTH FROM BUY_DATE)
     ORDER BY 1;
 
 사용 예)매입테이블에서 2020년 제품별 매입수량합계를 조회하시오.
    SELECT BUY_PROD AS 상품번호,
           SUM(BUY_QTY) AS 매입수량합계
      FROM BUYPROD
     WHERE EXTRACT(YEAR FROM BUY_DATE) = 2020
     GROUP BY BUY_PROD
     ORDER BY 1;
 
 사용 예)매입테이블에서 2020년 제품별 매입수량합계가 100개 이상인 상품만 조회하시오.
    SELECT BUY_PROD AS 상품번호,
           SUM(BUY_QTY) AS 매입수량합계
      FROM BUYPROD
     WHERE EXTRACT(YEAR FROM BUY_DATE) = 2020
     GROUP BY BUY_PROD
    HAVING SUM(BUY_QTY)>=100
     ORDER BY 1;
     
 사용 예)매입테이블에서 2020년 월별 상품별 매입수량합계를 조회하시오.
    SELECT EXTRACT(MONTH FROM BUY_DATE) AS 월,
           BUY_PROD AS 상품번호,
           SUM(BUY_QTY) AS 매입수량합계
      FROM BUYPROD
     WHERE EXTRACT(YEAR FROM BUY_DATE) = 2020
     GROUP BY EXTRACT(MONTH FROM BUY_DATE), BUY_PROD
     ORDER BY 1, 3 DESC;
     
 사용 예)회원테이블에서 성별 평균 마일리지를 조회하시오.
    SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1)IN('2','4') THEN '여성회원'
                ELSE '남성회원' END AS 성별,
            ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지
      FROM MEMBER
      GROUP BY CASE WHEN SUBSTR(MEM_REGNO2,1,1)IN('2','4') THEN '여성회원'
                ELSE '남성회원' END;   
 
 사용 예)2020년 4-7월 회원별 평균 구매횟수를 조회하시오.
        SELECT CART_MEMBER AS 회원번호,
               COUNT(*) AS 평균구매횟수
          FROM CART A
         WHERE SUBSTR(CART_NO,5,2)>='04'
           AND SUBSTR(CART_NO,5,2)<='07'
        GROUP BY CART_MEMBER;
        
    SELECT A.CART_MEMBER AS 회원번호,
            COUNT(*) AS 구매횟수
      FROM(SELECT CART_MEMBER,CART_NO,COUNT(*)
             FROM CART
            WHERE SUBSTR(CART_NO,1,6) BETWEEN '202004' AND '202007'
            GROUP BY CART_MEMBER,CART_NO)A
        GROUP BY A.CART_MEMBER
        ORDER BY 1;
        


 
 사용 예)2020년 5월 회원별 구매금액 합계를 구하여 출력하되 구매금액이
        500만원 이상인 자료만 조회하시오.
SELECT A.A1 AS 회원번호,
       A.A2 AS 회원명,
       A.A3 AS 구매금액
        FROM(SELECT B.MEM_ID AS A1,
               B.MEM_NAME AS A2,
               SUM(A.CART_QTY*C.PROD_PRICE) AS A3
          FROM CART A, MEMBER B, PROD C
         WHERE A.CART_NO LIKE '202005%'
           AND A.CART_MEMBER=B.MEM_ID
           AND A.CART_PROD=C.PROD_ID
         GROUP BY B.MEM_ID,B.MEM_NAME
         ORDER BY 3 DESC)A
WHERE ROWNUM<=5;
 
 사용 예)장바구니 테이블에서 2020년 5월 회원별 구매금액을 구하되 구매금액이
        많은 5명을 조회하시오.
        Alias는 회원번호, 회원명, 구매금액
    
    