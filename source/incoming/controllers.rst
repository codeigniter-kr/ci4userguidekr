####################
컨트롤러(Controller)
####################

컨트롤러는 HTTP 요청 처리 방법을 결정하며, 어플리케이션의 핵심입니다.

.. contents::
    :local:
    :depth: 2


컨트롤러란 무엇입니까?
=========================

컨트롤러는 URI와 연결될 수 있는 방식으로 이름 붙여진 클래스 파일입니다.

다음 URI를 살펴보세요.

::

    example.com/index.php/helloworld/

위의 예제에서 CodeIgniter는 Helloworld.php 라는 컨트롤러를 찾아 로드하려고 시도합니다.

**컨트롤러 이름이 URI의 첫 번째 세그먼트와 일치하면 로드됩니다.**

해봅시다 - Hello World!
==========================

이제 간단한 컨트롤러를 만들어 실제 작동하는 모습을 보도록 하겠습니다. 

텍스트 편집기를 사용하여 Hellowworld.php라는 파일을 만들고 다음 코드를 입력합니다.
Helloworld 컨트롤러가 BaseController를 확장하고 있음을 알 수 있습니다.
BaseController 기능이 필요하지 않은 경우 CodeIgniter\\Controller를 확장할 수도 있습니다.

BaseController는 모든 컨트롤러에 필요한 구성 요소를 로드하고 기능을 수행할 수 있는 편리한 위치를 제공합니다.
새 컨트롤러에서 이 클래스를 확장할 수 있습니다.

보안상의 이유로 새로운 유틸리티 메소드를 protected 또는 private로 선언해야 합니다.

::

    <?php

    namespace App\Controllers;

    class Helloworld extends BaseController
    {
        public function index()
        {
            echo 'Hello World!';
        }
    }

이 파일을 **/app/Controllers/** 디렉토리에 저장합니다.

.. important:: 'Helloworld.php'는 대문자 'H'로 시작되어야 합니다.

이제 이와 유사한 URL을 사용하여 사이트를 방문하십시오.

::

    example.com/index.php/helloworld

제대로 했다면 결과는::

    Hello World!

.. important:: 컨트롤러 클래스 이름은 대문자로 시작해야 하며, 첫번째 문자만 대문자입니다.

올바른 예

::

    <?php

    namespace App\Controllers;

    class Helloworld extends BaseController
    {

    }

틀린 예1

::

    <?php

    namespace App\Controllers;

    class helloworld extends BaseController
    {

    }

틀린 예2

::

    <?php

    namespace App\Controllers;

    class HelloWorld extends BaseController
    {

    }

여러분이 작성한 컨트롤러가 모든 메소드를 상속받을 수 있도록 상위 컨트롤러 클래스를 확장해야 합니다.

.. note:: 시스템은 정의된 경로와 일치하는 항목을 찾을 수 없는 경우 APPATH/Controller의 폴더/파일과 각 세그먼트를 일치시켜 컨트롤러와 URI를 일치시키려고 시도합니다. 
    따라서 폴더/파일은 대문자로 시작하고 나머지는 소문자여야 합니다.
    다른 명명 규칙을 원한다면 :doc:`URI Routing <routing>`\ 을 사용하여 수동으로 정의해야 합니다.

    다음은 `PSR-4: Autoloader`\ 에 기반으로 한 예입니다. 

    ::

        \<NamespaceName>(\<SubNamespaceNames>)*\<ClassName>

        $routes->get('helloworld', 'App\Controllers\HelloWorld::index');

메소드
=========

위 예제에서 메소드 이름은 ``index()``\ 입니다.
URI의 **두 번째 세그먼트**\ 가 비어 있으면 "index" 메소드가 항상 기본적으로 로드됩니다.
"Hello World" 메시지를 표시하는 다른 방법은 다음과 같습니다.

::

    example.com/index.php/helloworld/index/

**URI의 두 번째 세그먼트는 컨트롤러에서 호출할 메소드를 결정합니다.**

컨트롤러에 새로운 메소드를 추가해 봅시다.

::

    <?php

    namespace App\Controllers;

    class Helloworld extends BaseController
    {
        public function index()
        {
            echo 'Hello World!';
        }

        public function comment()
        {
            echo 'I am not flat!';
        }
    }


이제 다음 URL을 로드하여 comment 메소드를 봅니다.::

    example.com/index.php/helloworld/comment/

새로운 메시지가 표시됩니다.

메소드에 URI 세그먼트 전달
====================================

URI에 세 개 이상의 세그먼트가 포함되어 있으면 메소드에 매개 변수(parameters)로 전달됩니다.

예를 들어 이와 같은 URI가 있다고 가정 해 봅시다.::

    example.com/index.php/products/shoes/sandals/123

메소드에 URI 세그먼트 3과 세그먼트 4가 전달됩니다. ("sandals" 와 "123")::

    <?php

    namespace App\Controllers;

    class Products extends BaseController
    {
        public function shoes($sandals, $id)
        {
            echo $sandals;
            echo $id;
        }
    }

.. important:: :doc:`URI 라우팅 <routing>` 기능을 사용하는 경우 메소드에 전달 된 세그먼트가 다시 라우팅됩니다.

기본 컨트롤러 정의
=============================

사이트 루트 URL만 요청할 때, Helloworld 컨트롤러를 로드하도록 할 수 있습니다.

기본 컨트롤러를 지정하려면 **app/Config/Routes.php** 파일을 열고 아래 부분을 수정하십시오.

::

    $routes->setDefaultController('Helloworld');

여기서 'Helloworld'는 사용하려는 기본 컨트롤러 클래스의 이름입니다.
**Routes.php**\ 의 라인 코멘트 "Route Definitions" 섹션 몇 줄 아래 있습니다.

::

    $routes->get('/', 'Home::index');

URI 세그먼트를 지정하지 않고 사이트를 탐색하면 "Hello World"메시지가 표시됩니다.

.. note:: ``$routes->get('/', 'Home::index');``\ 은 "실제" 앱에서 사용하는 최적화된 경로입니다. 시연 목적으로 이 기능을 사용하고 싶지 않습니다. ``$routes->get()``\ 에 대한 설명은 :doc:`URI 라우팅 <routing>`\ 을 살펴보세요.


자세한 내용은 :doc:`URI 라우팅 <routing>` 설명서의 "라우트 구성 옵션" 섹션을 참조하십시오.

리매핑 메소드 호출
======================

위에서 언급 한 바와 같이, URI의 두 번째 세그먼트는 일반적으로 컨트롤러에서 호출되는 메소드를 결정합니다.
``_remap()`` 메소드를 사용하면 CodeIgniter의 이 동작을 재정의 할 수 있습니다.

::

    public function _remap()
    {
        // Some code here...
    }

.. important:: 컨트롤러에 _remap()\ 이라는 메소드가 포함되어 있으면 URI에 포함 된 내용에 관계없이 **항상** 호출됩니다.
    URI는 어떤 메소드가 호출되는지 판별하여 사용자 고유의 메소드 라우팅 규칙을 정의할 수 있는 일반적인 동작을 대체합니다.

재정의 된 메소드 호출(일반적으로 URI의 두 번째 세그먼트)은 ``_remap()`` 메소드에 매개 변수로 전달됩니다.
::

    public function _remap($method)
    {
        if ($method === 'some_method')
        {
            return $this->$method();
        }
        else
        {
            return $this->default_method();
        }
    }

메소드 이름 뒤의 추가 세그먼트는 ``_remap()``\ 에 전달됩니다.
이러한 매개 변수는 CodeIgniter의 기본 동작을 에뮬레이트하기 위해 메소드로 전달될 수 있습니다.

Example::

    public function _remap($method, ...$params)
    {
        $method = 'process_'.$method;
        if (method_exists($this, $method))
        {
            return $this->$method(...$params);
        }
        throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound();
    }

비공개 메소드
===============

경우에 따라 외부에 특정 메소드를 숨겨야할 수도 있습니다.
메소드를 private 또는 protected로 선언하면 URL 요청을 통해 접근할 수 없습니다.
"Helloworld" 컨트롤러에 대해 이와 같은 방법을 사용한 예입니다.

::

    protected function utility()
    {
        // some code
    }

아래와 같이 URL을 통해 액세스하려고 하면 동작하지 않습니다.

::

    example.com/index.php/helloworld/utility/

컨트롤러를 하위 디렉토리로 구성
================================================

CodeIgniter를 사용하면 컨트롤러를 하위(sub) 디렉터리에 계층적으로 구성하여 큰 어플리케이션을 구축할 수 있습니다.

메인 *app/Controllers/* 아래에 하위 디렉토리를 만들고 그 안에 컨트롤러 클래스를 배치하십시오.

.. note:: 이 기능을 사용할 때 URI의 첫 번째 세그먼트는 폴더를 지정해야 합니다.
    예를 들어 다음과 같은 컨트롤러가 있다고 가정해 봅시다.
    
    ::

        app/Controllers/Products/Shoes.php

    위의 컨트롤러를 호출하기 위한 URI는 다음과 같습니다.
    
    ::

        example.com/index.php/products/shoes/show/123

각 하위 디렉토리에는 URL에 하위 디렉토리만 호출하는 경우를 위하여 기본 컨트롤러가 지정할 수 있습니다.
*app/Config/Routes.php* 파일의 'default_controller'\ 에 이를 위한 컨트롤러를 지정하십시오.

CodeIgniter에서는 :doc:`URI 라우팅 <routing>` 기능을 사용하여 URI를 다시 매핑할 수도 있습니다.

포함된 속성
===================

생성하는 모든 컨트롤러는 ``CodeIgniter\Controller`` 클래스를 확장해야 합니다.
이 클래스는 모든 컨트롤러에서 사용할 수 있는 몇 가지 기능을 제공합니다.

**Request Object**

어플리케이션의 :doc:`Request 인스턴스 </incoming/request>`\ 는 클래스의 ``$this->request`` 속성으로 제공됩니다.

**Response Object**

어플리케이션의 :doc:`Response 인스턴스 </outgoing/response>`\ 는 클래스의 ``$this->response`` 속성으로 제공됩니다.

**Logger Object**

:doc:`Logger <../general/logging>` 클래스의 인스턴스는 클래스 ``$this->logger`` 속성으로 제공됩니다.

**forceHTTPS**

HTTPS를 통해 메소드에 액세스할 수있는 편리한 메소드를 모든 컨트롤러에서 사용할 수 있습니다.

::

    if (! $this->request->isSecure())
    {
        $this->forceHTTPS();
    }

기본적으로, HTTP Strict Transport Security 헤더를 지원하는 최신 브라우저는 이 호출을 통하여 HTTPS가 아닌 호출을 1년 동안 HTTPS 호출로 변환하도록 강제합니다.
지속 시간(초)은 매개 변수를 전달하여 수정할 수 있습니다.

::

    if (! $this->request->isSecure())
    {
        $this->forceHTTPS(31536000);    // one year
    }

.. note:: 숫자 대신 YEAR, MONTH등 :doc:`시간 기반 상수 </general/common_functions>`\ 를 사용할 수도 있습니다.

헬퍼
-------

클래스 속성에 헬퍼를 배열로 정의할 수 있습니다.
컨트롤러가 로드될 때마다 정의된 헬퍼도 자동으로 로드되며, 컨트롤러 내부의 어느 위치에서든 헬퍼에 정의된 메소드를 사용할 수 있습니다.

::

    namespace App\Controllers;

    class MyController extends BaseController
    {
        protected $helpers = ['url', 'form'];
    }

데이터 검증
======================

데이터 확인을 단순화하기 위해 컨트롤러는 편리한 메소드 ``validate()``\ 를 제공합니다.
이 메소드는 첫 번째 매개 변수와 선택적 두 번째 매개 변수에 항목이 유효하지 않은 경우 표시할 사용자 정의 오류 메시지 배열의 규칙 배열을 허용합니다.
내부적으로 이것은 컨트롤러의 **$this->request** 인스턴스를 사용하여 데이터의 유효성을 검사합니다.
:doc:`유효성 검사 라이브러리 문서 </libraries/validation>`\ 에는 이에 대한 메시지 배열의 형식과 사용 가능한 규칙에 대한 세부 정보가 있습니다.

::

    public function updateUser(int $userID)
    {
        if (! $this->validate([
            'email' => "required|is_unique[users.email,id,{$userID}]",
            'name'  => 'required|alpha_numeric_spaces'
        ]))
        {
            return view('users/update', [
                'errors' => $this->validator->getErrors()
            ]);
        }

        // do something here if successful...
    }

``Config\Validation.php``\ 에 정의된 규칙의 그룹 이름을 ``$rules`` 배열에 명시하여 간단하게 구성 파일에 정의된 규칙을 적용할 수 있습니다.

::

    public function updateUser(int $userID)
    {
        if (! $this->validate('userRules'))
        {
            return view('users/update', [
                'errors' => $this->validator->getErrors()
            ]);
        }

        // do something here if successful...
    }

.. note:: 모델에서 유효성 검사를 자동으로 처리할 수 있지만 때로는 컨트롤러에서 확인하기가 더 쉽습니다. 선택은 당신에게 달려 있습니다.

이게 다임!
============

이것이 컨트롤러에 대해 알아야 할 모든 것입니다.
