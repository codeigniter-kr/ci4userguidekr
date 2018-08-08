##########################
Working With HTTP Requests
##########################

In order to get the most out of CodeIgniter, you need to have a basic understanding of how HTTP requests
and responses work. Since this is what you work with while developing web applications, understanding the
concepts behind HTTP is a **must** for all developers that want to be successful.
CodeIgniter를 최대한 활용하려면 HTTP 요청 및 응답 방식에 대한 기본적인 이해가 필요합니다. 이 때문에 당신이 HTTP의 개념을 이해하고, 웹 애플리케이션을 개발하는 동안 작업하는 것은입니다 반드시 성공하고자하는 모든 개발자를위한.

The first part of this chapter gives an overview. After the concepts are out of the way, we will discuss
how to work with the requests and responses within CodeIgniter.
이 장의 첫 번째 부분에서는 개요를 제공합니다. 개념이 완전히 끝나면 CodeIgniter에서 요청과 응답을 처리하는 방법에 대해 설명합니다.

What is HTTP?
=============

HTTP is simply a text-based language that allows two machines to talk to each other. When a browser
requests a page, it asks the server if it can get the page. The server then prepares the page and sends
response back to the browser that asked for it. That's pretty much it. Obviously, there are some complexities
that you can use, but the basics are really pretty simple.
HTTP는 두 기계가 서로 대화 할 수있게하는 텍스트 기반 언어입니다. 브라우저가 페이지를 요청하면 페이지를 가져올 수 있는지 서버에 확인합니다. 그런 다음 서버는 페이지를 준비하고 요청한 브라우저에 응답을 보냅니다. 그것은 거의 그것입니다. 분명히, 당신이 사용할 수있는 몇 가지 복잡한 점이 있지만 기본은 매우 간단합니다.

HTTP is the term used to describe that language. It stands for HyperText Transfer Protocol. Your goal when
you develop web applications is to always understand what the browser is requesting, and be able to
respond appropriately.
HTTP는 해당 언어를 설명하는 데 사용되는 용어입니다. HyperText Transfer Protocol의 약자입니다. 웹 응용 프로그램을 개발할 때 브라우저가 무엇을 요구하는지 항상 이해하고 적절하게 응답 할 수 있어야합니다.

The Request
-----------
Whenever a client makes a request (a web browser, smartphone app, etc), it is sending a small text message
to the server and waits for a response.
클라이언트가 요청할 때마다 (웹 브라우저, 스마트 폰 앱 등) 서버에 작은 문자 메시지를 보내고 응답을 기다립니다.

The request would look something like this
요청은 다음과 같습니다.

::

	GET / HTTP/1.1
	Host codeigniter.com
	Accept: text/html
	User-Agent: Chrome/46.0.2490.80

This message displays all of the information necessary to know what the client is requesting. It tells the
method for the request (GET, POST, DELETE, etc), and the version of HTTP it supports.
이 메시지는 클라이언트가 요청한 정보를 알기 위해 필요한 모든 정보를 표시합니다. 요청 (GET, POST, DELETE 등) 및 지원되는 HTTP의 버전에 대한 메소드를 알려줍니다.

The request also includes a number of optional request headers that can contain a wide variety of
information such as what languages the client wants the content displayed as, the types of formats the
client accepts, and much more. Wikipedia has an article that lists `all header fields
<https://en.wikipedia.org/wiki/List_of_HTTP_header_fields>`_ if you want to look it over.
요청에는 클라이언트가 콘텐츠를 표시 할 언어, 클라이언트가 수락하는 형식 유형 등과 같은 다양한 정보를 포함 할 수있는 여러 선택적 요청 헤더가 포함됩니다. Wikipedia에는 모든 헤더 필드 를 열람 할 수 있는 기사가 있습니다.

The Response
------------

Once the server receives the request, your application will take that information and generate some output.
The server will bundle your output as part of its response to the client. This is also represented as
a simple text message that looks something like this
서버가 요청을 받으면 응용 프로그램은 해당 정보를 가져 와서 출력을 생성합니다. 서버는 출력을 클라이언트에 대한 응답의 일부로 묶습니다. 이것은 또한 다음과 같은 간단한 텍스트 메시지로도 표현됩니다.

::

	HTTP/1.1 200 OK
	Server: nginx/1.8.0
	Date: Thu, 05 Nov 2015 05:33:22 GMT
	Content-Type: text/html; charset=UTF-8

	<html>
		. . .
	</html>

The response tells the client what version of the HTTP specification that it's using and, probably most
importantly, the status code (200). The status code is one of a number of codes that have been standardized
to have a very specific meaning to the client. This can tell them that it was successful (200), or that the page
wasn't found (404). Head over to IANA for a `full list of HTTP status codes
<https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml>`_.
응답은 클라이언트에게 사용하고있는 HTTP 사양의 버전과 가장 중요한 것은 상태 코드 (200)를 알려줍니다. 상태 코드는 클라이언트에게 매우 특정한 의미를 갖도록 표준화 된 많은 코드 중 하나입니다. 이렇게하면 성공 (200) 또는 페이지를 찾을 수 없음 (404)을 알릴 수 있습니다. HTTP 상태 코드 의 전체 목록은 IANA에 문의하십시오 .

Working with Requests and Responses
-----------------------------------

While PHP provides ways to interact with the request and response headers, CodeIgniter, like most frameworks,
abstract them so that you have a consistent, simple interface to them. The :doc:`IncomingRequest class </libraries/incomingrequest>`
is an object-oriented representation of the HTTP request. It provides everything you need
PHP는 요청 및 응답 헤더와 상호 작용할 수있는 방법을 제공하지만 CodeIgniter는 대부분의 프레임 워크와 마찬가지로 일관성 있고 간단한 인터페이스를 제공하도록 추상화합니다. IncomingRequest 클래스는 HTTP 요청의 객체 지향의 표현이다. 필요한 모든 것을 제공합니다.

::

	use CodeIgniter\HTTP\IncomingRequest;

	$request = new IncomingRequest(new \Config\App(), new \CodeIgniter\HTTP\URI());

	// the URI being requested (i.e. /about)
	$request->uri->getPath();

	// Retrieve $_GET and $_POST variables
	$request->getVar('foo');
	$request->getGet('foo');
	$request->getPost('foo');

	// Retrieve JSON from AJAX calls
	$request->getJSON();

	// Retrieve server variables
	$request->getServer('Host');

	// Retrieve an HTTP Request header, with case-insensitive names
	$request->getHeader('host');
	$request->getHeader('Content-Type');

	$request->getMethod();  // GET, POST, PUT, etc

The request class does a lot of work in the background for you, that you never need to worry about.
The ``isAJAX()`` and ``isSecure()`` methods check several different methods to determine the correct answer.
요청 클래스는 백그라운드에서 당신을 걱정할 필요가없는 많은 작업을합니다. isAJAX()및 isSecure()방법은 정답을 결정하기 위해 여러 가지 방법을 확인하십시오.

CodeIgniter also provides a :doc:`Response class </libraries/response>` that is an object-oriented representation
of the HTTP response. This gives you an easy and powerful way to construct your response to the client
또한 CodeIgniter는 HTTP 응답의 객체 지향 표현 인 Response 클래스 를 제공합니다 . 이렇게하면 클라이언트에 대한 응답을 구성 할 수있는 쉽고 강력한 방법이 제공됩니다.

::

  use CodeIgniter\HTTP\Response;

  $response = new Response();

  $response->setStatusCode(Response::HTTP_OK);
  $response->setBody($output);
  $response->setHeader('Content-type', 'text/html');
  $response->noCache();

  // Sends the output to the browser
  $response->send();

In addition, the Response class allows you to work the HTTP cache layer for the best performance.
또한 Response 클래스를 사용하면 최상의 성능을 위해 HTTP 캐시 계층을 작업 할 수 있습니다.