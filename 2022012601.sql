2022-0126-01)
1.SYNONYM(동의어)
 - 오라클 객체에 부여하는 별칭
 - 긴 이름의 객체나 다른사람 소유의 객체에 접근할때 주로 사용
 - 테이블 별칭, 컬럼 별칭과의 차이점은 QUERY와 관계
   없이 사용 가능
(사용형식)
  CREATE [OR REPLACE] SYNONYM 동의어
    FOR 객체명;
    
사용예)
  CREATE OR REPLACE SYNONYM EMP
    FOR HR.EMPLOYEES;
    
  CREATE OR REPLACE SYNONYM DEPT FOR HR.DEPARTMENTS;  
    
  SELECT * FROM EMP;  
  SELECT * FROM DEPT;
  
  CREATE OR REPLACE SYNONYM MYDUAL FOR SYS.DUAL;
  
  SELECT SYSDATE FROM MYDUAL;
    
    
2. INDEX
 - 데이터 검색효율을 증대시키기 위한 도구
 - WHERE 조건절에 사용되는 컬럼, 정렬(ORDER BY), 그룹화(GROUP BY)
   의 기준 컬럼에 사용하여 처리 효율을 증대
 - 인덱스를 위한 별도의 기억공간이 소요되고, 시스템의 자원이 소비됨
 - 데이터의 변동이 심한 경우 인덱스 파일을 갱신에 많은 시간과 자원
   이 요구됨
 - 인덱스의 종류
  . Unique/Non-Unique : 인덱스가 중복값을 허용하는지 여부에 따른 분류
    'Unique'인덱스는 null값도 허용하나 하나의 null만 허용됨
  . Single/Composite : 인덱스 구성 컬럼이 1개인경우(Single), 2개
    이상의 컬럼으로 구성(Composite) 된 경우
  . Normal Index : Default 인덱스로 컬럼값과 rowid(물리적 위치정보)
    를 기반으로 주소가 계산되며 트리구조 이용
  . Bitmap Index : 컬럼값과 rowid(문리적 위치정보)를 2진으로 조합하여
    주소계산하며, Cardinality가 적은 경우(성별,나이 등) 효율적인 방식
  . Function-Based Normal Index : 인덱스 구성컬럼에 함수가 적용된
    경우로 이 인덱스를 이용하여 자료를 검색하는 경우 인덱스 구성에
    사용된 함수를 사용하는 것이 가장 효율적 
    
(사용형식)
  CREATE [UNIQUE|BITMAP] INDEX 인덱스명 
    ON 테이블명(컬럼명[,컬럼명,...])[ASC|DESC];
   .'ASC|DESC' : 인덱스 생성시 정렬 방식(기본은 ASC)
   
사용예)상품명으로 인덱스를 구성하시오
  CREATE INDEX idx_prod_name
    ON PROD(PROD_NAME);
    
  DROP INDEX idx_prod_name;  
  
  
  SELECT * FROM PROD
   WHERE PROD_NAME ='대우 VTR 6헤드'; 
   
사용예)사원테이블에서 'TJ Olson'사원 정보를 조회하시오.
  SELECT EMPLOYEE_ID,EMP_NAME,JOB_ID 
    FROM EMP
   WHERE EMP_NAME='TJ Olson'; 
   
  CREATE INDEX idx_emp_name
    ON EMP(EMP_NAME);
 
**인덱스 재구성
 - 자료의 삽입/삭제가 대량 발생된 경우
 - 테이블의 저장 위치(TABLE SPACE)가 변경된 경우
 (사용형식)
  ALTER INDEX 인덱스명 REBUILD;
  
  ALTER INDEX  idx_emp_name REBUILD;

 