###########
URI Routing
###########

.. contents::
    :local:
    :depth: 2

Typically there is a one-to-one relationship between a URL string and its corresponding
controller class/method. The segments in a URI normally follow this pattern
일반적으로 URL 문자열과 해당 컨트롤러 class/method 간에 일대일 관계가 있습니다. URI의 세그먼트는 일반적으로 다음 패턴을 따릅니다.

::

    example.com/class/function/id/

In some instances, however, you may want to remap this relationship so that a different
class/method can be called instead of the one corresponding to the URL.
그러나 어떤 경우에는 URL에 해당하는 클래스 / 메소드 대신 다른 클래스 / 메소드를 호출 할 수 있도록이 관계를 다시 매핑해야 할 수도 있습니다.

For example, let’s say you want your URLs to have this prototype
예를 들어 URL에이 프로토 타입이 있어야한다고 가정 해 보겠습니다.

::

    example.com/product/1/
    example.com/product/2/
    example.com/product/3/
    example.com/product/4/

Normally the second segment of the URL is reserved for the method name, but in the example
above it instead has a product ID. To overcome this, CodeIgniter allows you to remap the URI handler.
일반적으로 URL의 두 번째 세그먼트는 메서드 이름으로 예약되어 있지만 위 예제에서는 대신 제품 ID가 있습니다. 이를 극복하기 위해 CodeIgniter는 URI 핸들러를 다시 매핑 할 수있게 해줍니다.

Setting your own routing rules
==============================

Routing rules are defined in the **app/config/Routes.php** file. In it you'll see that
it creates an instance of the RouteCollection class that permits you to specify your own routing criteria.
Routes can be specified using placeholders or Regular Expressions.
라우팅 규칙은 **app/config/Routes.php** 파일에 정의되어 있습니다. 이 클래스에서 RouteCollection 클래스의 인스턴스를 생성하여 자신 만의 라우팅 기준을 지정할 수 있음을 알 수 있습니다. 경로는 자리 표시 자나 정규 표현식을 사용하여 지정할 수 있습니다.

A route simply takes the URI on the left, and maps it to the controller and method on the right,
along with any parameters that should be passed to the controller. The controller and method should
be listed in the same way that you would use a static method, by separating the fully-namespaced class
and its method with a double-colon, like ``Users::list``.  If that method requires parameters to be
passed to it, then they would be listed after the method name, separated by forward-slashes
라우트는 단순히 왼쪽의 URI를 취하여 컨트롤러에 전달되어야하는 매개 변수와 함께 오른쪽의 컨트롤러 및 메소드에 맵핑합니다. 컨트롤러와 메소드는 정적 메소드를 사용하는 것과 같은 방법으로 나열되어야하며, 완전히 네임 스페이스가 지정된 클래스와 그 메소드를 다음과 같이 이중 콜론으로 분리해야합니다 ``Users::list``. 이 메소드가 매개 변수를 전달해야하는 경우에는 메소드 이름 다음에 슬래시로 구분하여 나열됩니다.

::

	// Calls the $Users->list()
	Users::list
	// Calls $Users->list(1, 23)
	Users::list/1/23

Placeholders
============

A typical route might look something like this
일반적인 경로는 다음과 같습니다.

::

    $routes->add('product/(:num)', 'App\Catalog::productLookup');

In a route, the first parameter contains the URI to be matched, while the second parameter
contains the destination it should be re-routed to. In the above example, if the literal word
"product" is found in the first segment of the URL, and a number is found in the second segment,
the "App\Catalog" class and the "productLookup" method are used instead.
경로에서 첫 번째 매개 변수는 일치시킬 URI를 포함하고 두 번째 매개 변수는 경로를 다시 지정해야하는 대상을 포함합니다. 위의 예에서 "product"라는 리터럴 단어가 URL의 첫 번째 세그먼트에 있고 두 번째 세그먼트에 숫자가있는 경우 "AppCatalog"클래스와 "productLookup"메서드가 대신 사용됩니다.

Placeholders are simply strings that represent a Regular Expression pattern. During the routing
process, these placeholders are replaced with the value of the Regular Expression. They are primarily
used for readability.
자리 표시자는 정규식 패턴을 나타내는 문자열입니다. 라우팅 프로세스 중에 이러한 자리 표시자는 정규 표현식의 값으로 대체됩니다. 이들은 주로 가독성을 위해 사용됩니다.

The following placeholders are available for you to use in your routes:
다음 자리 표시자는 경로에서 사용할 수 있습니다.

* **(:any)** will match all characters from that point to the end of the URI. This may include multiple URI segments.
			 해당 지점에서 URI 끝까지의 모든 문자를 일치시킵니다. 여기에는 여러 개의 URI 세그먼트가 포함될 수 있습니다.
* **(:segment)** will match any character except for a forward slash (/) restricting the result to a single segment.
				 결과를 단일 세그먼트로 제한하는 슬래시 (/)를 제외한 모든 문자와 일치합니다.
* **(:num)** will match any integer.
			 정수와 일치합니다.
* **(:alpha)** will match any string of alphabetic characters
			   모든 영문자 문자열과 일치합니다
* **(:alphanum)** will match any string of alphabetic characters or integers, or any combination of the two.
				  영문자 또는 정수의 모든 문자열 또는이 둘의 조합을 일치시킵니다.
* **(:hash)** is the same as **:segment**, but can be used to easily see which routes use hashed ids (see the :doc:`Model </models/model>` docs).
			  세그먼트 와 동일 하지만 해시 된 ID를 사용하는 경로를 쉽게 볼 수 있습니다 ( :doc:`Model </models/model>` 문서 참조 ).

.. note:: **{locale}** cannot be used as a placeholder or other part of the route, as it is reserved for use
    in :doc:`localization </outgoing/localization>`.
    {locale} 은 현지화 용도로 예약되어 있으므로 자리 표시 자 또는 경로의 다른 부분으로 사용할 수 없습니다 .

Examples
========

Here are a few basic routing examples
다음은 몇 가지 기본 라우팅 예입니다.

::

	$routes->add('journals', 'App\Blogs');

A URL containing the word "journals" in the first segment will be remapped to the "App\Blogs" class,
and the default method, which is usually ``index()``
첫 번째 세그먼트에 "저널"이라는 단어가 포함 된 URL은 "AppBlogs"클래스에 매핑되고 기본 방법은 일반적으로 index()다음과 같습니다.

::

	$routes->add('blog/joe', 'Blogs::users/34');

A URL containing the segments "blog/joe" will be remapped to the “\Blogs” class and the “users” method.
The ID will be set to “34”
"blog / joe"세그먼트를 포함하는 URL은 "Blogs"클래스와 "users"메소드로 다시 매핑됩니다. ID는 "34"로 설정됩니다.

::

	$routes->add('product/(:any)', 'Catalog::productLookup');

A URL with “product” as the first segment, and anything in the second will be remapped to the “\Catalog” class
and the “productLookup” method
“product”을 첫 번째 세그먼트로 사용하고 두 번째 항목을 모두 “\Catalog” 클래스 및 "productLookup" 메소드로 다시 매핑합니다.

::

	$routes->add('product/(:num)', 'Catalog::productLookupByID/$1';

A URL with “product” as the first segment, and a number in the second will be remapped to the “\Catalog” class
and the “productLookupByID” method passing in the match as a variable to the method.
“product” 을 첫 번째 세그먼트로 사용하고 두 번째 숫자를 URL로 매핑하면 “\Catalog” 클래스와 "productLookupByID" 메서드가 메서드에서 변수로 전달됩니다.

.. important:: While the ``add()`` method is convenient, it is recommended to always use the HTTP-verb-based
    routes, described below, as it is more secure. It will also provide a slight performance increase, since
    only routes that match the current request method are stored, resulting in less routes to scan through
    when trying to find a match.
    이 add()방법이 편리 하기는하지만 아래에 설명 된 HTTP 동사를 기반으로하는 경로는 항상보다 안전하기 때문에 항상 사용하는 것이 좋습니다. 현재 요청 방법과 일치하는 경로 만 저장되므로 일치하는 항목을 찾으려고 할 때 검색 할 경로가 적어지기 때문에 성능이 약간 향상됩니다.

Custom Placeholders
===================

You can create your own placeholders that can be used in your routes file to fully customize the experience
and readability.
경로 파일에서 사용할 수있는 고유 한 자리 표시자를 만들어 경험과 가독성을 완전히 사용자 정의 할 수 있습니다.

You add new placeholders with the ``addPlaceholder`` method. The first parameter is the string to be used as
the placeholder. The second parameter is the Regular Expression pattern it should be replaced with.
This must be called before you add the route
addPlaceholder메서드를 사용하여 새 자리 표시자를 추가합니다 . 첫 번째 매개 변수는 자리 표시 자로 사용할 문자열입니다. 두 번째 매개 변수는 정규 표현식 패턴으로 대체해야합니다. 경로를 추가하기 전에이를 호출해야합니다.

::

	$routes->addPlaceholder('uuid', '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}');
	$routes->add('users/(:uuid)', 'Users::show/$1');

정규 표현식
===================

If you prefer you can use regular expressions to define your routing rules. Any valid regular expression
is allowed, as are back-references.
원하는 경우 정규식을 사용하여 라우팅 규칙을 정의 할 수 있습니다. 역 참조와 마찬가지로 유효한 모든 정규 표현식이 허용됩니다.

.. important:: Note: If you use back-references you must use the dollar syntax rather than the double backslash syntax.
    A typical RegEx route might look something like this
    역 참조를 사용하는 경우 이중 백 슬래시 구문 대신 달러 구문을 사용해야합니다. 일반적인 RegEx 경로는 다음과 같습니다.
    
    ::

	$routes->add('products/([a-z]+)/(\d+)', '$1::id_$2');

In the above example, a URI similar to products/shirts/123 would instead call the “\Shirts” controller class
and the “id_123” method.
위의 예제에서 products / shirts / 123과 비슷한 URI는 대신 "Shirts"컨트롤러 클래스와 "id_123"메서드를 호출합니다.

With regular expressions, you can also catch a segment containing a forward slash (‘/’), which would usually
represent the delimiter between multiple segments.
정규식을 사용하면 슬래시 ( '/')가 포함 된 세그먼트를 찾을 수 있습니다.이 세그먼트는 일반적으로 여러 세그먼트 사이의 구분 기호를 나타냅니다.

For example, if a user accesses a password protected area of your web application and you wish to be able to
redirect them back to the same page after they log in, you may find this example useful
예를 들어, 사용자가 웹 응용 프로그램의 암호로 보호 된 영역에 액세스하고 로그인 한 후에 다시 같은 페이지로 리디렉션하려는 경우이 예가 유용 할 수 있습니다.

::

	$routes->add('login/(.+)', 'Auth::login/$1');

For those of you who don’t know regular expressions and want to learn more about them,
`regular-expressions.info <http://www.regular-expressions.info/>`_ might be a good starting point.
정기적 인 표현을 모르고 더 많은 것을 배우고 자하는 사람들을 위해 regular-expressions.info 가 좋은 출발점이 될 수 있습니다.

.. important:: Note: You can also mix and match wildcards with regular expressions.
					 와일드 카드를 정규식과 혼합하여 사용할 수도 있습니다.

Closures
========

You can use an anonymous function, or Closure, as the destination that a route maps to. This function will be
executed when the user visits that URI. This is handy for quickly executing small tasks, or even just showing
a simple view
익명 함수 또는 Closure를 경로가 매핑되는 대상으로 사용할 수 있습니다. 이 함수는 사용자가 해당 URI를 방문 할 때 실행됩니다. 작은 작업을 신속하게 실행하거나 간단한보기 만 표시하는 경우에 유용합니다.

::

    $routes->add('feed', function()
    {
        $rss = new RSSFeeder();
        return $rss->feed('general');
    });

Mapping multiple routes
=======================

While the add() method is simple to use, it is often handier to work with multiple routes at once, using
the ``map()`` method. Instead of calling the ``add()`` method for each route that you need to add, you can
define an array of routes and then pass it as the first parameter to the ``map()`` method
add () 메소드는 사용하기 쉽지만, map()메소드를 사용하여 한 번에 여러 라우트로 작업하는 것이 더 편리합니다 . add()추가해야하는 각 경로에 대해 메소드를 호출하는 대신 경로 배열을 정의한 다음 첫 번째 매개 변수로 map () 메소드에 전달할 수 있습니다.

::

	$routes = [];
	$routes['product/(:num)']      = 'Catalog::productLookupById';
	$routes['product/(:alphanum)'] = 'Catalog::productLookupByName';

	$collection->map($routes);

Redirecting Routes
==================

Any site that lives long enough is bound to have pages that move. You can specify routes that should redirect
to other routes with the ``addRedirect()`` method. The first parameter is the URI pattern for the old route. The
second parameter is either the new URI to redirect to, or the name of a named route. The third parameter is
the HTTP status code that should be sent along with the redirect. The default value is ``302`` which is a temporary
redirect and is recommended in most cases
충분히 오래 살고있는 사이트는 이동하는 페이지가 있어야합니다. addRedirect()메소드를 사용하여 다른 경로로 리디렉션해야하는 경로를 지정할 수 있습니다 . 첫 번째 매개 변수는 이전 경로의 URI 패턴입니다. 두 번째 매개 변수는 리디렉션 할 새 URI 또는 명명 된 경로의 이름입니다. 세 번째 매개 변수는 리디렉션과 함께 보내야하는 HTTP 상태 코드입니다. 기본값은 302임시 리디렉션이며 대부분의 경우 권장됩니다.

::

    $routes->add('users/profile', 'Users::profile', ['as' => 'profile']);

    // Redirect to a named route
    $routes->addRedirect('users/about', 'profile');
    // Redirect to a URI
    $routes->addRedirect('users/about', 'users/profile');

If a redirect route is matched during a page load, the user will be immediately redirected to the new page before a
controller can be loaded.
페이지로드 중에 리디렉션 경로가 일치하면 컨트롤러를로드하기 전에 사용자가 새 페이지로 즉시 리디렉션됩니다.

Grouping Routes
===============

You can group your routes under a common name with the ``group()`` method. The group name becomes a segment that
appears prior to the routes defined inside of the group. This allows you to reduce the typing needed to build out an
extensive set of routes that all share the opening string, like when building an admin area
group()메소드를 사용하여 경로를 공통 이름으로 그룹화 할 수 있습니다 . 그룹 이름은 그룹 내부에 정의 된 경로보다 먼저 표시되는 세그먼트가됩니다. 이렇게하면 관리 영역을 빌드 할 때와 같이 모두 여는 문자열을 공유하는 광범위한 라우트 세트를 빌드하는 데 필요한 입력을 줄일 수 있습니다.

::

	$routes->group('admin', function($routes)
	{
		$routes->add('users', 'Admin\Users::index');
		$routes->add('blog', 'Admin\Blog::index');
	});

This would prefix the 'users' and 'blog" URIs with "admin", handling URLs like ``/admin/users`` and ``/admin/blog``.
It is possible to nest groups within groups for finer organization if you need it
이렇게하면 'users'및 'blog'URI 앞에 'admin'이라는 접두사가 붙어 URL /admin/users및을 처리합니다 /admin/blog. 필요한 경우 조직을 세분화하기 위해 그룹 내에 그룹을 중첩하는 것이 가능합니다.

::

	$routes->group('admin', function($routes)
	{
		$routes->group('users', function($routes)
		{
			$routes->add('list', 'Admin\Users::list');
		});

	});

This would handle the URL at ``admin/users/list``.
이 URL은에서 URL을 처리합니다 admin/users/list.

If you need to assign options to a group, like a `namespace <#assigning-namespace>`_, do it before the callback
네임 스페이스 와 같은 그룹에 옵션을 지정해야하는 경우 콜백 전에 수행하십시오

::

	$routes->group('api', ['namespace' => 'App\API\v1'], function($routes)
	{
		$routes->resource('users');
	});

This would handle a resource route to the ``App\API\v1\Users`` controller with the ``/api/users`` URI.
이것은 URI 가있는 App\API\v1\Users컨트롤러에 대한 리소스 경로를 처리합니다 /api/users.

You can also use ensure that a specific `filter </incoming/filters.html>`_ gets ran for a group of routes. This will always
run the filter before or after the controller. This is especially handy during authentication or api logging::

    $routes->group('api', ['filter' => 'api-auth'], function($routes)
    {
        $routes->resource('users');
    });

The value for the filter must match one of the aliases defined within ``app/Config/Filters.php``.

Environment Restrictions
========================

You can create a set of routes that will only be viewable under a certain environment. This allows you to create
tools that only the developer can use on their local machines that are not reachable on testing or production servers.
This can be done with the ``environment()`` method. The first parameter is the name of the environment. Any
routes defined within this closure are only accessible from the given environment
특정 환경에서만 볼 수있는 일련의 경로를 만들 수 있습니다. 이를 통해 개발자 만이 테스트 또는 프로덕션 서버에서 도달 할 수없는 로컬 컴퓨터에서 사용할 수있는 도구를 만들 수 있습니다. 이 environment()방법 으로 수행 할 수 있습니다 . 첫 번째 매개 변수는 환경의 이름입니다. 이 클로저 내에 정의 된 모든 경로는 지정된 환경에서만 액세스 할 수 있습니다.

::

	$routes->environment('development', function($routes)
	{
		$routes->add('builder', 'Tools\Builder::index');
	});

Reverse Routing
===============

Reverse routing allows you to define the controller and method, as well as any parameters, that a link should go
to, and have the router lookup the current route to it. This allows route definitions to change without you having
to update your application code. This is typically used within views to create links.
역방향 라우팅을 사용하면 컨트롤러와 메소드뿐만 아니라 링크가 이동해야하는 모든 매개 변수를 정의하고 라우터가 현재 라우트를 조회하도록 할 수 있습니다. 이렇게하면 응용 프로그램 코드를 업데이트하지 않고도 경로 정의를 변경할 수 있습니다. 일반적으로보기에서 링크를 만드는 데 사용됩니다.

For example, if you have a route to a photo gallery that you want to link to, you can use the ``route_to()`` helper
function to get the current route that should be used. The first parameter is the fully qualified Controller and method,
separated by a double colon (::), much like you would use when writing the initial route itself. Any parameters that
should be passed to the route are passed in next
예를 들어 링크하려는 사진 갤러리 경로가있는 경우 route_to()헬퍼 기능을 사용 하여 현재 사용해야하는 경로를 얻을 수 있습니다. 첫 번째 매개 변수는 초기 경로 자체를 작성할 때 사용하는 것과 같이 정규 콜론 (:)으로 구분 된 정규화 된 컨트롤러 및 메서드입니다. 경로에 전달되어야하는 모든 매개 변수가 다음에 전달됩니다.

::

	// The route is defined as:
	$routes->add('users/(:id)/gallery(:any)', 'App\Controllers\Galleries::showUserGallery/$1/$2');

	// Generate the relative URL to link to user ID 15, gallery 12
	// Generates: /users/15/gallery/12
	<a href="<?= route_to('App\Controllers\Galleries::showUserGallery', 15, 12) ?>">View Gallery</a>

Using Named Routes
==================

You can name routes to make your application less fragile. This applies a name to a route that can be called
later, and even if the route definition changes, all of the links in your application built with ``route_to``
will still work without you having to make any changes. A route is named by passing in the ``as`` option
with the name of the route
응용 프로그램의 취약성을 줄이기 위해 경로의 이름을 지정할 수 있습니다. 이렇게하면 나중에 호출 할 수있는 경로에 이름이 적용되고 경로 정의가 변경 되더라도 변경 route_to 하지 않아도 작성된 응용 프로그램의 모든 링크 가 계속 작동합니다. 경로는 경로 as이름과 함께 옵션을 전달하여 지정됩니다 .

::

    // The route is defined as:
    $routes->add('users/(:id)/gallery(:any)', 'Galleries::showUserGallery/$1/$2', ['as' => 'user_gallery');

    // Generate the relative URL to link to user ID 15, gallery 12
    // Generates: /users/15/gallery/12
    <a href="<?= route_to('user_gallery', 15, 12) ?>">View Gallery</a>

This has the added benefit of making the views more readable, too.
이렇게하면보기를 더 읽기 쉽게 만들 수있는 추가 이점이 있습니다.

Using HTTP verbs in routes
==========================

It is possible to use HTTP verbs (request method) to define your routing rules. This is particularly
useful when building RESTFUL applications. You can use any standard HTTP verb (GET, POST, PUT, DELETE, etc).
Each verb has its own method you can use
HTTP 동사 (요청 방법)를 사용하여 라우팅 규칙을 정의 할 수 있습니다. 이는 RESTful 응용 프로그램을 빌드 할 때 특히 유용합니다. 모든 표준 HTTP 동사 (GET, POST, PUT, DELETE 등)를 사용할 수 있습니다. 각 동사에는 사용할 수있는 고유 한 방법이 있습니다.

::

	$routes->get('products', 'Product::feature');
	$routes->post('products', 'Product::feature');
	$routes->put('products/(:num)', 'Product::feature');
	$routes->delete('products/(:num)', 'Product::feature');

You can supply multiple verbs that a route should match by passing them in as an array to the ``match`` method
경로가 일치해야하는 여러 동사를 배열에 배열로 전달하여 제공 할 수 있습니다 ``match``.

::

	$routes->match(['get', 'put'], 'products', 'Product::feature');

Command-Line only Routes
========================

You can create routes that work only from the command-line, and are inaccessible from the web browser, with the
``cli()`` method. This is great for building cronjobs or CLI-only tools. Any route created by any of the HTTP-verb-based
route methods will also be inaccessible from the CLI, but routes created by the ``any()`` method will still be
available from the command line
명령 행에서만 작동하는 라우트를 작성할 수 있으며 웹 브라우저에서 cli()메소드를 사용하여 액세스 할 수 없습니다 . 이것은 cronjob 또는 CLI 전용 도구를 만드는 데 적합합니다. HTTP-verb 기반 라우트 메소드로 작성된 라우트는 CLI에서 액세스 할 수 없지만 any()메소드로 작성된 라우트 는 명령 행에서 계속 사용할 수 있습니다.

::

	$routes->cli('migrate', 'App\Database::migrate');

Resource Routes
===============

You can quickly create a handful of RESTful routes for a single resource with the ``resource()`` method. This
creates the five most common routes needed for full CRUD of a resource: create a new resource, update an existing one,
list all of that resource, show a single resource, and delete a single resource. The first parameter is the resource
name
resource()메소드 를 사용하여 단일 자원에 대해 소수의 RESTful 라우트를 빠르게 작성할 수 있습니다 . 이렇게하면 리소스의 전체 CRUD에 필요한 5 가지 가장 일반적인 경로가 만들어집니다. 새 리소스 만들기, 기존 리소스 업데이트, 모든 리소스 목록 표시, 단일 리소스 표시 및 단일 리소스 삭제. 첫 번째 매개 변수는 자원 이름입니다.

::

    $routes->resource('photos');

    // Equivalent to the following:
    $routes->get('photos',                 'Photos::index');
    $routes->get('photos/new',             'Photos::new');
    $routes->get('photos/(:segment)/edit', 'Photos::edit/$1');
    $routes->get('photos/(:segment)',      'Photos::show/$1');
    $routes->post('photos',                'Photos::create');
    $routes->patch('photos/(:segment)',    'Photos::update/$1');
    $routes->put('photos/(:segment)',      'Photos::update/$1');
    $routes->delete('photos/(:segment)',   'Photos::delete/$1');

.. important:: The routes are matched in the order they are specified, so if you have a resource photos above a get 'photos/poll' the show action's route for the resource line will be matched before the get line. To fix this, move the get line above the resource line so that it is matched first.
			   경로가 지정된 순서대로 일치하므로 'photos / poll 가져 오기'위의 리소스 사진이있는 경우 리소스 라인에 대한 show 작업의 경로가 get 줄 앞에 일치합니다. 이 문제를 해결하려면 자원 줄 위의 get 줄을 먼저 일치시켜야합니다.

The second parameter accepts an array of options that can be used to modify the routes that are generated. While these
routes are geared toward API-usage, where more methods are allowed, you can pass in the 'websafe' option to have it
generate update and delete methods that work with HTML forms
두 번째 매개 변수는 생성 된 경로를 수정하는 데 사용할 수있는 옵션 배열을 허용합니다. 이러한 경로는 더 많은 메소드가 허용되는 API 사용에 맞춰 지지만 'websafe'옵션을 전달하면 HTML 양식과 함께 작동하는 업데이트 및 삭제 메소드를 생성 할 수 있습니다.

::

    $routes->resource('photos', ['websafe' => 1]);

    // The following equivalent routes are created:
    $routes->post('photos/(:segment)',        'Photos::update/$1');
    $routes->post('photos/(:segment)/delete', 'Photos::delete/$1');

Change the Controller Used
--------------------------

You can specify the controller that should be used by passing in the ``controller`` option with the name of
the controller that should be used
사용할 컨트롤러 controller의 이름을 옵션 에 전달하여 사용할 컨트롤러를 지정할 수 있습니다 .

::

	$routes->resource('photos', ['controller' =>'App\Gallery']);

	// Would create routes like:
	$routes->get('photos', 'App\Gallery::index');

Change the Placeholder Used
---------------------------

By default, the ``segment`` placeholder is used when a resource ID is needed. You can change this by passing
in the ``placeholder`` option with the new string to use
기본적으로 segment자리 표시자는 리소스 ID가 필요할 때 사용됩니다. placeholder사용할 새 문자열과 함께 옵션을 전달하여 변경할 수 있습니다 .

::

	$routes->resource('photos', ['placeholder' => '(:id)']);

	// Generates routes like:
	$routes->get('photos/(:id)', 'Photos::show/$1');

Limit the Routes Made
---------------------

You can restrict the routes generated with the ``only`` option. This should be an array or comma separated list of method names that should
be created. Only routes that match one of these methods will be created. The rest will be ignored
only옵션으로 생성 된 경로를 제한 할 수 있습니다 . 이것은 작성되어야하는 메소드 이름의 배열 또는 쉼표로 구분 된 목록이어야합니다. 이 메소드 중 하나와 일치하는 라우트 만 작성됩니다. 나머지는 무시됩니다.

::

	$routes->resource('photos', ['only' => ['index', 'show']]);

Otherwise you can remove unused routes with the ``except`` option. This option run after ``only``
그렇지 않으면 except옵션으로 사용하지 않는 경로를 제거 할 수 있습니다 . 이 옵션은 다음과 only같이 실행됩니다 .

::

	$routes->resource('photos', ['except' => 'new,edit']);

Valid methods are: index, show, create, update, new, edit and delete.
유효한 메소드는 index, show, create, update, new, edit 및 delete입니다.

Global Options
==============

All of the methods for creating a route (add, get, post, resource, etc) can take an array of options that
can modify the generated routes, or further restrict them. The ``$options`` array is always the last parameter
경로를 만드는 모든 방법 (추가, 가져 오기, 게시, 리소스 등)은 생성 된 경로를 수정할 수있는 옵션 배열을 취하거나 더 제한 할 수 있습니다. $options배열은 항상 마지막 매개 변수입니다

::

	$routes->add('from', 'to', $options);
	$routes->get('from', 'to', $options);
	$routes->post('from', 'to', $options);
	$routes->put('from', 'to', $options);
	$routes->head('from', 'to', $options);
	$routes->options('from', 'to', $options);
	$routes->delete('from', 'to', $options);
	$routes->patch('from', 'to', $options);
	$routes->match(['get', 'put'], 'from', 'to', $options);
	$routes->resource('photos', $options);
	$routes->map($array, $options);
	$routes->group('name', $options, function());

Assigning Namespace
-------------------

While a default namespace will be prepended to the generated controllers (see below), you can also specify
a different namespace to be used in any options array, with the ``namespace`` option. The value should be the
namespace you want modified
기본 네임 스페이스가 생성 된 컨트롤러 앞에 추가되지만 (아래 참조), 옵션 배열에서 사용할 옵션과 함께 다른 네임 스페이스를 지정할 수도 namespace있습니다. 값은 수정하려는 네임 스페이스 여야합니다.

::

	// Routes to \Admin\Users::index()
	$routes->add('admin/users', 'Users::index', ['namespace' => 'Admin']);

The new namespace is only applied during that call for any methods that create a single route, like get, post, etc.
For any methods that create multiple routes, the new namespace is attached to all routes generated by that function
or, in the case of ``group()``, all routes generated while in the closure.
새로운 네임 스페이스는 get, post 등과 같은 단일 경로를 만드는 모든 메소드에 대해 호출 할 때만 적용됩니다. 여러 경로를 작성하는 모든 메소드의 경우 새 네임 스페이스는 해당 함수 또는 해당 경우에 생성 된 모든 경로에 첨부됩니다 of group(), 모든 경로는 폐쇄 중에 생성됩니다.

Limit to Hostname
-----------------

You can restrict groups of routes to function only in certain domain or sub-domains of your application
by passing the "hostname" option along with the desired domain to allow it on as part of the options array
"hostname"옵션을 원하는 도메인과 함께 전달하여 options 배열의 일부로 사용할 수 있도록 경로 그룹을 응용 프로그램의 특정 도메인 또는 하위 도메인에서만 작동하도록 제한 할 수 있습니다.

::

	$collection->get('from', 'to', ['hostname' => 'accounts.example.com']);

This example would only allow the specified hosts to work if the domain exactly matched "accounts.example.com".
It would not work under the main site at "example.com".
이 예에서는 도메인이 "accounts.example.com"과 정확하게 일치하는 경우에만 지정된 호스트가 작동하도록 허용합니다. "example.com"의 메인 사이트에서는 작동하지 않습니다.

Limit to Subdomains
-------------------

When the ``subdomain`` option is present, the system will restrict the routes to only be available on that
sub-domain. The route will only be matched if the subdomain is the one the application is being viewed through
때 subdomain옵션이 존재하는 시스템은 경로가 해당 하위 도메인에 사용할 수 제한됩니다. 하위 도메인이 응용 프로그램을 통해보고있는 경우에만 경로가 일치합니다.

::

	// Limit to media.example.com
	$routes->add('from', 'to', ['subdomain' => 'media']);

You can restrict it to any subdomain by setting the value to an asterisk, (*). If you are viewing from a URL
that does not have any subdomain present, this will not be matched
값을 별표 (*)로 설정하여 하위 도메인으로 제한 할 수 있습니다. 하위 도메인이없는 URL에서보고있는 경우 일치하지 않습니다.

::

	// Limit to any sub-domain
	$routes->add('from', 'to', ['subdomain' => '*']);

.. important:: The system is not perfect and should be tested for your specific domain before being used in production.
	Most domains should work fine but some edge case ones, especially with a period in the domain itself (not used
	to separate suffixes or www) can potentially lead to false positives.
	이 시스템은 완벽하지 않으므로 프로덕션 환경에서 사용하기 전에 특정 도메인에 대해 테스트해야합니다. 대부분의 도메인은 정상적으로 작동하지만 도메인 케이스 (특히 접미어 나 www를 구분하는 데 사용되지 않는 기간)가있는 일부 엣지 경우는 오탐 가능성을 유발할 수 있습니다.

Offsetting the Matched Parameters
---------------------------------

You can offset the matched parameters in your route by any numeric value with the ``offset`` option, with the
value being the number of segments to offset.
offset값이 오프셋 할 세그먼트 수인 옵션 과 함께 모든 숫자 값으로 경로에서 일치 매개 변수를 오프셋 할 수 있습니다 .

This can be beneficial when developing API's with the first URI segment being the version number. It can also
be used when the first parameter is a language string
이것은 첫 번째 URI 세그먼트가 버전 번호 인 API를 개발할 때 유용 할 수 있습니다. 첫 번째 매개 변수가 언어 문자열 인 경우에도 사용할 수 있습니다.

::

	$routes->get('users/(:num)', 'users/show/$1', ['offset' => 1]);

	// Creates:
	$routes['users/(:num)'] = 'users/show/$2';

Routes Configuration Options
============================

The RoutesCollection class provides several options that affect all routes, and can be modified to meet your
application's needs. These options are available at the top of `/app/Config/Routes.php`.
RoutesCollection 클래스는 모든 경로에 영향을주는 몇 가지 옵션을 제공하며 응용 프로그램의 필요에 맞게 수정할 수 있습니다. 이 옵션은 /app/Config/Routes.php 의 맨 위에 있습니다 .

Default Namespace
-----------------

When matching a controller to a route, the router will add the default namespace value to the front of the controller
specified by the route. By default, this value is empty, which leaves each route to specify the fully namespaced
controller
제어기를 라우트와 일치시킬 때, 라우터는 라우트가 지정한 제어기의 앞면에 기본 이름 공간 값을 추가합니다. 기본적으로이 값은 비어 있으며 각 경로에서 완전히 네임 스페이스가 지정된 컨트롤러를 지정합니다.

::

    $routes->setDefaultNamespace('');

    // Controller is \Users
    $routes->add('users', 'Users::index');

    // Controller is \Admin\Users
    $routes->add('users', 'Admin\Users::index');

If your controllers are not explicitly namespaced, there is no need to change this. If you namespace your controllers,
then you can change this value to save typing
컨트롤러에 명시 적으로 이름 공간이 지정되어 있지 않으면이 이름을 변경할 필요가 없습니다. 컨트롤러에 네임 스페이스를 지정하면이 값을 변경하여 입력 내용을 저장할 수 있습니다.

::

	$routes->setDefaultNamespace('App');

	// Controller is \App\Users
	$routes->add('users', 'Users::index');

	// Controller is \App\Admin\Users
	$routes->add('users', 'Admin\Users::index');

Default Controller
------------------

When a user visits the root of your site (i.e. example.com) the controller to use is determined by the value set by
the ``setDefaultController()`` method, unless a route exists for it explicitly. The default value for this is ``Home``
which matches the controller at ``/app/Controllers/Home.php``
사용자가 사이트의 루트 (예 : example.com)를 방문하면 setDefaultController()명시 적으로 경로가 존재하지 않는 한 사용하는 컨트롤러는 메소드가 설정 한 값으로 결정됩니다 . 이 값의 기본값은 다음 Home 위치의 컨트롤러와 일치합니다 ``/app/Controllers/Home.php``.

::

	// example.com routes to app/Controllers/Welcome.php
	$routes->setDefaultController('Welcome');

The default controller is also used when no matching route has been found, and the URI would point to a directory
in the controllers directory. For example, if the user visits ``example.com/admin``, if a controller was found at
``/app/Controllers/admin/Home.php`` it would be used.
기본 제어기는 일치하는 라우트가없는 경우에도 사용되며 URI는 controllers 디렉토리를 가리 킵니다. 예를 들어, 사용자가 example.com/admin 방문하여 ``/app/Controllers/admin/Home.php`` 컨트롤러가 발견 되면 이를 사용합니다.

Default Method
--------------

This works similar to the default controller setting, but is used to determine the default method that is used
when a controller is found that matches the URI, but no segment exists for the method. The default value is
``index``
이것은 기본 컨트롤러 설정과 비슷하지만 URI와 일치하는 컨트롤러가 있지만 해당 메서드에 세그먼트가없는 경우 사용되는 기본 방법을 결정하는 데 사용됩니다. 기본값은 index다음과 같습니다.

::

	$routes->setDefaultMethod('listAll');

In this example, if the user were to visit example.com/products, and a Products controller existed, the
``Products::listAll()`` method would be executed.
이 예에서 사용자가 example.com/products를 방문하고 제품 컨트롤러가있는 경우 Products::listAll()메소드가 실행됩니다.

Translate URI Dashes
--------------------

This option enables you to automatically replace dashes (‘-‘) with underscores in the controller and method
URI segments, thus saving you additional route entries if you need to do that. This is required, because the
dash isn’t a valid class or method name character and would cause a fatal error if you try to use it
이 옵션을 사용하면 대시 ( '-')를 제어기 및 메소드 URI 세그먼트의 밑줄로 자동으로 바꿀 수 있으므로 필요한 경우 추가 경로 항목을 절약 할 수 있습니다. 대시가 유효한 클래스 또는 메서드 이름 문자가 아니므로이를 사용하려고하면 치명적인 오류가 발생하기 때문에 필수입니다.

::

	$routes->setTranslateURIDashes(true);

Use Defined Routes Only
-----------------------

When no defined route is found that matches the URI, the system will attempt to match that URI against the
controllers and methods as described above. You can disable this automatic matching, and restrict routes
to only those defined by you, by setting the ``setAutoRoute()`` option to false
URI와 일치하는 정의 된 라우트가 발견되지 않으면 시스템은 위에서 설명한대로 해당 URI와 컨트롤러 및 메소드를 비교하려고합니다. 자동 일치를 사용 중지하고 setAutoRoute()옵션을 false 로 설정하여 경로를 사용자가 정의한 경로로만 제한 할 수 있습니다 .

::

	$routes->setAutoRoute(false);

404 Override
------------

When a page is not found that matches the current URI, the system will show a generic 404 view. You can change
what happens by specifying an action to happen with the ``set404Override()`` option. The value can be either
a valid class/method pair, just like you would show in any route, or a Closure
현재 URI와 일치하는 페이지를 찾을 수없는 경우 시스템은 일반 404보기를 표시합니다. set404Override()옵션 을 사용하여 수행 할 동작을 지정하여 발생하는 상황을 변경할 수 있습니다 . 이 값은 모든 경로에 표시되는 것과 마찬가지로 유효한 클래스 / 메소드 쌍이거나 클로저입니다.

::

    // Would execute the show404 method of the App\Errors class
    $routes->set404Override('App\Errors::show404');

    // Will display a custom view
    $routes->set404Override(function()
    {
        echo view('my_errors/not_found.html');
    });
