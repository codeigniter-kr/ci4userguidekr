=====================
데이터베이스 테스트
=====================

.. contents::
    :local:
    :depth: 2

Test 클래스
==============

CodeIgniter가 테스트를 위해 제공하는 내장 데이터베이스 도구를 이용하려면 테스트에서``CIUnitTestCase``\ 를 확장하고 ``DatabaseTestTrait``\ 을 사용 해야 합니다.

.. literalinclude:: database/001.php

``setUp()`` 및 ``tearDown()`` 단계에서 특수 기능이 실행되므로 해당 메소드를 사용해야 하는 경우 부모의 메소드를 호출해야합니다. 
그렇지 않으면 여기에 설명된 기능중 대부분이 동작하지 않습니다.

.. literalinclude:: database/002.php

Test 데이터베이스 설정
==========================

데이터베이스 테스트를 실행할 때 테스트중에 사용할 수있는 데이터베이스를 제공해야 합니다.
프레임워크는 PHPUnit 내장 데이터베이스 기능을 사용하는 대신 CodeIgniter 전용 도구를 제공합니다.
첫 번째 단계는 **app/Config/Database.php**\ 에 ``tests`` 데이터베이스 그룹 설정이 있는지 확인하는 것입니다.
다른 데이터를 안전하게 유지하기 위해 테스트를 실행하는 동안에만 사용되는 데이터베이스 연결을 지정합니다.

팀에 여러 개발자가 있는 경우 자격 증명 저장소를 **.env** 파일에 보관할 수 있습니다.
이렇게 하려면 파일을 편집하여 다음 줄이 있는지 확인하고 자격 정보를 작성합니다.

::

    database.tests.hostname = localhost
    database.tests.database = ci4_test
    database.tests.username = root
    database.tests.password = root
    database.tests.DBDriver = MySQLi
    database.tests.DBPrefix =
    database.tests.port = 3306

마이그레이션과 시드
====================

테스트를 실행할 때 데이터베이스에 올바른 스키마 설정이 있고 모든 테스트에 대해 알려진 상태인지 확인해야 합니다.
테스트에 몇 가지 클래스 속성을 추가하면 마이그레이션 및 시드를 사용하여 데이터베이스를 설정할 수 있습니다.

.. literalinclude:: database/003.php

Migrations
----------

$migrate
^^^^^^^^

이 부울(boolean) 값은 테스트 전에 데이터베이스 마이그레이션을 실행할지 여부를 결정합니다.
기본적으로 데이터베이스는 항상 ``$namespace``\ 에 정의된 대로 사용 가능한 최신 상태로 마이그레이션됩니다. 
``false``\ 면 마이그레이션이 실행되지 않습니다.
마이그레이션을 사용하지 않으려면 ``false``\ 를 설정하십시오.

$migrateOnce
^^^^^^^^^^^^

이 부울(boolean) 값은 데이터베이스 마이그레이션을 한 번만 실행할지 여부를 결정합니다. 
마이그레이션을 첫 번째 테스트전 한 번만 실행하려면 ``true``\ 를 설정하십시오. 
값이 지정되지 않거나 ``false``\ 면, 각 테스트 전에 마이그레이션이 실행됩니다.

$refresh
^^^^^^^^

이 부울 값은 모든 테스트 전에 데이터베이스가 완전히 새로 고쳐지는지 여부를 결정합니다.
``true``\ 인 경우 모든 마이그레이션이 버전 0으로 롤백됩니다.

$namespace
^^^^^^^^^^

기본적으로 CodeIgniter는 **tests/_support/Database/Migrations**\ 에서 테스트 중에 실행해야 하는 마이그레이션을 찾습니다.
``$namespace`` 속성에 네임스페이스를 지정하여 이 위치를 변경할 수 있습니다.
여기에는 **Database\\Migrations** 처럼 하위 네임스페이스가 포함되지 않은 기본 네임스페이스만 포함되어야 합니다.

.. important:: 이 속성을 ``null``로 설정하면 ``php spark migrate --all``\ 과 같이 사용 가능한 모든 네임스페이스에서 마이그레이션을 실행합니다.

Seeds
-----

$seed
^^^^^

비어 있지 않은 경우 실행전에 데이터베이스를 테스트 데이터로 채우는 데 사용되는 Seed 파일의 이름을 지정합니다.

$seedOnce
^^^^^^^^^

이 부울 값은 데이터베이스 시딩(seeding)이 한 번만 실행되는지 여부를 결정합니다. 
데이터베이스 시딩을 첫 번째 테스트 전 한 번만 실행하려면 ``true``\ 를 설정하십시오. 
값이 지정되지 않거나 ``false``\ 인 경우, 데이터베이스 시딩은 각 테스트 전에 실행됩니다.

$basePath
^^^^^^^^^

기본적으로 CodeIgniter는 **tests/_support/Database/Seeds**\ 에서 테스트 중 실행해야 하는 시드를 찾습니다.
``$basePath`` 속성을 지정하여 이 디렉터를 변경할 수 있습니다. 
여기에는 **Seeds** 디렉토리가 아니라 하위 디렉토리를 보유한 단일 디렉토리의 경로가 포함되어야 합니다.

헬퍼 메소드
**************

**DatabaseTestTrait** 클래스는 데이터베이스 테스트에 도움이 되는 몇 가지 헬퍼 메소드를 제공합니다.

데이터베이스 상태 변경
=======================

regressDatabase()
-----------------

이 메소드는 위에서 설명한 ``$refresh`` 중에 호출되며, 데이터베이스를 수동으로 재설정해야 할 때 사용합니다.

migrateDatabase()
-----------------

이 메소드는 ``setUp()`` 중에 호출되며,  마이그레이션을 수동으로 실행해야 할 때 사용합니다.

seed($name)
-----------

시드를 데이터베이스에 수동으로 로드합니다. 
단일 매개 변수로 실행할 시드 이름입니다.
시드는 ``$basePath``\ 에 지정된 경로내에 있어야 합니다.

hasInDatabase($table, $data)
----------------------------

데이터베이스에 새로운 행을 삽입합니다.
이 행은 현재 테스트가 실행된 후 제거됩니다.
``$data``\ 는 테이블에 삽입할 데이터가 있는 연관 배열입니다.

.. literalinclude:: database/007.php

데이터베이스에서 데이터 가져오기
=================================

grabFromDatabase($table, $column, $criteria)
--------------------------------------------

행이 ``$criteria``\ 와 일치하는 지정된 테이블에서 ``$column``\ 의 값을 반환합니다.
둘 이상의 행이 발견되면 첫 번째 행만 반환합니다.

Assertions
==========

dontSeeInDatabase($table, $criteria)
------------------------------------

``$criteria``\ 의 키/값 쌍과 일치하는 기준이 있는 행이 데이터베이스에 존재하지 않음을 확인합니다.

.. literalinclude:: database/004.php

seeInDatabase($table, $criteria)
--------------------------------

``$criteria``\ 의 키/값 쌍과 일치하는 기준이 있는 행이 데이터베이스에 존재하는지 확인합니다.

.. literalinclude:: database/005.php

seeNumRecords($expected, $table, $criteria)
-------------------------------------------

데이터베이스에서 ``$criteria``\ 와 일치하는 여러 행이 발견되었는지 확인합니다.

.. literalinclude:: database/008.php
