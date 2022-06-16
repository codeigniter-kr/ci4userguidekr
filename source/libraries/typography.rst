################
타이포그래피
################

타이포그래피 라이브러리에는 의미적으로 관련된 방식으로 텍스트의 서식을 지정하는데 도움이 되는 메소드가 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

*******************
라이브러리 로드
*******************

CodeIgniter의 다른 서비스와 마찬가지로 ``Config\Services``\ 를 통해 로드할 수 있지만, 일반적으로 수동으로 로드할 필요는 없습니다.

.. literalinclude:: typography/001.php

**************************
사용 가능한 정적 함수
**************************

다음 기능을 사용할 수 있습니다:

.. php:function:: autoTypography($str[, $reduce_linebreaks = false])

	:param	string	$str: 입력 문자열
	:param	bool	$reduce_linebreaks: 이중 개행의 여러 인스턴스를 2개로 줄일지 여부
	:returns:	HTML-formatted typography-safe string
	:rtype: string

	텍스트를 변형하여 의미론적으로 정확한 HTML을 만듭니다.

	Usage example

	.. literalinclude:: typography/002.php

	.. note:: Typographic 형식은 특히 많은 콘텐츠를 포맷하는 경우 프로세서를 많이 사용할 수 있습니다. 
		이 기능을 사용하기로 했다면 :doc:`caching <../general/caching>` 페이지를 고려하십시오.

.. php:function:: formatCharacters($str)

	:param	string	$str: 입력 문자열
	:returns:	형식이 지정된 문자가 포함된 문자열
	:rtype:	string

	이 함수는 주로 큰 따옴표(")와 작은 따옴표(')를 중괄호로 변환하지만 em-dashes, 이중 공백(double spaces), 앰퍼샌드(&)도 변환합니다.

	Usage example

	.. literalinclude:: typography/003.php

**nl2brExceptPre()**

.. php:function:: nl2brExceptPre($str)

	:param	string	$str: 입력 문자열
	:returns:	String with HTML-formatted line breaks
	:rtype:	string

	줄 바꿈이 ``<pre>`` 태그내에 나타나지 않으면 개행을 ``<br />`` 태그로 변환합니다.
	이 함수는 ``<pre>`` 태그를 무시한다는 점을 제외하면 PHP 네이티브 ``nl2br()`` 함수와 동일합니다.

	Usage example

	.. literalinclude:: typography/004.php
