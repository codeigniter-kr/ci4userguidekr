요청(Request) Class
*******************

요청 클래스는 HTTP 요청의 객체 지향 표현입니다.
이는 브라우저에서 어플리케이션으로 들어오는 요청과 어플리케이션에서 타사 어플리케이션으로 요청을 보내는 발신 요청 모두에서 작동합니다.
이 클래스는 둘 다 필요한 공통 기능을 제공하지만 두 경우 모두 특정 기능을 추가하기 위해 Request 클래스에서 확장되는 사용자 정의 클래스가 있습니다.

자세한 사용법은 :doc:`IncomingRequest Class </incoming/incomingrequest>` 및 :doc:`CURLRequest Class </libraries/curlrequest>` 문서를 참조하십시오.

Class Reference
===============

.. php:namespace:: CodeIgniter\HTTP

.. php:class:: Request

    .. php:method:: getIPAddress()

        :returns: 사용자의 IP 주소 또는 null, IP 주소가 유효하지 않은 경우 0.0.0.0을 반환
        :rtype: string

        현재 사용자의 IP 주소를 반환합니다. IP 주소가 유효하지 않은 경우 메소드는 '0.0.0.0'을 리턴합니다.
        
        .. literalinclude:: request/001.php

        .. important:: 이 메소드는 ``App->proxyIPs``\ 에 허용하도록 설정된 IP 주소에 대해 ``HTTP_X_FORWARDED_FOR``, ``HTTP_CLIENT_IP``, ``HTTP_X_CLIENT_IP``, ``HTTP_X_CLUSTER_CLIENT_IP`` 주소를 반환합니다.

    .. php:method:: isValidIP($ip[, $which = ''])

        .. important:: 이 메소드는 더 이상 사용되지 않습니다.

        :param    string    $ip: IP address
        :param    string    $which: IP protocol ('ipv4' or 'ipv6')
        :returns:  주소가 유효하면 true, 그렇지 않으면 false
        :rtype:    bool

        IP 주소를 입력으로 사용하고 유효한지 여부에 따라 true 또는 false(부울)를 리턴합니다.

        .. note:: 위의 $request->getIPAddress() 메소드는 IP 주소를 자동으로 검증합니다.

        .. literalinclude:: request/002.php

        IP 형식을 지정하기 위해 'ipv4' 또는 'ipv6'의 선택적 두 번째 매개 변수를 사용합니다. 지정하지 않으면 두 형식을 모두 확인합니다.

    .. php:method:: getMethod([$upper = false])

        .. important:: 매개변수 ``$upper``\ 는 더 이상 사용되지 않습니다.

        :param    bool    $upper: 요청 메소드 이름을 대문자 또는 소문자로 반환할지 여부
        :returns: HTTP 요청 방법(request method)
        :rtype:   string

        설정 옵션에 따라 대문자 또는 소문자로 ``$_SERVER['REQUEST_METHOD']``\ 를 반환합니다.

        .. literalinclude:: request/003.php

    .. php:method:: setMethod($method)

        :param string $upper: 요청 방법을 설정합니다. 요청을 스푸핑할 때 사용됩니다.
        :returns: HTTP 요청 방법(request method)
        :rtype: Request

    .. php:method:: getServer([$index = null[, $filter = null[, $flags = null]]]) 
        :noindex:

        :param  mixed    $index: 값 이름
        :param  int      $filter: 적용할 필터 유형, 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`__\ 에서 찾을 수 있습니다.
        :param  int      $flags: 적용 할 플래그, 플래그 목록은 `여기 <https://www.php.net/manual/en/filter.filters.flags.php>`__\ 에서 찾을 수 있습니다.
        :returns:  발견되면 $_SERVER 항목 값, 그렇지 않으면 null
        :rtype:    mixed

        이 메소드는 :doc:`IncomingRequest Class </incoming/incomingrequest>`\ 의 ``post()``, ``get()`` 및 ``cookie()`` 메소드와 동일하며 getServer 데이터(``$_SERVER``)만 가져옵니다.
        
        .. literalinclude:: request/004.php

        ``$_SERVER``\ 의 여러개의 값을 배열을 받고싶다면, 필요한 모든 키를 배열로 전달하십시오.
        
        .. literalinclude:: request/005.php

    .. php:method:: getEnv([$index = null[, $filter = null[, $flags = null]]])

        :param    mixed     $index: 값 이름
        :param    int       $filter: 적용할 필터 유형. 필터 목록 `here <https://www.php.net/manual/en/filter.filters.php>`__.
        :param    int|array $flags: 적용할 플래그. 플래그 목록 `here <https://www.php.net/manual/en/filter.filters.flags.php>`__.
        :returns: 발견되면 $_ENV 항목 값, 그렇지 않으면 null
        :rtype:   mixed

        이 메소드는 :doc:`IncomingRequest Class </incoming/incomingrequest>`\ 의 ``post()``, ``get()`` 및 ``cookie()`` 메소드와 동일하며 getServer 데이터(``$_ENV``)만 가져옵니다.
        
        .. literalinclude:: request/006.php

        ``$_ENV``\ 의 여러개의 값을 배열을 받고싶다면, 필요한 모든 키를 배열로 전달하십시오.
        
        .. literalinclude:: request/007.php

    .. php:method:: setGlobal($method, $value)

        :param    string $method: Method명
        :param    mixed  $value:  추가할 데이터
        :returns: HTTP request method
        :rtype:   Request

        $_GET, $_POST 등과 같은 PHP 글로벌 값을 수동으로 설정할 수 있습니다.

    .. php:method:: fetchGlobal($method [, $index = null[, $filter = null[, $flags = null]]])

        :param    string    $method: 입력 필터 상수
        :param    mixed     $index: 값 이름
        :param    int       $filter: 적용할 필터 유형. 필터 목록 `here <https://www.php.net/manual/en/filter.filters.php>`__.
        :param    int|array $flags: 적용할 플래그. 플래그 목록 `here <https://www.php.net/manual/en/filter.filters.flags.php>`__.
        :rtype:   mixed

        cookie, get, post 등과 같은 PHP 글로벌에서 하나 이상의 항목을 가져옵니다.
        선택적으로 필터를 전달하여 입력을 검색할 때 입력을 필터링할 수 있습니다.