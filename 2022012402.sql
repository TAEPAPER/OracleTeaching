2022-0124-02)���� ������
 - �������� QUERY ����� �����Ͽ� ���ο� ����� ��ȯ
 - JOIN ������ ���� �� ����
 - ������(UNION, UNION ALL),������(INTERSECT),������(
   MINUS) ����
   . UNION : �� ������ ��� ���Ҹ� �ߺ����� �ʰ� ��ȯ(����)   
   . UNION ALL : �ߺ��� ����� �� ������ ��� ���Ҹ� ��ȯ(������������)
   . INTERSECT : �� ������ ����� ���� ��ȯ(����)
   . MINUS : �ǰ������տ��� �������հ���� ������ ��� ��ȯ
 (�������)
   QUERY_1
  UNION|UNION ALL|INTERSECT|MINUS
   QUERY_2
 [UNION|UNION ALL|INTERSECT|MINUS
   QUERY_3]
      :
 [UNION|UNION ALL|INTERSECT|MINUS
   QUERY_n]
  - ��� ������ SELECT ���� �÷��� ���� Ÿ��, ������ �����ؾ���
  - ����� �⺻�� ù ��° SELECT ����
  - ORDER BY���� �� ������ QUERY�� ��� ����
  
1. UNION
 - �������� ��� ���
 - �ߺ��� ����
 
��뿹)������̺��� 2005�⵵�� �Ի��� ����� �μ��� �ÿ�Ʋ�� 
      ����� ��ȸ�Ͻÿ�
      Alias�� �����ȣ,�����,�Ի���,�μ���
(2005�⵵�� �Ի��� ���)
  SELECT A.EMPLOYEE_ID AS �����ȣ,
         A.EMP_NAME AS �����,
         A.HIRE_DATE AS �Ի���,
         B.DEPARTMENT_NAME AS �μ���
    FROM HR.EMPLOYEES A,HR.DEPARTMENTS B
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
     AND EXTRACT(YEAR FROM HIRE_DATE)=2005
 UNION     
--(�μ��� �ÿ�Ʋ�� ���) 
  SELECT A.EMPLOYEE_ID,
         A.EMP_NAME,
         A.HIRE_DATE,
         B.DEPARTMENT_NAME
    FROM HR.EMPLOYEES A,HR.DEPARTMENTS B,HR.LOCATIONS C
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
     AND B.LOCATION_ID=C.LOCATION_ID
     AND C.CITY='Seattle';
  
��뿹)2005��4���� ���ԵȻ�ǰ�� ����Ȼ�ǰ�� �ߺ����� �ʰ� 
      ��� ��ȸ �Ͻÿ�
      Alias�� ��ǰ�ڵ�,��ǰ��,�ŷ�ó��
(4�� ���Ի�ǰ��ȸ)
  SELECT DISTINCT A.BUY_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         C.BUYER_NAME AS �ŷ�ó��
    FROM BUYPROD A,PROD B,BUYER C
   WHERE A.BUY_PROD=B.PROD_ID
     AND B.PROD_BUYER=C.BUYER_ID
     AND A.BUY_DATE BETWEEN TO_DATE('20050401') AND
         TO_DATE('20050430')
 UNION 
--(4�� �����ǰ��ȸ)
  SELECT DISTINCT A.CART_PROD,
         B.PROD_NAME,
         C.BUYER_NAME
    FROM CART A,PROD B,BUYER C
   WHERE A.CART_PROD=B.PROD_ID
     AND B.PROD_BUYER=C.BUYER_ID
     AND A.CART_NO LIKE '200504%';  
     
��뿹)2005�� 6���� 7���� ��ǰ�� ������ ȸ���� ��ȸ�Ͻÿ�
      Alias�� ȸ����ȣ,ȸ����,�ּ�,���ϸ���
(2005�� 6���� ��ǰ�� ������ ȸ��)
  SELECT DISTINCT A.CART_MEMBER AS ȸ����ȣ,
         B.MEM_NAME AS ȸ����,
         B.MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
         B.MEM_MILEAGE AS ���ϸ���
    FROM CART A, MEMBER B
   WHERE A.CART_MEMBER=B.MEM_ID
     AND A.CART_NO LIKE '200506%'
 UNION   
--(2005�� 7���� ��ǰ�� ������ ȸ��)
  SELECT DISTINCT A.CART_MEMBER AS ȸ����ȣ,
         B.MEM_NAME AS ȸ����,
         B.MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
         B.MEM_MILEAGE AS ���ϸ���
    FROM CART A, MEMBER B
   WHERE A.CART_MEMBER=B.MEM_ID
     AND A.CART_NO LIKE '200507%'
   ORDER BY 1;  
   
2. INTERSECT
 - �� SQL ����� ������(����� ����)�� ��ȯ
 
��뿹)2005�⵵ �ݾױ��� ���Լ��� ���� 5�� ǰ���
      ������� ���� 5�� ǰ���� ��ȸ�Ͽ� ���� ��θ�
      �����ϴ� ��ǰ������ ����Ͻÿ�.
      Alias�� ��ǰ�ڵ�, ��ǰ��, �ݾ�, ����
      
(2005�⵵ �ݾױ��� ���Լ��� ���� 5�� ǰ��)
  SELECT C.BID AS ��ǰ�ڵ�, 
         C.BNAME AS ��ǰ��, 
         C.BSUM AS �ݾ�, 
         C.BRANK AS ����
    FROM (SELECT A.BUY_PROD AS BID, 
                 B.PROD_NAME AS BNAME, 
                 SUM(A.BUY_QTY*B.PROD_COST) AS BSUM,
                 RANK() OVER(ORDER BY SUM(A.BUY_QTY*B.PROD_COST) DESC)
                  AS BRANK
            FROM BUYPROD A,PROD B
           WHERE A.BUY_PROD=B.PROD_ID
             AND EXTRACT(YEAR FROM A.BUY_DATE)=2005
           GROUP BY A.BUY_PROD,B.PROD_NAME) C
   WHERE C.BRANK<=5
INTERSECT     
--(2005�⵵ �ݾױ��� ������� ���� 5�� ǰ��)
  SELECT D.CID AS ��ǰ�ڵ�, 
         D.CNAME AS ��ǰ��, 
         D.CSUM AS �ݾ�, 
         D.CRANK AS ����
    FROM (SELECT A.CART_PROD AS CID, 
                 B.PROD_NAME AS CNAME, 
                 SUM(A.CART_QTY*B.PROD_COST) AS CSUM,
                 RANK() OVER(ORDER BY SUM(A.CART_QTY*B.PROD_COST) DESC)
                  AS CRANK
            FROM CART A,PROD B
           WHERE A.CART_PROD=B.PROD_ID
             AND A.CART_NO LIKE '2005%'
           GROUP BY A.CART_PROD,B.PROD_NAME) D
   WHERE D.CRANK<=5;
   
��뿹)2005�� 1���� 5���� ���Ե� ��ǰ������ ��ȸ�Ͻÿ�.
      Alias�� ��ǰ�ڵ�,��ǰ��,�з���
(2005�� 1���� ���Ե� ��ǰ)
  SELECT DISTINCT A.BUY_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         C.LPROD_NM AS �з���
    FROM BUYPROD A,PROD B,LPROD C
   WHERE A.BUY_PROD=B.PROD_ID
     AND B.PROD_LGU=C.LPROD_GU
     AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND
         TO_DATE('20050131')
   
INTERSECT      
--(2005�� 5���� ���Ե� ��ǰ)
  SELECT DISTINCT A.BUY_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         C.LPROD_NM AS �з���
    FROM BUYPROD A,PROD B,LPROD C
   WHERE A.BUY_PROD=B.PROD_ID
     AND B.PROD_LGU=C.LPROD_GU
     AND A.BUY_DATE BETWEEN TO_DATE('20050501') AND
         LAST_DAY(TO_DATE('20050501'))
   ORDER BY 1;      
      
3. MINUS
 - �� ������ �����հ���� ��ȯ
 - ��� ������ �߿�
 
��뿹)2005�� 6,7�� �� 6���޿��� �Ǹŵ� ��ǰ������
      ��ȸ�Ͻÿ�
      Alias�� ��ǰ�ڵ�,��ǰ��,�ǸŰ�,���԰�
(2005�� 6���� �Ǹŵ� ��ǰ)
  SELECT DISTINCT A.CART_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         B.PROD_PRICE AS �ǸŰ�,
         B.PROD_COST AS ���԰�
    FROM CART A,PROD B
   WHERE A.CART_PROD=B.PROD_ID
     AND A.CART_NO LIKE '200506%'
MINUS
--(2005�� 7���� �Ǹŵ� ��ǰ)
  SELECT DISTINCT A.CART_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         B.PROD_PRICE AS �ǸŰ�,
         B.PROD_COST AS ���԰�
    FROM CART A,PROD B
   WHERE A.CART_PROD=B.PROD_ID
     AND A.CART_NO LIKE '200507%'
   ORDER BY 1; 
   
(EXISTS ������)   
  SELECT DISTINCT A.CART_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         B.PROD_PRICE AS �ǸŰ�,
         B.PROD_COST AS ���԰�
    FROM CART A,PROD B
   WHERE A.CART_PROD=B.PROD_ID
     AND A.CART_NO LIKE '200506%'
     AND NOT EXISTS (SELECT 1
                       FROM CART C
                      WHERE C.CART_PROD=A.CART_PROD
                        AND C.CART_NO LIKE '200507%')
   ORDER BY 1;             
  