요청(Request) Class
****************************************************

요청 클래스는 HTTP 요청의 객체 지향 표현입니다.
이는 브라우저에서 어플리케이션으로 들어오는 요청과 어플리케이션에서 타사 어플리케이션으로 요청을 보내는 발신 요청 모두에서 작동합니다.
이 클래스는 둘 다 필요한 공통 기능을 제공하지만 두 경우 모두 특정 기능을 추가하기 위해 Request 클래스에서 확장되는 사용자 정의 클래스가 있습니다.

자세한 사용법은 :doc:`IncomingRequest Class </incoming/incomingrequest>` 및 :doc:`CURLRequest Class </libraries/curlrequest>` 문서를 참조하십시오.

Class Reference
============================================================

.. php:class:: CodeIgniter\\HTTP\\Request

	.. php:method:: getIPAddress()

		:returns: 사용자의 IP 주소 또는 null, IP 주소가 유효하지 않은 경우 0.0.0.0을 반환
		:rtype: string

		현재 사용자의 IP 주소를 반환합니다. IP 주소가 유효하지 않은 경우 메소드는 '0.0.0.0'을 리턴합니다.
		
		::

			echo $request->getIPAddress();

		.. important:: 이 메소드는 ``App->proxyIPs``\ 에 허용하도록 설정된 IP 주소에 대해 ``HTTP_X_FORWARDED_FOR``, ``HTTP_CLIENT_IP``, ``HTTP_X_CLIENT_IP`` 또는 ``HTTP_X_CLUSTER_CLIENT_IP`` 주소를 반환합니다.

	.. php:method:: isValidIP($ip[, $which = ''])

		:param	string	$ip: IP address
		:param	string	$which: IP protocol ('ipv4' or 'ipv6')
		:returns:	주소가 유효하면 true, 그렇지 않으면 false
		:rtype:	bool

		IP 주소를 입력으로 사용하고 유효한지 여부에 따라 true 또는 false(부울)를 리턴합니다.

		.. note:: 위의 $request->getIPAddress() 메소드는 IP 주소를 자동으로 검증합니다.

		::

			if ( ! $request->isValidIP($ip))
			{
                            echo 'Not Valid';
			}
			else
			{
                            echo 'Valid';
			}

		IP 형식을 지정하기 위해 'ipv4' 또는 'ipv6'의 선택적 두 번째 매개 변수를 사용합니다. 지정하지 않으면 두 형식을 모두 확인합니다.

	.. php:method:: getMethod([$upper = FALSE])

		:param	bool	$upper: 요청 메소드 이름을 대문자 또는 소문자로 반환할지 여부
		:returns:	HTTP 요청 방법
		:rtype:	string

		설정 옵션에 따라 대문자 또는 소문자로 ``$_SERVER['REQUEST_METHOD']``\ 를 반환합니다.

		::

			echo $request->getMethod(TRUE); // Outputs: POST
			echo $request->getMethod(FALSE); // Outputs: post
			echo $request->getMethod(); // Outputs: post

	.. php:method:: getServer([$index = null[, $filter = null[, $flags = null]]]) 
		:noindex:

		:param	mixed	$index: 값 이름
		:param  int     $filter: 적용할 필터 유형, 필터 목록은 `여기 <https://www.php.net/manual/en/filter.filters.php>`__\ 에서 찾을 수 있습니다.
		:param  int     $flags: 적용 할 플래그, 플래그 목록은 `여기 <https://www.php.net/manual/en/filter.filters.flags.php>`__\ 에서 찾을 수 있습니다.
		:returns:	발견되면 $_SERVER 항목 값, 그렇지 않으면 NULL
		:rtype:	mixed

		이 메소드는 :doc:`IncomingRequest Class </incoming/incomingrequest>`\ 의 ``post()``, ``get()`` 및 ``cookie()`` 메소드와 동일하며 getServer 데이터(``$_SERVER``)만 가져옵니다.
		
		::

			$request->getServer('some_data');

		``$_SERVER``\ 의 여러개의 값을 배열을 받고싶다면, 필요한 모든 키를 배열로 전달하십시오.
		
		::

			$require->getServer(['SERVER_PROTOCOL', 'REQUEST_URI']);
