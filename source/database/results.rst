########################
쿼리 결과 생성
########################

쿼리 결과를 생성하는 몇 가지 방법이 있습니다.

.. contents::
    :local:
    :depth: 2

***************************
결과 배열(Result Arrays)
***************************

getResult()
===========

이 메소드는 쿼리 결과를 **objects**\ 의 배열로 반환하고, 실패시는 **빈 배열**\ 을 반환합니다. 
일반적으로 아래와 같이 foreach 루프에 사용합니다.

.. literalinclude:: results/001.php

위의 메소드는``getResultObject()``\ 의 별칭입니다.

결과를 배열의 배열로 얻으려면 문자열 'array'를 전달합니다.

.. literalinclude:: results/002.php

위의 사용법은 ``getResultArray()``\ 의 별칭입니다.

``getResult()``\ 의 각 결과 객체에 대해 인스턴스화 할 클래스를 나타내는 문자열을 전달할 수도 있습니다.

.. literalinclude:: results/003.php

위의 메소드는``getCustomResultObject()``\ 의 별칭입니다.

getResultArray()
================

이 메소드는 조회 결과를 순수한 배열로 반환하거나 결과가 생성되지 않으면 빈 배열을 반환합니다. 
일반적으로 이것을 아래와 같은 foreach 루프에서 사용합니다

.. literalinclude:: results/004.php

**************************
결과 행(Result Rows)
**************************

getRow()
========

이 메소드는 단일 결과 행을 반환합니다.
쿼리에 둘 이상의 행이 있으면 첫 번째 행만 반환합니다.
결과는 **객체**\ 로 반환됩니다. 사용법 예는 다음과 같습니다.

.. literalinclude:: results/005.php

특정 행을 반환하려면 첫 번째 매개 변수에 행 번호를 숫자로 제출하십시오.

.. literalinclude:: results/006.php

행을 인스턴스화하는 클래스의 이름인 두 번째 문자열 매개 변수를 추가할 수도 있습니다.

.. literalinclude:: results/007.php

getRowArray()
=============

위의 ``row()`` 메소드와 동일하지만 배열을 반환합니다. 

.. literalinclude:: results/008.php

특정 행을 반환하려면 첫 번째 매개 변수에서 행 번호를 숫자로 제출하십시오.

.. literalinclude:: results/009.php

또한 이러한 변형을 사용하여 결과를 "forward/backwards/first/last"\ 로 검색할 수 있습니다:

    | ``$row = $query->getFirstRow()``
    | ``$row = $query->getLastRow()``
    | ``$row = $query->getNextRow()``
    | ``$row = $query->getPreviousRow()``

매개 변수에 "array"라는 단어를 넣지 않으면 기본적으로 객체를 반환합니다.:

    | ``$row = $query->getFirstRow('array')``
    | ``$row = $query->getLastRow('array')``
    | ``$row = $query->getNextRow('array')``
    | ``$row = $query->getPreviousRow('array')``

.. note:: 위의 모든 메소드는 전체 결과를 메모리에 로드합니다.(프리 페치) 큰 결과 집합을 처리하려면 ``getUnbufferedRow()``\ 를 사용하십시오.

getUnbufferedRow()
==================

이 메소드는 ``row()``\ 와 같이 메모리에서 전체 결과를 프리 페치 하지 않고, 단일 결과 행을 반환합니다.
쿼리에 둘 이상의 행이 있으면 현재 행을 반환하고 내부 데이터 포인터를 앞으로 이동합니다.

.. literalinclude:: results/010.php

MySQLi와 함께 사용할 때 MySQLi의 결과 모드를 ``MYSQLI_USE_RESULT``\ 로 설정하면 메모리를 절약할 수 있습니다.
이 방법은 일반적으로 사용할 때 권장되지 않지만 많은 결과를 csv 파일로 덤프할 경우 유용할 수 있습니다.
결과 모드를 변경할 경우 결과 모드와 관련된 트레이드오프를 인식해야 합니다.

.. literalinclude:: results/011.php

.. note:: ``MYSQLI_USE_RESULT``\ 를 사용할 경우 모든 레코드를 가져오거나 ``freeResult()`` 호출이 수행될 때까지 동일한 연결에서 모든 후속 호출에 오류가 발생합니다.
    ``getNumRows()`` 메서드는 데이터 포인터의 현재 위치를 기준으로 행 수를 반환합니다. 
    모든 레코드를 가져오거나 ``freeResult()`` 호출이 수행될 때까지 MyISAM 테이블은 잠긴 상태로 유지됩니다.

반환된 값의 유형을 지정하기 위해 선택적으로 'object'(기본값) 또는 'array'를 전달할 수 있습니다.

.. literalinclude:: results/012.php

*********************
사용자 정의 결과 객체
*********************

``getResult()``\ 와 ``getResultArray()`` 메소드가 허용하는대로 ``stdClass`` 또는 배열 대신 사용자 정의 클래스의 인스턴스로 결과를 반환할 수 있습니다.
클래스가 아직 메모리에 로드되지 않은 경우 오토로더가 로드를 시도합니다.
객체는 데이터베이스에서 반환된 모든 값을 속성으로 설정합니다.
선언되었으나 공개되지 않은 속성의 경우 ``__set()`` 메소드를 제공하여 설정할 수 있습니다.

.. literalinclude:: results/013.php

아래 나열된 두 가지 메소드 외에 ``getFirstRow()``, ``getLastRow()``, ``getNextRow()``, ``getPreviousRow()`` 메소드에서도 클래스 이름을 사용하여 결과를 다음과 같이 반환할 수 있습니다.

getCustomResultObject()
=======================

요청된 클래스의 인스턴스 배열로 전체 결과 집합을 반환합니다.
인스턴스화 할 클래스의 이름을 단일 매개 변수로 사용합니다.

.. literalinclude:: results/014.php

getCustomRowObject()
====================

쿼리 결과에서 단일 행을 반환합니다.
첫 번째 매개 변수는 결과의 행 번호입니다.
두 번째 매개 변수는 인스턴스화 할 클래스 이름입니다.

.. literalinclude:: results/015.php

``getRow()`` 메소드를 같은 방식으로 사용할 수 있습니다.

.. literalinclude:: results/016.php

*********************
결과 헬퍼 메소드
*********************

getFieldCount()
===============

쿼리에서 반환한 FIELDS(컬럼)의 갯수 입니다.
쿼리 결과(result) 객체를 사용하여 메소드를 호출해야 합니다.

.. literalinclude:: results/017.php

getFieldNames()
===============

쿼리에서 반환한 FIELDS(컬럼)의 이름을 가진 배열을 반환합니다.
쿼리 결과(result) 객체를 사용하여 메소드를 호출해야 합니다.

.. literalinclude:: results/018.php

getNumRows()
============

쿼리로 반환된 레코드 수입니다. 
쿼리 결과 객체(object)를 사용하여 메소드를 호출해야 합니다.

.. literalinclude:: results/019.php

.. note:: SQLite3의 경우 레코드 수를 반환하는 효율적인 메소드가 없기 때문에 CodeIgniter는 
    쿼리 결과 레코드를 내부적으로 가져오고 버퍼링한 결과 레코드 배열의 카운트를 반환하므로 비효율적일 수 있습니다.

freeResult()
============

결과(result)와 연관된 메모리를 비우고 결과 자원(resource) ID를 삭제합니다.
일반적으로 PHP는 스크립트 실행이 끝날때 자동으로 메모리를 비웁니다.
그러나 특정 스크립트에서 많은 쿼리를 실행하는 경우, 메모리 소비를 줄이기 위해 각 쿼리 결과가 생성된 후 결과를 해제할 수 있습니다.

.. literalinclude:: results/020.php

dataSeek()
==========

이 메소드는 다음 결과 행에 대한 내부 포인터를 페치하도록 설정합니다.
``getUnbufferedRow()``\ 와 함께 사용할 때 유용합니다.

양의 정수 값만 사용할 수 있으며, 기본값은 0입니다. 성공하면 TRUE, 실패하면 FALSE를 반환합니다.

.. literalinclude:: results/021.php

.. note:: 데이터베이스 드라이버가 이 기능을 지원하지 않을때 FALSE를 반환합니다. 가장 주의할 점은 PDO와 함께 사용할 수 없다는 것입니다.

***************
Class Reference
***************

.. php:namespace:: CodeIgniter\Database

.. php:class:: BaseResult

    .. php:method:: getResult([$type = 'object'])

        :param string $type: 요청한 결과 유형 - array, object, class name
        :returns: 페치된 행을 포함하는 배열
        :rtype: array

        ``getResultArray()``, ``getResultObject()``, ``getCustomResultObject()`` 메소드에 대한 랩퍼(wrapper).

        사용법: `결과 배열(Result Arrays)`_.

    .. php:method:: getResultArray()

        :returns: 페치된 행을 포함하는 배열
        :rtype: array

        쿼리 결과를 각 행이 연관(associative) 배열로 이루어진 배열로 반환합니다.

        사용법: `결과 배열(Result Arrays)`_.

    .. php:method:: getResultObject()

        :returns: 페치된 행을 포함하는 배열
        :rtype: array

        쿼리 결과를 각 행이 ``stdClass`` 객체로 이루어진 배열로 반환합니다.

        사용법: `결과 배열(Result Arrays)`_.

    .. php:method:: getCustomResultObject($class_name)

        :param string $class_name: 결과 행의 클래스명
        :returns: 페치된 행을 포함하는 배열
        :rtype: array

        쿼리 결과를 각 행이 지정된 클래스의 인스턴스로 이루어진 배열로 반환합니다

    .. php:method:: getRow([$n = 0[, $type = 'object']])

        :param int $n: 쿼리 결과(query result) 행의 인덱스
        :param string $type: 요청한 결과의 유형 - array, object, class name
        :returns: 요청 된 행, 존재하지 않는 경우 null
        :rtype: mixed

        ``getRowArray()``, ``getRowObject()``, ``getCustomRowObject()``  메소드에 대한 랩퍼(wrapper).

        사용법: `결과 행(Result Rows)`_.

    .. php:method:: getUnbufferedRow([$type = 'object'])

        :param string $type: 요청한 결과의 유형 - array, object, class name
        :returns: 결과 집합의 다음 행, 존재하지 않는 경우 null
        :rtype: mixed

        다음 결과 행을 가져 와서 요청된 유형으로 반환합니다.

        사용법: `결과 행(Result Rows)`_.

    .. php:method:: getRowArray([$n = 0])

        :param int $n: 쿼리 결과(query result) 행의 인덱스
        :returns: 요청 된 행, 존재하지 않는 경우 null
        :rtype: array

        요청 된 결과행을 연관 배열로 반환합니다.

        사용법: `결과 행(Result Rows)`_.

    .. php:method:: getRowObject([$n = 0])

        :param int $n: 쿼리 결과(query result) 행의 인덱스
        :returns: 요청 된 행, 존재하지 않는 경우 null
        :rtype: stdClass

        요청 된 결과 행을 ``stdClass`` 객체로 반환합니다.

        사용법: `결과 행(Result Rows)`_.

    .. php:method:: getCustomRowObject($n, $type)

        :param int $n: 쿼리 결과(query result) 행의 인덱스
        :param string $class_name: 결과 행의 클래스 이름
        :returns: 요청 된 행, 존재하지 않는 경우 null
        :rtype: $type

        요청한 결과 행을 요청된 클래스의 인스턴스로 반환합니다.

    .. php:method:: dataSeek([$n = 0])

        :param int $n: 쿼리 결과(query result) 행의 인덱스
        :returns: 성공하면 TRUE, 실패하면 FALSE
        :rtype: bool

        내부 결과 행 포인터를 원하는 오프셋으로 이동합니다.

        사용법: `결과 헬퍼 메소드`_.

    .. php:method:: setRow($key[, $value = null])

        :param mixed $key: 열 이름 또는 키/값 쌍의 배열
        :param mixed $value: 열에 할당할 값, $key 필드명
        :rtype: void

        특정 열에 값을 할당합니다.

    .. php:method:: getNextRow([$type = 'object'])

        :param string $type: 요청한 결과의 유형 - array, object, class name
        :returns: 결과 집합의 다음 행, 존재하지 않는 경우 null
        :rtype: mixed

        결과 집합에서 다음 행을 반환합니다.

    .. php:method:: getPreviousRow([$type = 'object'])

        :param string $type: 요청한 결과의 유형 - array, object, class name
        :returns: 결과 집합의 이전 행, 존재하지 않는 경우 null
        :rtype: mixed

        결과 집합에서 이전 행을 반환합니다.

    .. php:method:: getFirstRow([$type = 'object'])

        :param string $type: 요청한 결과의 유형 - array, object, class name
        :returns: 결과 집합의 첫 번째 행, 존재하지 않는 경우 null
        :rtype: mixed

        결과 집합에서 첫 번째 행을 반환합니다.

    .. php:method:: getLastRow([$type = 'object'])

        :param string $type: 요청한 결과의 유형 - array, object, class name
        :returns: 결과 세트의 마지막 행, 존재하지 않는 경우 null
        :rtype: mixed

        결과 집합에서 마지막 행을 반환합니다.

    .. php:method:: getFieldCount()

        :returns: 결과 집합 필드의 갯수
        :rtype: int

        결과 집합 필드의 갯수를 반환합니다.

        사용법: `결과 헬퍼 메소드`_.

    .. php:method:: getFieldNames()

        :returns: 열(column) 이름의 배열
        :rtype: array

        결과 집합의 필드 이름으로 구성된 배열을 반환합니다.

    .. php:method:: getFieldData()

        :returns: 필드 메타 데이터로 구성된 배열
        :rtype: array

        필드 메타 데이터로 구성된 ``stdClass`` 객체의 배열을 생성합니다.

    .. php:method:: getNumRows()

        :returns:	결과(result) 집합의 행 수
        :rtype:	int

        쿼리에서 반환된 행 수

    .. php:method:: freeResult()

        :rtype: void

        결과 집합을 해제합니다.

        사용법: `결과 헬퍼 메소드`_.
