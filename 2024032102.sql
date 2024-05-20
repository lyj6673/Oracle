2024-0321-02)조인(JOIN)
 - 필요한 자료가 복수개의 테이블에 분산되어 저장되어 있으며
   공통의 컬럼으로 관계를 형성하고 있을 때 이 관계를 이용하여 자료를 추출하는
   연산이 JOIN이다
 - 구분
   내부조인(INNER JOIN)/외부조인(OUTER JOIN)
   일반조인 / ANSI JOIN
    그 밖에 CARTESIAN JOIN(CROSS JOIN), NATUAL JOIN
 1. 내부조인
  - 조인조건에 일하는 자료만으로 결과를 도출
  - 조인조건을 만족하지 않는 자료는 무시함
  - 동등조인(EQUI JOIN), 비동등조인(NONE EQUI-JOIN), INNER JOIN(ANSI JOIN)
  (일반조인 사용형식)
  SELECT [테이블별칭.]컬럼명 [AS 별칭][,]
                    :
         [테이블별칭.]컬럼명 [AS 별칭]
    FROM 테이블명 [별칭], 테이블명 [별칭] [,테이블명 [별칭]...]
   WHERE 조인조건
    [AND 일반조건]
    
        :
    
    - 테이블명 [별칭]: 사용되는 모든 테이블의 컬럼명이 모두 다른 경우 '별칭'은
      생략 가능
    - '테이블 별칭'은 SELECT 절이나 WHERE 절 등에서 이름이 동일한 컬럼명들을
      참조할 때는 반드시 사용해야 함
    - 조인조건 : 사용되는 테이블 사이의 공통 컬럼을 동등연산자('=')를 사용한
      조건식이나(EQUI-JOIN), 동등연산자('=') 이외 연산자를 사용한
      조건식(NONE EQUI-JOIN)을 기술
    - 조인조건과 일반조건은 AND 연산자로 연결함
    
    (ANSI조인 사용형식)
    SELECT [테이블별칭.]컬럼명 [AS 별칭][,]
                    :
           [테이블별칭.]컬럼명 [AS 별칭] 
      FROM 테이블명 [별칭]
     INNER JOIN 테이블명 [별칭] ON(조인조건 [AND 일반조건])
     INNER JOIN 테이블명 [별칭] ON(조인조건 [AND 일반조건])
                    :
     [WHERE 일반조건]

 1) CARTESIAN JOIN(CROSS JOIN)
  - 조인조건이 생략되었거나 잘못된 조인조건이 부여된 경우
  - 결과는 두 테이블의 행은 곱한 갯수와 열은 더한 결과를 반환
  - 반드시 필요한 경우가 아니면 수행 자제
  (ANSI FORMAT)
    SELECT column_list
      FROM table_name
     CROSS JOIN table_name [ON join_condition];
     
 사용 예)
    SELECT COUNT(*)
      FROM BUYPROD, PROD, CART; =148*74*207
 
    SELECT COUNT(*)
      FROM BUYPROD
     CROSS JOIN PROD
     CROSS JOIN CART;
     
 2) 동등조인(Equi join)
  - 조인조건에 동등연산자 '='이 사용된 조인
  - 대부분의 조인이 동등조인임
  
 사용 예)사원테이블에서 근속년수가 5년이상인 사원들의 사원번호, 사원명, 부서명, 입사일을
        조회하시오.
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_NAME AS 부서명,
           A.HIRE_DATE AS 입사일
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
     WHERE EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIRE_DATE)>=5
       AND A.DEPARTMENT_ID=B.DEPARTMENT_ID;
       
 (ANSI 조인)
  SELECT    A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_NAME AS 부서명,
           A.HIRE_DATE AS 입사일
      FROM HR.EMPLOYEES A
     INNER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID=B.DEPARTMENT_ID AND
           EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIRE_DATE)>=5);
 
 사용 예)2020년 1-3월 제품별 매입집계를 조회하시오 매입수량이 100개 이상인 제품만 조회
        Alias는 제품코드, 제품명, 매입수량, 매입금액
 (일반조인)
    SELECT A.BUY_PROD AS 제품코드,
           B.PROD_NAME AS 제품명,
           SUM(A.BUY_QTY) AS 매입수량,
           SUM(A.BUY_QTY*B.PROD_COST) AS 매입금액
      FROM BUYPROD A, PROD B
     WHERE A.BUY_PROD=B.PROD_ID
       AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200331')
     GROUP BY A.BUY_PROD, B.PROD_NAME
     HAVING SUM(A.BUY_QTY)>=100
     ORDER BY 1;
     
 (ANSI조인) --수정못함
     SELECT A.BUY_PROD AS 제품코드,
           B.PROD_NAME AS 제품명,
           SUM(A.BUY_QTY) AS 매입수량,
           SUM(A.BUY_QTY*B.PROD_COST) AS 매입금액
      FROM BUYPROD A, PROD B
     WHERE A.BUY_PROD=B.PROD_ID
       AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200331')
     GROUP BY A.BUY_PROD, B.PROD_NAME
     HAVING SUM(A.BUY_QTY)>=100
     ORDER BY 1; 
 사용 예)2020년 1-6월 상품의 분류별 판매집계를 조회하시오
        Alias는 분류코드, 분류명, 판매금액
        SELECT AS 분류코드,
               AS 분류명,
               AS 판매금액
          FROM LPROD L, CART C, PROD P
         WHERE SUBSTR(C.CART_NO,1,6) BETWEEN '202001' AND '202006'
           AND (  )
           AND (  )
         GROUP BY L.LPROD_GU, L.LPROD_NM
         ORDER BY 1;
         
 (ANSI JOIN)
    SELECT L.LPROD_GU AS 분류코드,
           L.LPROD_NM AS 분류명,
           SUM(C.CART_QTY*P.PROD_PRICE) AS 판매금액
      FROM LPROD L
     INNER JOIN PROD P ON(L.LPROD_GU=P.PROD_LGU) --분류명 추출
     INNER JOIN CART C ON(C.CART_PROD=P.PROD_ID AND
           SUBSTR(C.CART_NO,1,6) BETWEEN '202001' AND '202006')
     GROUP BY L.LPROD_GU, L.LROD_NM
     ORDER BY 1;
        
 사용 예)HR계정에서 부서가 미국 이외에 위치한 부서에 근무하는 사원정보를 조회하시오
        Alias는 사원번호, 사원명, 부서코드, 부서명
        미국의 국가코드는 'US'임
    SELECT E.EMPLOYEE_ID AS 사원번호,
           E.EMP_NAME AS 사원명,
           D.DEPARTMENT_ID AS 부서코드,
           D.DEPARTMENT_NAME AS 부서명
      FROM HR.EMPLOYEES E, HR.DEPARTMENTS D, HR.LOCATIONS L
     WHERE L.COUNTRY_ID != 'US' --일반조건
       AND (   )
       AND (   );
       
 (ANSI JOIN)
 
 숙제) 2020년 6-7월 회원별 구매집계를 조회하시오.
      Alias는 회원번호,회원명,구매금액
 (일반조인)
 SELECT M.MEM_ID AS 회원번호,
        M.MEM_NAME AS 회원명,
        SUM(C.CART_QTY*P.PROD_PRICE) AS 구매금액합계
   FROM MEMBER M, CART C, PROD P
  WHERE M.MEM_ID=C.CART_MEMBER(+)
    AND SUBSTR(C.CART_NO,1,6) BETWEEN '202006' AND '202007'
  GROUP BY M.MEM_ID, M.MEM_NAME
  ORDER BY 1;
 
 (ANSI조인)
 SELECT M.MEM_ID AS 회원번호,
        M.MEM_NAME AS 회원명,
        SUM(C.CART_QTY*P.PROD_PRICE) AS 구매금액합계
   FROM MEMBER M 
   INNER JOIN CART C ON(M.MEM_ID=C.CART_MEMBER)
   INNER JOIN PROD P ON(C.CART_PROD=PROD_ID
    AND SUBSTR(C.CART_NO,1,6) BETWEEN '202006' AND '202007')
  GROUP BY M.MEM_ID, M.MEM_NAME
  ORDER BY 1;
 
 숙제2)2020년 거래처별 매입집계를 조회하시오.
      Alias는 거래처번호,거래처명,제품명, 매입금액
 (일반조인)
  SELECT B.BUYER_ID AS 거래처번호,
         B.BUYER_NAME AS 거래처명,
         P.PROD_NAME AS 제품명,
         SUM(C.CART_QTY*P.PROD_COST) AS 매입금액합계
    FROM BUYER B, CART C, PROD P
   WHERE C.CART_PROD=P.PROD_ID
     AND C.CART_NO LIKE '2020%'
   GROUP BY B.BUYER_ID, B.BUYER_NAME, P.PROD_NAME
   ORDER BY 1;
 (ANSI조인)
 SELECT B.BUYER_ID AS 거래처번호,
       B.BUYER_NAME AS 거래처명,
       P.PROD_NAME AS 제품명,
       SUM(C.CART_QTY*P.PROD_COST) AS 매입금액합계
  FROM BUYER B
  INNER JOIN CART C ON B.BUYER_?? = C.CART_??
  INNER JOIN PROD P ON C.CART_PROD = P.PROD_ID
  WHERE C.CART_NO LIKE '2020%'
  GROUP BY B.BUYER_ID, B.BUYER_NAME, P.PROD_NAME
  ORDER BY 1;
  -- 거래처와 판매금액의 공통 컬럼을 찾지 못해서 매입금액으로 수정하고 판매
  -- 금액 대신 단가와 수량을 곱했지만 거래처와 카트 테이블의 공통 컬럼도 찾지 못하겠습니다..
 
 숙제3)회원테이블에서 'l001회원'(구길동)의 마일리지보다 많은 마일리지를 보유한
      회원들을 조회하시오.
      Alias는 회원번호, 회원명, 마일리지
  
  SELECT MEM_ID AS 회원번호,
         MEM_NAME AS 회원명,
         MEM_MILEAGE AS 마일리지
    FROM MEMBER
   WHERE MEM_MILEAGE > (SELECT MEM_MILEAGE FROM MEMBER WHERE MEM_ID = 'l001')
   GROUP BY MEM_ID,MEM_NAME,MEM_MILEAGE
   ORDER BY 1;  

 
    
    
    
    
    
    
    
    
    
    
    
    
    
    