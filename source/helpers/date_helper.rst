###########
Date 헬퍼
###########

Date 헬퍼 파일에는 Date 작업을 지원하는 함수가 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

.. literalinclude:: date_helper/001.php

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: now([$timezone = null])

    :param	string	$timezone: 시간대
    :returns:	UNIX 타임 스탬프
    :rtype:	int

    구성 파일의 "time reference" 설정에 따라 현재 시간을 서버의 로컬 시간 또는 PHP지원 시간대를 참조하는 UNIX타임 스탬프로 반환합니다.
    다른 PHP지원 시간대에 마스터 시간 참조를 설정하지 않으려는 경우 PHP의 ``time()`` 함수를 통해 이 기능을 사용하는 것은 좋지 않습니다. (일반적으로 각 사용자가 자신의 시간대 설정을 지정할 수 있는 사이트를 실행하는 경우 수행)

    .. literalinclude:: date_helper/002.php

    시간대가 제공되지 않으면 **time_reference** 설정에 따라 ``time ()``\ 이 반환됩니다.

.. php:function:: timezone_select([$class = '', $default = '', $what = \DateTimeZone::ALL, $country = null])

    :param	string	$class: 선택 필드에 적용할 선택적 클래스
    :param	string	$default: 초기 선택의 기본값
    :param	int	$what: DateTimeZone 클래스 상수 (`listIdentifiers <https://www.php.net/manual/en/datetimezone.listidentifiers.php>`_ 참조)
    :param	string	$country: 2글자 ISO 3166-1 호환 국가 코드 (`listIdentifiers <https://www.php.net/manual/en/datetimezone.listidentifiers.php>`_ 참조)
    :returns:	사전 형식화 된 HTML 선택 필드
    :rtype:	string

    사용 가능한 시간대의 `select` 폼 필드를 생성합니다 (선택적으로 `$what`\ 과 `$country` 로 필터링 됨).
    필드에 적용할 옵션 클래스를 제공하여 서식을 쉽게 설정하고 기본적으로 선택된 값을 지정할 수 있습니다.

    .. literalinclude:: date_helper/003.php

CodeIgniter 3 ``date_helper``\ 의 많은 기능이 CodeIgniter 4의 ``I18n`` 모듈로 이동되었습니다.
