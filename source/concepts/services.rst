###############
서비스(Service)
###############

.. contents::
    :local:
    :depth: 2

소개
============

CodeIgniter 내의 모든 핵심(core) 클래스는 "서비스(Service)"로 제공됩니다.
이는 로드할 클래스 이름을 하드 코딩하는 대신 호출할 클래스가 매우 단순한 구성 파일 내에 정의된다는 것을 의미합니다.
이 파일은 팩토리(factory) 유형으로 작동하여 필요한 클래스의 새 인스턴스를 생성합니다.

타이머 클래스를 예로 들겠습니다. 타이머 클래스의 새 인스턴스를 만드는 방법입니다.

::

    $timer = new \CodeIgniter\Debug\Timer();

다른 타이머 클래스를 사용하기로 결정할 때까지 이는 매우 잘 작동합니다.
이 타이머 클래스는 기본 타이머가 제공하지 않는 고급 보고(Report) 기능이 있을 수 있으며, 
이 경우 어플리케이션의 로그를 보관하기 위한 시간이 많이 걸려 오류가 발생할 수 있습니다.
위와 같은 방식으로 클래스의 인스턴스를 생성하면 이를 수정하기 위해 어플리케이션에서 타이머 클래스를 사용한 모든 위치를 찾아야 합니다.
이런 경우 서비스방식이 유용해집니다.

우리가 인스턴스를 직접 만드는 대신 중앙 클래스가 클래스의 인스턴스를 만들도록 합니다.
이 클래스는 매우 간단하며, 서비스로 사용하려는 각 클래스에 대한 메소드만 포함합니다.
이 메소드는 일반적으로 해당 클래스의 공유 인스턴스를 반환하여 해당 클래스의 종속성을 전달합니다.

그런 다음 타이머 생성 코드를 이 새로운 클래스를 호출하는 코드로 바꿉니다.

::

    $timer = \Config\Services::timer();

사용된 구현을 변경해야 할 경우 서비스 구성 파일을 수정할 수 있으며, 변경 작업 없이 어플리케이션 전체에서 자동으로 반영됩니다.
이제 새로운 기능을 활용하기만 하면됩니다. 

이는 매우 간단하고 오류에 강합니다.

.. note:: 서비스는 컨트롤러에서 생성하는 것이 좋습니다. 
    모델 및 라이브러리와 같은 다른 파일에는 종속성이 생성자 또는 setter 메소드를 통해 전달되어야 합니다.


편의 기능
---------

서비스를 위해 두 가지 기능이 제공되며, 이 기능은 항상 사용 가능합니다.

첫 번째는 ``service()``\ 이며 요청된 서비스의 새 인스턴스를 반환합니다.
필요한 매개 변수(parameter)는 한 개이며, 서비스 이름입니다.

서비스를 통하여 반환된 인스턴스는 클래스의 SHARED 인스턴스이므로 함수를 
여러 번 호출해도 항상 동일한 인스턴스가 반환됩니다.

::

    $logger = service('logger');

서비스 생성시 추가 매개 변수를 전달이 필요하면 서비스 이름 다음 두 번째 매개변수로 전달합니다.

::

    $renderer = service('renderer', APPPATH.'views/');

``single_service()`` 함수는 ``service()`` 함수와 똑같이 작동하지만, 호출할 때마다 새로운 클래스 인스턴스를 반환합니다.

::

    $logger = single_service('logger');

서비스 정의
===========

서비스가 제대로 작동하려면 각 클래스에 일정한 API 또는 `인터페이스 <https://www.php.net/manual/en/language.oop5.interfaces.php>`_\ 를 사용하여 서비스를 이용할 수 있어야 합니다.
CodeIgniter의 거의 모든 클래스는 해당 클래스가 준수하는 인터페이스를 제공합니다.
코어 클래스를 확장하거나 교체하려는 경우 인터페이스의 요구 사항을 충족하고 클래스가 호환되는지 확인합니다.

``RouterCollectionInterface``\ 를 구현한 ``RouterCollection`` 클래스를 예로 들어보겠습니다.
경로(route)를 생성하는 다른 방법을 제공하는 클래스를 만든다면, ``RouterCollectionInterface``\ 를 구현하는 새 클래스를 만들어야 합니다.

::

    class MyRouter implements \CodeIgniter\Router\RouteCollectionInterface
    {
        // Implement required methods here.
    }

그리고 **/app/Config/Services.php**\ 를 수정하여 ``CodeIgniter\Router\RouterCollection`` 대신  ``MyRouter``\ 의 새 인스턴스를 생성합니다.

::

    public static function routes()
    {
        return new \App\Router\MyRouter();
    }

매개 변수 허용
--------------

경우에 따라 인스턴스화 중에 클래스에 설정을 전달하는 옵션이 필요할 수 있습니다.
서비스는 매우 간단한 클래스이므로, 이 작업을 쉽게 수행할 수 있습니다.

좋은 예는 ``renderer`` 서비스입니다. 기본적으로 이 클래스는 ``APPPATH.'views/'``\ 에서 뷰(view)를 찾습니다.
그러나 개발자는 필요에 따라 경로를 변경할 수 있는 옵션을 원하며, 이 클래스는 ``$viewPath``\ 를 생성자 매개 변수(parameter)로 허용합니다.
서비스 방법은 다음과 같습니다.

::

    public static function renderer($viewPath = APPPATH . 'views/')
    {
        return new \CodeIgniter\View\View($viewPath);
    }

생성자 메소드에서 기본 경로를 설정하지만, 사용하고자 하는 경로로 쉽게 변경할 수 있습니다.

::

    $renderer = \Config\Services::renderer('/shared/views');


공유 클래스
-----------

서비스의 단일 인스턴스만 생성하도록 요구해야 하는 경우가 있습니다.
이것은 팩토리 메소드(factory method) 내에서 호출하는 ``getSharedInstance()`` 메소드로 쉽게 처리됩니다.
클래스 내에서 인스턴스가 생성 및 저장되었는지 확인하고 그렇지 않은 경우 새 인스턴스를 만듭니다. 
모든 팩토리 메소드는 단일 매개 변수 ``$getShared = true``\ 를 제공하며 이 규칙을 준수해야 합니다.

::

    class Services
    {
        public static function routes($getShared = false)
        {
            if (! $getShared) {
                return new \CodeIgniter\Router\RouteCollection();
            }

            return static::getSharedInstance('routes');
        }
    }

서비스 검색
-----------------

CodeIgniter는 ``Config\\Services``\ 를 자동으로 검색할 수 있습니다.
php 파일은 정의 된 네임스페이스 내에 있습니다.
이를 통해 모듈 서비스 파일을 간단하게 사용할 수 있습니다.
사용자 정의 서비스 파일을 검색하려면 다음 요구 사항을 충족해야 합니다.

- 네임스페이스 정의는 ``Config\Autoload.php``\ 에 해야 합니다.
- 네임스페이스에 속한 파일은 ``Config\Services.php``\ 에서 찾을 수 있어야 합니다.
- 반드시 ``CodeIgniter\Config\BaseService``\ 를 확장(extend)해야 합니다.

다음의 작은 예시를 살펴보십시오.

루트 디렉토리에 Blog라는 새로운 디렉토리를 만들었다고 상상하십시오.
여기에는 컨트롤러, 모델 등이 포함된 **블로그 모듈**\ 이 있으며 일부 클래스를 서비스로 제공하려고 합니다.
첫 번째 단계는 ``Blog\Config\Services.php``\ 라는 새 파일을 만드는 것입니다.
파일의 골격은 다음과 같습니다.

::

    <?php 
    
    namespace Blog\Config;

    use CodeIgniter\Config\BaseService;

    class Services extends BaseService
    {
        public static function postManager()
        {
            // ...
        }
    }

이제 위에서 설명한대로 이 파일을 사용할 수 있습니다.
컨트롤러에서 게시물 서비스를 가져오려면 프레임워크의 ``Config\Services`` 클래스를 사용하여 서비스를 가져 오면 됩니다.

    $postManager = Config\Services::postManager();

.. note:: 여러 서비스 파일의 메소드 이름이 동일한 경우 첫 번째 발견된 파일의 인스턴스가 반환(return)됩니다.
