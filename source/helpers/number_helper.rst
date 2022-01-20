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

::

    helper('number');

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
    
    ::

        echo number_to_size(456); // Returns 456 Bytes
        echo number_to_size(4567); // Returns 4.5 KB
        echo number_to_size(45678); // Returns 44.6 KB
        echo number_to_size(456789); // Returns 447.8 KB
        echo number_to_size(3456789); // Returns 3.3 MB
        echo number_to_size(12345678912345); // Returns 1.8 GB
        echo number_to_size(123456789123456789); // Returns 11,228.3 TB

    선택적인 두 번째 매개 변수를 사용하면 결과의 정밀도를 설정할 수 있습니다.

    ::

        echo number_to_size(45678, 2); // Returns 44.61 KB

    선택적 세 번째 매개 변수를 사용하면 숫자를 생성할 때 사용해야 하는 로케일을 지정할 수 있으며 형식에 영향을 줄 수 있습니다. 
    로케일을 지정하지 않으면 요청이 분석되고 헤더 또는 앱 기본값에서 적절한 로케일을 가져옵니다.

    ::

        // Generates 11.2 TB
        echo number_to_size(12345678912345, 1, 'en_US');
        // Generates 11,2 TB
        echo number_to_size(12345678912345, 1, 'fr_FR');

    .. note:: 이 함수로 생성된 텍스트의 언어 파일 위치: *language/<your_lang>/Number.php*

.. php:function:: number_to_amount($num[, $precision = 1[, $locale = null])

    :param	mixed	$num: 서식을 지정할 숫자
    :param	int	$precision: 부동 소수점 정밀도
    :param  string $locale: 서식 지정에 사용할 로케일
    :returns:	사람이 읽을 수있는 문자열 버전, 제공된 값이 숫자가 아닌 경우 false
    :rtype:	string

    수십 억까지의 숫자에 대해 숫자를 **123.4 trillion**\ 과 같이 사람이 읽을 수 있는 버전으로 변환합니다.
    
    ::

        echo number_to_amount(123456); // Returns 123 thousand
        echo number_to_amount(123456789); // Returns 123 million
        echo number_to_amount(1234567890123, 2); // Returns 1.23 trillion
        echo number_to_amount('123,456,789,012', 2); // Returns 123.46 billion

    선택적인 두 번째 매개 변수를 사용하면 결과의 정밀도를 설정할 수 있습니다
    
    ::

        echo number_to_amount(45678, 2); // Returns 45.68 thousand

    선택적 세 번째 매개 변수를 사용하면 로케일을 지정할 수 있습니다.
    
    ::

        echo number_to_amount('123,456,789,012', 2, 'de_DE'); // Returns 123,46 billion

.. php:function:: number_to_currency($num, $currency[, $locale = 0])

    :param mixed $num: 서식을 지정할 숫자
    :param string $currency: 통화 유형 : USD, EUR등
    :param string|null $locale: 서식 지정에 사용할 로케일
    :param integer $fraction: 소수점 뒤의 소수 자릿수
    :returns: 로케일에 적합한 통화 문자열
    :rtype: string

    USD, EUR, GBP등과 같은 일반적인 통화 형식으로 숫자를 변환합니다.

    ::

        echo number_to_currency(1234.56, 'USD', 'en_US', 2);  // Returns $1,234.56
        echo number_to_currency(1234.56, 'EUR', 'de_DE', 2);  // Returns 1.234,56 €
        echo number_to_currency(1234.56, 'GBP', 'en_GB', 2);  // Returns £1,234.56
        echo number_to_currency(1234.56, 'YEN', 'ja_JP', 2);  // Returns YEN 1,234.56

    로케일을 지정하지 않으면 요청 로케일이 사용됩니다.

.. php:function:: number_to_roman($num)

    :param string $num: 변환하려는 숫자
    :returns: 매개 변수로 주어진 숫자의 변환된 로마자
    :rtype: string|null

    숫자를 로마자로 변환
    
    ::

        echo number_to_roman(23);  // Returns XXIII
        echo number_to_roman(324);  // Returns CCCXXIV
        echo number_to_roman(2534);  // Returns MMDXXXIV

    이 기능은 1-3999 범위의 숫자만 처리합니다.
    해당 범위 밖의 값에 대해서는 null을 반환합니다.