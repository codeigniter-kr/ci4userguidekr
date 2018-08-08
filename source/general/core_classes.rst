****************************
Creating Core System Classes
****************************

Every time CodeIgniter runs there are several base classes that are initialized automatically as part of the core
framework. It is possible, however, to swap any of the core system classes with your own version or even just extend
the core versions.
CodeIgniter가 실행될 때마다 핵심 프레임 워크의 일부로 자동 초기화되는 여러 기본 클래스가 있습니다. 그러나 핵심 시스템 클래스를 자신의 버전으로 바꾸거나 핵심 버전 만 확장 할 수도 있습니다.

**Most users will never have any need to do this, but the option to replace or extend them does exist for those
who would like to significantly alter the CodeIgniter core.**
**대부분의 사용자는이 작업을 수행 할 필요가 없지만 CodeIgniter 코어를 크게 변경하려는 사용자를 위해이를 대체하거나 확장 할 수있는 옵션이 있습니다.**

.. note:: Messing with a core system class has a lot of implications, so make sure you know what you are doing before
    attempting it.
    핵심 시스템 클래스를 망친다는 것은 많은 의미를 지니기 때문에 시도하기 전에 무엇을하고 있는지 알도록하십시오.

System Class List
=================

The following is a list of the core system files that are invoked every time CodeIgniter runs:
다음은 CodeIgniter가 실행될 때마다 호출되는 핵심 시스템 파일 목록입니다.

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
* CodeIgniter\\Log\\Logger
* CodeIgniter\\Log\\Handlers\\BaseHandler
* CodeIgniter\\Log\\Handlers\\FileHandler
* CodeIgniter\\Router\\RouteCollection
* CodeIgniter\\Router\\Router
* CodeIgniter\\Security\\Security
* CodeIgniter\\View\\View
* CodeIgniter\\View\\Escaper

Replacing Core Classes
======================

To use one of your own system classes instead of a default one, ensure that the :doc:`Autoloader <../concepts/autoloader>`
can find your class, that  your new class extends the appropriate interface, and modify the appropriate
:doc:`Service <../concepts/services>` to load your class in place of the core class.
기본 시스템 클래스 대신 자체 시스템 클래스 중 하나를 사용하려면 Autoloader 가 클래스를 찾을 수 있는지, 새 클래스가 적절한 인터페이스를 확장하는지 확인한 다음 해당 서비스 를 수정 하여 핵심 클래스 대신 클래스를로드하십시오.

For example, if you have a new ``App\Libraries\RouteCollection`` class that you would like to use in place of
the core system class, you would create your class like this
예를 들어 App\Libraries\RouteCollection핵심 시스템 클래스 대신 사용하려는 새 클래스가 있으면 다음과 같이 클래스를 만듭니다.

::

    namespace App\Libraries;

    class RouteCollection implements \CodeIgniter\Router\RouteCollectionInterface
    {

    }

Then  you would modify the ``routes`` service to load your class instead
그런 다음 routes클래스를로드 하도록 서비스를 수정합니다.

::

	public static function routes($getShared = false)
	{
		if (! $getShared)
		{
			return new \App\Libraries\RouteCollection();
		}

		return self::getSharedInstance('routes');
	}

Extending Core Classes
======================

If all you need to is add some functionality to an existing library - perhaps add a method or two - then it's overkill
to recreate the entire library. In this case it's better to simply extend the class. Extending the class is nearly
identical to replacing a class with a one exception:
기존 라이브러리에 몇 가지 기능을 추가하는 것이 필요하다면 - 아마도 하나 또는 두 개의 메소드를 추가하십시오 - 그러면 전체 라이브러리를 다시 만들려면 과잉입니다. 이 경우 단순히 클래스를 확장하는 것이 좋습니다. 클래스를 확장하는 것은 클래스를 하나의 예외로 대체하는 것과 거의 동일합니다.

* The class declaration must extend the parent class.
* 클래스 선언은 상위 클래스를 확장해야합니다.

For example, to extend the native RouteCollection class, you would declare your class with
예를 들어 기본 RouteCollection 클래스를 확장하려면 다음을 사용하여 클래스를 선언합니다.

::

    class RouteCollection extends \CodeIgniter\Router\RouteCollection
    {

    }

If you need to use a constructor in your class make sure you extend the parent constructor
클래스에서 생성자를 사용해야하는 경우 부모 생성자를 확장해야합니다.

::

        class RouteCollection implements \CodeIgniter\Router\RouteCollection
        {
            public function __construct()
            {
                parent::__construct();
            }
        }

**Tip:**  Any functions in your class that are named identically to the methods in the parent class will be used
instead of the native ones (this is known as “method overriding”). This allows you to substantially alter the CodeIgniter core.
**Tip:** 상위 클래스의 메소드와 동일하게 이름이 지정된 클래스의 모든 함수가 기본 클래스의 메소드 대신 사용됩니다 (이를 "메소드 대체"라고 함). 이를 통해 CodeIgniter 코어를 크게 변경할 수 있습니다.

If you are extending the Controller core class, then be sure to extend your new class in your application controller’s
constructors
Controller 핵심 클래스를 확장하는 경우 응용 프로그램 컨트롤러의 생성자에서 새 클래스를 확장해야합니다.

::

	class Home extends App\BaseController {

	}

