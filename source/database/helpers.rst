####################
쿼리 헬퍼 메소드
####################

.. contents::
    :local:
    :depth: 2

쿼리 실행 정보
***************

$db->insertID()
================

데이터베이스 삽입을 수행할 때 삽입 ID 번호입니다.

.. note:: PDO의 PostgreSQL 드라이버 또는 Interbase 드라이버를 사용하는 경우 이 함수에 ``$name`` 매개 변수가 필요합니다. 
    이 매개 변수는 삽입(Insert) ID를 확인하기 위한 적절한 시퀀스(sequence)를 지정합니다.

$db->affectedRows()
===================

"쓰기" 유형 쿼리를 수행할 때 영향을 받는 행의 갯수를 표시합니다. (insert, update, etc.).

.. note:: MySQL의 "DELETE FROM TABLE"\ 은 영향을 받는 행을 0 개로 반환합니다. 
    데이터베이스 클래스에는 영향을받는 올바른 행 수를 반환할 수있는 작은 핵(hack)이 있습니다. 
    기본적으로 이 핵은 활성화되어 있지만 데이터베이스 드라이버 파일에서 비활성화할 수 있습니다.

$db->getLastQuery()
===================

마지막으로 실행 된 쿼리(결과가 아닌 쿼리 문자열)를 나타내는 Query 개체를 반환합니다.

데이터베이스 정보
******************

$db->countAll()
===============

특정 테이블 행의 수를 확인할 수 있습니다.
첫 번째 매개 변수에 테이블 이름을 제출하십시오.
``Query Builder``\ 의 일부입니다.

.. literalinclude:: helpers/001.php

$db->countAllResults()
======================

특정 결과의 행 수를 확인할 수 있습니다.
첫 번째 매개 변수에 테이블 이름을 제출합니다.
``Query Builder``\ 의 일부입니다.

.. literalinclude:: helpers/002.php

$db->getPlatform()
==================

실행중인 데이터베이스 플랫폼을 출력합니다. (MySQL, MS SQL, Postgres, etc...)

.. literalinclude:: helpers/003.php

$db->getVersion()
=================

실행중인 데이터베이스 버전을 출력합니다.

.. literalinclude:: helpers/004.php
