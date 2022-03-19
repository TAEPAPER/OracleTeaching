2022-0119-01)
 
����]������̺� ���� �̿��Ͽ� �̱����� ��ġ�� �μ��� 
    ������� ����ӱ��� ��ȸ�Ͻÿ�.
    Alias�� �μ���ȣ,�μ���,�����,����ӱ��̴�.
    SELECT A.DEPARTMENT_ID AS �μ���ȣ,
           B.DEPARTMENT_NAME AS �μ���,
           COUNT(*) AS �����,
           ROUND(AVG(A.SALARY)) AS ����ӱ�
      FROM HR.EMPLOYEES A,HR.DEPARTMENTS B,HR.LOCATIONS C,
           HR.COUNTRIES D 
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
       AND B.LOCATION_ID=C.LOCATION_ID
       AND C.COUNTRY_ID=D.COUNTRY_ID
       AND LOWER(D.COUNTRY_NAME) LIKE '%america%'
     GROUP BY A.DEPARTMENT_ID,B.DEPARTMENT_NAME
     ORDER BY 1;
     
����]2005�� 4-6�� ��ǰ�� ������Ȳ��ȸ
    Alias�� ��ǰ�ڵ�,��ǰ��,���Լ����հ�,���Աݾ��հ�
    SELECT A.PROD_ID AS ��ǰ�ڵ�,
           A.PROD_NAME AS ��ǰ��,
           SUM(C.BUY_QTY*A.PROD_COST) AS ���Աݾ��հ�
      FROM PROD A, BUYPROD C
     WHERE C.BUY_PROD=A.PROD_ID
       AND C.BUY_DATE BETWEEN TO_DATE('20050401') AND 
           TO_DATE('20050630')
     GROUP BY A.PROD_ID,A.PROD_NAME
     ORDER BY 1;    
    
����]2005�� 4-6�� ��ǰ�� ������Ȳ��ȸ
    Alias�� ��ǰ�ڵ�,��ǰ��,��������հ�,����ݾ��հ�
    
����]2005�� 4-6�� ��ǰ�� ����/������Ȳ��ȸ
    Alias�� ��ǰ�ڵ�,��ǰ��,���Աݾ��հ�,����ݾ��հ�
    SELECT A.PROD_ID AS ��ǰ�ڵ�,
           A.PROD_NAME AS ��ǰ��,
           SUM(C.BUY_QTY*A.PROD_COST) AS ���Աݾ��հ�,
           SUM(A.PROD_PRICE*B.CART_QTY) AS ����ݾ��հ�
      FROM PROD A, CART B, BUYPROD C
     WHERE A.PROD_ID=B.CART_PROD
       AND C.BUY_PROD=A.PROD_ID
       AND SUBSTR(B.CART_NO,1,6) BETWEEN '200504' AND '200506'
       AND C.BUY_DATE BETWEEN TO_DATE('20050401') AND 
           TO_DATE('20050630')
     GROUP BY A.PROD_ID,A.PROD_NAME
     ORDER BY 1;
     
  (ANSI FORMAT)   
    SELECT A.PROD_ID AS ��ǰ�ڵ�,
           A.PROD_NAME AS ��ǰ��,
           SUM(C.BUY_QTY*A.PROD_COST) AS ���Աݾ��հ�,
           SUM(A.PROD_PRICE*B.CART_QTY) AS ����ݾ��հ�
      FROM PROD A
     INNER JOIN BUYPROD C ON(C.BUY_PROD=A.PROD_ID AND 
           C.BUY_DATE BETWEEN TO_DATE('20050401') AND 
           TO_DATE('20050630'))
     INNER JOIN CART B ON(A.PROD_ID=B.CART_PROD AND 
           SUBSTR(B.CART_NO,1,6) BETWEEN '200504' AND '200506')                      
     GROUP BY A.PROD_ID,A.PROD_NAME
     ORDER BY 1;     
  
  (SUBQUERY)   
    SELECT A.PROD_ID AS ��ǰ�ڵ�,
           A.PROD_NAME AS ��ǰ��,
           BSUM AS ���Աݾ��հ�,
           CSUM AS ����ݾ��հ�
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
     
����]��ٱ������̺�(CART)���� 2005�� �����ڷḦ �м��Ͽ�
    �ŷ�ó��, ��ǰ�� ������Ȳ�� ��ȸ�Ͻÿ�
    Alias�� �ŷ�ó�ڵ�,�ŷ�ó��,��ǰ��,�������,����ݾ�
    SELECT C.BUYER_ID AS �ŷ�ó�ڵ�,
           C.BUYER_NAME AS �ŷ�ó��,
           B.PROD_NAME AS ��ǰ��,
           SUM(A.CART_QTY) AS �������,
           SUM(A.CART_QTY*B.PROD_PRICE) AS ����ݾ�
      FROM CART A, PROD B, BUYER C
     WHERE A.CART_PROD=B.PROD_ID
       AND B.PROD_BUYER=C.BUYER_ID
   --    AND A.CART_NO LIKE '2005%'
       AND SUBSTR(A.CART_NO,1,4) = '2005'
     GROUP BY C.BUYER_ID,C.BUYER_NAME,B.PROD_NAME
     ORDER BY 1;
  
  (ANSI FORMAT)
    SELECT C.BUYER_ID AS �ŷ�ó�ڵ�,
           C.BUYER_NAME AS �ŷ�ó��,
           B.PROD_NAME AS ��ǰ��,
           SUM(A.CART_QTY) AS �������,
           SUM(A.CART_QTY*B.PROD_PRICE) AS ����ݾ�
      FROM CART A
     INNER JOIN PROD B ON(A.CART_PROD=B.PROD_ID AND
           SUBSTR(A.CART_NO,1,4) = '2005')
     INNER JOIN BUYER C ON(B.PROD_BUYER=C.BUYER_ID)  
     GROUP BY C.BUYER_ID,C.BUYER_NAME,B.PROD_NAME
     ORDER BY 1;  
    
    
    
    