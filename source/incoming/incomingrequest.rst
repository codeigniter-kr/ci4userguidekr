IncomingRequest Class
*********************

IncomingRequest 클래스는 브라우저와 같은 클라이언트의 HTTP 요청(request)에 대한 객체 지향 표현을 제공합니다.
아래 나열된 메소드 외에도 :doc:`요청(Request) </incoming/request>` 및 :doc:`메시지(Message) </incoming/message>` 클래스의 모든 메소드에 액세스 할 수 있습니다.

.. contents::
    :local:
    :depth: 2

Accessing the Request
-----------------------

클래스가 ``CodeIgniter\Controller``\ 를 상속 받았다면 클래스의 request 속성을 통해 요청(request) 클래스 인스턴스에 엑세스할 수 있습니다.

.. literalinclude:: incomingrequest/001.php

컨트롤러가 아닌 곳에서 요청(Request) 객체에 액세스해야 하는 경우 :doc:`서비스(Services) class </concepts/services>`\ 를 통해 사본을 얻을 수 있습니다.

.. literalinclude:: incomingrequest/002.php

컨트롤러 이외의 클래스에서 클래스 속성으로 엑세스하고 싶다면 요청(Request)을 종속성으로 전달하는 것이 좋습니다.

.. literalinclude:: incomingrequest/003.php

요청 유형 결정
----------------

요청은 AJAX 요청 또는 커맨드 라인에서의 요청등 여러 유형을 포함할 수 있으며, ``isAJAX()``\ 와 ``isCLI()`` 메소드로 확인할 수 있습니다

.. literalinclude:: incomingrequest/004.php

.. note:: ``isAJAX()`` 메소드는 ``X-Requested-With`` 헤더에 의존하며, JavaScript를 통한 XHR 요청은 경우에 따라 기본적으로 헤더가 전송되지 않습니다. (예: fetch). 
    이를 해결하는 방법에 대해서는 :doc:`AJAX 요청(Requests) </general/ajax>`\ 을 참조하십시오.

``getMethod()`` 메소드를 이용하여 요청중인 HTTP 메소드를 확인할 수 있습니다.

.. literalinclude:: incomingrequest/005.php

이 메소드는 기본적으로 소문자(예 : 'get', 'post', 등)로 값을 반환합니다.
``strtoupper()``\ 함수를 이용하여 대문자로 변환할 수 있습니다.

::

    // Returns 'GET'
    $method = strtoupper($request->getMethod());

``isSecure()`` 메소드를 이용하여 HTTPS 연결을 통해 요청이 이루어 졌는지 확인할 수 있습니다.

.. literalinclude:: incomingrequest/006.php

입력 검색
-----------

요청(Request) 객체를 통해 ``$_SERVER``, ``$_GET``, ``$_POST``, ``$_ENV``\ 에서 입력을 검색할 수 있습니다.
데이터는 자동으로 필터링되지 않으며 요청에 전달 된대로 입력 데이터를 리턴합니다.
전역 변수($_POST['something'])를 직접 액세스하는 대신 이러한 메소드를 사용하는 것의 주된 장점은 항목이 존재하지 않으면 null을 리턴하고 데이터를 필터링할 수 있다는 것입니다.
다음과 같이 항목이 먼저 존재하는지 테스트하지 않고도 편리하게 데이터를 사용할 수 있습니다.

.. literalinclude:: incomingrequest/007.php

CodeIgniter의 내장 메소드를 사용하면 간단히 수행 할 수 있습니다.

.. literalinclude:: incomingrequest/008.php

``getVar()`` 메소드는 ``$_REQUEST``\ 에서 데이터를 가져 오므로 ``$_GET``, ``$POST``, ``$_COOKIE``\ 의 모든 데이터를 반환합니다.
이 방법이 편리하지만, 더욱 구체적인 방법을 사용해야 할 수도 있습니다:

* ``$request->getGet()``
* ``$request->getPost()``
* ``$request->getServer()``
* ``$request->getCookie()``

또한 ``$_GET`` 또는 ``$_POST`` 모두에서 정보를 검색하지만, 가져오는 순서를 제어하는 기능도 제공합니다.

* ``$request->getPostGet()`` - checks $_POST first, then $_GET
* ``$request->getGetPost()`` - checks $_GET first, then $_POST

**JSON 데이터 가져오기**

``getJSON()``\ 을 사용하여 ``php://input``\ 의 내용을 JSON으로 가져올 수 있습니다.

.. note::  들어오는 데이터가 유효한 JSON인지 여부를 확인할 수있는 방법이 없으므로, JSON인 경우에만 이 메소드를 사용해야 합니다.

.. literalinclude:: incomingrequest/009.php

기본적으로 JSON 데이터의 모든 객체는 PHP 객체로 반환합니다.
연관 배열로 변환하려면 첫 번째 매개 변수로 ``true``\ 를 전달하십시오.

::

    $json = $request->getJSON(true);

두 번째와 세 번째 매개 변수는 PHP 함수 `json_decode <https://www.php.net/manual/en/function.json-decode.php>`_\ 의 ``depth``, ``options`` 매개 변수와 일치합니다.

수신 요청에 ``CONTENT_TYPE`` 헤더가 "application/json"\ 으로 설정된 경우 ``getVar()``\ 를 사용하여 JSON 스트림을 가져올 수 있습니다.
이런식으로 ``getVar()``\ 를 사용하면 항상 객체(oject)가 반환됩니다.

**JSON에서 특정 데이터 가져 오기**

원하는 데이터에 대해 변수 이름을 ``getVar()``\ 에 전달하면 JSON 스트림에서 특정 데이터를 얻을 수 있으며, ``dot`` 표기법을 사용하여 JSON을 탐색하여 루트 레벨이 아닌 데이터를 가져올 수 있습니다.

.. literalinclude:: incomingrequest/010.php

결과가 객체 대신 연관 배열이 되도록 하려면 ``getJsonVar()``\ 를 대신 사용하고 두 번째 매개 변수에 true를 전달합니다.
이 기능은 수신 요청에 올바른 ``CONTENT_TYPE`` 헤더가 있는지 확인할 수 없는 경우에도 사용할 수 있습니다.

.. literalinclude:: incomingrequest/011.php

.. note:: ``dot`` 표기법에 대한 자세한 내용은 ``Array`` 헬퍼의 ``dot_array_search()`` 설명서를 참조하십시오.

**원시(raw) 데이터 검색 (PUT, PATCH, DELETE)**

마지막으로 ``getRawInput()``\ 을 사용하여 ``php://input``\ 의 내용을 원시(raw) 스트림으로 가져올 수 있습니다

.. literalinclude:: incomingrequest/012.php

다음처럼 데이터를 검색하여 배열로 변환합니다.

.. literalinclude:: incomingrequest/013.php

**입력 데이터 필터링**

어플리케이션의 보안을 유지하려면 액세스하는 모든 입력을 필터링해야 합니다.
위에 설명된 메소드들의 두 번째 매개 변수로 사용할 필터 유형을 전달할 수 있습니다.
``filter_var()``\ 네이티브(native) 함수가 필터링에 사용됩니다.
`유효한 필터 유형 <https://www.php.net/manual/en/filter.filters.php>`_ 목록을 보려면 PHP 매뉴얼로 이동하십시오.

POST 변수를 필터링하면 다음과 같습니다

.. literalinclude:: incomingrequest/014.php

.. important:: 두 번째 매개 변수로 전달된 필터 유형 지원은 위에서 언급한 모든 메소드중 ``getJSON()``\ 을 제외 합니다.

헤더 검색
-----------

``getHeaders()`` 메소드로 요청과 함께 전송된 모든 헤더에 액세스 할 수 있습니다.
이 메소드는 키를 헤더 이름으로 사용하여 모든 헤더의 배열을 ``CodeIgniter\HTTP\Header``\ 로 반환합니다.

.. literalinclude:: incomingrequest/015.php

단일 헤더만 필요한 경우 ``header()`` 메소드를 사용합니다.
지정된 헤더 객체가 존재하는 경우 대소문자를 구분하지 않는 방식으로 가져오고, 그렇지 않으면 ``null``\ 을 반환합니다.

.. literalinclude:: incomingrequest/016.php

``hasHeader()``\ 를 사용하여 헤더가 있는지 확인할 수 있습니다.

.. literalinclude:: incomingrequest/017.php

헤더의 모든 값을 가진 문자열이 필요하다면 ``getHeaderLine()`` 메소드를 사용합니다.

.. literalinclude:: incomingrequest/018.php

이름과 값을 가진 전체 헤더 문자열이 필요하면 헤더를 문자열로 캐스트(cast)합니다.

.. literalinclude:: incomingrequest/019.php

요청 URL
------------

``$request->getUri()`` 메소드를 통해 요청에 대한 현재 URI를 나타내는 :doc:`URI </libraries/uri>` 객체를 검색할 수 있습니다.
이 객체를 문자열로 캐스트하여 현재 요청에 대한 전체 URL을 얻을 수 있습니다.

.. literalinclude:: incomingrequest/020.php

이 객체는 요청의 일부를 얻을 수 있는 모든 기능을 제공합니다.

.. literalinclude:: incomingrequest/021.php

``getPath()``\ 와 ``setPath()`` 메소드를 사용하여 현재 URI 문자열(baseURL에 상대적인 경로)로 작업할 수 있습니다.
``IncomingRequest``\ 의 공유 인스턴스에 있는 이 상대 경로는 :doc:`URL Helper </helpers/url_helper>` 함수가 사용되므로 테스트를 위해 들어오는 요청을 "스푸핑"\ 하는 데 도움이 됩니다.

.. literalinclude:: incomingrequest/022.php

업로드(Upload) 파일
---------------------

업로드된 모든 파일에 대한 정보는 ``$request->getFiles()``\ 를 통해 얻을 수 있으며, ``CodeIgniter\HTTP\Files\UploadedFile`` 인스턴스의 배열을 반환합니다.
이를 통하여 파일 업로드 작업이 쉬워지고 보안 위험을 최소화할 수 있습니다.

.. literalinclude:: incomingrequest/023.php

자세한 내용은 :ref:`Working with Uploaded Files <uploaded-files-accessing-files>`\ 을 보십시오.

HTML 파일 입력에 지정된 파일 이름을 기반으로 업로드한 파일을 얻을 수 있습니다.

.. literalinclude:: incomingrequest/024.php

HTML 파일 입력에 제공된 파일 이름을 기반으로 동일한 이름으로 업로드된 다중 파일 배열 얻을 수 있습니다.

.. literalinclude:: incomingrequest/025.php

.. note:: 여기의 파일은 ``$_FILES``\ 에 해당합니다. 사용자가 양식(form)에 파일을 업로드하지 않고 제출(submit) 버튼을 클릭하여도 파일($_FILES)은 계속 존재합니다. userfile의 ``isValid()`` 메소드로 파일이 실제로 업로드 되었는지 확인할 수 있습니다. 자세한 내용은 :ref:`verify-a-file`\ 을 참조하세요.

컨텐츠 협상
--------------

``negotiate()`` 메소드를 통해 요청된 컨텐츠 유형을 쉽게 협상할 수 있습니다.

.. literalinclude:: incomingrequest/026.php

자세한 내용은 :doc:`콘텐츠 협상 </incoming/content_negotiation>` 페이지를 참조하십시오.

Class Reference
================

.. note:: 여기에 나열된 메소드 외에도 이 클래스는 :doc:`요청(Request) Class </incoming/request>`\ 와 :doc:`메시지(Message) Class </incoming/message>` 클래스의 메소드를 상속합니다.

사용 가능한 부모(Parent) 클래스가 제공하는 메소드는 다음과 같습니다.:

* :meth:`CodeIgniter\\HTTP\\Request::getIPAddress`
* :meth:`CodeIgniter\\HTTP\\Request::isValidIP`
* :meth:`CodeIgniter\\HTTP\\Request::getMethod`
* :meth:`CodeIgniter\\HTTP\\Request::setMethod`
* :meth:`CodeIgniter\\HTTP\\Request::getServer`
* :meth:`CodeIgniter\\HTTP\\Request::getEnv`
* :meth:`CodeIgniter\\HTTP\\Request::setGlobal`
* :meth:`CodeIgniter\\HTTP\\Request::fetchGlobal`
* :meth:`CodeIgniter\\HTTP\\Message::getBody`
* :meth:`CodeIgniter\\HTTP\\Message::setBody`
* :meth:`CodeIgniter\\HTTP\\Message::appendBody`
* :meth:`CodeIgniter\\HTTP\\Message::populateHeaders`
* :meth:`CodeIgniter\\HTTP\\Message::headers`
* :meth:`CodeIgniter\\HTTP\\Message::header`
* :meth:`CodeIgniter\\HTTP\\Message::hasHeader`
* :meth:`CodeIgniter\\HTTP\\Message::getHeaderLine`
* :meth:`CodeIgniter\\HTTP\\Message::setHeader`
* :meth:`CodeIgniter\\HTTP\\Message::removeHeader`
* :meth:`CodeIgniter\\HTTP\\Message::appendHeader`
* :meth:`CodeIgniter\\HTTP\\Message::prependHeader`
* :meth:`CodeIgniter\\HTTP\\Message::getProtocolVersion`
* :meth:`CodeIgniter\\HTTP\\Message::setProtocolVersion`

.. php:namespace:: CodeIgniter\HTTP

.. php:class:: IncomingRequest

    .. php:method:: isCLI()

        :returns: 커맨드 라인 요청 ``true``, 그렇지 않으면 ``false``
        :rtype: bool

    .. php:method:: isAJAX()

        :returns: AJAX 요청 ``true``, 그렇지 않으면 ``false``
        :rtype: bool

    .. php:method:: isSecure()

        :returns: HTTPS 요청 ``true``, 그렇지 않으면 ``false``
        :rtype: bool

    .. php:method:: getVar([$index = null[, $filter = null[, $flags = null]]])

        :param  string  $index: 찾을 변수/키의 이름
        :param  int     $filter: 적용할 필터 유형, 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`__\ 에서 찾을 수 있습니다.
        :param  int     $flags: 적용할 플래그, 플래그 목록은 `여기 <https://www.php.net/manual/en/filter.filters.flags.php>`__\ 에서 찾을 수 있습니다.
        :returns:   제공된 매개 변수가 없는 경우 ``$_REQUEST``, 있으면 검색된 REQUEST 값 또는 ``null``
        :rtype: mixed|null

        첫 번째 매개 변수에는 찾고자하는 REQUEST 항목의 이름입니다
        
        .. literalinclude:: incomingrequest/027.php

        검색하려는 항목이 존재하지 않으면 이 메소드는 널(null)을 리턴합니다.

        두 번째 선택적 매개 변수를 사용하면 PHP 필터를 통해 데이터를 필터링할 수 있습니다.
        원하는 필터 유형을 두 번째 매개 변수로 전달하십시오.
        
        .. literalinclude:: incomingrequest/028.php

        모든 REQUEST 항목의 배열을 반환하려면 매개 변수없이 호출하십시오.

        모든 REQUEST 항목을 반환하고 필터를 통해 전달하려면 첫 번째 매개 변수를 ``null``\ 로 설정하고 두 번째 매개 변수를 사용하려는 필터로 설정하십시오.
        
        .. literalinclude:: incomingrequest/029.php

        여러 REQUEST 매개 변수의 배열을 반환하려면 필요한 모든 키를 배열로 전달하십시오.
        
        .. literalinclude:: incomingrequest/030.php

        매개 변수의 배열을 반환할 때 필터링을 사용하고 싶다면, 두 번째 매개 변수에 적용할 필터 유형을 설정하십시오.
        
        .. literalinclude:: incomingrequest/031.php

    .. php:method:: getGet([$index = null[, $filter = null[, $flags = null]]])

        :param  string  $index: 찾을 변수/키의 이름.
        :param  int     $filter: 적용할 필터 유형, 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`__\ 에서 찾을 수 있습니다.
        :param  int     $flags: 적용할 플래그, 플래그 목록은 `여기 <https://www.php.net/manual/en/filter.filters.flags.php>`__\ 에서 찾을 수 있습니다.
        :returns:   제공된 매개 변수가 없는 경우 ``$_GET``, 있으면 검색된 GET 값 또는 ``null``
        :rtype: mixed|null

        ``getVar()``\ 와 동일하지만, GET 데이터만 가져옵니다.

    .. php:method:: getPost([$index = null[, $filter = null[, $flags = null]]])

        :param  string  $index: 찾을 변수/키의 이름
        :param  int     $filter: 적용할 필터 유형, 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`__\ 에서 찾을 수 있습니다.
        :param  int     $flags: 적용할 플래그, 플래그 목록은 `여기 <https://www.php.net/manual/en/filter.filters.flags.php>`__\ 에서 찾을 수 있습니다.
        :returns:   제공된 매개 변수가 없는 경우 ``$_POST``, 있으면 검색된 POST 값 또는 ``null``
        :rtype: mixed|null

        ``getVar()``\ 와 동일하지만, POST 데이터만 가져옵니다.

    .. php:method:: getPostGet([$index = null[, $filter = null[, $flags = null]]])

        :param  string  $index: 찾을 변수/키의 이름
        :param  int     $filter: 적용할 필터 유형, 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`__\ 에서 찾을 수 있습니다.
        :param  int     $flags: 적용할 플래그, 플래그 목록은 `여기 <https://www.php.net/manual/en/filter.filters.flags.php>`__\ 에서 찾을 수 있습니다.
        :returns:   제공된 매개 변수가 없는 경우 ``$_POST``, 있으면 검색된 POST 값 또는 ``null``
        :rtype: mixed|null

        이 방법은 ``getPost()``, ``getGet()``\ 와 거의 같은 방식으로 작용하며, 2개의 메소드를 결합한 것입니다.
        POST에서 먼저 검색하여 발견되지 않으면 GET에서 검색합니다.
        
        .. literalinclude:: incomingrequest/032.php

    .. php:method:: getGetPost([$index = null[, $filter = null[, $flags = null]]])

        :param  string  $index: 찾을 변수/키의 이름
        :param  int     $filter: 적용할 필터 유형, 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`__\ 에서 찾을 수 있습니다.
        :param  int     $flags: 적용할 플래그, 플래그 목록은 `여기 <https://www.php.net/manual/en/filter.filters.flags.php>`__\ 에서 찾을 수 있습니다.
        :returns:   제공된 매개 변수가 없는 경우 ``$_POST``, 있으면 검색된 POST 값 또는 ``null``
        :rtype: mixed|null

        이 방법은 ``getPost()``, ``getGet()``\ 와 거의 같은 방식으로 작용하며, 2개의 메소드를 결합한 것입니다.
        GET에서 먼저 검색하여 발견되지 않으면 POST에서 검색합니다.
        
        .. literalinclude:: incomingrequest/033.php

    .. php:method:: getCookie([$index = null[, $filter = null[, $flags = null]]])

        :noindex:
        :param  mixed   $index: COOKIE명
        :param  int     $filter: 적용할 필터 유형, 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`__\ 에서 찾을 수 있습니다.
        :param  int     $flags: 적용할 플래그, 플래그 목록은 `여기 <https://www.php.net/manual/en/filter.filters.flags.php>`__\ 에서 찾을 수 있습니다.
        :returns:    제공된 매개 변수가 없는 경우 ``$_COOKIE``, 있으면 검색된 COOKIE 값 또는 ``null``
        :rtype:    mixed

        ``getPost()`` 와 ``getGet()``\ 과 동일하지만 값을 쿠키(cookie)에서 가져옵니다.
        
        .. literalinclude:: incomingrequest/034.php

        여러 쿠키 값의 배열을 반환하려면 필요한 모든 키를 배열로 전달하십시오.
        
        .. literalinclude:: incomingrequest/035.php

        .. note::  :doc:`Cookie Helper <../helpers/cookie_helper>` 함수 :php:func:`get_cookie()`\ 와 달리 이 메소드는 ``Config\Cookie::$prefix``\ 의 값이 앞에 추가되지 않습니다.

    .. php:method:: getServer([$index = null[, $filter = null[, $flags = null]]])
		:noindex:

        :param  mixed   $index: Value name
        :param  int     $filter: 적용할 필터 유형, 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`__\ 에서 찾을 수 있습니다.
        :param  int     $flags: 적용할 플래그, 플래그 목록은 `여기 <https://www.php.net/manual/en/filter.filters.flags.php>`__\ 에서 찾을 수 있습니다.
        :returns:    검색된 $_SERVER 값 또는 ``null``
        :rtype:    mixed

        ``getPost()``, ``getGet()``, ``getCookie()`` 메소드와 동일하지만 값을 ``$_SERVER``\ 에서 가져옵니다.
        
        .. literalinclude:: incomingrequest/036.php

        다수의 ``$_SERVER`` 값을 배열로 반환하려면, 필요한 모든 키를 배열로 전달하십시오.

        .. literalinclude:: incomingrequest/037.php

    .. php:method:: getUserAgent([$filter = null])

        :param  int  $filter: 적용할 필터 유형, 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`__\ 에서 찾을 수 있습니다.
        :returns:  SERVER 데이터에서 찾은 사용자 에이전트 문자열 또는 null
        :rtype: mixed

        이 메소드는 SERVER 데이터에서 사용자 에이전트(User Agent) 문자열을 리턴합니다.
        
        .. literalinclude:: incomingrequest/038.php

    .. php:method:: getPath()

        :returns:	    ``$_SERVER['SCRIPT_NAME']``\ 에 상대적인 현재 URI 경로
        :rtype:	string

        ``IncomingRequest::$uri``\ 는 기본 URL에 대한 전체 앱 구성을 인식하지 못할 수 있으므로 "현재 URI"를 결정하는 가장 안전한 메소드입니다.

    .. php:method:: setPath($path)

        :param	string	$path: 현재 URI로 사용할 상대 경로
        :returns:	    This Incoming Request
        :rtype:	IncomingRequest

        대부분 테스트 목적으로만 사용되며, URI 탐지에 의존하는 대신 현재 요청에 대한 상대 경로 값을 설정할 수 있습니다.
        이 메소드를 사용하면 기본 ``URI`` 인스턴스도 새로운 경로로 업데이트됩니다.
