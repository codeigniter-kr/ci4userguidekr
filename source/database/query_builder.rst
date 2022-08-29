###################
쿼리 빌더 클래스
###################

CodeIgniter를 사용하면 쿼리 빌더 클래스에 액세스 할 수 있습니다.
이 패턴을 사용하면 최소한의 스크립팅으로 데이터베이스에서 정보를 검색, 삽입 및 업데이트를 할 수 있습니다.
경우에 따라 데이터베이스 작업을 수행하는데 한두 줄의 코드만 사용해도 됩니다.
CodeIgniter에서는 데이터베이스의 각 테이블이 클래스 파일일 필요는 없습니다.
대신 더 간단한 인터페이스를 제공합니다.

단순성을 넘어서, Query Builder 기능을 사용하면 각 데이터베이스 어댑터별 조회 구문이 생성되는 이점이 있어 특정 데이터베이스에 종속되지 않는 어플리케이션을 작성할 수 있다는 것입니다.
또한 값이 시스템에 의해 자동으로 이스케이프되므로 보다 안전한 쿼리가 가능합니다.

.. contents::
    :local:
    :depth: 2

*************************
쿼리 빌더 로드
*************************

쿼리 빌더는 데이터베이스 연결의 ``table()`` 메소드를 통해 로드됩니다.
그러면 쿼리의 **FROM** 부분이 설정되고 Query Builder 클래스의 새 인스턴스가 반환됩니다.

.. literalinclude:: query_builder/001.php

Query Builder는 특별히 클래스를 요청할 때만 메모리에 로드되므로 기본적으로 자원(resource)이 사용되지 않습니다.

************************
데이터 선택(select)
************************

다음 함수를 사용하면 SQL **SELECT** 문을 작성할 수 있습니다.

Get
===

$builder->get()
---------------

select 쿼리를 실행하고 결과를 반환하며, 테이블에서 모든 레코드를 검색할 수 있습니다

.. literalinclude:: query_builder/002.php

첫 번째와 두 번째 매개 변수를 사용하여 limit과 offset을 설정할 수 있습니다

.. literalinclude:: query_builder/003.php

위 함수는 $query 라는 변수에 할당되어 있으며 결과를 표시하는데 사용할 수 있습니다.

.. literalinclude:: query_builder/004.php

결과 생성에 대한 자세한 내용은 :doc:`getResult*() 함수 <results>` 페이지를 참조하십시오.

$builder->getCompiledSelect()
-----------------------------

``$builder->get()``\ 처럼 select 쿼리를 컴파일하지만 쿼리를 *실행*\ 하지는 않습니다.
이 메소드는 SQL 쿼리를 문자열로 반환합니다.

.. literalinclude:: query_builder/005.php

첫 번째 매개 변수를 사용하면 쿼리 빌더의 쿼리를 재설정할지 여부를 설정할 수 있습니다. (기본적으로 ``$builder->get()``\ 을 사용할 때와 같이 재설정됩니다)

.. literalinclude:: query_builder/006.php

위의 예에서 주목해야 할 핵심은 두 번째 쿼리는 ``limit(10, 20)``\ 을 사용하지 않았지만 생성된 SQL 쿼리에는 ``LIMIT 20, 10``\ 이 있다는 것입니다.
그 이유는 첫 번째 매개변수가 ``false``\ 로 설정되어 있기 때문입니다.

$builder->getWhere()
--------------------

db->where() 함수를 사용하는 대신 첫 번째 매개 변수에 "where"\ 절을 추가 할 수 있다는 점을 제외하고 ``get()`` 메소드와 동일합니다.

.. literalinclude:: query_builder/007.php

자세한 내용은 아래의 `where` 함수에 대해 읽으십시오.

.. _query-builder-select:

Select
======

$builder->select()
------------------

쿼리의 **SELECT** 부분을 쓸 수 있습니다

.. literalinclude:: query_builder/008.php

.. note:: 테이블에서 모두(``*``)를 선택하는 경우 이 방법을 사용할 필요가 없습니다. 생략하면 CodeIgniter는 모든 필드를 선택하고 자동으로 ``SELECT *``\ 를 추가한다고 가정합니다.

``$builder->select()``\ 는 두 번째 매개 변수를 옵션으로 허용하며, 이를 ``false``\ 로 설정하면 CodeIgniter는 필드 또는 테이블 이름을 보호하지 않습니다.
필드의 자동 이스케이프가 필드를 손상시킬 수 있는 복합 선택문이 필요한 경우에 유용합니다.

.. literalinclude:: query_builder/009.php

.. _query-builder-select-rawsql:

RawSql
^^^^^^

v4.2.0부터 ``$builder->select()``\ 는 원시(raw) SQL 문자열을 표현하는 ``CodeIgniter\Database\RawSql`` 인스턴스를 허용합니다.

.. literalinclude:: query_builder/099.php

.. warning:: ``RawSql``\ 을 사용할 때 데이터는 수동으로 이스케이프(escape)해야 합니다. 그렇지 않으면 SQL 주입(SQL injection)이 발생할 수 있습니다.

$builder->selectMax()
---------------------

쿼리의 ``SELECT MAX(field)`` 부분을 작성합니다.
옵션으로 두 번째 매개 변수에 결과 필드의 이름을 전달하여 바꿀 수 있습니다.

.. literalinclude:: query_builder/010.php

$builder->selectMin()
---------------------

쿼리의 **SELECT MIN(field)** 부분을 작성합니다.
``selectMax()``\ 와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.

.. literalinclude:: query_builder/011.php

$builder->selectAvg()
---------------------

쿼리의 **SELECT AVG(field)** 부분을 작성합니다.
``selectMax()``\ 와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.

.. literalinclude:: query_builder/012.php

$builder->selectSum()
---------------------

쿼리의 **SELECT SUM(field)** 부분을 작성합니다.
``selectMax()``\ 와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.

.. literalinclude:: query_builder/013.php

$builder->selectCount()
-----------------------

쿼리의 **SELECT COUNT(field)** 부분을 작성합니다.
``selectMax()``\ 와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.


.. note:: 이 메소드는 ``groupBy()``\ 와 함께 사용할 때 특히 유용합니다. 카운트 결과는 일반적으로 ``countAll()`` 또는 ``countAllResults()``\ 를 참조하십시오.

.. literalinclude:: query_builder/014.php

$builder->selectSubquery()
--------------------------

SELECT 섹션에 서브쿼리(subquery)를 추가합니다.

.. literalinclude:: query_builder/015.php
   :lines: 2-

From
====

$builder->from()
----------------

쿼리의 FROM 부분을 작성합니다.

.. literalinclude:: query_builder/016.php

.. note:: 앞에서 설명한 것처럼 쿼리의 **FROM** 부분은 $db->table() 메소드에서 지정할 수 있습니다. ``from()``\ 에 대한 추가 호출은 쿼리의 FROM 부분에 더 많은 테이블을 추가합니다.

.. _query-builder-from-subquery:

Subqueries
==========

$builder->fromSubquery()
------------------------

Permits you to write part of a **FROM** query as a subquery.

This is where we add a subquery to an existing table:
**FROM** 쿼리의 일부를 서브쿼리(subquery)로 작성할 수 있습니다.

기존 테이블에 서브쿼리를 추가합니다.

.. literalinclude:: query_builder/017.php

``$db->newQuery()`` 메서드를 사용하면 서브쿼리를 기본 테이블로 만듭니다.

.. literalinclude:: query_builder/018.php

Join
====

$builder->join()
----------------

쿼리의 **JOIN** 부분을 작성합니다.

.. literalinclude:: query_builder/019.php

하나의 쿼리에 여러 개의 조인이 필요한 경우 메소드를 여러번 호출할 수 있습니다.

특정 유형의 **JOIN**\ 이 필요한 경우 함수의 세 번째 매개 변수를 통해 지정할 수 있습니다.
제공 옵션 : ``left``, ``right``, ``outer``, ``inner``, ``left outer``, ``right outer``.

.. literalinclude:: query_builder/020.php

.. _query-builder-join-rawsql:

RawSql
^^^^^^

v4.2.0부터 ``$builder->join()``\ 는 원시(raw) SQL 문자열을 표현하는 ``CodeIgniter\Database\RawSql`` 인스턴스를 허용합니다.

.. literalinclude:: query_builder/102.php

.. warning:: ``RawSql``\ 을 사용할 때 데이터는 수동으로 이스케이프(escape)해야 합니다. 그렇지 않으면 SQL 주입(SQL injection)이 발생할 수 있습니다.

*************************
특정 데이터 찾기
*************************

Where
=====

$builder->where()
-----------------

이 메소드를 사용하면 네 가지 방법중 하나를 사용하여 **WHERE** 절을 설정할 수 있습니다:

.. note:: 이 메소드에 전달된 모든 값(사용자 지정 문자열은 제외됨)은 자동으로 이스케이프되어 안전한 쿼리를 생성합니다.

.. note:: ``$builder->where()``\ 는 세 번째 매개 변수를 옵션으로 허용하며, ``false``\ 로 설정하면 CodeIgniter는 필드 또는 테이블 이름을 보호하지 않습니다.

1. key/value 메소드
^^^^^^^^^^^^^^^^^^^^

    .. literalinclude:: query_builder/021.php

    등호(=)가 추가되었습니다.

    여러 함수 호출을 사용하는 경우 AND와 함께 체인으로 연결됩니다:

    .. literalinclude:: query_builder/022.php

2. 사용자정의 key/value 메소드
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    비교를 제어하기 위해 첫 번째 매개 변수에 연산자를 포함시킬 수 있습니다:

    .. literalinclude:: query_builder/023.php

3. 연관 배열 메소드
^^^^^^^^^^^^^^^^^^^^

    .. literalinclude:: query_builder/024.php

    이 메소드를 사용하여 사용자 연산자를 포함시킬 수도 있습니다:

    .. literalinclude:: query_builder/025.php

4. 맞춤 문자열
^^^^^^^^^^^^^^^

    비교절을 직접 작성할 수 있습니다
    
    .. literalinclude:: query_builder/026.php

    
    .. warning:: 문자열 내에 사용자 지정 데이터를 사용하는 경우 데이터를 수동으로 이스케이프해야 합니다.
        그렇지 않으면 SQL 주입(SQL injection)이 발생할 수 있습니다.

    .. literalinclude:: query_builder/027.php

.. _query-builder-where-rawsql:

5. RawSql
^^^^^^^^^

    v4.2.0부터 ``$builder->where()``\ 는 원시(raw) SQL 문자열을 표현하는 ``CodeIgniter\Database\RawSql`` 인스턴스를 허용합니다.

    .. literalinclude:: query_builder/100.php

    .. warning:: ``RawSql``\ 을 사용할 때 데이터는 수동으로 이스케이프(escape)해야 합니다. 그렇지 않으면 SQL 주입(SQL injection)이 발생할 수 있습니다.

.. _query-builder-where-subquery:

6. Subqueries
^^^^^^^^^^^^^

    .. literalinclude:: query_builder/028.php

$builder->orWhere()
-------------------

이 함수는 여러 인스턴스가 OR로 결합된다는 점을 제외하고 위의 메소드와 동일합니다.

.. literalinclude:: query_builder/029.php

$builder->whereIn()
-------------------

**AND**\ 로 결합된 ``WHERE field IN ('item', 'item')`` SQL 쿼리를 생성합니다.

.. literalinclude:: query_builder/030.php

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

.. literalinclude:: query_builder/031.php

$builder->orWhereIn()
---------------------

**OR**\ 로 결합된 ``WHERE field IN ('item', 'item')`` SQL 쿼리를 생성합니다.

.. literalinclude:: query_builder/032.php

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

.. literalinclude:: query_builder/033.php

$builder->whereNotIn()
----------------------

**AND**\ 로 결합된 ``WHERE field NOT IN ('item', 'item')`` SQL 쿼리를 생성합니다.

.. literalinclude:: query_builder/034.php

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

.. literalinclude:: query_builder/035.php

$builder->orWhereNotIn()
------------------------

**OR**\ 로 결합된 ``WHERE field NOT IN ('item', 'item')`` SQL 쿼리를 생성합니다.

.. literalinclude:: query_builder/036.php

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

.. literalinclude:: query_builder/037.php

************************
유사한 데이터 찾기
************************

Like
====

$builder->like()
----------------

이 메소드를 사용하면 검색에 유용한 **LIKE**\ 절을 생성할 수 있습니다.

.. note:: 이 메소드에 전달된 모든 값은 자동으로 이스케이프됩니다.

.. note:: 모든 ``like*()`` 메소드의 변형은 메소드의 다섯 번째 매개 변수에 ``true``\ 를 전달하여 대소문자를 구분하지 않는 검색을 수행하도록 강제할 수 있습니다.
    그렇지 않으면 가능한 경우 플랫폼별 기능을 사용하여 값을 소문자로 만듭니다. (예 :``HAVING LOWER (column) LIKE '% search %'``).
    이를 위해서는 ``column`` 대신 ``LOWER(column)``\ 에 대해 인덱스를 작성해야 할 수 있습니다.

1. key/value 메소드
^^^^^^^^^^^^^^^^^^^^

    .. literalinclude:: query_builder/038.php

    메소드 호출을 여러번 하게되면 **AND**\ 와 함께 체인으로 연결됩니다.

    .. literalinclude:: query_builder/039.php

    와일드카드(%)의 위치를 제어하려면 옵션으로 지정된 세 번째 인수를 사용합니다.
    옵션 : ``before``, ``after``, ``both``\ (기본값)

    .. literalinclude:: query_builder/040.php

2. 연관 배열 메소드
^^^^^^^^^^^^^^^^^^^^

    .. literalinclude:: query_builder/041.php

.. _query-builder-like-rawsql:

3. RawSql
^^^^^^^^^

    v4.2.0부터 ``$builder->like()``\ 는 원시(raw) SQL 문자열을 표현하는 ``CodeIgniter\Database\RawSql`` 인스턴스를 허용합니다.

    .. literalinclude:: query_builder/101.php

    .. warning:: ``RawSql``\ 을 사용할 때 데이터는 수동으로 이스케이프(escape)해야 합니다. 그렇지 않으면 SQL 주입(SQL injection)이 발생할 수 있습니다.

$builder->orLike()
------------------

이 메소드는 여러 인스턴스가 **OR**\ 로 결합된다는 점을 제외하면 위의 메소드와 동일합니다.

.. literalinclude:: query_builder/042.php

$builder->notLike()
-------------------

이 메소드는 **NOT LIKE**\ 문을 생성한다는 점을 제외하면 ``like()``\ 와 동일합니다.

.. literalinclude:: query_builder/043.php

$builder->orNotLike()
---------------------

이 메소드는 여러 인스턴스가 **OR**\ 로 결합된다는 점을 제외하면 ``notLike()``\ 와 동일합니다.

.. literalinclude:: query_builder/044.php

$builder->groupBy()
-------------------

검색어의 **GROUP BY** 부분을 작성합니다.

.. literalinclude:: query_builder/045.php

여러 값의 배열을 전달할 수도 있습니다.

.. literalinclude:: query_builder/046.php

$builder->distinct()
--------------------

"DISTINCT" 키워드를 쿼리에 추가합니다.

.. literalinclude:: query_builder/047.php

$builder->having()
------------------

쿼리의 HAVING 부분을 작성합니다.
가능한 구문은 2개이며, 인수는 1개 또는 2개입니다.

.. literalinclude:: query_builder/048.php

여러 값의 배열을 전달할 수도 있습니다.

.. literalinclude:: query_builder/049.php

CodeIgniter는 기본적으로 쿼리를 이스케이프하여 데이터베이스에 전송합니다. 이스케이프되는 것을 방지하고 싶다면 옵션으로 지정된 세 번째 인수를 ``false``\ 로 설정하십시오.

.. literalinclude:: query_builder/050.php

$builder->orHaving()
--------------------

``having()``\ 과 동일하며 여러 절을 **OR**\ 로 구분합니다.

$builder->havingIn()
--------------------

**AND**\ 로 결합된 ``HAVING field IN ( 'item', 'item')`` SQL쿼리를 생성합니다.

.. literalinclude:: query_builder/051.php

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

.. literalinclude:: query_builder/052.php

$builder->orHavingIn()
----------------------

**OR**\ 로 결합된 ``HAVING field IN ( 'item', 'item')`` SQL 쿼리를 생성합니다.

.. literalinclude:: query_builder/053.php

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

.. literalinclude:: query_builder/054.php

$builder->havingNotIn()
-----------------------

**AND**\ 로 결합된 ``HAVING field NOT IN ( 'item', 'item')`` SQL 쿼리를 생성합니다.

.. literalinclude:: query_builder/055.php

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

.. literalinclude:: query_builder/056.php

$builder->orHavingNotIn()
-------------------------

**OR**\ 로 결합된 ``HAVING field NOT IN ( 'item', 'item')`` SQL 쿼리를 생성합니다.

.. literalinclude:: query_builder/057.php

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

.. literalinclude:: query_builder/058.php

$builder->havingLike()
----------------------

이 메소드를 사용하면 **HAVING** 부분 대해 **LIKE** 절을 생성할 수 있으며 검색에 유용합니다.

.. note:: 이 메소드에 전달 된 모든 값은 자동으로 이스케이프됩니다.

.. note:: 모든 ``havingLike*()`` 메소드의 변형은 메소드의 다섯 번째 매개 변수에 ``true``\ 를 전달하여 대소문자를 구분하지 않는 검색을 수행하도록 강제할 수 있습니다.
    그렇지 않으면 가능한 경우 플랫폼별 기능을 사용하여 값을 소문자로 만듭니다. (예 :``HAVING LOWER (column) LIKE '% search %'``).
    이를 위해서는 ``column`` 대신 ``LOWER(column)``\ 에 대해 인덱스를 작성해야 할 수 있습니다.

1. key/value 메소드
^^^^^^^^^^^^^^^^^^^^

    .. literalinclude:: query_builder/059.php

    메소드를 여러번 호출하는 경우 **AND**\ 와 함께 체인으로 연결됩니다.

    .. literalinclude:: query_builder/060.php

    와일드카드(**%**)의 위치를 제어하려면 옵션으로 지정된 세 번째 인수를 사용합니다.
    옵션 : ``before``, ``after``, ``both``\ (기본값)

    .. literalinclude:: query_builder/061.php

2. 연관 배열 메소드
^^^^^^^^^^^^^^^^^^^^

    .. literalinclude:: query_builder/062.php

$builder->orHavingLike()
------------------------

이 메소드는 여러 인스턴스가 **OR**\ 로 결합된다는 점을 제외하면 위의 메소드와 동일합니다.

.. literalinclude:: query_builder/063.php

$builder->notHavingLike()
-------------------------

이 메소드는 **NOT LIKE**\ 문을 생성한다는 점을 제외하면 ``havingLike()``\ 와 동일합니다.

.. literalinclude:: query_builder/064.php

$builder->orNotHavingLike()
---------------------------

이 메소드는 여러 인스턴스가 **OR**\ 로 결합된다는 점을 제외하면 ``notHavingLike()``\ 와 동일합니다.

.. literalinclude:: query_builder/065.php


****************
결과 정렬
****************

OrderBy
=======

$builder->orderBy()
-------------------

**ORDER BY** 절을 설정합니다.

첫 번째 매개 변수에는 정렬하려는 열(column) 이름이 포함됩니다.

두 번째 매개 변수를 사용하면 정렬 방향을 설정할 수 있습니다.
값은 ``ASC``, ``DESC``, ``RANDOM``

.. literalinclude:: query_builder/066.php

첫 번째 매개 변수에 사용자 정의 문자열을 전달할 수도 있습니다

.. literalinclude:: query_builder/067.php

여러개의 필드가 필요한 경우 함수를 여러번 호출할 수 있습니다.

.. literalinclude:: query_builder/068.php

방향 옵션을 **RANDOM**\ 으로 할 때 숫자로 지정하지 않으면 첫 번째 매개 변수가 무시됩니다.

.. literalinclude:: query_builder/069.php

******************************************
결과 제한(Limit) 또는 카운팅(Counting)
******************************************

Limit
=====

$builder->limit()
-----------------

쿼리에서 반환하려는 행 수를 제한할 수 있습니다

.. literalinclude:: query_builder/070.php

두 번째 매개 변수를 사용하면 결과 오프셋을 설정할 수 있습니다.

.. literalinclude:: query_builder/071.php

$builder->countAllResults()
---------------------------

쿼리 빌더를 통해 조건에 맞는 행의 갯수를 반환합니다.
``where()``, ``orWhere()``, ``like()``, ``orLike()``\ 등과 같은 쿼리 빌더 메소드를 허용합니다.

.. literalinclude:: query_builder/072.php

그러나 이 메소드는 ``select()``에 전달했을 수 있는 모든 필드 값을 재설정합니다.
유지하고 싶다면 첫 번째 매개 변수로 ``false``\ 를 전달합니다.

.. literalinclude:: query_builder/073.php

$builder->countAll()
--------------------

특정 테이블의 모든 행의 갯수를 반환니다.

.. literalinclude:: query_builder/074.php

``countAllResult()`` 메소드와 마찬가지로 이 메소드도 ``select()``\ 에 전달되었을 수 있는 모든 필드 값을 재설정합니다.
유지하고 싶다면 첫 번째 매개 변수로 ``false``\ 를 전달합니다.

.. _query-builder-union:

*************
Union queries
*************

Union
=====

$builder->union()
-----------------

둘 이상의 SELECT 문의 결과 집합을 결합하는 데 사용됩니다. 고유한 결과만 반환합니다.

.. literalinclude:: query_builder/103.php

.. note:: DBMS(예: MSSQL 및 Oracle)의 올바른 작업을 위해 쿼리는 ``SELECT * FROM ( ... ) alias``\ 로 래핑됩니다. 기본 쿼리는 항상 ``uwrp0``\ 라는 별칭을 갖습니다. ``union()``을 통해 추가된 각 후속 쿼리에는 별칭 ``uwrpN+1``\ 이 부여 됩니다.

모든 통합 쿼리는 ``union()`` 메서드가 호출된 순서에 관계없이 기본 쿼리 뒤에 추가됩니다.
``limit()``, ``orderBy()`` 메소드는 ``union()`` 이후에 호출되더라도 기본 쿼리에 추가됩니다.

경우에 따라 쿼리 결과의 레코드 수를 정렬하거나 제한해야 할 수도 있습니다.
해결책은 ``$db->newQuery()``\ 를 통해 생성된 래퍼를 사용하는 것입니다.
아래 예에서는 처음 5명의 사용자 + 마지막 5명의 사용자를 얻고 결과를 id로 정렬합니다.

.. literalinclude:: query_builder/104.php

$builder->unionAll()
--------------------

동작은 ``union()`` 메서드와 동일하지만 모든 결과가 반환됩니다.

**************
쿼리 그룹화
**************

Group
=====

쿼리 그룹화를 사용하면 WHERE절 그룹을 괄호로 묶어 그룹을 만들 수 있습니다.
이를 이요하여 복잡한 WHERE절을 쿼리로 만들 수 있습니다. 
중첩 그룹이 지원됩니다.

.. literalinclude:: query_builder/075.php

.. note:: 그룹은 균형을 유지해야합니다. 모든 ``groupStart()``\ 가 ``groupEnd()``\ 와 쌍으로 일치하는지 확인하십시오.

$builder->groupStart()
----------------------

쿼리의 **WHERE**\ 절에 여는 괄호를 추가하여 새 그룹을 시작합니다.

$builder->orGroupStart()
------------------------

쿼리의 **WHERE**\ 절에 **OR** 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

$builder->notGroupStart()
-------------------------

쿼리의 **WHERE**\ 절에 **NOT** 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

$builder->orNotGroupStart()
---------------------------

쿼리의 **WHERE**\ 절에 **OR NOT** 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

$builder->groupEnd()
--------------------

쿼리의 **WHERE**\ 절에 닫는 괄호를 추가하여 현재 그룹을 종료합니다.

$builder->havingGroupStart()
----------------------------

쿼리의 **HAVING**\ 절에 여는 괄호를 추가하여 새 그룹을 시작합니다.

$builder->orHavingGroupStart()
------------------------------

쿼리의 **HAVING**\ 절에 **OR** 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

$builder->notHavingGroupStart()
-------------------------------

쿼리의 **HAVING**\ 절에 **NOT** 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

$builder->orNotHavingGroupStart()
---------------------------------

쿼리의 **HAVING**\ 절에 **OR NOT** 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

$builder->havingGroupEnd()
--------------------------

쿼리의 **HAVING**\ 절에 닫는 괄호를 추가하여 현재 그룹을 종료합니다.

********************
Inserting 데이타
********************

Insert
======

$builder->insert()
------------------

제공한 데이터를 기반으로 Insert 문자열을 생성하고 쿼리를 실행합니다.
**배열** 또는 **객체(object)**\ 를 메소드에 전달할 수 있습니다. 
다음은 배열을 사용하는 예입니다

.. literalinclude:: query_builder/076.php

첫 번째 매개 변수는 값의 연관 배열입니다.

다음은 객체를 사용하는 예입니다

.. literalinclude:: query_builder/077.php

첫 번째 매개 변수는 객체입니다.

.. note:: 모든 값은 자동으로 이스케이프됩니다.

$builder->ignore()
------------------

제공한 데이터를 기반으로 인서트 무시 문자열(insert ignore string)을 생성하고 쿼리를 실행합니다.
따라서 동일한 기본 키를 가진 항목이 이미 있으면 쿼리가 인서트(insert)되지 않습니다.
선택적으로 **boolean**\ 을 메소드에 전달할 수 있습니다.
**insertBatch**, **update**, **delete**\ (지원되는 경우)에서도 사용할 수 있습니다.


위 예제의 배열을 사용한 예제입니다.

.. literalinclude:: query_builder/078.php

$builder->getCompiledInsert()
-----------------------------

``$builder->insert()``\ 와 같이 Insert 쿼리를 컴파일하지만 쿼리를 *실행*\ 하지는 않습니다.
이 메소드는 SQL 쿼리를 문자열로 반환합니다.

.. literalinclude:: query_builder/079.php

첫 번째 매개 변수를 사용하면 쿼리 빌더의 쿼리를 재설정할 지 여부를 설정할 수 있습니다. (기본적으로 ``$builder->insert()``\ 와 같습니다)

.. literalinclude:: query_builder/080.php

두 번째 쿼리가 작동한 이유는 첫 번째 매개변수가 ``false``\ 로 설정되었기 때문입니다.

.. note:: 이 방법은 insertBatch() 에서는 작동하지 않습니다.

insertBatch
===========

$builder->insertBatch()
-----------------------

제공한 데이터를 기반으로 Insert 문자열을 생성하고 쿼리를 실행합니다.
**배열** 또는 **객체(object)**\ 를 함수에 전달할 수 있습니다. 
다음은 배열을 사용하는 예입니다

.. literalinclude:: query_builder/081.php

첫 번째 매개 변수는 값의 연관 배열입니다.

.. note:: 모든 값은 자동으로 이스케이프됩니다.

*******************
Updating 데이타
*******************

Update
======

$builder->replace()
-------------------

이 메소드는 기본적으로 *PRIMARY* 와 *UNIQUE* 키를 기준으로 ``DELETE + INSERT``\ 에 대한 SQL 표준인 ``REPLACE``\ 문을 실행합니다.
이것으로 당신은 ``select()``, ``update()``, ``delete()``, ``insert()``\ 의 조합으로 구성된 복잡한 논리를 구현할 필요가 없어집니다.

.. literalinclude:: query_builder/082.php

위의 예에서 *title* 필드가 기본 키라고 가정하면 *title* 값으로 'My title'\ 이 포함된 행은 새 행 데이터로 대체되어 삭제됩니다.

``set()`` 메소드 사용도 허용되며 ``insert()``\ 와 마찬가지로 모든 필드가 자동으로 이스케이프됩니다.

$builder->set()
---------------

이 메소드를 사용하면 Insert 또는 Update 값을 설정할 수 있습니다.

**데이터 배열을 직접 Insert() 또는 Update() 메소드로 전달하는 대신 사용할 수 있습니다.**

.. literalinclude:: query_builder/083.php

여러번 사용하는 경우 Insert 또는 Update 수행 여부에 따라 올바르게 조립됩니다.

.. literalinclude:: query_builder/084.php

``set()``\ 은 옵션으로 세 번째 매개 변수 (``$escape``)도 허용하며 이 값을 ``false``\ 로 설정하면 데이터가 이스케이프되지 않습니다.
차이점을 설명하기 위해 다음 예제는 이스케이프 매개 변수를 사용하거나 사용하지 않고 ``set()``\ 을 사용합니다.

.. literalinclude:: query_builder/085.php

이 메소드에 연관 배열을 전달할 수 있습니다

.. literalinclude:: query_builder/086.php

또는 객체

.. literalinclude:: query_builder/087.php

$builder->update()
------------------

업데이트 문자열을 생성하고 제공한 데이터를 기반으로 쿼리를 실행합니다.
**배열** 또는 **객체**\ 를 함수에 전달할 수 있습니다.
다음은 배열을 사용하는 예입니다

.. literalinclude:: query_builder/088.php

또는 객체를 제공할 수 있습니다.

.. literalinclude:: query_builder/089.php

.. note:: 모든 값은 자동으로 이스케이프됩니다.

``$builder->where()`` 함수를 사용하면 **WHERE**\ 절을 설정할 수 있습니다.
선택적으로 이 정보를 문자열로 ``update()`` 메소드에 직접 전달할 수 있습니다

.. literalinclude:: query_builder/090.php

또는 배열로

.. literalinclude:: query_builder/091.php

업데이트를 수행할 때 위에서 설명한 ``$builder->set()`` 메소드를 사용할 수도 있습니다.

UpdateBatch
===========

$builder->updateBatch()
-----------------------

업데이트 문자열을 생성하고 제공한 데이터를 기반으로 쿼리를 실행합니다.
**배열** 또는 **객체**\ 를 메소드에 전달할 수 있습니다.
다음은 배열을 사용하는 예입니다

.. literalinclude:: query_builder/092.php

첫 번째 매개 변수는 값의 연관 배열이고, 두 번째 매개 변수는 where절에 사용할 키입니다.

.. note:: 모든 값은 자동으로 이스케이프됩니다.

.. note:: ``affectedRows()``는 작동 방식이 달라 이 메소드에 대한 적절한 결과를 제공하지 않습니다. 대신 ``updateBatch()``\ 는 영향을 받는 행 수를 반환합니다.

$builder->getCompiledUpdate()
-----------------------------

이것은 **INSERT** SQL 문자열대신 **UPDATE** SQL 문자열을 생성한다는 점을 제외하고 ``$builder->getCompiledInsert()``\ 와 동일한 방식으로 작동합니다.

자세한 내용은 `$builder->getCompiledInsert()`\ 에 대한 설명서를 참조하십시오.

.. note:: updateBatch()\ 는 이 메소드가 작동하지 않습니다.

**********************
데이터 삭제(Deleting)
**********************

Delete
======

$builder->delete()
------------------

DELETE SQL 문자열을 생성하고 쿼리를 실행합니다.

.. literalinclude:: query_builder/093.php

첫 번째 매개 변수는 where절입니다.
함수의 첫 번째 매개 변수에 데이터를 전달하는 대신 ``where()`` 또는 ``orWhere()`` 메소드를 사용할 수 있습니다.

.. literalinclude:: query_builder/094.php

테이블에서 모든 데이터를 삭제하려면 ``truncate()`` 함수 또는 ``emptyTable()`` 메소드를 사용합니다.

$builder->emptyTable()
----------------------

DELETE SQL 문자열을 생성하고 쿼리를 실행합니다.

.. literalinclude:: query_builder/095.php

$builder->truncate()
--------------------

TRUNCATE SQL 문자열을 생성하고 쿼리를 실행합니다.

.. literalinclude:: query_builder/096.php

.. note:: TRUNCATE 명령을 사용할 수 없으면 ``truncate()``\ 가 "DELETE FROM table"\ 로 실행됩니다.

$builder->getCompiledDelete()
-----------------------------

이것은 **INSERT** SQL 문자열 대신 **DELETE** SQL 문자열을 생성한다는 점을 제외하고 ``$builder->getCompiledInsert()``\ 와 동일한 방식으로 작동합니다.

자세한 내용은 ``$builder->getCompiledInsert()`` 설명서를 참조하십시오.

***************************
메소드 체이닝(Chaining)
***************************

메소드 체인을 사용하면 여러 메소드를 연결하여 구문을 단순화 할 수 있습니다.
다음 예제를 살펴보십시오.

.. literalinclude:: query_builder/097.php

.. _ar-caching:

***********************
쿼리 빌더 재설정
***********************

ResetQuery
==========

$builder->resetQuery()
----------------------

쿼리 빌더를 재 설정하면 ``$builder->get()`` 또는 ``$builder->insert()``\ 와 같은 메소드를 사용하여 쿼리를 실행하지 않고 쿼리를 새로 시작할 수 있습니다.

이는 쿼리 빌더를 사용하여 SQL을 생성(ex. ``$builder->getCompiledSelect()``)한 후 다음 작업을 진행시 유용합니다.

.. literalinclude:: query_builder/098.php

***************
Class Reference
***************

.. php:namespace:: CodeIgniter\Database

.. php:class:: BaseBuilder

    .. php:method:: db()

        :returns: 사용중인 데이터베이스 연결
        :rtype: ``ConnectionInterface``

        연결된 데이터베이스 객체를  ``$db``\ 로 반환합니다.
        ``insertID()``\ 나 ``errors()``\ 와 같이 쿼리빌더(Query Builder)에서 직접 사용할 수 없는 ``ConnectionInterface`` 메소드를 액세스할 때 유용합니다.

    .. php:method:: resetQuery()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리 빌더 상태를 재설정합니다.
        특정 조건에서 쿼리를 작성 취소하려는 경우에 유용합니다.

    .. php:method:: countAllResults([$reset = true])

        :param bool $reset: SELECT 재설정 여부
        :returns: 쿼리 결과의 행의 갯수
        :rtype: int

        쿼리 빌더를 통하여 반환한 모든 레코드를 수를 계산하는 플랫폼별 쿼리 문자열을 생성 실행합니다.

    .. php:method:: countAll([$reset = true])

        :param bool $reset: SELECT 재설정 여부
        :returns: 쿼리 결과의 행의 갯수
        :rtype: int

        쿼리 빌더를 통하여 반환한 모든 레코드를 수를 계산하는 플랫폼별 쿼리 문자열을 생성 실행합니다.

    .. php:method:: get([$limit = null[, $offset = null[, $reset = true]]]])

        :param int $limit: LIMIT 절
        :param int $offset: OFFSET 절
        :param bool $reset: 쿼리 빌더 값 재설정 여부
        :returns: ``\CodeIgniter\Database\ResultInterface`` instance (method chaining)
        :rtype: ``\CodeIgniter\Database\ResultInterface``

        호출된 쿼리 빌더 메소드를 기반으로 SELECT 문을 컴파일하고 실행합니다.

    .. php:method:: getWhere([$where = null[, $limit = null[, $offset = null[, $reset = true]]]]])

        :param string $where: WHERE 절
        :param int $limit: LIMIT 절
        :param int $offset: OFFSET 절
        :param bool $reset: 쿼리 빌더 값 재설정 여부
        :returns: ``\CodeIgniter\Database\ResultInterface`` instance (method chaining)
        :rtype: ``\CodeIgniter\Database\ResultInterface``

        ``get()``\ 과 동일하지만 WHERE를 직접 추가할 수 있습니다.

    .. php:method:: select([$select = '*'[, $escape = null]])

        :param array|RawSql|string $select: 쿼리의 SELECT 부분
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT절을 추가합니다.

    .. php:method:: selectAvg([$select = ''[, $alias = '']])

        :param string $select: 평균을 계산하는 필드
        :param string $alias: 결과 값 이름의 별명
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT AVG(field)절을 추가합니다.

    .. php:method:: selectMax([$select = ''[, $alias = '']])

        :param string $select: 최대 값을 계산하는 필드
        :param string $alias: 결과 값 이름의 별명
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT MAX(field)절을 추가합니다.

    .. php:method:: selectMin([$select = ''[, $alias = '']])

        :param string $select: 최소 값을 계산하는 필드
        :param string $alias: 결과 값 이름의 별명
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT MIN(field)절을 추가합니다.

    .. php:method:: selectSum([$select = ''[, $alias = '']])

        :param string $select: 합계를 계산하는 필드
        :param string $alias: 결과 값 이름의 별명
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT SUM(field)절을 추가합니다.

    .. php:method:: selectCount([$select = ''[, $alias = '']])

        :param string $select: 카운트할 필드
        :param string $alias: 결과 값 이름의 별명
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT COUNT(field)절을 추가합니다.

    .. php:method:: selectSubquery(BaseBuilder $subquery, string $as)

        :param string $subquery: BaseBuilder 인스턴스
        :param string $as: 결과 값 이름의 별칭
        :returns:   ``BaseBuilder`` instance (method chaining)
        :rtype:     ``BaseBuilder``

        선택 항목에 서브쿼리를 추가합니다.

    .. php:method:: distinct([$val = true])

        :param bool $val: "distinct" 플래그 설정 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리 빌더가 DISTINCT 절을 쿼리의 SELECT 부분에 추가하도록 지시하는 플래그를 설정합니다.

    .. php:method:: from($from[, $overwrite = false])

        :param mixed $from: 테이블 명; string 또는 array
        :param bool $overwrite: 기존 설정된 첫 번째 테이블 제거 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리의 FROM 절을 지정합니다.

    .. php:method:: fromSubquery($from, $alias)

        :param BaseBuilder $from: BaseBuilder class의 인스턴스
        :param string      $alias: 서브쿼리 별칭
        :returns:   ``BaseBuilder`` instance (method chaining)
        :rtype:     ``BaseBuilder``

        Specifies the ``FROM`` clause of a query using a subquery.

    .. php:method:: join($table, $cond[, $type = ''[, $escape = null]])

        :param string $table: 결합(Join)할 테이블 이름
        :param string $cond: JOIN ON 조건
        :param string $type: JOIN type
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 JOIN절을 추가합니다.

    .. php:method:: where($key[, $value = null[, $escape = null]])

        :param mixed $key: 비교할 필드 이름 또는 연관 배열
        :param mixed $value: 단일 키인 경우 이 값과 비교
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        쿼리의 WHERE 부분을 생성합니다. 여러번 호출할 경우 'AND'로 연결합니다.

    .. php:method:: orWhere($key[, $value = null[, $escape = null]])

        :param array|RawSql|string $key: 비교할 필드 이름 또는 연관 배열
        :param mixed $value: 단일 키인 경우 이 값과 비교
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        쿼리의 WHERE 부분을 생성합니다. 여러번 호출할 경우 'OR'로 연결합니다.

    .. php:method:: orWhereIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검색할 필드
        :param array|BaseBulder|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리의 WHERE field IN('item', 'item') 부분을 생성합니다. 'OR'로 연결합니다.

    .. php:method:: orWhereNotIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검색할 필드
        :param array|BaseBulder|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리의 WHERE field NOT IN('item', 'item') 부분을 생성합니다. 'OR'로 연결합니다.

    .. php:method:: whereIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검사 할 필드 이름
        :param array|BaseBulder|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리의 WHERE field IN('item', 'item') 부분을 생성합니다. 'AND'로 연결합니다.

    .. php:method:: whereNotIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검사 할 필드 이름
        :param array|BaseBulder|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리의 WHERE field NOT IN('item', 'item') 부분을 생성합니다. 'AND'로 연결합니다.

    .. php:method:: groupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        AND를 사용하여 그룹 표현식을 시작합니다.

    .. php:method:: orGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        OR을 사용하여 그룹 표현식을 시작합니다.

    .. php:method:: notGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        AND NOT을 사용하여 그룹 표현식을 시작합니다.

    .. php:method:: orNotGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        OR NOT을 사용하여 그룹 표현식을 시작합니다.

    .. php:method:: groupEnd()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: object

        그룹 표현식을 종료합니다.

    .. php:method:: like($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param array|RawSql|string $field: Field name
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 AND를 사용하여 LIKE 절을 쿼리에 추가합니다.

    .. php:method:: orLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 OR을 사용하여 LIKE 절을 쿼리에 추가합니다.

    .. php:method:: notLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 AND를 사용하여 NOT LIKE 절을 쿼리에 추가합니다.

    .. php:method:: orNotLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 OR을 사용하여 NOT LIKE 절을 쿼리에 추가합니다.

    .. php:method:: having($key[, $value = null[, $escape = null]])

        :param mixed $key: 필드/값 쌍의 식별자(문자열) 또는 연관 배열
        :param string $value: Value sought if $key is an identifier
        :param string $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 AND를 사용하여 HAVING 절을 쿼리에 추가합니다.

    .. php:method:: orHaving($key[, $value = null[, $escape = null]])

        :param mixed $key: 필드/값 쌍의 식별자(문자열) 또는 연관 배열
        :param string $value: Value sought if $key is an identifier
        :param string $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 OR을 사용하여 HAVING 절을 쿼리에 추가합니다.

    .. php:method:: orHavingIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검색할 필드
        :param array|BaseBulder|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리에 HAVING field IN('item', 'item') 절을 추가합니다. OR로 분리.

    .. php:method:: orHavingNotIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검색할 필드
        :param array|BaseBulder|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리에 HAVING field NOT IN('item', 'item') 절을 추가합니다. OR로 분리.

    .. php:method:: havingIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검사 할 필드 이름
        :param array|BaseBulder|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리에 HAVING field IN('item', 'item') 절을 추가합니다. AND로 분리.

    .. php:method:: havingNotIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검사 할 필드 이름
        :param array|BaseBulder|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리에 HAVING field NOT IN('item', 'item') 절을 추가합니다. AND로 분리.

    .. php:method:: havingLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 AND를 사용하여 HAVING 부분에 LIKE 절을 쿼리에 추가합니다.

    .. php:method:: orHavingLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 OR을 사용하여 HAVING 부분에 LIKE 절을 쿼리에 추가합니다.

    .. php:method:: notHavingLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 AND를 사용하여 HAVING 부분에 NOT LIKE 절을 쿼리에 추가합니다.

    .. php:method:: orNotHavingLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 OR을 사용하여 HAVING 부분에 NOT LIKE 절을 쿼리에 추가합니다.

    .. php:method:: havingGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        AND를 사용하여 HAVING 절에 대한 그룹 표현식을 시작합니다.

    .. php:method:: orHavingGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        OR을 사용하여 HAVING 절에 대한 그룹 표현식을 시작합니다.

    .. php:method:: notHavingGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        AND NOT을 사용하여 HAVING 절에 대한 그룹 표현식을 시작합니다.

    .. php:method:: orNotHavingGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        OR NOT을 사용하여 HAVING 절에 대한 그룹 표현식을 시작합니다.

    .. php:method:: havingGroupEnd()

        :returns: ``BaseBuilder`` instance
        :rtype: object

        HAVING 절에 대한 그룹 표현식을 종료합니다.

    .. php:method:: groupBy($by[, $escape = null])

        :param mixed $by: Field(s) to group by; string or array
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 GROUP BY절을 추가합니다.

    .. php:method:: orderBy($orderby[, $direction = ''[, $escape = null]])

        :param string $orderby: 정렬할 필드
        :param string $direction: The order requested - ASC, DESC or random
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 ORDER BY절을 추가합니다.

    .. php:method:: limit($value[, $offset = 0])

        :param int $value: 결과를 제한할 행 수
        :param int $offset: 건너 뛸 행 수
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 LIMIT and OFFSET절을 추가합니다.

    .. php:method:: offset($offset)

        :param int $offset: 건너 뛸 행 수
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 OFFSET절을 추가합니다.

    .. php:method:: union($union)

        :param BaseBulder|Closure $union: Union 쿼리
        :returns:   ``BaseBuilder`` instance (method chaining)
        :rtype:     ``BaseBuilder``

        ``UNION``\ 절을 추가합니다.

    .. php:method:: unionAll($union)

        :param BaseBulder|Closure $union: Union 쿼리
        :returns:   ``BaseBuilder`` instance (method chaining)
        :rtype:     ``BaseBuilder``

        ``UNION ALL``\ 절을 추가합니다.

    .. php:method:: set($key[, $value = ''[, $escape = null]])

        :param mixed $key: 필드 이름 또는 필드/값 쌍 배열
        :param string $value: $key가 단일 필드인 경우 필드 값
        :param bool $escape: 값을 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        ``insert()``, ``update()``, ``replace()``\ 에 전달할 필드/값 쌍을 추가합니다.

    .. php:method:: insert([$set = null[, $escape = null]])

        :param array $set: 필드/값 쌍 배열
        :param bool $escape: 값을 이스케이프할지 여부
        :returns: true on success, false on failure
        :rtype: bool

        INSERT 문을 컴파일하고 실행합니다.

    .. php:method:: insertBatch([$set = null[, $escape = null[, $batch_size = 100]]])

        :param array $set: Insert할 데이터
        :param bool $escape: 값을 이스케이프할지 여부
        :param int $batch_size: 한 번에 Insert할 행의 수
        :returns: Insert된 행의 수, 실패시 false
        :rtype: mixed

        배치 ``INSERT``\ 문을 컴파일하고 실행합니다.

        .. note:: ``$batch_size`` 이상의 행이 제공되면, 각각 ``$batch_size`` 행을 Insert하려고 하는 여러 INSERT 쿼리가 실행됩니다.

    .. php:method:: setInsertBatch($key[, $value = ''[, $escape = null]])

        :param mixed $key: 필드 이름 또는 필드/값 쌍 배열
        :param string $value: $key가 단일 필드인 경우 필드 값
        :param bool $escape: 값을 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        ``insertBatch()``\ 를 통해 테이블에 Insert할 필드/값 쌍을 추가합니다.

    .. php:method:: update([$set = null[, $where = null[, $limit = null]]])

        :param array $set: 필드/값 쌍의 연관 배열
        :param string $where: WHERE 절
        :param int $limit: LIMIT 절
        :returns: true on success, false on failure
        :rtype: bool

        UPDATE 문을 컴파일하고 실행합니다.

    .. php:method:: updateBatch([$set = null[, $value = null[, $batch_size = 100]]])

        :param array $set: 필드 이름 또는 필드/값 쌍의 연관 배열
        :param string $value: $set가 단일 필드인 경우 필드 값
        :param int $batch_size: 단일 쿼리에 그룹화할 조건 수입니다.
        :returns: 업데이트된 행 수 또는 실패 시 ``false``\ 입니다.
        :rtype: mixed

        배치 ``UPDATE``\ 문을 컴파일하고 실행합니다.

        .. note:: ``$batch_size`` 이상의 필드/값 쌍이 제공되면 각각 ``$batch_size`` 필드/값 쌍을 Update하는 여러 쿼리가 실행됩니다.

    .. php:method:: setUpdateBatch($key[, $value = ''[, $escape = null]])

        :param mixed $key: 필드 이름 또는 필드/값 쌍 배열
        :param string $value: $key가 단일 필드인 경우 필드 값
        :param bool $escape: 값을 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        ``updateBatch()``\ 를 통해 테이블에서 업데이트할 필드/값 쌍을 추가합니다.

    .. php:method:: replace([$set = null])

        :param array $set: 필드/값 쌍의 연관 배열
        :returns: true on success, false on failure
        :rtype: bool

        REPLACE 문을 컴파일하고 실행합니다.

    .. php:method:: delete([$where = ''[, $limit = null[, $reset_data = true]]])

        :param string $where: WHERE 절
        :param int $limit: LIMIT 절
        :param bool $reset_data: 쿼리 "write" 절을 재설정하려면 true
        :returns: ``BaseBuilder`` instance (method chaining) or false on failure
        :rtype: mixed

        DELETE 쿼리를 컴파일하고 실행합니다.

    .. php:method:: increment($column[, $value = 1])

        :param string $column: 증가시킬 열(column)의 이름
        :param int $value:  증가시키는 양

        필드 값을 지정된 양만큼 증가시킵니다.
        필드가 VARCHAR와 같은 숫자 필드가 아닌 경우 $value로 대체될 수 있습니다.

    .. php:method:: decrement($column[, $value = 1])

        :param string $column: 감소시킬 열(column)의 이름
        :param int $value:  감소시키는 양

        필드 값을 지정된 양만큼 감소시킵니다.
        필드가 VARCHAR와 같은 숫자 필드가 아닌 경우 $value로 대체될 수 있습니다.

    .. php:method:: truncate()

        :returns: true on success, false on failure
        :rtype: bool

        테이블에서 TRUNCATE 문을 실행합니다.

        .. note:: 사용중인 데이터베이스 플랫폼이 TRUNCATE를 지원하지 않으면 DELETE 문이 대신 사용됩니다.

    .. php:method:: emptyTable()

        :returns: true on success, false on failure
        :rtype: bool

        DELETE 문을 통해 테이블에서 모든 레코드를 삭제합니다.

    .. php:method:: getCompiledSelect([$reset = true])

        :param bool $reset: 현재 QB 값을 재설정할지 여부
        :returns: 컴파일된 SQL 문의 문자열
        :rtype: string

        SELECT 문을 컴파일하여 문자열로 반환합니다.

    .. php:method:: getCompiledInsert([$reset = true])

        :param bool $reset: 현재 QB 값을 재설정할지 여부
        :returns: 컴파일된 SQL 문의 문자열
        :rtype: string

        INSERT 문을 컴파일하여 문자열로 리턴합니다.

    .. php:method:: getCompiledUpdate([$reset = true])

        :param bool $reset: 현재 QB 값을 재설정할지 여부
        :returns: 컴파일된 SQL 문의 문자열
        :rtype: string

        UPDATE 문을 컴파일하여 문자열로 리턴합니다.

    .. php:method:: getCompiledDelete([$reset = true])

        :param bool $reset: 현재 QB 값을 재설정할지 여부
        :returns: 컴파일된 SQL 문의 문자열
        :rtype: string

        DELETE 문을 컴파일하여 문자열로 리턴합니다.
