마이그레이션 업그레이드
#######################

.. contents::
    :local:
    :depth: 2

관련 문서
==============

- `CodeIgniter 3.X 데이터베이스 마이그레이션 설명서 <http://codeigniter.com/userguide3/libraries/migration.html>`_
- :doc:`CodeIgniter 4.X 데이터베이스 마이그레이션 설명서 </dbmgmt/migration>`

무엇이 바뀌었습니까?
=====================

- 우선 순차적 마이그레이션 이름은 (``001_create_users``, ``002_create_posts``)\  더 이상 지원되지 않습니다. CodeIgniter 버전4는 타임스탬프 구성만 (``20121031100537_create_users``, ``20121031500638_create_posts``) 지원합니다. 순차적 이름을 사용한 경우에는 각 마이그레이션 파일의 이름을 변경해야 합니다.
- 마이그레이션 테이블 구조가 변경되었습니다. CI3에서 CI4로 업그레이드하고 동일한 데이터베이스를 사용하는 경우 마이그레이션 테이블 구조와 해당 데이터를 업그레이드해야 합니다.
- 마이그레이션 절차도 변경되었습니다. 이제 간단한 CLI 명령을 사용하여 데이터베이스를 마이그레이션할 수 있습니다.

::

    > php spark migrate

업그레이드 가이드
=================

1. v3 프로젝트에서 순차적 마이그레이션 이름을 사용한다면 타임스탬프로 마이그렝션 이름을 변경해야 합니다.
2. 모든 마이그레이션 파일을 **app/Database/Migration** 폴더로 옮겨야 합니다.
3. ``defined('BASEPATH') OR exit('No direct script access allowed');``\ 를 제거합니다.
4. <?php 태그 바로 아래 줄에 ``namespace App\Database\Migrations;``\ 를 추가합니다.
5. ``namespace App\Database\Migrations;`` 아래에 ``use CodeIgniter\Database\Migration;``\ 을 추가합니다.
6. ``extends CI_Migration``\ 을 ``extends Migration``\ 으로 대체합니다.
7. ``Forge`` 클래스 내의 메서드 이름이 camelCase를 사용하도록 변경되었습니다.

    - ``$this->dbforge->add_field`` to ``$this->forge->addField``
    - ``$this->dbforge->add_key`` to ``$this->forge->addKey``
    - ``$this->dbforge->create_table`` to ``$this->forge->addTable``
    - ``$this->dbforge->drop_table`` to ``$this->forge->addTable``

8. (선택사항) 배열 구문을 ``array(...)``\ 에서 ``[...]``\ 로 변경할 수 있습니다.
9. 동일한 데이터베이스를 사용하는 경우 마이그레이션 테이블을 업그레이드합니다.

    - **(development)** 개발 환경의 새로운 데이터베이스에 CI4 마이그레이션을 실행하여 마이그레이션 테이블을 만듭니다.
    - **(development)** 마이그레이션 테이블을 내보냅니다.(Export)
    - **(production)** CI3 마이그레이션 테이블을 삭제하거나 이름을 변경합니다.
    - **(production)** CI4 마이그레이션 테이블과 데이터를 가져옵니다.

코드 예
============

CodeIgniter Version 3.x
------------------------

Path: **application/migrations**

.. literalinclude:: upgrade_migrations/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

Path: **app/Database/Migrations**

.. literalinclude:: upgrade_migrations/001.php

검색 및 교체
================

CI3 파일의 다음 항목을 검색 및 교체합니다.

+------------------------------+----------------------------+
|  Search                      | Replace                    |
+==============================+============================+
| extends CI_Migration         | extends Migration          |
+------------------------------+----------------------------+
| $this->dbforge->add_field    | $this->forge->addField     |
+------------------------------+----------------------------+
| $this->dbforge->add_key      | $this->forge->addKey       |
+------------------------------+----------------------------+
| $this->dbforge->create_table | $this->forge->createTable  |
+------------------------------+----------------------------+
| $this->dbforge->drop_table   | $this->forge->dropTable    |
+------------------------------+----------------------------+