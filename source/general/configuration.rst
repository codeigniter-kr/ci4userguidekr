################################
Configuration File 설정
################################

Every application needs a way to define various settings that affect the application.
These are handled through configuration files. Configuration files simply
hold a class that contains its settings as public properties. Unlike in many other frameworks,
there is no single class that you need to use to access your settings. Instead, you simply
create an instance of the class and all your settings are there for you.
모든 응용 프로그램에는 응용 프로그램에 영향을주는 다양한 설정을 정의하는 방법이 필요합니다. 이들은 구성 파일을 통해 처리됩니다. 구성 파일은 설정을 공용 속성으로 포함하는 클래스를 보유하기 만하면됩니다. 다른 많은 프레임 워크와 달리, 설정에 액세스하는 데 사용해야하는 단일 클래스가 없습니다. 대신 클래스의 인스턴스를 만들면 모든 설정이 그대로 유지됩니다.

.. contents::
    :local:
    :depth: 2

Accessing Config Files
======================

You can access config files within your classes by creating a new instance or using the config function. All of the properties
are public, so you access the settings like any other property
새 인스턴스를 만들거나 config 함수를 사용하여 클래스 내의 구성 파일에 액세스 할 수 있습니다. 모든 속성은 공개되어 있으므로 다른 속성과 마찬가지로 설정에 액세스 할 수 있습니다.

::

	// Creating new class by hand
	$config = new \Config\EmailConfig();

	// Creating new class with config function
	$config = config( 'EmailConfig', false );

	// Get shared instance with config function
	$config = config( 'EmailConfig' );

	// Access config class with namespace
	$config = config( 'Config\\EmailConfig' );

	// Access settings as class properties
	$protocol = $config->protocol;
	$mailpath = $config->mailpath;

If no namespace is provided, it will look for the files in all available namespaces that have
been defined, as well as **/application/Config/**. All of the configuration files
that ship with CodeIgniter are namespaced with ``Config``. Using this namespace in your
application will provide the best performance since it knows exactly what directory to find the
files in and doesn't have to scan several locations in the filesystem to get there.
네임 스페이스가 제공되지 않으면 정의 된 사용 가능한 모든 네임 스페이스의 파일과 / application / Config / 를 찾습니다 . CodeIgniter와 함께 제공되는 모든 설정 파일은로 이름 붙여져 있습니다 Config. 응용 프로그램에서이 네임 스페이스를 사용하면 파일을 찾을 디렉토리를 정확히 알고 파일 시스템의 여러 위치를 스캔 할 필요가 없기 때문에 최상의 성능을 제공합니다.

You can locate the configuration files any place on your server by using a different namespace.
This allows you to pull configuration files on the production server to a folder that is not in
the web-accessible space at all, while keeping it under **/application** for ease of access during development.
다른 네임 스페이스를 사용하여 서버의 모든 위치에서 구성 파일을 찾을 수 있습니다. 이를 통해 프로덕션 서버의 구성 파일을 웹 액세스 가능한 공간이 아닌 폴더로 가져올 수 있으며 개발 중에 액세스하기 쉽도록 / application 아래에 보관할 수 있습니다.

Creating Configuration Files
============================

If you need to create a new configuration file you would create a new file at your desired location,
**/application/Config** by default. Then create the class and fill it with public properties that
represent your settings
새 구성 파일을 작성해야하는 경우 원하는 위치에 새 파일 ( / application / Config) 을 기본적으로 작성합니다. 그런 다음 클래스를 만들고 설정을 나타내는 public 속성으로 채 웁니다.

::

    namespace Config;
    use CodeIgniter\Config\BaseConfig;

    class App extends BaseConfig
    {
    	public $siteName  = 'My Great Site';
    	public $siteEmail = 'webmaster@example.com';

    }

The class should extend ``\CodeIgniter\Config\BaseConfig`` to ensure that it can receive environment-specific
settings.
클래스는 \CodeIgniter\Config\BaseConfig환경 별 설정을 수신 할 수 있도록 확장되어야합니다.

Handling Different Environments
===============================

Because your site can operate within multiple environments, such as the developer's local machine or
the server used for the production site, you can modify your values based on the environment.  Within these
you will have settings that might change depending on the server it's running on.This can include
database settings, API credentials, and other settings that will vary between deploys.
사이트는 개발자의 로컬 컴퓨터 또는 프로덕션 사이트에 사용되는 서버와 같은 여러 환경에서 작동 할 수 있으므로 환경에 따라 값을 수정할 수 있습니다. 여기에는 실행중인 서버에 따라 변경 될 수있는 설정이 있습니다. 여기에는 데이터베이스 설정, API 자격 증명 및 배포 사이에 달라질 기타 설정이 포함될 수 있습니다.

You can store values in a **.env** file in the root directory, alongside the system and application directories.
It is simply a collection of name/value pairs separated by an equal sign, much like a ".ini" file
.env 파일의 값을 시스템 디렉토리와 응용 프로그램 디렉토리와 함께 루트 디렉토리에 저장할 수 있습니다 . 이것은 단순히 ".ini" 파일과 마찬가지로 등호로 구분 된 이름/값 쌍의 모음입니다.

::

	S3_BUCKET="dotenv"
	SECRET_KEY="super_secret_key"

If the variable exists in the environment already, it will NOT be overwritten.
변수가 이미 환경에 존재하면 겹쳐 쓰지 않습니다.

.. important:: Make sure the **.env** file is added to **.gitignore** (or your version control system's equivalent)
	so it is not checked in the code. Failure to do so could result in sensitive credentials being stored in the
	repository for anyone to find.
	확실한 확인 .env의 파일이 추가됩니다 .gitignore (또는 버전 관리 시스템의 상당) 그래서이 코드에서 확인되지 않습니다. 그렇게하지 않으면 누구나 찾을 수있는 중요한 자격 증명이 저장소에 저장 될 수 있습니다.

You are encouraged to create a template file, like **env.example**, that has all of the variables your project
needs with empty or dummy data. In each environment, you can then copy the file to **.env** and fill in the
appropriate data.
env.example 과 같은 템플릿 파일을 만들면 프로젝트에 빈 데이터 나 더미 데이터가 필요한 모든 변수가 생성되는 것이 좋습니다 . 각 환경에서 파일을 .env 로 복사 하고 적절한 데이터를 채울 수 있습니다.

When your application runs, this file will be automatically loaded and the variables will be put into
the environment. This will work in any environment. These variables are then available through ``getenv()``,
``$_SERVER``, and ``$_ENV``. Of the three, ``getenv()`` function is recommended since it is not case-sensitive
응용 프로그램이 실행되면이 파일이 자동으로로드되고 변수가 환경에 저장됩니다. 이것은 모든 환경에서 작동합니다. 이러한 변수를 통해 다음을 사용할 수 있습니다 getenv(), $_SERVER그리고 $_ENV. 이 세 가지 중에서 getenv()대소 문자를 구분하지 않으므로 함수를 사용하는 것이 좋습니다.

::

	$s3_bucket = getenv('S3_BUCKET');
	$s3_bucket = $_ENV['S3_BUCKET'];
	$s3_bucket = $_SERVER['S3_BUCKET'];

.. note:: If you are using Apache, then the CI_ENVIRONMENT can be set at the top of 
    ``public/.htaccess``, which comes with a commented line to do that. Change the
    environment setting to the one you want to use, and uncomment that line.A

Nesting Variables
=================

To save on typing, you can reuse variables that you've already specified in the file by wrapping the
variable name within ``${...}``
입력시 저장하려면 다음과 같이 변수 이름을 줄 바꿈하여 파일에서 이미 지정한 변수를 다시 사용할 수 있습니다 ${...}.

::

	BASE_DIR="/var/webroot/project-root"
	CACHE_DIR="${BASE_DIR}/cache"
	TMP_DIR="${BASE_DIR}/tmp"

Namespaced Variables
====================

There will be times when you will have several variables with the same name. When this happens, the
system has no way of knowing what the correct value should be. You can protect against this by
"namespacing" the variables.
같은 이름의 여러 변수가있을 때가있을 것입니다. 이 경우 시스템은 올바른 값을 알아야합니다. 변수에 "네임 스페이스"를 지정하여이를 막을 수 있습니다.

Namespaced variables use a dot notation to qualify variable names when those variables
get incorporated into configuration files. This is done by including a distinguishing
prefix, followed by a dot (.), and then the variable name itself
이름 공간 변수는 점 표기법을 사용하여 해당 변수가 구성 파일에 통합 될 때 변수 이름을 한정합니다. 구분 접두어 뒤에 점 (.)을 붙인 다음 변수 이름 자체를 포함 시키면됩니다.

::

    // not namespaced variables
    name = "George"
    db=my_db

    // namespaced variables
    address.city = "Berlin"
    address.country = "Germany"
    frontend.db = sales
    backend.db = admin
    BackEnd.db = admin

Incorporating Environment Variables Into a Configuration
========================================================

When you instantiate a configuration file, any namespaced environment variables
are considered for merging into the a configuration objects' properties.
구성 파일을 인스턴스화하면 네임 스페이스 환경 변수가 구성 오브젝트의 특성으로 병합되는 것으로 간주됩니다.

If the prefix of a namespaced variable matches the configuration class name exactly,
case-sensitive, then the trailing part of the variable name (after the dot) is
treated as a configuration property name. If it matches an existing configuration
property, the environment variable's value will override the corresponding one
in the configuration file. If there is no match, the configuration properties are left unchanged.
네임 스페이스가있는 변수의 접두사가 구성 클래스 이름과 정확하게 일치하는 경우 (대소 문자가 구분 된 경우), 변수 이름의 후행 부분 (점 뒤)이 구성 속성 이름으로 처리됩니다. 기존 구성 등록 정보와 일치하면 환경 변수의 값이 구성 파일의 해당 구성 설정보다 우선합니다. 일치하는 항목이 없으면 구성 등록 정보는 변경되지 않습니다.

The same holds for a "short prefix", which is the name given to the case when the
environment variable prefix matches the configuration class name converted to lower case.
환경 접두어 접두사가 소문자로 변환 된 구성 클래스 이름과 일치하는 경우에 주어진 이름 인 "짧은 접두사"에 대해서도 마찬가지입니다.

Treating Environment Variables as Arrays
========================================

A namespaced environment variable can be further treated as an array.
If the prefix matches the configuration class, then the remainder of the
environment variable name is treated as an array reference if it also
contains a dot
네임 스페이스 환경 변수는 배열로 더 처리 될 수 있습니다. 접두사가 구성 클래스와 일치하면 환경 변수 이름의 나머지 부분에도 도트가 포함되어 있으면 배열 참조로 처리됩니다.

::

    // regular namespaced variable
    SimpleConfig.name = George

    // array namespaced variables
    SimpleConfig.address.city = "Berlin"
    SimpleConfig.address.country = "Germany"

If this was referring to a SimpleConfig configuration object, the above example would be treated as
이것이 SimpleConfig 설정 객체를 가리키고 있다면 위의 예제는 다음과 같이 취급 될 것입니다

::

    $address['city']    = "Berlin";
    $address['country'] = "Germany";

Any other elements of the ``$address`` property would be unchanged.
$address속성 의 다른 요소는 변경되지 않습니다.

You can also use the array property name as a prefix. If the environment file
held instead
접두어로 배열 속성 이름을 사용할 수도 있습니다. 환경 파일이 대신 보유 된 경우

::

    // array namespaced variables
    SimpleConfig.address.city = "Berlin"
    address.country = "Germany"

then the result would be the same as above.
결과는 위와 같을 것입니다.

Registrars
==========

A configuration file can also specify any number of "registrars", which are any
other classes which might provide additional configuration properties.
This is done by adding a ``registrars`` property to your configuration file,
holding an array of the names of candidate registrars.
구성 파일은 추가 등록 정보를 제공 할 수있는 다른 클래스 인 "레지스트라"를 원하는 수만큼 지정할 수도 있습니다. 이것은 registrars후보 등록자 이름 배열을 보유하고 있는 등록 정보를 구성 파일 에 추가하여 수행됩니다 .

::

    protected $registrars = [
        SupportingPackageRegistrar::class
    ];

In order to act as a "registrar" the classes so identified must have a
static function named the same as the configuration class, and it should return an associative
array of property settings.
"등록 기관"의 역할을하기 위해 이렇게 식별 된 클래스는 구성 클래스와 동일한 이름의 정적 함수를 가져야하며 속성 설정의 연관 배열을 반환해야합니다.

When your configuration object is instantiated, it will loop over the
designated classes in ``$registrars``. For each of these classes, which contains a method name matching
the configuration class, it will invoke that method, and incorporate any returned properties
the same way as described for namespaced variables.
구성 객체가 인스턴스화되면,에 지정된 클래스가 반복됩니다 $registrars. 구성 클래스와 일치하는 메소드 이름을 포함하는 이들 클래스 각각에 대해 메소드는 해당 메소드를 호출하고 리턴 된 특성을 이름 공간 변수에 대해 설명한 것과 같은 f}으로 통합합니다.

이를위한 예제 구성 클래스 설정 

::

    namespace App\Config;
    use CodeIgniter\Config\BaseConfig;

    class MySalesConfig extends baseConfig
    {
        public $target        = 100;
        public $campaign      = "Winter Wonderland";
        protected $registrars = [
            '\App\Models\RegionalSales';
        ];
    }

... 관련 지역 판매 모델은 다음과 같이 보일 수 있습니다.

::

    namespace App\Models;

    class RegionalSales
    {
        public static function MySalesConfig()
        {
            return ['target' => 45, 'actual' => 72];
        }
    }

위의 예에서 `MySalesConfig` 가 인스턴스화 되면 선언된 두 개의 등록 정보로 끝나게되지만 `$target`
등록 정보 의 값은 `RegionalSalesModel` 을 "registrar" 로 처리하여 무시할 수 있습니다 . 
결과 구성 등록 정보

::

    $target   = 45;
    $campaign = "Winter Wonderland";

