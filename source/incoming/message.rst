===============
HTTP 메시지
===============

Message 클래스는 메시지 본문, 프로토콜 버전, 헤더 작업 유틸리티 및 컨텐츠 협상(content negotiation) 처리 방법을 포함하여 요청 및 응답에 공통적인 HTTP 메시지 부분에 대한 인터페이스를 제공합니다.

이 클래스는 :doc:`Request Class </incoming/request>`\ 와 :doc:`Response Class </outgoing/response>`\ 의 상위 클래스입니다.
컨텐츠 교섭 메소드와 같은 일부 메소드는 요청(Request)이나 응답(Response)에만 적용되고, 다른 메소드는 적용되지 않을수 있지만, 헤더 메소드를 함께 유지하기 위해 이 문서에 포함되었습니다.

콘텐츠 협상(Content Negotiation)이란?
========================================
콘텐츠 협상(Content Negotiation)은, 동일한 리소스를 둘 이상의 콘텐츠 유형으로 서비스하도록 허용하고, 클라이언트가 자신에게 가장 적합한 데이터 유형을 요청할 수 있게 하는 HTTP 규격입니다.

PNG 파일을 표시할 수 없는 브라우저는 GIF 또는 JPEG 이미지를 서버에 요청합니다. 
서버는 클라이언트가 요청한 사용 가능한 파일 형식을 보고 지원하는 이미지 형식 중에서 가장 일치하는 항목을 선택합니다.
이 경우엔 JPEG 이미지를 선택합니다.

이 같은 협상은 네 가지 유형의 데이터에서 발생할 수 있습니다:

* **Media/Document Type** - 이미지 형식이거나 HTML, XML, JSON.
* **Character Set** - 문서의 문자 집합(character ) 설정. 일반적으로 UTF-8.
* **Document Encoding** - 일반적으로 결과(result)에 사용된 압축 유형.
* **Document Language** - 여러 언어를 지원하는 사이트의 경우, 이를 통해 반환할 항목을 결정하는 데 도움을 줍니다.

***************
Class Reference
***************

.. php:namespace:: CodeIgniter\HTTP

.. php:class:: Message

    .. php:method:: getBody()

        :returns: 메시지 본문
        :rtype: string

        설정된 경우 메시지 본문을 반환합니다. 본문이 없으면 null을 반환합니다.
        
        .. literalinclude:: message/001.php

    .. php:method:: setBody([$str])

       :param  mixed  $str: 메시지의 본문.
       :returns: Message|Respons 인스턴스
       :rtype: CodeIgniter\\HTTP\\Message 인스턴스.

        현재 요청(request)의 본문을 설정합니다.

    .. php:method:: appendBody($data)

        :param  mixed  $data: 메시지 본문.
        :returns: tMessage|Respons 인스턴스.
        :rtype: CodeIgniter\\HTTP\\Message|CodeIgniter\\HTTP\\Response

        현재 요청의 본문에 데이터를 추가합니다.

    .. php:method:: populateHeaders()

        :returns: void

        SERVER 데이터에서 찾은 헤더를 스캔하고, 구문 분석하여 나중에 액세스할 수 있도록 저장합니다.
        이는 :doc:`IncomingRequest Class </incoming/incomingrequest>` 클래스에서 현재 요청의 헤더를 사용 가능하게하는 데 사용됩니다.

        헤더는 ``HTTP_HOST``\ 와 같이 ``HTTP_``\ 로 시작하는 모든 SERVER 데이터입니다.
        각 메시지는 대문자와 밑줄 형식에서 첫 글자가 대문자인 단어(ucword)와 대시 형식으로 변환됩니다.
        앞의 ``HTTP_``\ 는 문자열에서 제거됩니다. 따라서 ``HTTP_ACCEPT_LANGUAGE``\ 는 ``Accept-Language``\ 가 됩니다.

    .. php:method:: headers()

        :returns: 찾은 모든 헤더의 배열입니다.
        :rtype: array

        이전에 설정되거나 찾은 모든 헤더의 배열을 반환합니다.

    .. php:method:: header([$name[, $filter = null]])

        :param  string  $name: 값을 검색하려는 헤더의 이름입니다.
        :param  int  $filter: 적용 할 필터 유형입니다. 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`_\ 에서 찾을 수 있습니다.
        :returns: 단일 헤더 객체를 반환합니다. 동일한 이름을 가진 여러 헤더가 존재하면 헤더 객체 배열을 반환합니다.
        :rtype: \CodeIgniter\HTTP\Header|array

        단일 메시지 헤더의 현재 값을 검색할 수 있습니다.
        ``$name``\ 는 대소문자를 구분하지 않는 헤더 이름입니다.
        헤더가 내부적으로 변환되는 동안 모든 유형의 케이스를 사용하여 헤더를 액세스할 수 있습니다.
        
        .. literalinclude:: message/002.php

        헤더에 값이 여러 개일 경우 ``getValue()``\ 는 값의 배열로 반환됩니다.
        ``getValueLine()`` 메소드를 사용하여 값을 문자열로 검색할 수 있습니다
        
        .. literalinclude:: message/003.php

        두 번째 매개 변수로 필터값을 전달하여 헤더를 필터링할 수 있습니다.
        
        .. literalinclude:: message/004.php

    .. php:method:: hasHeader($name)

        :param  string  $name: 확인할 헤더의 이름.
        :returns: 있으면 true, 그렇지 않으면 false.
        :rtype: bool

    .. php:method:: getHeaderLine($name)

        :param  string $name: 검색 할 헤더의 이름
        :returns: 헤더 값을 나타내는 문자열
        :rtype: string

        헤더의 값을 문자열로 반환합니다.
        이 메소드를 사용하면 헤더에 여러 개의 값이 있을 때 헤더 값의 문자열을 쉽게 얻을 수 있습니다.
        여러 개의 값은 적절하게 연결됩니다.
        
        .. literalinclude:: message/005.php

    .. php:method:: setHeader([$name[, $value]])
                :noindex:

        :param string $name: 값을 설정할 헤더의 이름
        :param mixed  $value: 설정할 헤더의 값
        :returns: Message 인스턴스
        :rtype: CodeIgniter\\HTTP\\Message

        단일 헤더의 값을 설정합니다. ``$name``\ 은 대소문자를 구분하지 않는 헤더 이름입니다.
        컬렉션에 헤더가 없으면 생성됩니다. ``$value``\ 는 문자열 또는 문자열 배열일 수 있습니다.
        
        .. literalinclude:: message/006.php

    .. php:method:: removeHeader([$name])

        :param string $name: 제거할 헤더의 이름.
        :returns: Message 인스턴스
        :rtype: CodeIgniter\\HTTP\\Message

        메시지에서 헤더를 제거합니다. ``$name``\ 은 대소문자를 구분하지 않는 헤더 이름입니다.
        
        .. literalinclude:: message/007.php

    .. php:method:: appendHeader([$name[, $value]]))

        :param string $name:  수정할 헤더의 이름
        :param mixed  $value: 헤더에 추가할 값
        :returns: Message 인스턴스
        :rtype: CodeIgniter\\HTTP\\Message

        기존 헤더에 값을 추가합니다.
        헤더는 단일 문자열 대신 값의 배열이어야 합니다.
        문자열이면 ``LogicException``\ 이 발생합니다.

        .. literalinclude:: message/008.php

    .. php:method:: prependHeader($name, $value)

        :param string $name: 수정할 헤더의 이름
        :param string  $value: 헤더 앞에 붙일 값
        :returns: Message 인스턴스
        :rtype: CodeIgniter\\HTTP\\Message

        기존 헤더 앞에 값을 추가합니다. 헤더는 단일 문자열 대신 값의 배열이어야 합니다.
        문자열이면 LogicException이 발생합니다.

        .. literalinclude:: message/009.php

    .. php:method:: getProtocolVersion()

        :returns: HTTP 프로토콜 버전
        :rtype: string

        HTTP 프로토콜을 반환합니다. 아무것도 설정하지 않으면 ``null``\ 을 반환합니다.
        사용 가능한 값은 ``1.0``, ``1.1``.

    .. php:method:: setProtocolVersion($version)

        :param string $version: HTTP 프로토콜 버전
        :returns: Message 인스턴스
        :rtype: CodeIgniter\\HTTP\\Message

        HTTP 프로토콜 버전을 설정합니다. 사용 가능한 값은 ``1.0``, ``1.1``, ``2.0``.

        .. literalinclude:: message/010.php

