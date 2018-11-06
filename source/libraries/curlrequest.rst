##################
CURLRequest 클래스
##################

The ``CURLRequest`` class is a lightweight HTTP client based on CURL that allows you to talk to other
web sites and servers. It can be used to get the contents of a Google search, retrieve a web page or image,
or communicate with an API, among many other things.
``CURLRequest`` 클래스는 다른 웹 사이트 및 서버와 대화 할 수있는 CURL 기반의 간단한 HTTP 클라이언트입니다. Google 검색의 콘텐츠를 가져 오거나, 웹 페이지 또는 이미지를 검색하거나, API와 통신하는 데 사용할 수 있습니다.

.. contents::
    :local:
    :depth: 2

This class is modelled after the `Guzzle HTTP Client <http://docs.guzzlephp.org/en/latest/>`_ library since
it is one of the more widely used libraries. Where possible, the syntax has been kept the same so that if
your application needs something a little more powerful than what this library provides, you will have
to change very little to move over to use Guzzle.
이 클래스는 널리 사용되는 라이브러리중 하나인 `Guzzle HTTP Client <http://docs.guzzlephp.org/en/latest/>`_ 라이브러리를 모델로합니다 . 가능한 경우 구문이 동일하게 유지되어 응용 프로그램에이 라이브러리가 제공하는 것보다 조금 더 강력한 기능이 필요한 경우 Guzzle을 사용하도록 이전하려면 거의 변경하지 않아야합니다.

.. note:: This class requires the `cURL Library <http://php.net/manual/en/book.curl.php>`_ to be installed
    in your version of PHP. This is a very common library that is typically available but not all hosts
    will provide it, so please check with your host to verify if you run into problems.
    이 클래스를 사용하려면 PHP 버전에 `cURL 라이브러리 <http://php.net/manual/en/book.curl.php>`_ 가 설치되어 있어야합니다. 이것은 일반적으로 사용 가능한 매우 일반적인 라이브러리이지만 모든 호스트가 제공하지는 않습니다. 따라서 호스트에 문의하여 문제가 있는지 확인하십시오.

*******************
라이브러리 로드
*******************

라이브러리는 수동 또는 :doc:`Services class </concepts/services>` 클래스를 통해 로드할 수 있습니다 .

Services 클래스를 로드하려면 다음과 같이 ``curlrequest()`` 메소드를 호출하세요.

::

	$client = \Config\Services::curlrequest();

You can pass in an array of default options as the first parameter to modify how cURL will handle the request.
The options are described later in this document
cURL이 요청을 처리하는 방법을 수정하는 첫 번째 매개 변수로 기본 옵션 배열을 전달할 수 있습니다. 옵션은이 문서의 뒷부분에서 설명합니다.

::

	$options = [
		'base_uri' => 'http://example.com/api/v1/',
		'timeout'  => 3
	];
	$client = \Config\Services::curlrequest($options);

When creating the class manually, you need to pass a few dependencies in. The first parameter is an
instance of the ``Config\App`` class. The second parameter is a URI instance. The third
parameter is a Response object. The fourth parameter is the optional ``$options`` array
클래스를 수동으로 만들 때 몇 가지 종속성을 전달해야합니다. 첫 번째 매개 변수는 ``Config\App`` 클래스 의 인스턴스입니다 . 두 번째 매개 변수는 URI 인스턴스입니다. 세 번째 매개 변수는 Response 개체입니다. 네 번째 매개 변수는 선택적 ``$options`` 배열입니다.

::

	$client = new \CodeIgniter\HTTP\CURLRequest(
		new \Config\App(),
		new \CodeIgniter\HTTP\URI(),
		new \CodeIgniter\HTTP\Response(new \Config\App()),
		$options
	);

************************
라이브러리를 통한 작업
************************

Working with CURL requests is simply a matter of creating the Request and getting a
:doc:`Response object </outgoing/response>` back. It is meant to handle the communications. After that
you have complete control over how the information is handled

CURL 요청으로 작업하는 것은 Request를 작성하고 :doc:`Response object </outgoing/response>` 를 다시 가져 오는 것입니다. 통신을 처리하기위한 것입니다. 정보가 처리되는 방법을 완전히 제어 할 수 있습니다.

Requests 만들기
===============

Most communication is done through the ``request()`` method, which fires off the request, and then returns
a Response instance to you. This takes the HTTP method, the url and an array of options as the parameters.
대부분의 통신은 ``request()`` 메소드를 통해 수행 되며 요청을 실행 한 다음 Response 인스턴스를 리턴합니다. HTTP 메소드, URL 및 옵션 배열을 매개 변수로 사용합니다.

::

	$client = \Config\Services::curlrequest();

	$response = $client->request('GET', 'https://api.github.com/user', [
		'auth' => ['user', 'pass']
	]);

Since the response is an instance of ``CodeIgniter\HTTP\Response`` you have all of the normal information
available to you
응답은 사용자의 인스턴스이므로 ``CodeIgniter\HTTP\Response`` 모든 일반적인 정보를 사용할 수 있습니다.

::

	echo $response->getStatusCode();
	echo $response->getBody();
	echo $response->getHeader('Content-Type');
	$language = $response->negotiateLanguage(['en', 'fr']);

``request()`` 메서드는 다음과 같은 shortcut 메서드를 사용할 수 있습니다. 첫 번째 매개 변수로 URL을 두 번째 매개 변수는 옵션 배열을 사용합니다.

::

* $client->get('http://example.com');
* $client->delete('http://example.com');
* $client->head('http://example.com');
* $client->options('http://example.com');
* $client->patch('http://example.com');
* $client->put('http://example.com');
* $client->post('http://example.com');

Base URI
--------

A ``base_uri`` can be set as one of the options during the instantiation of the class. This allows you to
set a base URI, and then make all requests with that client using relative URLs. This is especially handy
when working with APIs
``base_uri`` 클래스를 인스턴스화 하는 동안 A 를 옵션 중 하나로 설정할 수 있습니다. 이렇게하면 기본 URI를 설정 한 다음 상대 URL을 사용하여 해당 클라이언트와 함께 모든 요청을 수행 할 수 있습니다. 이는 API를 사용하여 작업 할 때 특히 편리합니다.

::

	$client = \Config\Services::curlrequest([
		'base_uri' => 'https://example.com/api/v1/'
	]);

	// GET http:example.com/api/v1/photos
	$client->get('photos');

	// GET http:example.com/api/v1/photos/13
	$client->delete('photos/13');

When a relative URI is provided to the ``request()`` method or any of the shortcut methods, it will be combined
with the base_uri according to the rules described by
`RFC 2986, section 2 <http://tools.ietf.org/html/rfc3986#section-5.2>`_. To save you some time, here are some
examples of how the combinations are resolved.
상대 URI가 ``request()`` 메서드 또는 모든 바로 가기 메서드에 제공되면 `RFC 2986, section 2 <http://tools.ietf.org/html/rfc3986#section-5.2>`_ 에 설명 된 규칙에 따라 base_uri와 결합됩니다 . 시간을 절약하기 위해 조합이 어떻게 해결되는지 몇 가지 예가 있습니다.

	===================   ==============   ======================
	base_uri              URI              Result
	===================   ==============   ======================
	http://foo.com        /bar             http://foo.com/bar
	http://foo.com/foo    /bar             http://foo.com/bar
	http://foo.com/foo    bar              http://foo.com/bar
	http://foo.com/foo/   bar              http://foo.com/foo/bar
	http://foo.com        http://baz.com   http://baz.com
	http://foo.com/?bar   bar              http://foo.com/bar
	===================   ==============   ======================

Responses 사용하기
==================

Each ``request()`` call returns a Response object that contains a lot of useful information and some helpful
methods. The most commonly used methods let you determine the response itself.
``request()`` 호출은 많은 유용한 정보와 유용한 메소드가 들어있는 Response 객체를 반환합니다. 가장 일반적으로 사용되는 방법을 사용하면 응답 자체를 결정할 수 있습니다.

You can get the status code and reason phrase of the response
응답의 상태 코드 및 이유 구문을 얻을 수 있습니다.

::

	$code   = $response->getStatusCode();    // 200
	$reason = $response->getReason();      // OK

response 에서 헤더를 검색 할 수 있습니다.

::

	// Get a header line
	echo $response->getHeaderLine('Content-Type');

	// Get all headers
	foreach ($response->getHeaders() as $name => $value)
	{
		echo $name .': '. $response->getHeaderLine($name) ."\n";
	}

The body can be retrieved using the ``getBody()`` method
본문은 ``getBody()`` 메서드를 사용하여 검색 할 수 있습니다.
::

	$body = $response->getBody();

The body is the raw body provided by the remote getServer. If the content type requires formatting, you will need
to ensure that your script handles that
본문은 원격 getServer가 제공하는 원시 본문입니다. 콘텐츠 형식에 형식이 필요한 경우 스크립트에서 다음을 처리하는지 확인해야합니다.

::

	if (strpos($response->getHeader('content-type'), 'application/json') !== false)
	{
		$body = json_decode($body);
	}

************
Request 옵션
************

This section describes all of the available options you may pass into the constructor, the ``request()`` method,
or any of the shortcut methods.
이 섹션에서는 생성자, ``request()`` 메서드 또는 shortcut 메서드에 전달할 수있는 모든 옵션을 설명합니다 .

allow_redirects
===============

By default, cURL will follow all "Location:" headers the remote servers send back. The ``allow_redirects`` option
allows you to modify how that works.
기본적으로 cURL은 원격 서버가 다시 보내는 모든 "Location:" 헤더를 따릅니다. 이 ``allow_redirects`` 옵션을 사용하면 작동 방식을 수정할 수 있습니다.

If you set the value to ``false``, then it will not follow any redirects at all
값을 ``false`` 로 설정하면 리디렉션을 전혀 따르지 않습니다.

::

	$client->request('GET', 'http://example.com', ['allow_redirects' => false]);

Setting it to ``true`` will apply the default settings to the request
이 값을 ``true`` 로 설정 하면 request의 기본 설정이 적용됩니다.

::

	$client->request('GET', 'http://example.com', ['allow_redirects' => true]);

	// Sets the following defaults:
	'max'       => 5, // Maximum number of redirects to follow before stopping
	'strict'    => true, // Ensure POST requests stay POST requests through redirects
	'protocols' => ['http', 'https'] // Restrict redirects to one or more protocols

You can pass in array as the value of the ``allow_redirects`` option to specify new settings in place of the defaults
``allow_redirects`` 기본값 대신 새로운 설정을 지정 하는 옵션 값으로 array를 전달할 수 있습니다 .

::

	$client->request('GET', 'http://example.com', ['allow_redirects' => [
		'max'       => 10,
		'protocols' => ['https'] // Force HTTPS domains only.
	]]);

.. note:: Following redirects does not work when PHP is in safe_mode or open_basedir is enabled.
			PHP가 safe_mode 에 있거나 open_basedir 이 활성화되어 있으면 다음 리디렉션이 작동하지 않습니다.

auth
====

Allows you to provide Authentication details for `HTTP Basic <http://www.ietf.org/rfc/rfc2069.txt>`_ and
`Digest <http://www.ietf.org/rfc/rfc2069.txt>`_ and authentication. Your script may have to do extra to support
Digest authentication - this simply passes the username and password along for you. The value must be an
array where the first element is the username, and the second is the password. The third parameter should be
the type of authentication to use, either ``basic`` or ``digest``
`HTTP Basic <http://www.ietf.org/rfc/rfc2069.txt>`_ 와 `Digest <http://www.ietf.org/rfc/rfc2069.txt>`_ 및 인증에
대한 인증 세부 정보를 제공 할 수 있습니다 . 스크립트는 다이제스트 인증을 지원하기 위해 추가 작업을해야 할 수도 있습니다.
이 작업은 사용자 이름과 비밀번호를 전달하면 됩니다. 값은 첫 번째 요소가 사용자 이름이고 두 번째 요소가 암호인 배열이어야
합니다. 세 번째 매개 변수는 사용할 인증 유형 ``basic`` 이거나 ``digest`` 중 하나여야 합니다 .

::

	$client->request('GET', 'http://example.com', ['auth' => ['username', 'password', 'digest']]);

body
====

There are two ways to set the body of the request for request types that support them, like PUT, OR POST.
The first way is to use the ``setBody()`` method
PUT 또는 POST와 같이 요청을 지원하는 요청 유형에 대한 요청의 본문을 설정하는 두 가지 방법이 있습니다. 첫 번째 방법은이 ``setBody()`` 메서드를 사용하는 것입니다.

::

	$client->setBody($body)
	       ->request('put', 'http://example.com');

The second method is by passing a ``body`` option in. This is provided to maintain Guzzle API compatibility,
and functions the exact same way as the previous example. The value must be a string
두 번째 방법은 ``body`` 옵션 을 전달하는 것입니다.이 방법은 Guzzle API 호환성을 유지하기 위해 제공되며 이전 예제와 완전히 동일한 방식으로 작동합니다. 값은 문자열이어야합니다.

::

	$client->request('put', 'http://example.com', ['body' => $body]);

cert
====

To specify the location of a PEM formatted client-side certificate, pass a string with the full path to the
file as the ``cert`` option. If a password is required, set the value to an array with the first element
as the path to the certificate, and the second as the password
PEM 형식의 클라이언트 쪽 인증서 위치를 지정하려면 파일의 전체 경로와 함께 문자열을 cert옵션으로 전달하십시오. 암호가 필요한 경우 첫 번째 요소를 인증서의 경로로 사용하고 두 번째 요소를 암호로 사용하여 배열에 값을 설정하십시오.

::

    $client->request('get', '/', ['cert' => ['/path/getServer.pem', 'password']);

connect_timeout
===============

By default, CodeIgniter does not impose a limit for cURL to attempt to connect to a website. If you need to
modify this value, you can do so by passing the amount of time in seconds with the ``connect_timeout`` option.
You can pass 0 to wait indefinitely
기본적으로 CodeIgniter는 cURL에 웹 사이트 연결 시도를 제한하지 않습니다. 이 값을 수정해야하는 경우 connect_timeout옵션을 사용하여 시간 (초)을 전달하면 됩니다. 0을 전달하여 무기한 대기하도록 할 수 있습니다.

::

	$response->request('GET', 'http://example.com', ['connect_timeout' => 0]);

cookie
======

This specifies the filename that CURL should use to read cookie values from, and
to save cookie values to. This is done using the CURL_COOKIEJAR and CURL_COOKIEFILE options.
An example::

	$response->request('GET', 'http://example.com', ['cookie' => WRITEPATH . 'CookieSaver.txt']);

디버그
======

When ``debug`` is passed and set to ``true``, this will enable additional debugging to echo to STDOUT during the
script execution. This is done by passing CURLOPT_VERBOSE and echoing the output
``debug`` 가 ``true`` 로 설정  되면 스크립트 실행 중에 추가 디버깅을 STDOUT에 echo 시킬 수 있습니다. 이것은 CURLOPT_VERBOSE를 전달하고 출력을 에코하여 수행됩니다.

::

	$response->request('GET', 'http://example.com', ['debug' => true]);

You can pass a filename as the value for debug to have the output written to a file
디버깅을위한 파일 이름을 파일에 전달하여 출력을 파일에 기록 할 수 있습니다.

::

	$response->request('GET', 'http://example.com', ['debug' => '/usr/local/curl_log.txt']);

delay
=====

Allows you to pause a number of milliseconds before sending the request
요청을 보내기 전에 수 밀리 초를 일시 중지 할 수 있습니다.

::

	// Delay for 2 seconds
	$response->request('GET', 'http://example.com', ['delay' => 2000]);

form_params
===========

You can send form data in an application/x-www-form-urlencoded POST request by passing an associative array in
the ``form_params`` option. This will set the ``Content-Type`` header to ``application/x-www-form-urlencoded``
if it's not already set
``form_params`` 옵션에 연관 배열을 전달하여 application/x-www-form-urlencoded POST 요청으로 양식 데이터를 보낼 수 있습니다 . 이것은 설정합니다 ``Content-Type`` 헤더에 ``application/x-www-form-urlencoded`` 가 아직 설정되어 있지 않은 경우를

::

	$client->request('POST', '/post', [
		'form_params' => [
			'foo' => 'bar',
			'baz' => ['hi', 'there']
		]
	]);

.. note:: ``form_params`` cannot be used with the ``multipart`` option. You will need to use one or the other.
        Use ``form_params`` for ``application/x-www-form-urlencoded`` request, and ``multipart`` for ``multipart/form-data``
        requests.
        ``form_params`` 은 ``multipart`` 옵션과 함께 사용할 수 없습니다 . 둘 중 하나를 사용해야합니다. 사용 ``form_params`` 에 대한 ``application/x-www-form-urlencoded`` 요구, 그리고 ``multipart` 에 대한 ``multipart/form-data`` 요청.

headers
=======

While you can set any headers this request needs by using the ``setHeader()`` method, you can also pass an associative
array of headers in as an option. Each key is the name of a header, and each value is a string or array of strings
representing the header field values
``setHeader()`` 메서드를 사용하여이 요청에 필요한 모든 헤더를 설정할 수 있지만 헤더 의 연관 배열을 옵션으로 전달할 수도 있습니다. 각 키는 헤더의 이름이며 각 값은 헤더 필드 값을 나타내는 문자열 또는 문자열 배열입니다.

::

	$client->request('get', '/', [
		'headers' => [
			'User-Agent' => 'testing/1.0',
			'Accept'     => 'application/json',
			'X-Foo'      => ['Bar', 'Baz']
		]
	]);

If headers are passed into the constructor they are treated as default values that will be overridden later by any
further headers arrays or calls to ``setHeader()``.
헤더가 생성자에 전달되면 기본값으로 처리되며 나중에 헤더 배열이나 호출에 의해 재정의됩니다 ``setHeader()``.

http_errors
===========

By default, CURLRequest will fail if the HTTP code returned is greater than or equal to 400. You can set
``http_errors`` to ``false`` to return the content instead
반환 된 HTTP 코드는 사용자가 설정할 수 400보다 크거나 같은 경우 기본적으로 CURLRequest이 실패 ``http_errors`` 하는 ``false`` 대신 내용을 반환 

::

    $client->request('GET', '/status/500');
    // Will fail verbosely

    $res = $client->request('GET', '/status/500', ['http_errors' => false]);
    echo $res->getStatusCode();
    // 500

json
====

The ``json`` option is used to easily upload JSON encoded data as the body of a request. A Content-Type header
of ``application/json`` is added, overwriting any Content-Type that might be already set. The data provided to
this option can be any value that ``json_encode()`` accepts
``json`` 옵션은 JSON 인코딩 데이터를 요청 본문으로 쉽게 업로드하는 데 사용됩니다. Content-Type 헤더 ``application/json`` 가 추가되어 이미 설정된 Content-Type을 덮어 씁니다. 이 옵션에 제공되는 데이터 ``json_encode()`` 는 다음 을 허용 하는 값이 될 수 있습니다 .

::

	$response = $client->request('PUT', '/put', ['json' => ['foo' => 'bar']]);

.. note:: This option does not allow for any customization of the ``json_encode()`` function, or the Content-Type
        header. If you need that ability, you will need to encode the data manually, passing it through the ``setBody()``
        method of CURLRequest, and set the Content-Type header with the ``setHeader()`` method.
        이 옵션은 ``json_encode()`` 함수 또는 Content-Type 헤더의 사용자 정의를 허용하지 않습니다 . 이 기능이 필요한 경우 데이터를 수동으로 인코딩하고 ``setBody()`` CURLRequest 메서드를 통해 전달한 다음 메서드를 사용하여 Content-Type 헤더를 설정해야 ``setHeader()`` 합니다.

multipart
=========

When you need to send files and other data via a POST request, you can use the ``multipart`` option, along with
the `CURLFile Class <http://php.net/manual/en/class.curlfile.php>`_. The values should be an associative array
of POST data to send. For safer usage, the legacy method of uploading files by prefixing their name with an ``@``
has been disabled. Any files that you want to send must be passed as instances of CURLFile
POST 요청을 통해 파일 및 기타 데이터를 보내야 ``multipart`` 하는 경우 `CURLFile 클래스 <http://php.net/manual/en/class.curlfile.php>`_ 와 함께 이 옵션을 사용할 수 있습니다 . 값은 보낼 POST 데이터의 연관 배열이어야합니다. 더 안전한 사용을 위해 파일 이름에 ``@`` 를 접두사로 붙여서 파일을 업로드하는 기존의 방법 이 비활성화되었습니다. 보낼 파일은 CURLFile의 인스턴스로 전달되어야합니다.

::

	$post_data = [
		'foo'      => 'bar',
		'userfile' => new \CURLFile('/path/to/file.txt')
	];

.. note:: ``multipart`` cannot be used with the ``form_params`` option. You can only use one or the other. Use
        ``form_params`` for ``application/x-www-form-urlencoded`` requests, and ``multipart`` for ``multipart/form-data``
        requests.
        ``multipart`` 는 ``form_params`` 옵션과 함께 사용할 수 없습니다 . 둘 중 하나만 사용할 수 있습니다. 사용 ``form_params`` 에 대한 ``application/x-www-form-urlencoded`` 요청, ``multipart`` 대한 ``multipart/form-data`` 요청.

query
=====

You can pass along data to send as query string variables by passing an associative array as the ``query`` option
연관 배열을 ``query`` 옵션 으로 전달하여 데이터를 전달하여 쿼리 문자열 변수로 보낼 수 있습니다 .

::

	// Send a GET request to /get?foo=bar
	$client->request('GET', '/get', ['query' => ['foo' => 'bar']]);

timeout
=======

By default, cURL functions are allowed to run as long as they take, with no time limit. You can modify this with the ``timeout``
option. The value should be the number of seconds you want the functions to execute for. Use 0 to wait indefinitely
기본적으로 cURL 함수는 시간 제한없이 시간이 지나면 실행될 수 있습니다. 이 ``timeout`` 옵션을 사용하여 수정할 수 있습니다 . 값은 함수를 실행할 시간 (초)이어야합니다. 무기한 대기하려면 0을 사용하십시오.

::

	$response->request('GET', 'http://example.com', ['timeout' => 5]);

verify
======

This option describes the SSL certificate verification behavior. If the ``verify`` option is ``true``, it enables the
SSL certificate verification and uses the default CA bundle provided by the operating system. If set to ``false`` it
will disable the certificate verification (this is insecure, and allows man-in-the-middle attacks!). You can set it
to a string that contains the path to a CA bundle to enable verification with a custom certificate. The default value
is true
이 옵션은 SSL 인증서 확인 동작을 설명합니다. ``verify`` 옵션에 ``true`` 를 사용하면 SSL 인증서 확인을 활성화하고 운영 체제에서 제공하는 기본 CA 번들을 사용합니다. 이 값을 ``false`` 설정하면 인증서 확인이 비활성화됩니다 (이 방법은 안전하지 않으며 man-in-the-middle 공격을 허용합니다!). 사용자 정의 인증서로 검증 할 수 있도록 CA 번들에 대한 경로가 포함 된 문자열로 설정할 수 있습니다. 기본값은 true 입니다.

::

	// Use the system's CA bundle (this is the default setting)
	$client->request('GET', '/', ['verify' => true]);

	// Use a custom SSL certificate on disk.
	$client->request('GET', '/', ['verify' => '/path/to/cert.pem']);

	// Disable validation entirely. (Insecure!)
	$client->request('GET', '/', ['verify' => false]);

version
=======

To set the HTTP protocol to use, you can pass a string or float with the version number (typically either 1.0
or 1.1, 2.0 is currently unsupported.)
사용할 HTTP 프로토콜을 설정하려면 버전 번호 (일반적으로 1.0 또는 1.1, 2.0은 현재 지원되지 않음)와 함께 문자열 또는 부동을 전달할 수 있습니다.

::

	// Force HTTP/1.0
	$client->request('GET', '/', ['version' => 1.0]);

