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

    <?php 
    
    namespace App\Database;

    use CodeIgniter\Test\CIDatabaseTestCase;

    class MyTests extends CIDatabaseTestCase
    {
        . . .
    }

``setUp()`` 및 ``tearDown()`` 단계에서 특수 기능이 실행되므로 해당 메소드를 사용해야 하는 경우 부모의 메소드를 호출해야합니다. 
그렇지 않으면 여기에 설명된 기능중 대부분이 동작하지 않습니다.

::

    <?php 
    
    namespace App\Database;

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
첫 번째 단계는 **app/Config/Database.php**\ 에 ``tests`` 데이터베이스 그룹 설정이 있는지 확인하는 것입니다.
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

    <?php 
    
    namespace App\Database;

    use CodeIgniter\Test\CIDatabaseTestCase;

    class MyTests extends CIDatabaseTestCase
    {
        protected $refresh  = true;
        protected $seed     = 'TestSeeder';
        protected $basePath = 'path/to/database/files';
    }

**$refresh**

이 부울 값은 모든 테스트 전에 데이터베이스가 완전히 새로 고쳐지는지 여부를 결정합니다.
true인 경우 모든 마이그레이션이 버전 0으로 롤백됩니다.
데이터베이스는 항상 ``$namespace``\ 에 의해 정의된 사용 가능한 최신 상태로 마이그레이션됩니다.
사용 가능한 모든 네임스페이스에서 마이그레이션을 실행하려면 이 속성을 ``null``\ 로 설정합니다.

**$seed**

모든 테스트 실행전에 데이터베이스를 테스트 데이터로 채우는 데 사용되는 Seed 파일의 이름을 지정합니다.

**$basePath**

기본적으로 CodeIgniter는 **tests/_support/Database/Seeds**에서 테스트 중 실행해야 하는 시드를 찾습니다.
``$basePath`` 속성을 지정하여 이 디렉터를 변경할 수 있습니다. 
여기에는 **Seeds** 디렉토리가 아니라 하위 디렉토리를 보유한 단일 디렉토리의 경로가 포함되어야 합니다.

**$namespace**

기본적으로 CodeIgniter는 **tests/_support/DatabaseTestMigrations/Database/Migrations**\ 에서 테스트 중에 실행해야 할 마이그레이션을 찾습니다.
``$namespace`` 속성에 새 네임스페이스를 지정하여 이 위치를 변경할 수 있습니다.
이 속성은 **Database\\Migrations** 하위 네임스페이스가 포함되지 않은 기본 네임스페이스만 포함되어야 합니다.

헬퍼 메소드
==============

**CIDatabaseTestCase** 클래스는 데이터베이스 테스트에 도움이 되는 몇 가지 헬퍼 메소드를 제공합니다.

**regressDatabase()**

이 메소드는 위에서 설명한 ``$refresh`` 중에 호출되며, 데이터베이스를 수동으로 재설정해야 할 때 사용합니다.

**migrateDatabase()**

이 메소드는 ``setUp`` 중에 호출되며,  마이그레이션을 수동으로 실행해야 할 때 사용합니다.


**seed($name)**

시드를 데이터베이스에 수동으로 로드합니다. 
단일 매개 변수로 실행할 시드 이름입니다.
시드는 ``$basePath``\ 에 지정된 경로내에 있어야 합니다.

**dontSeeInDatabase($table, $criteria)**

``$criteria``\ 의 키/값 쌍과 일치하는 행이 데이터베이스에 존재하지 않도록 지정합니다.

::

    $criteria = [
        'email'  => 'joe@example.com',
        'active' => 1
    ];
    $this->dontSeeInDatabase('users', $criteria);

**seeInDatabase($table, $criteria)**

``$criteria``\ 의 키/값 쌍과 일치하는 행이 데이터베이스에 존재한다고 가정합니다.

::

    $criteria = [
        'email'  => 'joe@example.com',
        'active' => 1
    ];
    $this->seeInDatabase('users', $criteria);

**grabFromDatabase($table, $column, $criteria)**

지정된 테이블에서 ``$criteria``\ 와 일치하는 행의 ``$column`` 값을 반환합니다.
둘 이상의 행이 발견되면 첫 번째 행에 대해서만 테스트합니다.

::

    $username = $this->grabFromDatabase('users', 'username', ['email' => 'joe@example.com']);

**hasInDatabase($table, $data)**

데이터베이스에 새로운 행을 삽입합니다.
이 행은 현재 테스트가 실행된 후 제거됩니다.
``$data``\ 는 테이블에 삽입할 데이터가 있는 연관 배열입니다.

::

    $data = [
        'email' => 'joe@example.com',
        'name'  => 'Joe Cool'
    ];
    $this->hasInDatabase('users', $data);

**seeNumRecords($expected, $table, $criteria)**

데이터베이스에서 ``$criteria``\ 와 일치하는 여러 개의 행이 있다고 가정합니다.

::

    $criteria = [
        'active' => 1
    ];
    $this->seeNumRecords(2, 'users', $criteria);

