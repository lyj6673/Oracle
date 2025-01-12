2024-0408-02)Trigger(트리거)
 - 특정 테이블에 입력/수정/삭제와 같은 이벤트가 발생되면 그 이벤트로 인한
   결과로 다른 테이블에 변경 동작을 자동으로 수행시키는 특수 프로시져
 - 나머지 특징은 procedure의 특징과 동일
 - **트리거 내부에서 DCL(Data Control Language:COMMIT, ROLLBACK, SAVEPOINT 등)
   명령은 사용할 수 없다
 - 행단위 트리커에서 한 트리거 동작이 완료 되기 전에 다른 트리거 호출이 금지(위반하면
   immutable error 발생)
   
 (사용형식)
    CREATE [OR REPLACE] TRIGGER 트리거명
      AFTER|BERORE INSERT|UPDATE|DELETE ON 테이블명
     [FOR EACH ROW]
     [WHEN 조건]
    [DECLARE]
      선언부
      
    BEGIN
      트리거 본문;
    END;
    
 - TRIGGER TIMMING : AFTER - 이벤트가 발생되기 전 트리거 본문 실행
                     BEFORE - 이벤트가 발생된 후 트리거 본문 실행
 - EVENT : INSERT|UPDATE|DELETE
    . 트리거를 유발하는 명령으로 단독으로 사용할 수도 있고 OR 연산자로
      연결한 형태로 사용 가능
      (ex AFTER  INSERT OR UPDATE OR DELETE IN CART--
          CART테이블에 INSERT 또는 UPDATE 도는 DELETE 명령이 실행된 후
          트리거 본문 실행)
  - 트리거 종류
    . 문장단위 트리거 : 트리거가 이벤트 결과에 관계없이 한 번만 실행
                     (immutable error가 발생하지 않음)
                     FOR EACH ROW가 생략되면 문장단위 트리거
                     :NEW,  :OLD와 트리거 함수 INSERTING, UPDATEING, DELETING
                     을 사용할 수 없음
    . 행단위 트리거 : 이벤트의 결과 행마다 트리거 본문 실행
                     (immutable error가 발생할 수 있음)
                     FOR EACH ROW 기술 해야함
                     :NEW,  :OLD와 트리거 함수 INSERTING, UPDATEING, DELETING
                     을 사용
                     
사용 예)분류테이블에서 분류코드 'P501' 자료를 삭제하는 트리거를 작성하시오
       삭제 후 '분류코드가 삭제 됐습니다'를 출력하는 것이 트리거
       => 문장단위 트리거는 결과가 전달되기 위해 COMMIT이나 조회(SELECT)문이
          실행되어야 함
  CREATE OR REPLACE TRIGGER tg_delete_lprod01
    AFTER DELETE LPROD
  BEGIN
    DBMS_OUTPUT.PUT_LINE('분류코드가 삭제되었습니다');
    
  EXCEPTION
    WHEN OTHER THEN
       DBMS_OUTPUT.PUT_LINE('에러발생 : '||SQLERRM);
  END; 
  
  DELETE FROM LPROD WHERE LPROD_GU='P502';
  SELECT 8 FROM LPROD;
        
사용 예)T_MEMBER테이블에서 마일리지가 2000미만인 회원을 삭제하시오
       삭제한 회원정보는 DEL_MEMBER 테이블에 저장하시오.
       
  CREATE OR REPLACE TRIGGER td_dalete_tmember
    BEFORE DELETE ON T_MEMBER
    FOR EACH ROW
  BEGIN
    INSERT INTO DEL_MEMBER(MEM_ID,MEM_NAME,MEM_AILEAGE)
    VALUES(:=OLD.MEM_ID, :OLD.MEM_NAME, :OLD.MEM_MILAGE);
  
  END;
  
  SELECT *
    FORM T_MEMBER
   WHERE MEM_MILEAGE<2000;
   
   DELETE FROM T_MEMBER WHERE MEM_MILEAGE<2000;
    -- T_MEMBER 테이블 통째로 삭제해버림
    SELECT * FROM DEL_MEMBER;
    
사용예)오늘 다음과 같이 매입이 발생되었다. 이를 처리하시오
      ------------------------------
      상품코드              매입수량
      ------------------------------   기초   매입   매출   현재고
      P201000004              5         9     24     9    24
      P202000006             10         9     50    14    45
      P302000023              4        17     24    11    30
      P101000003             15        15     36     7    44
      ------------------------------
    1)매입자료 저장
      INSERT INTO BUYPROD VALUES(SYSDATE, 'P201000004',5);
      INSERT INTO BUYPROD VALUES(SYSDATE, 'P202000006',10);
      INSERT INTO BUYPROD VALUES(SYSDATE, 'P302000023',4);
      INSERT INTO BUYPROD VALUES(SYSDATE, 'P101000003',15);
      
      
    2)트리거
      CREATE OR REPLACE TRIGGER tg_insert_buyprod
        AFTER  INSERT ON BUYPROD
        FOR EACH ROW
      DECLARE
        L_QTY NUMBER:=0;
      BEGIN
        L_QTY:=(:NEW.BUY_QTY);
        
        UPDATE REMAIN A
           SET A.REMAIN_I=A.REMAIN_I+L_QTY,
               A.REMAIN_J_99=A.REMAIN_J_99+L_QTY,
               A.REMAIN_DATE=(:NEW.BUY_DATE)
         WHERE A.PROD_ID = :NEW.BUY_PROD;
      END;

 사용 예)오늘 'm001'회원이 상품 'P302000005'을 20개 구매한 경우/ 일부 반품/
        전체반품을 한 경우를 해결하는 트리거를 작성하시오.
 
   CREATE OR REPLACE TRIGGER tg_cart_change 
     AFTER INSERT OR UPDATE OR DELETE ON CART
     FOR EACH ROW
   DECLARE
     L_QTY NUMBER:=0;
     L_PROD PROD.PROD_ID%TYPE;
     L_DATE DATE;
     L_MID MEMBER.MEM_ID%TYPE; --회원번호
     L_MILEAGE NUMBER:= 0; --마일리지
   BEGIN
     IF INSERTING THEN
        L_QTY:=(:NEW.CART_QTY);
        L_PROD:=(:NEW.CART_PROD);
        L_DATE:=TO_DATE(SUBSTR(:NEW.CART_NO,1,8));
        L_MID:=(:NEW.CART_MEMBER);
    ELSIF UPDATING THEN
        L_QTY:=(:NEW.CART_QTY)-(:OLD.CART_QTY);
        L_PROD:=(:NEW.CART_PROD);
        L_DATE:=TO_DATE(SUBSTR(:NEW.CART_NO,1,8));
        L_MID:=(:NEW.CART_MEMBER);
    ELSIF DELETING THEN
        L_QTY:= -(:NEW.CART_QTY);
        L_PROD:=(:NEW.CART_PROD);
        L_DATE:= TO_DATE(SUBSTR(:OLD.CART_NO,1,8));
        L_MID:=(:OLD.CART_MEMBER);
   END IF;
   
   UPDATE REMAIN
      SET REMAIN_O=REMAIN_O+L_QTY,
          REMAIN_J_99=REMAIN_J_99-L_QTY,
          REMAIN_DATE=L_DATE
    WHERE PROD_ID=L_PROD
      AND REMAIN_YEAR=TO_CHAR(EXTRACT(YEAR FROM L_DATE));
   
   SELECT PROD_MILEAGE*L_QTY INTO L_MILEAGE
     FROM PROD
    WHERE PROD_ID=L_PROD;
    
    --회원마일리지 UPDATE
    UPDATE MEMBER
       SET MEM_MILEAGE=MEM_MILEAGE+L_MILEAGE
     WHERE MEM_ID=L_MID;
      
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error 발생 : '||SQLERRM);
        
    END;
    
  [현재상태]     기초    매입    매출    현재고
 'P302000005'   21     216     24     213
                21     216     44     193
                21     216     39     198
                21     216     24     213
 
    'm001' 4180(마일리지) --> 4380 --> 4330 --> 4180
  
1) 'm001'회원이 상품 'P302000005'을 20개 구매
    INSERT INTO CART VALUES('m001',fn_create_cartno(SYSDATE),
                            'P302000005',20);
1) 'm001'회원이 상품 'P302000005'을 15개만 구매(5개 반품)
    UPDATE CART
       SET CART_QTY=15
     WHERE CART_MEMBER='m001'
       AND CART_NO='2024040900001'
       AND CART_PROD='P302000005';
-- 쓰다 말아서 롤백해둠--
    DELETE CART
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    