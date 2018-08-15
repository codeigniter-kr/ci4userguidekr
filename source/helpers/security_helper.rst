###############
Security Helper
###############

The Security Helper file contains security related functions.
보안 helper 파일에는 보안 관련 기능이 들어 있습니다.

.. contents::
  :local:

Loading this Helper
===================

This helper is loaded using the following code
이 helper는 다음 코드를 사용하여로드됩니다.

::

	helper('security');

Available Functions
===================

The following functions are available:
다음 기능을 사용할 수 있습니다.

.. php:function:: sanitize_filename($filename)

	:param	string	$filename: Filename
    	:returns:	Sanitized file name
    	:rtype:	string

    	Provides protection against directory traversal.
    	디렉터리 탐색에 대한 보호 기능을 제공합니다.

    	This function is an alias for ``\CodeIgniter\Security::sanitize_filename()``.
	For more info, please see the :doc:`Security Library <../libraries/security>`
	documentation.
	이 함수는에 대한 별칭입니다 ``\CodeIgniter\Security::sanitize_filename()``.
	자세한 내용은 :doc:`Security Library <../libraries/security>` 설명서 를 참조하십시오 .

.. php:function:: strip_image_tags($str)

	:param	string	$str: Input string
    	:returns:	The input string with no image tags
    	:rtype:	string

    	This is a security function that will strip image tags from a string.
    	It leaves the image URL as plain text.
    	문자열에서 이미지 태그를 제거하는 보안 기능입니다. 이미지 URL을 일반 텍스트로 남겨 둡니다.

    	예::

		$string = strip_image_tags($string);

.. php:function:: encode_php_tags($str)

	:param	string	$str: Input string
    	:returns:	Safely formatted string
    	:rtype:	string

    	This is a security function that converts PHP tags to entities.
    	PHP 태그를 엔티티로 변환하는 보안 함수입니다.

	예::

		$string = encode_php_tags($string);
