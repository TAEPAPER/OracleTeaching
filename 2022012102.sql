2022-0121-02)

��뿹)��ٱ������̺��� ȸ���� �ִ뱸�ż����� ����� ��ǰ��
      ��ȸ�Ͻÿ�
      Alias ȸ����ȣ,ȸ����,��ǰ��,���ż���
 (�������� : ȸ����ȣ,ȸ����,��ǰ��,���ż���)
  SELECT C.CART_MEMBER AS ȸ����ȣ,
         A.MEM_NAME AS ȸ����,
         B.PROD_NAME AS ��ǰ��,
         C.CART_QTY AS ���ż���
    FROM MEMBER A, PROD B, CART C
   WHERE C.CART_MEMBER=A.MEM_ID 
     AND C.CART_PROD=B.PROD_ID
     AND C.CART_QTY=(��������);

 (�������� : ȸ���� �ִ뱸�ż���)
  SELECT CART_MEMBER,
         MAX(CART_QTY)
    FROM CART
   GROUP BY CART_MEMBER;  
    
 (����)  
  SELECT C.CART_MEMBER AS ȸ����ȣ,
         A.MEM_NAME AS ȸ����,
         B.PROD_NAME AS ��ǰ��,
         C.CART_QTY AS ���ż���
    FROM MEMBER A, PROD B, CART C
   WHERE C.CART_MEMBER=A.MEM_ID 
     AND C.CART_PROD=B.PROD_ID
     AND (C.CART_MEMBER,C.CART_QTY)
          IN(SELECT CART_MEMBER,
                    MAX(CART_QTY)
               FROM CART
              GROUP BY CART_MEMBER)
   ORDER BY 1; 
   
  SELECT C.CART_MEMBER AS ȸ����ȣ,
         A.MEM_NAME AS ȸ����,
         B.PROD_NAME AS ��ǰ��,
         C.CART_QTY AS ���ż���
    FROM MEMBER A, PROD B, CART C
   WHERE C.CART_MEMBER=A.MEM_ID 
     AND C.CART_PROD=B.PROD_ID
     AND C.CART_QTY=(SELECT MAX(D.CART_QTY)
                       FROM CART D
                      WHERE D.CART_MEMBER=C.CART_MEMBER)
   ORDER BY 1;         
   