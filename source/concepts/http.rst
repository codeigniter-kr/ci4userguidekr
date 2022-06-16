##########################
HTTP 요청(Requests) 작업 
##########################

CodeIgniter를 최대한 활용하려면 HTTP 요청 및 응답의 작동 방식에 대한 기본적인 이해가 필요합니다.
웹 어플리케이션을 개발하는 동안 이 작업이 수행되므로 HTTP의 개념을 이해하는 것은 모든 개발자에게 **필수** 입니다.

이 장의 첫 부분은 개요를 제공합니다.
개념이 끝나면 CodeIgniter 내에서 요청 및 응답을 처리하는 방법에 대해 논의합니다.

.. contents::
    :local:
    :depth: 2

HTTP 란 무엇입니까?
***********************

HTTP는 단순히 두 시스템이 서로 통신 할 수있는 텍스트 기반 규칙입니다
브라우저가 페이지를 요청하면 서버가 페이지를 가져올 수 있는지 묻습니다.
그런 다음 서버는 페이지를 준비하고 요청한 브라우저로 응답을 보냅니다.
분명히 사용할 수 있는 몇 가지 복잡성이 있지만 기본 사항은 매우 간단합니다.

HTTP는 해당 교환 규칙을 설명하는 데 사용되는 용어이며 하이퍼 텍스트 전송 프로토콜(HyperText Transfer Protocol)라는 정식 명칭을 가지고 있습니다.
웹 어플리케이션을 개발할 때는 항상 브라우저가 요청하는 내용을 이해하고 적절하게 대응할 수 있어야 합니다.

요청(request)
================

클라이언트(web browser, smartphone app, etc)가 요청을하면 작은 문자 메시지를 서버로 보내고 응답을 기다립니다.

요청은 다음과 같습니다::

    GET / HTTP/1.1
    Host codeigniter.com
    Accept: text/html
    User-Agent: Chrome/46.0.2490.80

이 메시지는 클라이언트가 요청하는 내용을 알기 위해 필요한 모든 정보를 표시합니다.
요청 방법(GET, POST, DELETE, etc)과 지원하는 HTTP 버전을 알려줍니다.

요청에는 클라이언트가 컨텐츠를 표시하려는 언어, 클라이언트가 허용하는 형식 유형 등과 같은 다양한 정보를 포함할 수 있는 여러 선택적 요청 헤더도 포함됩니다.
Wikipedia에는 `모든 헤더 필드 <https://en.wikipedia.org/wiki/List_of_HTTP_header_fields>`_\ 를 나열하는 기사가 있습니다.

응답(Response)
================

서버가 요청을 받으면 어플리케이션에서 해당 정보를 가져 와서 결과물 일부를 생성합니다.
서버는 클라이언트에 대한 응답 결과물을 번들로 묶어 이와 같은 단순한 문자 메시지로 표현됩니다.::

    HTTP/1.1 200 OK
    Server: nginx/1.8.0
    Date: Thu, 05 Nov 2015 05:33:22 GMT
    Content-Type: text/html; charset=UTF-8

    <html>
        . . .
    </html>

응답은 클라이언트에게 사용중인 HTTP 사양의 버전과 상태 코드(200)를 알려줍니다.
상태 코드는 클라이언트에게 매우 특정한 의미를 갖도록 표준화 된 여러 코드중 하나입니다
이를 통해 성공(200)했거나 페이지를 찾을 수 없음(404)을 알 수 있습니다. `전체 HTTP 코드 목록 <https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml>`_\ 을 보려면 IANA로 가십시오.

요청 및 응답에 대한 작업
***********************************

PHP는 요청 및 응답 헤더와 상호 작용하는 방법을 제공하지만 CodeIgniter는 대부분의 프레임워크와 마찬가지로 일관되고 간단한 인터페이스를 제공하도록 추상화합니다.
:doc:`IncomingRequest class </incoming/incomingrequest>` 클래스는 HTTP 요청의 객체 지향 표현(representation)이며 필요한 모든 것을 제공합니다.

.. literalinclude:: http/001.php

요청 클래스는 여러분을 위해 백그라운드에서 많은 작업을 수행합니다.
``isAJAX()`` 및 ``isSecure()`` 메소드는 여러 가지 다른 방법으로 이를 확인하여 올바른 답을 결정합니다.

.. note:: ``isAJAX()`` 메소드는 ``X-Requested-With`` 헤더에 의존하며, 경우에 따라 JavaScript를 통해 XHR 요청을 할 때 기본적으로 전송되지 않을 수 있습니다.(i.e fetch)
    이 문제를 방지하는 방법에 대해서는 :doc:`AJAX 요청(Requests) </general/ajax>` 섹션을 참조하십시오.

CodeIgniter는 HTTP 응답의 객체 지향 표현인 :doc:`Response class </outgoing/response>`\ 도 제공하며, 이를 통해 클라이언트에 대한 응답을 쉽고 강력하게 구성할 수 있습니다.

.. literalinclude:: http/002.php

Response 클래스를 사용하면 최상의 성능을 위해 HTTP 캐시 레이어(layer)를 사용할 수 있습니다.
