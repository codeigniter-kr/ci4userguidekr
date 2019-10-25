##################
컨트롤러 필터
##################

.. contents::
    :local:
    :depth: 2

컨트롤러 필터를 사용하면 컨트롤러 실행 전후에 작업을 수행할 수 있습니다.
:doc:`이벤트 </extending/events>`\ 와 달리 응용 프로그램에서 필터를 적용할 URI를 쉽게 선택할 수 있습니다.
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

    <?php namespace App\Filters;

    use CodeIgniter\HTTP\RequestInterface;
    use CodeIgniter\HTTP\ResponseInterface;
    use CodeIgniter\Filters\FilterInterface;

    class MyFilter implements FilterInterface
    {
        public function before(RequestInterface $request)
        {
            // Do something here
        }

        //--------------------------------------------------------------------

        public function after(RequestInterface $request, ResponseInterface $response)
        {
            // Do something here
        }
    }

사전(Before) 필터
==============

모든 필터는 ``$request`` 오브젝트를 반환할 수 있으며, 컨트롤러가 실행될 때 변경 사항을 적용할 수 있도록 현재 요청(Request)을 대체합니다.

가끔 사전 필터가 실행되기 전에 컨트롤러의 작업을 중지할 필요가 있습니다.
요청 오브젝트가 아닌 것을 전달하면 이것을 수행 할 수 있습니다.
아래 예는 리디렉션을 수행합니다.

::

    public function before(RequestInterface $request)
    {
        $auth = service('auth');

        if (! $auth->isLoggedIn())
        {
            return redirect('login');
        }
    }

응답(Response) 인스턴스가 리턴되면 응답이 클라이언트로 전송되고 컨트롤러 실행이 중지됩니다.
이는 요금에 따른 API 제한을 구현하는데 유용할 수 있다.
**app/Filters/Throttle.php** 예제를 참조하세요.

사후(After) 필터
====================

사후(After) 필터는 ``$response`` 객체만 반환할 수 있으며, 컨트롤러 실행을 중지할 수 없다는 점을 제외하면 사전(After) 필터와 거의 동일합니다.
이를 통해 최종 출력을 수정하거나, 최종 출력으로 무언가를 수행할 수 있습니다.
이를 이용하여 특정 보안 헤더가 올바른 방식으로 설정되도록 하거나, 최종 출력을 캐시하거나, 나쁜(bad) 단어 필터로 최종 출력을 필터링하는 데 사용할 수 있습니다.

*******************
필터 구성
*******************

Once you've created your filters, you need to configure when they get run. 
This is done in ``app/Config/Filters.php``.
This file contains four properties that allow you to configure exactly when the filters run.

$aliases
========

The ``$aliases`` array is used to associate a simple name with one or more fully-qualified class names that are the
filters to run::

    public $aliases = [
        'csrf' => \CodeIgniter\Filters\CSRF::class
    ];

Aliases are mandatory and if you try to use a full class name later, the system will throw an error. Defining them
in this way makes it simple to switch out the class used. Great for when you decided you need to change to a
different authentication system since you only change the filter's class and you're done.

You can combine multiple filters into one alias, making complex sets of filters simple to apply::

    public $aliases = [
        'apiPrep' => [
            \App\Filters\Negotiate::class,
            \App\Filters\ApiAuth::class
        ]
    ];

You should define as many aliases as you need.

$globals
========

The second section allows you to define any filters that should be applied to every request made by the framework.
You should take care with how many you use here, since it could have performance implications to have too many
run on every request. Filters can be specified by adding their alias to either the before or after array::

	public $globals = [
		'before' => [
			'csrf'
		],
		'after'  => []
	];

There are times where you want to apply a filter to almost every request, but have a few that should be left alone.
One common example is if you need to exclude a few URI's from the CSRF protection filter to allow requests from
third-party websites to hit one or two specific URI's, while keeping the rest of them protected. To do this, add
an array with the 'except' key and a uri to match as the value alongside the alias::

	public $globals = [
		'before' => [
			'csrf' => ['except' => 'api/*']
		],
		'after'  => []
	];

Any place you can use a URI in the filter settings, you can use a regular expression or, like in this example, use
an asterisk for a wildcard that will match all characters after that. In this example, any URL's starting with ``api/``
would be exempted from CSRF protection, but the site's forms would all be protected. If you need to specify multiple
URI's you can use an array of URI patterns::

	public $globals = [
		'before' => [
			'csrf' => ['except' => ['foo/*', 'bar/*']]
		],
		'after'  => []
	];

$methods
========

You can apply filters to all requests of a certain HTTP method, like POST, GET, PUT, etc. In this array, you would
specify the method name in lowercase. It's value would be an array of filters to run. Unlike the ``$globals`` or the
``$filters`` properties, these will only run as before filters::

    public $methods = [
        'post' => ['foo', 'bar'],
        'get'  => ['baz']
    ]

In addition to the standard HTTP methods, this also supports two special cases: 'cli', and 'ajax'. The names are
self-explanatory here, but 'cli' would apply to all requests that were run from the command line, while 'ajax'
would apply to every AJAX request.

$filters
========

This property is an array of filter aliases. For each alias, you can specify before and after arrays that contain
a list of URI patterns that filter should apply to::

    public filters = [
        'foo' => ['before' => ['admin/*'], 'after' => ['users/*']],
        'bar' => ['before' => ['api/*', 'admin/*']]
    ];

****************
Provided Filters
****************

Three filters are bundled with CodeIgniter4: Honeypot, Security, and DebugToolbar.
