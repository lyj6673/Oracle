2024-0311-01)
사용 예) 사원테이블(HR.EMPLOYEES)에서 사원번호(EMPLOYEE_ID), 사원명(EMP_NAME), 
        부서코드(DEPARTMENT_ID), 급여(SALARY)를 조회하시오.
        단, 급여가 가장 많은 사원부터 출력하시오
         SELECT EMPLOYEE_ID AS 사원번호,
                EMP_NAME AS 사원명,
                DEPARTMENT_ID AS 부서번호,
                SALARY AS 급여
                FROM HR.EMPLOYEES ORDER BY SALARY DESC;

사용예) 위 문제에서 부서코드 순서별로(작은부서->큰부서코드),   같은 부서에서는 급여가 많은 사원순으로 출력하시오.
        SELECT EMPLOYEE_ID AS 사원번호,
                EMP_NAME AS 사원명,
                DEPARTMENT_ID AS 부서번호,
                SALARY AS 급여
        FROM HR.EMPLOYEES ORDER BY DEPARTMENT_ID ASC, SALARY DESC;
        
 사용예) 회원테이블에서 회원번호, 회원명, 마일리지를 조회하되
        마일리지가 많은 회원부터 출력하시오.
        SELECT MEM_ID AS 회원번호,
                MEM_NAME AS 회원명,
                MEM_MILEAGE AS "보유 마일리지"
                FROM MEMBER ORDER BY MEM_MILEAGE DESC;