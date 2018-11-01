###########
텍스트 Helper
###########

The Text Helper file contains functions that assist in working with Text.
텍스트 도우미 파일에는 텍스트로 작업하는 데 도움이되는 함수가 들어 있습니다.

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

Loading this Helper
===================

This helper is loaded using the following code
이 도우미는 다음 코드를 사용하여로드됩니다.

::

	helper('text');

Available Functions
===================

The following functions are available:
다음 기능을 사용할 수 있습니다.

.. php:function:: random_string([$type = 'alnum'[, $len = 8]])

	:param	string	$type: Randomization type
	:param	int	$len: Output string length
	:returns:	A random string
	:rtype:	string

	Generates a random string based on the type and length you specify.
	Useful for creating passwords or generating random hashes.
	지정한 유형과 길이에 따라 임의의 문자열을 생성합니다. 암호를 만들거나 임의의 해시를 생성하는 데 유용합니다.

	The first parameter specifies the type of string, the second parameter
	specifies the length. The following choices are available:
	첫 번째 매개 변수는 문자열 유형을 지정하고 두 번째 매개 변수는 길이를 지정합니다.
	다음 선택 항목을 사용할 수 있습니다.

	-  **alpha**: A string with lower and uppercase letters only.
	-  **alnum**: Alpha-numeric string with lower and uppercase characters.
	-  **basic**: A random number based on ``mt_rand()`` (length ignored).
	-  **numeric**: Numeric string.
	-  **nozero**: Numeric string with no zeros.
	-  **md5**: An encrypted random number based on ``md5()`` (fixed length of 32).
	-  **sha1**: An encrypted random number based on ``sha1()`` (fixed length of 40).
        -  **crypto**: A random string based on ``random_bytes()``.

	Usage example::

		echo random_string('alnum', 16);

.. php:function:: increment_string($str[, $separator = '_'[, $first = 1]])

	:param	string	$str: Input string
	:param	string	$separator: Separator to append a duplicate number with
	:param	int	$first: Starting number
	:returns:	An incremented string
	:rtype:	string

	Increments a string by appending a number to it or increasing the
	number. Useful for creating "copies" or a file or duplicating database
	content which has unique titles or slugs.
	숫자를 추가하거나 숫자를 늘려서 문자열을 증가시킵니다. 
	고유 한 제목이나 슬러그가있는 "사본"또는 파일 작성 또는 데이터베이스 내용 복제에 유용합니다.

	Usage example::

		echo increment_string('file', '_'); // "file_1"
		echo increment_string('file', '-', 2); // "file-2"
		echo increment_string('file_4'); // "file_5"

.. php:function:: alternator($args)

	:param	mixed	$args: A variable number of arguments
	:returns:	Alternated string(s)
	:rtype:	mixed

	Allows two or more items to be alternated between, when cycling through
	a loop.
	루프를 순환 할 때 두 개 이상의 항목을 번갈아 사용할 수 있습니다. 예:
	
	::

		for ($i = 0; $i < 10; $i++)
		{     
			echo alternator('string one', 'string two');
		}

	You can add as many parameters as you want, and with each iteration of
	your loop the next item will be returned.
	원하는만큼 매개 변수를 추가 할 수 있으며 루프의 각 반복마다 다음 항목이 반환됩니다.

	::

		for ($i = 0; $i < 10; $i++)
		{     
			echo alternator('one', 'two', 'three', 'four', 'five');
		}

	.. note:: To use multiple separate calls to this function simply call the
		function with no arguments to re-initialize.
		이 함수에 대해 여러 개의 개별 호출을 사용하려면 인수없이 함수를 호출하여 다시 초기화하십시오.

.. php:function:: reduce_double_slashes($str)

	:param	string	$str: Input string
	:returns:	A string with normalized slashes
	:rtype:	string

	Converts double slashes in a string to a single slash, except those
	found in URL protocol prefixes (e.g. http&#58;//).
	문자열의 이중 슬래시를 URL 프로토콜 접두어 (예 : http & //)에서 발견되는 것을 제외하고 단일 슬래시로 변환합니다.

	Example::

		$string = "http://example.com//index.php";
		echo reduce_double_slashes($string); // results in "http://example.com/index.php"

.. php:function:: strip_slashes($data)

	:param	mixed	$data: Input string or an array of strings
	:returns:	String(s) with stripped slashes
	:rtype:	mixed

	Removes any slashes from an array of strings.
	문자열 배열에서 슬래시를 제거합니다.

	Example::

		$str = [
			'question' => 'Is your name O\'reilly?',
			'answer'   => 'No, my name is O\'connor.'
		];

		$str = strip_slashes($str);

	The above will return the following array
	위의 코드는 다음 배열을 반환합니다.
	
	::

		[
			'question' => "Is your name O'reilly?",
			'answer'   => "No, my name is O'connor."
		];

	.. note:: For historical reasons, this function will also accept
		and handle string inputs. This however makes it just an
		alias for ``stripslashes()``.
		역사적인 이유로이 함수는 문자열 입력을 받아들이고 처리합니다. 
		그러나 이것은 단지 그것을 별명으로 ``stripslashes()`` 만듭니다.

.. php:function:: reduce_multiples($str[, $character = ''[, $trim = FALSE]])

	:param	string	$str: Text to search in
	:param	string	$character: Character to reduce
	:param	bool	$trim: Whether to also trim the specified character
	:returns:	Reduced string
	:rtype:	string

	Reduces multiple instances of a particular character occurring directly
	after each other.
	서로 직접적으로 발생하는 특정 문자의 여러 인스턴스를 줄입니다. 예:
	
	::

		$string = "Fred, Bill,, Joe, Jimmy";
		$string = reduce_multiples($string,","); //results in "Fred, Bill, Joe, Jimmy"

	If the third parameter is set to TRUE it will remove occurrences of the
	character at the beginning and the end of the string.
	세 번째 매개 변수가 TRUE로 설정되면 문자열의 시작과 끝에서 문자가 제거됩니다. 예:
	::

		$string = ",Fred, Bill,, Joe, Jimmy,";
		$string = reduce_multiples($string, ", ", TRUE); //results in "Fred, Bill, Joe, Jimmy"

.. php:function:: quotes_to_entities($str)

	:param	string	$str: Input string
	:returns:	String with quotes converted to HTML entities
	:rtype:	string

	Converts single and double quotes in a string to the corresponding HTML
	entities.
	문자열의 작은 따옴표와 큰 따옴표를 해당 HTML 엔터티로 변환합니다. 예:
	
	::

		$string = "Joe's \"dinner\"";
		$string = quotes_to_entities($string); //results in "Joe&#39;s &quot;dinner&quot;"

.. php:function:: strip_quotes($str)

	:param	string	$str: Input string
	:returns:	String with quotes stripped
	:rtype:	string

	Removes single and double quotes from a string.
	문자열에서 작은 따옴표와 큰 따옴표를 제거합니다. 예:
	
	::

		$string = "Joe's \"dinner\"";
		$string = strip_quotes($string); //results in "Joes dinner"

.. php:function:: word_limiter($str[, $limit = 100[, $end_char = '&#8230;']])

	:param	string	$str: Input string
	:param	int	$limit: Limit
	:param	string	$end_char: End character (usually an ellipsis)
	:returns:	Word-limited string
	:rtype:	string

	Truncates a string to the number of *words* specified. Example
	지정된 *단어* 수만큼 문자열을 자릅니다 . 예:
	
	::

		$string = "Here is a nice text string consisting of eleven words.";
		$string = word_limiter($string, 4);
		// Returns:  Here is a nice

	The third parameter is an optional suffix added to the string. By
	default it adds an ellipsis.
	세 번째 매개 변수는 문자열에 추가 된 선택적 접미사입니다. 기본적으로 줄임표가 추가됩니다.

.. php:function:: character_limiter($str[, $n = 500[, $end_char = '&#8230;']])

	:param	string	$str: Input string
	:param	int	$n: Number of characters
	:param	string	$end_char: End character (usually an ellipsis)
	:returns:	Character-limited string
	:rtype:	string

	Truncates a string to the number of *characters* specified. It
	maintains the integrity of words so the character count may be slightly
	more or less than what you specify.
	문자열을 지정된 *문자* 수로 자릅니다 .
	문자 수를 지정하는 것보다 조금 더 많거나 적을 수 있도록 단어의 무결성을 유지합니다.

	Example::

		$string = "Here is a nice text string consisting of eleven words.";
		$string = character_limiter($string, 20);
		// Returns:  Here is a nice text string

	The third parameter is an optional suffix added to the string, if
	undeclared this helper uses an ellipsis.
	세 번째 매개 변수는 선언되지 않은 경우이 도우미가 줄임표를 사용하는 경우 문자열에 추가되는 선택적 접미사입니다.

	.. note:: If you need to truncate to an exact number of characters please
		see the :php:func:`ellipsize()` function below.
		정확한 수의 문자로자를 필요가있는 경우 :php:func:`ellipsize()` 아래 기능을 참조하십시오 .

.. php:function:: ascii_to_entities($str)

	:param	string	$str: Input string
	:returns:	A string with ASCII values converted to entities
	:rtype:	string

	Converts ASCII values to character entities, including high ASCII and MS
	Word characters that can cause problems when used in a web page, so that
	they can be shown consistently regardless of browser settings or stored
	reliably in a database. There is some dependence on your server's
	supported character sets, so it may not be 100% reliable in all cases,
	but for the most part it should correctly identify characters outside
	the normal range (like accented characters).
	ASCII 값을 웹 페이지에서 사용할 때 문제를 일으킬 수있는 높은 ASCII 및 MS Word 문자를 포함한 문자 엔티티로 변환하므로 브라우저 설정에 관계없이 일관되게 표시되거나 데이터베이스에 안정적으로 저장 될 수 있습니다.
	서버에서 지원하는 문자 집합에 대한 의존도가 있으므로 모든 경우에 100 % 신뢰할 수는 없지만 대부분의 경우 정상 범위를 벗어난 문자 (악센트 부호가있는 문자 등)를 올바르게 식별해야합니다.

	Example::

		$string = ascii_to_entities($string);

.. php:function:: entities_to_ascii($str[, $all = TRUE])

	:param	string	$str: Input string
	:param	bool	$all: Whether to convert unsafe entities as well
	:returns:	A string with HTML entities converted to ASCII characters
	:rtype:	string

	This function does the opposite of :php:func:`ascii_to_entities()`.
	It turns character entities back into ASCII.
	이 함수는 반대의 역할을 :php:func:`ascii_to_entities()` 합니다. 문자 엔티티를 다시 ASCII로 변환합니다.

.. php:function:: convert_accented_characters($str)

	:param	string	$str: Input string
	:returns:	A string with accented characters converted
	:rtype:	string

	Transliterates high ASCII characters to low ASCII equivalents. Useful
	when non-English characters need to be used where only standard ASCII
	characters are safely used, for instance, in URLs.
	높은 ASCII 문자를 낮은 ASCII 문자로 변환합니다. URL에서와 같이 표준 ASCII 문자 만 안전하게 사용되는 경우 영어 이외의 문자를 사용해야하는 경우에 유용합니다.

	Example::

		$string = convert_accented_characters($string);

	.. note:: This function uses a companion config file
		`application/Config/ForeignCharacters.php`_ to define the to and
		from array for transliteration.
		이 함수는 companion 설정 파일 인 application / Config / ForeignCharacters.php 를 사용하여 음역에 대한 to와 from 배열을 정의합니다.

.. php:function:: word_censor($str, $censored[, $replacement = ''])

	:param	string	$str: Input string
	:param	array	$censored: List of bad words to censor
	:param	string	$replacement: What to replace bad words with
	:returns:	Censored string
	:rtype:	string

	Enables you to censor words within a text string. The first parameter
	will contain the original string. The second will contain an array of
	words which you disallow. The third (optional) parameter can contain
	a replacement value for the words. If not specified they are replaced
	with pound signs: ####.
	텍스트 문자열에서 단어를 검열 할 수 있습니다.
	첫 번째 매개 변수에는 원래 문자열이 포함됩니다.
	두 번째 단어에는 허용하지 않는 단어 배열이 포함됩니다.
	세 번째 (선택적) 매개 변수는 단어의 대체 값을 포함 할 수 있습니다.
	지정되지 않으면 파운드 기호로 바뀝니다 : ####.

	Example::

		$disallowed = ['darn', 'shucks', 'golly', 'phooey'];
		$string     = word_censor($string, $disallowed, 'Beep!');

.. php:function:: highlight_code($str)

	:param	string	$str: Input string
	:returns:	String with code highlighted via HTML
	:rtype:	string

	Colorizes a string of code (PHP, HTML, etc.). Example::

		$string = highlight_code($string);

	The function uses PHP's ``highlight_string()`` function, so the
	colors used are the ones specified in your php.ini file.
	이 함수는 PHP 함수를 사용 ``highlight_string()`` 하므로 php.ini 파일에 지정된 색상이 사용됩니다.

.. php:function:: highlight_phrase($str, $phrase[, $tag_open = '<mark>'[, $tag_close = '</mark>']])

	:param	string	$str: Input string
	:param	string	$phrase: Phrase to highlight
	:param	string	$tag_open: Opening tag used for the highlight
	:param	string	$tag_close: Closing tag for the highlight
	:returns:	String with a phrase highlighted via HTML
	:rtype:	string

	Will highlight a phrase within a text string. The first parameter will
	contain the original string, the second will contain the phrase you wish
	to highlight. The third and fourth parameters will contain the
	opening/closing HTML tags you would like the phrase wrapped in.
	텍스트 문자열 내의 구문을 강조 표시합니다.
	첫 번째 매개 변수에는 원래 문자열이 포함되고 두 번째 매개 변수에는 강조 표시 할 구문이 포함됩니다.
	세 번째와 네 번째 매개 변수에는 구문을 넣을 개폐 HTML 태그가 포함됩니다.

	Example::

		$string = "Here is a nice text string about nothing in particular.";
		echo highlight_phrase($string, "nice text", '<span style="color:#990000;">', '</span>');

	The above code prints
	위의 코드는 다음을 인쇄합니다.
	
	::

		Here is a <span style="color:#990000;">nice text</span> string about nothing in particular.

	.. note:: This function used to use the ``<strong>`` tag by default. Older browsers
		might not support the new HTML5 mark tag, so it is recommended that you
		insert the following CSS code into your stylesheet if you need to support
		such browsers
		이 함수 ``<strong>`` 는 기본적으로 태그 를 사용하는 데 사용됩니다 .
		이전 브라우저는 새 HTML5 마크 태그를 지원하지 않을 수 있으므로 이러한 브라우저를 지원해야하는 경우 스타일 시트에 다음 CSS 코드를 삽입하는 것이 좋습니다.
		
		::

			mark {
				background: #ff0;
				color: #000;
			};

.. php:function:: word_wrap($str[, $charlim = 76])

	:param	string	$str: Input string
	:param	int	$charlim: Character limit
	:returns:	Word-wrapped string
	:rtype:	string

	Wraps text at the specified *character* count while maintaining
	complete words.
	완전한 단어를 유지하면서 지정된 *문자* 수로 텍스트를 줄 바꿈합니다 .

	Example::

		$string = "Here is a simple string of text that will help us demonstrate this function.";
		echo word_wrap($string, 25);

		// Would produce:
		// Here is a simple string
		// of text that will help us
		// demonstrate this
		// function.

        Excessively long words will be split, but URLs will not be.
        지나치게 긴 단어는 분할되지만 URL은 분할되지 않습니다.

.. php:function:: ellipsize($str, $max_length[, $position = 1[, $ellipsis = '&hellip;']])

	:param	string	$str: Input string
	:param	int	$max_length: String length limit
	:param	mixed	$position: Position to split at (int or float)
	:param	string	$ellipsis: What to use as the ellipsis character
	:returns:	Ellipsized string
	:rtype:	string

	This function will strip tags from a string, split it at a defined
	maximum length, and insert an ellipsis.
	이 함수는 문자열에서 태그를 제거하고 정의 된 최대 길이로 분할하고 줄임표를 삽입합니다.

	The first parameter is the string to ellipsize, the second is the number
	of characters in the final string. The third parameter is where in the
	string the ellipsis should appear from 0 - 1, left to right. For
	example. a value of 1 will place the ellipsis at the right of the
	string, .5 in the middle, and 0 at the left.
	첫 번째 매개 변수는 줄임표로 표시 할 문자열이고 두 번째 매개 변수는 최종 문자열에있는 문자 수입니다. 
	세 번째 매개 변수는 문자열에서 줄임표가 왼쪽에서 오른쪽으로 0 - 1로 표시되어야하는 위치입니다.
	예를 들어 값 1은 문자열의 오른쪽에 줄임표를 넣고 중간에 .5, 왼쪽에 0을 붙입니다.

	An optional forth parameter is the kind of ellipsis. By default,
	&hellip; will be inserted.
	선택적인 네 번째 매개 변수는 줄임표의 종류입니다. 
	기본적으로 & hellip; 삽입됩니다.

	Example::

		$str = 'this_string_is_entirely_too_long_and_might_break_my_design.jpg';
		echo ellipsize($str, 32, .5);

	Produces::

		this_string_is_e&hellip;ak_my_design.jpg

.. php:function:: excerpt($text, $phrase = false, $radius = 100, $ellipsis = '...')

	:param	string	$text: Text to extract an excerpt
	:param	string	$phrase: Phrase or word to extract the text arround
	:param	int		$radius: Number of characters before and after $phrase
	:param	string	$ellipsis: What to use as the ellipsis character
	:returns:	Excerpt.
	:rtype:		string

	This function will extract $radius number of characters before and after the
	central $phrase with an elipsis before and after.
	이 함수는 앞뒤에 elipsis가있는 $ $ 구의 앞뒤에 $ radius 수를 추출합니다.

	The first paramenter is the text to extract an excerpt from, the second is the
	central word or phrase to count before and after. The third parameter is the
	number of characters to count before and after the central phrase. If no phrase
	passed, the excerpt will include the first $radius characters with the elipsis
	at the end.
	첫 번째 매개 변수는 발췌를 추출 할 텍스트이고, 두 번째 매개 변수는 앞뒤로 계산할 중앙 단어 또는 구입니다. 
	세 번째 매개 변수는 중부 프레이즈의 앞뒤에있는 문자 수입니다. 
	어구가 전달되지 않으면 발췌 부분에 elipsis가있는 첫 번째 $ 반지름 문자가 끝에 포함됩니다.

	Example::

		$text = 'Ut vel faucibus odio. Quisque quis congue libero. Etiam gravida
		eros lorem, eget porttitor augue dignissim tincidunt. In eget risus eget
		mauris faucibus molestie vitae ultricies odio. Vestibulum id ultricies diam.
		Curabitur non mauris lectus. Phasellus eu sodales sem. Integer dictum purus
		ac enim hendrerit gravida. Donec ac magna vel nunc tincidunt molestie sed
		vitae nisl. Cras sed auctor mauris, non dictum tortor. Nulla vel scelerisque
		arcu. Cras ac ipsum sit amet augue laoreet laoreet. Aenean a risus lacus.
		Sed ut tortor diam.';

		echo excerpt($str, 'Donec');

	Produces::

		... non mauris lectus. Phasellus eu sodales sem. Integer dictum purus ac
		enim hendrerit gravida. Donec ac magna vel nunc tincidunt molestie sed
		vitae nisl. Cras sed auctor mauris, non dictum ...
