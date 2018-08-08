###########
Date Helper
###########

The Date Helper file contains functions that assist in working with
dates.
데이터 helper 파일에는 날짜 작업에 도움이되는 함수가 들어 있습니다.

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

Loading this Helper
===================

This helper is loaded using the following code::

	helper('date');

Available Functions
===================

The following functions are available:
이 helper는 다음 코드를 사용하여로드됩니다.

.. php:function:: now([$timezone = NULL])

	:param	string	$timezone: Timezone
	:returns:	UNIX timestamp
	:rtype:	int

	Returns the current time as a UNIX timestamp, referenced either to your server's
	local time or any PHP supported timezone, based on the "time reference" setting
	in your config file. If you do not intend to set your master time reference to
	any other PHP supported timezone (which you'll typically do if you run a site
	that lets each user set their own timezone settings) there is no benefit to using
	this function over PHP's ``time()`` function.
	현재 시간을 UNIX 타임 스탬프로 반환합니다.
	설정 파일의 "time reference"설정에 따라 서버의 현지 시간 또는 PHP가 지원하는 모든 시간대를 참조합니다.
	당신은 (각 사용자가 자신의 시간대 설정을 할 수있는 사이트를 실행하는 경우 당신이 일반적 것이다) PHP의를 통해이 기능을 사용하여 얻을 수있는 이점이없는 다른 PHP 지원 시간대에 마스터 시간 기준을 설정하지 않으려면 ``time()`` 기능 .
	
	
	::

		echo now('Australia/Victoria');

	If a timezone is not provided, it will return ``time()`` based on the
	**time_reference** setting.
	시간대가 제공되지 않으면 time_reference 설정 ``time()`` 에 따라 반환됩니다 .

Many functions previously found in the CodeIgniter 3 ``date_helper`` have been moved to the ``I18n``
module in CodeIgniter 4.
이전에 CodeIgniter 3에서 발견 된 많은 기능들이 CodeIgniter 4 ``date_helper`` 의 ``I18n`` 모듈 로 옮겨졌습니다 .
