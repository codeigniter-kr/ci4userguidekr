############
Array Helper
############

The array helper provides several functions to simplify more complex usages of arrays. It is not intended to duplicate
any of the existing functionality that PHP provides - unless it is to vastly simplify their usage.
배열 도우미는 배열의보다 복잡한 사용을 단순화하는 몇 가지 함수를 제공합니다. 사용법을 크게 단순화하지 않는 한, PHP가 제공하는 기존 기능을 복제하는 것이 아닙니다.

.. contents::
    :local:

Loading this Helper
===================

이 helper는 다음 코드를 사용하여 로드됩니다.

::

	helper('array');

Available Functions
===================

다음 기능을 사용할 수 있습니다.

..  php:function:: dot_array_search(string $search, array $values)

    :param  string  $search: The dot-notation string describing how to search the array 배열을 검색하는 방법을 설명하는 점 표기법 문자열
    :param  array   $values: The array to search 검색 할 배열
    :returns: The value found within the array, or null 배열 내에있는 값, 또는 null
    :rtype: mixed

    This method allows you to use dot-notation to search through an array for a specific-key,
    and allows the use of a the '*' wildcard. Given the following array
    이 방법을 사용하면 점 표기법을 사용하여 배열에서 특정 키를 검색하고 '*'와일드 카드를 사용할 수 있습니다. 주어진 다음 배열
    
    ::

        $data = [
            'foo' => [
                'buzz' => [
                    'fizz' => 11
                ],
                'bar' => [
                    'baz' => 23
                ]
            ]
        ]

    We can locate the value of 'fizz' by using the search string "foo.buzz.fizz". Likewise, the value
    of baz can be found with "foo.bar.baz"
    검색 문자열 "foo.buzz.fizz"를 사용하여 'fizz'값을 찾을 수 있습니다. 마찬가지로, baz의 값은 "foo.bar.baz"로 찾을 수 있습니다.
    
    ::

        // Returns: 11
        $fizz = dot_array_search('foo.buzz.fizz', $data);

        // Returns: 23
        $baz = dot_array_search('foo.bar.baz', $data);

    You can use the asterisk as a wildcard to replace any of the segments. When found, it will search through all
    of the child nodes until it finds it. This is handy if you don't know the values, or if your values
    have a numeric index
    와일드 카드로 별표를 사용하여 세그먼트를 대체 할 수 있습니다. 발견되면 모든 자식 노드를 찾을 때까지 검색합니다. 값을 모르는 경우 또는 값에 숫자 인덱스가있는 경우이 방법이 유용합니다.
    
    ::

        // Returns: 23
        $baz = dot_array_search('foo.*.baz', $data);
