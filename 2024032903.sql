2024-0329-03)INDEX 객체
 - 자료 검색의 효율성을 증대 시키기 위한 객체
 - DB SERVER의 성능은 검색의 효율성에 가장 민감하게 반응
 - 인덱스는 자료 검색시 전체를 비교하지 않고 각 행을 대표하는 컬럼 값과
   해당 컬럼의 나머지 데이터가 저장된 주소로 구성된 인덱스파일을 별도로
   구성하여 검색시 인덱스를 검사하고 일치하는 값의 주소를 참조하여 나머지
   자료를 추출함
 - DBMS의 부하를 줄여서 DB SERVER의 전체 성능을 향상
 - [단점]
   . 별도의 공간 필요(인덱스 파일)
   . 인덱스 파일 관리에 시간과 비용이 소요
   . 자료의 지속적인 변경(수정/삭제/삽입)이 발생되는 경우 비효율적
 - INDEX의 종류
  . UNIQUE/NON-UNIQUE
  . SINGLE/COMPOSITE INDEX
  . NORMAL/BITMAP/FUNCTION BASED NORMAL INDEX
  
(사용형식)
    CREATE [UNIQUE|BITMAP] INDEX 인덱스명
      ON 테이블명(컬럼명[,컬럼명,...]) [ASC|DESC]
      . ASC|DESC : 오름차순 또는 내림차순으로 된 인덱스, 기본은 ASC
    
사용 예)
    SELECT *
      FROM HR.EMPLOYEES
     WHERE PHONE_NUMBER='515.124.4269'; --0.003초 소요
     
     CREATE INDEX IDX_EMP_TEL
        ON HR.EMPLOYEES(PHONE_NUMBER);-- 전화번호로 인덱스 구성
        
    SELECT *
      FROM HR.EMPLOYEES
     WHERE PHONE_NUMBER='515.124.4269';-- 0.002초 소요
     
     CREATE INDEX IDX_MEM_HP
        ON MEMBER(REPLACE(SUBSTR(MEM_HP,5,7),'-'));
     
     SELECT *
        FROM MEMBER
     WHERE MEM_HP='010-3452-9877'; -- 0.001초
     
     SELECT *
        FROM MEMBER
     WHERE REPLACE(SUBSTR(MEM_HP,5,7),'-')='345298';
     
**인덱스의 재구성
 - 인덱스는 2진 트리구조로 구성되어 인덱스 구성 항목의 삽입, 삭제, 갱신 시
   인덱스가 재구성되어야 함
 - 재구성의 실행을 강제시키는 명령이 rebuild임
 (사용 형식)
   ALTER INDEX 인덱스명 REBUILD
   . 테이블과 인덱스 파일이 다른 테이블 스페이스로 이동 된 경우
   . 자료의 변동(삽입/삭제/변경)이 많이 발생된 직후
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
     
     
     
     
     
     
     
     
     