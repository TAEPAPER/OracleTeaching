2022-0204-02)함수(User Defined Function : Function)
 - 특징은 procedure와 동일하나 반환값이 존재함
 - select 문의 select절, where절, update구문 등에
   사용
 (사용형식)
 CREATE [OR REPLACE] FUNCTION 함수명[(
   변수명 [모드] 타입명 [:=[DEFAULT] 값][,]
                  :
   변수명 [모드] 타입명 [:=[DEFAULT] 값])
   RETURN 타입명
 AS|IS
   선언부;
 BEGIN
   실행부;
   RETURN expr;
   [EXCEPTION 
     예외처리문;
   ]
 END;  
 
사용예)거래처코드를 입력받아 해당 거래처에서 납품하는 상품
      정보를 조회하시오(함수사용)
      Alias는 거래처코드,거래처명,상품코드,상품명,매입단가
  CREATE OR REPLACE FUNCTION FN_PROD_INFO(
    P_BID IN BUYER.BUYER_ID%TYPE)
    RETURN VARCHAR2
  IS
    V_RES VARCHAR2(1000);
  BEGIN
    SELECT PROD_ID||' '||RPAD(PROD_NAME,20,' ')||
           LPAD(PROD_COST,8,' ')
      INTO V_RES
      FROM PROD
     WHERE PROD_BUYER=P_BID
       AND ROWNUM=1;
    RETURN V_RES;
    
    EXCEPTION 
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('에러발생'||SQLERRM);
        RETURN NULL;
  END;
 
(실행)
  SELECT BUYER_ID,BUYER_NAME,FN_PROD_INFO(BUYER_ID)
    FROM BUYER;
    
(사용예)회원번호를 입력받아 회원명을 출력하는 함수 작성
  SELECT MEM_ID,MEM_NAME
    FROM MEMBER;
    
  CREATE OR REPLACE FUNCTION FN_MEM_NAME(
    P_MID IN MEMBER.MEM_ID%TYPE)
    RETURN MEMBER.MEM_NAME%TYPE
  IS
    V_NAME MEMBER.MEM_NAME%TYPE;
  BEGIN
    SELECT MEM_NAME INTO V_NAME
      FROM MEMBER
     WHERE MEM_ID=P_MID;
    RETURN V_NAME; 
  END;
  
(실행)
  SELECT MEM_ID AS 회원번호,
         FN_MEM_NAME(MEM_ID) AS 회원명
    FROM MEMBER;     

사용예)기간(년,월)을 입력 받아 상품별 매출금액집계를 조회하시오
  CREATE OR REPLACE FUNCTION FN_SUM_CART(
    P_PERIOD IN VARCHAR2,
    P_PID PROD.PROD_ID%TYPE)
    RETURN NUMBER
  AS
    V_PERIOD CHAR(7):=P_PERIOD||'%';
    V_SUM NUMBER:=0;  --제품별 매출금액합계
  BEGIN
    SELECT SUM(A.CART_QTY*B.PROD_PRICE) INTO V_SUM
      FROM CART A,PROD B
     WHERE A.CART_PROD=P_PID
       AND A.CART_PROD=B.PROD_ID
       AND A.CART_NO LIKE V_PERIOD;
    RETURN V_SUM;   
       
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('예외발생 : '||SQLERRM);
      RETURN NULL;
  END;
  
실행)
  SELECT PROD_ID AS 상품코드,
         NVL(FN_SUM_CART('200506',PROD_ID),0) AS 매출액집계
    FROM PROD
   ORDER BY 1; 
  
  
실행)
  ACCEPT P_PERIOD PROMPT '기간입력(년/월)'
  DECLARE 
    V_AMT NUMBER:=0;
    V_RES VARCHAR2(100);
    CURSOR CUR_PROD01 
    IS 
      SELECT PROD_ID,PROD_NAME FROM PROD;
  BEGIN
    FOR REC IN CUR_PROD01 LOOP
      V_AMT:=NVL(FN_SUM_CART('&P_PERIOD',REC.PROD_ID),0);
      V_RES:= REC.PROD_ID||' '||RPAD(REC.PROD_NAME,25,' ')
              ||LPAD(V_AMT,9,' ');
      DBMS_OUTPUT.PUT_LINE(V_RES);
      DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    END LOOP;
  END;
  
사용예)사원번호를 입력받아 해당 사원이 속한 부서명과 주소를
      반환하는 함수를 작성하시오.
      
  CREATE OR REPLACE FUNCTION FN_EMP_ADDR(
    P_EID IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE)
    RETURN VARCHAR2
  IS
    V_RES VARCHAR2(200);
    V_ADDR VARCHAR2(100);
  BEGIN
    SELECT A.DEPARTMENT_NAME,
           'ZIP CODE : '||B.POSTAL_CODE||
           ' '||STREET_ADDRESS||', '||CITY||
           ' '||STATE_PROVINCE
      INTO V_RES,V_ADDR     
      FROM HR.DEPARTMENTS A,HR.LOCATIONS B,HR.EMPLOYEES C 
     WHERE C.EMPLOYEE_ID=P_EID
       AND C.DEPARTMENT_ID=A.DEPARTMENT_ID
       AND A.LOCATION_ID=B.LOCATION_ID;
    V_RES:=V_RES||'  '||V_ADDR;
    RETURN V_RES;
    
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('예외발생 : '||SQLERRM);
      RETURN NULL;
  END;
  
실행)
  SELECT EMPLOYEE_ID AS 사원번호,
         EMP_NAME AS 사원명,
         FN_EMP_ADDR(EMPLOYEE_ID) AS "부서명 및 주소 "
    FROM HR.EMPLOYEES;     

사용예)년도를 입력받아 해당년도의 상품별 매입수량합계와
      매입금액합계를 구하는 함수들을 만들고 매입금액 기준
      상위 5개의 상품에 대한 매입집계를 출력하시오.
  Alias는 상품코드,상품명,매입수량,매입금액
  
  CREATE OR REPLACE FUNCTION FN_AMT_BUYQTY(
   P_YEAR CHAR, P_PID PROD.PROD_ID%TYPE)
   RETURN NUMBER
  IS
   V_SQTY NUMBER:=0;
  BEGIN
   SELECT SUM(BUY_QTY) INTO V_SQTY
     FROM BUYPROD
    WHERE EXTRACT(YEAR FROM BUY_DATE)=P_YEAR
      AND BUY_PROD=P_PID;
   RETURN V_SQTY;   
  END;

  CREATE OR REPLACE FUNCTION FN_SUM_BUYAMT(
   P_YEAR CHAR, P_PID PROD.PROD_ID%TYPE)
   RETURN NUMBER
  IS
   V_SAMT NUMBER:=0;
  BEGIN
   SELECT SUM(BUY_QTY*BUY_COST) INTO V_SAMT
     FROM BUYPROD
    WHERE EXTRACT(YEAR FROM BUY_DATE)=P_YEAR
      AND BUY_PROD=P_PID;
   RETURN V_SAMT;   
  END;   
  
  
실행)
  SELECT A.PROD_ID AS 상품코드,
         A.PROD_NAME AS 상품명,
         A.FAB AS 매입수량,
         TO_CHAR(A.FSB,'99,999,999') AS 매입금액
    FROM (SELECT PROD_ID,PROD_NAME,
                 FN_AMT_BUYQTY('2005',PROD_ID) AS FAB,
                 FN_SUM_BUYAMT('2005',PROD_ID) AS FSB
            FROM PROD
           ORDER BY 3 DESC) A 
   WHERE ROWNUM<=5;        