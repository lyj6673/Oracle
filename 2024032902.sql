2024-0329-02)SYNONYM(동의어) 객체
 - 오라클에 사용되는 객체에 또 다른 이름을 부여
 - SELECT문의 컬럼 별칭이나 테이블 별칭은 해당 쿼리의 해당 구역에서
   유효하나 동의어 객체는 DBMS가 실행 할 수 있는 모든 곳에서 적용됨
 - 다른 소유자의 객체를 접근할 때 "스키마명.객체명"으로 접근하여 긴 접근이름이
   필요하다. 이를 대신할 수 있는 기능이 동의어임

(사용 예)
    CREATE [OR REPLACE] SYNONYM 동의어이름 FOR 객체명
    
    CREATE OR REPLACE SYNONYM EMP FOR HR.EMPLOYEES;
    
    급여가 3000 미만인 사원조회
    
    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           SALARY AS 급여
      FROM EMP     --"HR".EMPLOYEES
     WHERE SALARY<3000;