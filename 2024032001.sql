2024-0319-02) ROLLUP과 CUBE
  - GROUP BY 절에서만 사용되어 다양한 집계결과를 반환
  
  1. ROLLUP
  (사용형식)
  
  GROUP BY ROLLUP(컬럼명1, 컬럼명2, ... 컬럼명N)[,컬럼명, ...]
   - 사용된 컬럼명N부터 컬럼명1이 모두 적용된 집계를 반환한 후
     컬럼명N 부터 하나씩 제거한 집계를 반환함
   - 마지막은 모든 칼럼이 적용되지 않은 집계(천제집계)를 반환
   - ROLLUP절에 기술된 컬럼의 수가 N개일 때 N+1개의 집계반환
   - ROLLUP절 전, 후에 컬럼이 올 수가 있으며 이를 '부분 ROLLUP'이라 함
   --레벨 별 집계를 구할 때 사용
   
   
사용예)2020년 월별, 회원별, 제품별 구매수량 합계를 조회하시오
      Alias는 월,회원번호,상품번호,구매수량합계

  SELECT SUBSTR(CART_NO,5,2) 월,
         CART_MEMBER AS 회원번호,
         CART_PROD AS 상품번호,
         SUM(CART_QTY) AS 구매수량합계
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD
   ORDER BY 1, 2, 3;
   
ROLLUP절 사용예)
 
  SELECT SUBSTR(CART_NO,5,2) 월,
         CART_MEMBER AS 회원번호,
         CART_PROD AS 상품번호,
         SUM(CART_QTY) AS 구매수량합계
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY ROLLUP(SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD)
   ORDER BY 1, 2, 3;
   --N은 조건이 제거된 것

  SELECT SUBSTR(CART_NO,5,2) 월,
         CART_MEMBER AS 회원번호,
         CART_PROD AS 상품번호,
         SUM(CART_QTY) AS 구매수량합계
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY SUBSTR(CART_NO,5,2), ROLLUP(CART_MEMBER, CART_PROD)
   ORDER BY 1, 2, 3;
   --SUBSTR(CART_NO,5,2)를 ROLLUP에서 빠지면 해당 조건은 고정이 됨   
   
  2. CUBE
  (사용형식)
  GROUP BY CUBE(컬럼명1, 컬럼명2, ... 컬럼명N)[,컬럼명, ...]
   - 사용된 컬럼들로 조합 가능한 모든 경우의 집계를 반환한 후     
   - 마지막은 모든 칼럼이 적용되지 않은 집계(천제집계)를 반환
   - CUBE절에 기술된 컬럼의 수가 N개일 때 2^N개의 집계반환
   - CUBE절 전, 후에 컬럼이 올 수가 있으며 이를 '부분 CUBE'이라 함   
    
사용예)2020년 월별, 회원별, 제품별 구매수량 합계를 조회하시오
      Alias는 월,회원번호,상품번호,구매수량합계  


GROUP BY절만 사용예)
  SELECT SUBSTR(CART_NO,5,2) 월,
         CART_MEMBER AS 회원번호,
         CART_PROD AS 상품번호,
         SUM(CART_QTY) AS 구매수량합계
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD
   ORDER BY 1, 2, 3;
   --NULL은 조건이 제거된 것

ROLLUP절 사용예)
  SELECT SUBSTR(CART_NO,5,2) 월,
         CART_MEMBER AS 회원번호,
         CART_PROD AS 상품번호,
         SUM(CART_QTY) AS 구매수량합계
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY ROLLUP(SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD)
   ORDER BY 1, 2, 3;
   --NULL은 조건이 제거된 것

CUBE절 사용예) 
  SELECT SUBSTR(CART_NO,5,2) 월,
         CART_MEMBER AS 회원번호,
         CART_PROD AS 상품번호,
         SUM(CART_QTY) AS 구매수량합계
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY CUBE(SUBSTR(CART_NO,5,2), CART_MEMBER, CART_PROD)
   ORDER BY 1, 2, 3;    
   

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
  