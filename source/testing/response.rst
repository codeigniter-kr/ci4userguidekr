######################
응답(Responses) 테스트
######################

``Test Response`` 클래스는 테스트 케이스의 응답을 구문 분석하고 테스트하는 데 유용한 여러 기능을 제공합니다. 
일반적으로 :doc:`Controller Tests <controllers>` 또는 :doc:`HTTP Feature Tests <feature>`\ 의 결과로 ``TestResponse``\ 가 제공되지만 언제든지 ``ResponseInterface``\ 를 사용하여 직접 생성할 수 있습니다.

.. literalinclude:: response/001.php

응답 테스트
*************

테스트 결과 ``TestResponse``\ 를 받았거나, 직접 테스트 응답을 작성하여도 테스트에 사용할 수 있는 여러 가지 새로운 어설션(assertion)\ 을 제고합니다.

Request/Response 액세스
=========================

request()
---------

테스트 중에 Request 개체가  경우 설정된 직접 액세스할 수 있습니다.

.. literalinclude:: response/002.php

response()
----------

이렇게 하면 응답 개체에 직접 액세스할 수 있습니다.

.. literalinclude:: response/003.php

응답 상태 확인
================

isOK()
------

응답이 "ok"\ 로 인식되는지 여부에 따라 부울 true/false\ 를 반환합니다. 
이는 주로 응답 상태 코드 200 또는 300에 의해 결정됩니다.
리디렉션이 아니라면 빈 본문은 유효한 것으로 간주되지 않습니다.

.. literalinclude:: response/004.php

assertOK()
----------

이 어설션은 ``isOK()`` 메소드를 사용하여 응답을 테스트합니다. 
``assertNotOK()``\ 는 이 어설션의 반대입니다.

.. literalinclude:: response/005.php

isRedirect()
------------

응답이 리디렉션 응답인지 여부에 따라 부울 true/false\ 를 반환합니다.

.. literalinclude:: response/006.php

assertRedirect()
----------------

응답이 RedirectResponse의 인스턴스임을 확인합니다.
``assertNotRedirect()``\ 는 이 어설션의 반대입니다.

.. literalinclude:: response/007.php

assertRedirectTo()
------------------

응답이 RedirectResponse의 인스턴스이며 대상이 지정된 uri와 일치하는지 확인합니다.

.. literalinclude:: response/008.php

getRedirectUrl()
----------------

RedirectResponse에 대해 설정된 URL을 반환합니다.
실패한 경우 null을 반환합니다.

.. literalinclude:: response/009.php

assertStatus(int $code)
-----------------------

반환된 HTTP 상태 코드가 $code와 일치하는지 확인합니다.

.. literalinclude:: response/010.php


세션 어설션(Assertion)
=======================

assertSessionHas(string $key, $value = null)
--------------------------------------------

결과 세션에 값이 존재하는지 확인합니다. 
$value\ 가 전달되면 는 변수의 값이 지정된 값과 일치하는지 확인합니다.

.. literalinclude:: response/011.php

assertSessionMissing(string $key)
---------------------------------

결과 세션에 지정된 $key가 포함되어 있지 않음을 확인합니다.

.. literalinclude:: response/012.php


헤더 어설션(Assertion)
=======================

assertHeader(string $key, $value = null)
----------------------------------------

``$key``\ 라는 헤더가 응답에 있는지 확인합니다. 
``$value``\ 가 비어 있지 않은면 값이 일치한다고 주장합니다.

.. literalinclude:: response/013.php

assertHeaderMissing(string $key)
--------------------------------

헤더 이름 ``$key``\ 가 응답에 존재하지 않음을 확인합니다.

.. literalinclude:: response/014.php


쿠키 어설션(Assertion)
=======================

assertCookie(string $key, $value = null, string $prefix = '')
-------------------------------------------------------------

응답에 ``$key``\ 라는 쿠키가 있는지 확인합니다. 
``$value``\ 가 비어 있지 않은 경우에도 값이 일치한다고 주장합니다. 
필요한 경우 쿠키 접두사를 세 번째 매개 변수로 전달하여 설정할 수 있습니다.

.. literalinclude:: response/015.php

assertCookieMissing(string $key)
--------------------------------

``$key``\ 라는 쿠키가 응답에 존재하지 않음을 확인합니다.

.. literalinclude:: response/016.php

assertCookieExpired(string $key, string $prefix = '')
-----------------------------------------------------

``$key``\ 라는 쿠키가 존재하지만 만료되었음을 확인합니다. 
필요한 경우 쿠키 접두사를 두 번째 매개 변수로 전달하여 설정할 수 있습니다.

.. literalinclude:: response/017.php

DOM 헬퍼
===========

반환되는 응답에는 응답 내의 HTML 출력을 검사하는 여러 가지 헾러 메소드가 포함되어 있습니다. 
이러한 헬퍼들은 테스트의 어설션 내에서 사용하는 데 유용합니다.

``see()`` 메소드는 페이지의 텍스트를 지정된 유형(type), 클래스(class), ID별로  확인하여 자체적이거나, 태그 내에 존재하는지 구체적으로 확인합니다.

.. literalinclude:: response/018.php

``dontSee()`` 메소드는 반대로 동작합니다.

.. literalinclude:: response/019.php

seeElement()
------------

``seeElements()``\ 와 ``dontSeeElements()``\ 는 이전 메소드와 매우 유사하지만 요소의 값을 살펴보지는 않습니다. 
대신, 그들은 단순히 페이지에 요소가 존재하는지만 확인합니다.

.. literalinclude:: response/020.php

seeLink()
---------

``seeLink()``\ 를 사용하여 지정된 텍스트로 페이지에 링크 주소가 표시되는지 확인할 수 있습니다.

.. literalinclude:: response/021.php

seeInField()
------------

``seeInField()`` 메소드는 이름 및 값을 포함한 입력 태그가 있는지 확인합니다.

.. literalinclude:: response/022.php

seeCheckboxIsChecked()
----------------------

마지막으로 체크박스가 존재하는지 ``seeCheckboxIsChecked()`` 메소드로 체크되어 있는지 확인할 수 있습니다

.. literalinclude:: response/023.php

DOM 어설션(Assertion)
======================

다음 어설션을 사용하여 특정 요소/텍스트 등이 응답(response) 본문에 있는지 확인할 수 있습니다.

assertSee(string $search = null, string $element = null)
--------------------------------------------------------

유형, 클래스 또는 ID별로 지정된 태그가 text/HTML 페이지에 있다고 주장합니다.

.. literalinclude:: response/024.php

assertDontSee(string $search = null, string $element = null)
------------------------------------------------------------

``assertSee()`` 메소드와 반대로 작동합니다.

.. literalinclude:: response/025.php

assertSeeElement(string $search)
--------------------------------

``assurtSee()``\ 와 비슷하지만 기존 요소만 확인합니다. 특정 텍스트를 확인하지 않습니다.

.. literalinclude:: response/026.php

assertDontSeeElement(string $search)
------------------------------------

``assurtSee()``\ 와 유사하지만, 누락된 기존 요소만 확인합니다. 특정 텍스트를 확인하지 않습니다.

.. literalinclude:: response/027.php

assertSeeLink(string $text, string $details = null)
---------------------------------------------------

 태그 본문중 **$text**\ 와 일치하는 앵커 태그가 있는지 확인합니다.

.. literalinclude:: response/028.php

assertSeeInField(string $field, string $value = null)
-----------------------------------------------------

이름 및 값을 가진 입력 태그가 있는지 확인합니다.

.. literalinclude:: response/029.php

JSON 작업
===========

응답(Response)중 API 메서드를 사용할 때 자주 JSON이 포함됩니다. 
다음 메소들을 사용하면 응답을 테스트할 수 있습니다.

getJSON()
---------

이 메소드는 응답 본문을 JSON 문자열로 반환합니다.

.. literalinclude:: response/030.php

이 메소드를 사용하여 ``$response``\ 이 실제로 JSON 콘텐츠를 보유하고 있는지 확인할 수 있습니다.

.. literalinclude:: response/031.php

.. note:: JSON 문자열은 결과에 예쁘게 출력(pretty-print)됩니다.

assertJSONFragment(array $fragment)
-----------------------------------

$fragment\ 가 JSON 응답 내에서 발견되없음 주장합니다. 전체 JSON 값과 일치할 필요는 없습니다.

.. literalinclude:: response/032.php

assertJSONExact($test)
----------------------

``assertJSONFragment()``\ 와 유사하지만 전체 JSON 응답을 확인하여 정확하게 일치를 확인합니다.

XML 작업
===========

getXML()
--------

응용프로그램이 XML을 반환하는 경우 이 메소드를 통해 XML을 검색할 수 있습니다.
