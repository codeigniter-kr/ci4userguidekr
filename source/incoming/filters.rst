##################
Controller Filters
##################

.. contents::
    :local:
    :depth: 2

Controller Filters allow you to perform actions either before or after the controllers execute. Unlike :doc:`events </extending/events>`,
you can very simply choose which URI's in your application have the filters applied to them. Incoming filters may
modify the Request, while after filters can act on and even modify the Response, allowing for a lot of flexibility
and power. Some common examples of tasks that might be performed with filters are:
컨트롤러 필터를 사용하면 컨트롤러가 실행되기 전이나 후에 작업을 수행 할 수 있습니다. :doc:`events </extending/events>` 와 달리 , 애플리케이션에서 필터가 적용된 URI를 매우 간단하게 선택할 수 있습니다. 들어오는 필터는 요청을 수정할 수 있으며 필터는 응답을 수정하고 응답을 수정하여 많은 유연성과 성능을 허용합니다. 필터를 사용하여 수행 할 수있는 작업의 일반적인 예는 다음과 같습니다.

* Performing CSRF protection on the incoming requests
  들어오는 요청에 대한 CSRF 보호 수행
* Restricting areas of your site based upon their Role
  역할에 따라 사이트 영역 제한
* Perform rate limiting on certain endpoints
  특정 끝점에서 속도 제한 수행
* Display a "Down for Maintenance" page
  "유지 보수를위한 다운"페이지 표시
* Perform automatic content negotiation
  자동 콘텐츠 협상 수행
* and more..

*****************
Creating a Filter
*****************

Filters are simple classes that implement ``CodeIgniter\Filters\FilterInterface``. 
They contain two methods: ``before()`` and ``after()`` which hold the code that 
will run before and after the controller respectively. Your class must contain both methods 
but may leave the methods empty if they are not needed. A skeleton filter class looks like
필터는 구현하는 간단한 클래스입니다 CodeIgniter\Filters\FilterInterface. 그들은 두 가지 방법을 포함 : before()및 after()직전 각각 컨트롤러 후 실행되는 코드를 누르고 있습니다. 클래스에는 두 가지 메소드가 모두 포함되어야하지만 필요하지 않은 경우 메소드를 비워 둘 수 있습니다. 스켈레톤 필터 클래스는 다음과 같습니다.

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

Before Filters
==============

From any filter, you can return the ``$request`` object and it will replace the current Request, allowing you
to make changes that will still be present when the controller executes.
모든 필터에서 $request객체를 반환 할 수 있으며 현재 요청을 대체하므로 컨트롤러가 실행될 때 변경 사항을 적용 할 수 있습니다.

Since before filters are executed prior to your controller being executed, you may at times want to stop the
actions in the controller from happening. You can do this by passing back anything that is not the request object.
This is typically used to peform redirects, like in this example
컨트롤러가 실행되기 전에 필터가 실행되기 전에 컨트롤러의 작업이 중단되는 것을 원할 때가 있습니다. 요청 객체가 아닌 것을 모두 돌려 주면됩니다. 일반적으로이 예와 같이 리디렉션을 수행하는 데 사용됩니다.

::

    public function before(RequestInterface $request)
    {
        $auth = service('auth');

        if (! $auth->isLoggedIn())
        {
            return redirect('login');
        }
    }

If a Response instance is returned, the Response will be sent back to the client and script execution will stop.
This can be useful for implementing rate limiting for API's. See **application/Filters/Throttle.php** for an
example.
Response 인스턴스가 반환되면 응답이 클라이언트에 보내지고 스크립트 실행이 중지됩니다. 이는 API의 속도 제한을 구현하는 데 유용 할 수 있습니다. 예제는 application / Filters / Throttle.php 를 참고하십시오 .

After Filters
=============

After filters are nearly identical to before filters, except that you can only return the ``$response`` object,
and you cannot stop script execution. This does allow you to modify the final output, or simply do something with
the final output. This could be used to ensure certain security headers were set the correct way, or to cache
the final output, or even to filter the final output with a bad words filter.
After 필터는 $response객체를 반환 할 수 있고 스크립트 실행을 중지 할 수 없다는 점을 제외하고는 필터 이전과 거의 동일합니다 . 이렇게하면 최종 출력을 수정하거나 최종 출력으로 무언가를 수행 할 수 있습니다. 이것은 특정 보안 헤더가 올바른 방법으로 설정되었는지 확인하거나 최종 출력을 캐싱하거나 나쁜 단어 필터로 최종 출력을 필터링하는 데 사용될 수 있습니다.

===================
Configuring Filters
===================

Once you've created your filters, you need to configure when they get run. This is done in ``application/Config/Filters.php``.
This file contains four properties that allow you to configure exactly when the filters run.
필터를 만든 후에는 언제 실행해야하는지 구성해야합니다. 이것은에서 이루어집니다 application/Config/Filters.php. 이 파일에는 필터 실행시기를 정확하게 구성 할 수있는 네 가지 등록 정보가 들어 있습니다.

$aliases
========

The ``$aliases`` array is used to associate a simple name with one or more fully-qualified class names that are the
filters to run
이 $aliases배열은 실행될 필터 인 하나 이상의 정규화 된 클래스 이름과 간단한 이름을 연결하는 데 사용됩니다.

::

    public $aliases = [
        'csrf' => \App\Filters\CSRF::class
    ];

Aliases are mandatory and if you try to use a full class name later, the system will throw an error. Defining them
in this way makes it simple to switch out the class used. Great for when you decided you need to change to a
different authentication system since you only change the filter's class and you're done.
별칭은 필수이며 나중에 전체 클래스 이름을 사용하려고하면 시스템에서 오류가 발생합니다. 이러한 방식으로 정의하면 사용 된 클래스를 쉽게 전환 할 수 있습니다. 필터 클래스 만 변경하면 완료되면 다른 인증 시스템으로 변경해야한다고 결정할 때 유용합니다.

You can combine multiple filters into one alias, making complex sets of filters simple to apply
여러 필터를 하나의 별칭으로 결합하여 복잡한 필터 집합을 적용하기 간단하게 만들 수 있습니다.

::

    public $aliases = [
        'apiPrep' => [
            \App\Filters\Negotiate::class,
            \App\Filters\ApiAuth::class
        ]
    ];

You should define as many aliases as you need.
필요한만큼 별칭을 정의해야합니다.

$globals
========

The second section allows you to define any filters that should be applied to every request made by the framework.
You should take care with how many you use here, since it could have performance implications to have too many
run on every request. Filters can be specified by adding their alias to either the before or after array
두 번째 섹션에서는 프레임 워크에 의해 만들어진 모든 요청에 적용되어야하는 필터를 정의 할 수 있습니다. 모든 요청에 대해 너무 많은 실행을하는 것이 성능에 영향을 줄 수 있으므로 여기에서 사용하는 사용자 수에주의해야합니다. before 또는 after 배열에 별칭을 추가하여 필터를 지정할 수 있습니다.

::

	public $globals = [
		'before' => [
			'csrf'
		],
		'after'  => []
	];

There are times where you want to apply a filter to almost every request, but have a few that should be left alone.
One common example is if you need to exclude a few URI's from the CSRF protection filter to allow requests from
third-party websites to hit one or two specific URI's, while keeping the rest of them protected. To do this, add
an array with the 'except' key and a uri to match as the value alongside the alias
거의 모든 요청에 필터를 적용하려는 경우가 있지만 남겨 두어야 할 필터가 몇 가지 있습니다. 한 가지 공통적 인 예는 타사 웹 사이트의 요청이 하나 또는 두 개의 특정 URI를 공격 할 수 있도록 허용하기 위해 CSRF 보호 필터에서 몇 가지 URI를 제외해야하지만 나머지는 보호해야합니다. 이렇게하려면 'except'키와 별칭과 함께 값으로 일치시킬 uri가있는 배열을 추가하십시오.

::

	public $globals = [
		'before' => [
			'csrf' => ['except' => 'api/*']
		],
		'after'  => []
	];

Any place you can use a URI in the filter settings, you can use a regular expression or, like in this example, use
an asterisk for a wildcard that will match all characters after that. In this example, any URL's starting with ``api/``
would be exempted from CSRF protection, but the site's forms would all be protected. If you need to specify multiple
URI's you can use an array of URI patterns
필터 설정에서 URI를 사용할 수있는 모든 곳에서 정규식을 사용할 수 있습니다.이 예와 같이 모든 문자와 일치하는 와일드 카드에 별표를 사용합니다. 이 예에서 시작하는 모든 URL api/ 은 CSRF 보호에서 면제되지만 사이트의 양식은 모두 보호됩니다. 다중 URI를 지정해야하는 경우 URI 패턴의 배열을 사용할 수 있습니다.

::

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
``$filters`` properties, these will only run as before filters
POST, GET, PUT 등과 같은 특정 HTTP 메소드의 모든 요청에 필터를 적용 할 수 있습니다.이 배열에서는 메소드 이름을 소문자로 지정합니다. 값은 실행할 필터 배열입니다. $globals또는 $filters속성 과 달리 이전 필터로만 실행됩니다.

::

    public $methods = [
        'post' => ['foo', 'bar'],
        'get'  => ['baz']
    ]

In addition to the standard HTTP methods, this also supports two special cases: 'cli', and 'ajax'. The names are
self-explanatory here, but 'cli' would apply to all requests that were run from the command line, while 'ajax'
would apply to every AJAX request.
표준 HTTP 메소드 외에도 'cli'및 'ajax'의 두 가지 특별한 경우도 지원합니다. 여기서 이름은 자명하지만 '명령 줄에서 실행 된 모든 요청에는'cli '가 적용되고 모든 AJAX 요청에는'ajax '가 적용됩니다.

$filters
========

This property is an array of filter aliases. For each alias you can specify before and after arrays that contain
a list of URI patterns that filter should apply to
이 속성은 필터 별칭의 배열입니다. 각 별칭에 대해 필터가 적용되어야하는 URI 패턴 목록을 포함하는 배열 앞뒤에 지정할 수 있습니다.

::

    public filters = [
        'foo' => ['before' => ['admin/*'], 'after' => ['users/*']],
        'bar' => ['before' => ['api/*', 'admin/*']]
    ];

****************
Provided Filters
****************

Three filters are bundled with CodeIgniter4: Honeypot, Security, and Throttler
