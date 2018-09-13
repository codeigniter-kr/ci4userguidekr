=====================
IncomingRequest 클래스
=====================

The IncomingRequest class provides an object-oriented representation of an HTTP request from a client, like a browser.
It extends from, and has access to all the methods of the :doc:`Request </libraries/request>` and :doc:`Message </libraries/message>`
classes, in addition to the methods listed below.
IncomingRequest 클래스는 클라이언트와 같은 HTTP 요청의 객체 지향 표현을 브라우저와 같이 제공합니다. 아래에 나열된 메소드 외에도 :doc:`Request </libraries/request>` 클래스 와 :doc:`Message </libraries/message>` 클래스 의 모든 메소드에 액세스 할 수 있으며 액세스 할 수 있습니다.

.. contents:: Page Contents

요청 액세스
=====================

An instance of the request class already populated for you if the current class is a descendant of
``CodeIgniter\Controller`` and can be accessed as a class property
현재 클래스가 하위 클래스이고 ``CodeIgniter\Controller`` 클래스 속성으로 액세스 할 수있는 경우 이미 채워져있는 요청 클래스의 인스턴스입니다 .
::

	class UserController extends CodeIgniter\Controller
	{
		public function index()
		{
			if ($this->request->isAJAX())
			{
				. . .
			}
		}
	}

If you are not within a controller, but still need access to the application's Request object, you can
get a copy of it through the :doc:`Services class </concepts/services>`
컨트롤러 내에 있지 않지만 여전히 응용 프로그램의 Request 객체에 대한 액세스가 필요한 경우 :doc:`Services class </concepts/services>` 를 통해 해당 객체의 복사본을 얻을 수 있습니다 .
::

	$request = \Config\Services::request();

It's preferable, though, to pass the request in as a dependency if the class is anything other than
the controller, where you can save it as a class property
클래스가 컨트롤러가 아닌 다른 클래스 인 경우 요청을 클래스로 전달하면 클래스 속성으로 저장할 수있는 것이 바람직합니다.
::

	use CodeIgniter\HTTP\RequestInterface;

	class SomeClass
	{
		protected $request;

		public function __construct(RequestInterface $request)
		{
			$this->request = $request;
		}
	}

	$someClass = new SomeClass(\Config\Services::request());

요청 유형 결정
========================

A request could be of several types, including an AJAX request or a request from the command line. This can
be checked with the ``isAJAX()`` and ``isCLI()`` methods
요청은 AJAX 요청이나 명령 행의 요청을 포함하여 여러 유형이 될 수 있습니다. ``isAJAX()`` 또는 ``isCLI()`` 메소드를 사용하여 확인할 수 있습니다 .
::

	// Check for AJAX request.
	if ($request->isAJAX())
	{
		. . .
	}

	// Check for CLI Request
	if ($request->isCLI())
	{
		. . .
	}

You can check the HTTP method that this request represents with the ``method()`` method
이 요청이 나타내는 HTTP 메소드를 ``method()`` 메소드로 확인할 수 있습니다.
::

	// Returns 'post'
	$method = $request->getMethod();

By default, the method is returned as a lower-case string (i.e. 'get', 'post', etc). You can get an
uppercase version by passing in ``true`` as the only parameter
기본적으로 메서드는 소문자 문자열 (예 : 'get', 'post'등)로 반환됩니다. 유일한 매개 변수로 ``true`` 를 전달하여 대문자 버전을 얻을 수 있습니다 .
::

	// Returns 'GET'
	$method = $request->getMethod(true);

You can also check if the request was made through and HTTPS connection with the ``isSecure()`` method
또한 요청이 HTTPS 연결을 통해 이루어 졌는지 ``isSecure()`` 메소드로 확인할 수 있습니다.
::

	if (! $request->isSecure())
	{
		force_https();
	}

입력 가져오기
================

You can retrieve input from $_SERVER, $_GET, $_POST, $_ENV, and $_SESSION through the Request object.
The data is not automatically filtered and returns the raw input data as passed in the request. The main
advantages to using these methods instead of accessing them directly ($_POST['something']), is that they
will return null if the item doesn't exist, and you can have the data filtered. This lets you conveniently
use data without having to test whether an item exists first. In other words, normally you might do something
like this
Request 객체를 통해 $_SERVER, $_GET, $_POST, $_ENV 및 $_SESSION의 입력을 가져올 수 있습니다. 
데이터는 자동으로 필터링되지 않고 요청에서 전달 된 원시 입력 데이터를 반환합니다. ($_POST[ 'something'])를 직접 액세스하는 대신
이들 메소드를 사용하면, 항목이 존재하지 않으면 null을 리턴하고 데이터를 필터링 할 수 있다는 장점이 있습니다. 
이렇게하면 항목이 먼저 있는지 여부를 테스트하지 않고도 편리하게 데이터를 사용할 수 있습니다. 즉, 일반적으로 다음과 같이 할 수 있습니다.

::

	$something = isset($_POST['foo']) ? $_POST['foo'] : NULL;

With CodeIgniter’s built in methods you can simply do this
CodeIgniter에 내장 된 메소드를 사용하면 다음과 같이 간단하게 할 수 있습니다 
::

	$something = $request->getVar('foo');

The ``getVar()`` method will pull from $_REQUEST, so will return any data from $_GET, $POST, or $_COOKIE. While this
is convenient, you will often need to use a more specific method, like:
``getVar()`` 메서드는 $_REQUEST에서 가져 오므로 $_GET, $_POST 또는 $_COOKIE의 데이터를 반환합니다. 편리하기는하지만 다음과 같은 보다 구체적인 방법을 사용해야 할 때가 많습니다.

* ``$request->getGet()``
* ``$request->getPost()``
* ``$request->getServer()``
* ``$request->getCookie()``

In addition, there are a few utility methods for retrieving information from either $_GET or $_POST, while
maintaining the ability to control the order you look for it:
또한 $_GET 또는 $_POST에서 정보를 검색하는 몇 가지 유틸리티 메소드가 있지만 검색 순서를 제어하는 기능은 유지됩니다.

* ``$request->getPostGet()`` - checks $_POST first, then $_GET
* ``$request->getGetPost()`` - checks $_GET first, then $_POST

**JSON 데이터 가져 오기**

You can grab the contents of php://input as a JSON stream with ``getJSON()``.
getJSON()을 사용하면 php:// 입력 내용을 JSON 스트림으로 가져올 수 있습니다.

.. note::  This has no way of checking if the incoming data is valid JSON or not, you should only use this
    method if you know that you're expecting JSON.
    이렇게하면 들어오는 데이터가 유효한 JSON인지 아닌지를 확인할 방법이 없습니다. JSON이 필요한 것으로 알고있는 경우에만이 메서드를 사용해야합니다.

::

	$json = $request->getJSON();

By default, this will return any objects in the JSON data as objects. If you want that converted to associative
arrays, pass in ``true`` as the first parameter.
기본적으로 JSON 데이터의 객체를 객체로 반환합니다. 이를 연관 배열로 변환 하려면 첫 번째 매개 변수로 true를 전달 하십시오.

The second and third parameters match up to the ``depth`` and ``options`` arguments of the
`json_decode <http://php.net/manual/en/function.json-decode.php>`_ PHP function.
두 번째와 세 번째 매개 변수 는 PHP 함수 `json_decode <http://php.net/manual/en/function.json-decode.php>`_ 의 ``depth`` ,  ``options`` 파라메터와 일치합니다 .

**원시 데이터 검색 (PUT, PATCH, DELETE)**

Finally, you can grab the contents of php://input as a raw stream with ``getRawInput()``
마지막으로, ``getRawInput()`` 를 사용하면 php:// 입력 내용을 원시 스트림으로 가져올 수 있습니다.
::

	$data = $request->getRawInput();

This will retrieve data and convert it to an array. Like this
그러면 데이터가 검색되어 배열로 변환됩니다. 이렇게
::

	var_dump($request->getRawInput());

	[
		'Param1' => 'Value1',
		'Param2' => 'Value2'
	]

입력 데이터 필터링
--------------------

To maintain security of your application, you will want to filter all input as you access it. You can
pass the type of filter to use in as the last parameter of any of these methods. The native ``filter_var()``
function is used for the filtering. Head over to the PHP manual for a list of `valid
filter types <http://php.net/manual/en/filter.filters.php>`_.
응용 프로그램의 보안을 유지하려면 액세스 할 때 모든 입력을 필터링해야합니다. 
이러한 메서드의 마지막 매개 변수로 사용할 필터 유형을 전달할 수 있습니다. 
네이티브 ``filter_var()`` 함수는 필터링에 사용됩니다. 
`유효한 필터 유형 목록 <http://php.net/manual/en/filter.filters.php>`_ 을 보려면 PHP 매뉴얼을 참조하십시오 .

Filtering a POST variable would look like this
POST 변수를 필터링하면 다음과 같습니다.
::

	$email = $request->getVar('email', FILTER_SANITIZE_EMAIL);

All of the methods mentioned above support the filter type passed in as the last parameter, with the
exception of ``getJSON()``.
위에서 언급 한 모든 메소드는 마지막 매개 변수로 전달 된 필터 유형을 지원합니다. (``getJSON()`` 제외)

헤더 가져오기
==================

You can get access to any header that was sent with the request with the ``getHeaders()`` method, which returns
an array of all headers, with the key as the name of the header, and the value being an instance of
``CodeIgniter\HTTP\Header``
``getHeaders()`` 메서드로 요청과 함께 전송 된 모든 헤더에 액세스 할 수 있습니다.이 메서드는 모든 헤더의 배열을 반환하며 헤더의 이름은 키이고 인스턴스의 값은 ``CodeIgniter\HTTP\Header`` 입니다.

::

	var_dump($request->getHeaders());

	[
		'Host'          => CodeIgniter\HTTP\Header,
		'Cache-Control' => CodeIgniter\HTTP\Header,
		'Accept'        => CodeIgniter\HTTP\Header,
	]

If you only need a single header, you can pass the name into the ``getHeader()`` method. This will grab the
specified header object in a case-insensitive manner if it exists. If not, then it will return ``null``
단일 헤더 만 있으면 ``getHeader()`` 메서드에 이름을 전달할 수 있습니다 . 지정된 헤더 객체가있는 경우 대소 문자를 구분하지 않고 가져옵니다. 그렇지 않은 경우에는 ``null`` 을 반환합니다.
::

	// these are all equivalent
	$host = $request->getHeader('host');
	$host = $request->getHeader('Host');
	$host = $request->getHeader('HOST');

You can always use ``hasHeader()`` to see if the header existed in this request
``hasHeader()`` 메소드를 사용하여 요청에 헤더가 있는지 확인할 수 있습니다.
::

	if ($request->hasHeader('DNT'))
	{
		// Don't track something...
	}

If you need the value of header as a string with all values on one line, you can use the ``getHeaderLine()`` method
한 줄에 모든 값이있는 문자열로 header 값이 필요한 경우 ``getHeaderLine()`` 메소드를 사용할 수 있습니다 .
::

    // Accept-Encoding: gzip, deflate, sdch
    echo 'Accept-Encoding: '.$request->getHeaderLine('accept-encoding');

If you need the entire header, with the name and values in a single string, simply cast the header as a string
하나의 문자열에 이름과 값을 포함한 전체 헤더가 필요한 경우 헤더를 문자열로 캐스트하십시오.
::

	echo (string)$header;

The Request URL
===============

You can retrieve a :doc:`URI <uri>` object that represents the current URI for this request through the
``$request->uri`` property. You can cast this object as a string to get a full URL for the current request::

	$uri = (string)$request->uri;

The object gives you full abilities to grab any part of the request on it's own::

	$uri = $request->uri;

	echo $uri->getScheme();         // http
	echo $uri->getAuthority();      // snoopy:password@example.com:88
	echo $uri->getUserInfo();       // snoopy:password
	echo $uri->getHost();           // example.com
	echo $uri->getPort();           // 88
	echo $uri->getPath();           // /path/to/page
	echo $uri->getQuery();          // foo=bar&bar=baz
	echo $uri->getSegments();       // ['path', 'to', 'page']
	echo $uri->getSegment(1);       // 'path'
	echo $uri->getTotalSegments();  // 3

Uploaded Files
==============

Information about all uploaded files can be retrieved through ``$request->getFiles()``, which returns a
:doc:`FileCollection </libraries/uploaded_files>` instance. This helps to ease the pain of working with uploaded files,
and uses best practices to minimize any security risks.
::

	$files = $request->getFiles();

	// Grab the file by name given in HTML form
	if ($files->hasFile('uploadedFile')
	{
		$file = $files->getFile('uploadedfile');

		// Generate a new secure name
		$name = $file->getRandomName();

		// Move the file to it's new home
		$file->move('/path/to/dir', $name);

		echo $file->getSize('mb');      // 1.23
		echo $file->getExtension();     // jpg
		echo $file->getType();          // image/jpg
	}

You can also retrieve a single file based on the filename given in the HTML file input::

	$file = $request->getFile('uploadedfile');

Content Negotiation
===================

You can easily negotiate content types with the request through the ``negotiate()`` method::

	$language    = $request->negotiate('language', ['en-US', 'en-GB', 'fr', 'es-mx']);
	$imageType   = $request->negotiate('media', ['image/png', 'image/jpg']);
	$charset     = $request->negotiate('charset', ['UTF-8', 'UTF-16']);
	$contentType = $request->negotiate('media', ['text/html', 'text/xml']);
	$encoding    = $request->negotiate('encoding', ['gzip', 'compress']);

See the :doc:`Content Negotiation </libraries/content_negotiation>` page for more details.

Class Reference
---------------

.. note:: In addition to the methods listed here, this class inherits the methods from the
	:doc:`Request Class </libraries/request>` and the :doc:`Message Class </libraries/message>`.

The methods provided by the parent classes that are available are:

* :meth:`CodeIgniter\\HTTP\\Request::getIPAddress`
* :meth:`CodeIgniter\\HTTP\\Request::validIP`
* :meth:`CodeIgniter\\HTTP\\Request::getMethod`
* :meth:`CodeIgniter\\HTTP\\Request::getServer`
* :meth:`CodeIgniter\\HTTP\\Message::body`
* :meth:`CodeIgniter\\HTTP\\Message::setBody`
* :meth:`CodeIgniter\\HTTP\\Message::populateHeaders`
* :meth:`CodeIgniter\\HTTP\\Message::headers`
* :meth:`CodeIgniter\\HTTP\\Message::header`
* :meth:`CodeIgniter\\HTTP\\Message::headerLine`
* :meth:`CodeIgniter\\HTTP\\Message::setHeader`
* :meth:`CodeIgniter\\HTTP\\Message::removeHeader`
* :meth:`CodeIgniter\\HTTP\\Message::appendHeader`
* :meth:`CodeIgniter\\HTTP\\Message::protocolVersion`
* :meth:`CodeIgniter\\HTTP\\Message::setProtocolVersion`
* :meth:`CodeIgniter\\HTTP\\Message::negotiateMedia`
* :meth:`CodeIgniter\\HTTP\\Message::negotiateCharset`
* :meth:`CodeIgniter\\HTTP\\Message::negotiateEncoding`
* :meth:`CodeIgniter\\HTTP\\Message::negotiateLanguage`
* :meth:`CodeIgniter\\HTTP\\Message::negotiateLanguage`

.. php:class:: CodeIgniter\\HTTP\\IncomingRequest

	.. php:method:: isCLI()

		:returns: True if the request was initiated from the command line, otherwise false.
		:rtype: bool

	.. php:method:: isAJAX()

		:returns: True if the request is an AJAX request, otherwise false.
		:rtype: bool

	.. php:method:: isSecure()

		:returns: True if the request is an HTTPS request, otherwise false.
		:rtype: bool

	.. php:method:: getVar([$index = null[, $filter = null[, $flags = null]]])

		:param  string  $index: The name of the variable/key to look for.
		:param  int     $filter: The type of filter to apply. A list of filters can be found `here <http://php.net/manual/en/filter.filters.php>`_.
		:param  int     $flags: Flags to apply. A list of flags can be found `here <http://php.net/manual/en/filter.filters.flags.php>`_.
		:returns:   $_REQUEST if no parameters supplied, otherwise the REQUEST value if found, or null if not
		:rtype: mixed|null

		The first parameter will contain the name of the REQUEST item you are looking for::

			$request->getVar('some_data');

		The method returns null if the item you are attempting to retrieve
		does not exist.

		The second optional parameter lets you run the data through the PHP's
		filters. Pass in the desired filter type as the second parameter::

			$request->getVar('some_data', FILTER_SANITIZE_STRING);

		To return an array of all POST items call without any parameters.

		To return all POST items and pass them through the filter, set the
		first parameter to null while setting the second parameter to the filter
		you want to use::

			$request->getVar(null, FILTER_SANITIZE_STRING); // returns all POST items with string sanitation

		To return an array of multiple  POST parameters, pass all the required keys as an array::

			$request->getVar(['field1', 'field2']);

		Same rule applied here, to retrieve the parameters with filtering, set the second parameter to
		the filter type to apply::

			$request->getVar(['field1', 'field2'], FILTER_SANITIZE_STRING);

	.. php:method:: getGet([$index = null[, $filter = null[, $flags = null]]])

		:param  string  $index: The name of the variable/key to look for.
		:param  int  $filter: The type of filter to apply. A list of filters can be found `here <http://php.net/manual/en/filter.filters.php>`_.
		:param  int     $flags: Flags to apply. A list of flags can be found `here <http://php.net/manual/en/filter.filters.flags.php>`_.
		:returns:   $_GET if no parameters supplied, otherwise the GET value if found, or null if not
		:rtype: mixed|null

		This method is identical to ``getVar()``, only it fetches GET data.

	.. php:method:: getPost([$index = null[, $filter = null[, $flags = null]]])

		:param  string  $index: The name of the variable/key to look for.
		:param  int  $filter: The type of filter to apply. A list of filters can be found `here <http://php.net/manual/en/filter.filters.php>`_.
		:param  int     $flags: Flags to apply. A list of flags can be found `here <http://php.net/manual/en/filter.filters.flags.php>`_.
		:returns:   $_POST if no parameters supplied, otherwise the POST value if found, or null if not
		:rtype: mixed|null

			This method is identical to ``getVar()``, only it fetches POST data.

	.. php:method:: getPostGet([$index = null[, $filter = null[, $flags = null]]])

		:param  string  $index: The name of the variable/key to look for.
		:param  int     $filter: The type of filter to apply. A list of filters can be found `here <http://php.net/manual/en/filter.filters.php>`_.
		:param  int     $flags: Flags to apply. A list of flags can be found `here <http://php.net/manual/en/filter.filters.flags.php>`_.
		:returns:   $_POST if no parameters supplied, otherwise the POST value if found, or null if not
		:rtype: mixed|null

		This method works pretty much the same way as ``getPost()`` and ``getGet()``, only combined.
		It will search through both POST and GET streams for data, looking first in POST, and
		then in GET::

			$request->getPostGet('field1');

	.. php:method:: getGetPost([$index = null[, $filter = null[, $flags = null]]])

		:param  string  $index: The name of the variable/key to look for.
		:param  int     $filter: The type of filter to apply. A list of filters can be found `here <http://php.net/manual/en/filter.filters.php>`_.
		:param  int     $flags: Flags to apply. A list of flags can be found `here <http://php.net/manual/en/filter.filters.flags.php>`_.
		:returns:   $_POST if no parameters supplied, otherwise the POST value if found, or null if not
		:rtype: mixed|null

		This method works pretty much the same way as ``getPost()`` and ``getGet()``, only combined.
		It will search through both POST and GET streams for data, looking first in GET, and
		then in POST::

			$request->getGetPost('field1');

	.. php:method:: getCookie([$index = null[, $filter = null[, $flags = null]]])

		:param	mixed	$index: COOKIE name
		:param  int     $filter: The type of filter to apply. A list of filters can be found `here <http://php.net/manual/en/filter.filters.php>`_.
		:param  int     $flags: Flags to apply. A list of flags can be found `here <http://php.net/manual/en/filter.filters.flags.php>`_.
		:returns:	$_COOKIE if no parameters supplied, otherwise the COOKIE value if found or null if not
		:rtype:	mixed

		This method is identical to ``getPost()`` and ``getGet()``, only it fetches cookie data::

			$request->getCookie('some_cookie');
			$request->getCookie('some_cookie', FILTER_SANITIZE_STRING); // with filter

		To return an array of multiple cookie values, pass all the required keys as an array::

			$request->getCookie(array('some_cookie', 'some_cookie2'));

		.. note:: Unlike the :doc:`Cookie Helper <../helpers/cookie_helper>`
			function :php:func:`get_cookie()`, this method does NOT prepend
			your configured ``$config['cookie_prefix']`` value.

	.. php:method:: getServer([$index = null[, $filter = null[, $flags = null]]])

		:param	mixed	$index: Value name
		:param  int     $filter: The type of filter to apply. A list of filters can be found `here <http://php.net/manual/en/filter.filters.php>`_.
		:param  int     $flags: Flags to apply. A list of flags can be found `here <http://php.net/manual/en/filter.filters.flags.php>`_.
		:returns:	$_SERVER item value if found, NULL if not
		:rtype:	mixed

		This method is identical to the ``getPost()``, ``getGet()`` and ``getCookie()``
		methods, only it fetches getServer data (``$_SERVER``)::

			$request->getServer('some_data');

		To return an array of multiple ``$_SERVER`` values, pass all the required keys
		as an array.
		::

			$request->getServer(['SERVER_PROTOCOL', 'REQUEST_URI']);

	.. php:method:: getUserAgent([$filter = null])

		:param  int  $filter: The type of filter to apply. A list of filters can be found `here <http://php.net/manual/en/filter.filters.php>`_.
		:returns:  The User Agent string, as found in the SERVER data, or null if not found.
		:rtype: mixed

		This method returns the User Agent string from the SERVER data::

			$request->getUserAgent();
