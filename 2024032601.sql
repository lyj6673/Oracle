2024-0326-01) 서브쿼리

사용 예)HR계정의 사원테이블에서 부서의 위치가 미국에 위치한 부서에 속한 사원의
       평균 급여보다 더 많은 급여를 받는 미국 이외의 부서에 근무하는 사원정보를
       조회하시오.
       Alias는 사원번호, 사원명, 부서명, 급여
(서브쿼리 : 미국에 위치한 부서에 속한 사원의 평균 급여)
    SELECT AVG(A.SALARY)
      FROM HR.EMPLOYEES A,HR.DEPARTMENTS B, HR.LOCATIONS C
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
       AND B.LOCATION_ID=C.LOCATION_ID
       AND C.COUNTRY_ID='US'
(메인쿼리 : 사원번호,사원명,부서명,급여(조건: 미국이외에 위치한 부서에 근무 & 서브쿼리에서
           계산된 평균급여보다 급여가 많은 사원)
  SELECT A1.EMPLOYEE_ID AS 사원번호,
         A1.EMP_NAME AS 사원명,
         B1.DEPARTMENT_NAME AS 부서명,
         ROUND(D1.ASAL) AS 평균급여,
         A1.SALARY AS 급여
    FROM HR.EMPLOYEES A1,HR.DEPARTMENTS B1, HR.LOCATIONS C1,
    (SELECT AVG(A.SALARY) AS ASAL
      FROM HR.EMPLOYEES A,HR.DEPARTMENTS B, HR.LOCATIONS C
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
       AND B.LOCATION_ID=C.LOCATION_ID
       AND C.COUNTRY_ID='US')D1
     WHERE A1.DEPARTMENT_ID=B1.DEPARTMENT_ID
       AND B1.LOCATION_ID=C1.LOCATION_ID
       AND C1.COUNTRY_ID!='US'
       AND A1.SALARY>D1.ASAL
       ORDER BY D1.DEPARTMENT_ID, A1.SALARY;
사용 예)회원테이블에서 마일리지가 많은 5명의 회원이 2020년 4월 구매한 정보를 
       조회하시오. Alias는 회원번호,회원명,구매금액합계
(서브쿼리 : 마일리지가 많은 5명의 회원의 회원번호)
      SELECT A.MEM_ID, A.MEM_NAME 
        FROM (SELECT MEM_ID, MEM_MILEAGE, MEM_NAME
                FROM MEMBER
               WHERE MEM_MILEAGE IS NOT NULL
               ORDER BY MEM_MILEAGE DESC)A
        WHERE ROWNUM<=5
(메인쿼리 : 5면의 회원이 2020년 5월 구매한 정보)
    SELECT C.CART_MEMBER AS 회원번호,
           M.MEM_NAME AS 회원명,
           SUM(C.CART_QTY*P.PROD_PRICE) AS 구매금액합계
      FROM CART C, MEMBER M, PROD P
     WHERE C.CART_MEMBER=M.MEM_ID
       AND C.CART_PROD=P.PROD_ID
       AND C.CART_NO LIKE '202004%'
       AND C.CART_MEMBER IN(SELECT A.MEM_ID
                              FROM (SELECT MEM_ID, MEM_MILEAGE, MEM_NAME
                                      FROM MEMBER
                                     WHERE MEM_MILEAGE IS NOT NULL
                                     ORDER BY MEM_MILEAGE DESC)A
                                     WHERE ROWNUM<=5)
    GROUP BY C.CART_MEMBER,M.MEM_NAME
    ORDER BY 3 DESC;
        
       
사용 예)부서테이블에서 부서관리사원이 사원번호가 100인 부서에 속한 사원정보를
       조회하시오
    (서브쿼리 : 부서관리사원의 사원번호가 100인 부서의 부서번호)
       SELECT DEPARTMENT_ID
         FROM HR.DEPARTMENTS
        WHERE MANAGER_ID=100;
    
    (메인쿼리 : 서브쿼리의 결과에 속한 부서의 사원정보)
        SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명,
               DEPARTMENT_ID AS 부서번호
          FROM HR.EMPLOYEES
         WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID
                                  FROM HR.DEPARTMENTS
                                 WHERE MANAGER_ID=100);
                        
                                 
  (EXISTS 연산자 사용)                               
         SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           A.DEPARTMENT_ID AS 부서번호
      FROM HR.EMPLOYEES A
     WHERE EXISTS (SELECT 1
                     FROM HR.DEPARTMENTS B
                    WHERE B.MANAGER_ID=100);
                      AND A.DEPARTMENT_ID=B.DEPARTMENT_ID);
        

사용 예)사원테이블에서 각 부서별 평균급여보다 더 많은 급여를 받는 사원정보를
       조회하시오
       Alias는 사원번호,사원명,부서번호,부서평균급여,급여
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              A.DEPARTMENT_ID AS 부서번호,
              (SELECT ROUND(AVG(C.SALARY))
                 FROM HR.EMPLOYEES C
                WHERE C.DEPARTMENT_ID=A.DEPARTMENT_ID) AS 부서평균급여,
              A.SALARY AS 급여
         FROM HR.EMPLOYEES A
        WHERE A.SALARY>(SELECT AVG(SALARY)
                          FROM HR.EMPLOYEES B
                         WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID)
         ORDER BY 3, 5 DESC;
         
         (EXISTS 연산자 사용)
         SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              A.DEPARTMENT_ID AS 부서번호,
              (SELECT ROUND(AVG(C.SALARY))
                 FROM HR.EMPLOYEES C
                WHERE C.DEPARTMENT_ID=A.DEPARTMENT_ID) AS 부서평균급여,
              A.SALARY AS 급여
         FROM HR.EMPLOYEES A
        WHERE EXISTS(SELECT 1
                          FROM HR.EMPLOYEES B
                         WHERE A.SALARY>(SELECT AVG(C.SALARY)
                                           FROM HR.EMPLOYEES C
                                          WHERE A.DEPARTMENT_ID=C.DEPARTMENT_ID))
         ORDER BY 3, 5 DESC;
         