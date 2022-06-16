#############
Number 헬퍼
#############

Number 헬퍼 파일에는 로케일을 인식하는 방식으로 숫자 데이터를 작업하는데 도움이되는 함수가 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

.. literalinclude:: number_helper/001.php

상황이 잘못될 때
====================

PHP의 국제화 및 현지화 로직이 제공된 로케일 및 옵션에 대해 제공된 값을 처리 할 수 없는 경우 ``BadFunctionCallException()``\ 이 발생합니다.

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: number_to_size($num[, $precision = 1[, $locale = null]])

    :param	mixed	$num: 바이트 수
    :param	int	$precision: 부동 소수점 정밀도
    :param  string $locale: 서식 지정에 사용할 로케일
    :returns:	포맷된 데이터 크기 문자열 또는 제공된 값이 숫자가 아닌 경우 false
    :rtype:	string

    크기에 따라 숫자를 바이트로 포맷하고 적절한 접미사를 추가합니다.
    
    .. literalinclude:: number_helper/002.php

    선택적인 두 번째 매개 변수를 사용하면 결과의 정밀도를 설정할 수 있습니다.

    .. literalinclude:: number_helper/003.php

    선택적 세 번째 매개 변수를 사용하면 숫자를 생성할 때 사용해야 하는 로케일을 지정할 수 있으며 형식에 영향을 줄 수 있습니다. 
    로케일을 지정하지 않으면 요청이 분석되고 헤더 또는 앱 기본값에서 적절한 로케일을 가져옵니다.

    .. literalinclude:: number_helper/004.php

    .. note:: 이 함수로 생성된 텍스트의 언어 파일 위치: *language/<your_lang>/Number.php*

.. php:function:: number_to_amount($num[, $precision = 1[, $locale = null])

    :param	mixed	$num: 서식을 지정할 숫자
    :param	int	$precision: 부동 소수점 정밀도
    :param  string $locale: 서식 지정에 사용할 로케일
    :returns:	사람이 읽을 수있는 문자열 버전, 제공된 값이 숫자가 아닌 경우 false
    :rtype:	string

    수십 억까지의 숫자에 대해 숫자를 **123.4 trillion**\ 과 같이 사람이 읽을 수 있는 버전으로 변환합니다.
    
    .. literalinclude:: number_helper/005.php

    선택적인 두 번째 매개 변수를 사용하면 결과의 정밀도를 설정할 수 있습니다
    
    .. literalinclude:: number_helper/006.php

    선택적 세 번째 매개 변수를 사용하면 로케일을 지정할 수 있습니다.
    
    .. literalinclude:: number_helper/007.php

.. php:function:: number_to_currency($num, $currency[, $locale = 0])

    :param mixed $num: 서식을 지정할 숫자
    :param string $currency: 통화 유형 : USD, EUR등
    :param string|null $locale: 서식 지정에 사용할 로케일
    :param integer $fraction: 소수점 뒤의 소수 자릿수
    :returns: 로케일에 적합한 통화 문자열
    :rtype: string

    USD, EUR, GBP등과 같은 일반적인 통화 형식으로 숫자를 변환합니다.

    .. literalinclude:: number_helper/008.php

    로케일을 지정하지 않으면 요청 로케일이 사용됩니다.

.. php:function:: number_to_roman($num)

    :param string $num: 변환하려는 숫자
    :returns: 매개 변수로 주어진 숫자의 변환된 로마자
    :rtype: string|null

    숫자를 로마자로 변환
    
    .. literalinclude:: number_helper/009.php

    이 기능은 1-3999 범위의 숫자만 처리합니다.
    해당 범위 밖의 값에 대해서는 null을 반환합니다.