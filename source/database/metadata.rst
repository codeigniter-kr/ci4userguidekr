##############################
데이터베이스 메타데이터
##############################

.. contents::
    :local:
    :depth: 2

*************************
테이블 메타데이터
*************************

이 함수를 사용하면 테이블 정보를 가져올 수 있습니다.

데이터베이스의 테이블 정보
================================

**$db->listTables();**

연결된 데이터베이스의 모든 테이블 이름이 포함된 배열을 반환합니다.

::

    $tables = $db->listTables();

    foreach ($tables as $table)
    {
        echo $table;
    }
    
.. note:: 일부 드라이버에는 반환된 배열에 제외된 추가 시스템 테이블이 있습니다.

테이블이 존재하는지 확인
===========================

**$db->tableExists();**

때로는 작업을 실행하기 전에 특정 테이블이 존재하는지 확인하는 것이 도움이됩니다. 
TRUE / FALSE를 반환합니다.

::

    if ($db->tableExists('table_name'))
    {
        // some code...
    }

.. note:: **table_name**\ 을 찾고있는 테이블 이름으로 바꾸십시오.

*******************
필드 메타데이터
*******************

테이블의 필드 정보
==========================

**$db->getFieldNames()**

필드명을 포함한 배열을 반환합니다. 이 쿼리는 두 가지 방법으로 호출할 수 있습니다:

1. $db->getFieldNames()에 테이블 이름을 제공하고 호출합니다.

::

    $fields = $db->getFieldNames('table_name');

    foreach ($fields as $field)
    {
        echo $field;
    }

2. 실행한 쿼리의 결과 객체에서 함수를 호출하여 관련된 필드명을 수집합니다.

::

    $query = $db->query('SELECT * FROM some_table');

    foreach ($query->getFieldNames() as $field)
    {
        echo $field;
    }

필드가 테이블에 존재하는지 확인
==========================================

**$db->fieldExists()**

때로는 작업을 수행하기 전에 특정 필드가 존재하는지 확인하는 것이 도움이됩니다. 
TRUE / FALSE를 반환합니다.

::

    if ($db->fieldExists('field_name', 'table_name'))
    {
        // some code...
    }

.. note:: **field_name**\ 을 찾고있는 열 이름으로 바꾸고 **table_name**\ 을 찾고있는 테이블 이름으로 바꾸십시오.

필드 메타데이터 검색
=======================

**$db->getFieldData()**

필드 정보가 포함된 객체의 배열을 반환합니다.

때로는 필드 이름이나 열 유형, 최대 길이 등과 같은 다른 메타 데이터를 수집하는 것이 도움이됩니다.

.. note:: 모든 데이터베이스가 메타데이터를 제공하는 것은 아닙니다.

::

    $fields = $db->getFieldData('table_name');

    foreach ($fields as $field)
    {
        echo $field->name;
        echo $field->type;
        echo $field->max_length;
        echo $field->primary_key;
    }

이미 쿼리를 실행한 경우 테이블 이름을 제공하는 대신 결과 객체를 사용할 수 있습니다

::

    $query  = $db->query("YOUR QUERY");
    $fields = $query->fieldData();

데이터베이스에서 지원하는 경우이 기능에서 다음 데이터를 사용할 수 있습니다:

-  name - 컬럼명
-  max_length - 컬럼의 최대 길이
-  primary_key - 1 이면 primary key
-  type - 컬럼 타입(type)

테이블의 인덱스 정보
===========================

**$db->getIndexData()**

인덱스 정보가 포함된 객체의 배열을 반환합니다.

::

    $keys = $db->getIndexData('table_name');

    foreach ($keys as $key)
    {
        echo $key->name;
        echo $key->type;
        echo $key->fields;  // array of field names
    }

키 유형은 사용중인 데이터베이스에 따라 다를수 있습니다.
예를 들어, MySQL은 테이블과 관련된 각 키에 대해 primary, fulltext, spatial, index, unique 중 하나를 반환합니다.

**$db->getForeignKeyData()**

외래(foreign) 키 정보가 포함된 객체의 배열을 반환합니다.

::

    $keys = $db->getForeignKeyData('table_name');

    foreach ($keys as $key)
    {
        echo $key->constraint_name;
        echo $key->table_name;
        echo $key->column_name;
        echo $key->foreign_table_name;
        echo $key->foreign_column_name;
    }

오브젝트 필드는 사용중인 데이터베이스에 다를수 있습니다.
예를 들어, SQLite3은 열 이름에 대한 데이터를 리턴하지 않지만 복합 외부 키 정의에 대한 *sequence* 추가 필드를 갖습니다.
