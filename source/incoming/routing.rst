###################
URI 라우팅(Routing)
###################

.. contents::
    :local:
    :depth: 2

라우팅이란?
********************

URI 라우팅은 URI를 컨트롤러의 메소드와 연결합니다.

CodeIgniter에는 두 가지 종류의 라우팅이 있습니다. 하나는 **Defined Route Routing**\ 이고 다른 하나는 **Auto Routing**\ 입니다.
정의된 경로 라우팅을 사용하여 경로를 수동으로 정의할 수 있으며, 유연한 URL을 허용합니다.
자동 라우팅(Auto Routing)은 규칙에 따라 HTTP 요청을 자동으로 라우팅하고 해당 컨트롤러 메서드를 실행합니다. 
수동으로 경로를 정의할 필요가 없습니다.

먼저 정의된 경로 라우팅을 살펴보겠습니다. 자동 라우팅을 사용하려면 :ref:`auto-routing-improved`\ 를 참조하세요.

.. _defined-route-routing:

자신만의 라우팅 규칙 설정
==============================

라우팅 규칙은 **app/Config/Routes.php** 파일에 정의되어 있습니다.
여기에서 고유한 라우팅 기준을 지정할 수 있는 RouteCollection 클래스(``$routes``)의 인스턴스를 생성하는 것을 볼 수 있습니다.
경로는 자리 표시자(placeholders) 또는 정규식을 사용하여 지정할 수 있습니다.

경로를 지정할 때 HTTP 동사에 해당하는 메소드(요청 메소드)를 선택합니다.
GET 요청이 예상되면 ``get()`` 메서드를 사용합니다.

.. literalinclude:: routing/001.php

경로는 왼쪽에 컨트롤러에 전달되어야 하는 매개변수를 URI path(``/``)를 사용하여 정의하고 오른쪽에 정의된 컨트롤러 및 메소드(``Home::index``)에 매핑합니다. .
컨트롤러와 메소드는 ``Users::list``\ 와 같이 이중 콜론으로 클래스와 해당 메서드를 구분하여 정적 메서드를 사용하는 것과 동일한 방식으로 나열해야 합니다.
해당 메서드에 매개변수를 전달해야 하는 경우 메소드 이름 뒤에 나열되며 슬래시로 구분됩니다.

.. literalinclude:: routing/002.php

You can use any standard HTTP verb (GET, POST, PUT, DELETE, etc):

.. literalinclude:: routing/003.php

You can supply multiple verbs that a route should match by passing them in as an array to the ``match()`` method:

.. literalinclude:: routing/004.php

자리 표시자(Placeholder)
===========================

일반적으로 경로(route)는 다음과 같습니다

.. literalinclude:: routing/005.php

경로에서 첫 번째 매개 변수는 일치할 URI이고, 두 번째 매개 변수는 라우팅해야 하는 대상입니다.
위의 예제는 URL 경로의 첫 번째 세그먼트가 "product"\ 이고 두 번째 세그먼트에 숫자가 있으면 "App\Catalog" 클래스의 "productLookup" 메소드로 라우팅됩니다.

자리 표시자는 단순히 정규식 패턴을 나타내는 문자열입니다.
라우팅 프로세스가 진행되는 동안 이러한 자리 표시자는 정규식 값으로 대체됩니다.
이들은 주로 가독성을 위해 사용됩니다.

경로에서 사용할 수있는 자리 표시자는 다음과 같습니다.

============ ===========================================================================================================
Placeholders Description
============ ===========================================================================================================
(:any)       해당 시점부터 URI 끝까지의 모든 문자와 일치하며, 여기에는 여러 URI 세그먼트가 포함될 수 있습니다.
(:segment)   결과를 단일 세그먼트로 제한하는 슬래시(``/``)를 제외한 모든 문자와 일치합니다.
(:num)       모든 정수와 일치합니다.
(:alpha)     모든 알파벳 문자와 일치합니다
(:alphanum)  영문자, 정수 문자열, 둘의 조합과 일치합니다.
(:hash)      ``(:segment)``\ 와 같습니다. 그러나 hashded id를 사용합니다.
============ ===========================================================================================================

.. note:: ``{locale}`` :doc:`현지화(localization) </outgoing/localization>`\ 에 사용하도록 예약되어 있으므로 자리 표시자 또는 경로의 다른 부분으로 사용할 수 없습니다.

Examples
========

다음은 기본적인 몇 가지 라우팅 예입니다.

첫 번째 세그먼트에 **journals**\ 라는 단어가 포함된 URL은 ``\App\Controllers\Blogs`` 클래스의 기본 메소드인 ``index()``\ 로 매핑됩니다.

.. literalinclude:: routing/006.php

"blog/joe" 세그먼트가 포함된 URL은 ``\App\Controllers\Blogs`` 클래스의 ``users()`` 메소드로 매핑됩니다. ID는 ``34``\ 로 설정됩니다.

.. literalinclude:: routing/007.php

첫 번째 세그먼트가 **product**\ 이고 두 번째 세그먼트가 있는 URL은 ``\App\Controllers\Catalog`` 클래스의 ``productLookup()`` 메소드로 매핑됩니다.

.. literalinclude:: routing/008.php

첫 번째 세그먼트가 **product**\ 이고 두 번째로 숫자가 있는 URL은 ``\App\Controllers\Catalog`` 클래스의 ``productLookupByID()`` 메소드로 매핑되고, 
두 번째 세그먼트의 숫자를 메소드 변수에 전달합니다.

.. literalinclude:: routing/009.php

하나의 ``(:any)``\ 가 있는 경우 URL의 여러 세그먼트와 일치합니다.

.. literalinclude:: routing/010.php

위의 경로는 **product/123**, **product/123/456**, **product/123/456/789** 등과 일치합니다.
컨트롤러를 구현할 때는 최대 매개 변수를 고려해야 합니다.

.. literalinclude:: routing/011.php

여러 세그먼트를 일치시키는 것이 의도된 동작이 아니라면 경로를 정의할 때 ``(:segment)``\ 를 사용합니다.

.. literalinclude:: routing/012.php

위의 경로는 **product/123**\ 만 일치하고 다른 예(product/123/456, product/123/456/789 등)는 404 오류가 발생합니다.


.. warning:: ``add()`` 방식은 편리하지만, 아래 설명된 더 안전한 HTTP-verb-based 경로(route) 사용을 권장합니다.
    :doc:`CSRF protection </libraries/security>`\ 은 *GET** 요청을 보호하지 않으므로, ``add()`` 메서드에 지정된 URI를 GET 메서드로 액세스할 경우 CSRF protection이 작동하지 않습니다.

.. note:: HTTP-verb-based 경로(route)를 사용하면 현재 요청 방법과 일치하는 경로만 저장되므로 일치하는 경로를 찾을 때 검색할 경로가 줄어들어 성능이 약간 향상됩니다.

Array Callable Syntax
=====================

v4.2.0부터 배열 호출 가능 구문(array callable syntax)을 사용하여 컨트롤러를 지정할 수 있습니다.

.. literalinclude:: routing/013.php
   :lines: 2-

또는 ``use`` 키워드 사용:

.. literalinclude:: routing/014.php
   :lines: 2-

자리 표시자가 있는 경우 지정된 순서대로 매개변수를 자동으로 설정합니다.

.. literalinclude:: routing/015.php
   :lines: 2-

그러나 경로(route)에 정규식을 사용하는 경우 자동 구성 매개변수가 올바르지 않을 수 있습니다.
이러한 경우 매개변수를 수동으로 지정합니다.

.. literalinclude:: routing/016.php
   :lines: 2-

맞춤(custom) 자리 표시자
==========================

가독성을 위해 경로(route) 파일에 사용자 정의 자리 표시자를 만들어 사용할 수 있습니다.

``addPlaceholder()`` 메소드를 사용하여 새로운 자리 표시자를 추가합니다.
첫 번째 매개 변수는 자리 표시자로 사용될 문자열입니다.
두 번째 매개 변수는 정규식 패턴입니다.
경로(route)를 추가하기 전에 호출해야 합니다.

.. literalinclude:: routing/017.php

정규식
===================

원하는 경우 정규식을 사용하여 라우팅 규칙을 정의할 수 있습니다.
역 참조와 마찬가지로 유효한 정규식이 허용됩니다.

.. important:: Note: 역 참조를 사용하는 경우 이중 백 슬래시 구문 대신 달러($) 구문을 사용해야합니다.
    일반적인 RegEx 경로는 다음과 같습니다.

    .. literalinclude:: routing/018.php

위의 예에서, **products/shirts/123**\ 과 유사한 URI는 ``Products`` 컨트롤러 클래스의 ``show`` 메소드를 호출하고 세그먼트가 첫 번째 및 두 번째 세그먼트가 인수로 전달됩니다.

정규 표현식을 사용하면 일반적으로 여러 세그먼트 사이의 구분 기호를 나타내는 슬래시(``/``)가 포함된 세그먼트를 잡을 수도 있습니다.

사용자가 웹 어플리케이션의 비밀번호로 보호된 영역에 액세스하고 로그인한 후 동일한 페이지로 다시 리디렉션하려는 경우 이 예제가 유용할 수 있습니다.

.. literalinclude:: routing/019.php

정규 표현식에 대해 더 배우고 싶은 사람들에게 `regular-expressions.info <https://www.regular-expressions.info/>`_\ 가 좋은 출발점이 될 수 있습니다.

.. important:: Note: 와일드 카드를 정규식과 혼합하여 일치시킬 수도 있습니다.

클로저(Closure)
==================

경로가 매핑되는 대상으로 익명 함수(anonymous function) 또는 클로저를 사용할 수 있습니다.
이 기능은 사용자가 해당 URI를 방문할 때 실행됩니다.
작은 작업을 빠르게 실행하거나 간단히 뷰만 표시하는 데 편리합니다.

.. literalinclude:: routing/020.php

다중 경로 매핑
=======================

한 번에 여러 경로에 대해 매핑하려면 ``add()`` 메소드보다 ``map()`` 메소드를 사용하는것이 편리합니다.
추가해야 할 각 경로에 대해 ``add()`` 메소드를 여러번 호출하는 대신 배열로 경로(route)를 정의한 다음 이를 ``map()`` 메소드에 매개 변수로 전달할 수 있습니다.

.. literalinclude:: routing/021.php

.. _redirecting-routes:

라우트 리디렉션
==================

서비스를 오래 동안 유지한 사이트는 페이지가 이동되기 마련입니다.
라우트의 ``addRedirect()`` 메소드를 사용하면 이전 경로를 다른 경로로 리디렉션(redirect)할 수 있습니다.
첫 번째 매개 변수는 이전 경로의 URI 패턴입니다.
두 번째 매개 변수는 리디렉션할 새 URI 또는 명명된 경로(route)명입니다.
세 번째 매개 변수는 리디렉션과 함께 전송되어야 하는 HTTP 상태 코드입니다.
기본값은 임시 리디렉션을 뜻하는 ``302``\ 이며  대부분의 경우 권장됩니다

.. literalinclude:: routing/022.php

.. note:: v4.2.0부터 ``addRedirect()`` 자리 표시자를 사용할 수 있습니다.

페이지 로드중 요청(request) 경로가 리디렉션 경로와 일치하면 컨트롤러를 로드하기 전에 사용자는 새 페이지로 리디렉션됩니다.

라우트 그룹화
===============

``group()`` 메소드를 사용하여 경로를 그룹화 할 수 있습니다.
그룹 이름은 그룹 내부에 정의된 경로 앞에 나타나는 세그먼트가 됩니다.
이렇게 하면 관리자 영역을 구축할 때와 같이 시작 문자열을 공유하는 광범위한 경로 작성에 필요한 입력(typing)을 줄일 수 있습니다.

.. literalinclude:: routing/023.php

이것은 **users**\ 와 **blog** URI를 접두사 **admin**\ 을 사용하여 **/admin/users**\ 와 **/admin/blog**\ 로 만들어 줍니다.

콜백 전에 :ref:`assigning-namespace`\ 처럼 그룹에 옵션을 할당해야 하는 경우

.. literalinclude:: routing/024.php

위 예는 **/api/users** URI를 사용하여 ``App\API\v1\Users`` 컨트롤러에 대한 리소스 경로(route)를 처리합니다.

라우트 그룹에 특정 :doc:`filter <filters>`\ 를 사용할 수도 있습니다.
필터를 사용하면 컨트롤러 전후에 필터를 실행하며, 인증이나 api 로깅에 유용합니다.

.. literalinclude:: routing/025.php

필터 값은 **app/Config/Filters.php**\ 에 정의된 별칭(aliase)중 하나와 일치해야 합니다.

필요한 경우 그룹 내에 그룹을 중첩하여 보다 세밀한 구성을 할 수 있습니다.

.. literalinclude:: routing/026.php

위 예는 URL을 **admin/users/list**\ 로 처리할 것입니다. 

.. note:: 외부 ``group()``\ 에 전달된 옵션(예: ``namespace``\ 와 ``filter``)은 내부 ``group()`` 옵션과 병합(merge)되지 않습니다.

필터 또는 네임스페이스, 하위 도메인 등과 같은 다른 경로 구성 옵션을 적용하기 위해 경로를 그룹화할 수 있습니다. 
그룹에 접두사를 추가할 필요 없이 접두사 대신 빈 문자열을 전달할 수 있으며, 그룹의 경로는 그룹이 존재하지 않았지만 주어진 경로 구성 옵션을 사용하여 라우팅됩니다.

.. literalinclude:: routing/027.php

환경 제한(Restrictions)
===========================

특정 환경에서만 볼 수있는 일련의 경로를 만들 수 있습니다.
이를 통해 개발자는 테스트나 프로덕션 서버에서 접근할 수 없지만 로컬 컴퓨터에서 개발자만 사용할 수 있는 도구를 만들 수 있습니다.
``environment()`` 메소드에 환경 이름을 전달하여 이를 정의할 수 있습니다.
이렇게 폐쇄적으로 정의한 모든 경로는 주어진 환경에서만 액세스할 수 있습니다.

.. literalinclude:: routing/028.php

.. _reverse-routing:

리버스(Reverse) 라우팅
========================

리버스 라우팅은 링크와 연결해야 하는 모든 매개변수뿐만 아니라, 컨트롤러와 메소드를 정의하고, 라우터가 현재 경로를 조회하도록 할 수 있습니다.
이렇게 하면 어플리케이션 코드를 업데이트하지 않고도 경로 정의를 변경할 수 있습니다. 이것은 일반적으로 링크를 만들기 위해 뷰에서 사용됩니다.

예를 들어, 연결하려는 사진 갤러리에 대한 경로가 있는 경우 ``url_to()`` 헬퍼 함수를 사용하여 사용해야 하는 경로를 가져올 수 있습니다. 첫 번째 매개변수는 정규화된 컨트롤러 및 메소드입니다.
첫 번째 매개 변수는 초기 경로 자체를 작성할 때 사용하는 것과 같이 정규화된 컨트롤러 및 메소드이며 이중 콜론(``::``)으로 구분합니다.
경로로 전달되어야하는 모든 매개 변수는 다음 매개 변수에 전달됩니다.

.. literalinclude:: routing/029.php

.. _using-named-routes:

명명된 경로 사용
==================

어플리케이션의 취약성을 낮추기 위해 경로 이름을 지정할 수 있습니다.
이렇게하면 나중에 호출할 수있는 경로에 이름이 적용되며, 경로 정의가 변경되더라도 ``route_to()``\ 로 구축된 어플리케이션의 모든 링크를 수정하지 않아도 계속 작동합니다.
경로 이름과 함께 ``as`` 옵션을 전달하여 경로 이름을 지정합니다.

.. literalinclude:: routing/030.php

이렇게 하면 뷰를 더 읽기 쉽게 만들 수 있는 이점도 있습니다.

모든(any) HTTP 동사(verbs)가 있는 경로(route)
==============================================

모든 HTTP 동사에 대해 ``add()`` 메소드를 사용하여 경로(route)를 정의할 수 있습니다.

.. literalinclude:: routing/031.php

.. warning:: ``add()`` 방식이 편리하지만, 위에서 설명한 HTTP 동사 기반 경로를 사용하는 것이 더 안전합니다.
    :doc:`CSRF 보호 </libraries/security>`\ 는 **GET** 요청에 대해 보호하지 않으므로, ``add()`` 메소드에 지정된 URI가 GET 메소드로 액세스 가능한 경우 CSRF 보호가 작동하지 않습니다.

.. note:: HTTP 동사 기반 경로를 사용하면 현재 요청 방법과 일치하는 경로만 저장되므로, 검색할 일치 항목 경로가 줄어들어 성능이 약간 향상됩니다.

.. _command-line-only-routes:

커맨드 라인(command-line) 전용 라우트
===============================================

``cli()`` 메서드를 사용하여 명령줄에서만 작동하고 웹 브라우저에서는 액세스할 수 없는 라우트를 만들 수 있습니다.
HTTP 동사 기반 라우트 메소드로 생성된 모든 라우트는 CLI에서도 액세스할 수 없지만 ``add()`` 메소드로 생성된 라우트는 명령줄에서 계속 사용할 수 있습니다.

.. literalinclude:: routing/032.php

.. note::CLI를 통해 컨트롤러를 호출하는 대신 CLI 스크립트에 Spark 명령을 사용하는 것이 좋습니다.
    자세한 내용은 :doc:`../cli/cli_commands` 페이지를 참조하십시오.

.. warning:: :ref:`auto-routing`\ 을 활성화하고 명령 파일이 **app/Controllers**\ 에 있으면 HTTP를 통한 자동 라우팅으로 CLI 명령에 액세스할 수 있습니다.

전역 옵션
==============

경로(route)를 만드는 모든 메소드(add, get, post, :doc:`resource <restful>` etc)는 생성된 경로를 수정하거나 추가로 제한할 수 있는 옵션을 배열로 취할 수 있습니다.
``$options`` 배열은 항상 마지막 매개 변수(parameter)입니다

.. literalinclude:: routing/033.php

.. _applying-filters:

필터 적용
----------------

컨트롤러 전후에 실행할 필터를 제공하여 특정 경로의 동작을 변경할 수 있습니다.
이를 인증 또는 API 로깅에 이용하면 편리합니다.
제공되는 필터의 값은 문자열 또는 문자열 배열입니다.

* **app/Config/Filters.php**\ 에 정의된 별칭 필터.
* 필터 클래스이름

필터에 대한 자세한 내용은 :doc:`Controller filters <filters>`\ 를 확인하세요.

.. Warning:: **app/Config/Routes.php**(**app/Config/Filters.php**\ 가 아님) 파일에 경로에 대한 필터를 설정한 경우 자동 라우팅을 비활성화하는 것이 좋습니다.
    자동 라우팅을 활성화하면 구성된 경로와 다른 URL을 통해 컨트롤러에 액세스할 수 있으며, 이 경우 경로에 지정한 필터가 적용되지 않습니다.
    자동 라우팅을 비활성화하려면 :ref:`use-defined-routes-only`\ 를 확인하세요.

별칭(alias) 필터
^^^^^^^^^^^^^^^^^

별칭 필터는 **app/Config/Filters.php**\ 에 정의합니다.

.. literalinclude:: routing/034.php

별칭 필터의 ``before()`` 또는 ``after()`` 메소드에 전달할 인수를 제공할 수 있습니다.

.. literalinclude:: routing/035.php

클래스명 필터
^^^^^^^^^^^^^^^^

필터에 필터 클래스명을 지정합니다.

.. literalinclude:: routing/036.php

다중 필터
^^^^^^^^^^^^

.. important:: *다중 필터*\ 는 이전 버전과 호환되지 않아 기본적으로 비활성화되어 있으며, 사용시 별도의 설정이 필요합니다. 
    자세한 내용은 :ref:'upgrade-415-multiple-filters-for-a-route\ 를 확인하세요.

필터를 배열로 지정합니다.

.. literalinclude:: routing/037.php

.. _assigning-namespace:

네임스페이스 할당
---------------------

기본 네임스페이스가 컨트롤러(아래 참조) 앞에 추가되지만, ``namespace`` 옵션을 사용하여 다른 네임스페이스를 지정할 수도 있습니다.
값은 수정하려는 네임스페이스여야 합니다.

.. literalinclude:: routing/038.php

새로운 네임스페이스는 get, post 등과 같이 단일 경로를 만드는 메소드에 대해서만 적용됩니다.
다중 경로를 만드는 모든 메소드의 경우 새로운 네임스페이스를 해당 함수에 의해 생성된 모든 경로 또는 ``group()``\ 일 경우 클로저에 생성된 모든 경로에 연결됩니다.

호스트 이름(Hostname)으로 제한
-------------------------------------

"hostname" 옵션을 원하는 도메인과 함께 전달하여 경로(route) 그룹이 특정 도메인 또는 하위 도메인에서만 작동하도록 제한할 수 있습니다.

.. literalinclude:: routing/039.php

이 예는 도메인이 "accounts.example.com".과 정확히 일치하는 경우에만 작동하도록 허용합니다.
기본 사이트인 **example.com** 에서는 작동하지 않습니다.

서브도메인(Subdomain)으로 제한
----------------------------------------

``subdomain`` 옵션이 있으면 시스템은 해당 서브도메인에서만 경로(route)를 사용할 수 있도록 제한합니다.
경로는 서브도메인(subdomain)이 어플리케이션을 통해 보고 있는 영역인 경우에만 일치합니다.

.. literalinclude:: routing/040.php

값을 별표(``*``)로 설정하여 하위 도메인으로 제한할 수 있습니다.
하위 도메인이 없는 URL에서 보는 경우 일치하지 않습니다

.. literalinclude:: routing/041.php

.. important:: 시스템이 완벽하지 않으므로 프로덕션(production) 환경에서 사용하기 전에 특정 도메인에 대해 테스트해야 합니다.
    대부분의 도메인에서 제대로 작동하지만, 일부 도메인, 특히 도메인 자체에 마침표가 있는 경우(접미사 또는 www를 구분하는 데 사용되지 않음)에는 잘못 탐지할 수 있습니다.

일치하는 매개 변수(Parameter) 상쇄(offset)
--------------------------------------------

``offset`` 옵션을 사용하여 경로에서 일치하는 매개 변수를 숫자 값으로 상쇄(offset)할 수 있으며 값은 상쇄할 세그먼트 수입니다.

이 기능은 첫 번째 URI 세그먼트가 버전 번호인 API를 개발할 때 유용할 수 있습니다.
첫 번째 매개 변수가 언어(language) 문자열 인 경우에도 사용할 수 있습니다.

.. literalinclude:: routing/042.php

.. _routing-priority:

경로(Route) 우선 순위
*********************

경로는 정의된 순서대로 라우팅 테이블에 등록되며, URI에 액세스할 때 일치하는 첫 번째 경로가 실행됩니다.

.. note:: 경로(URI 경로)가 다른 핸들러로 두 번 이상 정의된 경우 첫 번째 정의된 경로만 등록됩니다.

:ref:`spark route <spark-routes>` 명령을 실행하여 라우팅 테이블에 등록된 경로를 확인할 수 있습니다.

경로 우선 순위 변경
=======================

모듈로 작업할 때 어플리케이션의 경로에 와일드카드가 포함되어 있으면 모듈 경로가 올바르게 처리되지 않습니다.
``priority`` 옵션을 사용하여 경로 처리의 우선순위를 낮추면 이 문제를 해결할 수 있습니다. 
매개 변수는 양의 정수와 0을 사용합니다. 
``priority``\ 에 지정된 숫자가 높을수록 처리 대기열의 경로 우선 순위가 낮아집니다.

.. literalinclude:: routing/043.php


이 기능을 비활성화하려면 매개 변수에 ``false``\ 를 사용하여 메소드를 호출합니다.

.. literalinclude:: routing/044.php

.. note:: 모든 경로의 우선 순위 기본값은 0입니다. 음수는 절대값으로 캐스팅입니다.

.. _routes-configuration-options:

경로(Route) 구성 옵션
****************************

RoutesCollection 클래스는 모든 경로에 영향을 주는 몇 가지 옵션을 제공하며 어플리케이션의 요구에 맞게 수정할 수 있습니다.
이 옵션들은 `/app/Config/Routes.php` 상단에 있습니다.

기본 네임스페이스
=================

컨트롤러를 경로에 일치시킬 때 라우터는 기본 네임스페이스 값을 경로에 지정된 컨트롤러 앞에 추가합니다. 기본 값은 ``App\Controllers``\ 입니다.

값을 빈 문자열(``''``)로 설정하면 완전히 네임스페이스가 지정된 컨트롤러를 지정하기 위해 각 경로(route)가 남습니다.

.. literalinclude:: routing/045.php

컨트롤러의 네임스페이스가 명시적으로 지정되지 않은 경우 이 값을 설정하여 컨트롤러에 네임스페이스를 지정할 수 있습니다.

.. literalinclude:: routing/046.php

URI 대시(-) 변환
====================

이 옵션을 사용하면 컨트롤러 및 메서드 URI 세그먼트에서 대시(``-``)를 밑줄(``_``)로 자동 교체하여 필요한 경우 추가 경로 항목을 저장할 수 있습니다.
대시(``-``)는 클래스 또는 메서드 이름의 유효한 문자가 아니므로, 사용하려고 하면 치명적인 오류를 일으킬 수 있습니다.

.. literalinclude:: routing/049.php

.. _use-defined-routes-only:

정의된 경로만 사용
=======================

v4.2.0부터 자동 라우팅은 기본적으로 비활성화됩니다.

자동 라우팅이 활성화된 경우 URI와 일치하는 정의된 경로(route)가 없으면 시스템은 해당 URI를 컨트롤러 및 메서드와 일치시키려고 시도합니다.

``setAutoRoute()`` 옵션을 ``false``\ 로 설정하여 자동 라우팅을 비활성화하고 사용자가 정의한 경로(route)만 사용하도록 제한할 수 있습니다.

.. literalinclude:: routing/050.php

.. warning:: :doc:`CSRF 보호 </libraries/security>`\ 는 **GET** 요청을 보호하지 않으므로, GET 메소드로 URI에 액세스하면 CSRF 보호가 작동하지 않습니다.

404 재정의
============

현재 URI와 일치하는 페이지를 찾을 수 없는 경우 시스템은 일반 404 뷰를 표시합니다.
``set404Override()`` 메소드로 수행할 작업을 지정하여 이를 변경할 수 있습니다.
값은 경로에 표시되는 것처럼 유효한 클래스/메서드(class/method) 이거나 클로저(Closure)일 수 있습니다.

.. literalinclude:: routing/051.php

.. note:: ``set404Override()`` 메소드는 응답 상태 코드를 ``404``\ 로 변경하지 않습니다.
    컨트롤러에서 설정시 상태 코드를 설정하지 않으면 기본 상태 코드 ``200``\ 이 반환됩니다. 상태 코드를 설정하는 방법에 대한 정보는 :php:func:`Response::setStatusCode() <setStatusCode>`\ 를 참조하십시오.

우선순위에 따른 경로 처리
============================

우선 순위에 따라 경로 대기열 처리를 활성화하거나 비활성화합니다. 우선 순위를 낮추는 것은 route 옵션에 정의되어 있습니다.
기본적으로 비활성화되어 있으며, 이 기능은 모든 경로(route)에 영향을 줍니다.
우선 순위를 낮추는 사용 예는 :ref:`routing-priority`\ 를 참조하세요.

.. literalinclude:: routing/052.php

.. _auto-routing-improved:

자동 라우팅(개선됨)
***********************

v4.2.0부터 더 안전하고 새로운 자동 라우팅이 도입되었습니다.

URI와 일치하는 정의된 경로가 없으면 시스템은 자동 라우팅이 활성화된 경우 해당 URI를 컨트롤러와 메서드로 일치시키려고 시도합니다.

.. important:: 보안상의 이유로 컨트롤러가 정의된 경로에서 사용되는 경우 자동 라우팅(개선됨)이 컨트롤러로 라우팅하지 않습니다.

자동 라우팅은 규칙에 따라 HTTP 요청을 자동으로 라우팅하고 해당 컨트롤러 메서드를 실행할 수 있습니다.

.. note:: 자동 라우팅(개선됨)은 기본적으로 비활성화되어 있습니다. 사용하려면 아래를 참조하십시오.

.. _enabled-auto-routing-improved:

자동 라우팅 활성화
====================

이를 사용하려면 **app/Config/Routes.php**\ 에서 ``setAutoRoute()`` 설정을 true로 변경해야 합니다.

::

    $routes->setAutoRoute(true);

그리고 **app/Config/Feature.php**\ 의 ``$autoRoutesImproved`` 속성을 ``true``\ 로 변경해야 합니다.

::

    public bool $autoRoutesImproved = true;

URI 세그먼트
==============

Model-View-Controller 접근 방식을 따르는 URL의 세그먼트는 일반적으로 다음과 같습니다.

::

    example.com/class/method/ID

1. 첫 번째 세그먼트는 호출되어야 하는 컨트롤러 **class**\ 를 나타냅니다.
2. 두 번째 세그먼트는 호출되어야 하는 클래스 **method**\ 를 나타냅니다.
3. 세 번째 세그먼트와 추가 세그먼트는 컨트롤러에 전달될 ID와 변수를 나타냅니다.

이 URI를 보세요.

::

    example.com/index.php/helloworld/hello/1

위의 예에서 **GET** 메소드로 HTTP 요청을 보내면 Auto Routing은 ``App\Controllers\Helloworld``\ 라는 컨트롤러를 찾고 ``getHello()`` 메소드를 실행하고 ``'1'``\ 을 첫 번째 인수로 사용합니다.

.. note:: 자동 라우팅(개선됨)에 의해 실행될 컨트롤러 메소드에는 ``getIndex()``, ``postCreate()``\ 와 같은 HTTP 동사(``get``, ``post``, ``put`` 등)가 접두사로 필요합니다. .

:ref:`Auto Routing in Controllers <controller-auto-routing-improved>`\ 에서 더 많은 정보를 확인하세요.

구성 옵션
=====================

이 옵션은 **app/Config/Routes.php** 상단에서 사용할 수 있습니다.

기본 컨트롤러
------------------

사용자가 사이트의 루트(예 : **example.com**)를 방문할 때 경로가 명시적으로 존재하지 않으면 사용할 컨트롤러는 ``setDefaultController()`` 메소드에 의해 설정된 값에 의해 결정됩니다.
기본값은 ``/app/Controllers/Home.php``\ 의 ``Home`` 컨트롤러입니다.

.. literalinclude:: routing/047.php

일치하는 경로를 찾지 못한 경우에도 기본 컨트롤러가 사용되며, URI는 컨트롤러 디렉토리를 가리킵니다.
예를 들어 사용자가 **example.com/admin**\ 을 방문하면 **/app/Controllers/admin/Home.php** 컨트롤러가 사용됩니다.

.. note:: 컨트롤러 이름으로 된 URI로 기본 컨트롤러에 액세스할 수 없습니다.
    기본 컨트롤러가 ``Home``\ 이면 **example.com/**\ 에 액세스할 수 있지만 **example.com/home**\ 는 액세스할 수 없습니다.

:ref:`Auto Routing in Controllers <controller-auto-routing-improved>`\ 에서 더 많은 정보를 확인하세요.

기본 메소드
--------------

이 메소드는 기본 컨트롤러 설정과 유사하게 작동하며, URI와 일치하는 컨트롤러를 발견되었으나, 메소드에 대한 세그먼트가 없을 때 사용됩니다.
기본값은 ``index``\ 입니다.

사용자가 **example.com/products**\ 를 방문하였을때 ``Products`` 컨트롤러가 존재한다면, ``Products::listAll()`` 메소드가 실행됩니다.

.. literalinclude:: routing/048.php

.. note:: 기본 메서드 이름으로 된 URI로 컨트롤러에 액세스할 수 없습니다.
    위의 예에서는 **example.com/products**\ 에 액세스할 수 있지만 **example.com/products/listall**\ 는 액세스할 수 없습니다.

.. _auto-routing:

자동 라우팅(레거시)
*********************

Auto Routing(Legacy)은 CodeIgniter 3의 라우팅 시스템입니다.
규칙에 따라 HTTP 요청을 자동으로 라우팅하고 해당 컨트롤러의 메소드를 실행할 수 있습니다.

모든 경로는 **app/Config/Routes.php** 파일에 정의되거나 :ref:`auto-routing-improved`\ 를 사용하는 것이 좋습니다.

.. warning:: 잘못된 설정 및 잘못된 코딩을 방지하기 위해 자동 라우팅(레거시) 기능을 사용하지 않는 것이 좋습니다.
    컨트롤러 필터 또는 CSRF 보호가 우회되는 취약한 앱을 만들기 쉽습니다.

.. important:: 자동 라우팅(레거시)은 **any** HTTP 메서드를 사용하여 HTTP 요청을 컨트롤러 메서드로 라우팅합니다.

자동 라우팅 활성화(레거시)
============================

v4.2.0부터 자동 라우팅은 기본적으로 비활성화되어 있습니다.

이를 사용하려면 **app/Config/Routes.php**\ 의 ``setAutoRoute()`` 설정을 true로 변경해야 합니다.

::

    $routes->setAutoRoute(true);

URI 세그먼트(레거시)
=====================

Model-View-Controller 접근 방식을 따르는 URL의 세그먼트는 일반적으로 다음과 같습니다.

::

    example.com/class/method/ID

1. 첫 번째 세그먼트는 호출되어야 하는 컨트롤러 **class**\ 를 나타냅니다.
2. 두 번째 세그먼트는 호출되어야 하는 클래스 **method**\ 를 나타냅니다.
3. 세 번째 세그먼트와 추가 세그먼트는 컨트롤러에 전달될 ID와 변수를 나타냅니다.

다음 URI를 확인하세요.

::

    example.com/index.php/helloworld/index/1

위의 예에서 CodeIgniter는 **Helloworld.php**\ 라는 컨트롤러를 찾고 ``'1'``\ 을 첫 번째 인수로 전달하여 ``index()`` 메소드를 실행합니다.

자세한 내용은 :ref:`Auto Routing (Legacy) in Controllers <controller-auto-routing>`\ 를 참조하세요.

구성 옵션(레거시)
==============================

이 옵션은 **app/Config/Routes.php** 상단에서 사용할 수 있습니다.

기본 컨트롤러(레거시)
---------------------------

사용자가 사이트의 루트(예: example.com)를 방문할 때 사용할 컨트롤러는 명시적 경로가 존재하지 않으면 ``setDefaultController()`` 메소드로 설정한 값에 의해 결정됩니다.
기본값은 **app/Controllers/Home.php** 컨트롤러의 ``Home``\ 입니다.

.. literalinclude:: routing/047.php

기본 컨트롤러는 일치하는 경로가 없고 URI가 컨트롤러 폴더의 하위 폴더를 가리킬 때도 사용됩니다.
예를 들어 사용자가 **example.com/admin**\ 을 방문하면 **app/Controllers/Admin/Home.php**\ 에서 컨트롤러가 사용됩니다.

자세한 내용은 :ref:`Auto Routing in Controllers <controller-auto-routing>`\ 를 참조하세요.

기본 메소드(레거시)
-----------------------

기본 컨트롤러 설정과 유사하게 작동하지만 URI와 일치하는 세그먼트가 없는 컨트롤러의 메소드에 사용되는 기본 메소드를 결정하는 데 사용됩니다. 기본값은 ``index``\ 입니다.

이 예에서 **example.com/products**\ 는 ``Products`` 컨트롤러의 ``Products::listAll()`` 메소드가 실행됩니다.

.. literalinclude:: routing/048.php

경로 확인
*****************

CodeIgniter는 모든 경로를 표시하는 :doc:`command </cli/spark_commands>`\ 가 있습니다.

.. _spark-routes:

routes
======

모든 경로 및 필터를 표시합니다.

::

    > php spark routes

출력은 다음과 같습니다.

.. code-block:: none

    +--------+------------------+------------------------------------------+----------------+-----------------------+
    | Method | Route            | Handler                                  | Before Filters | After Filters         |
    +--------+------------------+------------------------------------------+----------------+-----------------------+
    | GET    | /                | \App\Controllers\Home::index             | invalidchars   | secureheaders toolbar |
    | GET    | feed             | (Closure)                                | invalidchars   | secureheaders toolbar |
    | CLI    | ci(.*)           | \CodeIgniter\CLI\CommandRunner::index/$1 |                |                       |
    | auto   | /                | \App\Controllers\Home::index             | invalidchars   | secureheaders toolbar |
    | auto   | home             | \App\Controllers\Home::index             | invalidchars   | secureheaders toolbar |
    | auto   | home/index[/...] | \App\Controllers\Home::index             | invalidchars   | secureheaders toolbar |
    +--------+------------------+------------------------------------------+----------------+-----------------------+

*Method* 열은 경로(route)의 수신 대기하는 HTTP 메소드를 보여줍니다.
``auto``\ 는 경로가 Auto Routing(Legacy)에 의해 발견되었음을 의미하며, **app/Config/Routes.php**\ 에 정의되어 있지 않습니다.

*Route* 열은 일치시킬 URI 경로(path)를 보여줍니다. 정의된 경로(route)의 경로(route)는 정규식으로 표현됩니다.
그러나 자동 라우팅 경로(route)에서 ``[/...]``\ 는 세그먼트 수를 나타냅니다.

자동 라우팅(개선됨)을 사용하는 경우 출력은 다음과 같습니다.

.. code-block:: none

    +-----------+-------------------------+------------------------------------------+----------------+---------------+
    | Method    | Route                   | Handler                                  | Before Filters | After Filters |
    +-----------+-------------------------+------------------------------------------+----------------+---------------+
    | CLI       | ci(.*)                  | \CodeIgniter\CLI\CommandRunner::index/$1 |                |               |
    | GET(auto) | product/list/../..[/..] | \App\Controllers\Product::getList        |                | toolbar       |
    +-----------+-------------------------+------------------------------------------+----------------+---------------+

*Method*는 ``GET(auto)``\ 와 같습니다. *Route* 열의 ``/..``\ 는 하나의 세그먼트를 나타냅니다.
``[/..]``\ 는 선택 사항임을 나타냅니다.

.. note:: 자동 라우팅이 활성화된 경우 ``home`` 경로가 있는 경우 ``Home``, ``hOme``, ``hoMe``, ``HOME``\ 등으로 액세스할 수 있습니다.  그러나 명령은 ``home``\ 만 표시합니다.

.. important:: 시스템이 완벽하지 않습니다. 사용자 지정 자리 표시자를 사용하는 경우 *필터*\ 가 올바르지 않을 수 있습니다. 그러나 **app/Config/Routes.php**\ 에 정의된 필터는 항상 올바르게 표시됩니다.
