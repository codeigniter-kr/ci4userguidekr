###############
Security 헬퍼
###############

Security 헬퍼에는 보안 관련 함수가 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

.. literalinclude:: security_helper/001.php

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: sanitize_filename($filename)

    :param	string	$filename: 파일명
    :returns:	안전한 파일명
    :rtype:	string

    Provides protection against directory traversal.

    이 함수는 ``\CodeIgniter\Security::sanitize_filename()``\ 의 별칭입니다.
    자세한 내용은 :doc:`보안 라이브러리 <../libraries/security>` 설명서를 참조하십시오.

.. php:function:: strip_image_tags($str)

    :param	string	$str: 입력 문자열
    :returns:	이미지 태그가 없는 입력 문자열
    :rtype:	string

    이것은 문자열에서 이미지 태그를 제거하는 보안 기능입니다.
    이미지 URL을 일반 텍스트만 남겨 둡니다.

    .. literalinclude:: security_helper/002.php

.. php:function:: encode_php_tags($str)

    :param	string	$str: 입력 문자열
    :returns:	안전한 형식의 문자열
    :rtype:	string

    PHP 태그를 엔티티로 변환하는 보안 기능입니다.

    .. literalinclude:: security_helper/003.php
