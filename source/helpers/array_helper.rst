############
Array 헬퍼
############

배열 헬퍼는 보다 복잡한 배열 사용을 단순화하기 위해 여러 기능을 제공합니다.
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

..  php:function:: array_deep_search($key, array $array)

    :param  mixed  $key: 대상 키(key)
    :param  array  $array: 검색할 배열
    :returns: 배열에서 찾은 값 또는 null
    :rtype: mixed

    불확실한 깊이의 배열에 키 값이 있는 요소의 값을 반환합니다.


..  php:function:: array_sort_by_multiple_keys(array &$array, array $sortColumns)

    :param  array  $array:       정렬할 배열 (참조로 전달).
    :param  array  $sortColumns: 정렬할 배열 키와 PHP 정렬 플래그로 구성된 연관배열.
    :returns: 정렬 성공 여부.
    :rtype: boolean

    이 메서드는 계층적 방식으로 하나 이상의 키 값을 기준으로 다차원 배열의 요소를 정렬합니다.
    아래 예시는 모델의 ``find()`` 함수에서 반환될 수 있는 다음 배열을 가져옵니다.
    
    ::

        $players = [
            0 => [
                'name'     => 'John',
                'team_id'  => 2,
                'position' => 3,
                'team'     => [
                    'id'    => 1,
                    'order' => 2,
                ],
            ],
            1 => [
                'name'     => 'Maria',
                'team_id'  => 5,
                'position' => 4,
                'team'     => [
                    'id'    => 5,
                    'order' => 1,
                ],
            ],
            2 => [
                'name'     => 'Frank',
                'team_id'  => 5,
                'position' => 1,
                'team'     => [
                    'id'    => 5,
                    'order' => 1,
                ],
            ],
        ];

    이제 이 배열을 두 개의 키로 정렬합니다.
    이 메소드는 더 깊은 배열 수준의 값에 액세스하기 위해 점 표기법을 지원하지만 와일드카드는 지원하지 않습니다.
    
    ::

        array_sort_by_multiple_keys($players,
            [
                'team.order' => SORT_ASC,
                'position'   => SORT_ASC,
            ]
        );

    ``$players`` 배열은 이제 각 플레이어의 'team' 하위 배열의 'order' 값에 따라 정렬됩니다.
    여러 플레이어의 'order' 값이 같을 경우, 'position'\ 에 따라 정렬됩니다.
    결과 배열은 다음과 같습니다.

    ::

        $players = [
            0 => [
                'name'     => 'Frank',
                'team_id'  => 5,
                'position' => 1,
                'team'     => [
                    'id' => 5,
                    'order' => 1,
                ],
            ],
            1 => [
                'name'     => 'Maria',
                'team_id'  => 5,
                'position' => 4,
                'team'     => [
                    'id' => 5,
                    'order' => 1,
                ],
            ],
            2 => [
                'name'     => 'John',
                'team_id'  => 2,
                'position' => 3,
                'team'     => [
                    'id' => 1,
                    'order' => 2,
                ],
            ],
        ];

    같은 방식으로 메서드는 객체 배열도 처리할 수 있습니다.
    위의 예에서 각 'player'\ 는 배열로 표현되지만, 'team'\ 은 객체일 가능성이 더 높습니다.
    메소드는 각 중첩 수준에서 요소의 유형을 탐지하고 그에 따라 처리합니다.