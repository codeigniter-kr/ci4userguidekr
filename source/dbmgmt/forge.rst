Database Forge 클래스
##########################

Database Forge 클래스에는 데이터베이스 관리에 도움이되는 메소드가 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

****************************
Forge 클래스 초기화
****************************

.. important:: Forge 클래스는 데이터베이스 드라이버에 의존하므로 Forge 클래스를 초기화하려면 데이터베이스 드라이버가 이미 실행 중이어야 합니다.

다음과 같이 Forge 클래스를 로드합니다.

.. literalinclude:: forge/001.php

관리하려는 데이터베이스가 기본 데이터베이스가 아닌 경우 다른 데이터베이스 그룹 이름을 DB Forge 로더에 전달할 수 있습니다.

.. literalinclude:: forge/002.php

위의 예처럼 매개 변수로 연결할 다른 데이터베이스 그룹의 이름을 전달합니다.

*******************************
데이터베이스 생성 및 삭제
*******************************

$forge->createDatabase('db_name')
=================================

첫 번째 매개 변수로 지정된 데이터베이스를 생성합니다.
성공 또는 실패에 따라 true/false를 반환합니다.

.. literalinclude:: forge/003.php

두 번째 매개 변수를 true로 설정하면 ``IF EXISTS``\ 문을 추가하거나, 데이터베이스를 작성하기 전에 데이터베이스가 존재하는지 점검합니다. (DBMS에 따라 다름)

.. literalinclude:: forge/004.php

$forge->dropDatabase('db_name')
===============================

첫 번째 매개 변수로 지정된 데이터베이스를 삭제합니다.
성공 또는 실패에 따라 true/false를 반환합니다.

.. literalinclude:: forge/005.php

명령줄에서 데이터베이스 만들기
======================================

CodeIgniter는 ``db:create`` 명령을 사용하여 터미널에서 직접 데이터베이스 만들기를 지원합니다.
이 명령은 데이터베이스가 아직 존재하지 않는 것으로 가정합니다.
데이터베이스가 존재한다면 CodeIgniter는 오류를 출력합니다.

다음 명령어와 데이터베이스 이름(예: ``foo``)을 입력합니다.

::

	> php spark db:create foo

모든 것이 잘 되었다면, 여러분에게 ``Database "foo" successfully created.`` 메시지가 표시됩니다.

테스트(testing) 환경이거나 SQLite3 드라이버를 사용하는 경우 ``--ext`` 옵션을 사용하여 데이터베이스가 생성될 파일의 확장자를 전달할 수 있습니다.
유효한 값은 ``db`` 또는 ``sqlite``\ 이며 기본값은 ``db``\ 입니다.
이 항목 앞에 마침표(.)가 붙으면 안 된다는 점을 기억하십시오.

::

	> php spark db:create foo --ext sqlite
	// will create the db file in WRITEPATH/foo.sqlite

.. note:: 특수 SQLite3 데이터베이스 이름 ``:memory:``\ 를 사용하는 경우 인메모리(in-memory) 데이터베이스를 사용하므로 데이터베이스 파일은 생성되지 않습니다.

****************************
테이블 생성 및 삭제
****************************

테이블을 만들때 수행할 수 있는 작업이 몇 가지 있습니다.
필드를 추가, 테이블에 키를 추가, 컬럼 변경.
CodeIgniter는 이를 위한 메커니즘을 제공합니다.

필드 추가
=============

필드는 일반적으로 연관 배열을 통해 생성됩니다. 
배열 내에 필드의 데이터 유형과 관련된 ``type`` 키를 포함해야 합니다.
예를 들면 INT, VARCHAR, TEXT 등입니다. 많은 데이터 유형(예 : VARCHAR)에 ``constraint`` 키가 필요합니다.

.. literalinclude:: forge/006.php

또한 다음 키/값을 사용할 수 있습니다:

-  ``unsigned``/true : 필드 정의에서 "UNSIGNED"를 생성합니다.
-  ``default``/value : 필드 정의에서 기본값을 생성합니다.
-  ``null``/true : 필드 정의에서 "null"을 생성합니다. 이 옵션이 없으면 필드는 기본적으로 "NOT null"이 됩니다.
-  ``auto_increment``/true : 필드에 auto_increment 플래그를 생성합니다. 필드 유형은 정수와 같이 이를 지원하는 유형이어야합니다.
-  ``unique``/true : 필드 정의를 위한 고유 키를 생성합니다.

.. literalinclude:: forge/007.php

필드가 정의 된 후 ``$forge->addField($ fields)``\ 를 사용하여 추가하고 ``createTable()`` 메소드를 호출합니다.

$forge->addField()
------------------

필드 추가 메소드는 위의 배열을 승인합니다.

.. _forge-addfield-default-value-rawsql:

원시(raw) SQL 문자열을 기본값으로 사용
---------------------------------------

v4.2.0부터 ``$forge->addField()``\ 는 원시(raw) SQL 문자열을 표현하는 ``CodeIgniter\Database\RawSql`` 인스턴스를 허용합니다.

.. literalinclude:: forge/027.php

.. warning:: ``RawSql``\ 을 사용할 때 데이터를 수동으로 이스케이프해야 합니다. 그렇게 하지 않으면 SQL 주입이 발생할 수 있습니다.

문자열을 필드로 전달
-------------------------

필드 생성 방법을 정확히 알고 있다면 ``addField()``\ 를 사용하여 필드 정의에 문자열을 전달할 수 있습니다.

.. literalinclude:: forge/008.php

.. note:: 문자열을 필드로 전달한 후에는 해당 필드에서 ``addKey()`` 호출을 수행 할 수 없습니다.

.. note:: ``addField()``\ 를 여러 번 호출하면 누적됩니다.

id 필드 만들기
--------------------

id 필드는 만들때 특별한 예외가 적용됩니다.
유형이 id 인 필드는 자동으로 INT(9) auto_incrementing Primary 키로 할당됩니다.

.. literalinclude:: forge/009.php

키 추가
===========

일반적으로 테이블에 키가 필요합니다.
이것은 ``$forge->addKey('field')``\ 로 추가합니다.
선택 사항인 두 번째 매개 변수를 true로 설정하면 기본(Primary) 키가 되고 세 번째 매개 변수가 true로 설정되면 고유(Unique) 키가 됩니다.
``addKey()`` 다음에 ``createTable()``\ 을 호출해야 합니다.

기본 키가 아닌 경우 여러 컬럼을 혼합하여 키를 만들 때는 배열로 보내야 합니다.
아래 샘플 출력은 MySQL 용입니다.

.. literalinclude:: forge/010.php

코드를 보다 객관적으로 만들려면 특정 메소드로 기본 및 고유 키를 추가할 수 있습니다

.. literalinclude:: forge/011.php

.. _adding-foreign-keys:

외래(Foreign) 키 추가
==========================

외래 키는 테이블 전체에서 관계 및 작업을 시행하는 데 도움이됩니다. 외래 키를 지원하는 테이블의 경우 forge에서 직접 추가 할 수 있습니다

.. literalinclude:: forge/012.php

구속 조건의 "on delete" 및 "on update" 속성에 대해 원하는 작업을 지정할 수 있습니다.

.. literalinclude:: forge/013.php

테이블 만들기
==================

필드와 키가 선언되면 다음과 같이 새 테이블을 만들 수 있습니다.

.. literalinclude:: forge/014.php

두 번째 매개변수를 true로 설정하면 테이블이 존재하지 않는 경우에만 테이블을 생성합니다.

.. literalinclude:: forge/016.php

MySQL의 ``ENGINE``\ 과 같은 선택적 테이블 속성을 전달할 수 있습니다.

::

	$attributes = ['ENGINE' => 'InnoDB'];
	$forge->createTable('table_name', false, $attributes);
	// produces: CREATE TABLE `table_name` (...) ENGINE = InnoDB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci

.. note:: ``CHARACTER SET`` 또는 ``COLLATE`` 속성을 지정하지 않으면 ``createTable()``\ 은 미리 구성된 *charset* 과 *DBCollat* 값을 추가합니다. (MySQL 만 해당).

테이블 삭제
================

``DROP TABLE``\ 문을 실행하고 옵션으로 ``IF EXISTS``\ 절을 추가합니다.

.. literalinclude:: forge/017.php

세 번째 매개 변수를 설정하여 ``CASCADE`` 옵션을 추가할 수 있습니다. 
이 옵션이 true로 설정되면 일부 드라이버에서 외부 키가 있는 테이블을 제거할 수 있습니다.

.. literalinclude:: forge/018.php

외래 키(Foreign Key) 삭제
==========================

DROP FOREIGN KEY문을 실행합니다.

.. literalinclude:: forge/019.php

키 삭제
======================

DROP KEY 문을 실행합니다.

.. literalinclude:: forge/020.php

테이블 이름 바꾸기
===========================

TABLE rename 문을 실행합니다.

.. literalinclude:: forge/021.php

****************
테이블 수정
****************

테이블에 컬럼 추가
==========================

$forge->addColumn()
-------------------

``addColumn()`` 메소드는 기존 테이블을 수정하는데 사용됩니다.
위와 동일한 필드 배열을 허용하며 추가 필드를 무제한으로 사용할 수 있습니다.

.. literalinclude:: forge/022.php

MySQL 또는 CUBIRD를 사용하는 경우 ``AFTER`` 및 ``FIRST`` 절을 활용하여 새 컬럼을 배치할 수 있습니다.

.. literalinclude:: forge/023.php

테이블의 컬럼 삭제
==============================

$forge->dropColumn()
--------------------

테이블에서 단일 컬럼을 제거할 때

.. literalinclude:: forge/024.php

테이블에서 여러 컬럼을 제거할 때

.. literalinclude:: forge/025.php


테이블의 컬럼 수정
=============================

$forge->modifyColumn()
----------------------

이 메소드는 ``addColumn()``\ 과 사용법이 동일하지만 새 컬럼을 추가하는 대신 기존 컬럼을 변경합니다.
필드 정의(define) 배열에 "name" 키를 추가하면 이름을 변경할 수 있습니다.

.. literalinclude:: forge/026.php

***************
Class Reference
***************

.. php:namespace:: CodeIgniter\Database

.. php:class:: Forge

	.. php:method:: addColumn($table[, $field = []])

		:param	string	$table: 컬럼을 추가 할 테이블 이름
		:param	array	$field: 컬럼 정의
		:returns:	true면 성공, false면 실패
		:rtype:	bool

		테이블에 컬럼을 추가합니다. 사용법:  `테이블에 컬럼 추가`_.

	.. php:method:: addField($field)

		:param	array	$field: 추가 할 필드 정의
		:returns:	\CodeIgniter\Database\Forge instance (method chaining)
		:rtype:	\CodeIgniter\Database\Forge

		테이블을 만드는데 사용될 필드를 세트에 추가합니다. 사용법: `필드 추가`_.

    .. php:method:: addForeignKey($fieldName, $tableName, $tableField[, $onUpdate = '', $onDelete = ''])

		:param    string|string[]    $fieldName: 키 필드 또는 필드 배열 이름
		:param    string    $tableName: 상위 테이블의 이름
		:param    string|string[]    $tableField: 상위 테이블 필드 또는 필드 배열의 이름
		:param    string    $onUpdate: "on update"시 원하는 작업
		:param    string    $onDelete: "on delete"시 원하는 작업
		:returns:    \CodeIgniter\Database\Forge instance (method chaining)
		:rtype:    \CodeIgniter\Database\Forge

		테이블에 외부 키를 추가합니다. 사용법: `외래(Foreign) 키 추가`_.

	.. php:method:: addKey($key[, $primary = false[, $unique = false]])

		:param	mixed	$key: 키 필드 또는 필드 배열의 이름
		:param	bool	$primary: 기본(Primary) 키여야 하는 경우 true로 설정
		:param	bool	$unique: 고유(Unique) 키여야 하는 경우 true로 설정
		:returns:	\CodeIgniter\Database\Forge instance (method chaining)
		:rtype:	\CodeIgniter\Database\Forge

		테이블 작성할 때 사용될 키를 세트에 추가합니다. 사용법:  `키 추가`_.

	.. php:method:: addPrimaryKey($key)

		:param	mixed	$key: 키 필드 또는 필드 배열의 이름
		:returns:	\CodeIgniter\Database\Forge instance (method chaining)
		:rtype:	\CodeIgniter\Database\Forge

		테이블 작성할 때 사용될 기본 키를 세트에 추가합니다. 사용법:  `키 추가`_.

	.. php:method:: addUniqueKey($key)

		:param	mixed	$key: 키 필드 또는 필드 배열의 이름
		:returns:	\CodeIgniter\Database\Forge instance (method chaining)
		:rtype:	\CodeIgniter\Database\Forge

		테이블 작성할 때 사용될 고유 키를 세트에 추가합니다. 사용법:  `키 추가`_.

	.. php:method:: createDatabase($db_name[, $ifNotExists = false])

		:param	string	$db_name: 생성할 데이터베이스 이름
		:param	string	$ifNotExists: ``IF NOT EXISTS`` 절을 추가하거나 데이터베이스가 존재하는지 확인하려면 true로 설정
		:returns:	true면 성공, false면 실패
		:rtype:	bool

		새로운 데이터베이스를 생성합니다. 사용법: `데이터베이스 생성 및 삭제`_.

	.. php:method:: createTable($table[, $if_not_exists = false[, array $attributes = []]])

		:param	string	$table: 생성할 테이블 이름
		:param	string	$if_not_exists: ``IF NOT EXISTS`` 절을 추가하려면 true로 설정
		:param	string	$attributes: 테이블 속성의 연관 배열
		:returns:  Query 객체면 성공, false면 실패
		:rtype:	mixed

		새로운 테이블을 생성합니다. 사용법:  `테이블 만들기`_.

	.. php:method:: dropColumn($table, $column_name)

		:param	string	$table: 테이블 이름
		:param	mixed	$column_name: 쉼표로 구분된 컬럼 이름 또는 컬럼 이름 배열
		:returns:	true면 성공, false면 실패
		:rtype:	bool

		테이블에서 한 개의 컬럼 또는 여러 컬럼을 제거합니다. 사용법:  `테이블의 컬럼 삭제`_.

	.. php:method:: dropDatabase($dbName)

		:param	string	$dbName: 제거할 데이터베이스 이름
		:returns:	true면 성공, false면 실패
		:rtype:	bool

		데이터베이스를 제거합니다. 사용법:  `데이터베이스 생성 및 삭제`_.

	.. php:method:: dropTable($table_name[, $if_exists = false])

		:param	string	$table: 제거할 테이블 이름
		:param	string	$if_exists: ``IF EXISTS`` 절을 추가하려면 true로 설정
		:returns:	true면 성공, false면 실패
		:rtype:	bool

		테이블을 제거합니다.. 사용법:  `테이블 삭제`_.

	.. php:method:: modifyColumn($table, $field)

		:param	string	$table: 테이블 이름
		:param	array	$field: 컬럼 정의
		:returns:	true면 성공, false면 실패
		:rtype:	bool

		테이블의 컬럼을 수정합니다. 사용법:  `테이블의 컬럼 수정`_.

	.. php:method:: renameTable($table_name, $new_table_name)

		:param	string	$table: 테이블 이름
		:param	string	$new_table_name: 테이블의 새로운 이름
		:returns:  Query 객체면 성공, false면 실패
		:rtype:	mixed

		테이블 이름을 바꿉니다. 사용법:  `테이블 이름 바꾸기`_.
