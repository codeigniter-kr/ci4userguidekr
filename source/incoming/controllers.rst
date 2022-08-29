####################
컨트롤러(Controller)
####################

컨트롤러는 HTTP 요청 처리 방법을 결정하며, 어플리케이션의 핵심입니다.

.. contents::
    :local:
    :depth: 2


컨트롤러란 무엇입니까?
***********************

컨트롤러는 HTTP 요청을 처리하는 간단한 클래스 파일입니다. :doc:`URI Routing <routing>`\ 은 URI를 컨트롤러와 연결합니다.

생성하는 모든 컨트롤러는 ``BaseController`` 클래스를 확장해야 합니다.
이 클래스는 모든 컨트롤러에서 사용할 수 있는 몇 가지 기능을 제공합니다.

생성자(Constructor)
*******************

CodeIgniter의 컨트롤러에는 특별한 생성자 ``initController()``\ 가 있습니다.
PHP의 생성자 ``__construct()`` 실행 후 프레임워크에 의해 호출됩니다.

``initController()``\ 를 재정의할 때 ``parent::initController($request, $response, $logger);``\ 를 추가하는 것을 잊지 마십시오.

.. literalinclude:: controllers/023.php

.. important:: 생성자에서 ``return``을 사용할 수 없습니다. 따라서 ``return redirect()->to('route');``\ 는 작동하지 않습니다.

``initController()`` 메소드는 다음 세 가지 속성을 설정합니다.


포함된 속성
*******************

CodeIgniter의 컨트롤러는 다음 3가지 속성을 제공합니다.

**Request Object**

애플리케이션의 기본 :doc:`Request Instance </incoming/incomingrequest>`\ 는 클래스 속성 ``$this->request``\ 로 사용할 수 있습니다.

**Response Object**

애플리케이션의 기본 :doc:`Response Instance </outgoing/response>`\ 는 클래스 속성 ``$this->response``\ 로 사용할 수 있습니다.

**Logger Object**

:doc:`Logger <../general/logging>` 클래스의 인스턴스는 클래스 속성 ``$this->logger``\ 로 사용할 수 있습니다.

헬퍼
=======

헬퍼 파일 배열을 클래스 속성으로 정의할 수 있습니다.
컨트롤러가 로드될 때마다 속성으로 정의된 헬퍼 파일이 자동으로 메모리에 로드되어 컨트롤러 내 어디서나 해당 메소드를 사용할 수 있습니다.

.. literalinclude:: controllers/001.php

.. _controllers-validating-data:

forceHTTPS
**********

모든 컨트롤러에서 HTTPS를 통해 메서드에 강제로 액세스하도록 하는 편리한 메소드를 사용할 수 있습니다.

.. literalinclude:: controllers/002.php

이 메소드는 기본적으로 **HTTP Strict Transport Security** 헤더를 지원하는 최신 브라우저에서 1년 동안 HTTP 호출을 HTTPS 호출로 변환하도록 합니다.
첫 번째 매개변수로 기간(초)을 전달하여 수정할 수 있습니다.

.. literalinclude:: controllers/003.php

.. note:: :doc:`time-based constants </general/common_functions>`\ 에서 정의된 ``YEAR``, ``MONTH`` 등을 사용할 수 있습니다.

.. _controller-validate:

데이터 검증
***************

$this->validate()
=================

컨트롤러는 데이터 검사를 단순화하기 위해 ``validate()`` 메소드도 제공합니다.
이 메소드는 첫 번째 매개변수에 검증 규칙 배열과 옵션으로 유효하지 않은 항목에 대해 표시할 사용자 지정 오류 메시지 배열을 두 번째 매개변수로 허용합니다.
검증은 내부적으로 컨트롤러의 ``$this->request`` 인스턴스를 사용하여 검증할 데이터를 가져옵니다.
:doc:`Validation Library </libraries/validation>` 문서에는 검증 규칙 및 메시지 배열 형식과 사용 가능한 규칙에 대한 세부 정보가 있습니다.

.. literalinclude:: controllers/004.php

구성 파일에 규칙을 유지하는 것이 더 간단하다고 생각된다면 ``$rules`` 배열을 ``Config\Validation.php``\ 에 정의된 그룹 이름으로 바꿀 수 있습니다.

.. literalinclude:: controllers/005.php

.. note:: 유효성 검사는 모델에서 자동으로 처리될 수도 있지만 때로는 컨트롤러에서 수행하는 것이 더 쉽습니다. 선택은 당신에게 달려 있습니다.

$this->validateData()
=====================

``$this->validateData()`` 메소드를 사용하면 컨트롤러의 메소드 매개변수와 기타 사용자 정의 데이터를 확인할 수 있습니다.
이 메소드는 유효성을 검사할 데이터 배열을 첫 번째 매개변수로 허용합니다.

.. literalinclude:: controllers/006.php

메소드 보호
*************

특정 메서드를 공개하지 않고 숨기고 싶은 메소드는 ``private`` 또는 ``protected``로 선언합니다.
그러면 URL 요청에 의해 접근하는 것을 방지할 수 있습니다. 
예를 들어 ``Helloworld`` 컨트롤러에 대해 다음과 같이 메소드를 정의하면

.. literalinclude:: controllers/007.php

메소드에 대한 경로(``helloworld/utility``)를 정의합니다. 다음 URL을 사용하여 액세스하려고 하면 작동하지 않습니다.

::

    example.com/index.php/helloworld/utility

자동 라우팅(Auto-routing)도 작동하지 않습니다.

.. _controller-auto-routing-improved:

Auto Routing (개선)
************************

v4.2.0부터 더 안전한 새로운 자동 라우팅이 도입되었습니다.

이 섹션에서는 새로운 자동 라우팅의 기능에 대해 설명합니다.
HTTP 요청을 자동으로 라우팅하고 경로 정의 없이 해당 컨트롤러 메서드를 실행합니다.

v4.2.0부터 자동 라우팅은 기본적으로 비활성화되어 있습니다. 
활성화하려면 :ref:`enabled-auto-routing-improved`\ 를 참조하십시오.

다음 URI를 고려하십시오.

::

    example.com/index.php/helloworld/

위의 예에서 CodeIgniter는 자동 라우팅(Auto Routing)이 활성화되었을 때 ``App\Controllers\Helloworld``\ 라는 이름의 컨트롤러를 찾아 로드하려고 시도합니다.

.. note:: 컨트롤러의 짧은 이름이 URI의 첫 번째 세그먼트와 일치하면 로드됩니다.

Hello World!
============

이제 간단한 컨트롤러를 만들어 실제 작동하는 모습을 보도록 하겠습니다. 

텍스트 편집기를 사용하여 **Hellowworld.php**\ 라는 파일을 만들고 다음 코드를 입력합니다.
``Helloworld`` 컨트롤러가 ``BaseController``\ 를 확장하고 있음을 알 수 있습니다.
BaseController 기능이 필요하지 않은 경우 ``CodeIgniter\\Controller``\ 를 확장(extend)합니다.

BaseController는 구성 요소를 로드하고 모든 사용자가 필요로 하는 기능을 수행할 수 있는 편리한 장소를 제공합니다.
새로 만드는 모든 컨트롤러에서 이 클래스를 확장할 수 있습니다.

.. literalinclude:: controllers/020.php

이 파일을 **/app/Controllers/** 디렉토리에 저장합니다.

.. important:: 파일 이름은 **Helloworld.php**\ 여야 하며 ``H``\ 는 대문자여야 합니다. 자동 라우팅을 사용할 때 컨트롤러 클래스 이름은 대문자로 시작해야 하며 첫 번째 문자만 대문자일 수 있습니다.

.. important:: Auto Routing(개선)에 의해 실행될 컨트롤러 메소드는 ``getIndex()``, ``postCreate()``\ 와 같이 접두사로 HTTP 동사(``get``, ``post``, ``put`` 등)가 필요합니다.

이제 이와 유사한 URL을 사용하여 사이트를 방문하십시오.

::

    example.com/index.php/helloworld

제대로 했다면 결과는

::

    Hello World!

올바른 예

.. literalinclude:: controllers/009.php

틀린 예1

.. literalinclude:: controllers/010.php

틀린 예2

.. literalinclude:: controllers/011.php

여러분이 작성한 컨트롤러가 모든 메소드를 상속받을 수 있도록 상위 컨트롤러 클래스를 확장해야 합니다.

.. note:: 시스템은 정의된 경로에 대해 일치 항목을 찾지 못한 경우 **app/Controllers/**\ 의 폴더/파일에 대해 각 세그먼트를 일치시켜 컨트롤러와 URI를 일치시키려고 시도합니다.
    그렇기 때문에 폴더/파일은 반드시 대문자로 시작하고 나머지는 소문자로 시작해야 합니다.

    다음은 `PSR-4: Autoloader`\ 에 기반으로 한 예입니다. 

    .. literalinclude:: controllers/012.php

    다른 명명 규칙을 사용하고 싶다면 :ref:`Defined Route Routing <defined-route-routing>`\ 을 사용하여 수동으로 정의해야 합니다.

메소드
=========

위 예제에서 메소드 이름은 ``getIndex()``\ 입니다.
URI의 **두 번째 세그먼트**\ 가 비어 있으면 (HTTP 동사 + ``Index()``) 메소드가 로드됩니다.

**URI의 두 번째 세그먼트는 컨트롤러에서 호출할 메소드를 결정합니다.**

컨트롤러에 새로운 메소드를 추가해 봅시다.

.. literalinclude:: controllers/021.php


이제 다음 URL을 로드하여 ``getComment()`` 메소드를 봅니다.

::

    example.com/index.php/helloworld/comment/

새로운 메시지가 표시됩니다.

.. warning:: 보안상의 이유로 모든 새로운 유틸리티 메소드는 ``protected`` 또는 ``private``\ 로 선언해야 합니다.

메소드에 URI 세그먼트 전달
====================================

URI에 세 개 이상의 세그먼트가 포함되어 있으면 메소드에 매개 변수(parameters)로 전달됩니다.

예를 들어 이와 같은 URI가 있다고 가정 해 봅시다.::

    example.com/index.php/products/shoes/sandals/123

메소드에 URI 세그먼트 3과 세그먼트 4가 전달됩니다. (``'sandals'`` 와 ``'123'``)

.. literalinclude:: controllers/022.php

.. important:: :doc:`URI 라우팅 <routing>` 기능을 사용하는 경우 메소드에 전달 된 세그먼트가 다시 라우팅됩니다.

기본 컨트롤러 정의
=============================

CodeIgniter는 URI가 아닐 때 기본 컨트롤러를 로드하도록 지시할 수 있습니다.
사이트 루트 URL만 요청되는 경우 ``Helloworld`` 컨트롤러가 로드되도록 시도해 보겠습니다.

기본 컨트롤러를 지정하려면 **app/Config/Routes.php** 파일을 열고 아래 부분을 수정하십시오.

.. literalinclude:: controllers/015.php

여기서 'Helloworld'는 사용하려는 기본 컨트롤러 클래스의 이름입니다.
**Routes.php**\ 의 라인 코멘트 "Route Definitions" 섹션 몇 줄 아래 있습니다.

.. literalinclude:: controllers/016.php

URI 세그먼트를 지정하지 않고 사이트를 탐색하면 "Hello World" 메시지가 표시됩니다.

.. note:: ``$routes->get('/', 'Home::index');``\ 은 "실제" 앱에서 사용하는 최적화된 경로입니다. 시연 목적으로 이 기능을 사용하고 싶지 않습니다. ``$routes->get()``\ 에 대한 설명은 :doc:`URI 라우팅 <routing>`\ 을 살펴보세요.


자세한 내용은 :doc:`URI 라우팅 <routing>` 설명서의 :ref:`routes-configuration-options` 섹션을 참조하십시오.

컨트롤러를 하위 디렉터리로 구성
================================================

대규모 애플리케이션을 구축하는 경우 컨트롤러를 하위 디렉터리로 계층적으로 구성하거나 구조화할 수 있습니다.
CodeIgniter는 이를 허용합니다.

기본 **app/Controllers/** 아래에 하위 디렉터리를 만들고 그 안에 컨트롤러 클래스를 배치하기만 하면 됩니다.

.. important:: 폴더 이름은 반드시 대문자로 시작해야 하며 첫 번째 문자만 대문자일 수 있습니다.

이 기능을 사용할 때 URI의 첫 번째 세그먼트는 폴더를 지정해야 합니다.
예를 들어 아래와 같은 컨트롤러가 있다고 가정해 보겠습니다.

::

    app/Controllers/Products/Shoes.php

위의 컨트롤러 호출 URI는 다음과 같습니다.

::

    example.com/index.php/products/shoes/show/123

.. note:: **app/Controllers/**\ 와 **public/**\ 에 같은 이름의 디렉토리를 가질 수 없습니다.
     디렉토리가 있으면 웹 서버가 디렉토리를 검색하고 CodeIgniter로 라우팅되지 않기 때문입니다.

각 하위 디렉터리에는 URL에 *하위 디렉터리만* 호출될 때 사용될 기본 컨트롤러가 포함될 수 있습니다.
**app/Config/Routes.php** 파일에 지정된 기본 컨트롤러의 이름과 일치하는 컨트롤러를 그 곳에 넣으면 됩니다.

CodeIgniter는 또한 :ref:`Defined Route Routing <defined-route-routing>`\ 을 사용하여 URI를 매핑할 수 있습니다.

.. _controller-auto-routing:

Auto Routing (기존)
*********************

이 섹션에서는 CodeIgniter 3의 라우팅 시스템인 Auto Routing(기존)의 기능에 대해 설명합니다.
HTTP 요청을 자동으로 라우팅하고 경로 정의 없이 해당 컨트롤러 메서드를 실행합니다.
Auto Routing은 기본적으로 비활성화되어 있습니다.

.. warning:: 잘못된 구성 및 잘못된 코딩을 방지하려면 Auto Routing(기존)을 사용하지 않는 것이 좋습니다.
     컨트롤러 필터 또는 CSRF 보호가 우회되는 취약한 앱을 만들기 쉽습니다.

.. important:: Auto Routing(기존)은 **모든** HTTP 메서드를 사용하여 HTTP 요청을 컨트롤러 메서드로 라우팅합니다.

다음 URI를 고려해봅시다.

::

    example.com/index.php/helloworld/

위의 예에서 CodeIgniter는 **Helloworld.php**\ 라는 컨트롤러를 찾아 로드하려고 시도합니다.

.. note:: 컨트롤러의 짧은 이름이 URI의 첫 번째 세그먼트와 일치하면 로드됩니다.

Hello World!
============

작동하는 모습을 볼 수 있도록 간단한 컨트롤러를 만들어 보겠습니다.
텍스트 편집기를 사용하여 **Helloworld.php**\ 라는 파일을 만들고 다음 코드를 그 안에 넣습니다.
``Helloworld`` 컨트롤러가 ``BaseController``\ 를 확장하고 있음을 알 수 있습니다.
BaseController의 기능이 필요하지 않다면 ``CodeIgniter\Controller``\ 를 확장할 수 있습니다.

BaseController는 구성 요소를 로드하고 모든 컨트롤러에 필요한 기능을 수행하기 위한 편리한 장소를 제공합니다.
모든 새 컨트롤러에서 이 클래스를 확장할 수 있습니다.

보안상의 이유로 새 유틸리티 메소드는 ``protected`` 또는 ``private``\ 로 선언해야 합니다.

.. literalinclude:: controllers/008.php

그런 다음 파일을 **app/Controllers/** 디렉터리에 저장합니다.

.. important:: 파일 이름은 **Helloworld.php**\ 여야 하며 ``H``\ 는 대문자여야 합니다. 자동 라우팅을 사용할 때 컨트롤러 클래스 이름은 대문자로 시작해야 하며 첫 번째 문자만 대문자일 수 있습니다.

이제 다음과 유사한 URL을 사용하여 사이트를 방문하십시오.

::

    example.com/index.php/helloworld

다음과 같은 결과를 확인할 수 있습니다.

::

    Hello World!

올바른 예

.. literalinclude:: controllers/009.php

틀린 예1

.. literalinclude:: controllers/010.php

틀린 예2

.. literalinclude:: controllers/011.php

또한 컨트롤러가 모든 메서드를 상속할 수 있도록 부모 컨트롤러 클래스를 확장하는지 항상 확인하십시오.

.. note::
    시스템은 정의된 경로에 대해 일치 항목을 찾지 못한 경우 **app/Controllers/**\ 의 폴더/파일에 대해 각 세그먼트를 일치시켜 컨트롤러와 URI를 일치시키려고 시도합니다.
    그렇기 때문에 폴더/파일은 반드시 대문자로 시작하고 나머지는 소문자로 시작해야 합니다.

     다음은 PSR-4 Autoloader를 기반으로 한 예입니다.

    .. literalinclude:: controllers/012.php

    다른 명명 규칙을 원하면 :ref:`Defined Route Routing <defined-route-routing>`\ 을 사용하여 수동으로 정의해야 합니다.

메소드
=======

위의 예에서 메소드 이름은 ``index()``입니다. 
URI의 **두 번째 세그먼트**\ 가 비어 있으면 ``index()`` 메소드가 항상 기본적으로 로드됩니다.
"Hello World" 메시지를 표시하는 또 다른 방법은 다음과 같습니다.

::

    example.com/index.php/helloworld/index/

**URI의 두 번째 세그먼트는 컨트롤러에서 호출되는 메소드를 결정합니다.**

컨트롤러에 새 메서드를 추가해 봅시다.

.. literalinclude:: controllers/013.php

이제 다음 URL을 로드하여 comment 메소드를 확인하세요.

::

    example.com/index.php/helloworld/comment/

새 메시지가 표시되어야 합니다.

메소드에 URI 세그먼트 전달하기
====================================

URI에 세 개 이상의 세그먼트가 포함되어 있으면 매개변수로 메소드에 전달됩니다.

예를 들어 다음과 같은 URI가 있다고 가정해 보겠습니다.

::

    example.com/index.php/products/shoes/sandals/123

메소드에 URI 세그먼트 3\ 과 4로 전달됩니다. (``'sandals'``\ 와 ``'123'``):

.. literalinclude:: controllers/014.php

기본 컨트롤러 정의
=============================


CodeIgniter는 URI가 없을 때 기본 컨트롤러를 로드하도록 지시할 수 있으며, 이는 사이트 루트 URL만 요청되는 경우와 마찬가지입니다.
``Helloworld`` 컨트롤러로 시도해 보겠습니다.

기본 컨트롤러를 지정하려면 **app/Config/Routes.php** 파일을 열고 다음 변수를 설정하세요.

.. literalinclude:: controllers/015.php

여기서 ``Helloworld``\ 는 사용하려는 컨트롤러 클래스의 이름입니다.

"Route Definitions" 섹션의 **Routes.php** 아래 몇 줄에서 다음 줄을 주석 처리합니다.

.. literalinclude:: controllers/016.php

이제 URI 세그먼트를 지정하지 않고 사이트를 탐색하면 "Hello World" 메시지가 표시됩니다.

.. note:: ``$routes->get('/', 'Home::index');`` 행은 "실제" 앱에서 사용하려는 최적화입니다. 그러나 데모 목적으로 해당 기능을 사용하고 싶지 않습니다. ``$routes->get()``\ 은 :doc:`URI Routing <routing>`\ 에 설명되어 있습니다.

자세한 내용은 :doc:`URI Routing <routing>` 문서의 :ref:`routes-configuration-options` 섹션을 참조하세요.

컨트롤러를 하위 디렉터리로 구성
================================================

대규모 애플리케이션을 구축하는 경우 컨트롤러를 하위 디렉터리로 계층적으로 구성하거나 구조화할 수 있습니다.
CodeIgniter는 이를 허용합니다.

기본 **app/Controllers/** 아래에 하위 디렉터리를 만들고 그 안에 컨트롤러 클래스를 배치하기만 하면 됩니다.

.. important:: 폴더 이름은 반드시 대문자로 시작해야 하며 첫 번째 문자만 대문자일 수 있습니다.

이 기능을 사용할 때 URI의 첫 번째 세그먼트는 폴더를 지정해야 합니다.
예를 들어 다음과 같이 컨트롤러가 있다고 가정해 보겠습니다.

::

    app/Controllers/Products/Shoes.php

위의 컨트롤러를 호출하기 위한 URI는 다음과 같이 보일 것입니다.

::

    example.com/index.php/products/shoes/show/123

.. note:: **app/Controllers/**\ 와 **public/**\ 에 같은 이름의 디렉토리를 가질 수 없습니다.
     디렉토리가 있으면 웹 서버가 디렉토리를 검색하고 CodeIgniter로 라우팅되지 않기 때문입니다.

각 하위 디렉터리에는 URL에 *하위 디렉터리만* 호출될 때 사용될 기본 컨트롤러가 포함될 수 있습니다.
**app/Config/Routes.php** 파일에 지정된 기본 컨트롤러의 이름과 일치하는 컨트롤러를 그 곳에 넣으면 됩니다.

CodeIgniter는 또한 :ref:`Defined Route Routing <defined-route-routing>`\ 을 사용하여 URI를 매핑할 수 있습니다.

메소드 호출 재정의
**********************

위에서 언급했듯이 URI의 두 번째 세그먼트는 일반적으로 컨트롤러에서 호출되는 메서드를 결정합니다.
CodeIgniter는 ``_remap()`` 메서드를 사용하여 이 동작을 재정의할 수 있습니다.

.. literalinclude:: controllers/017.php

.. important:: 컨트롤러에 ``_remap()``\ 이라는 메서드가 포함되어 있으면 URI에 포함된 내용에 관계없이 **항상** 호출됩니다.
     URI가 호출되는 메서드를 결정하는 일반적인 동작을 재정의하여 고유한 메소드 라우팅 규칙을 정의할 수 있습니다.

재정의된 메서드 호출(일반적으로 URI의 두 번째 세그먼트)은 ``_remap()`` 메서드에 매개변수로 전달됩니다.

.. literalinclude:: controllers/018.php

메소드 이름 뒤의 모든 추가 세그먼트는 ``_remap()``\ 으로 전달됩니다.
이 매개변수는 메소드에 전달되어 CodeIgniter의 기본 동작을 에뮬레이트할 수 있습니다.

.. literalinclude:: controllers/019.php

컨트롤러 확장
************************

컨트롤러를 확장하려면 :doc:`../extending/basecontroller`\ 를 참조하세요.

이게 다임!
************

이것이 컨트롤러에 대해 알아야 할 모든 것입니다.
