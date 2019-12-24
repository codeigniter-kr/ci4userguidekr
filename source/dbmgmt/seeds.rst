#######################
데이터베이스 시딩
#######################

데이터베이스 시딩은 데이터베이스에 데이터를 추가하는 간단한 방법입니다.
개발하는 동안 개발할 수 있는 샘플 데이터로 데이터베이스를 채워야 하는 경우 개발 중에 특히 유용하지만 이에 국한되지는 않습니다.
시드에는 마이그레이션에 포함하지 않으려는 정적 데이터(국가 또는 지리 부호화 테이블, 이벤트 또는 설정 정보 등과 같은)가 포함될 수 있습니다.

데이터베이스 시드는 **run()** 메소드를 가지고 있는 **CodeIgniter\Database\Seeder**\ 를 확장한 간단한 클래스입니다.
**run()** 내에서 클래스는 필요한 모든 형식의 데이터를 만들수 있습니다.
``$this->db``\ 와 ``$this->forge``\ 를 통해 데이터베이스 연결 및 forge에 액세스할 수 있습니다.
시드 파일은 **app/Database/Seeds** 디렉토리에 저장해야합니다. 
파일 이름은 클래스 이름과 일치해야합니다.

::

	<?php namespace App\Database\Seeds;

	class SimpleSeeder extends \CodeIgniter\Database\Seeder
	{
		public function run()
		{
			$data = [
				'username' => 'darth',
				'email'    => 'darth@theempire.com'
			];

			// Simple Queries
			$this->db->query("INSERT INTO users (username, email) VALUES(:username:, :email:)",
				$data
			);

			// Using Query Builder
			$this->db->table('users')->insert($data);
		}
	}

중첩 시더(Seeder)
====================

시더는 **call()** 메소드를 사용하여 다른 시더를 호출할 수 있습니다. 
이를 통해 중앙 시더를 쉽게 구성할 수 있으며, 작업을 별도의 시더 파일로 구성할 수 있습니다

::

	<?php namespace App\Database\Seeds;

	class TestSeeder extends \CodeIgniter\Database\Seeder
	{
		public function run()
		{
			$this->call('UserSeeder');
			$this->call('CountrySeeder');
			$this->call('JobSeeder');
		}
	}

**call()** 메소드에서 정규화된 클래스 이름을 사용하여 오토로더가 찾을 수 있는 모든 위치에 시더를 유지할 수 있습니다. 
모듈화된 코드 기반에 적합합니다.

::

	public function run()
	{
		$this->call('UserSeeder');
		$this->call('My\Database\Seeds\CountrySeeder');
	}

시더 사용
=============

데이터베이스 구성 클래스를 통해 메인 시더의 사본을 얻을 수 있습니다

::

	$seeder = \Config\Database::seeder();
	$seeder->call('TestSeeder');

커맨드 라인 시딩
--------------------

전용 컨트롤러를 만들지 않으려는 경우 마이그레이션 CLI 도구의 일부로 커맨드 라인에서 데이터를 시드할 수 있습니다.

::

	> php spark db:seed TestSeeder

