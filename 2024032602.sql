2024-0326-02)서브쿼리를 이용한 DML 명령
1. UPDATE 명령
 (사용형식)
  UPDATE 테이블명
     SET (컬럼명,컬럼명,...)=(서브쿼리)
  [WHERE 조건];
   - SET 절에 하나 이상의 컬럼을 기술하려면 반드시 ()안에 기술해야하고
     서브쿼리의 SELECT 절의 컬럼과 갯수, 순서가 반드시 일치해야함
     
사용 예) 2020년 1-3월 제품별 매입수량을 구하여 재고수불 테이블을 갱신하시오
        단, 처리일자는 2020/01/31이다.
    UPDATE REMAIN A
       SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE)=
       (SELECT A.REMAIN_I+B.BQTY, A.REMAIN_J_99+B.BQTY,TO_DATE('20200131')
          FROM (SELECT BUY_PROD,
                       SUM(BUY_QTY) AS BQTY --입고수량
                  FROM BUYPROD
                 WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
                 GROUP BY BUY_PROD)B
           WHERE B.BUY_PROD=A.PROD_ID)
    WHERE A.PROD_ID IN(SELECT DISTINCT BUY_PROD
                         FROM BUYPROD
                        WHERE BUY_DATE BETWEEN TO_DATE('20200101')
                            AND TO_DATE('20200131'));

숙제] 2020년 2-7월 제품별 매입/매출 수량을 조회하여 재고수불테이블을 갱신하시오
     단, 갱신일은 2020/07/31이다
     
     UPDATE REMAIN A
       SET (A.REMAIN_I, A.REMAIN_O, A.REMAIN_J_99, A.REMAIN_DATE)=
       (SELECT A.REMAIN_I+B.BQTY, A.REMAIN_O+CQTY, A.REMAIN_J_99+B.BQTY-CQTY,TO_DATE('20200731')
          FROM (SELECT BUY_PROD,
                       SUM(BUY_QTY) AS BQTY --입고수량
                  FROM BUYPROD
                 WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200731')
                 GROUP BY BUY_PROD)B,
                 (SELECT CART_PROD,
                       SUM(CART_QTY) AS CQTY --출고수량
                  FROM CART
                 WHERE TO_NUMBER(SUBSTR(CART_NO,5,2)) BETWEEN 2 AND 7
                 GROUP BY CART_PROD)C
           WHERE B.BUY_PROD=A.PROD_ID
             AND C.CART_PROD=A.PROD_ID)
    WHERE A.PROD_ID IN(SELECT DISTINCT BUY_PROD
                         FROM BUYPROD
                        WHERE BUY_DATE BETWEEN TO_DATE('20200101')
                              AND TO_DATE('20200731'))
      AND A.PROD_ID IN(SELECT DISTINCT CART_PROD
                         FROM CART
     WHERE TO_NUMBER(SUBSTR(CART_NO, 5, 2)) BETWEEN 2 AND 7);

ROLLBACK;
COMMIT;
(서브쿼리 1 : 2020년 2-7월까지 제품별 매입수량 집계)
    SELECT BUY_PROD,
           SUM(BUY_QTY)
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200731')
     GROUP BY BUY_PROD

(서브쿼리 2 : 2020년 2-7월까지 제품별 매출수량 집계)
    SELECT CART_PROD,
           SUM(CART_QTY)
      FROM CART
     WHERE SUBSTR(CART_NO,1,6) BETWEEN '202002' AND '202007'
     GROUP BY CART_PROD

서브쿼리 : 모든 제품별 매입/매출수량 반환 (서브쿼리1,2와 RPOD를 OUTER JOIN)

    SELECT A.PROD_ID, B.BSUM, C.CSUM
      FROM PROD A, 
           (SELECT BUY_PROD,
                   SUM(BUY_QTY) AS BSUM
              FROM BUYPROD
             WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200731')
             GROUP BY BUY_PROD)B,
            (SELECT CART_PROD,
                    SUM(CART_QTY) AS CSUM
               FROM CART
              WHERE SUBSTR(CART_NO,1,6) BETWEEN '202002' AND '202007'
              GROUP BY CART_PROD)C
      WHERE A.PROD_ID=B.BUY_PROD(+)
        AND A.PROD_ID=C.CART_PROD(+)
      ORDER BY 1;
      
(재고수불테이블 갱신)
    UPDATE REMAIN R
       SET (R.REMAIN_I, R.REMAIN_O, R.REMAIN_J_99, R.REMAIN_DATE)=
            (SELECT R.REMAIN_I+TA.BBSUM, R.REMAIN_O+TA.CCSUM,
                    R.REMAIN_J_99+TA.BBSUM-TA.CCSUM,TO_DATE('20200731')
               FROM (SELECT A.PROD_ID AS AID, 
                               NVL(B.BSUM,0) AS BBSUM,
                               NVL(C.CSUM,0) AS CCSUM
                       FROM PROD A, 
                            (SELECT BUY_PROD,
                                    SUM(BUY_QTY) AS BSUM
                               FROM BUYPROD
                              WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200731')
                              GROUP BY BUY_PROD)B,
                             (SELECT CART_PROD,
                                     SUM(CART_QTY) AS CSUM
                                FROM CART
                               WHERE SUBSTR(CART_NO,1,6) BETWEEN '202002' AND '202007'
                               GROUP BY CART_PROD)C
                       WHERE A.PROD_ID=B.BUY_PROD(+)
                         AND A.PROD_ID=C.CART_PROD(+))TA
               WHERE TA.AID=R.PROD_ID);
               
               
               
               
               
               ROLLBACK;
             
      
      








사용예)1. 회원테이블에 상품별 마일리지가 NULL인 상품을 찾아 '0'으로 치환하시오
(서브쿼리 : 상품별 마일리지가 NULL인 상품)
    SELECT PROD_ID
      FROM PROD
     WHERE PROD_MILEAGE IS NULL;
     
(메인쿼리)
      2. 회원테이블의 마일리지를 모두 0으로 갱신하시오
       UPDATE MEMBER
          SET MEM_MILEAGE=0;
      3. 2020년 회원별 상품별 구매수량을 조회하여 마일리지를 새로 부여하시오.
    (서브쿼리 : 2020년 회원별 구매수량에 의한 마일리지 계산)
    SELECT B.CART_MEMBER,
         SUM(B.CSUM*A.PROD_MILEAGE) AS BSUM
    FROM PROD A,
         (SELECT CART_MEMBER,
                 CART_PROD,
                 SUM(CART_QTY) AS CSUM
            FROM CART
           WHERE CART_NO LIKE '2020%'
           GROUP BY CART_MEMBER, CART_PROD)B
   WHERE A.PROD_ID=B.CART_PROD
   GROUP BY B.CART_MEMBER
   ORDER BY 1
 
SELECT CART_MEMBER,
       CART_PROD,
       SUM(CART_QTY) AS CSUM
  FROM CART
 WHERE CART_NO LIKE '2020%'
 GROUP BY CART_MEMBER, CART_PROD
 ORDER BY 1
    
 메인쿼리 : 회원테이블의 마일리지 갱신
  UPDATE MEMBER
     SET MEM_MILEAGE = (
         SELECT TA.BSUM
           FROM (SELECT B.CART_MEMBER AS BID,
                    SUM(B.CSUM*A.PROD_MILEAGE) AS BSUM
                   FROM PROD A,
                        (SELECT CART_MEMBER,
                                CART_PROD,
                                SUM(CART_QTY) AS CSUM
                           FROM CART
                          WHERE CART_NO LIKE '2020%'
                          GROUP BY CART_MEMBER, CART_PROD)B
                          WHERE A.PROD_ID=B.CART_PROD
                          GROUP BY B.CART_MEMBER)TA
          WHERE TA.BID=MEM_ID)
   WHERE MEM_ID IN (SELECT DISTINCT CART_MEMBER
                      FROM CART
                     WHERE CART_NO LIKE '2020%')
                       
** 상품테이블에서 판매가에서 매입가를 뺀 값의 0.1%값을 구하여 상품의 마일리지로 갱신
  SELECT ROUND(((PROD_PRICE-PROD_COST)*0.001),1)
    FROM PROD
    
  UPDATE PROD A
     SET PROD_MILEAGE=(SELECT ROUND(((B.PROD_PRICE-B.PROD_COST)*0.001),-1)
                         FROM PROD B
                        WHERE A.PROD_ID=B.PROD_ID);
                       

