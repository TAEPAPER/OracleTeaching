2022-0208-01)트리거
 ** hr계정의 사원테이블에 퇴직일자 컬럼을 추가하시오
    ALTER TABLE HR.EMPLOYEES ADD(RETIRE_DATE DATE);
    
 ** HR 계정에 퇴직자 테이블을 생성하시오
    테이블명 : RETIRES
    컬럼명      데이터타입    NULLABLE    PK/FK
 ------------------------------------------------
 EMPLOYEE_ID   NUMBER(6)    N.N         PK & FK
 RETIRE_DATE   DATE
 JOB_ID        VARCHAR2(10)             FK
 DEPARTMENT_ID NUMBER(4)                FK
 ------------------------------------------------
  CREATE TABLE RETIRES(
   EMPLOYEE_ID   NUMBER(6),
   RETIRE_DATE   DATE,
   JOB_ID        VARCHAR2(10),
   DEPARTMENT_ID NUMBER(4),
   CONSTRAINT pk_retires PRIMARY KEY(EMPLOYEE_ID),
   CONSTRAINT fk_ret_emp FOREIGN KEY(EMPLOYEE_ID)
     REFERENCES EMPLOYEES(EMPLOYEE_ID),
   CONSTRAINT fk_ret_jobs FOREIGN KEY(JOB_ID)
     REFERENCES JOBS(JOB_ID),
   CONSTRAINT fk_ret_dept FOREIGN KEY(DEPARTMENT_ID)
     REFERENCES DEPARTMENTS(DEPARTMENT_ID));
     
SELECT EMP_NAME, HIRE_DATE
  FROM EMPLOYEES
 ORDER BY 2; 
     
     
사용예)사원테이블에서 2003년 이전에 입사한 사원들을
      퇴직 처리하려한다.
      퇴직자는 사원테이블 퇴직일자에 오늘 날짜로 변경하기전
      퇴직자테이블에 정보를 입력해야한다.

  CREATE TRIGGER tg_retire
   BEFORE  UPDATE ON EMPLOYEES
   FOR EACH ROW
   BEGIN
    INSERT INTO RETIRES
      VALUES(:OLD.EMPLOYEE_ID,SYSDATE,
             :OLD.JOB_ID,:OLD.DEPARTMENT_ID);
   END;


   UPDATE EMPLOYEES
      SET RETIRE_DATE=SYSDATE
    WHERE HIRE_DATE<=TO_DATE('20021231');  



    
      
   