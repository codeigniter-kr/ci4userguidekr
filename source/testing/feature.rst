####################
HTTP 기능 테스트
####################

기능 테스트를 통해 어플리케이션에 대한 단일 호출 결과를 볼 수 있습니다.
단일 웹 양식의 결과를 반환하거나 API 엔드 포인트에 도달하는 등의 결과일 수 있습니다.
이는 단일 요청의 전체 수명주기를 테스트하여 라우팅이 작동하고, 응답이 올바른 형식이며, 결과를 분석하는 등의 작업을 수행할 수 있기 때문에 편리합니다.

.. contents::
    :local:
    :depth: 2

테스트 클래스
=================

기능 테스트에서는 모든 테스트 클래스가 ``CodeIgniter\Test\DatabaseTestCase`` \와 ``CodeIgniter\Test\FeatureTestTrait`` 특성(trait)을 사용해야 합니다.
이러한 테스트 도구는 적절한 데이터베이스 스테이징에 의존하기 때문에 자체 메서드를 구현하는 경우 항상 ``parent::setUp()``\ 과 ``parent::tearDown()``\ 이 호출되도록 해야 합니다.

::

    <?php 
    
    namespace App;

    use CodeIgniter\Test\DatabaseTestTrait;
    use CodeIgniter\Test\FeatureTestTrait;

    class TestFoo extends FeatureTestCase
    {
    	use DatabaseTestTrait, FeatureTestTrait;

        protected function setUp(): void
        {
            parent::setUp();

			$this->myClassMethod();
        }

        protected function tearDown(): void
        {
            parent::tearDown();

			$this->anotherClassMethod();
        }
    }

페이지 요청
=================

기본적으로 기능 테스트를 사용하면 어플리케이션에서 엔드 포인트를 호출하여 결과를 다시 가져올 수 있습니다.
이렇게 하려면 ``call()`` 메소드를 사용하십시오. 
첫 번째 매개 변수는 사용할 HTTP 메소드입니다.(대부분 GET 또는 POST)
두 번째 매개 변수는 테스트할 사이트의 경로입니다.
세 번째 매개 변수는 사용중인 HTTP 동사에 대한 수퍼 글로벌 변수를 채우는데 사용되는 배열입니다.
따라서 **GET** 메소드는 **$_GET** 변수가 채워지고 **post** 메소드는 **$_POST** 배열이 채워집니다.

::

    // Get a simple page
    $result = $this->call('get', '/');

    // Submit a form
    $result = $this->call('post', 'contact'), [
        'name'  => 'Fred Flintstone',
        'email' => 'flintyfred@example.com',
    ]);

타이핑을 쉽고 더 명확하게 하기 위해 각 HTTP 동사에 대한 속기 방법이 있습니다.

::

    $this->get($path, $params);
    $this->post($path, $params);
    $this->put($path, $params);
    $this->patch($path, $params);
    $this->delete($path, $params);
    $this->options($path, $params);

.. note:: $params 배열은 모든 HTTP 동사에 대해 의미가 없지만 일관성을 위해 포함됩니다.

다른 경로(route) 설정
------------------------

"routes" 배열을 ``withRoutes()`` 메소드에 전달하여 사용자 지정 경로 모음을 사용할 수 있습니다.
이것은 시스템의 기존 경로를 무시합니다

::

    $routes = [
        ['get', 'users', 'UserController::list'],
     ];

    $result = $this->withRoutes($routes)->get('users');

각 "routes"는 HTTP동사 (또는 "all"), 일치할 URI,  라우팅 대상을 포함하는 3요소 배열입니다.


세션 값 설정
----------------------

``withSession()`` 메소드를 사용하여 단일 테스트 중에 사용할 사용자 정의 세션 값을 설정할 수 있습니다.
요청이 이루어질때 $_SESSION 변수 내에 존재해야 하는 키/값 쌍의 배열이 사용됩니다.
인증 등을 테스트할 때 편리합니다.

단일 테스트 중에 사용할 사용자 정의 세션 값을 ``withSession()``메소드를 사용하여 설정할 수 있습니다. 
$_SESSION 변수에 존재해야 하는 값을 키/값 쌍의 배열을 사용하거나  ``null``\ 을 전달하여 현재 ``$ _SESSION``\ 을 사용할 수 있습니다.
인증 등을 테스트할 때 편리합니다.

::

    $values = [
        'logged_in' => 123,
    ];

    $result = $this->withSession($values)->get('admin');

    // Or...

    $_SESSION['logged_in'] = 123;

    $result = $this->withSession()->get('admin');

헤더 설정
---------------

``withHeaders()`` 메소드를 사용하여 헤더 값을 설정할 수 있으며, 호출할 때 헤더로 전달될 키/값 쌍의 배열이 필요합니다.

::

    $headers = [
        'CONTENT_TYPE' => 'application/json',
    ];

    $result = $this->withHeaders($headers)->post('users');

이벤트 우회
----------------

이벤트는 어플리케이션에서 사용하기 편리하지만 테스트중에 문제가 될 수 있습니다.
특히 이메일을 보내는데 사용되는 이벤트. 
``skipEvents()`` 메소드로 이벤트 처리를 건너 뛰도록 시스템에 지시할 수 있습니다

::

    $result = $this->skipEvents()->post('users', $userInfo);

request 형식 설정
-----------------------

``withBodyFormat()``\ 메소드를 사용하여 요청 본문의 형식을 설정할 수 있습니다. 
현재 이 기능은 `json` 또는 `xml`\ 을 지원하며, 설정시 ``call(), post(), get() ...``\ 로 전달되는 매개 변수를 가져 와서 주어진 형식으로 요청 본문에 할당합니다. 
이에 따라 요청에 대한 `Content-Type` 헤더도 설정됩니다.
이 기능은 컨트롤러가 예상하는 형식으로 요청을 설정할 수 있도록 JSON 또는 XML API를 테스트할 때 유용합니다.

::

    // 기능 테스트에 다음이 포함된 경우:
    $result = $this->withBodyFormat('json')->post('users', $userInfo);

    // 컨트롤러는 다음과 같이 전달된 매개 변수를 가져올 수 있습니다.
    $userInfo = $this->request->getJson();

본문 설정
----------------

``withBody()``\ 메소드로 요청의 본문을 설정할 수 있습니다. 
이를 통해 원하는 형식으로 본문를 형식화할  수 있습니다. 
테스트할 XML이 복잡한 경우 이 옵션을 사용하는 것이 좋습니다. 
이렇게 해도 Content-Type 헤더는 설정되지 않으므로, 필요한 경우 ``withHeaders()``\ 메소드를 사용하여 설정합니다.

응답 확인
====================

``FeatureTestTrait::call()``\ 은 ``TestResponse`` 인스턴스를 반환합니다. 
이 클래스를 사용하여 테스트 케이스에서 추가 어설션 및 검증을 수행하는 방법은 `Testing Responses <response.html>`_\ 를 참조하십시오.