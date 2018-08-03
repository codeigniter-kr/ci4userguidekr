#################
Autoloading Files
#################

Every application consists of a large number of classes in many different locations.
The framework provides classes for core functionality. Your application will have a
number of libraries, models, and other entities to make it work. You might have third-party
classes that your project is using. Keeping track of where every single file is, and
hard-coding that location into your files in a series of ``requires()`` is a massive
headache and very error-prone. That's where autoloaders come in.
모든 응용 프로그램은 많은 다른 위치에 많은 수의 클래스로 구성되어 있습니다. 프레임 워크는 핵심 기능을위한 클래스를 제공합니다. 응용 프로그램에는 여러 라이브러리, 모델 및 기타 엔티티가 있어야 작동합니다. 프로젝트에서 사용하는 제 3 자 클래스가있을 수 있습니다. 모든 단일 파일이 어디에 있는지 추적하고 일련의 파일에 해당 위치를 하드 코딩하는 requires()것은 큰 골치 거리이며 오류가 발생하기 쉽습니다. 그것이 오토로더가 들어오는 곳입니다.

CodeIgniter provides a very flexible autoloader that can be used with very little configuration.
It can locate individual non-namespaced classes, namespaced classes that adhere to
`PSR4 <http://www.php-fig.org/psr/psr-4/>`_ autoloading
directory structures, and will even attempt to locate classes in common directories (like Controllers,
Models, etc).
CodeIgniter는 아주 작은 구성으로 사용할 수있는 매우 유연한 오토로더를 제공합니다. 개별 네임 스페이스가없는 클래스, PSR4 자동로드 디렉토리 구조 를 준수하는 네임 스페이스 클래스 를 찾을 수 있으며 공통 디렉토리 (예 : 컨트롤러, 모델 등)에 클래스를 배치하려고 시도합니다.

For performance improvement, the core CodeIgniter components have been added to the classmap.
성능 향상을 위해 핵심 CodeIgniter 구성 요소가 클래스 맵에 추가되었습니다.

The autoloader works great by itself, but can also work with other autoloaders, like
`Composer <https://getcomposer.org>`_, or even your own custom autoloaders, if needed.
Because they're all registered through
`spl_autoload_register <http://php.net/manual/en/function.spl-autoload-register.php>`_,
they work in sequence and don't get in each other's way.
오토로더는 그 자체로 훌륭하게 작동하지만 필요한 경우 작곡가 와 같은 다른 오토로더 또는 사용자 정의 오토로더 와도 작업 할 수 있습니다 . 그들은 모두 spl_autoload_register를 통해 등록 되었으므로 순서대로 작동하고 서로간에 영향을주지 않습니다.

The autoloader is always active, being registered with ``spl_autoload_register()`` at the
beginning of the framework's execution.
오토로더는 항상 활성화 spl_autoload_register()되어 있으며 프레임 워크가 실행될 때 등록됩니다 .

Configuration
=============

Initial configuration is done in **/application/Config/Autoload.php**. This file contains two primary
arrays: one for the classmap, and one for PSR4-compatible namespaces.
초기 설정은 /application/Config/Autoload.php 에서 이루어집니다 . 이 파일에는 클래스 맵용과 PSR4 호환 네임 스페이스 용의 두 가지 기본 배열이 들어 있습니다.

Namespaces
==========

The recommended method for organizing your classes is to create one or more namespaces for your
application's files. This is most important for any business-logic related classes, entity classes,
etc. The ``psr4`` array in the configuration file allows you to map the namespace to the directory
those classes can be found in
클래스 구성에 권장되는 방법은 응용 프로그램 파일에 대한 하나 이상의 네임 스페이스를 만드는 것입니다. 이는 비즈니스 로직 관련 클래스, 엔티티 클래스 등에서 가장 중요 psr4합니다. 구성 파일 의 배열을 사용하면 네임 스페이스를 해당 클래스를 찾을 수있는 디렉토리에 매핑 할 수 있습니다.

::

	$psr4 = [
		'App'         => APPPATH,
		'CodeIgniter' => BASEPATH,
	];

The key of each row is the namespace itself. This does not need a trailing slash. If you use double-quotes
to define the array, be sure to escape the backwards slash. That means that it would be ``My\\App``,
not ``My\App``. The value is the location to the directory the classes can be found in. They should
have a trailing slash.
각 행의 키는 네임 스페이스 자체입니다. 여기에는 슬래시가 필요하지 않습니다. 큰 따옴표를 사용하여 배열을 정의하는 경우 역 슬래시를 이스케이프해야합니다. 즉, 될 것을 의미 My\\App하지 My\App. 이 값은 클래스를 찾을 수있는 디렉토리의 위치이며, 뒤에 슬래시가 있어야합니다.

By default, the application folder is namespace to the ``App`` namespace. While you are not forced to namespace the controllers,
libraries, or models in the application directory, if you do, they will be found under the ``App`` namespace.
You may change this namespace by editing the **/application/Config/Constants.php** file and setting the
new namespace value under the ``APP_NAMESPACE`` setting
기본적으로 응용 프로그램 폴더는 네임 스페이스의 App네임 스페이스입니다. 컨트롤러, 라이브러리 또는 모델의 응용 프로그램 디렉토리에 네임 스페이스를 지정해야하는 것은 아니지만 네임 스페이스 아래에서 찾을 수 있습니다 App. /application/Config/Constants.php 파일 을 편집 하고 설정에서 새 네임 스페이스 값을 설정 하여이 네임 스페이스를 변경할 수 있습니다 APP_NAMESPACE.

::

	define('APP_NAMESPACE', 'App');

You will need to modify any existing files that are referencing the current namespace.
현재 네임 스페이스를 참조하는 기존 파일을 수정해야합니다.

.. important:: Config files are namespaced in the ``Config`` namespace, not in ``App\Config`` as you might
	expect. This allows the core system files to always be able to locate them, even when the application
	namespace has changed.
	구성 파일은 예상대로 Config네임 스페이스에 네임 스페이스로 저장됩니다 App\Config. 따라서 응용 프로그램 네임 스페이스가 변경된 경우에도 핵심 시스템 파일에서 항상 해당 위치를 찾을 수 있습니다.

Classmap
========

The classmap is used extensively by CodeIgniter to eke the last ounces of performance out of the system
by not hitting the file-system with extra ``file_exists()`` calls. You can use the classmap to link to
third-party libraries that are not namespaced
클래스 맵은 CodeIgniter에 의해 광범위하게 사용되어 여분의 file_exists()호출로 파일 시스템을 치지 않음으로써 시스템의 마지막 성능을 실현 합니다. 클래스 맵을 사용하여 네임 스페이스가 아닌 타사 라이브러리에 연결할 수 있습니다.

::

	$classmap = [
		'Markdown' => APPPATH .'third_party/markdown.php'
	];

The key of each row is the name of the class that you want to locate. The value is the path to locate it at.
각 행의 키는 찾으려는 클래스의 이름입니다. 값은 위치를 찾을 경로입니다.

Legacy Support
==============

If neither of the above methods find the class, and the class is not namespaced, the autoloader will look in the
**/application/Libraries** and **/application/Models** directories to attempt to locate the files. This provides
a measure to help ease the transition from previous versions.
위의 메소드 중 어느 것도 클래스를 찾지 않고 클래스가 이름 공간이 아닌 경우, 자동 로더는 / application / Libraries 및 / application / Models 디렉토리를 검색하여 파일 위치를 찾습니다. 이렇게하면 이전 버전에서 쉽게 이전 할 수 있습니다.

There are no configuration options for legacy support.
레거시 지원을위한 구성 옵션은 없습니다.