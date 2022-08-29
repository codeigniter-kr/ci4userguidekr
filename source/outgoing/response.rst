========================
HTTP 응답(Responses)
========================

Response 클래스는 호출 한 클라이언트에 적합한 메소드를 사용하여 :doc:`HTTP 메시지 클래스 </incoming/message>`\ 를 확장합니다.

.. contents::
    :local:
    :depth: 2

응답 작업
=========================

응답(Response) 클래스가 인스턴스화되어 컨트롤러로 전달됩니다.
응답 클래스는 ``$this->response``\ 를 통해 액세스할 수 있습니다.
CodeIgniter가 헤더와 본문 전송을 담당하므로 클래스를 직접 만지게되는 경우는 드믑니다.
페이지가 요청한 내용을 성공적으로 만들면 좋습니다.
문제가 발생하거나 매우 특정한 상태 코드를 다시 보내거나 강력한 HTTP 캐싱을 활용해야 할 때 유용합니다.

출력 설정
------------------

스크립트 출력을 직접 설정해야 하고 자동으로 가져 오기 위해 CodeIgniter에 의존하지 않는 경우 ``setBody`` 메소드를 사용하여 수동으로 수행하십시오.
이것은 일반적으로 응답의 상태 코드 설정과 함께 사용됩니다

.. literalinclude:: response/001.php

이유(reason) 문구('OK', 'Created', 'Moved Permanently')가 자동으로 추가되지만 ``setStatusCode()`` 메소드의 두 번째 매개 변수로 사용자 정의 이유(reason)를 추가할 수 있습니다.

.. literalinclude:: response/002.php

배열을 ``setJSON``\ 과 ``setXML`` 메소드를 사용하여 JSON 또는 XML로 형식화하고 컨텐츠 유형 헤더를 적절한 MIME으로 설정할 수 있습니다.
일반적으로 변환할 데이터 배열을 보냅니다.

.. literalinclude:: response/003.php

헤더 설정
---------------

응답에 대해 헤더를 설정해야 하는 경우가 종종 있습니다.
응답(Response) 클래스는 ``setHeader()`` 메소드를 사용하여 이것을 매우 간단하게 만듭니다.
첫 번째 매개 변수는 헤더의 이름입니다.
두 번째 매개 변수는 값으로, 클라이언트로 전송될 때 올바르게 결합될 문자열 또는 값의 배열입니다.
기본 PHP 함수를 사용하는 대신 이러한 함수를 사용하면 헤더가 조기에 전송되지 않아 오류가 발생하고 테스트할 수 있습니다.

.. literalinclude:: response/004.php

헤더가 존재하고 둘 이상의 값을 가질 수 있는 경우 ``appendHeader()``\ 과 ``prependHeader()`` 메소드를 사용하여 값을 각각 값 목록의 끝 또는 시작에 추가할 수 있습니다.
첫 번째 매개 변수는 헤더의 이름이고 두 번째 매개 변수는 추가하거나 추가할 값입니다.

.. literalinclude:: response/005.php

헤더 이름을 단일 매개 변수로 사용하는 ``removeHeader()`` 메소드를 사용하여 응답에서 헤더를 제거할 수 있습니다.
대소 문자를 구분하지 않습니다.

.. literalinclude:: response/006.php

강제 파일 다운로드
===================

응답(Response) 클래스는 클라이언트에게 파일을 보내는 간단한 방법을 제공하여 브라우저에 데이터를 컴퓨터로 다운로드하라는 메시지를 표시합니다.
이렇게하면 적절한 헤더가 설정됩니다.

첫 번째 매개 변수는 **다운로드 한 파일의 이름을 지정** 하는 이름이고, 두 번째 매개 변수는 파일 데이터입니다.

두 번째 매개 변수를 null로 설정하고 ``$filename``\ 이 읽을 수 있는 파일 경로인 경우 해당 내용을 대신 읽습니다.

세 번째 매개 변수를 true(boolean)로 설정하면 실제 파일 MIME 유형 (파일 이름 확장자를 기준으로)이 전송되고, 브라우저에 해당 유형에 대한 핸들러가 있는 경우 이를 사용할 수 있습니다.

Example

.. literalinclude:: response/007.php

서버에서 기존 파일을 다운로드하려면 두 번째 매개 변수에 명시적으로 ``null``\ 을 전달해야 합니다.

.. literalinclude:: response/008.php

``setFileName()`` 메소드를 사용하면 클라이언트 브라우저로 전송될 때 파일 이름을 변경할 수 있습니다.

.. literalinclude:: response/009.php

.. note:: 다운로드가 클라이언트로 전송되려면 반드시 응답 객체를 반환해야합니다.
    이를 통해 클라이언트로 전송되기 전에 모든 **이후(after)** 필터를 통해 응답을 전달할 수 있습니다.

HTTP 캐싱(Caching)
======================

HTTP 사양에는 클라이언트(종종 웹 브라우저)가 결과를 캐시하는데 도움이 되는 도구가 내장되어 있습니다.
올바르게 사용되면 아무것도 변경되지 않았으므로 클라이언트에 서버에 연결할 필요가 없다는 사실을 알리기 때문에 애플리케이션의 성능이 크게 향상될 수 있습니다.

이는 ``Cache-Control``\ 와 ``ETag`` 헤더를 통해 처리됩니다.
이 안내서는 모든 캐시 헤더 기능을 완전히 소개하기에 적합한 곳은 아니지만 
`Google Developers <https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching>`_\ 에서 잘 이해할 수 있습니다.

기본적으로 CodeIgniter를 통해 전송된 모든 응답 오브젝트에는 HTTP 캐싱이 해제되어 있습니다.
옵션과 정확한 환경은 너무 다양하여 기본 설정을 해제하는것을 제외한 다른 기본 설정을 만들 수 없습니다.
그러나 ``setCache()`` 메소드를 이용하면 필요한 캐쉬 값을 설정할 수 있습니다.

.. literalinclude:: response/010.php

``$options`` 배열은 몇 가지 예외를 제외하고 ``Cache-Control`` 헤더에 지정된 키/값 쌍의 배열을 취합니다.
특정 상황에 필요한대로 모든 옵션을 자유롭게 설정할 수 있습니다.
대부분의 옵션은 ``Cache-Control`` 헤더에 적용되지만 ``etag``\ 와 ``last-modified`` 옵션은 해당 헤더에 지능적으로 처리합니다.

.. _content-security-policy:

콘텐츠 보안 정책
=======================

XSS 공격에 대한 최선의 보호 방법 중 하나는 사이트에서 콘텐츠 보안 정책을 구현하는 것입니다.
이렇게하면 이미지, 스타일 시트, 자바 스크립트 파일 등 사이트의 HTML에서 가져온 모든 단일 컨텐츠 소스를 허용해야합니다.
브라우저는 화이트리스트에 맞지 않는 소스의 콘텐츠를 거부합니다.
이 화이트리스트는 응답의 ``Content-Security-Policy`` 헤더내에 생성되며 다양한 방법으로 구성할 수 있습니다.

이것은 복잡하게 들리며 일부 사이트에서는 확실히 어려울 수 있습니다.
그러나 모든 콘텐츠가 동일한 도메인(http://example.com)에 의해 제공되는 여러 간단한 사이트의 경우 통합이 매우 간단합니다.

이 주제는 복잡한 주제이므로 이 가이드에서는 모든 세부 사항을 다루지는 않습니다.
자세한 내용은 다음 사이트를 방문하십시오:

* `Content Security Policy main site <https://content-security-policy.com/>`_
* `W3C Specification <https://www.w3.org/TR/CSP>`_
* `Introduction at HTML5Rocks <https://www.html5rocks.com/en/tutorials/security/content-security-policy/>`_
* `Article at SitePoint <https://www.sitepoint.com/improving-web-security-with-the-content-security-policy/>`_

CSP 켜기
--------

기본적으로 이 기능은 꺼져있습니다. 
어플리케이션에서 지원을 활성화하려면  **app/Config/App.php**\ 에서 ``CSPEnabled`` 값을 수정하십시오.

.. literalinclude:: response/011.php

활성화되면 응답 객체에 ``CodeIgniter\HTTP\ContentSecurityPolicy`` 인스턴스가 포함됩니다.
**app/Config/ContentSecurityPolicy.php**\ 에 설정된 값이 해당 인스턴스에 적용되며 런타임동안 변경이 필요하지 않으면 올바른 형식의 헤더가 전송되고 모든 작업이 완료됩니다.

CSP를 사용하면 두 개의 헤더 행이 HTTP 응답에 추가됩니다: 
다양한 컨텍스트에 대해 명시적으로 허용되는 컨텐츠 유형 또는 출처를 식별하는 정책이 포함된 **Content-Security-Policy** 헤더와 허용되지만 허용될 컨텐츠 유형 또는 출처를 식별하는 **Content-Security-Policy-Report-Only** 헤더.

우리의 구현은 ``reportOnly()`` 메소드를 통해 변경 가능한 기본 처리를 제공합니다.
CSP 지시문에 추가 항목을 추가하면 아래와 같이 차단 또는 방지에 적합한 CSP 헤더가 추가됩니다.
추가 메소드 호출에 선택적 두 번째 매개 변수를 제공하여 호출마다 대체할 수 있습니다.

런타임 구성
-----------

어플리케이션이 런타임중에 변경해야 하는 경우 컨트롤러의 ``$this->response->CSP``\ 를 통하여 인스턴스에 액세스 할 수 있습니다.
이 클래스에는 설정해야 할 적절한 헤더 값에 매우 명확하게 매핑되는 많은 메소드가 있습니다.
아래 예제는 모두 지시어 이름과 일련의 매개 변수로 표시하지만 이들은 모두 배열을 허용합니다.

.. literalinclude:: response/012.php

각 "add" 메소드에 대한 첫 번째 매개 변수는 적절한 문자열 또는 배열입니다.

``reportOnly`` 메소드를 사용하면 재정의하지 않는 한 후속 소스에 대한 기본 보고 처리를 지정할 수 있습니다.
예를 들어 youtube.com을 허용하도록 지정한 다음, 허용되지만 보고하는 다른 소스를 여러 개 제공할 수 있습니다.

.. literalinclude:: response/013.php

인라인 컨텐츠
-----------------

인라인 스크립트 및 스타일은 사용자 생성 컨텐츠의 결과일 수 있기 때문에 보호하지 않도록 웹 사이트를 설정할 필요가 있습니다.
``<style>``\ 와 ``<script>`` 태그에 ``{csp-style-nonce}`` 또는 ``{csp-script-nonce}`` 자리 표시자를 포함하면 자동으로 간단하게 처리됩니다.

::

    // Original
    <script {csp-script-nonce}>
        console.log("Script won't run as it doesn't contain a nonce attribute");
    </script>

    // Becomes
    <script nonce="Eskdikejidojdk978Ad8jf">
        console.log("Script won't run as it doesn't contain a nonce attribute");
    </script>

    // OR
    <style {csp-style-nonce}>
        . . .
    </style>

.. warning:: 공격자가 ``<script {csp-script-nonce}>``\ 와 같은 문자열을 삽입하면 이 기능으로 실제 nonce 속성이 될 수 있습니다. **app/Config/ContentSecurityPolicy.php**\ 에서 ``$scriptNonceTag``\ 와 ``$styleNonceTag`` 속성을 사용하여 자리 표시자 문자열을 사용자 정의할 수 있습니다.

이 자동 교체 기능이 마음에 들지 않으면 **app/Config/ContentSecurityPolicy.php**\ 에서 ``$autoNonce = false``\ 를 설정하여 이 기능을 끌 수 있습니다.

이 경우 ``csp_script_nonce()``\ 와 ``csp_style_nonce()`` 함수를 사용할 수 있습니다.

::

    // Original
    <script <?= csp_script_nonce() ?>>
        console.log("Script won't run as it doesn't contain a nonce attribute");
    </script>

    // Becomes
    <script nonce="Eskdikejidojdk978Ad8jf">
        console.log("Script won't run as it doesn't contain a nonce attribute");
    </script>

    // OR
    <style <?= csp_style_nonce() ?>>
        . . .
    </style>

***************
Class Reference
***************

.. note:: 여기에 나열된 메소드 외에 이 클래스는 :doc:`메시지 클래스 </incoming/message>`\ 의 메소드를 상속합니다..

사용 가능한 부모 클래스가 제공하는 메소드는 다음과 같습니다:

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

.. php:namespace:: CodeIgniter\HTTP

.. php:class:: Response

    .. php:method:: getStatusCode()

        :returns: HTTP 상태 코드
        :rtype: int

        응답(Response)의 현재 상태 코드를 반환합니다. 상태 코드가 설정되지 않은 경우 ``BadMethodCallException``\ 이 발생합니다.
        
        .. literalinclude:: response/014.php

    .. php:method:: setStatusCode($code[, $reason=''])

        :param int $code: HTTP 상태 코드
        :param string $reason: 이유 문구
        :returns: Response 인스턴스
        :rtype: CodeIgniter\HTTP\Response

        응답과 함께 보내야하는 HTTP 상태 코드를 설정합니다.

        .. literalinclude:: response/015.php

        이유 문구는 공식 목록에 따라 자동으로 생성됩니다.
        사용자 정의 상태 코드에 대한 고유한 설정이 필요한 경우 이유 문구를 두 번째 매개 변수로 전달할 수 있습니다.
        
        .. literalinclude:: response/016.php

    .. php:method:: getReasonPhrase()

        :returns: 이유 문구.
        :rtype: string

        응답의 현재 상태 코드에 대한 문구를 반환합니다. 상태가 설정되지 않은 경우 빈 문자열을 반환합니다.
        
        .. literalinclude:: response/017.php

    .. php:method:: setDate($date)

        :param DateTime $date: 응답에 설정할 DateTime 인스턴스
        :returns: response 인스턴스.
        :rtype: CodeIgniter\HTTP\Response

        응답에 사용될 날짜를 설정합니다. The ``$date``\ 는 ``DateTime``\ 의 인스턴스여야 합니다  
        
        .. literalinclude:: response/018.php

    .. php:method:: setContentType($mime[, $charset='UTF-8'])

        :param string $mime: 응답의 컨텐츠 유형
        :param string $charset: 응답이 사용하는 문자 세트
        :returns: response 인스턴스.
        :rtype: CodeIgniter\HTTP\Response

        응답의 내용 유형을 설정합니다.
        
        .. literalinclude:: response/019.php

        이 메소드는 문자 집합은 기본적으로 ``UTF-8``\ 로 설정합니다.
        이를 변경해야 하는 경우 문자 세트를 두 번째 매개 변수로 전달할 수 있습니다.
        
        .. literalinclude:: response/020.php

    .. php:method:: noCache()

        :returns: response 인스턴스.
        :rtype: CodeIgniter\HTTP\Response

        모든 HTTP 캐싱을 끄도록 ``Cache-Control`` 헤더를 설정합니다.
        모든 응답 메시지의 기본 설정값입니다.
        
        .. literalinclude:: response/021.php

    .. php:method:: setCache($options)

        :param array $options: 키/값 캐시 제어 설정 배열
        :returns: response 인스턴스.
        :rtype: CodeIgniter\HTTP\Response

        ``ETags``\ 와 ``Last-Modified``\ 를 포함하여 ``Cache-Control`` 헤더를 설정합니다.
        대표적으로 많이 사용되는 키:

        * etag
        * last-modified
        * max-age
        * s-maxage
        * private
        * public
        * must-revalidate
        * proxy-revalidate
        * no-transform

        ``last-modified`` 옵션은 날짜 문자열 또는 DateTime 개체일 수 있습니다.

    .. php:method:: setLastModified($date)

        :param string|DateTime $date: Last-Modified 헤더를 설정할 날짜
        :returns: response 인스턴스.
        :rtype: CodeIgniter\HTTP\Response

        ``Last-Modified`` 헤더를 설정합니다. ``$date`` 객체는 문자열 또는 ``DateTime`` 인스턴스일 수 있습니다.
        
        .. literalinclude:: response/022.php

    .. php:method:: send()
        :noindex:

        :returns: response 인스턴스.
        :rtype: CodeIgniter\HTTP\Response

        모든것을 클라이언트로 다시 보내도록 응답(Response)에 지시합니다.
        먼저 헤더를 보낸 다음 응답 본문을 보냅니다.
        어플리케이션의 기본 응답인 경우 CodeIgniter에서 자동으로 처리하므로 이를 호출할 필요가 없습니다.

    .. php:method:: setCookie($name = ''[, $value = ''[, $expire = ''[, $domain = ''[, $path = '/'[, $prefix = ''[, $secure = false[, $httponly = false[, $samesite = null]]]]]]]])

        :param array|Cookie|string $name: 쿠키명 또는 매개 변수 배열
        :param string $value: 쿠키값
        :param int $expire: 쿠키 만료 시간(초)
        :param string $domain: 쿠키 domain
        :param string $path: 쿠키 path
        :param string $prefix: 쿠키명 prefix. ``''``\ 로 설정하면 **app/Config/Cookie.php**\ 의 기본값이 사용됩니다.
        :param bool $secure: HTTPS를 통해서만 쿠키를 전송할지 여부
        :param bool $httponly: HTTP 요청에 대해서만 쿠키에 액세스 할 수 있는지 여부 (no JavaScript)
        :param string $samesite: SameSite 쿠키 매개 변수의 값. ``''``\ 로 설정하면 쿠키에 SameSite 속성이 설정되지 않습니다. ``null``\ 로 설정하면 **app/Config/Cookie.php** 값이 사용됩니다.

        :rtype: void

        지정한 값이 포함된 쿠키를 설정합니다.
        이 메소드로 쿠키를 설정 정보를 전달할 때 연관 배열과 개별 매개 변수(Discrete Parameters) 두 가지 방법을 사용할 수 있습니다.

        **연관 배열**

        연관 배열을 첫 번째 매개 변수로 전달합니다.
        
        .. literalinclude:: response/023.php

        이름과 값만 필요합니다. 
        쿠키를 삭제하려면 ``expire``\ 를 공백(blank)으로 쿠키를 설정하십시오.

        쿠키 만료 시간은 **초** 단위로 설정되며, 현재 시간에 추가됩니다.
        시간을 포함하지 말고 쿠키가 유효하기를 원하는 *지금* 이후의 시간(초)만 포함하십시오.
        ``expire``\ 가 0으로 설정되면 쿠키는 브라우저가 열려있는 동안만 지속됩니다.

        사이트 요청 방식에 관계없는 사이트 전체 쿠키의 경우 ``.your-domain.com``\ 와 같이 마침표로 시작하는 URL을 ``domain``\ 에 추가하십시오.

        메소드가 루트 경로를 설정하므로 일반적으로 ``path``\ 는 설정하지 않아도 됩니다.

        ``prefix``\ 는 서버의 다른 동일한 이름의 쿠키와 이름 충돌을 피해야하는 경우에만 필요합니다.

        보안 쿠키를 만들고 싶다면 ``secure``\ 의 값을 부울(boolean) true로 설정합십시오.

        SameSite 값은 도메인과 하위 도메인 간에 쿠키가 공유되는 방식을 제어합니다.
        허용되는 값은 ``None``, ``Lax``, ``Strict`` 또는 빈 문자열 ``''``\ 입니다.
        빈 문자열(``''``)로 설정하면 클라이언트로 보낸 쿠키에 SameSite 속성이 설정되지 않습니다.
        ``null``\ 로 설정하면 ``config/App.php``\ 의 값이 사용됩니다.

        **개별 매개 변수**

        개별 매개 변수를 사용하여 쿠키를 설정할 수 있습니다.
        
        .. literalinclude:: response/024.php

    .. php:method:: deleteCookie($name = ''[, $domain = ''[, $path = '/'[, $prefix = '']]])

        :param mixed $name: 쿠키명 또는 매개 변수 배열
        :param string $domain: 쿠키 domain
        :param string $path: 쿠키 path
        :param string $prefix: 쿠키명 prefix
        :rtype: void

        ``expire``\ 를 ``0``\ 으로 설정하여 기존 쿠키를 삭제합니다.

        **Notes**

        ``name``\ 만 필요합니다.

        ``prefix``\ 는 서버의 다른 동일한 이름의 쿠키와 이름 충돌을 피해야하는 경우에만 필요합니다.

            - 해당 하위 집합에 대해서만 쿠키를 삭제해야 하는 경우 ``prefix``\ 를 제공하십시오.
            - 해당 도메인에 대해서만 쿠키를 삭제해야 하는 경우 ``domain``\ 을 제공하십시오.
            - 해당 경로에 대해서만 쿠키를 삭제해야 하는 경우 ``path``\ 를 제공하십시오.

        선택적 매개 변수중 하나라도 비어 있으면 동일한 이름의 모든 쿠키가 삭제됩니다.

        Example

        .. literalinclude:: response/025.php

    .. php:method:: hasCookie($name = ''[, $value = null[, $prefix = '']])

        :param mixed $name: 쿠키명 또는 매개 변수 배열
        :param string $value: 쿠키값
        :param string $prefix: 쿠키명 접두사
        :rtype: bool

        응답(Response)에 지정된 쿠키가 있는지 확인합니다.

        **Notes**

        ``name``\ 만 필요합니다. ``prefix``\ 가 지정되면 쿠키명 앞에 붙습니다.
        
         ``value``\ 가 제공되지 않으면, 메소드는 이름으로 지정된 쿠키가 있는지 확인합니다.
         ``value``\ 가 제공되면, 메소드는 쿠키가 존재하는지, 제공된 값을 가지고 있는지 확인합니다.

        Example

        .. literalinclude:: response/026.php

    .. php:method:: getCookie($name = ''[, $prefix = ''])
        :noindex:

        :param mixed $name: 쿠키명
        :param string $prefix: 쿠키명 접두사
        :rtype: ``Cookie|Cookie[]|null``

        ``name``\ 이 지정된 쿠키(있는 경우) 또는 null을 반환합니다.

        ``name``\ 이 없으면 ``Cookie`` 객체의 배열을 반환합니다. 

        Example

        .. literalinclude:: response/027.php

    .. php:method:: getCookies()

        :rtype: ``Cookie[]``

        응답(Response) 인스턴스 내에 현재 설정된 모든 쿠키를 반환합니다.
        이 쿠키는 현재 요청 중에만 설정하도록 특별히 지정한 쿠키입니다.
