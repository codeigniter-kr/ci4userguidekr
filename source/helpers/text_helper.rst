###########
Text 헬퍼
###########

Text 헬퍼에는 텍스트 작업을 지원하는 기능이 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

.. literalinclude:: text_helper/001.php

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: random_string([$type = 'alnum'[, $len = 8]])

    :param	string	$type: 무작위화 유형
    :param	int	$len: 출력 문자열 길이
    :returns:	무작위 문자열
    :rtype:	string

    지정한 유형과 길이에 따라 임의의 문자열을 생성합니다.
    비밀번호를 생성하거나 임의의 해시를 생성하는데 유용합니다.

    첫 번째 매개 변수는 문자열 유형을 지정하고 두 번째 매개 변수는 길이를 지정합니다. 다음과 같은 선택이 가능합니다 :

    - **alpha**: 소문자와 대문자만 있는 문자열
    - **alnum**: 소문자와 대문자가 포함된 영/숫자 문자열
    - **basic**: ``mt_rand()``\ 를 기준으로하는 난수 (길이 무시)
    - **numeric**: 숫자 문자열
    - **nozero**: 0이없는 숫자 문자열
    - **md5**: ``md5()``\ 를 기반으로 암호화된 난수 (고정 길이 32)
    - **sha1**: ``sha1()``\ 을 기반으로 암호화 된 난수 (고정 길이 40)
    - **crypto**: ``random_bytes()``\ 를 기반으로 하는 임의의 문자열

    .. note:: **crypto**\ 를 사용하는 경우 두 번째 매개변수에 짝수를 설정해야 합니다.
        v4.2.2부터 홀수를 설정하면 ``InvalidArgumentException``\ 이 발생합니다.

    .. literalinclude:: text_helper/002.php

.. php:function:: increment_string($str[, $separator = '_'[, $first = 1]])

    :param	string	$str: 입력 문자열
    :param	string	$separator: 중복 번호를 추가할 구분 기호
    :param	int	$first: 시작 번호
    :returns:	증분 문자열
    :rtype:	string

    숫자를 추가하거나 늘리면 문자열이 증가합니다.
    "사본" 파일을 만들거나 고유한 제목 또는 슬러그가 있는 데이터베이스 내용을 복제하는 데 유용합니다.

    .. literalinclude:: text_helper/003.php

.. php:function:: alternator($args)

    :param	mixed	$args: 가변 개수의 인수
    :returns:	대체 문자열
    :rtype:	mixed

    루프를 순환할 때 둘 이상의 항목을 번갈아 사용할 수 있습니다.
    
    .. literalinclude:: text_helper/004.php

    원하는만큼 매개 변수를 추가할 수 있으며 루프를 반복할 때마다 다음 항목이 리턴됩니다.

    .. literalinclude:: text_helper/005.php

    .. note:: 이 함수에 대해 여러 개의 개별 호출을 사용하려면 인수없이 함수를 호출하여 다시 초기화하십시오.

.. php:function:: reduce_double_slashes($str)

    :param	string	$str: 입력 문자열
    :returns:	단일 슬래시로 정규화된 문자열
    :rtype:	string

    URL 프로토콜 접두사에 있는 것을 제외하고 문자열의 이중 슬래시를 단일 슬래시로 변환합니다. (예 : http&#58;//).

    .. literalinclude:: text_helper/006.php

.. php:function:: strip_slashes($data)

    :param	mixed	$data: 입력 문자열 또는 문자열 배열
    :returns:	슬래시가 제거 된 문자열
    :rtype:	mixed

    문자열 배열에서 슬래시를 제거합니다.

    .. literalinclude:: text_helper/007.php

    위 실행 결과는 다음 배열을 반환합니다
    
    .. literalinclude:: text_helper/008.php

    .. note:: 이것은 ``stripslashes()``\ 의 별칭이며, 호환성을 위해 문자열 입력도 받아들이고 처리합니다.

.. php:function:: reduce_multiples($str[, $character = ''[, $trim = false]])

    :param	string	$str: 검색할 텍스트
    :param	string	$character: 줄일 문자
    :param	bool	$trim: 지정된 문자를 다듬을지 여부
    :returns:	감소된 문자열
    :rtype:	string

    서로 직접적으로 발생하는 특정 문자의 여러 인스턴스를 줄입니다.
    
    .. literalinclude:: text_helper/009.php

    세 번째 매개 변수가 true로 설정되면 문자열의 시작과 끝에 있는 문자가 제거됩니다.
    
    .. literalinclude:: text_helper/010.php

.. php:function:: quotes_to_entities($str)

    :param	string	$str: 입력 문자열
    :returns:	따옴표가 HTML 엔티티로 변환된 문자열
    :rtype:	string

    문자열에서 작은 따옴표와 큰 따옴표를 해당 HTML 엔터티로 변환합니다.

    .. literalinclude:: text_helper/011.php

.. php:function:: strip_quotes($str)

    :param	string	$str: 입력 문자열
    :returns:	따옴표가있는 문자열
    :rtype:	string

    문자열에서 작은 따옴표와 큰 따옴표를 제거합니다.

    .. literalinclude:: text_helper/012.php

.. php:function:: word_limiter($str[, $limit = 100[, $end_char = '&#8230;']])

    :param	string	$str: 입력 문자열
    :param	int	$limit: 제한
    :param	string	$end_char: 끝 문자 (일반적으로 줄임표)
    :returns:	 제한된 단어 수 문자열
    :rtype:	string

    문자열을 지정된 *단어* 수 만큼 자릅니다.
    
    .. literalinclude:: text_helper/013.php

    세 번째 매개 변수는 문자열에 추가된 선택적 접미사입니다. 기본적으로 줄임표가 추가됩니다.

.. php:function:: character_limiter($str[, $n = 500[, $end_char = '&#8230;']])

    :param	string	$str: 입력 문자열
    :param	int	$n: 문자 수
    :param	string	$end_char: 끝 문자 (일반적으로 줄임표)
    :returns:	제한된 문자 수 문자열
    :rtype:	string

    지정된 *문자 수*\ 만큼 문자열을 자릅니다.
    단어의 무결성을 유지하므로 문자 수가 사용자가 지정한 것보다 약간 많거나 적을 수 있습니다.

    .. literalinclude:: text_helper/014.php

    세 번째 매개 변수는 선언되지 않은 경우 이 헬퍼가 줄임표를 사용하는 경우 문자열에 추가된 선택적 접미사입니다.

    .. note:: 정확한 수의 문자로 잘라야 할 경우 아래의 :php:func:`ellipsize()` 함수를 참조하십시오.

.. php:function:: ascii_to_entities($str)

    :param	string	$str: 입력 문자열
    :returns:	엔티티로 변환 된 ASCII 값을 가진 문자열
    :rtype:	string

    ASCII 값을 웹 페이지에서 사용할 때 문제를 일으킬 수 있는 상위 ASCII 및 MS Word 문자를 포함하는 ASCII 값을 브라우저 설정에 관계없이 일관성있게 표시하거나, 데이터베이스에 안정적으로 저장할 수 있도록 문자 엔티티로 변환합니다.
    서버의 지원되는 문자 집합에 약간의 의존성이 있으므로 모든 경우에 100% 신뢰할 수는 없지만 대부분의 경우 일반 범위를 벗어난 문자(예 : 악센트 부호가 있는 문자)를 정확하게 식별합니다.

    .. literalinclude:: text_helper/015.php

.. php:function:: entities_to_ascii($str[, $all = true])

    :param	string	$str: 입력 문자열
    :param	bool	$all: 안전하지 않은 엔터티도 변환할지 여부
    :returns:	HTML 엔티티가 ASCII 문자로 변환된 문자열
    :rtype:	string

    이 함수는 :php:func:`ascii_to_entities()`\ 와 반대입니다.
    문자 엔터티를 다시 ASCII로 바꿉니다.

.. php:function:: convert_accented_characters($str)

    :param	string	$str: 입력 문자열
    :returns:	악센트 문자가 변환된 문자열
    :rtype:	string

    상위 ASCII 문자를 하위 ASCII 문자로 음역합니다.
    URL과 같이 표준 ASCII 문자만 안전하게 사용하는 경우 영어 이외의 문자를 사용해야 하는 경우에 유용합니다.

    .. literalinclude:: text_helper/016.php

    .. note:: 이 함수는 컴패니언 구성 파일 `app/Config/ForeignCharacters.php`\ 를 사용하여 음역을 위한 배열을 정의합니다.	

.. php:function:: word_censor($str, $censored[, $replacement = ''])

    :param	string	$str: 입력 문자열
    :param	array	$censored: 검열해야 할 사용 금지 단어 목록
    :param	string	$replacement: 사용 금지 단어 대체 문자열
    :returns:	검열된 문자열
    :rtype:	string

    텍스트 문자열 내에서 단어를 검열 할 수 있습니다.
    첫 번째 매개 변수는 원래 문자열을 포함합니다. 
    두 번째는 허용하지 않는 단어 배열을 포함합니다. 
    세 번째 (선택적) 매개 변수는 단어의 대체 값을 포함합니다. 지정하지 않으면 파운드 기호(####)로 대체됩니다.

    .. literalinclude:: text_helper/017.php

.. php:function:: highlight_code($str)

    :param	string	$str: 입력 문자열
    :returns:	HTML을 통해 코드가 강조 표시된 문자열
    :rtype:	string

    코드 문자열(PHP, HTML 등)을 채색합니다.

    .. literalinclude:: text_helper/018.php

    이 함수는 PHP의 ``highlight_string()`` 함수를 사용하므로 사용되는 색상은 php.ini 파일에 지정된 색상입니다.

.. php:function:: highlight_phrase($str, $phrase[, $tag_open = '<mark>'[, $tag_close = '</mark>']])

    :param	string	$str: 입력 문자열
    :param	string	$phrase: 하이라이트할 문구
    :param	string	$tag_open: 하이라이트에 대한 시작 태그
    :param	string	$tag_close: 하이라이트에 대한 닫기 태그
    :returns:	HTML을 통해 강조 표시된 태그가 있는 문자열
    :rtype:	string

    텍스트 문자열 내에서 문구를 강조 표시합니다.
    첫 번째 매개 변수는 원래 문자열을 포함하고 두 번째 매개 변수는 강조 표시하려는 구를 포함합니다.
    세 번째 및 네 번째 매개 변수에는 구문을 래핑하려는 시작/닫기 HTML 태그가 포함됩니다.

    .. literalinclude:: text_helper/019.php

    위 코드의 출력
    
    ::

        Here is a <span style="color:#990000;">nice text</span> string about nothing in particular.

    .. note:: 이 기능은 기본적으로 ``<strong>`` 태그를 사용했습니다. 
        이전 브라우저는 새로운 HTML5 마크 태그를 지원하지 않을 수 있으므로 이러한 브라우저를 지원해야 하는 경우 다음 CSS 코드를 스타일 시트에 삽입하는 것이 좋습니다.
    
        ::

            mark {
                background: #ff0;
                color: #000;
            };

.. php:function:: word_wrap($str[, $charlim = 76])

    :param	string	$str: 입력 문자열
    :param	int	$charlim: 글자 수 한도
    :returns:	줄 바꿈 문자열
    :rtype:	string

    완전한 단어를 유지하면서 지정된 *문자* 수로 텍스트를 줄 바꿈합니다.

    .. literalinclude:: text_helper/020.php

.. php:function:: ellipsize($str, $max_length[, $position = 1[, $ellipsis = '&hellip;']])

    :param	string	$str: 입력 문자열
    :param	int	$max_length: 문자열 길이 제한
    :param	mixed	$position: 분할 할 위치 (int 또는 float)
    :param	string	$ellipsis: 줄임표 문자로 사용할 문자열
    :returns:	생략된 문자열
    :rtype:	string

    이 함수는 문자열에서 태그를 제거하고 정의된 최대 길이로 분할한 후 줄임표를 삽입합니다.
    
    첫 번째 매개 변수는 생략할 문자열이고 두 번째 매개 변수는 최종 문자열의 문자 수입니다.
    세 번째 매개 변수는 문자열에서 줄임표가 나타나는 위치이며 값이 1이면 문자열 오른쪽에, .5면 가운데에, 0이면 왼쪽에 줄임표가 나타납니다.

    네 번째 파라미터(선택 사항)는 생략 부호입니다. 
    기본값으로 ``&hellip;``\ 이 삽입됩니다.

    .. literalinclude:: text_helper/021.php

    ::

        this_string_is_e&hellip;ak_my_design.jpg

.. php:function:: excerpt($text, $phrase = false, $radius = 100, $ellipsis = '...')

    :param	string	$text: 발췌문을 추출하기 위한 텍스트
    :param	string	$phrase: 문자열을 추출하기 위한 구문 또는 단어
    :param	int		$radius: $phrase 전후의 문자 수
    :param	string	$ellipsis: 줄임표 문자로 사용할 항목
    :returns:	Excerpt.
    :rtype:		string

    이 함수는 앞뒤로 줄임표를 사용하여 중앙 $phrase 전후에 $radius 수의 문자를 추출합니다.

    첫 번째 매개 변수는 발췌문을 추출하는 텍스트이고 두 번째 매개 변수는 이전과 이후에 계산할 중심 단어 또는 구입니다.
    세 번째 매개 변수는 중앙 구 앞뒤로 계산할 문자 수입니다.
    문구가 전달되지 않으면 발췌 부분에 줄임표가 있는 첫 $radius 문자가 포함됩니다.

    .. literalinclude:: text_helper/022.php

    ::

        ... non mauris lectus. Phasellus eu sodales sem. Integer dictum purus ac
        enim hendrerit gravida. Donec ac magna vel nunc tincidunt molestie sed
        vitae nisl. Cras sed auctor mauris, non dictum ...
