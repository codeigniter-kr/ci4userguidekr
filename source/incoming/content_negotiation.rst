*******************
콘텐츠 협상
*******************

Content negotiation is a way to determine what type of content to return to the client based on what the client
can handle, and what the server can handle. This can be used to determine whether the client is wanting HTML or JSON
returned, whether the image should be returned as a jpg or png, what type of compression is supported and more. This
is done by analyzing four different headers which can each support multiple value options, each with their own priority.
Trying to match this up manually can be pretty challenging. CodeIgniter provides the ``Negotiator`` class that
can handle this for you.
콘텐츠 협상은 클라이언트가 처리 할 수있는 내용과 서버가 처리 할 수있는 내용에 따라 클라이언트에 반환 할 콘텐츠 유형을 결정하는 방법입니다. 클라이언트가 HTML 또는 JSON을 반환할지 여부, 이미지를 jpg 또는 png로 반환할지 여부, 지원되는 압축 유형 등을 결정하는 데 사용할 수 있습니다. 이것은 네 개의 다른 헤더를 분석하여 수행됩니다. 각각의 헤더는 여러 값 옵션을 지원할 수 있으며 각 옵션마다 고유 한 우선 순위가 있습니다. 이것을 수동으로 맞추려고하면 꽤 어려울 수 있습니다. CodeIgniter는 이것을 처리 할 수 있는 ``Negotiator`` 클래스를 제공합니다 .

=================
Loading the Class
=================

You can load an instance of the class manually through the Service class
Service 클래스를 통해 클래스의 인스턴스를 수동으로로드 할 수 있습니다.

::

	$negotiator = \Config\Services::negotiator();

This will grab the current request instance and automatically inject it into the Negotiator class.
그러면 현재 요청 인스턴스를 잡고 Negotiator 클래스에 자동으로 주입합니다.

This class does not need to be loaded on it's own. Instead, it can be accessed through this request's ``IncomingRequest``
instance. While you cannot access it directly this way, you can easily access all of methods through the ``negotiate()``
method
이 클래스는 자체적으로로드 할 필요가 없습니다. 대신이 request의 ``IncomingRequest`` 인스턴스를 통해 액세스 할 수 있습니다 . 이런 식으로 직접 액세스 할 수는 없지만 ``negotiate()`` 메서드를 통해 모든 메서드에 쉽게 액세스 할 수 있습니다.

::

	$request->negotiate('media', ['foo', 'bar']);

When accessed this way, the first parameter is the type of content you're trying to find a match for, while the
second is an array of supported values.
이 방법으로 액세스하면 첫 번째 매개 변수는 일치하는 항목을 찾는 데 사용되는 유형이며 두 번째 매개 변수는 지원되는 값의 배열입니다.

===========
협상
===========

In this section we will discuss the 4 types of content that can be negotiated and show how that would look using
both of the methods described above to access the negotiator.
이 섹션에서는 협상 할 수있는 4 가지 유형의 컨텐츠에 대해 논의하고 위에서 설명한 두 가지 방법을 사용하여 협상자에게 액세스하는 방법을 보여줍니다.

Media
=====

The first aspect to look at is handling 'media' negotiations. These are provided by the ``Accept`` header and
is one of the most complex headers available. A common example is the client telling the server what format it
wants the data in. This is especially common in API's. For example, a client might request JSON formatted data
from an API endpoint
먼저 미디어 협상을 다뤄야한다. ``Accept`` 헤더 에 의해 제공되며 가장 복잡한 헤더 중 하나입니다. 일반적인 예는 데이터를 원하는 형식으로 서버에 알려주는 클라이언트입니다. 이는 API에서 특히 일반적입니다. 예를 들어 클라이언트가 API 끝점에서 JSON 형식의 데이터를 요청할 수 있습니다.

::

	GET /foo HTTP/1.1
	Accept: application/json

The server now needs to provide a list of what type of content it can provide. In this example, the API might
be able to return data as raw HTML, JSON, or XML. This list should be provided in order of preference
이제 서버는 제공 할 수있는 콘텐츠 유형 목록을 제공해야합니다. 이 예에서 API는 원시 HTML, JSON 또는 XML로 데이터를 반환 할 수 있습니다. 이 목록은 우선 순위에 따라 제공되어야합니다.

::

	$supported = [
		'application/json',
		'text/html',
		'application/xml'
	];

	$format = $request->negotiate('media', $supported);
	// or
	$format = $negotiate->media($supported);

In this case, both the client and the server can agree on formatting the data as JSON so 'json' is returned from
the negotiate method. By default, if no match is found, the first element in the $supported array would be returned.
In some cases, though, you might need to enforce the format to be a strict match. If you pass ``true`` as the
final value, it will return an empty string if no match is found
이 경우 클라이언트와 서버 모두 JSON 형식으로 데이터를 합의하므로 'json'이 협상 메서드에서 반환됩니다. 기본적으로 일치하는 항목이 없으면 $ 지원되는 배열의 첫 번째 요소가 반환됩니다. 그러나 경우에 따라 형식을 엄격하게 일치시켜야 할 수도 있습니다. 최종 값으로 ``true`` 를 전달 하면 일치하는 항목이없는 경우 빈 문자열이 반환됩니다.

::

	$format = $request->negotiate('media', $supported, true);
	// or
	$format = $negotiate->media($supported, true);

언어
========

Another common usage is to determine the language the content should be served in. If you are running only a single
language site, this obviously isn't going to make much difference, but any site that can offer up multiple translations
of content will find this useful, since the browser will typically send the preferred language along in the ``Accept-Language``
header
또 다른 일반적인 용도는 콘텐츠가 제공되어야하는 언어를 결정하는 것입니다. 단일 언어 사이트 만 실행하는 경우 분명히 많은 차이를 만들지는 않을 것입니다. 그러나 여러 개의 콘텐츠 번역을 제공 할 수있는 사이트에서는 브라우저에서 일반적으로 ``Accept-Language`` 헤더에 기본 언어를 전송하므로 유용합니다 .

::

	GET /foo HTTP/1.1
	Accept-Language: fr; q=1.0, en; q=0.5

In this example, the browser would prefer French, with a second choice of English. If your website supports English
and German you would do something like
이 예에서 브라우저는 프랑스어를 선호하고 영어를 두 번째로 선택하였습니다. 귀하의 웹 사이트가 영어와 독일어를 지원한다면 다음과 같이하십시오

::

	$supported = [
		'en',
		'de'
	];

	$lang = $request->negotiate('language', $supported);
	// or
	$lang = $negotiate->language($supported);

In this example, 'en' would be returned as the current language. If no match is found, it will return the first element
in the $supported array, so that should always be the preferred language.
이 예제에서는 'en'이 현재 언어로 반환됩니다. 일치하는 항목이 없으면 $ supported 배열의 첫 번째 요소를 반환하므로 항상 기본 언어 여야합니다.

Encoding
========

The ``Accept-Encoding`` header contains the character sets the client prefers to receive, and is used to
specify the type of compression the client supports
``Accept-Encoding`` 헤더는 문자를 클라이언트가 받을 선호 설정하고 클라이언트가 지원하는 압축 형식을 지정하는 데 사용됩니다 포함

::

	GET /foo HTTP/1.1
	Accept-Encoding: compress, gzip

Your web server will define what types of compression you can use. Some, like Apache, only support **gzip**
웹 서버는 사용할 수있는 압축 유형을 정의합니다. 일부는 아파치와 마찬가지로 **gzip** 만 지원합니다 .

::

	$type = $request->negotiate('encoding', ['gzip']);
	// or
	$type = $negotiate->encoding(['gzip']);

See more at `Wikipedia <https://en.wikipedia.org/wiki/HTTP_compression>`_.

Character Set
=============

The desired character set is passed through the ``Accept-Charset`` header
원하는 character set가 ``Accept-Charset`` 헤더를 통해 전달됩니다 .

::

	GET /foo HTTP/1.1
	Accept-Charset: utf-16, utf-8

By default, if no matches are found, **utf-8** will be returned
기본적으로 일치하는 항목이 없으면 utf-8 이 반환됩니다.

::

	$charset = $request->negotiate('charset', ['utf-8']);
	// or
	$charset = $negotiate->charset(['utf-8']);

