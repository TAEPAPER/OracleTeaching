2022-0121-02)

사용예)장바구니테이블에서 회원별 최대구매수량를 기록한 상품을
      조회하시오
      Alias 회원번호,회원명,상품명,구매수량
 (메인쿼리 : 회원번호,회원명,상품명,구매수량)
  SELECT C.CART_MEMBER AS 회원번호,
         A.MEM_NAME AS 회원명,
         B.PROD_NAME AS 상품명,
         C.CART_QTY AS 구매수량
    FROM MEMBER A, PROD B, CART C
   WHERE C.CART_MEMBER=A.MEM_ID 
     AND C.CART_PROD=B.PROD_ID
     AND C.CART_QTY=(서브쿼리);

 (서브쿼리 : 회원별 최대구매수량)
  SELECT CART_MEMBER,
         MAX(CART_QTY)
    FROM CART
   GROUP BY CART_MEMBER;  
    
 (결합)  
  SELECT C.CART_MEMBER AS 회원번호,
         A.MEM_NAME AS 회원명,
         B.PROD_NAME AS 상품명,
         C.CART_QTY AS 구매수량
    FROM MEMBER A, PROD B, CART C
   WHERE C.CART_MEMBER=A.MEM_ID 
     AND C.CART_PROD=B.PROD_ID
     AND (C.CART_MEMBER,C.CART_QTY)
          IN(SELECT CART_MEMBER,
                    MAX(CART_QTY)
               FROM CART
              GROUP BY CART_MEMBER)
   ORDER BY 1; 
   
  SELECT C.CART_MEMBER AS 회원번호,
         A.MEM_NAME AS 회원명,
         B.PROD_NAME AS 상품명,
         C.CART_QTY AS 구매수량
    FROM MEMBER A, PROD B, CART C
   WHERE C.CART_MEMBER=A.MEM_ID 
     AND C.CART_PROD=B.PROD_ID
     AND C.CART_QTY=(SELECT MAX(D.CART_QTY)
                       FROM CART D
                      WHERE D.CART_MEMBER=C.CART_MEMBER)
   ORDER BY 1;         
   