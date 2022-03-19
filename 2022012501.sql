 
   
**순위함수(RANK OVER)
 - 특정컬럼을 기준으로 순서화시키고 등수부여
 - RANK OVER, DENSE_RANK 등이 있다.
 1) RANK
  . 순위를 부여
  . 같은 값은 같은 순위를 부여하고 차 순위는 중복된 개수만큼
    순위를 증분하여 부여(ex 1,2,2,2,5,6...)
  . SELECT 절에 사용  
  (사용형식)
   RANK() OVER(ORDER BY 컬럼명 [ASC|DESC]) [AS 별칭]
    - '컬럼명'을 기준으로 등수부여
    
사용예)2005년 구매금액이 많은 5명의 회원을 조회하시오.
      Alias는 회원번호,회원명,구매금액
  SELECT A.CART_MEMBER AS 회원번호,
         B.MEM_NAME AS 회원명,
         SUM(A.CART_QTY*C.PROD_PRICE) AS 구매금액
    FROM CART A,MEMBER B,PROD C
   WHERE A.CART_MEMBER=B.MEM_ID
     AND A.CART_PROD=C.PROD_ID
     AND ROWNUM<=5
   GROUP BY A.CART_MEMBER,B.MEM_NAME
   ORDER BY 3 DESC;

(서브쿼리 사용)    
 
  (서브쿼리:2005년 회원별 구매금액 계산,
           구매금액 순으로 내림차순정렬 )
   SELECT A.CART_MEMBER AS CID,
          SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
     FROM CART A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
      AND A.CART_NO LIKE '2005%'
    GROUP BY A.CART_MEMBER
    ORDER BY 2 DESC
 
 (메인쿼리: 구매금액이 많은 5명의 회원의 회원번호,회원명,구매금액)
  SELECT M.MEM_ID AS 회원번호,
         M.MEM_NAME AS 회원명,
         C.CSUM AS 구매금액
    FROM MEMBER M,
        (SELECT A.CART_MEMBER AS CID,
                SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
           FROM CART A, PROD B
          WHERE A.CART_PROD=B.PROD_ID
            AND A.CART_NO LIKE '2005%'
          GROUP BY A.CART_MEMBER
          ORDER BY 2 DESC) C
   WHERE M.MEM_ID=C.CID
     AND ROWNUM<=5;
     
사용예)2005년 구매금액이 많은 회원부터 등수를 부여하여 조회하시오.
      Alias는 회원번호,회원명,구매금액,등수 
  SELECT A.CART_MEMBER AS 회원번호,
         B.MEM_NAME AS 회원명,
         SUM(A.CART_QTY*C.PROD_PRICE) AS 구매금액,
         RANK() OVER(ORDER BY SUM(A.CART_QTY*C.PROD_PRICE) DESC) 
         AS 등수
    FROM CART A,MEMBER B,PROD C
   WHERE A.CART_MEMBER=B.MEM_ID
     AND A.CART_PROD=C.PROD_ID
   GROUP BY A.CART_MEMBER,B.MEM_NAME;
   
 2) 그룹내에서 순위
  (사용형식)
  RANK() OVER(PARTITION BY 컬럼명[,컬럼명,...] 
              ORDER BY 컬럼명[,컬럼명,...][ASC|DESC])
  . PARTITION BY 컬럼명 : 그룹으로 묶을 컬럼명 기술
  
사용예)사원테이블에서 각 부서별 사원들의 급여를 기준으로 순위
      를 부여하여 출력하시오. 순위는 급여가 많은사람 순으로
      부여하고 같은 급여이면 입사일이 빠른 순으로 부여하시오
  SELECT A.EMPLOYEE_ID AS 사원번호,
         A.EMP_NAME AS 사원명,
         B.DEPARTMENT_NAME AS 부서명,
         A.SALARY AS 급여,
         A.HIRE_DATE AS 입사일,
         RANK() OVER(PARTITION BY A.DEPARTMENT_ID 
                     ORDER BY A.SALARY DESC,HIRE_DATE ASC) AS 순위
    FROM HR.EMPLOYEES A,HR.DEPARTMENTS B
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID;
      
 3) DENSE_RANK()
  - 순위 부여
  - 같은 값이면  같은 순위 부여하며, 차순위는 같은순위 갯수와 관계
    없이 다음 순위 부여(ex, 1,1,1,2,3,4,...)
  - 나머지 특징은 RANK()와 동일
  
 4) ROW_NUMBER()
  - 순위 부여                      값 9 9 9 8 7 6....     
  - 같은 값이라도 순차적인 순위 부여(ex, 1,2,3,4,5,6,...)
  - 나머지 특징은 RANK()와 동일 
      
사용예)사원테이블에서 급여가 5000이하인 사원들을 조회하고
      급여에따른 순위를 부여하시  
(RANK() 함수 사용)
  SELECT EMPLOYEE_ID AS 사원번호,
         EMP_NAME AS 사원명,
         DEPARTMENT_ID AS 부서코드,
         SALARY AS 급여,
         RANK() OVER(ORDER BY SALARY DESC) AS 순위
    FROM HR.EMPLOYEES
   WHERE SALARY<=5000; 
      
(DENSE_RANK() 함수 사용)
  SELECT EMPLOYEE_ID AS 사원번호,
         EMP_NAME AS 사원명,
         DEPARTMENT_ID AS 부서코드,
         SALARY AS 급여,
         DENSE_RANK() OVER(ORDER BY SALARY DESC) AS 순위
    FROM HR.EMPLOYEES
   WHERE SALARY<=5000; 
            
(ROW_NUMBER() 함수 사용)
  SELECT EMPLOYEE_ID AS 사원번호,
         EMP_NAME AS 사원명,
         DEPARTMENT_ID AS 부서코드,
         SALARY AS 급여,
         ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS 순위
    FROM HR.EMPLOYEES
   WHERE SALARY<=5000; 
                  