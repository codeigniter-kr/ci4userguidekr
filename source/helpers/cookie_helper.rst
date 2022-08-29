#############
쿠키 헬퍼
#############

쿠키 헬퍼에는 쿠키 작업을 지원하는 기능이 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

.. literalinclude:: cookie_helper/001.php

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: set_cookie($name[, $value = ''[, $expire = ''[, $domain = ''[, $path = '/'[, $prefix = ''[, $secure = false[, $httpOnly = false]]]]]]])

    :param	mixed	$name: 이 함수에 사용 가능한 모든 매개 변수의 쿠키 이름 *또는* 연관 배열
    :param	string	$value: 쿠키 값
    :param	int	$expire: 만료까지의 시간 (초)
    :param	string	$domain: 쿠키 도메인 (일반적으로 .yourdomain.com)
    :param	string	$path: 쿠키 경로
    :param	string	$prefix: 쿠키 이름 접두사. ``''``\ 인 경우 **app/Config/Cookie.php**\ 의 기본값이 사용됩니다.
    :param	bool	$secure: HTTPS를 통해서만 쿠키를 보낼지 여부
    :param	bool	$httpOnly: JavaScript에서 쿠키를 숨길 지 여부
    :param  string    $sameSite: SameSite 쿠키 매개변수의 값입니다. ``null``\ 인 경우 **app/Config/Cookie.php**\ 의 기본값이 사용됩니다.
    :rtype:	void

    브라우저 쿠키를 설정하기 위한 보다 친근한 구문을 제공합니다.
    이 함수는 :php:meth:`CodeIgniter\\HTTP\\Response::setCookie()`\ 의 별칭이므로, 사용법에 대한 설명은 :doc:`Response 라이브러리 </outgoing/response>`\ 를 참조하십시오.

.. php:function:: get_cookie($index[, $xssClean = false[, $prefix = '']])

    :param	string	$index: 쿠키 이름
    :param	bool	$xssClean: 반환된 값에 XSS 필터링을 적용할지 여부
    :param	string	$prefix: 쿠키 이름 접두사. ``''``\ 로 설정하면 **app/Config/Cookie.php**\ 의 기본값이 사용됩니다. ``null``\ 로 설정하면 접두사 없음
    :returns:	쿠키 값 또는 찾지 못한 경우 null
    :rtype:	mixed

    .. note:: v4.2.1부터 세 번째 매개변수 ``$prefix``\ 가 도입되었으며 버그 수정으로 인해 동작이 약간 변경되었습니다. 자세한 내용은 :ref:`업그레이드 <upgrade-421-get_cookie>`\ 를 참조하세요.

    이 헬퍼 함수는 브라우저 쿠키를 얻기 위한 보다 친숙한 구문을 제공합니다.
    이 함수는 **app/Config/Cookie.php** 파일에 설정된 ``Config\Cookie::$prefix``\ 를 추가한다는 점을 제외하고는 ``IncomingRequest::getCookie()``\ 와 매우 유사하게 작동하므로 자세한 사용법은 :doc:`IncomingRequest 라이브러리 </incoming/incomingrequest>`\ 를 참조하십시오.

    .. warning:: XSS 필터링을 사용하는 것은 나쁜 습관입니다. XSS 공격을 완벽하게 차단하지는 않습니다. 뷰(view)에서 올바른 ``$context``\ 와 함께 ``esc()``\ 를 사용하는 것이 좋습니다.

.. php:function:: delete_cookie($name[, $domain = ''[, $path = '/'[, $prefix = '']]])

    :param string $name: 쿠키 이름
    :param string $domain: 쿠키 도메인 (일반적으로 .yourdomain.com)
    :param string $path: 쿠키 경로
    :param string $prefix: 쿠키 이름 접두사
    :rtype:	void

    쿠키를 삭제할 수 있습니다. 
    필수값으로 쿠키 이름만 필요하며, 사용자 정의 경로나 다른 값을 설정하지 않아도 됩니다.

    .. literalinclude:: cookie_helper/002.php

    이 함수는 ``value``\ 와 ``expire`` 변수가 없다는 점을 제외하면 ``set_cookie()``\ 와 동일합니다.

    .. note:: ``set_cookie()``\ 를 사용할 때 ``value``\ 가 빈 문자열로 설정되고 ``expire``\ 가 ``0``\ 으로 설정되면 쿠키가 삭제됩니다.
        ``value``\ 가 비어 있지 않은 문자열로 설정되고 ``expire``\ 가 ``0``\ 으로 설정되면 쿠키는 브라우저가 열려 있는 동안에만 지속됩니다.

    첫 번째 매개 변수에 값 배열이나 불연속 매개 변수(discrete parameters)를 설정할 수 있습니다.

    .. literalinclude:: cookie_helper/003.php

.. php:function:: has_cookie(string $name[, ?string $value = null[, string $prefix = '']])

    :param string $name: 쿠키 이름
    :param string|null $value: 쿠키 값
    :param string $prefix: 쿠키 접두사(prefix)
    :rtype: bool

    이름으로 쿠키가 있는지 확인합니다. ``Response::hasCookie()``\ 의 별칭(alias)입니다..