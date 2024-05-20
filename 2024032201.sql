2024-0322-01)외부조인
 - 내부조인은 조인조건을 만족하지 않는 자료를 무시(자료의 종류가 적은 쪽을 기준)한
   결과를 반환
 - 외부조인은 자료의 종류가 많은 쪽을 기준으로 적은 쪽에 NULL행을 추가하여 조인
   을 수행함
 - 일반 외부조인 경우
   . 조인조건 기술시 자료의 종류가 적은 쪽에 외부조인 연산자 '(+)'를 기술
   . 조인조건이 여러 개이고 모두 외부 조인이 필요한 경우 해당되는 모든 조건에
     '(+)'를 사용해야 함
   . 한 테이블이 동시에 여러 번 외부조인에 사용될 수 없다. 예를 들어 3 테이블
     A, B, C가 외부조인되는 경우 A를 기준으로 B가 외부조인되고, 동시에 C를
     기준으로 B가 외부조인 될 수 없다(A=B(+) AND C=B(+)는 허용 안됨
   . 일반 외부조인에서 일반 조건이 부여되면 결과는 내부조인 결과가 반환됨=>해결책
     으로 ANSI외부조인이나 서브쿼리를 사용해야 함
   
 (일반외부조인 사용형식)
    SELECT 컬럼list,...
      FROM 테이블명1 [별칭1], 테이블명2 [별칭2][,테이블명3 [별칭3],...]
     WHERE [별칭1.]컬럼명=[별칭2.]컬럼명(+)
      [AND [별칭1.]컬럼명=[별칭2.]컬럼명(+)
                    :
 (ANSI반외부조인 사용형식)
   SELECT 컬럼list,...
     FROM 테이블명1 [별칭1]
   LEFT|RIGHT|FULL OUTER JOIN 테이블명2[별칭2] ON(조인조건 [AND 일반조건])
                :
    [WHERE 일반조건]
    . LEFT OUTER JOIN : 테이블명1의 자료의 종류가 테이블명2의 자료의 종류보다 많을 때
    . RIGHT OUTER JOIN : 테이블명1의 자료의 종류가 테이블명2의 자료의 종류보다 적을 때
    . FULL OUTER JOIN : 양쪽 테이블의 자료의 종류가 각각 적을 때
    . WHERE 일반조건 : 모든 테이블에 공통으로 적용되는 조건을 기술해야 함. 이 절을 사용하면
      결과가 내부조인 결과가 반환됨
      
사용 예) 모든 분류별 상품의 수를 조회하시오
        Alias는 분류코드,분류명,상품의 수
    SELECT DISTINCT PROD_LGU
      FROM PROD;
    SELECT LPROD_GU
      FROM LPROD;
      
 (일반외부조인)
    SELECT L.LPROD_GU AS 분류코드,
           L.LPROD_NM AS 분류명,
           COUNT(PROD_ID) AS 상품의수
      FROM LPROD L, PROD P
     WHERE L.LPROD_GU=P.PROD_LGU(+) 
     GROUP BY L.LPROD_GU, L.LPROD_NM
     ORDER BY 1;

 (ANSI FORMAT)
    SELECT L.LPROD_GU AS 분류코드,
           L.LPROD_NM AS 분류명,
           COUNT(PROD_ID) AS 상품의수
      FROM LPROD L 
      LEFT OUTER JOIN PROD P ON(L.LPROD_GU=P.PROD_LGU)
      GROUP BY L.LPROD_GU, L.LPROD_NM
      ORDER BY 1;
     
      

사용 예) 모든 회원별 판매집계를 조회하시오.

사용 예) (NULL 부서코드를 제외하고) 모든 부서별 사원수와 평균급여를 조회하시오.

사용 예) 2020년 7월 모든 회원별 구매금액집계(회원번호, 회원명, 구매금액합계)를
        조회하시오
    SELECT M.MEM_ID AS 회원번호,
           M.MEM_NAME AS 회원명,
           SUM(C.CART_QTY*P.PROD_PRICE) AS 구매금액합계
      FROM MEMBER M, CART C, PROD P
     WHERE M.MEM_ID=C.CART_MEMBER(+)
       AND C.CART_NO LIKE '202007%'
     GROUP BY M.MEM_ID, M.MEM_NAME
     ORDER BY 1;

 (SUBQUERY)
  - 2020년 7월 회원별 구매금액집계
    SELECT A.CART_MEMBER AS CID,
           SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
      FROM CART A, PROD B
     WHERE A.CART_PROD=B.PROD_ID
       AND A.CART_NO LIKE '202007%'
     GROUP BY A.CART_MEMBER;
   -----------------------------------------------------------  
    SELECT M.MEM_ID AS 회원번호,
           M.MEM_NAME AS 회원명,
           NVL(C.CSUM,0) AS 구매금액합계
      FROM MEMBER M, (SELECT A.CART_MEMBER AS CID,
                             SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
                        FROM CART A, PROD B
                       WHERE A.CART_PROD=B.PROD_ID
                         AND A.CART_NO LIKE '202007%'
                    GROUP BY A.CART_MEMBER)C
      WHERE M.MEM_ID=C.CID(+)
      ORDER BY 1;

 (ANSI FORMAT)
    SELECT M.MEM_ID AS 회원번호,
           M.MEM_NAME AS 회원명,
           SUM(C.CART_QTY*P.PROD_PRICE) AS 구매금액합계
      FROM MEMBER M 
      LEFT OUTER JOIN CART C ON(M.MEM_ID=C.CART_MEMBER)
      LEFT OUTER JOIN PROD P ON(C.CART_PROD=PROD_ID
       AND C.CART_NO LIKE '202007%')
     GROUP BY M.MEM_ID, M.MEM_NAME
     ORDER BY 1;
      
숙제4) 2020년 6월 모든 상품별 매입/매출 집계를 조회하시오
     Alias는 상품번호,상품명,매입수량,매입금액,매출수량,매출금액
     (일반외부조인)
     SELECT P.PROD_ID AS 상품번호,
            P.PROD_NAME AS 상품명,
            SUM(B.BUY_QTY) AS 매입수량,
            SUM(B.BUY_QTY*P.PROD_COST) AS 매입금액,
            SUM(C.CART_QTY) AS 매출수량,
            SUM(C.CART_QTY*P.PROD_PRICE) AS 매출금액
       FROM PROD P, BUYPROD B, CART C
      WHERE P.PROD_ID=B.BUY_PROD(+)
        AND P.PROD_ID=C.CART_PROD(+)
        AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
        AND C.CART_NO LIKE '202004%'
      GROUP BY P.PROD_ID, P.PROD_NAME
      ORDER BY 1;
      
    (ANSI조인)
    SELECT P.PROD_ID AS 상품번호,
           P.PROD_NAME AS 상품명,
           NVL(SUM(B.BUY_QTY),0) AS 매입수량,
           NVL(SUM(B.BUY_QTY*P.PROD_COST),0) AS 매입금액,
           NVL(SUM(C.CART_QTY),0) AS 매출수량,
           NVL(SUM(C.CART_QTY*P.PROD_PRICE),0) AS 매출금액
      FROM PROD P 
      LEFT OUTER JOIN BUYPROD B ON(P.PROD_ID=B.BUY_PROD
      AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
      LEFT OUTER JOIN CART C ON(P.PROD_ID=C.CART_PROD
      AND C.CART_NO LIKE '202004%')
    GROUP BY P.PROD_ID, P.PROD_NAME
    ORDER BY 1;
    
    (SUBQUERY )
  SELECT A.PROD_ID AS 상품번호,
         A.PROD_NAME AS 상품명,
         NVL(B.BQTY,0) AS 매입수량,
         NVL(B.BSUM,0) AS 매입금액,
         NVL(C.CQTY,0) AS 매출수량,
         NVL(C.CSUM,0) AS 매출금액
    FROM PROD A, 
         (SELECT A.BUY_PROD AS BID,
                 SUM(A.BUY_QTY) AS BQTY,
                 SUM(A.BUY_QTY*B.PROD_COST) AS BSUM
            FROM BUYPROD A, PROD B
           WHERE A.BUY_PROD=B.PROD_ID
             AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20201231')  
           GROUP BY A.BUY_PROD)B, 
         (SELECT A.CART_PROD AS CID,
                 SUM(A.CART_QTY) AS CQTY,
                 SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
            FROM CART A, PROD B
           WHERE A.CART_PROD=B.PROD_ID
             AND A.CART_NO LIKE '2020%'  
           GROUP BY A.CART_PROD) C
   WHERE A.PROD_ID=B.BID(+)
     AND A.PROD_ID=C.CID(+)
   ORDER BY 1;  
   
(ANSI FORMAT)   
  SELECT A.PROD_ID AS 상품번호,
         A.PROD_NAME AS 상품명,
         NVL(B.BQTY,0) AS 매입수량,
         NVL(B.BSUM,0) AS 매입금액,
         NVL(C.CQTY,0) AS 매출수량,
         NVL(C.CSUM,0) AS 매출금액
    FROM PROD A 
    LEFT OUTER JOIN (SELECT A.BUY_PROD AS BID,
                            SUM(A.BUY_QTY) AS BQTY,
                            SUM(A.BUY_QTY*B.PROD_COST) AS BSUM
                       FROM BUYPROD A, PROD B
                      WHERE A.BUY_PROD=B.PROD_ID
                        AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20201231')  
                      GROUP BY A.BUY_PROD)B
          ON(A.PROD_ID = B.BID)
    LEFT OUTER JOIN (SELECT A.CART_PROD AS CID,
                            SUM(A.CART_QTY) AS CQTY,
                            SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
                       FROM CART A, PROD B
                      WHERE A.CART_PROD=B.PROD_ID
                        AND A.CART_NO LIKE '2020%'  
                      GROUP BY A.CART_PROD) C
          ON(A.PROD_ID = C.CID)  
   ORDER BY 1;