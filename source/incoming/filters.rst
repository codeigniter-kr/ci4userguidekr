##################
컨트롤러 필터
##################

.. contents::
    :local:
    :depth: 2

컨트롤러 필터를 사용하면 컨트롤러 실행 전후에 작업을 수행할 수 있습니다.
:doc:`이벤트 </extending/events>`\ 와 달리 필터를 적용할 특정 URI를 선택할 수 있습니다.
수신(Incoming) 필터는 요청을 수정하는 반면 사후(after)필터는 응답에 대해 작동하고 데이터를 수정할 수 있기 때문에 많은 유연성과 성능을 제공합니다.
필터로 수행할 수있는 일반적인 예는 다음과 같습니다:

* 수신 요청(request)에 대한 CSRF 보호
* 역할(role)에 따른 사이트 영역 제한
* 특정 엔드 포인트의 속도 제한
* "유지 보수 또는 서버 점검" 페이지 표시
* 자동 컨텐츠 협상(content negotiation)
* and more..

*****************
필터 만들기
*****************

필터는 ``CodeIgniter\Filters\FilterInterface``\ 를 구현(implement)하는 간단한 클래스입니다.
두 개의 메소드 ``before()`` 와 ``after()``\ 를 가지고 있으며, 컨트롤러 전후에 각각 실행됩니다.
클래스에는 두 메소드가 모두 포함되어야하지만 필요하지 않은 경우 메소드를 비워둘 수 있습니다.
스켈레톤 필터 클래스는 다음과 같습니다.

::

    <?php 
    
    namespace App\Filters;

    use CodeIgniter\HTTP\RequestInterface;
    use CodeIgniter\HTTP\ResponseInterface;
    use CodeIgniter\Filters\FilterInterface;

    class MyFilter implements FilterInterface
    {
        public function before(RequestInterface $request, $arguments = null)
        {
            // Do something here
        }

        public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
        {
            // Do something here
        }
    }

사전(Before) 필터
======================

모든 필터는 ``$request`` 오브젝트를 반환할 수 있으며, 컨트롤러가 실행될 때 변경 사항을 적용할 수 있도록 현재 요청(Request)을 대체합니다.

컨트롤러가 실행되기 전에 필터가 실행되기 때문에 먼저 컨트롤러의 작업을 중지하거나, 특정 필터 이후의 필터 실행을 중지할 필요가 있습니다.
**비어 있지 않은** 결과를 반환하면 쉽게 이 작업을 수행할 수 있습니다.
이전 필터가 빈 결과를 반환하면 컨트롤러 작업 또는 이후 필터가 계속 실행됩니다.
``Request`` 인스턴스의 경우는 비어 있지 않은 결과 규칙의 예외입니다.
before 필터에서 반환하면 실행이 중지되지 않고 현재 ``$request`` 개체만 교체됩니다.

아래 예는 리디렉션을 수행합니다.

::

    public function before(RequestInterface $request, $arguments = null)
    {
        $auth = service('auth');

        if (! $auth->isLoggedIn())
        {
            return redirect('login');
        }
    }

``응답(Response)`` 인스턴스가 리턴되면 응답이 클라이언트로 전송되고 컨트롤러 실행이 중지됩니다.
API 요청에 대한 속도 제한을 구현하는데 유용하며, 이에 대한 예는 :doc:`Throttler </libraries/throttler>`\ 를 참조하십시오.

사후(After) 필터
====================

사후(After) 필터는 ``$response`` 객체만 반환할 수 있으며, 컨트롤러 실행을 중지할 수 없다는 점을 제외하면 사전(After) 필터와 거의 동일합니다.
이를 통해 최종 출력을 수정하거나, 최종 출력으로 무언가를 수행할 수 있습니다.
이를 이용하여 특정 보안 헤더가 올바른 방식으로 설정되도록 하거나, 최종 출력을 캐시하거나, 나쁜(bad) 단어 필터로 최종 출력을 필터링하는 데 사용할 수 있습니다.

*******************
필터 구성
*******************

필터를 만든 후에는 실행시기를 구성해야 하며, 이 작업은 ``app/Config/Filters``\ 에서 이루어집니다.
이 파일에는 필터가 실행될 때 구성할 수 있는 네 가지 속성이 포함되어 있습니다.

$aliases
========

``$aliases`` 배열은 하나 이상의 정규화된 클래스 이름을 실행될 간단한 필터 이름으로 연결하는 데 사용합니다.

::

    public $aliases = [
        'csrf' => \CodeIgniter\Filters\CSRF::class,
    ];

별명은 필수이며 이후 전체 클래스 이름을 사용하려고 하면 시스템에서 오류가 발생합니다.
이런 식으로 정의하면 필터에 사용되는 클래스를 간단하게 전환할 수 있습니다.
필터의 클래스만 변경하면 전환 완료되므로, 다른 인증 시스템으로 변경해야할 때 유용합니다.

여러 필터를 하나의 별칭으로 결합하여 복잡한 필터 세트를 간단하게 적용할 수 있습니다.

::

    public $aliases = [
        'apiPrep' => [
            \App\Filters\Negotiate::class,
            \App\Filters\ApiAuth::class,
        ]
    ];

필요한만큼 별칭을 정의해야 합니다.

$globals
========

두 번째 섹션에서는 프레임워크의 모든 요청에 적용해야하는 필터를 정의할 수 있습니다.
모든 요청에 너무 많은 작업을 적용하는 것은 성능에 영향을 미칠 수 있으므로 여기에 얼마나 많은 것을 사용할지 주의해야 합니다.
사전(before) 또는 사후(after) 배열에 별칭을 추가하여 필터를 지정할 수 있습니다.

::

    public $globals = [
        'before' => [
            'csrf',
        ],
        'after'  => []
    ];

모든 요청에 필터를 적용하고 싶을 때도 있지만, 몇 개만 남겨두어야 할 경우도 있습니다.
한 가지 일반적인 예는 CSRF 보호 필터에 몇 개의 URI를 제외하여 제3자 웹 사이트의 요청이 하나 또는 두 개의 특정 URI를 도달할 수 있도록 하고 나머지 URI는 보호해야 하는 경우입니다.
이렇게 하려면 'except' 키가 있는 배열을 별칭 과 함께 값으로 일치시킬 uri를 추가하십시오.

::

    public $globals = [
        'before' => [
            'csrf' => ['except' => 'api/*'],
        ],
        'after'  => [],
    ];

필터 설정에서 URI를 사용할 수 있는 모든 장소, 정규 표현식을 사용하거나 이 예에서와 같이 와일드 카드 별표(*)를 사용하여 그 이후의 모든 문자를 일치시킬 수 있습니다.
다음 예는 ``api/``\ 로 시작하는 URL은 CSRF 보호에서 제외되지만 양식(Form)은 모두 보호됩니다.
여러 개의 URI를 지정해야 하는 경우 URI 패턴 배열을 사용할 수 있습니다.

::

    public $globals = [
        'before' => [
            'csrf' => ['except' => ['foo/*', 'bar/*']],
        ],
        'after'  => [],
    ];

$methods
========

POST, GET, PUT등과 같은 특정 HTTP 메소드의 모든 요청에 필터를 적용 할 수 있습니다.
이 배열에서는 메소드 이름을 소문자로 지정합니다.
값은 실행할 필터 배열입니다. 
``$globals`` 나 ``$filters`` 속성과 달리 이 속성은 이전(before) 필터처럼 실행됩니다.

::

    public $methods = [
        'post' => ['foo', 'bar'],
        'get'  => ['baz'],
    ]

표준 HTTP 메소드 외에도 'cli'\ 와 'ajax' 두 가지 특수한 경우도 지원하며, 'cli'는 커맨드 라인에서 실행 된 모든 요청에 적용되고 'ajax'는 모든 AJAX 요청에 적용됩니다.

.. note:: AJAX 요청은 ``X-Requested-With`` 헤더에 의존하며, JavaScript를 통한 XHR 요청은 경우에 따라 기본적으로 헤더가 전송되지 않습니다. (예: fetch). 
    이를 해결하는 방법에 대해서는 :doc:`AJAX 요청(Requests) </general/ajax>`\ 을 참조하십시오.

$filters
========

이 속성은 필터 별칭(alias)의 배열입니다. 
각 별명(alias)에 대해 필터링해야 하는 URI 패턴 목록이 포함된 전후 배열을 지정할 수 있습니다.

::

    public filters = [
        'foo' => ['before' => ['admin/*'], 'after' => ['users/*']],
        'bar' => ['before' => ['api/*', 'admin/*']],
    ];

필터 인수(arguments)
=======================

라우터에 필터를 구성할 때 필터에 필요한 추가 인수를 전달할 수 있습니다.

::

    $routes->add('users/delete/(:segment)', 'AdminController::index', ['filter' => 'admin-auth:dual,noreturn']);

이 예에서 ``['dual', 'noreturn']`` 배열은 필터의 ``before()``\ 와 ``after()`` 메소드에 ``$arguments``\ 로 전달됩니다.

****************
제공되는 필터
****************

CodeIgniter4에 3개의 필터가 번들로 제공됩니다: ``Honeypot``, ``CSRF``, ``DebugToolbar``

.. note:: 필터는 구성 파일에 정의되어 선언된 순서대로 실행되지만, ``DebugToolbar``\ 는 다른 필터에서 일어나는 모든 일을 등록해야 하므로 선언된 순서와 상관없이 항상 마지막에 실행됩니다.
