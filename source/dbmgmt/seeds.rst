#######################
데이터베이스 시딩
#######################

데이터베이스 시딩은 데이터베이스에 데이터를 추가하는 간단한 방법입니다.
개발하는 동안 개발할 수 있는 샘플 데이터로 데이터베이스를 채워야 하는 경우 개발 중에 특히 유용하지만 이에 국한되지는 않습니다.
시드에는 마이그레이션에 포함하지 않으려는 정적 데이터(국가 또는 지리 부호화 테이블, 이벤트 또는 설정 정보 등과 같은)가 포함될 수 있습니다.

데이터베이스 시드는 **run()** 메소드를 가지고 있는 ``CodeIgniter\Database\Seeder``\ 를 확장한 간단한 클래스입니다.
**run()** 내에서 클래스는 필요한 모든 형식의 데이터를 만들수 있습니다.
``$this->db``\ 와 ``$this->forge``\ 를 통해 데이터베이스 연결 및 forge에 액세스할 수 있습니다.
시드 파일은 **app/Database/Seeds** 디렉토리에 저장해야합니다. 
파일 이름은 클래스 이름과 일치해야합니다.

.. literalinclude:: seeds/001.php

중첩 시더(Seeder)
====================

시더는 **call()** 메소드를 사용하여 다른 시더를 호출할 수 있습니다. 
이를 통해 중앙 시더를 쉽게 구성할 수 있으며, 작업을 별도의 시더 파일로 구성할 수 있습니다

.. literalinclude:: seeds/002.php

**call()** 메소드에서 정규화된 클래스 이름을 사용하여 오토로더가 찾을 수 있는 모든 위치에 시더를 유지할 수 있습니다. 
모듈화된 코드 기반에 적합합니다.

.. literalinclude:: seeds/003.php

시더 사용
=============

데이터베이스 구성 클래스를 통해 메인 시더의 사본을 얻을 수 있습니다

.. literalinclude:: seeds/004.php

커맨드 라인 시딩
--------------------

전용 컨트롤러를 만들지 않으려는 경우 마이그레이션 CLI 도구의 일부로 커맨드 라인에서 데이터를 시드할 수 있습니다.

::

	> php spark db:seed TestSeeder

시드(seed) 파일 생성
---------------------

명령줄(Command line)에서 시드 파일을 쉽게 생성할 수 있습니다.

::

	> php spark make:seeder user --suffix
    // Output: UserSeeder.php file located at app/Database/Seeds directory.

``--namespace`` 옵션을 사용하여 시드 파일이 저장될 **root** 네임스페이스를 지정할 수 있습니다.

::

	> php spark make:seeder MySeeder -namespace Acme\Blog

``Acme\Blog``\ 가 ``app/Blog`` 디렉토리에 매핑되면 이 명령은 시드 파일을 ``app/Blog/Database/Seeds/`` 디레토리에 저장합니다.

``--force`` 옵션을 지정하면 대상에 있는 기존 파일을 덮어 씁니다.