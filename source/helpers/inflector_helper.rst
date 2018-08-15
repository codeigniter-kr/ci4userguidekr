################
Inflector Helper
################

The Inflector Helper file contains functions that permits you to change
**English** words to plural, singular, camel case, etc.
Inflector Helper 파일에는 **영어** 단어를 복수형, 단수 형, 낙타 형 등 으로 변경할 수있는 기능이 있습니다 .

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

Loading this Helper
===================

This helper is loaded using the following code
이 helper는 다음 코드를 사용하여로드됩니다.

::

	helper('inflector');

Available Functions
===================

The following functions are available:
다음 기능을 사용할 수 있습니다.

.. php:function:: singular($string)

	:param	string	$string: Input string
	:returns:	A singular word
	:rtype:	string

	Changes a plural word to singular. 
	복수 단어를 단수로 바꿉니다.
	예:
	
	::

		echo singular('dogs'); // Prints 'dog'

.. php:function:: plural($string)

	:param	string	$string: Input string
	:returns:	A plural word
	:rtype:	string

	Changes a singular word to plural. 
	한 단어를 복수로 변경합니다.
	예:
	
	::

		echo plural('dog'); // Prints 'dogs'

.. php:function:: camelize($string)

	:param	string	$string: Input string
	:returns:	Camelized string
	:rtype:	string

	Changes a string of words separated by spaces or underscores to camel
	case.
	공백이나 밑줄로 구분 된 단어를 낙타의 경우로 변경합니다.
	예:
	
	::

		echo camelize('my_dog_spot'); // Prints 'myDogSpot'

.. php:function:: underscore($string)

	:param	string	$string: Input string
	:returns:	String containing underscores instead of spaces
	:rtype:	string

	Takes multiple words separated by spaces and underscores them.
	공백으로 분리 된 여러 단어를 가져 와서 밑줄을 긋습니다.
	예:
	
	::

		echo underscore('my dog spot'); // Prints 'my_dog_spot'

.. php:function:: humanize($string[, $separator = '_'])

	:param	string	$string: Input string
	:param	string	$separator: Input separator
	:returns:	Humanized string
	:rtype:	string

	Takes multiple words separated by underscores and adds spaces between
	them. Each word is capitalized.

	밑줄로 분리 된 여러 단어를 가져 와서 그 사이에 공백을 추가합니다. 
	각 단어는 대문자로 표기됩니다.
	예:
	
	::

		echo humanize('my_dog_spot'); // Prints 'My Dog Spot'

	To use dashes instead of underscores
	밑줄 대신 대시를 사용하려면 다음을 수행하십시오.
	
	::

		echo humanize('my-dog-spot', '-'); // Prints 'My Dog Spot'

.. php:function:: is_pluralizable($word)

	:param	string	$word: Input string
	:returns:	TRUE if the word is countable or FALSE if not
	:rtype:	bool

	Checks if the given word has a plural version. 
	지정된 단어에 복수형이 있는지 검사합니다.
	예:
	
	::

		is_pluralizable('equipment'); // Returns FALSE

.. php:function:: dasherize($string)

	:param	string	$string: Input string
	:returns:	Dasherized string
	:rtype:	string

	Replaces underscores with dashes in the string. 
	밑줄을 문자열의 대시로 대체합니다.
	예:
	
	::

		dasherize('hello_world'); // Returns 'hello-world'

.. php:function:: ordinal($integer)

	:param	int	$integer: The integer to determine the suffix
	:returns:	Ordinal suffix
	:rtype:	string

	Returns the suffix that should be added to a
	number to denote the position such as
	1st, 2nd, 3rd, 4th. 
	1, 2, 3, 4와 같이 위치를 나타 내기 위해 숫자에 추가해야하는 접미사를 반환합니다.
	예:
	
	::

		ordinal(1); // Returns 'st'

.. php:function:: ordinalize($integer)

	:param	int	$integer: The integer to ordinalize
	:returns:	Ordinalized integer
	:rtype:	string

	Turns a number into an ordinal string used
	to denote the position such as 1st, 2nd, 3rd, 4th.
	숫자를 1, 2, 3, 4와 같이 위치를 나타내는 데 사용되는 순서 문자열로 변환합니다.
	예:
	
	::

		ordinalize(1); // Returns '1st'