2022-0127-01)비교문
 - 오라클의 분기문으로 IF와 CASE WHEN ~ THEN이 제공
 - IF문은 개발언어의 IF와 동일 기능
 - CASE WHEN ~ THEN은 개발언어의 다중 분기와 같은 기능
1. IF 문
 - 제시된 조건을 판단하여 서로 다른 방향으로 제어 이동
 (사용형식-1)
 IF 조건식 THEN
    명령-1;
[ELSE
    명령-2;]
 END IF;
 
 (사용형식-2)
 IF 조건식-1 THEN
    
    IF 조건식-2 THEN
       명령-1;
    
    END IF;
    
 ELSIF 조건식-2 THEN
    명령-2;
       :
 ELSE
    명령-n;
 END IF; 
    
 (사용형식-3)
 IF 조건식-1 THEN
    IF 조건식-2 THEN
       명령-1;
       
    ELSE
       명령-2;
    END IF;   
 ELSIF 조건식-3 THEN
    명령-3;
       :
 ELSE
    명령-n;
 END IF;     
 
사용예)첫 날에 100원, 두째날부터 전날의 2배씩 저축할때 
      최초로 100만원을 넘는 날과 그때까지 저축된 금액을 구하시오.
  DECLARE
    V_DAYS NUMBER:=1; --날수
    V_SUM NUMBER:=0; --저축한 금액 합계(저금통)
    V_AMT NUMBER:=100; --저축할 금액
  BEGIN
    LOOP
      V_SUM:=V_SUM+V_AMT;
      EXIT WHEN V_SUM>=1000000;
      V_AMT:=V_AMT*2;
      V_DAYS:=V_DAYS+1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('경과일수 : '||V_DAYS);
    DBMS_OUTPUT.PUT_LINE('저축금액 : '||V_SUM);   
  END;

사용예)회원테이블에서 회원들의 마일리지를 조회하여 
      마일리지가 0-1000 이면 '일반회원',
          "     1001-2000 이면 '열심회원'
          "     2001 이상이면 'VIP 회원'을 
      출력하는 프로시져를 작성하시오.
      Alias는 회원번호,회원명,마일리지,비고
  DECLARE
    V_MID MEMBER.MEM_ID%TYPE;
    V_MNAME MEMBER.MEM_NAME%TYPE;
    V_MILE NUMBER:=0;
    V_REMARKS VARCHAR2(50);
    CURSOR CUR_MEM01 
    IS
      SELECT MEM_ID,MEM_NAME,MEM_MILEAGE
      FROM MEMBER;
  BEGIN
    OPEN CUR_MEM01;
    DBMS_OUTPUT.PUT_LINE('회원번호  회원명  마일리지  비고'); 
    LOOP
      FETCH CUR_MEM01 INTO V_MID,V_MNAME,V_MILE;
      EXIT WHEN CUR_MEM01%NOTFOUND;
      IF V_MILE <=1000 THEN
         V_REMARKS:='일반회원';
      ELSIF V_MILE <=2000 THEN
         V_REMARKS:='열심회원';
      ELSE
         V_REMARKS:='VIP회원';
      END IF;
      DBMS_OUTPUT.PUT_LINE(V_MID||'     '||V_MNAME||'    '||
                           V_MILE||'   '||V_REMARKS);   
      DBMS_OUTPUT.PUT_LINE('--------------------------------');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('전체회원수 : '||CUR_MEM01%ROWCOUNT);
    CLOSE CUR_MEM01;
  END;
    
  