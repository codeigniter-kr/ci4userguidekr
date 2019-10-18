################################
구성(configuration) 파일 작업
################################

모든 응용 프로그램에는 응용 프로그램에 영향을 미치는 다양한 설정을 정의 할 수 있는 방법이 필요합니다.
이들은 구성 파일을 통해 처리됩니다.
구성 파일에는 공용 속성 설정이 포함된 클래스가 있습니다.
다른 많은 프레임워크와 달리 설정에 액세스하기 위해 사용해야 하는 클래스는 없습니다.
대신 클래스의 인스턴스를 작성하기 만하면 모든 설정이 가능합니다.

.. contents::
    :local:
    :depth: 2

구성 파일에 액세스
======================

새 인스턴스를 만들거나 config 함수를 사용하여 클래스내의 구성 파일에 액세스 할 수 있습니다.
모든 속성이 공개되므로 다른 속성과 마찬가지로 설정에 액세스할 수 있습니다.::

	// Creating new class by hand
	$config = new \Config\Pager();

	// Creating new class with config function
	$config = config( 'Pager', false );

	// Get shared instance with config function
	$config = config( 'Pager' );

	// Access config class with namespace
	$config = config( 'Config\\Pager' );

	// Access settings as class properties
	$pageSize = $config->perPage;

네임스페이스가 제공되지 않으면 **/app/Config/**\ 뿐만 아니라 정의 된 사용 가능한 모든 네임스페이스에서 파일을 찾습니다.
CodeIgniter와 함께 제공되는 모든 구성 파일의 네임스페이스는 ``Config``\ 입니다.
응용 프로그램에서 이 네임스페이스를 사용하면 파일을 찾을 디렉토리를 정확히 알고, 파일 시스템에서 여러 위치를 스캔할 필요가 없으므로 최상의 성능을 제공 할 수 있습니다.

다른 네임스페이스를 사용하여 서버의 어느 위치에서나 구성 파일을 찾을 수 있습니다.
이를 통해 프로덕션 서버의 구성 파일중 웹 액세스 공간에 없는 폴더를 **/app** 아래로 가져 와서 개발 중에 쉽게 액세스 할 수 있습니다.

구성 파일 만들기
============================

새 구성 파일을 생성해야 하는 경우 원하는 위치(기본적으로 **/app/Config**)에 새 파일을 생성하십시오.
그런 다음 클래스를 만들고 설정을 나타내는 공용 속성으로 채우십시오.::

    <?php namespace Config;

    use CodeIgniter\Config\BaseConfig;

    class App extends BaseConfig
    {
    	public $siteName  = 'My Great Site';
    	public $siteEmail = 'webmaster@example.com';

    }

클래스는 환경 별 설정을 받을 수 있도록 ``\CodeIgniter\Config\BaseConfig``\ 를 확장해야 합니다.

다양한 환경 처리
===============================

사이트는 개발자의 로컬 컴퓨터 또는 프로덕션 사이트에 사용되는 서버와 같은 여러 환경에서 작동 할 수 있으므로 환경에 따라 값을 수정할 수 있습니다.
실행 중인 서버에 따라 변경될 수 있는 설정으로 데이터베이스 설정, API 자격 증명 및 배포마다 다른 기타 설정이 포함될 수 있습니다.

시스템 및 응용 프로그램 디렉토리와 함께 루트 디렉토리의 **.env** 파일에 값을 저장할 수 있습니다.
".ini" 파일과 같은 등호(=)로 구분 된 이름(name)/값(value) 쌍의 모음입니다.::

	S3_BUCKET="dotenv"
	SECRET_KEY="super_secret_key"

변수가 이미 환경에 존재하는 경우 덮어쓰지 않습니다.

.. important:: .env 파일이 배포되지 않도록 .gitignor(또는 버전 관리 시스템의 동일한 파일)에 추가되었는지 확인하십시오. 그렇지 않으면 중요한 자격 증명이 저장소에 저장되어 누구나 이를 볼수있게 됩니다.

프로젝트에 **env.example** 파일과 같은 비어 있거나 더미 데이터로 필요한 모든 변수가 포함 된 템플릿 파일을 작성하여 두면, 각 환경에서 이 파일을 **.env** 로 복사하고 적절하게 활용할 수 있습니다.

응용 프로그램이 실행되면 이 파일(.env)이 자동으로 로드되고 변수가 환경에 배치되며, 모든 환경에서 작동합니다.
이렇게 로드된 변수는 ``getenv()``, ``$_SERVER``, 및 ``$_ENV``\ 를 통해 사용할 수 있습니다. 
이 세 가지 중 ``getenv()`` 함수는 대소문자를 구분하지 않음으로 사용을 권장합니다.::

	$s3_bucket = getenv('S3_BUCKET');
	$s3_bucket = $_ENV['S3_BUCKET'];
	$s3_bucket = $_SERVER['S3_BUCKET'];

.. note:: Apache를 사용하는 경우 CI_ENVIRONMENT를 ``public/.htaccess`` 파일의 맨 위에 설정할 수 있으며, 주석 처리되어 있습니다.
    환경 설정을 사용하려는 환경으로 변경하고 해당 줄의 주석을 해제하십시오.

중첩(Nesting) 변수
=====================

입력 시간을 절약하기 위해 변수 이름을 ``${...}``\ 로 묶어 파일에 이미 지정한 변수를 재사용 할 수 있습니다.::

	BASE_DIR="/var/webroot/project-root"
	CACHE_DIR="${BASE_DIR}/cache"
	TMP_DIR="${BASE_DIR}/tmp"

네임스페이스 변수
====================

이름이 같은 변수가 여러개 있을 때가 있습니다.
이 경우 시스템은 올바른 값이 무엇인지 알 방법이 없습니다.
변수에 "네임스페이스"를 지정하여 이를 방지 할 수 있습니다.

네임스페이스 변수는 구성 파일에 점 표기법을 사용하여 변수 이름을 지정 합니다.
이것은 구별 접두사와 점(.), 변수 이름으로 구성합니다.::

    // not namespaced variables
    name = "George"
    db=my_db

    // namespaced variables
    address.city = "Berlin"
    address.country = "Germany"
    frontend.db = sales
    backend.db = admin
    BackEnd.db = admin

환경 변수를 구성에 통합
========================================================

구성 파일을 인스턴스화하면 네임스페이스 환경 변수가 구성 개체의 속성에 병합되는 것으로 간주됩니다.

네임스페이스가 있는 변수의 접두사가 대소문자를 구분하여 구성 클래스 이름과 정확히 일치하면, 변수 이름의 마지막 부분(점 뒤)이 구성 속성 이름으로 처리됩니다.
기존 구성 특성과 일치하면 환경 변수의 값이 구성 파일의 해당 값을 대체하고, 일치하는 것이 없으면 구성 속성은 변경되지 않습니다.

짧은 접두사도 마찬가지인데, 이는 환경변수 접두사가 소문자로 변환된 구성 클래스 이름과 일치할 때 주어진 이름입니다.

환경변수를 배열로 처리
========================================

네이스페이스 환경변수는 배열로 처리될 수 있습니다.
접두사가 구성 클래스와 일치하면 나머지 환경 변수 이름도 점을 포함하는 경우 배열 참조로 처리됩니다.::

    // regular namespaced variable
    SimpleConfig.name = George

    // array namespaced variables
    SimpleConfig.address.city = "Berlin"
    SimpleConfig.address.country = "Germany"


이것이 SimpleConfig 구성 오브젝트를 참조하는 경우 위 예제는 다음과 같이 처리됩니다.::

    $address['city']    = "Berlin";
    $address['country'] = "Germany";

``$address`` 속성의 다른 요소는 변경되지 않습니다.

배열 속성 이름을 접두사로 사용할 수도 있습니다. 환경 파일이 대신 유지되는 경우::

    // array namespaced variables
    SimpleConfig.address.city = "Berlin"
    address.country = "Germany"

그러면 결과는 위와 같습니다.

.. _registrars:

등록자(Registrars)
=====================

구성 파일은 추가 구성 특성을 제공 할 수있는 다른 클래스인 "registrars"를 얼마든지 지정할 수 있습니다.
후보 등록자(registrars)들의 이름을 나열하고 구성 파일에 ``registrars`` 특성을 추가하면됩니다.

::

    protected $registrars = [
        SupportingPackageRegistrar::class
    ];


"등록자" 역할을 하려면 식별된 클래스에는 구성 클래스와 동일한 이름의 정적 함수가 있어야 하며 속성 설정의 연관 배열을 리턴해야 합니다.

구성 개체가 인스턴스화되면 ``$registrars``\ 에 지정된 클래스를 순환합니다.
구성 클래스와 일치하는 메서드 이름을 포함된 각 클래스에 대해 해당 메서드를 호출하고, 네임스페이스 변수에 대해 설명한 것과 동일한 방식으로 리턴된 속성을 통합합니다.

구성 클래스 설정 예::

    <?php namespace App\Config;

    use CodeIgniter\Config\BaseConfig;

    class MySalesConfig extends BaseConfig
    {
        public $target        = 100;
        public $campaign      = "Winter Wonderland";
        protected $registrars = [
            '\App\Models\RegionalSales';
        ];
    }

... RegionalSales 모델 파일::

    <?php namespace App\Models;

    class RegionalSales
    {
        public static function MySalesConfig()
        {
            return ['target' => 45, 'actual' => 72];
        }
    }

위 예에서 `MySalesConfig`\ 가 인스턴스화될 때 선언된 두 가지 속성은, `RegionalSalesModel`\ 을 "registrar"\ 로 처리함으로써 `$target` 속성의 값이 오버라이드됩니다. 샘플 결과 값::

    $target   = 45;
    $campaign = "Winter Wonderland";
