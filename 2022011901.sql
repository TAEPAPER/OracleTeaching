2022-0119-01)
 
문제]사원테이블 등을 이용하여 미국내에 위치한 부서별 
    사원수와 평균임금을 조회하시오.
    Alias는 부서번호,부서명,사원수,평균임금이다.
    SELECT A.DEPARTMENT_ID AS 부서번호,
           B.DEPARTMENT_NAME AS 부서명,
           COUNT(*) AS 사원수,
           ROUND(AVG(A.SALARY)) AS 평균임금
      FROM HR.EMPLOYEES A,HR.DEPARTMENTS B,HR.LOCATIONS C,
           HR.COUNTRIES D 
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
       AND B.LOCATION_ID=C.LOCATION_ID
       AND C.COUNTRY_ID=D.COUNTRY_ID
       AND LOWER(D.COUNTRY_NAME) LIKE '%america%'
     GROUP BY A.DEPARTMENT_ID,B.DEPARTMENT_NAME
     ORDER BY 1;
     
문제]2005년 4-6월 상품별 매입현황조회
    Alias는 상품코드,상품명,매입수량합계,매입금액합계
    SELECT A.PROD_ID AS 상품코드,
           A.PROD_NAME AS 상품명,
           SUM(C.BUY_QTY*A.PROD_COST) AS 매입금액합계
      FROM PROD A, BUYPROD C
     WHERE C.BUY_PROD=A.PROD_ID
       AND C.BUY_DATE BETWEEN TO_DATE('20050401') AND 
           TO_DATE('20050630')
     GROUP BY A.PROD_ID,A.PROD_NAME
     ORDER BY 1;    
    
문제]2005년 4-6월 상품별 매출현황조회
    Alias는 상품코드,상품명,매출수량합계,매출금액합계
    
문제]2005년 4-6월 상품별 매입/매출현황조회
    Alias는 상품코드,상품명,매입금액합계,매출금액합계
    SELECT A.PROD_ID AS 상품코드,
           A.PROD_NAME AS 상품명,
           SUM(C.BUY_QTY*A.PROD_COST) AS 매입금액합계,
           SUM(A.PROD_PRICE*B.CART_QTY) AS 매출금액합계
      FROM PROD A, CART B, BUYPROD C
     WHERE A.PROD_ID=B.CART_PROD
       AND C.BUY_PROD=A.PROD_ID
       AND SUBSTR(B.CART_NO,1,6) BETWEEN '200504' AND '200506'
       AND C.BUY_DATE BETWEEN TO_DATE('20050401') AND 
           TO_DATE('20050630')
     GROUP BY A.PROD_ID,A.PROD_NAME
     ORDER BY 1;
     
  (ANSI FORMAT)   
    SELECT A.PROD_ID AS 상품코드,
           A.PROD_NAME AS 상품명,
           SUM(C.BUY_QTY*A.PROD_COST) AS 매입금액합계,
           SUM(A.PROD_PRICE*B.CART_QTY) AS 매출금액합계
      FROM PROD A
     INNER JOIN BUYPROD C ON(C.BUY_PROD=A.PROD_ID AND 
           C.BUY_DATE BETWEEN TO_DATE('20050401') AND 
           TO_DATE('20050630'))
     INNER JOIN CART B ON(A.PROD_ID=B.CART_PROD AND 
           SUBSTR(B.CART_NO,1,6) BETWEEN '200504' AND '200506')                      
     GROUP BY A.PROD_ID,A.PROD_NAME
     ORDER BY 1;     
  
  (SUBQUERY)   
    SELECT A.PROD_ID AS 상품코드,
           A.PROD_NAME AS 상품명,
           BSUM AS 매입금액합계,
           CSUM AS 매출금액합계
      FROM PROD A,
           (SELECT CC.BUY_PROD AS BID,
                   SUM(CC.BUY_QTY*BB.PROD_COST) AS BSUM
              FROM PROD BB, BUYPROD CC
             WHERE BB.PROD_ID=CC.BUY_PROD
               AND CC.BUY_DATE BETWEEN TO_DATE('20050401') AND 
                   TO_DATE('20050630')
             GROUP BY CC.BUY_PROD) B,
           (SELECT CC.CART_PROD AS CID,
                   SUM(CC.CART_QTY*BB.PROD_PRICE) AS CSUM
              FROM PROD BB, CART CC
             WHERE BB.PROD_ID=CC.CART_PROD
               AND SUBSTR(CC.CART_NO,1,6) BETWEEN '200504' AND 
                   '200506'
             GROUP BY CC.CART_PROD) C
     WHERE A.PROD_ID=B.BID(+)
       AND A.PROD_ID=C.CID(+)
     ORDER BY 1;
     
문제]장바구니테이블(CART)에서 2005년 매출자료를 분석하여
    거래처별, 상품별 매출현황을 조회하시오
    Alias는 거래처코드,거래처명,상품명,매출수량,매출금액
    SELECT C.BUYER_ID AS 거래처코드,
           C.BUYER_NAME AS 거래처명,
           B.PROD_NAME AS 상품명,
           SUM(A.CART_QTY) AS 매출수량,
           SUM(A.CART_QTY*B.PROD_PRICE) AS 매출금액
      FROM CART A, PROD B, BUYER C
     WHERE A.CART_PROD=B.PROD_ID
       AND B.PROD_BUYER=C.BUYER_ID
   --    AND A.CART_NO LIKE '2005%'
       AND SUBSTR(A.CART_NO,1,4) = '2005'
     GROUP BY C.BUYER_ID,C.BUYER_NAME,B.PROD_NAME
     ORDER BY 1;
  
  (ANSI FORMAT)
    SELECT C.BUYER_ID AS 거래처코드,
           C.BUYER_NAME AS 거래처명,
           B.PROD_NAME AS 상품명,
           SUM(A.CART_QTY) AS 매출수량,
           SUM(A.CART_QTY*B.PROD_PRICE) AS 매출금액
      FROM CART A
     INNER JOIN PROD B ON(A.CART_PROD=B.PROD_ID AND
           SUBSTR(A.CART_NO,1,4) = '2005')
     INNER JOIN BUYER C ON(B.PROD_BUYER=C.BUYER_ID)  
     GROUP BY C.BUYER_ID,C.BUYER_NAME,B.PROD_NAME
     ORDER BY 1;  
    
    
    
    