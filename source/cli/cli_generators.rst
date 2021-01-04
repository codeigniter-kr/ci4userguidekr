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
.. code-block:: none

    make:command <name> [options]

Argument:
=========
* ``name``: 명령 클래스의 이름. **[REQUIRED]**

Options:
========
* ``--command``: spark에서 실행할 명령 이름. 기본값은 ``command:name``.
* ``--group``: 명령의 그룹/네임스페이스입니다. 기본(basic) 명령의 경우 ``CodeIgniter``, 생성기(generator) 명령의 경우``Generators``\ 가 기본값입니다.
* ``--type``: 명령 타입, ``basic`` 또는 ``generator``. 기본값은 ``basic``.
* ``-n``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:controller
---------------

새로운 컨트롤러 파일을 만듭니다.

Usage:
======
.. code-block:: none

    make:controller <name> [options]

Argument:
=========
* ``name``: 컨트롤러 클래스 이름. **[REQUIRED]**

Options:
========
* ``--bare``: ``BaseController`` 대신 ``CodeIgniter\Controller``\ 을 확장(extend)합니다.
* ``--restful``: RESTful resource를 확장. ``controller`` 또는 ``presenter`` 선택. 기본값은 ``controller``.
* ``-n``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:entity
-----------

새로운 엔티티 파일을 만듭니다.

Usage:
======
.. code-block:: none

    make:entity <name> [options]

Argument:
=========
* ``name``: 엔티티 클래스명. **[REQUIRED]**

Options:
========
* ``-n``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:filter
-----------

새로운 필터 파일을 만듭니다.

Usage:
======
.. code-block:: none

    make:filter <name> [options]

Argument:
=========
* ``name``: 필터 클래스명. **[REQUIRED]**

Options:
========
* ``-n``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:model
----------

새로운 모델 파일을 생성합니다.

Usage:
======
.. code-block:: none

    make:model <name> [options]

Argument:
=========
* ``name``: 모델 클래스명. **[REQUIRED]**

Options:
========
* ``--dbgroup``: 사용할 데이터베이스 그룹. 기본값은 ``default``.
* ``--entity``: 엔티티 클래스를 리턴 유형으로 사용하려면 이 플래그를 설정합니다.
* ``--table``: 사용할 테이블명. 기본값은 클래스명의 복수형.
* ``-n``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

make:seeder
-----------

새로운 시더 파일을 만듭니다.

Usage:
======
.. code-block:: none

    make:seeder <name> [options]

Argument:
=========
* ``name``: 시더 클래스명. **[REQUIRED]**

Options:
========
* ``-n``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

migrate:create
--------------

새로운 마이그레이션 파일을 만듭니다.

Usage:
======
.. code-block:: none

    migrate:create <name> [options]

Argument:
=========
* ``name``: 마이그레이션 클래스명. **[REQUIRED]**

Options:
========
* ``-n``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

session:migration
-----------------

데이터베이스 세션에 대한 마이그레이션 파일을 생성합니다.

Usage:
======
.. code-block:: none

    session:migration [options]

Options:
========
* ``-g``: 데이터베이스 그룹 설정
* ``-t``: 테이블명 설정. 기본값은 ``ci_sessions``.
* ``-n``: 루트(root) 네임스페이스 설정. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.
* ``--force``: 기존 파일을 덮어 쓰려면 이 플래그를 설정합니다.

.. note:: ``php spark help session:migration``\ 을 실행하면 ``name`` 인수가 나열지만, 클래스명은 ``-t`` 옵션으로 전달된 테이블명에서 파생되므로 사용되지 않습니다.

.. note:: 하위 폴더에 생성된 코드를 저장하고 싶나요?
    메인 ``Controllers`` 폴더의 ``Admin`` 하위 폴더에 컨트롤러 클래스를 만들고 싶다면, 클래스 이름 앞에 ``php spark make:controller admin/login``\ 와 같이 하위 폴더를 추가하면 됩니다.
    이 명령은 ``App\Controllers\Admin`` 네임 스페이스를 사용하여 ``Controllers/Admin`` 하위 폴더에 ``Login`` 컨트롤러를 생성합니다.

.. note:: 모듈 작업을 하고 있습니까? 
    코드 생성시 루트 네임스페이스는 기본값인 상수 ``APP_NAMESPACE``\ 의 값으로 설정됩니다.
    다른 위치의 모듈 네임스페이스에 생성된 코드가 있어야 한다면 ``-n`` 옵션을 사용하여 설정해야 합니다. ex> ``php spark make:model blog -n Acme\Blog``

.. warning:: ``-n`` 옵션을 설정할 때 제공된 네임스페이스가 ``Config\Autoload``\ 의 ``$psr4`` 배열에 정의되거나 
    composer autoload 파일에 정의된 유효한 네임스페이스인지 확인하십시오.
    그렇지 않으면 ``RuntimeException``\ 이 발생합니다.

.. warning:: 마이그레이션 파일을 만들기 위해 ``migrate:create``\ 는 이후 릴리스에서 제거되어 더 이상 사용되지 않습니다.
    대신 ``make:migration``\ 을 사용하십시오.

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

    php spark make:scaffold user

다음 클래스를 생성합니다.

(1) ``App\Controllers\User``;
(2) ``App\Models\User``;
(3) ``App\Entities\User``;
(4) ``App\Database\Migrations\<some date here>_User``;
(5) ``App\Database\Seeds\User``.

****************
GeneratorCommand
****************

모든 생성기 명령은 코드 생성에 사용되는 메소드를 완전히 활용하기 위해 ``GeneratorCommand``\ 를 확장해야 합니다.
일부 메소드는 이미 만들어져 있지만 각 메소드를 사용자 정의하거나 업그레이드해야 할 수도 있습니다.
공개적이고 본질적으로 완전하기 때문에 재정의할 필요가 없는 ``run()`` 메소드를 제외하고 모든 메서드는 재정의 가능합니다.

.. php:class:: CodeIgniter\\CLI\\GeneratorCommand

    .. php:method:: getClassName()

        :rtype: string

        입력에서 클래스 이름을 가져옵니다.
        이름이 필요한 경우 프롬프트를 제공하여 재정의할 수 있습니다.

    .. php:method:: sanitizeClassName(string $class)

        :param string $class: 클래스명
        :rtype: string

        입력을 트리밍하고 구분 기호를 정규화하며 모든 경로가 파스칼 케이스인지 확인합니다.

    .. php:method:: qualifyClassName(string $class)

        :param string $class: 클래스명
        :rtype: string

        클래스 이름을 구문 분석하고 이미 정규화된 클래스인지 확인합니다.

    .. php:method:: getRootNamespace()

        :rtype: string

        입력에서 루트 네임스페이스를 가져옵니다. 기본값은 상수 ``APP_NAMESPACE``\ 의 값.

    .. php:method:: getNamespacedClass(string $rootNamespace, string $class)

        :param string $rootNamespace: 클래스의 루트 네임스페이스
        :param string $class: 클래스명
        :returns: 정규화된 클래스 이름
        :rtype: string

        정규화된 클래스 이름을 가져옵니다. 
        이 기능은 구현해야 합니다.

    .. php:method:: buildPath(string $class)

        :param string $class: 정규화된 클래스 이름
        :returns: 클래스가 저장될 절대 경로
        :rtype: string
        :throws: RuntimeException

        클래스 이름에서 파일 경로를 빌드합니다.

    .. php:method:: modifyBasename(string $filename)

        :param string $filename: 파일 경로의 기본(base) 이름
        :returns: 파일의 수정된 기본 이름(basename)입니다.
        :rtype: string

        하위 생성자가 저장하기 전에 파일의 기본 이름을 변경할 수 있는 마지막 기회를 제공합니다.
        이 기능은 기본 이름에 날짜 구성 요소가 있는 마이그레이션 파일에 유용합니다.

    .. php:method:: buildClassContents(string $class)

        :param string $class: 정규화된 클래스 이름
        :rtype: string

        템플릿에 필요한 모든 교체를 수행하여 생성되는 클래스에 대한 내용을 빌드합니다.

    .. php:method:: getTemplate()

        :rtype: string

        생성 중인 클래스의 템플릿을 가져옵니다. 
        이 기능은 구현해야 합니다.

    .. php:method:: getNamespace(string $class)

        :param string $class: 정규화된 클래스 이름
        :rtype: string

        정규화된 클래스 이름에서 네임스페이스 부분을 검색합니다.

    .. php:method:: setReplacements(string $template, string $class)

        :param string $template: 사용할 템플릿 문자열
        :param string $class: 정규화된 클래스 이름
        :returns: 모든 주석이 교체된 템플릿 문자열
        :rtype: string

        필요한 모든 교체를 수행합니다.

    .. php:method:: sortImports(string $template)

        :param string $template: 템플릿 파일
        :returns: 정렬된 가져온 모든 템플릿 파일
        :rtype: string

        Alphabetically sorts the imports for a given template.

.. warning:: 자식 생성기는 ``GeneratorCommand``\ 의 ``getNamespacedClass`` 와 ``getTemplate`` 두 가지 추상 메서드를 구현해야 합니다.
    그렇지 않으면 PHP 치명적인 오류가 발생합니다.

.. note:: ``GeneratorCommand`` 에는 기본 인수 ``['name' => 'Class name']``\ 가 있습니다.
    ``$arguments`` 속성 name에 설명을 재정의할 수 있습니다. ex> ``['name' => 'Module class name']``.

.. note:: ``GeneratorCommand`` \는 ``-n``\ 과 ``--force``\ 라는 기본 옵션을 가지고 있습니다.
    하위 클래스는 코드 생성을 구현하는 데 중요하므로 이 두 속성을 재정의할 수 없습니다.

.. note:: 생성기의 기본 그룹은 ``GeneratorCommand``\ 이므로 기본적으로 ``Generators`` 네임스페이스 아래에 등록됩니다.
    자신의 생성기를 다른 네임스페이스에 등록하려면 자식 생성기의 ``$group`` 속성을 제공하십시오.
    ex> ``protected $group = 'CodeIgniter';``
