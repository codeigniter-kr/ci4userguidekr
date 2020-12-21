###################
URI 라우팅(Routing)
###################

.. contents::
    :local:
    :depth: 2

일반적으로 URL 문자열과 해당 컨트롤러 클래스/메소드 사이에는 일대일 관계가 있습니다.
URI의 세그먼트는 일반적으로 이 패턴을 따릅니다.

::

    example.com/class/method/id/

그러나 경우에 따라 URL에 해당하는 클래스 대신 다른 클래스/메소드를 호출할 수 있도록 이 관계를 다시 맵핑해야 할 경우가 있습니다.

예를 들어 URL에 이런 프로토타입이 있어야 한다고 가정해 보겠습니다.

::

    example.com/product/1/
    example.com/product/2/
    example.com/product/3/
    example.com/product/4/

일반적으로 URL의 두 번째 세그먼트는 메소드 이름으로 예약되어 있지만 위의 예제에서는 대신 제품 ID가 있습니다.
이를 위해 CodeIgniter는 URI 처리기(handler)를 다시 매핑할 수 있습니다.

자신만의 라우팅 규칙 설정
==============================

라우팅 규칙(rule)은 **app/Config/Routes.php** 파일에 정의되어 있습니다.
여기에서 고유한 라우팅 기준을 지정할 수 있는 RouteCollection 클래스의 인스턴스가 생성됩니다.
자리 표시자(placeholder) 또는 정규식(Regular Expressions)을 사용하여 경로를 지정할 수 있습니다.

라우터는 왼쪽의 URI를 가져와 컨트롤러에 전달해야 하는 매개 변수를 오른쪽의 컨트롤러/메소드에 맵핑합니다.
컨트롤러와 메소드는 완전한 이름 공간 클래스(fully-namespaced class)와 ``Users::list``\ 와 같이 이중 콜론(정적 메소드를 사용하는 것과 동일한 방식)으로 분리하여 나열합니다.
해당 메소드에 매개 변수를 전달해야 한다면 메소드 이름 뒤에 슬래시로 구분하여 나열합니다.

::

    // Calls the $Users->list()
    Users::list
    // Calls $Users->list(1, 23)
    Users::list/1/23

자리 표시자(Placeholder)
===========================

일반적으로 경로(route)는 다음과 같습니다

::

    $routes->add('product/(:num)', 'App\Catalog::productLookup');

경로에서 첫 번째 매개 변수는 일치할 URI이고, 두 번째 매개 변수는 다시 라우팅해야 하는 대상입니다.
위의 예제는 URL의 첫 번째 세그먼트가 "product"\ 이고 두 번째 세그먼트에 숫자가 있으면 "App\Catalog" 클래스의 "productLookup" 메소드로 라우팅됩니다.

자리 표시자는 단순히 정규식 패턴을 나타내는 문자열입니다.
라우팅 프로세스가 진행되는 동안 이러한 자리 표시자는 정규식 값으로 대체됩니다.
이들은 주로 가독성을 위해 사용됩니다.

경로에서 사용할 수있는 자리 표시자는 다음과 같습니다.

============ ===========================================================================================================
Placeholders Description
============ ===========================================================================================================
(:any)       해당 시점부터 URI 끝까지의 모든 문자와 일치하며, 여기에는 여러 URI 세그먼트가 포함될 수 있습니다.
(:segment)   결과를 단일 세그먼트로 제한하는 슬래시(/)를 제외한 모든 문자와 일치합니다.
(:num)       모든 정수와 일치합니다.
(:alpha)     모든 알파벳 문자와 일치합니다
(:alphanum)  영문자, 정수 문자열, 둘의 조합과 일치합니다.
(:hash)      **(:segment)**\ 와 같습니다. 그러나 hashded id를 사용합니다. (:doc:`모델 </models/model>` 문서 참조).
============ ===========================================================================================================

.. note:: **{locale}** :doc:`현지화(localization) </outgoing/localization>`\ 에 사용하도록 예약되어 있으므로 자리 표시자 또는 경로의 다른 부분으로 사용할 수 없습니다.

Examples
========

다음은 기본적인 몇 가지 라우팅 예입니다.

첫 번째 세그먼트에 "journals"\ 라는 단어가 포함된 URL은 "App\Blogs" 클래스의 기본 메소드인 ``index()``\ 로 매핑됩니다.

::

    $routes->add('journals', 'App\Blogs');

"blog/joe" 세그먼트가 포함된 URL은 "\Blogs" 클래스의 "users" 메소드로 매핑됩니다. ID는 "34"로 설정됩니다.

::

    $routes->add('blog/joe', 'Blogs::users/34');

첫 번째 세그먼트가 "product"\ 이고 두 번째 세그먼트가 있는 URL은 "\Catalog" 클래스의 "productLookup" 메소드로 매핑됩니다.

::

    $routes->add('product/(:any)', 'Catalog::productLookup');

첫 번째 세그먼트가 "product"\ 이고 두 번째로 숫자가 있는 URL은 "\Catalog" 클래스의 "productLookupByID" 메소드로 매핑되고, 
두 번째 세그먼트의 숫자를 메소드 변수에 전달합니다.

::

    $routes->add('product/(:num)', 'Catalog::productLookupByID/$1');

하나의 ``(:any)``\ 가 있는 경우 URL의 여러 세그먼트와 일치합니다.

이에 대한 예로

::

	$routes->add('product/(:any)', 'Catalog::productLookup/$1');

위의 경로는 product/123, product/123/456, product/123/456/789 등과 일치합니다.
컨트롤러를 구현할 때는 최대 매개 변수를 고려해야 합니다.

::

    public function productLookup($seg1 = false, $seg2 = false, $seg3 = false) {
        echo $seg1; // Will be 123 in all examples
        echo $seg2; // false in first, 456 in second and third example
        echo $seg3; // false in first and second, 789 in third
    }

여러 세그먼트를 일치시키는 것이 의도된 동작이 아니라면 경로를 정의할 때 ``(:segment)``\ 를 사용합니다.

위의 URL 예제를 사용합니다.

::

	$routes->add('product/(:segment)', 'Catalog::productLookup/$1');

위의 경로는 product/123만 일치하고 다른 예(product/123/456, product/123/456/789 등)는 404 오류가 발생합니다.


.. important:: ``add()`` 메소드는 편리하지만 아래 설명된 HTTP 동사 기반 경로(route)를 사용하십시오. 더 안전하며, 경로와 일치하는 항목을 찾을때 
    요청(request) 방법을 이용해 검색해야 할 경로가 적어지므로 성능이 약간 향상됩니다.

맞춤(custom) 자리 표시자
==========================

가독성을 위해 경로(route) 파일에 사용자 정의 자리 표시자를 만들어 사용할 수 있습니다.

``addPlaceholder`` 메소드를 사용하여 새로운 자리 표시자를 추가합니다.
첫 번째 매개 변수는 자리 표시자로 사용될 문자열입니다.
두 번째 매개 변수는 정규식 패턴입니다.
경로(route)를 추가하기 전에 호출해야 합니다

::

    $routes->addPlaceholder('uuid', '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}');
    $routes->add('users/(:uuid)', 'Users::show/$1');

정규식
===================

원하는 경우 정규식을 사용하여 라우팅 규칙을 정의할 수 있습니다.
역 참조와 마찬가지로 유효한 정규식이 허용됩니다.

.. important:: Note: 역 참조를 사용하는 경우 이중 백 슬래시 구문 대신 달러($) 구문을 사용해야합니다.
    일반적인 RegEx 경로는 다음과 같습니다::

    $routes->add('products/([a-z]+)/(\d+)', 'Products::show/$1/id_$2');

위의 예에서, ``products/shirts/123``\ 과 유사한 URI는 대신 ``Products`` 컨트롤러 클래스의 ``show`` 메소드를 호출하고 세그먼트가 첫 번째 및 두 번째 세그먼트가 인수로 전달됩니다.

정규 표현식을 사용하면 일반적으로 여러 세그먼트 사이의 구분 기호를 나타내는 슬래시('/')가 포함된 세그먼트를 잡을 수도 있습니다.

사용자가 웹 어플리케이션의 비밀번호로 보호된 영역에 액세스하고 로그인한 후 동일한 페이지로 다시 리디렉션하려는 경우 이 예제가 유용할 수 있습니다.

::

    $routes->add('login/(.+)', 'Auth::login/$1');

정규 표현식에 대해 더 배우고 싶은 사람들에게 `regular-expressions.info <https://www.regular-expressions.info/>`_\ 가 좋은 출발점이 될 수 있습니다.

.. important:: Note: 와일드 카드를 정규식과 혼합하여 일치시킬 수도 있습니다.

클로저(Closure)
==================

경로가 매핑되는 대상으로 익명 함수(anonymous function) 또는 클로저를 사용할 수 있습니다.
이 기능은 사용자가 해당 URI를 방문할 때 실행됩니다.
작은 작업을 빠르게 실행하거나 간단히 뷰만 표시하는 데 편리합니다.

::

    $routes->add('feed', function()
    {
        $rss = new RSSFeeder();
        return $rss->feed('general');
    });

다중 경로 매핑
=======================

한 번에 여러 경로에 대해 매핑하려면 `add()` 메소드보다 ``map()`` 메소드를 사용하는것이 편리합니다.
추가해야 할 각 경로에 대해 `add()` 메소드를 여러번 호출하는 대신 배열로 경로(route)를 정의한 다음 이를 ``map()`` 메소드에 매개 변수로 전달할 수 있습니다.

::

    $routes = [];
    $routes['product/(:num)']      = 'Catalog::productLookupById';
    $routes['product/(:alphanum)'] = 'Catalog::productLookupByName';

    $collection->map($routes);

라우트 리디렉션
==================

서비스를 오래 동안 유지한 사이트는 페이지가 이동되기 마련입니다.
라우트의 ``addRedirect()`` 메소드를 사용하면 이전 경로를 다른 경로로 리디렉션(redirect)할 수 있습니다.
첫 번째 매개 변수는 이전 경로의 URI 패턴입니다.
두 번째 매개 변수는 리디렉션할 새 URI 또는 명명된 경로(route)명입니다.
세 번째 매개 변수는 리디렉션과 함께 전송되어야 하는 HTTP 상태 코드입니다.
기본값은 임시 리디렉션을 뜻하는 ``302``\ 이며  대부분의 경우 권장됩니다

::

    $routes->add('users/profile', 'Users::profile', ['as' => 'profile']);

    // Redirect to a named route
    $routes->addRedirect('users/about', 'profile');
    // Redirect to a URI
    $routes->addRedirect('users/about', 'users/profile');

페이지 로드중 요청(request) 경로가 리디렉션 경로와 일치하면 컨트롤러를 로드하기 전에 사용자는 새 페이지로 리디렉션됩니다.

라우트 그룹화
===============

``group()`` 메소드를 사용하여 경로를 그룹화 할 수 있습니다.
그룹 이름은 그룹 내부에 정의된 경로 앞에 나타나는 세그먼트가 됩니다.
이렇게 하면 관리자 영역을 구축할 때와 같이 시작 문자열을 공유하는 광범위한 경로 작성에 필요한 입력(typing)을 줄일 수 있습니다.

::

    $routes->group('admin', function($routes)
    {
        $routes->add('users', 'Admin\Users::index');
        $routes->add('blog', 'Admin\Blog::index');
    });

이것은 'users'\ 와 'blog' URI를 접두사 "admin"\ 을 사용하여 ``/admin/users`` 및 ``/admin/blog``\ 로 만들어 줍니다.

콜백 전에 `namespace <#assigning-namespace>`_\ 처럼 그룹에 옵션을 할당해야 하는 경우::

    $routes->group('api', ['namespace' => 'App\API\v1'], function($routes)
    {
        $routes->resource('users');
    });

위 예는 ``/api/users`` URI를 사용하여 ``App\API\v1\Users`` 컨트롤러에 대한 리소스 경로(route)를 처리합니다.

라우트 그룹에 특정 `필터(filter) <filters.html>`_\ 를 사용할 수도 있습니다.
필터를 사용하면 컨트롤러 전후에 필터를 실행하며, 인증이나 api 로깅에 유용합니다.

::

    $routes->group('api', ['filter' => 'api-auth'], function($routes)
    {
        $routes->resource('users');
    });

필터 값은 ``app/Config/Filters.php``\ 에 정의된 별칭(aliase)중 하나와 일치해야 합니다.

필요한 경우 그룹 내에 그룹을 중첩하여 보다 세밀한 구성을 할 수 있습니다.

::

    $routes->group('admin', function($routes)
    {
        $routes->group('users', function($routes)
        {
            $routes->add('list', 'Admin\Users::list');
        });

    });

This would handle the URL at ``admin/users/list``. Note that options passed to the outer ``group()`` (for example ``namespace`` and ``filter``) are not merged with the inner ``group()`` options.

At some point, you may want to group routes for the purpose of applying filters or other route config options like namespace, subdomain, etc. 
Without necessarily needing to add a prefix to the group, you can pass an empty string in place of the prefix and the routes in the group will be routed as though the group never existed but with the given route config options

위 예는 URL을 ``admin/users/list`` 로 처리할 것입니다. 
외부 ``group()``\ 에 전달된 옵션(예: ``namespace``\ 와 ``filter``)은 내부 ``group()`` 옵션과 병합되지 않습니다.

필터 또는 네임스페이스, 하위 도메인 등과 같은 다른 경로 구성 옵션을 적용하기 위해 경로를 그룹화할 수 있습니다. 
그룹에 접두사를 추가할 필요 없이 접두사 대신 빈 문자열을 전달할 수 있으며, 그룹의 경로는 그룹이 존재하지 않았지만 주어진 경로 구성 옵션을 사용하여 라우팅됩니다.

환경 제한(Restrictions)
===========================

특정 환경에서만 볼 수있는 일련의 경로를 만들 수 있습니다.
이를 통해 개발자는 테스트나 프로덕션 서버에서 접근할 수 없지만 로컬 컴퓨터에서 개발자만 사용할 수 있는 도구를 만들 수 있습니다.
``environment()`` 메소드에 환경 이름을 전달하여 이를 정의할 수 있습니다.
이렇게 폐쇄적으로 정의한 모든 경로는 주어진 환경에서만 액세스할 수 있습니다

::

    $routes->environment('development', function($routes) {
        $routes->add('builder', 'Tools\Builder::index');
    });

리버스(Reverse) 라우팅
========================

리버스 라우팅은 링크와 연결해야 하는 모든 매개변수뿐만 아니라, 컨트롤러와 메소드를 정의하고, 라우터가 현재 경로를 조회하도록 할 수 있습니다.
이렇게 하면 어플리케이션 코드를 업데이트하지 않고도 경로 정의를 변경할 수 있습니다. 이것은 일반적으로 링크를 만들기 위해 뷰에서 사용됩니다.

예를 들어, 연결하려는 사진 갤러리에 대한 경로가 있는 경우 ``route_to()`` 헬퍼 함수를 사용하여 현재 경로를 얻을 수 있습니다.
첫 번째 매개 변수는 초기 경로 자체를 작성할 때 사용하는 것과 같이 정규화된 컨트롤러 및 메소드이며 이중 콜론(::)으로 구분합니다.
경로로 전달되어야하는 모든 매개 변수는 다음 매개 변수에 전달됩니다.

::

    // The route is defined as:
    $routes->add('users/(:id)/gallery(:any)', 'App\Controllers\Galleries::showUserGallery/$1/$2');

    // Generate the relative URL to link to user ID 15, gallery 12
    // Generates: /users/15/gallery/12
    <a href="<?= route_to('App\Controllers\Galleries::showUserGallery', 15, 12) ?>">View Gallery</a>

명명된 경로 사용
==================

어플리케이션의 취약성을 낮추기 위해 경로 이름을 지정할 수 있습니다.
이렇게하면 나중에 호출할 수있는 경로에 이름이 적용되며, 경로 정의가 변경되더라도 ``route_to``\ 로 구축된 어플리케이션의 모든 링크를 수정하지 않아도 계속 작동합니다.
경로 이름과 함께 ``as`` 옵션을 전달하여 경로 이름을 지정합니다.

::

    // The route is defined as:
    $routes->add('users/(:id)/gallery(:any)', 'Galleries::showUserGallery/$1/$2', ['as' => 'user_gallery');

    // Generate the relative URL to link to user ID 15, gallery 12
    // Generates: /users/15/gallery/12
    <a href="<?= route_to('user_gallery', 15, 12) ?>">View Gallery</a>

이렇게 하면 뷰를 더 읽기 쉽게 만들 수 있는 이점도 있습니다.

라우트에 HTTP 동사(verbs) 사용
=================================

HTTP 동사(request method)를 사용하여 라우팅 규칙을 정의 할 수 있습니다.
RESTFUL 어플리케이션을 빌드할 때 특히 유용합니다.
표준 HTTP 동사(GET, POST, PUT, DELETE 등)를 사용할 수 있습니다.
각 동사는 사용할 수 있는 고유한 메소드가 있습니다.

::

    $routes->get('products', 'Product::feature');
    $routes->post('products', 'Product::feature');
    $routes->put('products/(:num)', 'Product::feature');
    $routes->delete('products/(:num)', 'Product::feature');

``match`` 메소드에 배열로 일치해야 하는 여러 동사에 경로를 제공할 수 있습니다.

::

    $routes->match(['get', 'put'], 'products', 'Product::feature');

커맨드 라인(command-line) 전용 라우트
===============================================

``cli()`` 메소드를 사용하여 명령행(cronjob 또는 CLI 전용 도구)에서만 작동하고 웹 브라우저에서 액세스할 수 없는 경로(route)를 작성할 수 있습니다.
CLI에서 HTTP 동사 기반 라우트 메소드(get, post, put 등)로 작성된 라우트는 액세스할 수 없지만, ``any()`` 메소드로 작성된 라우트는 커맨드 라인에서 사용 가능합니다.

::

    $routes->cli('migrate', 'App\Database::migrate');

전역 옵션
==============

경로(route)를 만드는 모든 메소드(add, get, post, `resource <restful.html>`_ etc)는 생성된 경로를 수정하거나 추가로 제한할 수 있는 옵션을 배열로 취할 수 있습니다.
``$options`` 배열은 항상 마지막 매개 변수(parameter)입니다

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

필터 적용
----------------

컨트롤러 전후에 실행할 필터를 제공하여 특정 경로의 동작을 변경할 수 있습니다.
이것은 인증 또는 API 로깅에 이용하면 편리합니다.

::

    $routes->add('admin',' AdminController::index', ['filter' => 'admin-auth']);

필터 값은 ``app/Config/Filters.php``\ 에 정의된 별칭 중 하나와 일치해야 합니다.
필터의 ``before()`` 및 ``after()`` 메소드에 전달할 인수를 제공할 수도 있습니다.

::

    $routes->add('users/delete/(:segment)', 'AdminController::index', ['filter' => 'admin-auth:dual,noreturn']);

필터 설정에 대한 자세한 내용은 `컨트롤러 필터 <filters.html>`_\ 를 참조하십시오.

네임스페이스 할당
---------------------

기본 네임스페이스가 컨트롤러(아래 참조) 앞에 추가되지만, ``namespace`` 옵션을 사용하여 다른 네임스페이스를 지정할 수도 있습니다.
값은 수정하려는 네임스페이스여야 합니다.

::

    // Routes to \Admin\Users::index()
    $routes->add('admin/users', 'Users::index', ['namespace' => 'Admin']);

새로운 네임스페이스는 get, post 등과 같이 단일 경로를 만드는 메소드에 대해서만 적용됩니다.
다중 경로를 만드는 모든 메소드의 경우 새로운 네임스페이스를 해당 함수에 의해 생성된 모든 경로 또는 ``group()``\ 일 경우 클로저에 생성된 모든 경로에 연결됩니다.

호스트 이름(Hostname)으로 제한
-------------------------------------

"hostname" 옵션을 원하는 도메인과 함께 전달하여 경로(route) 그룹이 특정 도메인 또는 하위 도메인에서만 작동하도록 제한할 수 있습니다.

::

    $collection->get('from', 'to', ['hostname' => 'accounts.example.com']);

이 예는 도메인이 "accounts.example.com".과 정확히 일치하는 경우에만 작동하도록 허용합니다.
기본 사이트인 "example.com" 에서는 작동하지 않습니다.

서브도메인(Subdomain)으로 제한
----------------------------------------

``subdomain`` 옵션이 있으면 시스템은 해당 서브도메인에서만 경로(route)를 사용할 수 있도록 제한합니다.
경로는 서브도메인(subdomain)이 어플리케이션을 통해 보고 있는 영역인 경우에만 일치합니다.

::

    // Limit to media.example.com
    $routes->add('from', 'to', ['subdomain' => 'media']);

값을 별표(*)로 설정하여 하위 도메인으로 제한할 수 있습니다.
하위 도메인이 없는 URL에서 보는 경우 일치하지 않습니다

::

    // Limit to any sub-domain
    $routes->add('from', 'to', ['subdomain' => '*']);

.. important:: 시스템이 완벽하지 않으므로 프로덕션(production) 환경에서 사용하기 전에 특정 도메인에 대해 테스트해야 합니다.
    대부분의 도메인에서 제대로 작동하지만, 일부 도메인, 특히 도메인 자체에 마침표가 있는 경우(접미사 또는 www를 구분하는 데 사용되지 않음)에는 잘못 탐지할 수 있습니다.

일치하는 매개 변수(Parameter) 상쇄(offset)
--------------------------------------------

``offset`` 옵션을 사용하여 경로에서 일치하는 매개 변수를 숫자 값으로 상쇄(offset)할 수 있으며 값은 상쇄할 세그먼트 수입니다.

이 기능은 첫 번째 URI 세그먼트가 버전 번호인 API를 개발할 때 유용할 수 있습니다.
첫 번째 매개 변수가 언어(language) 문자열 인 경우에도 사용할 수 있습니다.

::

    $routes->get('users/(:num)', 'users/show/$1', ['offset' => 1]);

    // Creates:
    $routes['users/(:num)'] = 'users/show/$2';

경로(Route) 구성 옵션
============================

RoutesCollection 클래스는 모든 경로에 영향을 주는 몇 가지 옵션을 제공하며 어플리케이션의 요구에 맞게 수정할 수 있습니다.
이 옵션들은 `/app/Config/Routes.php` 상단에 있습니다.

기본 네임스페이스
----------------------

기본 네임스페이스 값이 지정되어 있으면, 라우터는 경로로 지정된 컨트롤러 앞에 이 값을 추가합니다.
기본적으로 이 값은 비어 있으며, 각 경로는 컨트롤러를 전체 네임스페이스와 함께 지정합니다.

::

    $routes->setDefaultNamespace('');

    // Controller is \Users
    $routes->add('users', 'Users::index');

    // Controller is \Admin\Users
    $routes->add('users', 'Admin\Users::index');

컨트롤러의 네임스페이스가 명시적으로 지정되지 않은 경우 이 값을 설정하여 컨트롤러에 네임스페이스를 지정할 수 있습니다.

::

    $routes->setDefaultNamespace('App');

    // Controller is \App\Users
    $routes->add('users', 'Users::index');

    // Controller is \App\Admin\Users
    $routes->add('users', 'Admin\Users::index');

기본 컨트롤러
------------------

사용자가 사이트의 루트(예 : example.com)를 방문할 때 경로가 명시적으로 존재하지 않으면 사용할 컨트롤러는 ``setDefaultController()`` 메소드에 의해 설정된 값에 의해 결정됩니다.
기본값은 ``/app/Controllers/Home.php``\ 의 ``Home`` 컨트롤러입니다.

::

    // example.com routes to app/Controllers/Welcome.php
    $routes->setDefaultController('Welcome');

일치하는 경로를 찾지 못한 경우에도 기본 컨트롤러가 사용되며, URI는 컨트롤러 디렉토리를 가리킵니다.
예를 들어 사용자가 ``example.com/admin``\ 을 방문하면 ``/app/Controllers/admin/Home.php`` 컨트롤러가 사용됩니다.

기본 메소드
--------------

이 메소드는 기본 컨트롤러 설정과 유사하게 작동하며, URI와 일치하는 컨트롤러를 발견되었으나, 메소드에 대한 세그먼트가 없을 때 사용됩니다.
기본값은 ``index``\ 입니다.

사용자가 "example.com/products"\ 를 방문하였을때 products 컨트롤러가 존재한다면, ``Products::listAll()`` 메소드가 실행됩니다.

::

    $routes->setDefaultMethod('listAll');

URI 대시(-) 변환
--------------------

이 옵션을 사용하면 컨트롤러 및 메소드 URI 세그먼트에서 대시 ('-')를 밑줄('_')로 자동 대체할 수 있습니다.
대시는 클래스 또는 메소드명의 유효한 문자가 아니므로 사용하면 치명적인 오류가 발생합니다.
URI에 대시를 사용하고자 할 때 이 옵션 사용은 필수입니다.

::

    $routes->setTranslateURIDashes(true);

정의된 경로만 사용
-----------------------

URI와 일치하는 정의된 경로가 없으면 시스템은 위에서 설명한대로 컨트롤러 및 메소드와 해당 URI를 일치 시키려고 시도합니다.
``setAutoRoute()`` 옵션을 false로 설정하면 자동 일치 기능을 비활성화하여 사용자가 정의한 경로로만 접근하도록 제한할 수 있습니다

::

    $routes->setAutoRoute(false);

404 재정의
--------------

현재 URI와 일치하는 페이지를 찾지 못하면 시스템은 일반 404 뷰를 표시합니다.
``set404Override()`` 옵션을 사용하여 404 뷰대신 컨트롤러 클래스/메소드 또는 클로저(Closure)로 변경할 수 있습니다.

::

    // Would execute the show404 method of the App\Errors class
    $routes->set404Override('App\Errors::show404');

    // Will display a custom view
    $routes->set404Override(function()
    {
        echo view('my_errors/not_found.html');
    });
