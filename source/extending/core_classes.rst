****************************
핵심 시스템 클래스 작성
****************************

CodeIgniter가 실행될 때마다 프레임워크의 일부로 자동 초기화되는 몇 가지 핵심(core) 기본 클래스가 있습니다.
이 핵심 시스템 클래스는 상황에 따라 자신의 버전으로 바꾸거나 확장할 수 있습니다.

**대부분의 사용자는 이 작업을 수행할 필요가 없지만, 용도에 따라 CodeIgniter 코어를 크게 변경하려는 경우 이를 대체하거나 확장할 수 있습니다.**

.. note:: 핵심 시스템 클래스를 변경하는 것은 프레임워크에 많은 변화를 가져올 수 있음으로, 시도하기 전에 자신이 무엇을 하고 있는지 알아야 합니다.

System Class 목록
=====================

다음은 CodeIgniter가 실행될 때마다 호출되는 핵심(core) 시스템 파일 목록입니다:

* Config\\Services
* CodeIgniter\\Autoloader\\Autoloader
* CodeIgniter\\Config\\DotEnv
* CodeIgniter\\Controller
* CodeIgniter\\Debug\\Exceptions
* CodeIgniter\\Debug\\Timer
* CodeIgniter\\Events\\Events
* CodeIgniter\\HTTP\\CLIRequest (if launched from command line only)
* CodeIgniter\\HTTP\\IncomingRequest (if launched over HTTP)
* CodeIgniter\\HTTP\\Request
* CodeIgniter\\HTTP\\Response
* CodeIgniter\\HTTP\\Message
* CodeIgniter\\HTTP\\URI
* CodeIgniter\\Log\\Logger
* CodeIgniter\\Log\\Handlers\\BaseHandler
* CodeIgniter\\Log\\Handlers\\FileHandler
* CodeIgniter\\Router\\RouteCollection
* CodeIgniter\\Router\\Router
* CodeIgniter\\Security\\Security
* CodeIgniter\\View\\View
* CodeIgniter\\View\\Escaper

핵심 클래스 교체
======================

기본 시스템 클래스 대신 자신의 시스템 클래스 중 하나를 사용하려면 :doc:`오토로더 <../concepts/autoloader>`\ 가 클래스를 찾을 수 있는지, 새 클래스가 적절한 인터페이스를 확장하는지 확인하고 코어 클래스 대신 클래스를 로드하는 :doc:`서비스 <../concepts/services>`\ 를 수정해야 합니다.

다음 예는 핵심 시스템 클래스 대신 사용할 새 ``App\Libraries\RouteCollection`` 클래스를 작성합니다.

::

    <?php 
    
    namespace App\Libraries;

    use CodeIgniter\Router\RouteCollectionInterface;

    class RouteCollection implements RouteCollectionInterface
    {
        // ...
    }

그런 다음 ``routes`` 서비스에서 클래스를 로드 하도록 수정합니다.

::

	public static function routes(bool $getShared = false)
	{
		if ($getShared) {
			return static::getSharedInstance('routes');
		}

		return new RouteCollection(static::locator(), config('Modules'));
	}

핵심 클래스 확장
======================

기존 라이브러리에 몇 가지 기능을 추가하기 위해(한 두 가지의 메소드를 추가) 전체 라이브러리를 다시 작성하는 것은 너무 과합니다.
이 경우 클래스를 확장하는 것이 좋습니다.
클래스 확장은 클래스를 하나의 예외로 바꾸는 것과 거의 동일합니다.

* 클래스 선언은 부모 클래스를 확장해야합니다.

다음 예는 기본 RouteCollection 클래스를 확장하여 사용자 클래스를 선언합니다.

::

    <?php 
    
    namespace App\Libraries;

    use CodeIgniter\Router\RouteCollection;

    class RouteCollection extends RouteCollection
    {
        // ...
    }

클래스에서 생성자를 사용해야 하는 경우 부모 생성자를 호출해야 합니다.

::

    <?php 
    
    namespace App\Libraries;

    use CodeIgniter\Router\RouteCollection as BaseRouteCollection;

    class RouteCollection extends BaseRouteCollection
    {
        public function __construct()
        {
            parent::__construct();

            // your code here
        }
    }

**Tip:**  부모 클래스의 메소드와 동일한 이름을 가진 클래스의 모든 메소드가 기본 메소드 대신 사용됩니다("메소드 재정의(method overriding)"\ 라고 함). 이를 통해 CodeIgniter 코어를 실질적으로 변경할 수 있습니다.
