############
코드 모듈
############

CodeIgniter supports a form of code modularization to help you create reusable code. Modules are typically
centered around a specific subject, and can be thought of as mini-applications within your larger application. Any
of the standard file types within the framework are supported, like controllers, models, views, config files, helpers,
language files, etc. Modules may contain as few, or as many, of these as you like.
CodeIgniter는 재사용 가능한 코드를 생성하는 데 도움이되는 매우 간단한 모듈화 형식을 지원합니다. 모듈은 일반적으로 특정 주제를 중심으로하며 더 큰 응용 프로그램 내에서 미니 응용 프로그램으로 생각할 수 있습니다. 컨트롤러, 모델, 뷰, 구성 파일, 헬퍼, 언어 파일 등과 같이 프레임 워크 내의 표준 파일 형식이 모두 지원됩니다. 모듈은 원하는만큼 또는 그 중 일부만 포함 할 수 있습니다.

.. contents::
    :local:
    :depth: 2

==========
Namespaces
==========

The core element of the modules functionality comes from the :doc:`PSR4-compatible autoloading </concepts/autoloader>`
that CodeIgniter uses. While any code can use the PSR4 autoloader and namespaces, the only way to take full advantage of
modules is to namespace your code and add it to **app/Config/Autoload.php**, in the ``psr4`` section.
모듈 기능의 핵심 요소는 CodeIgniter에서 사용 하는 PSR4:doc:`PSR4-compatible autoloading </concepts/autoloader>` 에서 비롯됩니다 . 코드 모듈을 최대한 활용하기 위해 PSR4 오토로더 및 네임 스페이스 유일한 방법을 사용할 수 있지만 코드를 네임 스페이스와에 추가하는 것입니다 **app/Config/Autoload.php** 에, ``psr4`` 섹션.

For example, let's say we want to keep a simple blog module that we can re-use between components. We might create
folder with our company name, Acme, to store all of our modules within. We will put it right alongside our **application**
directory in the main project root
예를 들어 구성 요소간에 다시 사용할 수있는 간단한 블로그 모듈을 유지하려고한다고 가정 해 봅시다. 우리는 우리 회사의 모든 이름을 저장할 Acme이라는 폴더를 만들 수 있습니다. 기본 프로젝트 루트에있는 응용 프로그램 디렉토리 바로 옆에 넣을 것입니다.

::

    /acme        // New modules directory
    /application
    /public
    /system
    /tests
    /writable

Open **app/Config/Autoload.php** and add the **Acme** namespace to the ``psr4`` array property
**app/Config/Autoload.php** 를 열고 **Acme** 네임 스페이스를 ``psr4`` 배열 속성에 추가합니다 .

::

    public $psr4 = [
        'Acme' => ROOTPATH.'acme'
    ];

Now that this is setup we can access any file within the **acme** folder through the ``Acme`` namespace. This alone
takes care of 80% of what is needed for modules to work, so you should be sure to familiarize yourself within namespaces
and become comfortable with their use. A number of the file types will be scanned for automatically through all defined
namespaces here, making this crucial to working with modules at all.
이제는 이것이 설정되어서 우리는 네임스페이스 ``Acme`` 를 통해 **acme** 폴더 내의 모든 파일에 액세스 할 수 있습니다. 이것만으로도 모듈이 작동하는 데 필요한 것의 80 %를 처리하므로 네임 스페이스 내에 익숙해지고 사용에 익숙해 져야합니다. 여기에 정의 된 모든 네임 스페이스를 통해 여러 파일 유형이 자동으로 검색되므로 모듈 작업을하는 데 매우 중요합니다.

A common directory structure within a module will mimic the main application folder
모듈 내의 공통 디렉토리 구조는 기본 응용 프로그램 폴더를 모방합니다.

::

    /acme
        /Blog
            /Config
            /Controllers
            /Database
                /Migrations
                /Seeds
            /Helpers
            /Language
                /en
            /Libraries
            /Models
            /Views

Of course, there is nothing forcing you to use this exact structure, and you should organize it in the manner that
best suits your module, leaving out directories you don't need, creating new directories for Entities, Interfaces,
or Repositories, etc.
물론,이 정확한 구조를 사용하도록 강요하는 것은 없으며 필요하지 않은 디렉토리를 제외하고 모듈에 가장 적합한 방식으로 구성하고 엔티티, 인터페이스 또는 저장소에 대한 새로운 디렉토리를 작성해야합니다.

==============
Auto-Discovery
==============

Many times, you will need to specify the full namespace to files you want to include, but CodeIgniter can be
configured to make integrating modules into your applications simpler by automatically discovering many different
file types, including:

- :doc:`Events </extending/events>`
- :doc:`Registrars </general/configuration>`
- :doc:`Route files </incoming/routing>`
- :doc:`Services </concepts/services>`

This is configured in the file **app/Config/Modules.php**.

The auto-discovery system works by scanning any psr4 namespaces that have been defined within **Config/Autoload.php**
for familiar directories/files.

When at the **acme** namespace above, we would need to make one small adjustment to make it so the files could be found:
each "module" within the namespace would have to have it's own namespace defined there. **Acme** would be changed
to **Acme\Blog**. Once  your module folder has been defined, the discover process would look for a Routes file, for example,
at **/acme/Blog/Config/Routes.php**, just as if it was another application.

Enable/Disable Discover
=======================

You can turn on or off all auto-discovery in the system with the **$enabled** class variable. False will disable
all discovery, optimizing performance, but negating the special capabilities of your modules.

Specify Discovery Items
=======================

With the **$activeExplorers** option, you can specify which items are automatically discovered. If the item is not
present, then no auto-discovery will happen for that item, but the others in the array will still be discovered.


==================
Working With Files
==================

This section will take a look at each of the file types (controllers, views, language files, etc) and how they can
be used within the module. Some of this information is described in more detail in the relevant location of the user
guide, but is being reproduced here so that it's easier to grasp how all of the pieces fit together.
이 섹션에서는 각 파일 유형 (컨트롤러, 뷰, 언어 파일 등)과 모듈 내에서 이들이 사용되는 방법을 살펴볼 것입니다. 이 정보 중 일부는 사용자 안내서의 관련 위치에 자세히 설명되어 있지만 여기에 재현되어 모든 조각이 어떻게 맞는지 쉽게 파악할 수 있습니다.

Routes
======

By default, :doc:`routes </incoming/routing>` are automatically scanned for within modules. It can be turned off in
the **Modules** config file, described above.
기본적으로 :doc:`라우투 </incoming/routing>`\ 는 모듈 내에서 자동으로 검색됩니다. 위에서 설명한 **Modules** 설정 파일에서 해제 할 수 있습니다.

.. note:: Since the files are being included into the current scope, the ``$routes`` instance is already defined for you.
    It will cause errors if you attempt to redefine that class.
    파일이 현재 범위에 포함되므로 ``$routes`` 인스턴스가 이미 정의되어 있습니다. 해당 클래스를 다시 정의하려고하면 오류가 발생합니다.

Controllers
===========

Controllers outside of the main **app/Controllers** directory cannot be automatically routed by URI detection,
but must be specified within the Routes file itself

::

    // Routes.php
    $routes->get('blog', 'Acme\Blog\Controllers\Blog::index');

To reduce the amount of typing needed here, the **group** routing feature is helpful
여기에 필요한 타이핑 양을 줄이려면 그룹 라우팅 기능이 유용합니다.

::

    $routes->group('blog', ['namespace' => 'Acme\Blog\Controllers'], function($routes)
    {
        $routes->get('/', 'Blog::index');
    });

Config Files
============

No special change is needed when working with configuration files. These are still namespaced classes and loaded
with the ``new`` command
구성 파일 작업시 특별한 변경이 필요하지 않습니다. 이들은 여전히 네임 스페이스 클래스이며 다음 ``new`` 명령으로 로드됩니다 .

::

    $config = new \Acme\Blog\Config\Blog();

Config files are automatically discovered whenever using the **config()** function that is always available    

Migrations
==========

Migration files will be automatically discovered within defined namespaces. All migrations found across all
namespaces will be run every time.
마이그레이션 파일은 정의 된 네임 스페이스 내에서 자동으로 검색됩니다. 모든 네임 스페이스에서 발견되는 모든 마이그레이션은 매번 실행됩니다.

Seeds
=====

Seed files can be used from both the CLI and called from within other seed files as long as the full namespace
is provided. If calling on the CLI, you will need to provide double backslashes
seed 파일은 CLI에서 모두 사용할 수 있으며 전체 네임 스페이스가 제공되는 한 다른 시드 파일 내에서 호출 될 수 있습니다. CLI에서 호출할 때는 이중 백 슬래시(\\)를 사용해야 합니다.
::

    > php public/index.php migrations seed Acme\\Blog\\Database\\Seeds\\TestPostSeeder

Helpers
=======

Helpers will be located automatically from defined namespaces when using the ``helper()`` method, as long as it
is within the namespaces **Helpers** directory
헬퍼는 ``helper()`` 네임 스페이스 **Helpers** 디렉터리 내에있는 한 메서드를 사용할 때 정의 된 네임 스페이스에서 자동으로 배치됩니다 .

::

    helper('blog');

Language Files
==============

Language files are located automatically from defined namespaces when using the ``lang()`` method, as long as the
file follows the same directory structures as the main application directory.
언어 파일은 ``lang()`` 메소드가 사용될 때 정의 된 이름 공간에서 자동으로 위치 합니다. 단, 파일이 기본 응용 프로그램 디렉토리와 동일한 디렉토리 구조를 따르는 경우입니다.

Libraries
=========

Libraries are always instantiated by their fully-qualified class name, so no special access is provided
라이브러리는 항상 정규화 된 클래스 이름으로 인스턴스화되므로 특별한 액세스가 제공되지 않습니다.

::

    $lib = new \Acme\Blog\Libraries\BlogLib();

Models
======

Models are always instantiated by their fully-qualified class name, so no special access is provided
모델은 항상 정규화 된 클래스 이름으로 인스턴스화되므로 특별한 액세스가 제공되지 않습니다.

::

    $model = new \Acme\Blog\Models\PostModel();

Views
=====

Views can be loaded using the class namespace as described in the :doc:`views </outgoing/views>` documentation
뷰는 :doc:`views </outgoing/views>` 문서에 설명 된대로 클래스 네임 스페이스를 사용하여 로드 할 수있습니다

::

    echo view('Acme\Blog\Views\index');
