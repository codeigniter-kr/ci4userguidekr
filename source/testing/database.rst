=====================
데이터베이스 테스트
=====================

.. contents::
    :local:
    :depth: 2

Test 클래스
==============

CodeIgniter가 테스트를 위해 제공하는 내장 데이터베이스 도구를 이용하려면 테스트에서``CIDatabaseTestCase``\ 를 확장해야 합니다.

::

    <?php namespace App\Database;

    use CodeIgniter\Test\CIDatabaseTestCase;

    class MyTests extends CIDatabaseTestCase
    {
        . . .
    }

``setUp()`` 및 ``tearDown()`` 단계에서 특수 기능이 실행되므로 해당 메소드를 사용해야 하는 경우 부모의 메소드를 호출해야합니다. 
그렇지 않으면 여기에 설명된 기능중 대부분이 동작하지 않습니다.

::

    <?php namespace App\Database;

    use CodeIgniter\Test\CIDatabaseTestCase;

    class MyTests extends CIDatabaseTestCase
    {
        public function setUp()
        {
            parent::setUp();

            // Do something here....
        }

        public function tearDown()
        {
            parent::tearDown();

            // Do something here....
        }
    }

Test 데이터베이스 설정
==========================

데이터베이스 테스트를 실행할 때 테스트중에 사용할 수있는 데이터베이스를 제공해야 합니다.
프레임워크는 PHPUnit 내장 데이터베이스 기능을 사용하는 대신 CodeIgniter 전용 도구를 제공합니다.
첫 번째 단계는 **app/Config/Database.php **\ 에 ``tests`` 데이터베이스 그룹 설정이 있는지 확인하는 것입니다.
다른 데이터를 안전하게 유지하기 위해 테스트를 실행하는 동안에만 사용되는 데이터베이스 연결을 지정합니다.

팀에 여러 개발자가 있는 경우 자격 증명 저장소를 **.env** 파일에 보관할 수 있습니다.
이렇게 하려면 파일을 편집하여 다음 줄이 있는지 확인하고 자격 정보를 작성합니다.

::

    database.tests.dbdriver = 'MySQLi';
    database.tests.username = 'root';
    database.tests.password = '';
    database.tests.database = '';

마이그레이션과 시드
--------------------

테스트를 실행할 때 데이터베이스에 올바른 스키마 설정이 있고 모든 테스트에 대해 알려진 상태인지 확인해야 합니다.
테스트에 몇 가지 클래스 속성을 추가하면 마이그레이션 및 시드를 사용하여 데이터베이스를 설정할 수 있습니다.

::

    <?php namespace App\Database;

    use CodeIgniter\Test\CIDatabaseTestCase;

    class MyTests extends\CIDatabaseTestCase
    {
        protected $refresh  = true;
        protected $seed     = 'TestSeeder';
        protected $basePath = 'path/to/database/files';
    }

**$refresh**

이 부울 값은 모든 테스트 전에 데이터베이스가 완전히 새로 고쳐지는지 여부를 결정합니다.
true인 경우 모든 마이그레이션이 버전 0으로 롤백되고 데이터베이스가 사용 가능한 최신 마이그레이션으로 마이그레이션됩니다.

**$seed**

모든 테스트 실행전에 데이터베이스를 테스트 데이터로 채우는 데 사용되는 Seed 파일의 이름을 지정합니다.

**$basePath**

기본적으로 CodeIgniter는 **tests/_support/Database/Seeds**에서 테스트 중 실행해야 하는 시드를 찾습니다.
``$basePath`` 속성을 지정하여 이 디렉터를 변경할 수 있습니다. 
여기에는 **seeds** 디렉토리가 아니라 하위 디렉토리를 보유한 단일 디렉토리의 경로가 포함되어야 합니다.

**$namespace**

By default, CodeIgniter will look in **tests/_support/DatabaseTestMigrations/Database/Migrations** to locate the migrations
that it should run during testing. You can change this location by specifying a new namespace in the ``$namespace`` properties.
This should not include the **Database/Migrations** path, just the base namespace.

Helper Methods
==============

The **CIDatabaseTestCase** class provides several helper methods to aid in testing your database.

**seed($name)**

Allows you to manually load a Seed into the database. The only parameter is the name of the seed to run. The seed
must be present within the path specified in ``$basePath``.

**dontSeeInDatabase($table, $criteria)**

Asserts that a row with criteria matching the key/value pairs in ``$criteria`` DOES NOT exist in the database.
::

    $criteria = [
        'email'  => 'joe@example.com',
        'active' => 1
    ];
    $this->dontSeeInDatabase('users', $criteria);

**seeInDatabase($table, $criteria)**

Asserts that a row with criteria matching the key/value pairs in ``$criteria`` DOES exist in the database.
::

    $criteria = [
        'email'  => 'joe@example.com',
        'active' => 1
    ];
    $this->seeInDatabase('users', $criteria);

**grabFromDatabase($table, $column, $criteria)**

Returns the value of ``$column`` from the specified table where the row matches ``$criteria``. If more than one
row is found, it will only test against the first one.
::

    $username = $this->grabFromDatabase('users', 'username', ['email' => 'joe@example.com']);

**hasInDatabase($table, $data)**

Inserts a new row into the database. This row is removed after the current test runs. ``$data`` is an associative
array with the data to insert into the table.
::

    $data = [
        'email' => 'joe@example.com',
        'name'  => 'Joe Cool'
    ];
    $this->hasInDatabase('users', $data);

**seeNumRecords($expected, $table, $criteria)**

Asserts that a number of matching rows are found in the database that match ``$criteria``.
::

    $criteria = [
        'active' => 1
    ];
    $this->seeNumRecords(2, 'users', $criteria);

