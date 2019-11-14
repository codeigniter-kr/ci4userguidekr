########################
쿼리 결과 생성
########################

쿼리 결과를 생성하는 몇 가지 방법이 있습니다.

.. contents::
    :local:
    :depth: 2

***************************
결과 배열(Result Arrays)
***************************

**getResult()**

이 메소드는 쿼리 결과를 **objects**\ 의 배열로 반환하고, 실패시는 **빈 배열**\ 을 반환합니다. 
일반적으로 아래와 같이 foreach 루프에 사용합니다.

::

    $query = $db->query("YOUR QUERY");

    foreach ($query->getResult() as $row)
    {
        echo $row->title;
        echo $row->name;
        echo $row->body;
    }

위의 메소드는``getResultObject()``\ 의 별칭입니다.

결과를 배열의 배열로 얻으려면 문자열 'array'를 전달합니다.

::

    $query = $db->query("YOUR QUERY");

    foreach ($query->getResult('array') as $row)
    {
        echo $row['title'];
        echo $row['name'];
        echo $row['body'];
    }

위의 사용법은 ``getResultArray()``\ 의 별칭입니다.

``getResult()``\ 의 각 결과 객체에 대해 인스턴스화 할 클래스를 나타내는 문자열을 전달할 수도 있습니다.

::

    $query = $db->query("SELECT * FROM users;");

    foreach ($query->getResult('User') as $user)
    {
        echo $user->name; // access attributes
        echo $user->reverseName(); // or methods defined on the 'User' class
    }

위의 메소드는``getCustomResultObject()``\ 의 별칭입니다.

**getResultArray()**

이 메소드는 조회 결과를 순수한 배열로 리턴하거나 결과가 생성되지 않으면 빈 배열을 리턴합니다. 
일반적으로 이것을 아래와 같은 foreach 루프에서 사용합니다

::

    $query = $db->query("YOUR QUERY");

    foreach ($query->getResultArray() as $row)
    {
        echo $row['title'];
        echo $row['name'];
        echo $row['body'];
    }

**************************
결과 행(Result Rows)
**************************

**getRow()**

이 메소드는 단일 결과 행을 리턴합니다.
쿼리에 둘 이상의 행이 있으면 첫 번째 행만 반환합니다.
결과는 **객체**로 반환됩니다. 사용법 예는 다음과 같습니다.

::

    $query = $db->query("YOUR QUERY");

    $row = $query->getRow();

    if (isset($row))
    {
        echo $row->title;
        echo $row->name;
        echo $row->body;
    }

특정 행을 리턴하려면 첫 번째 매개 변수에 행 번호를 숫자로 제출하십시오.

::

	$row = $query->getRow(5);

행을 인스턴스화하는 클래스의 이름인 두 번째 문자열 매개 변수를 추가할 수도 있습니다.

::

	$query = $db->query("SELECT * FROM users LIMIT 1;");
	$row = $query->getRow(0, 'User');

	echo $row->name; // access attributes
	echo $row->reverse_name(); // or methods defined on the 'User' class

**getRowArray()**

위의 ``row()`` 메서드와 동일하지만 배열을 반환합니다. 샘플::

    $query = $db->query("YOUR QUERY");

    $row = $query->getRowArray();

    if (isset($row))
    {
        echo $row['title'];
        echo $row['name'];
        echo $row['body'];
    }

특정 행을 리턴하려면 첫 번째 매개 변수에서 행 번호를 숫자로 제출하십시오.

::

	$row = $query->getRowArray(5);

또한 이러한 변형을 사용하여 결과를 "forward/backwards/first/last"로 검색할 수 있습니다:

	| **$row = $query->getFirstRow()**
	| **$row = $query->getLastRow()**
	| **$row = $query->getNextRow()**
	| **$row = $query->getPreviousRow()**

매개 변수에 "array"라는 단어를 넣지 않으면 기본적으로 객체를 반환합니다.:

	| **$row = $query->getFirstRow('array')**
	| **$row = $query->getLastRow('array')**
	| **$row = $query->getNextRow('array')**
	| **$row = $query->getPreviousRow('array')**

.. note:: 위의 모든 메소드는 전체 결과를 메모리에 로드합니다.(프리 페치) 큰 결과 집합을 처리하려면 ``getUnbufferedRow()``\ 를 사용하십시오.

**getUnbufferedRow()**

이 메소드는 ``row()``\ 와 같이 메모리에서 전체 결과를 프리 페치 하지 않고, 단일 결과 행을 리턴합니다.
쿼리에 둘 이상의 행이 있으면 현재 행을 반환하고 내부 데이터 포인터를 앞으로 이동합니다.

::

    $query = $db->query("YOUR QUERY");

    while ($row = $query->getUnbufferedRow())
    {
        echo $row->title;
        echo $row->name;
        echo $row->body;
    }

반환된 값의 유형을 지정하기 위해 선택적으로 'object'(기본값) 또는 'array'를 전달할 수 있습니다.

::

	$query->getUnbufferedRow();		    // object
	$query->getUnbufferedRow('object');	// object
	$query->getUnbufferedRow('array');	// associative array

*********************
사용자 정의 결과 객체
*********************

``getResult()``\ 와 ``getResultArray()`` 메소드가 허용하는대로 ``stdClass`` 또는 배열 대신 사용자 정의 클래스의 인스턴스로 결과를 리턴할 수 있습니다.
클래스가 아직 메모리에 로드되지 않은 경우 오토로더가 로드를 시도합니다.
객체는 데이터베이스에서 반환된 모든 값을 속성으로 설정합니다.
선언되었으나 공개되지 않은 속성의 경우 ``__set()`` 메소드를 제공하여 설정할 수 있습니다.

Example::

	class User
	{
		public $id;
		public $email;
		public $username;

		protected $last_login;

		public function lastLogin($format)
		{
			return $this->lastLogin->format($format);
		}

		public function __set($name, $value)
		{
			if ($name === 'lastLogin')
			{
				$this->lastLogin = DateTime::createFromFormat('U', $value);
			}
		}

		public function __get($name)
		{
			if (isset($this->$name))
			{
				return $this->$name;
			}
		}
	}

아래 나열된 두 가지 메소드 외에 ``getFirstRow()``, ``getLastRow()``, ``getNextRow()``, ``getPreviousRow()`` 메소드에서도 클래스 이름을 사용하여 결과를 다음과 같이 반환할 수 있습니다.

**getCustomResultObject()**

요청된 클래스의 인스턴스 배열로 전체 결과 집합을 반환합니다.
인스턴스화 할 클래스의 이름을 단일 매개 변수로 사용합니다.

Example::

	$query = $db->query("YOUR QUERY");

	$rows = $query->getCustomResultObject('User');

	foreach ($rows as $row)
	{
		echo $row->id;
		echo $row->email;
		echo $row->last_login('Y-m-d');
	}

**getCustomRowObject()**

쿼리 결과에서 단일 행을 반환합니다.
첫 번째 매개 변수는 결과의 행 번호입니다.
두 번째 매개 변수는 인스턴스화 할 클래스 이름입니다.

Example::

	$query = $db->query("YOUR QUERY");

	$row = $query->getCustomRowObject(0, 'User');

	if (isset($row))
	{
		echo $row->email;   // access attributes
		echo $row->last_login('Y-m-d');   // access class methods
	}

``getRow()`` 메서드를 같은 방식으로 사용할 수 있습니다.

Example::

	$row = $query->getCustomRowObject(0, 'User');

*********************
결과 헬퍼 메소드
*********************

**getFieldCount()**

쿼리에서 반환 한 FIELDS (열) 갯수 입니다.
Make sure to call the method using your query result object

::

	$query = $db->query('SELECT * FROM my_table');

	echo $query->getFieldCount();

**getFieldNames()**

Returns an array with the names of the FIELDS (columns) returned by the query.
Make sure to call the method using your query result object::

    $query = $db->query('SELECT * FROM my_table');

	echo $query->getFieldNames();

**freeResult()**

It frees the memory associated with the result and deletes the result
resource ID. Normally PHP frees its memory automatically at the end of
script execution. However, if you are running a lot of queries in a
particular script you might want to free the result after each query
result has been generated in order to cut down on memory consumption.

Example::

	$query = $thisdb->query('SELECT title FROM my_table');

	foreach ($query->getResult() as $row)
	{
		echo $row->title;
	}

	$query->freeResult();  // The $query result object will no longer be available

	$query2 = $db->query('SELECT name FROM some_table');

	$row = $query2->getRow();
	echo $row->name;
	$query2->freeResult(); // The $query2 result object will no longer be available

**dataSeek()**

This method sets the internal pointer for the next result row to be
fetched. It is only useful in combination with ``getUnbufferedRow()``.

It accepts a positive integer value, which defaults to 0 and returns
TRUE on success or FALSE on failure.

::

	$query = $db->query('SELECT `field_name` FROM `table_name`');
	$query->dataSeek(5); // Skip the first 5 rows
	$row = $query->getUnbufferedRow();

.. note:: Not all database drivers support this feature and will return FALSE.
	Most notably - you won't be able to use it with PDO.

***************
Class Reference
***************

.. php:class:: \CodeIgniter\Database\BaseResult

	.. php:method:: getResult([$type = 'object'])

		:param	string	$type: Type of requested results - array, object, or class name
		:returns:	Array containing the fetched rows
		:rtype:	array

		A wrapper for the ``getResultArray()``, ``getResultObject()``
		and ``getCustomResultObject()`` methods.

		Usage: see `Result Arrays`_.

	.. php:method:: getResultArray()

		:returns:	Array containing the fetched rows
		:rtype:	array

		Returns the query results as an array of rows, where each
		row is itself an associative array.

		Usage: see `Result Arrays`_.

	.. php:method:: getResultObject()

		:returns:	Array containing the fetched rows
		:rtype:	array

		Returns the query results as an array of rows, where each
		row is an object of type ``stdClass``.

		Usage: see `Result Arrays`_.

	.. php:method:: getCustomResultObject($class_name)

		:param	string	$class_name: Class name for the resulting rows
		:returns:	Array containing the fetched rows
		:rtype:	array

		Returns the query results as an array of rows, where each
		row is an instance of the specified class.

	.. php:method:: getRow([$n = 0[, $type = 'object']])

		:param	int	$n: Index of the query results row to be returned
		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	The requested row or NULL if it doesn't exist
		:rtype:	mixed

		A wrapper for the ``getRowArray()``, ``getRowObject()`` and
		``getCustomRowObject()`` methods.

		Usage: see `Result Rows`_.

	.. php:method:: getUnbufferedRow([$type = 'object'])

		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	Next row from the result set or NULL if it doesn't exist
		:rtype:	mixed

		Fetches the next result row and returns it in the
		requested form.

		Usage: see `Result Rows`_.

	.. php:method:: getRowArray([$n = 0])

		:param	int	$n: Index of the query results row to be returned
		:returns:	The requested row or NULL if it doesn't exist
		:rtype:	array

		Returns the requested result row as an associative array.

		Usage: see `Result Rows`_.

	.. php:method:: getRowObject([$n = 0])

		:param	int	$n: Index of the query results row to be returned
                :returns:	The requested row or NULL if it doesn't exist
		:rtype:	stdClass

		Returns the requested result row as an object of type
		``stdClass``.

		Usage: see `Result Rows`_.

	.. php:method:: getCustomRowObject($n, $type)

		:param	int	$n: Index of the results row to return
		:param	string	$class_name: Class name for the resulting row
		:returns:	The requested row or NULL if it doesn't exist
		:rtype:	$type

		Returns the requested result row as an instance of the
		requested class.

	.. php:method:: dataSeek([$n = 0])

		:param	int	$n: Index of the results row to be returned next
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Moves the internal results row pointer to the desired offset.

		Usage: see `Result Helper Methods`_.

	.. php:method:: setRow($key[, $value = NULL])

		:param	mixed	$key: Column name or array of key/value pairs
		:param	mixed	$value: Value to assign to the column, $key is a single field name
		:rtype:	void

		Assigns a value to a particular column.

	.. php:method:: getNextRow([$type = 'object'])

		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	Next row of result set, or NULL if it doesn't exist
		:rtype:	mixed

		Returns the next row from the result set.

	.. php:method:: getPreviousRow([$type = 'object'])

		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	Previous row of result set, or NULL if it doesn't exist
		:rtype:	mixed

		Returns the previous row from the result set.

	.. php:method:: getFirstRow([$type = 'object'])

		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	First row of result set, or NULL if it doesn't exist
		:rtype:	mixed

		Returns the first row from the result set.

	.. php:method:: getLastRow([$type = 'object'])

		:param	string	$type: Type of the requested result - array, object, or class name
		:returns:	Last row of result set, or NULL if it doesn't exist
		:rtype:	mixed

		Returns the last row from the result set.

	.. php:method:: getFieldCount()

		:returns:	Number of fields in the result set
		:rtype:	int

		Returns the number of fields in the result set.

		Usage: see `Result Helper Methods`_.

    .. php:method:: getFieldNames()

		:returns:	Array of column names
		:rtype:	array

		Returns an array containing the field names in the
		result set.

	.. php:method:: getFieldData()

		:returns:	Array containing field meta-data
		:rtype:	array

		Generates an array of ``stdClass`` objects containing
		field meta-data.

	.. php:method:: freeResult()

		:rtype:	void

		Frees a result set.

		Usage: see `Result Helper Methods`_.
