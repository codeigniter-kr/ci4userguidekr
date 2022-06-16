모델 업그레이드
################

.. contents::
    :local:
    :depth: 2

관련 문서
==============

- `CodeIgniter 3.X 모델 설명서 <http://codeigniter.com/userguide3/general/models.html>`_
- :doc:`CodeIgniter 4.X 모델 설명서 </models/model>`

무엇이 바뀌었습니까?
=====================

- CI4 모델은 자동 데이터베이스 연결, 기본 CRUD, 모델 내 검증, 자동 페이지화 등 기능이 CI3 보다 훨씬 뛰어납니다.
- CodeIgniter 4에 네임스페이스가 추가되었으므로 네임스페이스를 지원하도록 모델을 변경해야 합니다.

업그레이드 가이드
=================

1. 먼저 모든 모델 파일을 **app/Models** 폴더로 옮깁니다.
2. <?php 태그 바로 뒤에 ``namespace App\Models;``\ 를 추가합니다.
3. ``namespace App\Models;`` 아래에 ``use CodeIgniter\Model;``\ 을 추가합니다.
4. ``extends CI_Model``\ 을 ``extends Model``\ 로 바꿉니다.
5. CI3의 ``$this->load->model(x);`` 대신 `$this->x = new X();``\ 를 사용하여 구성 요소에 대한 이름 지정 규칙을 지정하거나 ``model()`` 함수를 사용하여 ``$this->x = model('X');``\ 로 지정합니다.

모델 구조에서 하위 디렉터리를 사용하는 경우 그에 따라 네임스페이스를 변경해야합니다.
예: 버전 3 모델 **application/models/users/user_contact.php**\ 의 네임스페이스는 ``namespace App\Models\Users;``\ 여야 하며 버전 4의 모델 경로는 **app/Models/Users/UserContact.php**\ 입니다.

CI4의 새 모델에는 많은 기능을 제공하는 기본 메소드가 있습니다. 예를 들어,``find($id)`` 메소드. 이를 통해 기본 키가 ``$id``\ 인 데이터를 검색할 수 있습니다.
데이터 삽입도 이전보다 쉽습니다. CI4에는 ``insert($data)`` 메소드가 있습니다. 선택적으로 이러한 기본 제공 메소드를 사용하고 코드를 새 메소드로 마이그레이션할 수 있습니다.

이러한 메소드에 대한 자세한 정보는 :doc:`여기 </models/model>`\ 에서 찾을 수 있습니다.

코드 예
============

CodeIgniter Version 3.x
------------------------

Path: **application/models**

.. literalinclude:: upgrade_models/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

Path: **app/Models**

.. literalinclude:: upgrade_models/001.php

데이터를 삽입을 위해 CI4 이후 부터는 모델에 ``insert()`` 메소드가 기본 제공되므로 ``$model->insert()`` 메서드를 구현하지 않고 직접 호출하면 됩니다.