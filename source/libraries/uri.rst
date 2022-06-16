*****************
URI 작업
*****************

CodeIgniter는 어플리케이션에서 URI로 작업하기 위한 객체 지향 솔루션을 제공합니다.
이를 사용하면 URI가 아무리 복잡하더라도 기존 URI에 상대 URI를 추가하고, 안전하고 올바르게 분석 할 수 있을 뿐만 아니라 구조가 항상 올바른지 간단하게 확인할 수 있습니다.

.. contents::
    :local:
    :depth: 2

======================
URI 인스턴스 만들기
======================

URI 인스턴스는 아래와 같이 간단합니다.

.. literalinclude:: uri/001.php

``service()`` 함수를 사용하여 인스턴스를 받을수 있습니다

.. literalinclude:: uri/002.php


새 인스턴스를 만들 때 생성자에서 전체 또는 부분 URL을 전달하면 해당 섹션으로 구문 분석됩니다.

.. literalinclude:: uri/003.php

현재 URI
---------------

여러 경우에, 당신이 정말로 원하는 것은 요청에 대한 현재 URL을 나타내는 객체입니다.
**url_helper**\ 에서 사용 가능한 함수 중 하나를 사용할 수 있습니다.

.. literalinclude:: uri/004.php

첫 번째 매개 변수로 ``true``\ 를 전달해야 합니다. 
그렇지 않으면 현재 URL의 문자열 표현이 반환됩니다.
This URI is based on the path (relative to your ``baseURL``) as determined by the current request object and your settings in ``Config\App`` (baseURL, indexPage, and forceGlobalSecureRequests).
Assuming that you're in a controller that extends ``CodeIgniter\Controller`` you can get this relative path

이 URI는 request 객체와 ``Config\App``(baseURL, indexPage, forceGlobalSecureRequests)의 설정에 다라 결정된 경로(``baseURL``\ 에 상대적)를 기반으로 합니다.
사용자가 ``CodeIgniter\Controller``\ 를 확장하는 컨트롤러에 있다고 가정하면 이 상대 경로를 얻을 수 있습니다.

.. literalinclude:: uri/005.php

===============
URI 문자열
===============

많은 경우, 실제로 원하는 것은 URI의 문자열 표현을 얻는 것입니다. 
이것은 단순히 URI를 문자열로 캐스팅하여 수행하기 쉽습니다.

.. literalinclude:: uri/006.php

URI 조각을 알고 있고 모든 형식이 올바른지 확인하려면 URI 클래스의 정적 ``createURIString()`` 메소드를 사용하여 문자열을 생성할 수 있습니다

.. literalinclude:: uri/007.php

.. important:: ``URI``\ 가 문자열에 캐스팅되면 프로젝트 URL을  ``Config\App``\ 에 정의된 설정으로 조정하려고 시도합니다.
	변경되지 않은 정확한 문자열 표현이 필요한 경우 ``URI::createURIString()``\ 을 사용하십시오.

=============
URI 부분
=============

URI 인스턴스가 있으면 URI의 다양한 부분을 설정하거나 검색할 수 있습니다.
이 섹션에서는 해당 부분이 무엇인지, 어떻게 작동하는지 자세히 설명합니다.

스키마(Scheme)
-------------------

스키마(scheme)는 대부분 'http' 또는 'https'\ 지만 'file', 'mailto'\ 등을 포함한 모든 체계가 지원됩니다.

.. literalinclude:: uri/008.php

권한(Authority)
-------------------

많은 URI에는 총칭하여 'authority'으로 알려진 여러 요소가 포함되어 있습니다.
여기에는 모든 사용자 정보, 호스트 및 포트 번호가 포함됩니다. 
``getAuthority()`` 메소드를 사용하여 이러한 모든 부분을 하나의 단일 문자열로 검색하거나 개별 부분을 조작할 수 있습니다.

.. literalinclude:: uri/009.php

기본적으로 암호 부분은 다른 사람에게 노출하지 않기 위해 표시되지 않습니다.
비밀번호를 표시하려면 ``showPassword()`` 메소드를 사용합니다.
이 URI 인스턴스는 비밀번호를 다시 끌 때까지 계속 해당 비밀번호를 표시하므로, 작업이 완료되면 비밀번호를 끄십시오.

.. literalinclude:: uri/010.php

포트를 표시하지 않으려면 ``true`` 를 매개 변수로 전달하십시오.

.. literalinclude:: uri/011.php

.. note:: 현재 포트가 구성표의 기본 포트인 경우 표시되지 않습니다.

사용자 정보
----------------

사용자 정보 섹션은 FTP URI에서 사용 하는 사용자 이름과 비밀번호입니다. 
권한의 일부로 이를 얻을 수는 있지만 직접 검색할 수도 있습니다

.. literalinclude:: uri/012.php

기본적으로 비밀번호는 표시되지 않지만 ``showPassword()`` 메소드로 비밀번호를 대체할 수 있습니다.

.. literalinclude:: uri/013.php

호스트(Host)
---------------

URI의 호스트 부분은 일반적으로 URL의 도메인 이름입니다.
이것은 ``getHost()``\ 와 ``setHost()`` 메소드로 쉽게 설정하고 검색할 수 있습니다

.. literalinclude:: uri/014.php

포트(Port)
---------------

포트는 0에서 65535 사이의 정수입니다. 각 스키마(sheme)에는 기본값이 있습니다.

.. literalinclude:: uri/015.php

``setPort()`` 메소드를 사용하면 포트가 유효한 범위 내에 있고 할당되었는지 확인합니다.

패스(Path)
---------------

경로는 사이트의 모든 세그먼트입니다. 
예상대로 ``getPath()`` \와 ``setPath()`` 메소드를 사용하여 조작할 수 있습니다.

.. literalinclude:: uri/016.php

.. note:: 이 메소드로 또는 클래스가 허용하는 다른 방법으로 경로를 설정하면 위험한 문자를 인코딩하고 안전을 위해 점(dot) 세그먼트를 제거하는 것이 좋습니다.

쿼리(Query)
---------------

간단한 문자열 표현을 사용하여 클래스를 통해 쿼리 변수를 조작할 수 있습니다.
쿼리 값은 현재 문자열로만 설정할 수 있습니다.

.. literalinclude:: uri/017.php

.. note:: 쿼리 값에는 조각이 포함될 수 없습니다. 유효하지 않은 경우 ``InvalidArgumentException``\ 이 발생합니다.

배열을 사용하여 쿼리 값을 설정할 수 있습니다

.. literalinclude:: uri/018.php

``setQuery()``\ 와 ``setQueryArray()`` 메소드는 기존 쿼리 변수를 덮어 씁니다.
``addQuery()`` 메소드를 사용하여 기존 쿼리 변수를 손상시키지 않고 쿼리 변수 컬렉션에 값을 추가할 수 있습니다.
첫 번째 매개 변수는 변수의 이름이고 두 번째 매개 변수는 값입니다.

.. literalinclude:: uri/019.php

**쿼리 값 필터링**

*only* 또는 *except* 키를 사용하여 ``getQuery()`` 메소드에 옵션 배열을 전달하여 리턴된 쿼리 값을 필터링할 수 있습니다.

.. literalinclude:: uri/020.php

이 한 번의 호출 동안 반환된 값만 변경됩니다.
URI의 쿼리 값을보다 영구적으로 수정해야 하는 경우 ``stripQuery()``\ 와 ``keepQuery()`` 메소드를 사용하여 실제 객체의 쿼리 변수 컬렉션을 변경할 수 있습니다.

.. literalinclude:: uri/021.php

.. note:: 기본적으로 ``setQuery()``\ 와 ``setQueryArray()`` 메소드는 ``parse_str()`` 함수를 사용하여 데이터를 준비합니다. 
	키 이름에 점을 포함할 수 있는 보다 자유로운 규칙을 사용하려면 특수 메소드 ``useRawQueryString()``\ 를 미리 호출해야 합니다.

조각(Fragment)
-------------------

조각(fragment)은 URL 끝 부분에 파운드 기호(#)가 옵니다.
HTML URL에서 이들은 페이지 앵커에 대한 링크입니다. 
미디어 URI는 다양한 방법으로 그것들을 사용할 수 있습니다.

.. literalinclude:: uri/022.php

==================
URI 세그먼트
==================

슬래시 사이의 경로의 각 섹션은 단일 세그먼트입니다. 
URI 클래스는 세그먼트 값이 무엇인지 판별하는 간단한 방법을 제공합니다.
세그먼트는 경로에서 가장 왼쪽부터 인덱스는 1로 시작합니다.

.. literalinclude:: uri/023.php

``getSegment()`` 메소드의 두 번째 매개 변수를 사용하여 특정 세그먼트에 대해 다른 기본값을 설정할 수 있습니다. 
기본값은 빈 문자열입니다.

.. literalinclude:: uri/024.php

총 세그먼트 수를 얻을 수 있습니다.

.. literalinclude:: uri/025.php

마지막으로 모든 세그먼트의 배열을 검색할 수 있습니다.

.. literalinclude:: uri/026.php

===========================
예외 던지기 비활성화
===========================

기본적으로 이 클래스의 일부 메서드는 예외를 발생시킬 수 있습니다. 예외 발생을 사용하지 않으려면 이를 방지하는 특수 플래그를 설정합니다.

.. literalinclude:: uri/027.php
