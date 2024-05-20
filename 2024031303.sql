2024-0313-03)문자열 함수

1. CONCAT(C1, C2)
 - 주어진 문자열 c1과 c2를 결합하여 새로운 문자열 반환
 - 결합 연산자 '||'로 대치
 
 사용 예)회원테이블에서 주민등록번호의 표현을 'xxxxxx-xxxxxxx'으로 출력하시오
        Alias는 회원번호, 회원명, 주민등록번호
        
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명, 
           CONCAT(CONCAT(MEM_REGNO1,'-'),MEM_REGNO2) AS 주민등록번호
      FROM MEMBER;

 사용 예)거래처테이블(BUYER)에서 거래처 정보를 조회하시오. 단, 주소는
        기본주소와 상세주소 사이에 공백 2개를 삽입하여 출력하시오.
        Alias는 거래처번호, 거래처명, 주소, 담당자

     SELECT BUYER_ID AS 거래처번호,
           BUYER_NAME AS 거래처명, 
           CONCAT(CONCAT(BUYER_ADD1,'  '),BUYER_ADD2) AS 주소,
           BUYER_BANKNAME AS 담당자
      FROM BUYER;   
      
2. LOWER(c1), UPPER(c1), INITCAP(c1)
 - 주어진 문자열 c1의 철자를 대문자로(upper), 소문자로(lower),
   단어의 첫 글자만 대문자로(initcap) 바꾸는 함수
   
3. LPAD(c1,n [,c2]), RPAD(c1,n [,c2])
 - 주어진 문자열 c1을 n 자리만큼 확보된 기억공간에서
   오른쪽부터 저장하고 남는 왼쪽에(LPAD), 문자열 'c2'를 모두 채움
   문자열 'c2'가 생략되면 공백으로 채움
   - 주어진 문자열 c1을 n 자리만큼 확보된 기억공간에서
   왼쪽부터 저장하고 남는 오른쪽에(RPAD), 문자열 'c2'를 모두 채움
   문자열 'c2'가 생략되면 공백으로 채움
   
4. LTRIM(c1 [,c2]), RTRIM(c1 [,c2])
 - 주어진 문자열 c1에서 우측(RTRIM) 또는 좌측(LTRIM)에서 c2를 찾아 제거함
 - c2가 생략되면 공백을 제거함
 - 문자열 내부의 공백은 제거하지 못함
 
5. TRIM(c1)
 - c1문자열의 왼쪽과 오른쪽에 존재하는 무효의 공백을 제거함
 
6. SUBSTR(c1, m[,n])
 - 주어진 문자열 c1에서 m번째 문자부터 n개의 문자를 추출함
 - n이 생략되거나 기술한 문자의 갯수보다 큰 값이면 m부터 나머지 모든
   문자가 추출
 - m이 음수이면 오른쪽부터 기산하여 처리함
 
 7. REPLACE(c1, c2 [c3])
  - 문자나 문자열을 치환하기 위한 함수
  - c1 문자열에서 c2를 찾아 c3로 치환
  - c3가 생략되면 찾은 c2를 제거함(c2가 공백이면 공백을 제거)
  
사용 예)상품테이블에서 'p301'분류에 속한 상품정보를 조회하시오.
       Alias는 상품코드, 상품명, 분류코드, 매출단가
    
    SELECT PROD_ID AS 상품코드,
           PROD_NAME AS 상품명,
           PROD_LGU AS 분류코드,
           PROD_PRICE AS 매출단가
      FROM PROD
     WHERE LOWER(PROD_LGU) = 'p301'; 
       
사용 예)키보드로 회원번호를 입력받아 해당 회원정보를 조회
       Alias는 회원번호, 회원명, 주소, 마일리지
       ACCEPT P_PID PROMPT '회원번호 : '
       DECLARE
        L_NAME MEMBER.MEM_NAME%TYPE;
        L_ADDR VARCHAR2(200);
        L_MILEAGE NUMBER:=0;
       BEGIN
        SELECT MEM_NAME, MEM_ADD1||' '||MEM_ADD2, MEM_MILEAGE
          INTO L_NAME, L_ADDR, L_MILEAGE
          FROM MEMBER
         WHERE MEM_ID=LOWER(RTRIM('&P_PID'));
       
         DBMS_OUTPUT.PUT_LINE('------------------------');
         DBMS_OUTPUT.PUT_LINE('회원번호 : '||'&P_PID');
         DBMS_OUTPUT.PUT_LINE('회원명 : '||L_NAME);
         DBMS_OUTPUT.PUT_LINE('주소 : '||L_ADDR);
         DBMS_OUTPUT.PUT_LINE('마일리지 : '||L_MILEAGE);
         DBMS_OUTPUT.PUT_LINE('------------------------');
       END;
       
사용 예)상품테이블에서 분류코드 'p102'에 속한 상품 정보를 조회하시오
       Alias는 상품코드, 상품명, 매입단가, 매출단가이며
       매입/매출 단가는 10자리(Byte)에 오른쪽 정렬 후 왼쪽에 '*'문자열을
       삽입하시오
    SELECT PROD_ID AS 상품코드,
           PROD_NAME AS 상품명,
           LPAD(PROD_COST,10,'*') AS 매입단가,
           LPAD(LTRIM(TO_CHAR(PROD_PRICE,'9,999,999')),15,'*')AS 매출단가
      FROM PROD
     WHERE UPPER(PROD_LGU)='P102';
       
사용 예)회원테이블에서 충남에 거주하는 회원정보를 조회하시오
       Alias는 회원번호, 회원명, 주민등록번호, 주소이며
       두번째 주민등록번호 중 첫 자리를 제외한 나머지 6글자는 모두 '*'로
       출력하시오.
 (조건 : 충남에 거주하는 회원)
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_REGNO1||'-'||RPAD(SUBSTR(MEM_REGNO2,1,1),7,'*') AS 주민등록번호,
           MEM_ADD1||' '||MEM_ADD2 AS 주소
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '충남%';
     
사용 예)오늘이 2020년 5월 7일이라고 간주하고 장바구니 테이블에 사용할 
       장바구니 번호를 생성하시오.
    SELECT TO_CHAR(SYSDATE,'YYYYMMDD')||
           TRIM(TO_CHAR(TO_NUMBER(SUBSTR(MAX(CART_NO),9))+1,'00000'))
      FROM CART
     WHERE SUBSTR(CART_NO,1,8)= TO_CHAR(SYSDATE,'YYYYMMDD')
     
     SELECT MAX(CART_NO)+1
      FROM CART
     WHERE SUBSTR(CART_NO,1,8)= TO_CHAR(SYSDATE,'YYYYMMDD')
     
사용 예)상품테이블에서 상품명 중 '대우'를 찾아 'DW'로 치환하고, 또 상품명에
       포함된 모든 공백을 삭제하여 출력하시오
       Alias는 상품코드, 상품명, 변경상품명1, 변경상품명2
    SELECT PROD_ID AS 상품코드,
           PROD_NAME AS 상품명,
           REPLACE(PROD_NAME,'대우','DW') AS 변경상품명1,
           REPLACE(PROD_NAME,' ') AS 변경상품명2
      FROM PROD;

       

  