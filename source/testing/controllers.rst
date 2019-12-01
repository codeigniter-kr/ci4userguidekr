###################
컨트롤러 테스트
###################

컨트롤러를 테스트하는것은 몇 가지 새로운 헬퍼 클래스와 특성(trait)으로 편리합니다. 
컨트롤러를 테스트는 전체 응용프로그램 부트스트랩 프로세스를 실행하지 않고도 컨트롤러내에서 코드를 실행할 수 있습니다.
종종 `기능 테스트 도구 <feature.html>`_\ 를 사용하는 것이 더 간단하며 이 기능은 필요할 때 사용할 수 있습니다.

.. note:: 전체 프레임워크가 부트스트랩되지 않았으므로 이 방법으로 컨트롤러를 테스트할 수 없는 경우가 있습니다.

헬퍼 특성(Trait)
==================

기본 테스트 클래스중 하나를 사용할 수 있지만 테스트할 때는 ``ControllerTester`` 특성을 사용합니다.

::

    <?php namespace CodeIgniter;

    use CodeIgniter\Test\ControllerTester;

    class TestControllerA extends \CIDatabaseTestCase
    {
        use ControllerTester;
    }

특성을 포함하면 요청 및 응답 클래스, 요청 본문, URI등에 대해 환경 설정을 할 수 있습니다.
``controller()`` 메서드에 컨트롤러의 클래스 이름을 전달하여 사용할 컨트롤러를 지정합니다.
마지막으로 실행할 메서드 이름을 매개 변수로 ``execute()`` 메서드를 호출합니다.

::

    <?php namespace CodeIgniter;

    use CodeIgniter\Test\ControllerTester;

    class TestControllerA extends \CIDatabaseTestCase
    {
        use ControllerTester;

        public function testShowCategories()
        {
            $result = $this->withURI('http://example.com/categories')
			    ->controller(\App\Controllers\ForumController::class)
			    ->execute('showCategories');

            $this->assertTrue($result->isOK());
        }
    }

헬퍼 메소드
==============

**controller($class)**

테스트할 컨트롤러의 클래스 이름을 지정합니다. 
첫 번째 매개 변수는 정규화된 클래스 이름이어야 합니다 (네임스페이스 포함).

::

    $this->controller(\App\Controllers\ForumController::class);

**execute($method)**

컨트롤러 내에서 지정된 메소드를 실행합니다. 
단일 매개 변수로 실행할 메소드의 이름입니다.

::

    $results = $this->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

응답 자체를 검사하기 위한 많은 루틴을 제공하는 새로운 헬퍼 클래스를 리턴합니다.
자세한 내용은 아래를 참조하십시오.

**withConfig($config)**

다른 설정으로 테스트하기 위해 수정된 버전의 **Config\App.php**\ 를 전달할 수 있습니다.

::

    $config = new Config\App();
    $config->appTimezone = 'America/Chicago';

    $results = $this->withConfig($config)
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

다른 설정을 제공하지 않으면 애플리케이션의 앱 구성 파일이 사용됩니다.

**withRequest($request)**

테스트 요구에 맞는 **IncomingRequest** 인스턴스를 제공합니다.

::

    $request = new CodeIgniter\HTTP\IncomingRequest(new Config\App(), new URI('http://example.com'));
    $request->setLocale($locale);

    $results = $this->withRequest($request)
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

인스턴스를 제공하지 않으면 기본 애플리케이션 값을 가진 새로운 IncomingRequest 인스턴스가 컨트롤러로 전달됩니다.

**withResponse($response)**

**Response** 인스턴스를 제공 할 수 있습니다

::

    $response = new CodeIgniter\HTTP\Response(new Config\App());

    $results = $this->withResponse($response)
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

Response를 제공하지 않으면 기본 애플리케이션 값을 가진 새 Response 인스턴스가 컨트롤러에 전달됩니다.

**withLogger($logger)**

**Logger** 인스턴스를 제공할 수 있습니다

::

    $logger = new CodeIgniter\Log\Handlers\FileHandler();

    $results = $this->withResponse($response)
                    -> withLogger($logger)
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

Logger를 제공하지 않으면 기본 애플리케이션 값을 가진 새 Logger 인스턴스가 컨트롤러에 전달됩니다..

**withURI($uri)**

Allows you to provide a new URI that simulates the URL the client was visiting when this controller was run.
This is helpful if you need to check URI segments within your controller. The only parameter is a string
representing a valid URI::

    $results = $this->withURI('http://example.com/forums/categories')
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

It is a good practice to always provide the URI during testing to avoid surprises.

**withBody($body)**

요청에 대한 사용자 정의 본문을 제공할 수 있습니다.
이는 JSON 값을 본문으로 설정해야하는 API 컨트롤러를 테스트할 때 유용합니다.
유일한 매개 변수는 요청의 본문을 나타내는 문자열입니다

::

    $body = json_encode(['foo' => 'bar']);

    $results = $this->withBody($body)
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

응답(Response) 확인
=====================

컨트롤러가 실행되면 생성된 요청 및 응답에 대한 직접 액세스뿐만 아니라 여러 유용한 메소드를 제공하는 새로운 **ControllerResponse** 인스턴스가 리턴됩니다.

**isOK()**

This provides a simple check that the response would be considered a "successful" response. 
This primarily checks that the HTTP status code is within the 200 or 300 ranges
이는 응답이 "성공"인지 간단하게 확인합니다.
주로 HTTP 상태 코드가 200 또는 300 범위 내에 있는지 확인합니다.

::

    $results = $this->withBody($body)
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

    if ($results->isOK())
    {
        . . .
    }

**isRedirect()**

최종 응답이 일종의 리디렉션인지 확인합니다.

::

    $results = $this->withBody($body)
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

    if ($results->isRedirect())
    {
        . . .
    }

**request()**

You can access the Request object that was generated with this method::

    $results = $this->withBody($body)
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

    $request = $results->request();

**response()**

This allows you access to the response object that was generated, if any::

    $results = $this->withBody($body)
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

    $response = $results->response();

**getBody()**

You can access the body of the response that would have been sent to the client with the **getBody()** method. This could
be generated HTML, or a JSON response, etc.::

    $results = $this->withBody($body)
                     ->controller(\App\Controllers\ForumController::class)
                     ->execute('showCategories');

    $body = $results->getBody();

Response Helper methods
-----------------------

The response you get back contains a number of helper methods to inspect the HTML output within the response. These
are useful for using within assertions in your tests.

The **see()** method checks the text on the page to see if it exists either by itself, or more specifically within
a tag, as specified by type, class, or id::

    // Check that "Hello World" is on the page
    $results->see('Hello World');
    // Check that "Hello World" is within an h1 tag
    $results->see('Hello World', 'h1');
    // Check that "Hello World" is within an element with the "notice" class
    $results->see('Hello World', '.notice');
    // Check that "Hello World" is within an element with id of "title"
    $results->see('Hellow World', '#title');

The **dontSee()** method is the exact opposite::

    // Checks that "Hello World" does NOT exist on the page
    $results->dontSee('Hello World');
    // Checks that "Hellow World" does NOT exist within any h1 tag
    $results->dontSee('Hello World', 'h1');

The **seeElement()** and **dontSeeElement()** are very similar to the previous methods, but do not look at the
values of the elements. Instead, they simply check that the elements exist on the page::

    // Check that an element with class 'notice' exists
    $results->seeElement('.notice');
    // Check that an element with id 'title' exists
    $results->seeElement('#title')
    // Verify that an element with id 'title' does NOT exist
    $results->dontSeeElement('#title');

You can use **seeLink()** to ensure that a link appears on the page with the specified text::

    // Check that a link exists with 'Upgrade Account' as the text::
    $results->seeLink('Upgrade Account');
    // Check that a link exists with 'Upgrade Account' as the text, AND a class of 'upsell'
    $results->seeLink('Upgrade Account', '.upsell');

The **seeInField()** method checks for any input tags exist with the name and value::

    // Check that an input exists named 'user' with the value 'John Snow'
    $results->seeInField('user', 'John Snow');
    // Check a multi-dimensional input
    $results->seeInField('user[name]', 'John Snow');

Finally, you can check if a checkbox exists and is checked with the **seeCheckboxIsChecked()** method::

    // Check if checkbox is checked with class of 'foo'
    $results->seeCheckboxIsChecked('.foo');
    // Check if checkbox with id of 'bar' is checked
    $results->seeCheckboxIsChecked('#bar');
