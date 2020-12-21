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

테스트를 수행하기 위한 모든 테스트 클래스는 ``CodeIgniter\Test\FeatureTestCase`` 클래스를 확장(extend)하거나 ``CodeIgniter\Test\FeatureTestTrait``\ 을 사용해야 합니다.
이렇게 만들어진 테스트는 `CIDatabaseTestCase <database.html>`_\ 를 확장(extend)하므로 ``parent::setUp()``\ 와 ``parent::tearDown()``\ 을 호출되도록 해야 합니다.

::

    <?php namespace App;

    use CodeIgniter\Test\FeatureTestCase;

    class TestFoo extends FeatureTestCase
    {
        public function setUp(): void
        {
            parent::setUp();
        }

        public function tearDown(): void
        {
            parent::tearDown();
        }
    }

페이지 요청
=================

기본적으로 FeatureTestCase를 사용하면 어플리케이션에서 엔드 포인트를 호출하고 결과를 다시 얻을 수 있습니다.
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
        'name' => 'Fred Flintstone',
        'email' => 'flintyfred@example.com'
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
       [ 'get', 'users', 'UserController::list' ]
     ];

    $result = $this->withRoutes($routes)
        ->get('users');

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
        'logged_in' => 123
    ];

    $result = $this->withSession($values)
        ->get('admin');

    // Or...
    
    $_SESSION['logged_in'] = 123;
    
    $result = $this->withSession()->get('admin');

헤더 설정
---------------

``withHeaders()`` 메소드를 사용하여 헤더 값을 설정할 수 있으며, 호출할 때 헤더로 전달될 키/값 쌍의 배열이 필요합니다.

::

    $headers = [
        'CONTENT_TYPE' => 'application/json'
    ];

    $result = $this->withHeaders($headers)->post('users');

이벤트 우회
----------------

이벤트는 어플리케이션에서 사용하기 편리하지만 테스트중에 문제가 될 수 있습니다.
특히 이메일을 보내는데 사용되는 이벤트. 
``skipEvents()`` 메소드로 이벤트 처리를 건너 뛰도록 시스템에 지시할 수 있습니다

::

    $result = $this->skipEvents()
        ->post('users', $userInfo);

request 형식 설정
-----------------------

``withBodyFormat()``\ 메소드를 사용하여 요청 본문의 형식을 설정할 수 있습니다. 
현재 이 기능은 `json` 또는 `xml`\ 을 지원하며, 설정시 ``call(), post(), get() ...``\ 로 전달되는 매개 변수를 가져 와서 주어진 형식으로 요청 본문에 할당합니다. 
이에 따라 요청에 대한 `Content-Type` 헤더도 설정됩니다.
이 기능은 컨트롤러가 예상하는 형식으로 요청을 설정할 수 있도록 JSON 또는 XML API를 테스트할 때 유용합니다.

::

    //기능 테스트에 다음이 포함된 경우:
    $result = $this->withBodyFormat('json')
        ->post('users', $userInfo);

    //컨트롤러는 다음과 같이 전달된 매개 변수를 가져올 수 있습니다.
    $userInfo = $this->request->getJson();

본문 설정
----------------

``withBody()``\ 메소드로 요청의 본문을 설정할 수 있습니다. 
이를 통해 원하는 형식으로 본문를 형식화할  수 있습니다. 
테스트할 XML이 복잡한 경우 이 옵션을 사용하는 것이 좋습니다. 
이렇게 해도 Content-Type 헤더는 설정되지 않으므로, 필요한 경우 ``withHeaders()``\ 메소드를 사용하여 설정합니다.

응답 테스트
====================

``call()``\ 을 수행하고 결과를 얻은 후에는 테스트에 사용할 수 있는 여러 가지 새로운 어설트(assert)가 있습니다.

.. note:: Response 오브젝트는 ``$result->response``\ 를 통하여 사용 가능합니다. 필요한 경우 해당 인스턴스를 사용하여 다른 어설션을 수행할 수 있습니다.

응답 상태 확인
------------------------

**isOK()**

응답이 "ok"인지 여부에 따라 부울 true/false를 반환합니다. 이것은 주로 200 또는 300의 응답 상태 코드에 의해 결정됩니다.

::

    if ($result->isOK())
    {
        ...
    }

**assertOK()**

이 어설션은 **isOK()** 메소드를 사용하여 응답을 테스트합니다.

::

    $result->assertOK();

**isRedirect()**

응답이 리디렉션된 응답인지 여부에 따라 부울 true/false를 반환합니다.

::

    if ($result->isRedirect())
    {
        ...
    }

**assertRedirect()**

응답이 RedirectResponse의 인스턴스임을 확인합니다.

::

    $result->assertRedirect();

**getRedirectUrl()**

RedirectResponse에 설정된 URL을 반환합니다. 실패하면 null을 반환합니다.

::

    $url = $result->getRedirectUrl();
    $this->assertEquals(site_url('foo/bar'), $url);

**assertStatus(int $code)**

반환된 HTTP 상태 코드가 $code와 일치하는지 확인합니다.

::

    $result->assertStatus(403);


세션 어설션
------------------

**assertSessionHas(string $key, $value = null)**

결과 세션에 값이 존재하는지 확인합니다. $value가 전달되면 변수의 값이 지정된 값과 일치한다고 주장(assert)합니다.

::

    $result->assertSessionHas('logged_in', 123);

**assertSessionMissing(string $key)**

결과 세션에 지정된 $key가 포함되지 않도록합니다.

::

    $result->assertSessionMissin('logged_in');


헤더 어설션
-----------------

**assertHeader(string $key, $value = null)**

응답에 **$key**\ 라는 헤더가 존재하는지 확인합니다.
**$value**\ 가 비어 있지 않으면 값이 일치한다고 주장합니다.

::

    $result->assertHeader('Content-Type', 'text/html');

**assertHeaderMissing(string $key)**

응답에 헤더 이름 **$key**\ 가 존재하지 않는지 확인합니다.

::

    $result->assertHeader('Accepts');



쿠키 어설션
-----------------

**assertCookie(string $key, $value = null, string $prefix = '')**

응답에 **$key**\ 라는 쿠키가 존재하는지 확인합니다.
**$value**\ 가 비어 있지 않으면 값이 일치한다고 주장(assert)합니다.
필요한 경우 쿠키 접두사를 세 번째 매개 변수로 전달하여 설정할 수 있습니다.

::

    $result->assertCookie('foo', 'bar');

**assertCookieMissing(string $key)**

응답에 **$key**\ 라는 쿠키가 존재하지 않음을 확인합니다.

::

    $result->assertCookieMissing('ci_session');

**assertCookieExpired(string $key, string $prefix = '')**

이름이 **$key**\ 인 쿠키가 존재하지만 만료되었는지 확인합니다.
필요한 경우 쿠키 접두사를 두 번째 매개 변수로 전달하여 설정할 수 있습니다.

::

    $result->assertCookieExpired('foo');


DOM 어설트
--------------

다음 어설션을 사용하여 응답 본문에 특정 요소/텍스트 등이 존재하는지 확인하기 위한 테스트를 수행할 수 있습니다.

**assertSee(string $search = null, string $element = null)**

유형, 클래스 또는 ID로 지정된대로 텍스트/HTML이 페이지에 있거나 보다 구체적으로 태그 내에 있다고 가정합니다.

::

    // Check that "Hello World" is on the page
    $result->assertSee('Hello World');
    // Check that "Hello World" is within an h1 tag
    $result->assertSee('Hello World', 'h1');
    // Check that "Hello World" is within an element with the "notice" class
    $result->assertSee('Hello World', '.notice');
    // Check that "Hello World" is within an element with id of "title"
    $result->assertSee('Hellow World', '#title');


**assertDontSee(string $search = null, string $element = null)**

**assertSee()** 메소드와 정반대

::

    // Checks that "Hello World" does NOT exist on the page
    $results->dontSee('Hello World');
    // Checks that "Hello World" does NOT exist within any h1 tag
    $results->dontSee('Hello World', 'h1');

**assertSeeElement(string $search)**

**assertSee()**\ 와 유사하지만 기존 요소만 검사합니다. 특정 텍스트를 확인하지 않습니다

::

    // Check that an element with class 'notice' exists
    $results->seeElement('.notice');
    // Check that an element with id 'title' exists
    $results->seeElement('#title')

**assertDontSeeElement(string $search)**

**assertSee()**\ 와 유사하지만 누락된 기존 요소만 검사합니다.
특정 텍스트를 확인하지 않습니다

::

    // Verify that an element with id 'title' does NOT exist
    $results->dontSeeElement('#title');

**assertSeeLink(string $text, string $details=null)**

태그 본문과 일치하는 **$text**\ 를 사용하여 앵커 태그를 찾도록합니다.

::

    // Check that a link exists with 'Upgrade Account' as the text::
    $results->seeLink('Upgrade Account');
    // Check that a link exists with 'Upgrade Account' as the text, AND a class of 'upsell'
    $results->seeLink('Upgrade Account', '.upsell');

**assertSeeInField(string $field, string $value=null)**

이름과 값을 가진 입력 태그가 존재하는지 확인

::

    // Check that an input exists named 'user' with the value 'John Snow'
    $results->assertSeeInField('user', 'John Snow');
    // Check a multi-dimensional input
    $results->assertSeeInField('user[name]', 'John Snow');



JSON 작업
-----------------

응답에는 종종 API 응답을 사용할 때 특히 JSON 응답이 포함됩니다.
다음 메소드로 응답을 테스트할 수 있습니다.

**getJSON()**

이 메소드는 응답 본문을 JSON 문자열로 리턴합니다.

::

    // Response body is this:
    ['foo' => 'bar']

    $json = $result->getJSON();

    // $json is this:
    {
        "foo": "bar"
    }

.. note:: JSON 문자열은 예쁘게 인쇄됩니다.

**assertJSONFragment(array $fragment)**

JSON 응답내에서 $fragment가 발견되었음을 확인합니다. 
전체 JSON 값과 일치하지 않아도됩니다.

::

    // Response body is this:
    [
        'config' => ['key-a', 'key-b']
    ]

    // Is true
    $this->assertJSONFragment(['config' => ['key-a']);

.. note:: PHPUnit의 `assertArraySubset() <https://phpunit.readthedocs.io/en/7.2/assertions.html#assertarraysubset>`_ 메소드를 사용하여 비교를 수행합니다.

**assertJSONExact($test)**

**assertJSONFragment()**\ 와 비슷하지만 전체 JSON 응답을 검사하여 정확히 일치하는지 확인합니다.


XML 작업
----------------

**getXML()**

어플리케이션이 XML을 리턴하면 이 메소드를 통해 XML을 검색할 수 있습니다.
