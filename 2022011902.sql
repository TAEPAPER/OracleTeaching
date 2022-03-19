2022-0119-02)
2. NON-EQUI JOIN
  - 조인조건문에 '='연산자 이외의 연산자가 사용되는 
    조인
    
**HR 계정에 급여에 따른 등급표를 작성하시오
 1)테이블명 : SAL_GRADE
 2)컬럼명
 -------------------------------
  GRADE    LOW_SAL    MAX_SAL
 -------------------------------
     1      1000       2999 
     2      3000       4999
     3      5000       7999
     4      8000      12999
     5     13000      19999
     6     20000      40000  
 --------------------------------
 3) 기본키 : GRADE
 
 CREATE TABLE SAL_GRADE(
   GRADE NUMBER(2) PRIMARY KEY,
   LOW_SAL NUMBER(6),
   MAX_SAL NUMBER(6))
 
 INSERT INTO SAL_GRADE VALUES(1,1000,2999);
 INSERT INTO SAL_GRADE VALUES(2,3000,4999);
 INSERT INTO SAL_GRADE VALUES(3,5000,7999);
 INSERT INTO SAL_GRADE VALUES(4,8000,12999);
 INSERT INTO SAL_GRADE VALUES(5,13000,19999);
 INSERT INTO SAL_GRADE VALUES(6,20000,40000);
 
 SELECT * FROM SAL_GRADE;
 COMMIT;
 
사용예)HR계정의 사원테이블에서 급여에 따른 등급을 
      조회하여 출력하시오
      Alias는 사원번호,사원명,부서명,급여,등급이다
      SELECT A.EMPLOYEE_ID AS 사원번호,
             A.EMP_NAME AS 사원명,
             B.DEPARTMENT_NAME AS 부서명,
             A.SALARY AS 급여,
             C.GRADE AS 등급
        FROM HR.EMPLOYEES A,HR.DEPARTMENTS B,
             SAL_GRADE C
       WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
         AND (A.SALARY>=C.LOW_SAL AND A.SALARY<=C.MAX_SAL)
       ORDER BY 3;  
       
사용예)사원테이블에서 사원들의 평균급여보다 많은 급여를 받는
      사원들을 조회하시오
      Alias는 사원번호,사원명,직무명,급여
      SELECT A.EMPLOYEE_ID AS 사원번호,
             A.EMP_NAME AS 사원명,
             B.JOB_TITLE AS 직무명,
             A.SALARY AS 급여
        FROM HR.EMPLOYEES A, HR.JOBS B,
             (SELECT AVG(SALARY) AS ASAL
                FROM HR.EMPLOYEES) C
       WHERE A.JOB_ID=B.JOB_ID
         AND A.SALARY>C.ASAL
       ORDER BY 4 DESC;
                
숙제]사원테이블에서 부서별 평균임금을 구하고 해당부서에 속한
     사원 중 자기부서의 평균 급여보다 많은 급여를 받는
     사원을 조회하시오.
     Alias는 사원번호,사원명,부서명,부서평균급여,급여
     
     제출일자 : 2022년 1월 28일
     제출방법 : 파일전송(SEM-PC의 D:\공유폴더\Oracle\homework01)
     파일명 : 메모장 등을 활용하여 txt 또는 doc 또는 hwp
             파일로 저장하여 전송
             파일명은 이름작성일자.txt(ex 홍길동20220127.txt)
      
 
 
 