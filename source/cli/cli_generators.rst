##############
CLI 생성기
##############

CodeIgniter4에는 컨트롤러, 모델, 엔티티 등을 쉽게 생성 할 수있는 생성기가 장착되어 있습니다.
하나의 명령으로 전체 파일 세트를 스캐폴딩할 수도 있습니다.

.. contents::
    :local:
    :depth: 2

************
소개
************

내장된 모든 생성기는 ``Generators`` 네임스페이스 아래에 위치하며, ``php spark list``\ 를 사용하여 나열할 수 있습니다.
특정 생성기에 대한 전체 설명 및 사용 정보를 보려면 다음 명령을 사용합니다.

.. note:: 생성된 코드가 하위 폴더에 있어야 합니까?
    예를 들어, 메인 ``Controllers`` 폴더의 ``Admin`` 하위 폴더에 상주할 컨트롤러 클래스를 생성하려면 다음과 같이 하위 폴더를 클래스 이름 앞에 추가하면 됩니다. ``php spark make:controller admin/login``.
    이 명령은 네임스페이스가 ``App\Controllers\Admin``\ 인 ``Controllers/Admin`` 하위 폴더에 ``Login`` 컨트롤러를 생성합니다.

.. note:: 모듈 작업? 
    코드 생성은 루트 네임스페이스를 기본값 ``APP_NAMESPACE``\ 로 설정합니다.
    모듈 네임스페이스의 다른 곳에 생성된 코드가 필요한 경우 명령에서 ``--namespace`` 옵션을 설정해야 합니다. (예: ``php spark make:model blog --namespace Acme\Blog``)

.. warning:: ``--namespace`` 옵션을 설정할 때 제공된 네임스페이스가 ``Config\Autoload``\ 의 ``$psr4`` 배열에 정의되었거나 작곡가 자동 로드 파일에 정의된 유효한 네임스페이스인지 확인하십시오.
    그렇지 않으면 코드 생성이 중단됩니다.

.. warning:: 마이그레이션 파일을 생성하기 위해 ``migrate:create``\ 를 사용하는 것은 더 이상 사용되지 않습니다. 향후 릴리스에서 제거될 예정입니다.
    대신 ``make:migration``\ 을 사용하세요.
    또한 더 이상 사용되지 않는 ``session:migration`` 대신 ``make:migration --session``\ 을 사용하세요.

::

    > php spark help <generator_command>

여기서 ``<generator_command>``\ 는 확인할 명령으로 대체됩니다.

*******************
내장된 생성기
*******************

CodeIgniter4는 기본적으로 다음 생성기를 제공합니다.

make:command
------------

새로운 spark 명령을 만듭니다.

Usage:
======
::

    make:command <name> [options]

Argument:
=========
* ``name``: 명령 클래스의 이름. **[REQUIRED]**

Options:
========
* ``--command``: spark에서 실행할 명령 이름. 기본값은 ``command:name``.
* ``--group``: 명령의 그룹/네임스페이스입니다. 기본(basic) 명령의 경우 ``CodeIgniter``, 생성기(generator) 명령의 경우``Generators``\ 가 기본값입니다.
* ``--type``: 명령 타입, ``basic`` 또는 ``generator``. 기본값은 ``basic``.
* ``--namespace``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--suffix``: 접미사를 생성된 클래스 이름에 추가합니다.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

.. note:: ``--suffix``\ 를 사용하면 생성된 컨트롤러 이름은 ``ProductController``\ 와 같습니다.
    이는 :ref:`Auto Routing <controller-auto-routing-improved>`\ 를 사용할 때 컨트롤러 명명 규칙을 위반합니다.(컨트롤러 클래스 이름은 대문자로 시작해야 하며 첫 번째 문자만 대문자일 수 있음)
    따라서 ``--suffix``\ 는 :ref:`Defined Routes <defined-route-routing>`\ 을 사용할 때 사용할 수 있습니다.

make:config
-----------

새로운 구성(config) 파일을 만듭니다.

Usage:
======
::

    make:config <name> [options]

Argument:
=========
* ``name``: 구성(config) 클래스의 이름 **[REQUIRED]**

Options:
========
* ``--namespace``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--suffix``: 접미사를 생성된 클래스 이름에 추가합니다.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:controller
---------------

새로운 컨트롤러 파일을 만듭니다.

Usage:
======
::

    make:controller <name> [options]

Argument:
=========
* ``name``: 컨트롤러 클래스 이름. **[REQUIRED]**

Options:
========
* ``--bare``: ``BaseController`` 대신 ``CodeIgniter\Controller``\ 을 확장(extend)합니다.
* ``--restful``: RESTful resource를 확장. ``controller`` 또는 ``presenter`` 선택. 기본값은 ``controller``.
* ``--namespace``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--suffix``: 접미사를 생성된 클래스 이름에 추가합니다.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:entity
-----------

새로운 엔티티 파일을 만듭니다.

Usage:
======
::

    make:entity <name> [options]

Argument:
=========
* ``name``: 엔티티 클래스명. **[REQUIRED]**

Options:
========
* ``--namespace``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--suffix``: 접미사를 생성된 클래스 이름에 추가합니다.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:filter
-----------

새로운 필터 파일을 만듭니다.

Usage:
======
::

    make:filter <name> [options]

Argument:
=========
* ``name``: 필터 클래스명. **[REQUIRED]**

Options:
========
* ``--namespace``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--suffix``: 접미사를 생성된 클래스 이름에 추가합니다.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:model
----------

새로운 모델 파일을 생성합니다.

Usage:
======
::

    make:model <name> [options]

Argument:
=========
* ``name``: 모델 클래스명. **[REQUIRED]**

Options:
========
* ``--dbgroup``: 사용할 데이터베이스 그룹. 기본값은 ``default``.
* ``--return``: 반환 유형(``array``, ``object``, ``entity``)을 설정합니다. 기본값은 ``array``.
* ``--table``: 사용할 테이블명. 기본값은 클래스명의 복수형.
* ``--namespace``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--suffix``: 접미사를 생성된 클래스 이름에 추가합니다.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:seeder
-----------

새로운 시더 파일을 만듭니다.

Usage:
======
::

    make:seeder <name> [options]

Argument:
=========
* ``name``: 시더 클래스명. **[REQUIRED]**

Options:
========
* ``--namespace``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--suffix``: 접미사를 생성된 클래스 이름에 추가합니다.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

migrate:create
--------------

새로운 마이그레이션 파일을 만듭니다.

Usage:
======
::

    make:migration <name> [options]

Argument:
=========
* ``name``: 마이그레이션 클래스명. **[REQUIRED]**

Options:
========
* ``--session``: 데이터베이스 세션에 대한 마이그레이션 파일을 생성합니다.
* ``--table``: 데이터베이스 세션에 사용할 테이블 이름을 설정합니다. 기본값은 ``ci_sessions``.
* ``--dbgroup``: 데이터베이스 세션에 대한 데이터베이스 그룹을 설정합니다. 기본값은 ``default`` group.
* ``--namespace``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--suffix``: 접미사를 생성된 클래스 이름에 추가합니다.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:validation
---------------

새 유효성 검사 파일을 만듭니다.

Usage:
======
::

    make:validation <name> [options]

Argument:
=========
* ``name``: 유효성 검사 클래스 이름. **[REQUIRED]**

Options:
========
* ``--namespace``: root namespace. 기본 값은 ``APP_NAMESPACE``.
* ``--suffix``: 생성된 클래스 이름에 구성 요소 접미사 추가.
* ``--force``: 기존 파일을 덮어쓰도록 설정.

****************************************
스캐폴딩 코드 세트
****************************************

개발 단계에서는 *Admin* 그룹 생성과 같은 그룹별 기능을 생성하는 경우가 있습니다.
이 그룹에는 자체 컨트롤러, 모델, 마이그레이션 파일 또는 엔티티가 포함됩니다.
각 생성기 명령을 터미널에 하나씩 입력할 수 있지만, 모든것을 제어하는 생성기 명령 하나를 사용하는 것이 좋을 것이라고 생각합니다.

CodeIgniter4는 컨트롤러, 모델, 엔티티, 마이그레이션 및 시더 생성기 명령에 대한 전용 래퍼인 ``make:scapold`` 명령을 제공됩니다.
생성된 모든 클래스의 이름을 지정하는 데 사용할 클래스 이름만 있으면 됩니다.
또한 각 생성기 명령에 의해 지원하는 **개별 옵션**\ 은 scaffold 명령에 의해 인식됩니다.

터미널에서 다음과 같이 실행

::

    > php spark make:scaffold user

다음 클래스를 생성합니다.

(1) ``App\Controllers\User``;
(2) ``App\Models\User``;
(3) ``App\Database\Migrations\<some date here>_User``;
(4) ``App\Database\Seeds\User``.

스케폴딩(scaffolding) 파일에 ``Entity`` 클래스를 포함하려면 ``-return entity``\ 를 명령어에 사용합니다.

**************
GeneratorTrait
**************

모든 제너레이터 명령은 ``GeneratorTrait``\ 을 사용하여 코드 생성에 사용되는 메소드를 완전히 활용해야 합니다.