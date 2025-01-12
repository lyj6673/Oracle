2024-0408-01)User Defind Function(Function)
 - 반환 값이 존재함
 - 복잡한 서브쿼리나 자주 사용되는 계산식을 만들어 컴파일하여 일반 API 함수
   처럼 사용
 - 반환 값의 자료타입을 RETURN 문으로 선언해야하며,
   실행영역에서 실제 자료를 반환하는 RETURN 문이 하나 이상 존재해야 함
 - 기타 특징은 PROCEDURE와 동일
 
 (사용형식)
 CREATE [OR REPLACE] FUNCTION 함수명[(
   변수 [IN]|OUT|INOUT 데이터타입[,]
                :
   변수 [IN]|OUT|INOUT 데이터타입)]
   RETURN 데이터 타입
   
 IS|AS
    선언영역
 BEGIN
    실행영역
 END;
 
 사용예)회원아이디를 입력 받아 주소를 출력하는 함수를 작성하여 회원번호, 회원명, 주소
       마일리지를 출력하시오.
  CREATE OR REPLACE FUNCTION fn_member_address(
    P_MID IN MEMBER.MEM_ID%TYPE)
    RETURN VARCHAR2
  IS
    L_ADDRESS VARCHAR2(500);
  BEGIN
    SELECT MEM_ADD1||' '||MEM_ADD2 INTO L_ADDRESS
      FROM MEMBER
     WHERE MEM_ID=P_MID;
    RETURN L_ADDRESS;
  END;
  
  [실행]
  SELECT MEM_ID AS 회원번호,
         MEM_NAME AS 회원명,
         fn_member_address(MEM_ID) AS 주소,
         MEM_MILEAGE AS 마일리지
    FROM MEMBER; 
       
       
 사용 예)모든 회원의 2020년 4월 구매실적을 조회하는 함수를 작성하고, 회원번호, 회원명,
        구매금액, 마일리지를 출력하시오.
        
  SELECT A.MEM_ID AS 회원번호,
         A.MEM_NAME AS 회원명,
         NVL(B.CSUM,0) AS 구매금액,
         A.MEM_MILEAGE AS 마일리지
    FROM MEMBER A,
          (SELECT C.CART_MEMBER AS CMID, 
                  SUM(C.CART_QTY*P.PROD_PRICE) AS CSUM
             FROM CART C, PROD P
            WHERE C.CART_PROD=P.PROD_ID
              AND C.CART_NO LIKE '202004%'
            GROUP BY C.CART_MEMBER) B
   WHERE A.MEM_ID=B.CMID(+)
   ORDER BY 1;
   
[함수 : 회원번호를 입력 받아 2020년 4월 구매실적을 조회]
  CREATE OR REPLACE FUNCTION fn_sum_cart202004(
    P_MID MEMBER.MEM_ID%TYPE)
    RETURN NUMBER
  IS
    L_SUM NUMBER:=0;
  BEGIN
    SELECT SUM(C.CART_QTY*PROD_PRICE) INTO L_SUM
      FROM CART C, PROD P
     WHERE C.CART_PROD=P.PROD_ID
       AND C.CART_NO LIKE '202004%'
       AND C.CART_MEMBER=P_MID;
    RETURN L_SUM;
  END;
  
  [함수호출]
  SELECT MEM_ID AS 회원번호,
         MEM_NAME AS 회원명,
         NVL(fn_sum_cart202004(MEM_ID),0) AS 구매금액,
         MEM_MILEAGE AS 마일리지
    FROM MEMBER
   ORDER BY 1;
 -----------------------------------------------------  
CREATE OR REPLACE FUNCTION fn_create_cartno(
    P_DATE IN DATE)
    RETURN VARCHAR2
  IS
    L_FLAG NUMBER:=0;
    L_TMP_CARTNO VARCHAR2(20);
  BEGIN
    SELECT COUNT(*) INTO L_FLAG
      FROM CART
     WHERE SUBSTR(CART_NO,1,8)=TO_CHAR(P_DATE,'YYYYMMDD');
     
     IF L_FLAG=0 THEN
        L_TMP_CARTNO:=TO_CHAR(P_DATE,'YYYYMMDD')||TRIM('00001');
     ELSE
        SELECT TO_CHAR(TO_NUMBER(A.CART_NO)+1) INTO L_TMP_CARTNO
          FROM (SELECT CART_NO
                  FROM CART
                 WHERE SUBSTR(CART_NO,1,8)=TO_CHAR(P_DATE,'YYYYMMDD')
                 ORDER BY 1 DESC)A
         WHERE ROWNUM = 1;
    END IF;
    RETURN L_TMP_CARTNO;
    END;

