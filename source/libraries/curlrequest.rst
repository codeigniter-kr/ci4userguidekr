##########################
CURLRequest 클래스
##########################

``CURLRequest`` 클래스는 다른 웹 사이트 또는 서버와 통신할 수있는 CURL 기반의 경량 HTTP 클라이언트입니다.
Google 검색 내용을 가져 오거나 웹 페이지 또는 이미지를 검색하거나 API와 통신하는데 사용할 수 있습니다.

.. contents::
    :local:
    :depth: 2

이 클래스는 `Guzzle HTTP Client <http://docs.guzzlephp.org/en/latest/>`_ 라이브러리를 모델로합니다. 
가장 널리 사용되는 라이브러리중 하나이기 때문입니다.
가능한 경우 Guzzle의 구문과 동일하게 유지되므로, 응용 프로그램에서 이 라이브러리를 대신하여 Guzzle로 바꾸어도 거의 변경없이 사용 가능합니다.

.. note:: 이 클래스는 사용하기 위해서는 PHP 버전의 `cURL 라이브러리 <http://php.net/manual/en/book.curl.php>`_\ 를 설치해야합니다. 
	이 라이브러리는 일반적으로 사용 가능하지만 모든 호스트가 제공하지는 않으므로 문제가 발생한다면 호스트에 문의하여 설치를 확인하십시오.

*******************
라이브러리 로드
*******************

라이브러리는 수동으로 또는 :doc:`서비스 클래스 </concepts/services>`\ 를 통해 로드할 수 있습니다.

서비스 클래스를 통하여 로드하려면 ``curlrequest()`` 메서드를 호출하십시오.

::

	$client = \Config\Services::curlrequest();

cURL이 요청을 처리하는 방법을 수정하기 위해 기본 옵션 배열을 첫 번째 매개 변수로 전달할 수 있습니다.
옵션은 이 문서의 뒷부분에서 설명합니다

::

	$options = [
		'base_uri' => 'http://example.com/api/v1/',
		'timeout'  => 3
	];
	$client = \Config\Services::curlrequest($options);

클래스를 수동으로 만들 때는 몇 가지 종속성을 전달해야 합니다.
첫 번째 매개 변수는 ``Config\App`` 클래스의 인스턴스입니다.
두 번째 매개 변수는 URI 인스턴스입니다.
세 번째 매개 변수는 Response 객체입니다.
네 번째 매개 변수는 ``$options`` 배열입니다.(선택)

::

	$client = new \CodeIgniter\HTTP\CURLRequest(
		new \Config\App(),
		new \CodeIgniter\HTTP\URI(),
		new \CodeIgniter\HTTP\Response(new \Config\App()),
		$options
	);

************************
라이브러리 작업
************************

CURL 요청 작업은 통신을 처리하기 위해 요청(request)을 작성하고 :doc:`응답(response) 객체 </outgoing/response>`\ 를 얻는 문제입니다.
그 후 정보 처리 방법을 완전히 제어할 수 있습니다.

요청 만들기
===============

대부분의 통신은``request()`` 메소드를 통해 이루어지며, 이 메소드는 요청을 시작한 다음 Response 인스턴스를 리턴합니다.
HTTP 메소드, url 및 옵션 배열을 매개 변수로 사용합니다.

::

	$client = \Config\Services::curlrequest();

	$response = $client->request('GET', 'https://api.github.com/user', [
		'auth' => ['user', 'pass']
	]);

응답은 ``CodeIgniter\HTTP\Response``\ 의 인스턴스이므로 모든 일반 정보를 사용할 수 있습니다

::

	echo $response->getStatusCode();
	echo $response->getBody();
	echo $response->getHeader('Content-Type');
	$language = $response->negotiateLanguage(['en', 'fr']);

``request()`` 메소드가 가장 유연하지만 다음 단축 메소드를 사용할 수도 있습니다.
각각 URL을 첫 번째 매개 변수로 사용하고 옵션 배열을 두 번째 매개 변수로 사용합니다.

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

클래스를 인스턴스화하는 동안 ``base_uri``\ 을 옵션 중 하나로 설정할 수 있습니다.
이를 통해 기본 URI를 설정한 다음 상대 URL을 사용하여 해당 클라이언트와의 모든 요청을 할 수 있습니다.
API로 작업할 때 특히 유용합니다

::

	$client = \Config\Services::curlrequest([
		'base_uri' => 'https://example.com/api/v1/'
	]);

	// GET http:example.com/api/v1/photos
	$client->get('photos');

	// GET http:example.com/api/v1/photos/13
	$client->delete('photos/13');

상대 URI가 ``request()`` 메소드 또는 임의의 단축키 메소드에 제공되면, `RFC 2986, section 2 <http://tools.ietf.org/html/rfc3986#section-5.2>`_\ 에 설명된 규칙에 따라 base_uri와 결합됩니다. 
다음은 조합에 대한 몇 가지 예입니다.

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

응답 사용
===============

각 ``request()`` 호출은 유용한 정보와 메소드를 포함하는 응답 객체를 반환합니다.
가장 일반적으로 사용되는 메소드를 사용하여 반응 자체를 확인할 수 있습니다.

응답의 상태 코드 및 이유를 확인할 수 있습니다.

::

	$code   = $response->getStatusCode();    // 200
	$reason = $response->getReason();      // OK

응답에서 헤더를 검색할 수 있습니다

::

	// Get a header line
	echo $response->getHeaderLine('Content-Type');

	// Get all headers
	foreach ($response->getHeaders() as $name => $value)
	{
		echo $name .': '. $response->getHeaderLine($name) ."\n";
	}

``getBody()`` 메소드를 사용하여 본문을 검색할 수 있습니다.

::

	$body = $response->getBody();

본문은 원격 getServer에서 제공하는 원시 본문입니다.
컨텐츠 유형에 형식이 필요한 경우 스크립트가 해당 형식을 처리하는지 확인해야 합니다.

::

	if (strpos($response->getHeader('content-type'), 'application/json') !== false)
	{
		$body = json_decode($body);
	}

**********************
요청(Request) 옵션
**********************

이 섹션에서는 생성자, ``request()`` 메서드 또는 바로 가기 메서드에 전달할 수 있는 모든 옵션에 대해 설명합니다.

allow_redirects
===============

기본적으로 cURL은 원격 서버가 보내는 모든 "Location:" 헤더를 따릅니다.
``allow_redirects`` 옵션을 사용하면 작동 방식을 수정할 수 있습니다.

값을 ``false``\ 로 설정하면 리디렉션을 따르지 않습니다.

::

	$client->request('GET', 'http://example.com', ['allow_redirects' => false]);

``true``\ 로 설정하면 기본 설정이 요청에 적용됩니다.

::

	$client->request('GET', 'http://example.com', ['allow_redirects' => true]);

	// Sets the following defaults:
	'max'       => 5, // Maximum number of redirects to follow before stopping
	'strict'    => true, // Ensure POST requests stay POST requests through redirects
	'protocols' => ['http', 'https'] // Restrict redirects to one or more protocols

``allow_redirects`` 옵션 값을 배열로 전달하여 기본값 대신 새 설정을 지정할 수 있습니다.

::

	$client->request('GET', 'http://example.com', ['allow_redirects' => [
		'max'       => 10,
		'protocols' => ['https'] // Force HTTPS domains only.
	]]);

.. note:: PHP가 safe_mode에 있거나 open_basedir이 활성화되어 있으면 다음 리디렉션이 작동하지 않습니다.

auth
====

Allows you to provide Authentication details for `HTTP Basic <http://www.ietf.org/rfc/rfc2069.txt>`_ and
`Digest <http://www.ietf.org/rfc/rfc2069.txt>`_ and authentication. Your script may have to do extra to support
Digest authentication - this simply passes the username and password along for you. The value must be an
array where the first element is the username, and the second is the password. The third parameter should be
the type of authentication to use, either ``basic`` or ``digest``::

	$client->request('GET', 'http://example.com', ['auth' => ['username', 'password', 'digest']]);

body
====

There are two ways to set the body of the request for request types that support them, like PUT, OR POST.
The first way is to use the ``setBody()`` method::

	$client->setBody($body)
	       ->request('put', 'http://example.com');

The second method is by passing a ``body`` option in. This is provided to maintain Guzzle API compatibility,
and functions the exact same way as the previous example. The value must be a string::

	$client->request('put', 'http://example.com', ['body' => $body]);

cert
====

To specify the location of a PEM formatted client-side certificate, pass a string with the full path to the
file as the ``cert`` option. If a password is required, set the value to an array with the first element
as the path to the certificate, and the second as the password::

    $client->request('get', '/', ['cert' => ['/path/getServer.pem', 'password']);

connect_timeout
===============

By default, CodeIgniter does not impose a limit for cURL to attempt to connect to a website. If you need to
modify this value, you can do so by passing the amount of time in seconds with the ``connect_timeout`` option.
You can pass 0 to wait indefinitely::

	$response->request('GET', 'http://example.com', ['connect_timeout' => 0]);

cookie
======

This specifies the filename that CURL should use to read cookie values from, and
to save cookie values to. This is done using the CURL_COOKIEJAR and CURL_COOKIEFILE options.
An example::

	$response->request('GET', 'http://example.com', ['cookie' => WRITEPATH . 'CookieSaver.txt']);

debug
=====

When ``debug`` is passed and set to ``true``, this will enable additional debugging to echo to STDOUT during the
script execution. This is done by passing CURLOPT_VERBOSE and echoing the output::

	$response->request('GET', 'http://example.com', ['debug' => true]);

You can pass a filename as the value for debug to have the output written to a file::

	$response->request('GET', 'http://example.com', ['debug' => '/usr/local/curl_log.txt']);

delay
=====

Allows you to pause a number of milliseconds before sending the request::

	// Delay for 2 seconds
	$response->request('GET', 'http://example.com', ['delay' => 2000]);

form_params
===========

You can send form data in an application/x-www-form-urlencoded POST request by passing an associative array in
the ``form_params`` option. This will set the ``Content-Type`` header to ``application/x-www-form-urlencoded``
if it's not already set::

	$client->request('POST', '/post', [
		'form_params' => [
			'foo' => 'bar',
			'baz' => ['hi', 'there']
		]
	]);

.. note:: ``form_params`` cannot be used with the ``multipart`` option. You will need to use one or the other.
        Use ``form_params`` for ``application/x-www-form-urlencoded`` request, and ``multipart`` for ``multipart/form-data``
        requests.

headers
=======

While you can set any headers this request needs by using the ``setHeader()`` method, you can also pass an associative
array of headers in as an option. Each key is the name of a header, and each value is a string or array of strings
representing the header field values::

	$client->request('get', '/', [
		'headers' => [
			'User-Agent' => 'testing/1.0',
			'Accept'     => 'application/json',
			'X-Foo'      => ['Bar', 'Baz']
		]
	]);

If headers are passed into the constructor they are treated as default values that will be overridden later by any
further headers arrays or calls to ``setHeader()``.

http_errors
===========

By default, CURLRequest will fail if the HTTP code returned is greater than or equal to 400. You can set
``http_errors`` to ``false`` to return the content instead::

    $client->request('GET', '/status/500');
    // Will fail verbosely

    $res = $client->request('GET', '/status/500', ['http_errors' => false]);
    echo $res->getStatusCode();
    // 500

json
====

The ``json`` option is used to easily upload JSON encoded data as the body of a request. A Content-Type header
of ``application/json`` is added, overwriting any Content-Type that might be already set. The data provided to
this option can be any value that ``json_encode()`` accepts::

	$response = $client->request('PUT', '/put', ['json' => ['foo' => 'bar']]);

.. note:: This option does not allow for any customization of the ``json_encode()`` function, or the Content-Type
        header. If you need that ability, you will need to encode the data manually, passing it through the ``setBody()``
        method of CURLRequest, and set the Content-Type header with the ``setHeader()`` method.

multipart
=========

When you need to send files and other data via a POST request, you can use the ``multipart`` option, along with
the `CURLFile Class <http://php.net/manual/en/class.curlfile.php>`_. The values should be an associative array
of POST data to send. For safer usage, the legacy method of uploading files by prefixing their name with an `@`
has been disabled. Any files that you want to send must be passed as instances of CURLFile::

	$post_data = [
		'foo'      => 'bar',
		'userfile' => new \CURLFile('/path/to/file.txt')
	];

.. note:: ``multipart`` cannot be used with the ``form_params`` option. You can only use one or the other. Use
        ``form_params`` for ``application/x-www-form-urlencoded`` requests, and ``multipart`` for ``multipart/form-data``
        requests.

query
=====

You can pass along data to send as query string variables by passing an associative array as the ``query`` option::

	// Send a GET request to /get?foo=bar
	$client->request('GET', '/get', ['query' => ['foo' => 'bar']]);

timeout
=======

By default, cURL functions are allowed to run as long as they take, with no time limit. You can modify this with the ``timeout``
option. The value should be the number of seconds you want the functions to execute for. Use 0 to wait indefinitely::

	$response->request('GET', 'http://example.com', ['timeout' => 5]);

verify
======

This option describes the SSL certificate verification behavior. If the ``verify`` option is ``true``, it enables the
SSL certificate verification and uses the default CA bundle provided by the operating system. If set to ``false`` it
will disable the certificate verification (this is insecure, and allows man-in-the-middle attacks!). You can set it
to a string that contains the path to a CA bundle to enable verification with a custom certificate. The default value
is true::

	// Use the system's CA bundle (this is the default setting)
	$client->request('GET', '/', ['verify' => true]);

	// Use a custom SSL certificate on disk.
	$client->request('GET', '/', ['verify' => '/path/to/cert.pem']);

	// Disable validation entirely. (Insecure!)
	$client->request('GET', '/', ['verify' => false]);

version
=======

To set the HTTP protocol to use, you can pass a string or float with the version number (typically either 1.0
or 1.1, 2.0 is currently unsupported.)::

	// Force HTTP/1.0
	$client->request('GET', '/', ['version' => 1.0]);

