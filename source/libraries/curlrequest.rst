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

.. note:: 이 클래스는 사용하기 위해서는 PHP 버전의 `cURL 라이브러리 <https://www.php.net/manual/en/book.curl.php>`_\ 를 설치해야합니다. 
	이 라이브러리는 일반적으로 사용 가능하지만 모든 호스트가 제공하지는 않으므로 문제가 발생한다면 호스트에 문의하여 설치를 확인하십시오.

**********************
CURLRequest 설정
**********************

공유 옵션
===============

역사적인 이유로 CURLRequest는 기본적으로 요청 간의 모든 옵션을 공유합니다.
클래스의 인스턴스와 함께 2개 이상의 요청을 보내는 경우 이로 인해 불필요한 헤더(header)와 바디(body)가 포함된 오류 요청이 발생할 수 있습니다.

**app/Config/CURLRequest.php** 파일의 다음 매개별수 값을 ``false``\ 로 설정하여 공유 여부를 변경할 수 있습니다.

.. literalinclude:: curlrequest/001.php

.. note:: v4.2.0 이전에는 버그로 인해 ``$shareOptions``\ 가 false인 경우에도 요청 본문이 재설정되지 않았습니다.

*******************
라이브러리 로드
*******************

라이브러리는 수동으로 또는 :doc:`서비스 클래스 </concepts/services>`\ 를 통해 로드할 수 있습니다.

서비스 클래스를 통하여 로드하려면 ``curlrequest()`` 메소드를 호출하십시오.

.. literalinclude:: curlrequest/002.php

cURL이 요청을 처리하는 방법을 수정하기 위해 기본 옵션 배열을 첫 번째 매개 변수로 전달할 수 있습니다.
옵션은 이 문서의 뒷부분에서 설명합니다

.. literalinclude:: curlrequest/003.php

.. note:: ``$shareOptions``\ 가 `false`\ 이면 클래스 생성자에 전달된 기본 옵션이 모든 요청에 사용됩니다. 다른 옵션은 요청 전송 후 재설정됩니다.

클래스를 수동으로 만들 때는 몇 가지 종속성을 전달해야 합니다.
첫 번째 매개 변수는 ``Config\App`` 클래스의 인스턴스입니다.
두 번째 매개 변수는 URI 인스턴스입니다.
세 번째 매개 변수는 Response 객체입니다.
네 번째 매개 변수는 기본값 ``$options`` 배열입니다.

.. literalinclude:: curlrequest/004.php

************************
라이브러리 작업
************************

CURL 요청 작업은 통신을 처리하기 위해 요청(request)을 작성하고 :doc:`응답(response) 객체 </outgoing/response>`\ 를 얻는 문제입니다.
그 후 정보 처리 방법을 완전히 제어할 수 있습니다.

요청(request) 만들기
=====================

대부분의 통신은``request()`` 메소드를 통해 이루어지며, 이 메소드는 요청을 시작한 다음 Response 인스턴스를 리턴합니다.
HTTP 메소드, url 및 옵션 배열을 매개 변수로 사용합니다.

.. literalinclude:: curlrequest/005.php

.. note:: ``$shareOptions``\ 가 `false`\ 이면 메서드에 전달된 옵션이 요청에 사용됩니다. 요청을 전송하면 삭제됩니다. 옵션을 모든 요청에 사용하려면 생성자의 옵션을 전달합니다.

응답은 ``CodeIgniter\HTTP\Response``\ 의 인스턴스이므로 모든 일반 정보를 사용할 수 있습니다

.. literalinclude:: curlrequest/006.php

``request()`` 메소드가 가장 유연하지만 다음 단축 메소드를 사용할 수도 있습니다.
각각 URL을 첫 번째 매개 변수로 사용하고 옵션 배열을 두 번째 매개 변수로 사용합니다.

.. literalinclude:: curlrequest/007.php

Base URI
--------

클래스를 인스턴스화하는 동안 ``baseURI``\ 을 옵션 중 하나로 설정할 수 있습니다.
이를 통해 기본 URI를 설정한 다음 상대 URL을 사용하여 해당 클라이언트와의 모든 요청을 할 수 있습니다.
API로 작업할 때 특히 유용합니다

.. literalinclude:: curlrequest/008.php

상대 URI가 ``request()`` 메소드 또는 임의의 단축키 메소드에 제공되면, `RFC 2986, section 2 <http://tools.ietf.org/html/rfc3986#section-5.2>`_\ 에 설명된 규칙에 따라 baseURI와 결합됩니다. 
다음은 조합에 대한 몇 가지 예입니다.

	===================   ================   ======================
	baseURI               URI                Result
	===================   ================   ======================
	http://foo.com        /bar               `http://foo.com/bar`
	http://foo.com/foo    /bar               `http://foo.com/bar`
	http://foo.com/foo    bar                `http://foo.com/bar`
	http://foo.com/foo/   bar                `http://foo.com/foo/bar`
	http://foo.com        `http://baz.com`   `http://baz.com`
	http://foo.com/?bar   bar                `http://foo.com/bar`
	===================   ================   ======================

응답 사용
===============

각 ``request()`` 호출은 유용한 정보와 메소드를 포함하는 응답 객체를 반환합니다.
가장 일반적으로 사용되는 메소드를 사용하여 반응 자체를 확인할 수 있습니다.

응답의 상태 코드 및 이유를 확인할 수 있습니다.

.. literalinclude:: curlrequest/009.php

응답에서 헤더를 검색할 수 있습니다

.. literalinclude:: curlrequest/010.php

``getBody()`` 메소드를 사용하여 본문을 검색할 수 있습니다.

.. literalinclude:: curlrequest/011.php

본문은 원격 getServer에서 제공하는 원시 본문입니다.
컨텐츠 유형에 형식이 필요한 경우 스크립트가 해당 형식을 처리하는지 확인해야 합니다.

.. literalinclude:: curlrequest/012.php

**********************
요청(Request) 옵션
**********************

이 섹션에서는 생성자, ``request()`` 메소드 또는 바로 가기 메소드에 전달할 수 있는 모든 옵션에 대해 설명합니다.

allow_redirects
===============

기본적으로 cURL은 원격 서버가 보내는 모든 "Location:" 헤더를 따릅니다.
``allow_redirects`` 옵션을 사용하면 작동 방식을 수정할 수 있습니다.

값을 ``false``\ 로 설정하면 리디렉션을 따르지 않습니다.

.. literalinclude:: curlrequest/013.php

``true``\ 로 설정하면 기본 설정이 요청에 적용됩니다.

.. literalinclude:: curlrequest/014.php

``allow_redirects`` 옵션 값을 배열로 전달하여 기본값 대신 새 설정을 지정할 수 있습니다.

.. literalinclude:: curlrequest/015.php

.. note:: PHP가 safe_mode에 있거나 open_basedir이 활성화되어 있으면 다음 리디렉션이 작동하지 않습니다.

auth
====

`HTTP Basic <https://www.ietf.org/rfc/rfc2069.txt>`_\ 과 `Digest <https://www.ietf.org/rfc/rfc2069.txt>`_ 인증에 대한 인증 정보를 제공합니다.
다이제스트 인증을 지원하기 위해 스크립트에 추가 작업을 수행해야 할 수도 있습니다.(사용자 이름과 암호를 전달하기만 하면 됩니다.)
값은 첫 번째 요소가 사용자 이름이고 두 번째 요소는 암호인 배열입니다.
세 번째 요소는 사용할 인증 유형으로 ``basic`` 또는 ``digest``\ 여야 합니다.

.. literalinclude:: curlrequest/016.php

body
====

PUT 또는 POST와 같이 요청을 지원하는 요청 유형에 대한 요청 본문을 설정하는 방법에는 두 가지가 있습니다.
첫 번째 방법은 ``setBody()`` 메소드를 사용하는 것입니다

.. literalinclude:: curlrequest/017.php

두 번째 방법은 ``body`` 옵션을 전달하는 것입니다. 
이는 Guzzle API 호환성을 유지하기 위해 제공되며, 이전 예제와 동일한 방식으로 작동합니다.
값은 문자열이어야 합니다

.. literalinclude:: curlrequest/018.php

cert
====

PEM 형식의 클라이언트측 인증서의 위치를 지정하려면 ``cert`` 옵션으로 파일의 전체 경로가 포함된 문자열을 전달하십시오.
비밀번호가 필요한 경우 첫 번째 요소를 인증서의 경로, 두 번째 요소는 비밀번호인 배열을 설정하십시오.

.. literalinclude:: curlrequest/019.php

connect_timeout
===============

기본적으로 CodeIgniter는 cURL이 웹 사이트에 연결을 시도하는 데 제한을 두지 않습니다.
이 값을 수정해야 하는 경우 ``connect_timeout`` 옵션을 사용하여 시간을 초 단위로 전달하면 됩니다.
무기한 대기하게 만들려면 0을 전달합니다

.. literalinclude:: curlrequest/020.php

cookie
======

쿠키를 사용하고 싶다면 CURL이 쿠키 값을 읽고, 저장할 때 사용할 파일 이름을 지정합니다.
이는 CURL_COOKIEJAR 및 CURL_COOKIEFILE 옵션을 사용하여 수행됩니다.

.. literalinclude:: curlrequest/021.php

debug
=====

``true``\ 로 설정된 ``debug``\ 가 전달되면 스크립트 실행중 발생한 디버깅 내용이 STDOUT으로 에코되도록 합니다.
이는 CURLOPT_VERBOSE를 전달하고 출력을 에코하여 수행됩니다.
따라서 ``spark serve``\ 를 통해 내장 서버를 실행하면 콘솔에 출력이 표시됩니다.
그렇지 않으면 출력이 서버의 오류 로그에 기록됩니다.

.. literalinclude:: curlrequest/034.php

debug의 값으로 파일 이름을 전달하면 출력을 파일에 저장됩니다.

.. literalinclude:: curlrequest/022.php

delay
=====

요청을 보내기 전에 몇 밀리 초 동안 일시 중지할 수 있습니다

.. literalinclude:: curlrequest/023.php

form_params
===========

``form_params`` 옵션에 연관 배열을 전달하여 ``application/x-www-form-urlencoded`` POST 요청에 폼(form) 데이터를 보낼 수 있습니다.
``Content-Type`` 헤더를 설정하지 않은 경우 ``application/x-www-form-urlencoded``\ 가 기본으로 설정됩니다

.. literalinclude:: curlrequest/024.php

.. note:: ``form_params``\ 는 ``multipart`` 옵션과 함께 사용할 수 없습니다. 둘 중 하나를 사용해야 합니다. ``application/x-www-form-urlencoded`` 요청에는 ``form_params``\ 를 사용하고 ``multipart/form-data`` 요청에는 ``multipart``\ 를 사용하십시오.

.. _curlrequest-request-options-headers:

headers
=======

``setHeader()`` 메소드를 사용하여 요청에 필요한 헤더를 설정할 수 있지만, 옵션으로 헤더의 연관 배열을 전달할 수 있습니다.
각 키는 헤더의 이름이며, 각 값은 헤더 필드 값을 나타내는 문자열 또는 문자열 배열입니다.

.. literalinclude:: curlrequest/025.php

헤더가 생성자로 전달되면 나중에 추가 헤더 배열 또는 ``setHeader()`` 호출로 재정의되는 기본값으로 처리됩니다.

http_errors
===========

기본적으로 리턴된 HTTP 코드가 400 이상이면 CURLRequest가 실패합니다.
대신 ``http_errors``\ 를 ``false``\ 로 설정하면 오류 내용을 반환합니다

.. literalinclude:: curlrequest/026.php

json
====

``json`` 옵션은 JSON으로 인코딩된 데이터를 요청 본문으로 쉽게 업로드하는 데 사용됩니다.
``application/json`` Content-Type 헤더가 추가되어 이미 설정된 Content-Type을 덮어 씁니다.
이 옵션에 제공된 데이터는 ``json_encode()``\ 가 허용하는 모든 값입니다.

.. literalinclude:: curlrequest/027.php

.. note:: 이 옵션은 ``json_encode()`` 함수 또는 Content-Type 헤더를 사용자 정의할 수 없습니다. 이 기능이 필요한 경우 데이터를 수동으로 인코딩하여 CURLRequest의 ``setBody()`` 메소드를 통해 전달하고 ``setHeader()`` 메소드로 Content-Type 헤더를 설정해야 합니다.

multipart
=========

POST 요청을 통해 파일 및 기타 데이터를 보내야 할 경우 `CURLFile 클래스 <https://www.php.net/manual/en/class.curlfile.php>`_\ 와 함께 ``multipart`` 옵션을 사용합니다.
값은 전송할 POST 데이터의 연관 배열이어야 합니다. 
보다 안전한 사용을 위해 파일 이름 앞에 `@`\ 를 붙여 파일을 업로드하는 기존 방법이 비활성화되었습니다.
보내려는 모든 파일은 ``CURLFile``\ 의 인스턴스로 전달되어야 합니다.

.. literalinclude:: curlrequest/028.php

.. note:: ``multipart``\ 는 ``form_params`` 옵션과 함께 사용할 수 없습니다. 하나만 사용할 수 있습니다. ``application/x-www-form-urlencoded`` 요청에는 ``form_params``\ 를 사용하고 ``multipart/form-data``\ 요청에는 ``multipart``\ 를 사용하십시오.

query
=====

``query`` 옵션으로 연관 배열을 전달하여 쿼리 문자열 변수로 보낼 데이터를 전달할 수 있습니다.

.. literalinclude:: curlrequest/029.php

timeout
=======

기본적으로 cURL 함수는 시간 제한없이 실행할 수 있습니다. ``timeout``\ 옵션으로 이를 수정할 수 있습니다.
값은 함수를 실행하려는 시간(초)이어야 합니다.
무기한 대기하려면 0을 사용합니다.

.. literalinclude:: curlrequest/030.php

user_agent
==========

요청에 대한 사용자 에이전트를 지정할 수 있습니다.

.. literalinclude:: curlrequest/031.php

verify
======

이 옵션은 SSL 인증서 확인 동작을 설명합니다.
``verify`` 옵션이 ``true``\ 인 경우 SSL 인증서 확인을 활성화하고, 운영 체제에서 제공하는 기본 CA 번들을 사용합니다.
``false``\ 로 설정하면 인증서 확인이 비활성화됩니다. - 이는 안전하지 않으며 중간자 공격(man-in-the-middle attacks!)을 허용합니다.
사용자 지정 인증서로 확인할 수 있도록 CA 번들 경로가 포함된 문자열을 값으로 설정할 수 있습니다.
기본값은 ``true``\ 입니다.

.. literalinclude:: curlrequest/032.php

version
=======

HTTP 프로토콜을 사용하도록 설정하려면 버전 번호를 사용하여 문자열 또는 실수(float)을 전달합니다 (일반적으로 1.0 또는 1.1, 2.0은 현재 지원되지 않습니다).

.. literalinclude:: curlrequest/033.php
