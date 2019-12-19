############
Array 헬퍼
############

배열 헬펀는 보다 복잡한 배열 사용을 단순화하기 위해 여러 기능을 제공합니다.
사용법을 크게 단순화하지 않는다면 PHP가 제공하는 기존 기능을 복제하지 않습니다.

.. contents::
    :local:

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

::

	helper('array');

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

..  php:function:: dot_array_search(string $search, array $values)

    :param  string  $search: 배열을 검색하는 방법을 설명하는 점 표기법 문자열(dot-notation string)
    :param  array   $values: 검색 할 배열
    :returns: 배열 내에서 찾은 값 또는 null
    :rtype: mixed

    이 방법을 사용하면 점 표기법을 사용하여 특정 키의 배열을 검색할 수 있으며 '*' 와일드 카드를 사용할 수 있습니다.
    다음과 같은 배열이 주어졌을때
    
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

    검색 문자열 "foo.buzz.fizz"\ 를 사용하여 'fizz'\ 의 값을 찾을 수 있습니다. 
    마찬가지로, baz의 값은 "foo.bar.baz"\ 에서 찾을 수 있습니다.
    
    ::

        // Returns: 11
        $fizz = dot_array_search('foo.buzz.fizz', $data);

        // Returns: 23
        $baz = dot_array_search('foo.bar.baz', $data);

    별표(*)를 와일드 카드로 사용하여 세그먼트를 바꿀 수 있습니다.
    발견되면 모든 하위 노드를 찾을 때까지 검색합니다.
    값을 모르거나 값에 숫자 색인이 있는 경우에 유용합니다.
    
    ::

        // Returns: 23
        $baz = dot_array_search('foo.*.baz', $data);
