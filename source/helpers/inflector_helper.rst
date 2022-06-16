################
Inflector 헬퍼
################

Inflector 헬퍼에는 **영어** 단어를 복수, 단수, camel 등으로 변경할 수 있는 함수가 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

.. literalinclude:: inflector_helper/001.php

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: singular($string)

    :param	string	$string: 입력 문자열
    :returns:	단수형 단어
    :rtype:	string

    복수형 단어를 단수형으로 바꿉니다.
    
    .. literalinclude:: inflector_helper/002.php

.. php:function:: plural($string)

    :param	string	$string: 입력 문자열
    :returns:	복수형 단어
    :rtype:	string

    단수형 단어를 복수형으로 바꿉니다.
    
    .. literalinclude:: inflector_helper/003.php

.. php:function:: counted($count, $string)

    :param	int 	$count:  항목 수
    :param	string	$string: 입력 문자열
    :returns:	단수 또는 복수구
    :rtype:	string

    단어와 그 수를 구문으로 변경합니다.
    
    .. literalinclude:: inflector_helper/004.php

.. php:function:: camelize($string)

    :param	string	$string: 입력 문자열
    :returns:	Camel case 문자열
    :rtype:	string

    공백이나 밑줄로 구분된 단어 문자열을 Camel case 문자열로 변경합니다.
    
    .. literalinclude:: inflector_helper/005.php

.. php:function:: pascalize($string)

    :param	string	$string: 입력 문자열
    :returns:	Pascal case 문자열
    :rtype:	string

    공백 또는 밑줄로 구분된 문자열을 Pascal case 문자열로 변경합니다. 
    첫 번째 문자가 대문자로 표시되는 Camel case 문자열입니다.

    .. literalinclude:: inflector_helper/006.php

.. php:function:: underscore($string)

    :param	string	$string: 입력 문자열
    :returns:	공백 대신 밑줄을 포함하는 문자열
    :rtype:	string

    여러 단어를 구분하는 공백을 밑줄로 표시합니다.
    
    .. literalinclude:: inflector_helper/007.php

.. php:function:: humanize($string[, $separator = '_'])

    :param	string	$string: 입력 문자열
    :param	string	$separator: 입력 구분자
    :returns:	Humanized 문자열
    :rtype:	string

    여러 단어를 구분하는 밑줄을 공백으로 표시합니다. 각 단어의 첫 글자는 대문자입니다.

    .. literalinclude:: inflector_helper/008.php

    밑줄 대신 대시(-)를 사용할 수 있습니다.
    
    .. literalinclude:: inflector_helper/009.php

.. php:function:: is_pluralizable($word)

    :param	string	$word: 입력 문자열
    :returns:	단어가 복수형이면 true, 그렇지 않은 경우 false
    :rtype:	bool

    주어진 단어가 복수형인지 확인합니다.
    
    .. literalinclude:: inflector_helper/010.php

.. php:function:: dasherize($string)

    :param	string	$string: 입력 문자열
    :returns:	Dasherized 문자열
    :rtype:	string

    문자열에서 밑줄을 대시로 바꿉니다.
    
    .. literalinclude:: inflector_helper/011.php

.. php:function:: ordinal($integer)

    :param	int	$integer: 접미사를 결정하는 정수
    :returns:	서수 접미사
    :rtype:	string

    1st, 2nd, 3rd, 4th등 위치를 나타 내기 위해 숫자에 추가해야 하는 접미사를 반환합니다.
    
    .. literalinclude:: inflector_helper/012.php

.. php:function:: ordinalize($integer)

    :param	int	$integer: 순서화할 정수
    :returns:	서수 정수
    :rtype:	string

    숫자를 1st, 2nd, 3rd, 4th등 위치를 나타내는 서수 문자열로 바꿉니다.

    .. literalinclude:: inflector_helper/013.php
