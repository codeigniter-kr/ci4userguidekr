#############
Cookie Helper
#############

The Cookie Helper file contains functions that assist in working with
cookies.
쿠키 Helper 파일에는 쿠키 작업에 도움이되는 기능이 포함되어 있습니다.

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

Loading this Helper
===================

This helper is loaded using the following code
이 도우미는 다음 코드를 사용하여로드됩니다.

::

	helper('cookie');

Available Functions
===================

The following functions are available:
다음 기능을 사용할 수 있습니다.

.. php:function:: set_cookie($name[, $value = ''[, $expire = ''[, $domain = ''[, $path = '/'[, $prefix = ''[, $secure = false[, $httpOnly = false]]]]]]])

	:param	mixed	$name: Cookie name *or* associative array of all of the parameters available to this function
	:param	string	$value: Cookie value
	:param	int	$expire: Number of seconds until expiration
	:param	string	$domain: Cookie domain (usually: .yourdomain.com)
	:param	string	$path: Cookie path
	:param	string	$prefix: Cookie name prefix
	:param	bool	$secure: Whether to only send the cookie through HTTPS
	:param	bool	$httpOnly: Whether to hide the cookie from JavaScript
	:rtype:	void

	이 helper 함수는 브라우저 쿠키를 설정하는 친숙한 구문을 제공합니다. 
	이 기능은 ``Response::setCookie()`` 의 별명이기 때문에 자세한 설명은
	:doc:`Response Library <../libraries/response>` 를 참조하십시오 .

.. php:function:: get_cookie($index[, $xssClean = false])

	:param	string	$index: Cookie name
	:param	bool	$xss_clean: Whether to apply XSS filtering to the returned value
	:returns:	The cookie value or NULL if not found
	:rtype:	mixed

	This helper function gives you friendlier syntax to get browser
	cookies. Refer to the :doc:`IncomingRequest Library <../libraries/incomingrequest>` for
	detailed description of its use, as this function acts very
	similarly to ``IncomingRequest::getCookie()``, except it will also prepend
	the ``$cookiePrefix`` that you might've set in your
	*application/Config/App.php* file.
	이 helper 함수는 브라우저 쿠키를 얻기위한 친숙한 구문을 제공합니다.
	이 함수에 대한 자세한 설명은 :doc:`IncomingRequest Library <../libraries/incomingrequest>` 를 참조하십시오.
	이 함수는 응용 프로그램 / Config / App.php 파일 에서 설정 한 ``IncomingRequest::getCookie()`` 것 외에는 매우 유사 합니다. ``$cookiePrefix``



.. php:function:: delete_cookie($name[, $domain = ''[, $path = '/'[, $prefix = '']]])

	:param	string	$name: Cookie name
	:param	string	$domain: Cookie domain (usually: .yourdomain.com)
	:param	string	$path: Cookie path
	:param	string	$prefix: Cookie name prefix
	:rtype:	void

	Lets you delete a cookie. Unless you've set a custom path or other
	values, only the name of the cookie is needed.
	쿠키를 삭제할 수 있습니다. 사용자 정의 경로 나 다른 값을 설정하지 않은 경우에는 쿠키의 이름 만 필요합니다.
	
	::

		delete_cookie('name');

	This function is otherwise identical to ``set_cookie()``, except that it
	does not have the value and expiration parameters. You can submit an
	array of values in the first parameter or you can set discrete
	parameters.
	이 함수는 ``set_cookie()`` value 및 expiration 매개 변수가 없다는 점을 제외 하고는와 동일합니다 .
	첫 번째 매개 변수에 값 배열을 제출하거나 개별 매개 변수를 설정할 수 있습니다.
	
	
	::

		delete_cookie($name, $domain, $path, $prefix);