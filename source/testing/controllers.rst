###################
컨트롤러 테스트
###################

컨트롤러를 테스트하는것은 몇 가지 새로운 헬퍼 클래스와 특성(trait)으로 편리합니다. 
컨트롤러를 테스트는 전체 어플리케이션 부트스트랩 프로세스를 실행하지 않고도 컨트롤러내에서 코드를 실행할 수 있습니다.
종종 :doc:`기능 테스트 도구 <feature>`\ 를 사용하는 것이 더 간단하며 이 기능은 필요할 때 사용할 수 있습니다.

.. note:: 전체 프레임워크가 부트스트랩되지 않았으므로 이 방법으로 컨트롤러를 테스트할 수 없는 경우가 있습니다.

.. contents::
    :local:
    :depth: 2

헬퍼 특성(Trait)
==================

기본 테스트 클래스중 하나를 사용할 수 있지만 테스트할 때는 ``ControllerTestTrait`` 특성을 사용합니다.

.. literalinclude:: controllers/001.php

특성을 포함하면 요청 및 응답 클래스, 요청 본문, URI등에 대해 환경 설정을 할 수 있습니다.
``controller()`` 메소드에 컨트롤러의 클래스 이름을 전달하여 사용할 컨트롤러를 지정합니다.
마지막으로 실행할 메소드 이름을 매개 변수로 ``execute()`` 메소드를 호출합니다.

.. literalinclude:: controllers/002.php

헬퍼 메소드
==============

controller($class)
------------------

테스트할 컨트롤러의 클래스 이름을 지정합니다. 
첫 번째 매개 변수는 정규화된 클래스 이름이어야 합니다 (네임스페이스 포함).

.. literalinclude:: controllers/003.php

execute(string $method, ...$params)
-----------------------------------

컨트롤러 내에서 지정된 메소드를 실행합니다. 
첫 번재 매개 변수는 실행할 메소드의 이름입니다.

.. literalinclude:: controllers/004.php

두 번째 또는 후속 매개변수를 지정하여 컨트롤러 메소드에 전달할 수 있습니다.
응답 자체를 검사하기 위한 많은 루틴을 제공하는 새로운 헬퍼 클래스를 리턴합니다.
자세한 내용은 아래를 참조하십시오.

withConfig($config)
-------------------

다른 설정으로 테스트하기 위해 수정된 버전의 **Config\App.php**\ 를 전달할 수 있습니다.

.. literalinclude:: controllers/005.php

다른 설정을 제공하지 않으면 어플리케이션의 앱 구성 파일이 사용됩니다.

withRequest($request)
---------------------

테스트 요구에 맞는 **IncomingRequest** 인스턴스를 제공합니다.

.. literalinclude:: controllers/006.php

인스턴스를 제공하지 않으면 기본 어플리케이션 값을 가진 새로운 IncomingRequest 인스턴스가 컨트롤러로 전달됩니다.

withResponse($response)
-----------------------

**Response** 인스턴스를 제공 할 수 있습니다

.. literalinclude:: controllers/007.php

Response를 제공하지 않으면 기본 어플리케이션 값을 가진 새 Response 인스턴스가 컨트롤러에 전달됩니다.

withLogger($logger)
-------------------

**Logger** 인스턴스를 제공할 수 있습니다

.. literalinclude:: controllers/008.php

Logger를 제공하지 않으면 기본 어플리케이션 값을 가진 새 Logger 인스턴스가 컨트롤러에 전달됩니다..

withURI(string $uri)
--------------------

컨트롤러를 실행할 때 클라이언트가 방문한 URL을 시뮬레이트하는 새 URI를 제공합니다.
컨트롤러내에서 URI 세그먼트를 확인해야 하는 경우 유용합니다. 
유일한 매개 변수는 유효한 URI를 나타내는 문자열입니다.

.. literalinclude:: controllers/009.php

뜻밖의 일을 피하려면 테스트할 때 항상 URI를 제공하는 것이 좋습니다.

withBody($body)
---------------

요청에 대한 사용자 정의 본문을 제공할 수 있습니다.
이는 JSON 값을 본문으로 설정해야하는 API 컨트롤러를 테스트할 때 유용합니다.
유일한 매개 변수는 요청의 본문을 나타내는 문자열입니다

.. literalinclude:: controllers/010.php

응답(Response) 확인
=====================

``ControllerTestTrait::execute()``\ 는 ``TestResponse`` 인스턴스를 반환합니다. 
이 클래스를 사용하여 테스트 케이스에 추가 어썰션 및 검증을 수행하는 방법은 :doc:`Testing Responses <response>`\ 를 참조하십시오.

필터 테스트
==============

컨트롤러 테스트와 마찬가지로 이 프레임워크는 사용자 정의 :doc:`Filters </incoming/filters>` 및 프로젝트에서 이를 라우팅에 사용하는 테스트를 만드는 데 도움이 되는 도구를 제공합니다.

Helper Trait
----------------

컨트롤러 테스터와 마찬가지로 이러한 기능을 사용하려면 테스트 케이스에 ``FilterTestTrait``\ 를 포함해야 합니다.

.. literalinclude:: controllers/011.php

Configuration
-------------

컨트롤러 테스트 ``FilterTestTrait``\ 와 논리적으로 겹치기 때문에 동일한 클래스에서 필요한 경우 ``ControllerTestTrait``\ 와 함께 작동하도록 설계되었습니다.
특성(Trait)이 포함되면 ``ControllerTestTrait``\ 는 ``setUp`` 메소드를 감지하고 테스트에 필요한 모든 구성 요소를 준비합니다.
특별한 구성이 필요한 경우 지원 메소드를 호출하기 전에 속성을 변경할 수 있습니다.

* ``$request`` A prepared version of the default ``IncomingRequest`` service
* ``$response`` A prepared version of the default ``ResponseInterface`` service
* ``$filtersConfig`` The default ``Config\Filters`` configuration (note: discovery is handle by ``Filters`` so this will not include module aliases)
* ``$filters`` An instance of ``CodeIgniter\Filters\Filters`` using the three components above
* ``$collection`` A prepared version of ``RouteCollection`` which includes the discovery of ``Config\Routes``

기본 구성은 대개 "실시간" 프로젝트를 가장 가깝게 에뮬레이트하므로 테스트에 가장 적합하지만, (예를 들어) 필터링되지 않은 경로에 실수로 트리거되는 필터를 시뮬레이션하려는 경우 구성에 추가할 수 있습니다.

.. literalinclude:: controllers/012.php

경로 확인
---------------

헬퍼 함수 ``getFiltersForRoute()``\ 는, 제공된 경로를 시뮬레이션하고 컨트롤러 또는 라우팅 코드를 실제로 실행하지 않고 지정된 위치("before" 또는 "fore")\ 에 대해 실행되었을 모든 필터 목록을 반환합니다.
이는 컨트롤러 및 HTTP 테스트보다 성능 면에서 큰 이점이 있습니다.

.. php:function:: getFiltersForRoute($route, $position)

    :param	string	$route: 확인할 URI
    :param	string	$position: 확인할 필터 메소드, "before" 또는 "after"
	:returns:	실행될 각 필터에 대한 별칭
	:rtype:	string[]

    Usage example

    .. literalinclude:: controllers/013.php

필터 메서드 호출
----------------------

구성에 설명된 속성은 다른 테스트의 간섭이나 간섭 없이 최대 성능을 보장하도록 모두 설정됩니다.
다음 헬퍼 함수는 이러한 속성을 사용하여 호출 가능한 메소드를 반환하여 필터 코드를 안전하게 테스트하고 결과를 확인합니다.

.. php:function:: getFilterCaller($filter, $position)

    :param	FilterInterface|string	$filter: 필터 인스턴스, 클래스 또는 별칭
    :param	string	$position: 실행할 필터 메소드, "before" 또는 "after"
    :returns:	시뮬레이션된 필터 이벤트를 실행하기 위한 호출 가능한 메소드
    :rtype:	Closure
    
    Usage example
    
    .. literalinclude:: controllers/014.php
    
    ``Closure``\ 가 필터 메서드에 전달되는 입력 매개 변수를 어떻게 취할 수 있는지 확인하십시오.

Assertions
----------

``FilterTestTrait``\ 의 헬퍼 메소드외에도 테스트 메소드를 간소화하기 위한 몇 가지 어설션이 함께 제공됩니다.

assertFilter()
^^^^^^^^^^^^^^

``assertFilter()`` 메소드는 지정된 위치 경로가 필터를 사용하는지 확인합니다.(alias 기준)

.. literalinclude:: controllers/015.php

assertNotFilter()
^^^^^^^^^^^^^^^^^

``assertNotFilter()`` 메소드는 지정된 경로가 필터를 사용하지 않는지 확인합니다.(alias 기준)

.. literalinclude:: controllers/016.php

assertHasFilters()
^^^^^^^^^^^^^^^^^^

``assertHasFilters()`` 메소드는 지정된 위치의 경로에 하나 이상의 필터 세트가 있는지 확인합니다.

.. literalinclude:: controllers/017.php

assertNotHasFilters()
^^^^^^^^^^^^^^^^^^^^^

``assertNotHasFilters()`` 메소드는 지정된 위치에 설정된 필터가 없는지 확인합니다.

.. literalinclude:: controllers/018.php
