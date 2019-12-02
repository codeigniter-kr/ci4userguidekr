####################
HTTP 기능 테스트
####################

기능 테스트를 통해 애플리케이션에 대한 단일 호출 결과를 볼 수 있습니다.
단일 웹 양식의 결과를 반환하거나 API 엔드 포인트에 도달하는 등의 결과일 수 있습니다.
이는 단일 요청의 전체 수명주기를 테스트하여 라우팅이 작동하고, 응답이 올바른 형식이며, 결과를 분석하는 등의 작업을 수행할 수 있기 때문에 편리합니다.

.. contents::
    :local:
    :depth: 2

테스트 클래스
=================

기능 테스트를 위해서는 모든 테스트 클래스가 ``CodeIgniter\Test\FeatureTestCase`` 클래스를 확장해야 합니다.
이렇게 하면 `CIDatabaseTestCase <database.html>`_\ 로 확장되므로 작업을 수행하기 전에 항상 ``parent::setUp()`` 와 ``parent::tearDown()``\ 이 호출되는지 확인해야 합니다.

::

    <?php namespace App;

    use CodeIgniter\Test\FeatureTestCase;

    class TestFoo extends FeatureTestCase
    {
        public function setUp()
        {
            parent::setUp();
        }

        public function tearDown()
        {
            parent::tearDown();
        }
    }

페이지 요청
=================

기본적으로 FeatureTestCase를 사용하면 애플리케이션에서 엔드 포인트를 호출하고 결과를 다시 얻을 수 있습니다.
이렇게 하려면 ``call()`` 메서드를 사용하십시오. 
첫 번째 매개 변수는 사용할 HTTP 메소드입니다.(대부분 GET 또는 POST)
두 번째 매개 변수는 테스트할 사이트의 경로입니다.
세 번째 매개 변수는 사용중인 HTTP 동사에 대한 수퍼 글로벌 변수를 채우는데 사용되는 배열입니다.
따라서 **GET** 메소드는 **$_GET** 변수가 채워지고 **post** 메소드는 **$_POST** 배열이 채워집니다.

::

    // Get a simple page
    $result = $this->call('get', site_url());

    // Submit a form
    $result = $this->call('post', site_url('contact'), [
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

"routes" 배열을 ``withRoutes()`` 메서드에 전달하여 사용자 지정 경로 모음을 사용할 수 있습니다.
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

::

    $values = [
        'logged_in' => 123
    ];

    $result = $this->withSession($values)
        ->get('admin');

이벤트 우회
----------------

이벤트는 응용 프로그램에서 사용하기 편리하지만 테스트중에 문제가 될 수 있습니다.
특히 이메일을 보내는데 사용되는 이벤트. 
``skipEvents()`` 메소드로 이벤트 처리를 건너 뛰도록 시스템에 지시할 수 있습니다

::

    $result = $this->skipEvents()
        ->post('users', $userInfo);


Testing the Response
====================

Once you've performed a ``call()`` and have results, there are a number of new assertions that you can use in your
tests.

.. note:: The Response object is publicly available at ``$result->response``. You can use that instance to perform
    other assertions against, if needed.

Checking Response Status
------------------------

**isOK()**

Returns a boolean true/false based on whether the response is perceived to be "ok". This is primarily determined by
a response status code in the 200 or 300's.
::

    if ($result->isOK())
    {
        ...
    }

**assertOK()**

This assertion simply uses the **isOK()** method to test a response.
::

    $this->assertOK();

**isRedirect()**

Returns a boolean true/false based on whether the response is a redirected response.
::

    if ($result->isRedirect())
    {
        ...
    }

**assertRedirect()**

Asserts that the Response is an instance of RedirectResponse.
::

    $this->assertRedirect();

**assertStatus(int $code)**

Asserts that the HTTP status code returned matches $code.
::

    $this->assertStatus(403);


Session Assertions
------------------

**assertSessionHas(string $key, $value = null)**

Asserts that a value exists in the resulting session. If $value is passed, will also assert that the variable's value
matches what was specified.
::

    $this->assertSessionHas('logged_in', 123);

**assertSessionMissing(string $key)**

Asserts that the resulting session does not include the specified $key.
::

    $this->assertSessionMissin('logged_in');


Header Assertions
-----------------

**assertHeader(string $key, $value = null)**

Asserts that a header named **$key** exists in the response. If **$value** is not empty, will also assert that
the values match.
::

    $this->assertHeader('Content-Type', 'text/html');

**assertHeaderMissing(string $key)**

Asserts that a header name **$key** does not exist in the response.
::

    $this->assertHeader('Accepts');



Cookie Assertions
-----------------

**assertCookie(string $key, $value = null, string $prefix = '')**

Asserts that a cookie named **$key** exists in the response. If **$value** is not empty, will also assert that
the values match. You can set the cookie prefix, if needed, by passing it in as the third parameter.
::

    $this->assertCookie('foo', 'bar');

**assertCookieMissing(string $key)**

Asserts that a cookie named **$key** does not exist in the response.
::

    $this->assertCookieMissing('ci_session');

**assertCookieExpired(string $key, string $prefix = '')**

Asserts that a cookie named **$key** exists, but has expired. You can set the cookie prefix, if needed, by passing it
in as the second parameter.
::

    $this->assertCookieExpired('foo');


DOM Assertions
--------------

You can perform tests to see if specific elements/text/etc exist with the body of the response with the following
assertions.

**assertSee(string $search = null, string $element = null)**

Asserts that text/HTML is on the page, either by itself or - more specifically - within
a tag, as specified by type, class, or id::

    // Check that "Hello World" is on the page
    $this->assertSee('Hello World');
    // Check that "Hello World" is within an h1 tag
    $this->assertSee('Hello World', 'h1');
    // Check that "Hello World" is within an element with the "notice" class
    $this->assertSee('Hello World', '.notice');
    // Check that "Hello World" is within an element with id of "title"
    $this->assertSee('Hellow World', '#title');


**assertDontSee(string $search = null, string $element = null)**

Asserts the exact opposite of the **assertSee()** method::

    // Checks that "Hello World" does NOT exist on the page
    $results->dontSee('Hello World');
    // Checks that "Hello World" does NOT exist within any h1 tag
    $results->dontSee('Hello World', 'h1');

**assertSeeElement(string $search)**

Similar to **assertSee()**, however this only checks for an existing element. It does not check for specific text::

    // Check that an element with class 'notice' exists
    $results->seeElement('.notice');
    // Check that an element with id 'title' exists
    $results->seeElement('#title')

**assertDontSeeElement(string $search)**

Similar to **assertSee()**, however this only checks for an existing element that is missing. It does not check for
specific text::

    // Verify that an element with id 'title' does NOT exist
    $results->dontSeeElement('#title');

**assertSeeLink(string $text, string $details=null)**

Asserts that an anchor tag is found with matching **$text** as the body of the tag::

    // Check that a link exists with 'Upgrade Account' as the text::
    $results->seeLink('Upgrade Account');
    // Check that a link exists with 'Upgrade Account' as the text, AND a class of 'upsell'
    $results->seeLink('Upgrade Account', '.upsell');

**assertSeeInField(string $field, string $value=null)**

Asserts that an input tag exists with the name and value::

    // Check that an input exists named 'user' with the value 'John Snow'
    $results->seeInField('user', 'John Snow');
    // Check a multi-dimensional input
    $results->seeInField('user[name]', 'John Snow');



Working With JSON
-----------------

Responses will frequently contain JSON responses, especially when working with API methods. The following methods
can help to test the responses.

**getJSON()**

This method will return the body of the response as a JSON string::

    // Response body is this:
    ['foo' => 'bar']

    $json = $result->getJSON();

    // $json is this:
    {
        "foo": "bar"
    }

.. note:: Be aware that the JSON string will be pretty-printed in the result.

**assertJSONFragment(array $fragment)**

Asserts that $fragment is found within the JSON response. It does not need to match the entire JSON value.

::

    // Response body is this:
    [
        'config' => ['key-a', 'key-b']
    ]

    // Is true
    $this->assertJSONFragment(['config' => ['key-a']);

.. note:: This simply uses phpUnit's own `assertArraySubset() <https://phpunit.readthedocs.io/en/7.2/assertions.html#assertarraysubset>`_
    method to do the comparison.

**assertJSONExact($test)**

Similar to **assertJSONFragment()**, but checks the entire JSON response to ensure exact matches.


Working With XML
----------------

**getXML()**

If your application returns XML, you can retrieve it through this method.

