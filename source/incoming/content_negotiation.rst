###############################
콘텐츠 협상(Content Negotiator)
###############################

콘텐츠 협상은 클라이언트가 처리할 수있는 내용과 서버가 처리할 수있는 내용을 기반으로 클라이언트에 반환할 콘텐츠 유형을 결정하는 방법입니다.
클라이언트가 HTML 또는 JSON을 반환하기를 원하는지, 이미지를 jpg 또는 png로 반환해야 하는지 여부, 지원되는 압축 유형 등을 결정하는데 사용할 수 있습니다.
이는 각각 고유한 우선 순위를 가진 여러 값 옵션을 지원할 수 있는 네 가지 헤더를 분석하여 수행됩니다.
이것을 수동으로 맞추는 것은 매우 어려울 수 있습니다.
CodeIgniter는 이를 처리할 수 있는 ``Negotiator`` 클래스를 제공합니다.

=================
클래스 로드
=================

Service 클래스를 통해 클래스 인스턴스를 수동으로 로드할 수 있습니다.

.. literalinclude:: content_negotiation/001.php

요청 인스턴스를 가져와 자동으로 Negotiator 클래스를 삽입합니다.

이 클래스는 로드할 필요없이 요청(reqest)의 ``IncomingRequest`` 인스턴스를 통해 액세스 할 수 있습니다.
클래스의 메소드를 직접 액세스할 수는 없지만 ``negotiate()`` 메소드를 통해 모든 메소드에 쉽게 액세스할 수 있습니다

.. literalinclude:: content_negotiation/002.php

이렇게 액세스할 때 첫 번째 매개 변수는 일치시키려는 컨텐츠 유형이고, 두 번째 매개 변수는 지원되는 값의 배열입니다.

===========
협상
===========

이 섹션에서는 협상할 수 있는 4 가지 유형의 컨텐츠에 대해 논의하고 협상자(negotiator)에게 액세스하기 위해 위에서 설명한 두 가지 방법을 어떻게 사용하는지 보여줍니다.

Media
=====

살펴볼 첫 번째 측면은 'media' 협상 처리입니다.
이들은 ``Accept`` 헤더에 의해 제공되며 가장 복잡한 헤더중 하나입니다.
일반적인 예는 클라이언트가 서버에게 데이터를 원하는 형식을 알려주는 것입니다.
이것은 API에서 특히 일반적입니다.
예를 들어, 아래와 같이 클라이언트는 API 엔드(End) 포인트에서 JSON 형식의 데이터를 요청할 수 있습니다.

::

    GET /foo HTTP/1.1
    Accept: application/json

서버는 이제 어떤 유형의 컨텐츠를 제공할 수 있는지 목록을 제공해야 합니다.
아래 예는 API가 HTML, JSON 또는 XML로 데이터를 반환하며, 선호하는 순서(JSON, HTML, XML)대로 제공합니다.

.. literalinclude:: content_negotiation/003.php

위의 경우 클라이언트와 서버 모두 데이터를 JSON으로 형식화하는데 동의하므로 협상 메소드에서 'json'이 반환됩니다.
기본적으로 일치하는 항목이 없으면 ``$supported`` 배열의 첫 번째 요소가 반환됩니다.
그러나 때에 따라 형식을 엄격하게 일치시켜야 할 수도 있습니다.
``true``\ 를 최종 값으로 전달하면 일치하는 항목이 없을때 빈 문자열이 반환됩니다.

.. literalinclude:: content_negotiation/004.php

Language
========

또 다른 일반적인 사용법은 콘텐츠를 제공할 언어를 결정하는 것입니다.
브라우저는 일반적으로 ``Accept-Language`` 헤더에 선호하는 언어를 보냅니다.
이는 단일 언어로 구성된 사이트를 운영하는 경우에는 큰 의미가 없으나, 여러 언어로 번역 콘텐츠를 제공할 수 있는 사이트에서는 이 기능이 유용합니다. 

::

    GET /foo HTTP/1.1
    Accept-Language: fr; q=1.0, en; q=0.5

이 예에서 브라우저는 영어와 두 번째로 프랑스어를 선호합니다.
당신의 웹 사이트가 영어와 독일어를 지원한다면

.. literalinclude:: content_negotiation/005.php

이 예는 협상 결과로 'en'이 반환됩니다.
일치하는 것이 없으면 ``$supported`` 배열의 첫 번째 요소를 반환하므로 선호하는 언어를 첫 번째로 설정합니다.

Encoding
========

``Accept-Encoding`` 헤더에는 라이언트가 이해 가능한 컨텐츠 인코딩이 무엇인지 알려주며, 클라이언트가 지원하는 압축 유형을 지정하는 데 사용됩니다

::

    GET /foo HTTP/1.1
    Accept-Encoding: compress, gzip

웹 서버는 사용할 수있는 압축 유형을 정의합니다.
Apache와 같은 일부 웹 서버는 **gzip**\ 만 지원합니다.

.. literalinclude:: content_negotiation/006.php

`Wikipedia <https://en.wikipedia.org/wiki/HTTP_compression>`_\ 에서 더 많은 것을 보십시오.

Character Set
=============

원하는 문자 세트는 ``Accept-Charset`` 헤더를 통해 전달됩니다

::

    GET /foo HTTP/1.1
    Accept-Charset: utf-16, utf-8

일치하는 항목이 없으면 기본적으로 **utf-8**\ 이 반환됩니다.

.. literalinclude:: content_negotiation/007.php

