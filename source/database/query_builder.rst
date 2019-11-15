###################
쿼리 빌더 클래스
###################

CodeIgniter를 사용하면 쿼리 빌더 클래스에 액세스 할 수 있습니다.
이 패턴을 사용하면 최소한의 스크립팅으로 데이터베이스에서 정보를 검색, 삽입 및 업데이트를 할 수 있습니다.
경우에 따라 데이터베이스 작업을 수행하는데 한두 줄의 코드만 사용해도 됩니다.
CodeIgniter에서는 데이터베이스의 각 테이블이 클래스 파일일 필요는 없습니다.
대신 더 간단한 인터페이스를 제공합니다.

단순성을 넘어서, Query Builder 기능을 사용하면 각 데이터베이스 어댑터별 조회 구문이 생성되는 이점이 있어 특정 데이터베이스에 종속되지 않는 어플리케이션을 작성할 수 있다는 것입니다.
또한 값이 시스템에 의해 자동으로 이스케이프되므로 보다 안전한 쿼리가 가능합니다.

.. contents::
    :local:
    :depth: 2

*************************
쿼리 빌더 로드
*************************

쿼리 빌더는 데이터베이스 연결의 ``table()`` 메소드를 통해 로드됩니다.
그러면 쿼리의 ``FROM`` 부분이 설정되고 Query Builder 클래스의 새 인스턴스가 반환됩니다.

::

    $db      = \Config\Database::connect();
    $builder = $db->table('users');

Query Builder는 특별히 클래스를 요청할 때만 메모리에 로드되므로 기본적으로 자원(resource)이 사용되지 않습니다.

************************
데이터 선택(select)
************************

다음 함수를 사용하면 SQL **SELECT** 문을 작성할 수 있습니다.

**$builder->get()**

select 쿼리를 실행하고 결과를 반환하며, 테이블에서 모든 레코드를 검색할 수 있습니다

::

    $builder = $db->table('mytable');
    $query   = $builder->get();  // Produces: SELECT * FROM mytable

첫 번째와 두 번째 매개 변수를 사용하여 limit과 offset을 설정할 수 있습니다

::

	$query = $builder->get(10, 20);

	// Executes: SELECT * FROM mytable LIMIT 20, 10
	// (in MySQL. Other databases have slightly different syntax)

위 함수는 $query 라는 변수에 할당되어 있으며 결과를 표시하는데 사용할 수 있습니다.

::

	$query = $builder->get();

	foreach ($query->getResult() as $row)
	{
		echo $row->title;
	}

결과 생성에 대한 자세한 내용은 :doc:`결과(result) 함수 <results>` 페이지를 참조하십시오.

**$builder->getCompiledSelect()**

**$builder->get()**\ 처럼 select 쿼리를 컴파일하지만 쿼리를 *실행*\ 하지는 않습니다.
이 메서드는 SQL 쿼리를 문자열로 반환합니다.

Example::

	$sql = $builder->getCompiledSelect();
	echo $sql;

	// Prints string: SELECT * FROM mytable

첫 번째 매개 변수를 사용하면 쿼리 빌더의 쿼리를 재설정할지 여부를 설정할 수 있습니다. (기본적으로 `$builder->get()`\ 을 사용할 때와 같이 재설정됩니다)

::

	echo $builder->limit(10,20)->getCompiledSelect(false);

	// Prints string: SELECT * FROM mytable LIMIT 20, 10
	// (in MySQL. Other databases have slightly different syntax)

	echo $builder->select('title, content, date')->getCompiledSelect();

	// Prints string: SELECT title, content, date FROM mytable LIMIT 20, 10

위 예제에서 두 번째 쿼리가 **$builder->from()**\ 을 사용하거나, 테이블 이름을 첫 번째 매개 변수에 전달하지 않았다는 것에 주목하십시오.
이렇게 사용 가능한 이유는 **$builder->get()**\ 을 사용하여 쿼리가 실행되지 않았기 때문이며, 값을 재설정해야 한다면 **$builder->resetQuery()**\ 를 사용해야 합니다.

**$builder->getWhere()**

db->where() 함수를 사용하는 대신 첫 번째 매개 변수에 "where"\ 절을 추가 할 수 있다는 점을 제외하고 ``get()`` 함수와 동일합니다.

::

	$query = $builder->getWhere(['id' => $id], $limit, $offset);

자세한 내용은 아래의 `where` 함수에 대해 읽으십시오.

**$builder->select()**

쿼리의 SELECT 부분을 쓸 수 있습니다

::

	$builder->select('title, content, date');
	$query = $builder->get();

	// Executes: SELECT title, content, date FROM mytable

.. note:: 테이블에서 모든 (\*)를 선택하는 경우 이 기능을 사용할 필요가 없습니다. 생략하면 CodeIgniter는 모든 필드를 선택하고 'SELECT \*'를 자동으로 추가합니다.

``$builder->select()``\ 는 두 번째 매개 변수를 옵션으로 허용하며, 이를 FALSE로 설정하면 CodeIgniter는 필드 또는 테이블 이름을 보호하지 않습니다.
필드의 자동 이스케이프가 필드를 손상시킬 수 있는 복합 선택문이 필요한 경우에 유용합니다.

::

	$builder->select('(SELECT SUM(payments.amount) FROM payments WHERE payments.invoice_id=4) AS amount_paid', FALSE);
	$query = $builder->get();

**$builder->selectMax()**

쿼리의 ``SELECT MAX(field)`` 부분을 작성합니다.
옵션으로 두 번째 매개 변수에 결과 필드의 이름을 전달하여 바꿀 수 있습니다.

::

	$builder->selectMax('age');
	$query = $builder->get();  // Produces: SELECT MAX(age) as age FROM mytable

	$builder->selectMax('age', 'member_age');
	$query = $builder->get(); // Produces: SELECT MAX(age) as member_age FROM mytable

**$builder->selectMin()**

쿼리의 "SELECT MIN(field)" 부분을 작성합니다.
selectMax()와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.

::

	$builder->selectMin('age');
	$query = $builder->get(); // Produces: SELECT MIN(age) as age FROM mytable

**$builder->selectAvg()**

쿼리의 "SELECT AVG(field)" 부분을 작성합니다.
selectMax()와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.

::

	$builder->selectAvg('age');
	$query = $builder->get(); // Produces: SELECT AVG(age) as age FROM mytable

**$builder->selectSum()**

쿼리의 "SELECT SUM(field)" 부분을 작성합니다.
selectMax()와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.

::

	$builder->selectSum('age');
	$query = $builder->get(); // Produces: SELECT SUM(age) as age FROM mytable

**$builder->selectCount()**

쿼리의 "SELECT COUNT(field)" 부분을 작성합니다.
selectMax()와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.


.. note:: 이 메소드는 ``groupBy()``\ 와 함께 사용할 때 특히 유용합니다. 카운트 결과는 일반적으로 ``countAll()`` 또는 ``countAllResults()``\ 를 참조하십시오.

::

	$builder->selectSum('age');
	$query = $builder->get(); // Produces: SELECT SUM(age) as age FROM mytable

**$builder->from()**

쿼리의 FROM 부분을 작성합니다.

::

	$builder->select('title, content, date');
	$builder->from('mytable');
	$query = $builder->get();  // Produces: SELECT title, content, date FROM mytable

.. note:: 앞에서 설명한 것처럼 쿼리의 FROM 부분은 $db->table() 함수에서 지정할 수 있습니다. from()에 대한 추가 호출은 쿼리의 FROM 부분에 더 많은 테이블을 추가합니다.

**$builder->join()**

쿼리의 JOIN 부분을 작성합니다.

::

    $builder->db->table('blog');
    $builder->select('*');
    $builder->join('comments', 'comments.id = blogs.id');
    $query = $builder->get();

    // Produces:
    // SELECT * FROM blogs JOIN comments ON comments.id = blogs.id

하나의 쿼리에 여러 개의 조인이 필요한 경우 여러번 함수를 호출할 수 있습니다.

특정 유형의 JOIN이 필요한 경우 함수의 세 번째 매개 변수를 통해 지정할 수 있습니다.
제공 옵션 : ``left``, ``right``, ``outer``, ``inner``, ``left outer``, ``right outer``.

::

	$builder->join('comments', 'comments.id = blogs.id', 'left');
	// Produces: LEFT JOIN comments ON comments.id = blogs.id

*************************
특정 데이터 찾기
*************************

**$builder->where()**

이 함수를 사용하면 네 가지 방법중 하나를 사용하여 **WHERE** 절을 설정할 수 있습니다:

.. note:: 이 함수에 전달된 모든 값은 자동으로 이스케이프되어 안전한 쿼리를 생성합니다.

#. **단순 key/value 방법:**

	::

		$builder->where('name', $name); // Produces: WHERE name = 'Joe'

	등호(=)가 추가되었습니다.

	여러 함수 호출을 사용하는 경우 AND와 함께 체인으로 연결됩니다:

	::

		$builder->where('name', $name);
		$builder->where('title', $title);
		$builder->where('status', $status);
		// WHERE name = 'Joe' AND title = 'boss' AND status = 'active'

#. **사용자 key/value 방법:**

	비교를 제어하기 위해 첫 번째 매개 변수에 연산자를 포함시킬 수 있습니다:

	::

		$builder->where('name !=', $name);
		$builder->where('id <', $id); // Produces: WHERE name != 'Joe' AND id < 45

#. **연관 배열 방법:**

	::

		$array = ['name' => $name, 'title' => $title, 'status' => $status];
		$builder->where($array);
		// Produces: WHERE name = 'Joe' AND title = 'boss' AND status = 'active'

	이 방법을 사용하여 사용자 연산자를 포함시킬 수도 있습니다:

	::

		$array = ['name !=' => $name, 'id <' => $id, 'date >' => $date];
		$builder->where($array);

#. **맞춤 문자열:**

	비교절을 직접 작성할 수 있습니다
	
	::

		$where = "name='Joe' AND status='boss' OR status='active'";
		$builder->where($where);

	``$builder->where()``\ 는 세 번째 매개 변수를 옵션으로 허용하며, FALSE로 설정하면 CodeIgniter는 필드 또는 테이블 이름을 보호하지 않습니다.

	::

		$builder->where('MATCH (field) AGAINST ("value")', NULL, FALSE);

#. **서브 쿼리:**

	익명 함수를 사용하여 서브 쿼리를 만들 수 있습니다.

	::

		$builder->where('advance_amount <', function(BaseBuilder $builder) {
			return $builder->select('MAX(advance_amount)', false)->from('orders')->where('id >', 2);
		});
		// Produces: WHERE "advance_amount" < (SELECT MAX(advance_amount) FROM "orders" WHERE "id" > 2)

**$builder->orWhere()**

이 함수는 여러 인스턴스가 OR로 결합된다는 점을 제외하고 위의 함수와 동일합니다.

::

	$builder->where('name !=', $name);
	$builder->orWhere('id >', $id);  // Produces: WHERE name != 'Joe' OR id > 50

**$builder->whereIn()**

적절한 경우 AND로 결합된 ``WHERE field IN ('item', 'item')`` SQL 쿼리를 생성합니다.

::

	$names = ['Frank', 'Todd', 'James'];
	$builder->whereIn('username', $names);
	// Produces: WHERE username IN ('Frank', 'Todd', 'James')

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

::

	$builder->whereIn('id', function(BaseBuilder $builder) {
		return $builder->select('job_id')->from('users_jobs')->where('user_id', 3);
	});
	// Produces: WHERE "id" IN (SELECT "job_id" FROM "users_jobs" WHERE "user_id" = 3)

**$builder->orWhereIn()**

적절한 경우 OR로 결합된 ``WHERE field IN ('item', 'item')`` SQL 쿼리를 생성합니다.

::

	$names = ['Frank', 'Todd', 'James'];
	$builder->orWhereIn('username', $names);
	// Produces: OR username IN ('Frank', 'Todd', 'James')

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

::

	$builder->orWhereIn('id', function(BaseBuilder $builder) {
		return $builder->select('job_id')->from('users_jobs')->where('user_id', 3);
	});

	// Produces: OR "id" IN (SELECT "job_id" FROM "users_jobs" WHERE "user_id" = 3)

**$builder->whereNotIn()**

적절한 경우 AND로 결합된 ``WHERE field NOT IN ('item', 'item')`` SQL 쿼리를 생성합니다.

::

	$names = ['Frank', 'Todd', 'James'];
	$builder->whereNotIn('username', $names);
	// Produces: WHERE username NOT IN ('Frank', 'Todd', 'James')

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

::

	$builder->whereNotIn('id', function(BaseBuilder $builder) {
		return $builder->select('job_id')->from('users_jobs')->where('user_id', 3);
	});

	// Produces: WHERE "id" NOT IN (SELECT "job_id" FROM "users_jobs" WHERE "user_id" = 3)


**$builder->orWhereNotIn()**

적절한 경우 OR로 결합된 ``WHERE field NOT IN ('item', 'item')`` SQL 쿼리를 생성합니다.

::

	$names = ['Frank', 'Todd', 'James'];
	$builder->orWhereNotIn('username', $names);
	// Produces: OR username NOT IN ('Frank', 'Todd', 'James')

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

::

	$builder->orWhereNotIn('id', function(BaseBuilder $builder) {
		return $builder->select('job_id')->from('users_jobs')->where('user_id', 3);
	});

	// Produces: OR "id" NOT IN (SELECT "job_id" FROM "users_jobs" WHERE "user_id" = 3)

************************
유사한 데이터 찾기
************************

**$builder->like()**

This method enables you to generate **LIKE** clauses, useful for doing searches.

.. note:: All values passed to this method are escaped automatically.

.. note:: All ``like*`` method variations can be forced to perform case-insensitive searches by passing
        a fifth parameter of ``true`` to the method. This will use platform-specific features where available
        otherwise, will force the values to be lowercase, i.e. ``WHERE LOWER(column) LIKE '%search%'``. This
        may require indexes to be made for ``LOWER(column)`` instead of ``column`` to be effective.

#. **Simple key/value method:**

	::

		$builder->like('title', 'match');
		// Produces: WHERE `title` LIKE '%match%' ESCAPE '!'

	If you use multiple method calls they will be chained together with
	AND between them::

		$builder->like('title', 'match');
		$builder->like('body', 'match');
		// WHERE `title` LIKE '%match%' ESCAPE '!' AND  `body` LIKE '%match% ESCAPE '!'

	If you want to control where the wildcard (%) is placed, you can use
	an optional third argument. Your options are 'before', 'after' and
	'both' (which is the default).

	::

		$builder->like('title', 'match', 'before');	// Produces: WHERE `title` LIKE '%match' ESCAPE '!'
		$builder->like('title', 'match', 'after');	// Produces: WHERE `title` LIKE 'match%' ESCAPE '!'
		$builder->like('title', 'match', 'both');	// Produces: WHERE `title` LIKE '%match%' ESCAPE '!'

#. **Associative array method:**

	::

		$array = ['title' => $match, 'page1' => $match, 'page2' => $match];
		$builder->like($array);
		// WHERE `title` LIKE '%match%' ESCAPE '!' AND  `page1` LIKE '%match%' ESCAPE '!' AND  `page2` LIKE '%match%' ESCAPE '!'

**$builder->orLike()**

This method is identical to the one above, except that multiple
instances are joined by OR::

	$builder->like('title', 'match'); $builder->orLike('body', $match);
	// WHERE `title` LIKE '%match%' ESCAPE '!' OR  `body` LIKE '%match%' ESCAPE '!'

**$builder->notLike()**

This method is identical to ``like()``, except that it generates
NOT LIKE statements::

	$builder->notLike('title', 'match');	// WHERE `title` NOT LIKE '%match% ESCAPE '!'

**$builder->orNotLike()**

This method is identical to ``notLike()``, except that multiple
instances are joined by OR::

	$builder->like('title', 'match');
	$builder->orNotLike('body', 'match');
	// WHERE `title` LIKE '%match% OR  `body` NOT LIKE '%match%' ESCAPE '!'

**$builder->groupBy()**

Permits you to write the GROUP BY portion of your query::

	$builder->groupBy("title"); // Produces: GROUP BY title

You can also pass an array of multiple values as well::

	$builder->groupBy(["title", "date"]);  // Produces: GROUP BY title, date

**$builder->distinct()**

Adds the "DISTINCT" keyword to a query

::

	$builder->distinct();
	$builder->get(); // Produces: SELECT DISTINCT * FROM mytable

**$builder->having()**

Permits you to write the HAVING portion of your query. There are 2
possible syntaxes, 1 argument or 2::

	$builder->having('user_id = 45');  // Produces: HAVING user_id = 45
	$builder->having('user_id',  45);  // Produces: HAVING user_id = 45

You can also pass an array of multiple values as well::

	$builder->having(['title =' => 'My Title', 'id <' => $id]);
	// Produces: HAVING title = 'My Title', id < 45

If you are using a database that CodeIgniter escapes queries for, you
can prevent escaping content by passing an optional third argument, and
setting it to FALSE.

::

	$builder->having('user_id',  45);  // Produces: HAVING `user_id` = 45 in some databases such as MySQL
	$builder->having('user_id',  45, FALSE);  // Produces: HAVING user_id = 45

**$builder->orHaving()**

Identical to having(), only separates multiple clauses with "OR".

**$builder->havingIn()**

Generates a HAVING field IN ('item', 'item') SQL query joined with AND if
appropriate

    ::

        $groups = [1, 2, 3];
        $builder->havingIn('group_id', $groups);
        // Produces: HAVING group_id IN (1, 2, 3)

You can use subqueries instead of an array of values.

    ::

        $builder->havingIn('id', function(BaseBuilder $builder) {
            return $builder->select('user_id')->from('users_jobs')->where('group_id', 3);
        });
        // Produces: HAVING "id" IN (SELECT "user_id" FROM "users_jobs" WHERE "group_id" = 3)

**$builder->orHavingIn()**

Generates a HAVING field IN ('item', 'item') SQL query joined with OR if
appropriate

    ::

        $groups = [1, 2, 3];
        $builder->orHavingIn('group_id', $groups);
        // Produces: OR group_id IN (1, 2, 3)

You can use subqueries instead of an array of values.

    ::

        $builder->orHavingIn('id', function(BaseBuilder $builder) {
            return $builder->select('user_id')->from('users_jobs')->where('group_id', 3);
        });

        // Produces: OR "id" IN (SELECT "user_id" FROM "users_jobs" WHERE "group_id" = 3)

**$builder->havingNotIn()**

Generates a HAVING field NOT IN ('item', 'item') SQL query joined with
AND if appropriate

    ::

        $groups = [1, 2, 3];
        $builder->havingNotIn('group_id', $groups);
        // Produces: HAVING group_id NOT IN (1, 2, 3)

You can use subqueries instead of an array of values.

    ::

        $builder->havingNotIn('id', function(BaseBuilder $builder) {
            return $builder->select('user_id')->from('users_jobs')->where('group_id', 3);
        });

        // Produces: HAVING "id" NOT IN (SELECT "user_id" FROM "users_jobs" WHERE "group_id" = 3)


**$builder->orHavingNotIn()**

Generates a HAVING field NOT IN ('item', 'item') SQL query joined with OR
if appropriate

    ::

        $groups = [1, 2, 3];
        $builder->havingNotIn('group_id', $groups);
        // Produces: OR group_id NOT IN (1, 2, 3)

You can use subqueries instead of an array of values.

    ::

        $builder->orHavingNotIn('id', function(BaseBuilder $builder) {
            return $builder->select('user_id')->from('users_jobs')->where('group_id', 3);
        });

        // Produces: OR "id" NOT IN (SELECT "user_id" FROM "users_jobs" WHERE "group_id" = 3)

**$builder->havingLike()**

This method enables you to generate **LIKE** clauses for HAVING part or the query, useful for doing
searches.

.. note:: All values passed to this method are escaped automatically.

.. note:: All ``havingLike*`` method variations can be forced to perform case-insensitive searches by passing
        a fifth parameter of ``true`` to the method. This will use platform-specific features where available
        otherwise, will force the values to be lowercase, i.e. ``HAVING LOWER(column) LIKE '%search%'``. This
        may require indexes to be made for ``LOWER(column)`` instead of ``column`` to be effective.

#. **Simple key/value method:**

	::

		$builder->havingLike('title', 'match');
		// Produces: HAVING `title` LIKE '%match%' ESCAPE '!'

	If you use multiple method calls they will be chained together with
	AND between them::

		$builder->havingLike('title', 'match');
		$builder->havingLike('body', 'match');
		// HAVING `title` LIKE '%match%' ESCAPE '!' AND  `body` LIKE '%match% ESCAPE '!'

	If you want to control where the wildcard (%) is placed, you can use
	an optional third argument. Your options are 'before', 'after' and
	'both' (which is the default).

	::

		$builder->havingLike('title', 'match', 'before');	// Produces: HAVING `title` LIKE '%match' ESCAPE '!'
		$builder->havingLike('title', 'match', 'after');	// Produces: HAVING `title` LIKE 'match%' ESCAPE '!'
		$builder->havingLike('title', 'match', 'both');	// Produces: HAVING `title` LIKE '%match%' ESCAPE '!'

#. **Associative array method:**

	::

		$array = ['title' => $match, 'page1' => $match, 'page2' => $match];
		$builder->havingLike($array);
		// HAVING `title` LIKE '%match%' ESCAPE '!' AND  `page1` LIKE '%match%' ESCAPE '!' AND  `page2` LIKE '%match%' ESCAPE '!'

**$builder->orHavingLike()**

This method is identical to the one above, except that multiple
instances are joined by OR::

	$builder->havingLike('title', 'match'); $builder->orHavingLike('body', $match);
	// HAVING `title` LIKE '%match%' ESCAPE '!' OR  `body` LIKE '%match%' ESCAPE '!'

**$builder->notHavingLike()**

This method is identical to ``havingLike()``, except that it generates
NOT LIKE statements::

	$builder->notHavingLike('title', 'match');	// HAVING `title` NOT LIKE '%match% ESCAPE '!'

**$builder->orNotHavingLike()**

This method is identical to ``notHavingLike()``, except that multiple
instances are joined by OR::

	$builder->havingLike('title', 'match');
	$builder->orNotHavingLike('body', 'match');
	// HAVING `title` LIKE '%match% OR  `body` NOT LIKE '%match%' ESCAPE '!'

****************
Ordering results
****************

**$builder->orderBy()**

Lets you set an ORDER BY clause.

The first parameter contains the name of the column you would like to order by.

The second parameter lets you set the direction of the result.
Options are **ASC**, **DESC** AND **RANDOM**.

::

	$builder->orderBy('title', 'DESC');
	// Produces: ORDER BY `title` DESC

You can also pass your own string in the first parameter::

	$builder->orderBy('title DESC, name ASC');
	// Produces: ORDER BY `title` DESC, `name` ASC

Or multiple function calls can be made if you need multiple fields.

::

	$builder->orderBy('title', 'DESC');
	$builder->orderBy('name', 'ASC');
	// Produces: ORDER BY `title` DESC, `name` ASC

If you choose the **RANDOM** direction option, then the first parameters will
be ignored, unless you specify a numeric seed value.

::

	$builder->orderBy('title', 'RANDOM');
	// Produces: ORDER BY RAND()

	$builder->orderBy(42, 'RANDOM');
	// Produces: ORDER BY RAND(42)

.. note:: Random ordering is not currently supported in Oracle and
	will default to ASC instead.

****************************
Limiting or Counting Results
****************************

**$builder->limit()**

Lets you limit the number of rows you would like returned by the query::

	$builder->limit(10);  // Produces: LIMIT 10

The second parameter lets you set a result offset.

::

	$builder->limit(10, 20);  // Produces: LIMIT 20, 10 (in MySQL. Other databases have slightly different syntax)


**$builder->countAllResults()**

Permits you to determine the number of rows in a particular Query
Builder query. Queries will accept Query Builder restrictors such as
``where()``, ``orWhere()``, ``like()``, ``orLike()``, etc. Example::

	echo $builder->countAllResults();  // Produces an integer, like 25
	$builder->like('title', 'match');
	$builder->from('my_table');
	echo $builder->countAllResults(); // Produces an integer, like 17

However, this method also resets any field values that you may have passed
to ``select()``. If you need to keep them, you can pass ``FALSE`` as the
first parameter.

	echo $builder->countAllResults(false); // Produces an integer, like 17

**$builder->countAll()**

Permits you to determine the number of rows in a particular table.
Example::

	echo $builder->countAll();  // Produces an integer, like 25

As is in countAllResult method, this method resets any field values that you may have passed
to ``select()`` as well. If you need to keep them, you can pass ``FALSE`` as the
first parameter.

**************
Query grouping
**************

Query grouping allows you to create groups of WHERE clauses by enclosing them in parentheses. This will allow
you to create queries with complex WHERE clauses. Nested groups are supported. Example::

	$builder->select('*')->from('my_table')
		->groupStart()
			->where('a', 'a')
			->orGroupStart()
				->where('b', 'b')
				->where('c', 'c')
			->groupEnd()
		->groupEnd()
		->where('d', 'd')
	->get();

	// Generates:
	// SELECT * FROM (`my_table`) WHERE ( `a` = 'a' OR ( `b` = 'b' AND `c` = 'c' ) ) AND `d` = 'd'

.. note:: groups need to be balanced, make sure every groupStart() is matched by a groupEnd().

**$builder->groupStart()**

Starts a new group by adding an opening parenthesis to the WHERE clause of the query.

**$builder->orGroupStart()**

Starts a new group by adding an opening parenthesis to the WHERE clause of the query, prefixing it with 'OR'.

**$builder->notGroupStart()**

Starts a new group by adding an opening parenthesis to the WHERE clause of the query, prefixing it with 'NOT'.

**$builder->orNotGroupStart()**

Starts a new group by adding an opening parenthesis to the WHERE clause of the query, prefixing it with 'OR NOT'.

**$builder->groupEnd()**

Ends the current group by adding a closing parenthesis to the WHERE clause of the query.

**$builder->groupHavingStart()**

Starts a new group by adding an opening parenthesis to the HAVING clause of the query.

**$builder->orGroupHavingStart()**

Starts a new group by adding an opening parenthesis to the HAVING clause of the query, prefixing it with 'OR'.

**$builder->notGroupHavingStart()**

Starts a new group by adding an opening parenthesis to the HAVING clause of the query, prefixing it with 'NOT'.

**$builder->orNotGroupHavingStart()**

Starts a new group by adding an opening parenthesis to the HAVING clause of the query, prefixing it with 'OR NOT'.

**$builder->groupHavingEnd()**

Ends the current group by adding a closing parenthesis to the HAVING clause of the query.

**************
Inserting Data
**************

**$builder->insert()**

Generates an insert string based on the data you supply, and runs the
query. You can either pass an **array** or an **object** to the
function. Here is an example using an array::

	$data = [
		'title' => 'My title',
		'name'  => 'My Name',
		'date'  => 'My date'
	];

	$builder->insert($data);
	// Produces: INSERT INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date')

The first parameter is an associative array of values.

Here is an example using an object::

	/*
	class Myclass {
		public $title   = 'My Title';
		public $content = 'My Content';
		public $date    = 'My Date';
	}
	*/

	$object = new Myclass;
	$builder->insert($object);
	// Produces: INSERT INTO mytable (title, content, date) VALUES ('My Title', 'My Content', 'My Date')

The first parameter is an object.

.. note:: All values are escaped automatically producing safer queries.

**$builder->getCompiledInsert()**

Compiles the insertion query just like $builder->insert() but does not
*run* the query. This method simply returns the SQL query as a string.

Example::

	$data = [
		'title' => 'My title',
		'name'  => 'My Name',
		'date'  => 'My date'
	];

	$sql = $builder->set($data)->getCompiledInsert('mytable');
	echo $sql;

	// Produces string: INSERT INTO mytable (`title`, `name`, `date`) VALUES ('My title', 'My name', 'My date')

The second parameter enables you to set whether or not the query builder query
will be reset (by default it will be--just like $builder->insert())::

	echo $builder->set('title', 'My Title')->getCompiledInsert('mytable', FALSE);

	// Produces string: INSERT INTO mytable (`title`) VALUES ('My Title')

	echo $builder->set('content', 'My Content')->getCompiledInsert();

	// Produces string: INSERT INTO mytable (`title`, `content`) VALUES ('My Title', 'My Content')

The key thing to notice in the above example is that the second query did not
utilize `$builder->from()` nor did it pass a table name into the first
parameter. The reason this worked is that the query has not been executed
using `$builder->insert()` which resets values or reset directly using
`$builder->resetQuery()`.

.. note:: This method doesn't work for batched inserts.

**$builder->insertBatch()**

Generates an insert string based on the data you supply, and runs the
query. You can either pass an **array** or an **object** to the
function. Here is an example using an array::

	$data = [
		[
			'title' => 'My title',
			'name'  => 'My Name',
			'date'  => 'My date'
		],
		[
			'title' => 'Another title',
			'name'  => 'Another Name',
			'date'  => 'Another date'
		]
	];

	$builder->insertBatch($data);
	// Produces: INSERT INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date'),  ('Another title', 'Another name', 'Another date')

The first parameter is an associative array of values.

.. note:: All values are escaped automatically producing safer queries.

*************
Updating Data
*************

**$builder->replace()**

This method executes a REPLACE statement, which is basically the SQL
standard for (optional) DELETE + INSERT, using *PRIMARY* and *UNIQUE*
keys as the determining factor.
In our case, it will save you from the need to implement complex
logics with different combinations of  ``select()``, ``update()``,
``delete()`` and ``insert()`` calls.

Example::

	$data = [
		'title' => 'My title',
		'name'  => 'My Name',
		'date'  => 'My date'
	];

	$builder->replace($data);

	// Executes: REPLACE INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date')

In the above example, if we assume that the *title* field is our primary
key, then if a row containing 'My title' as the *title* value, that row
will be deleted with our new row data replacing it.

Usage of the ``set()`` method is also allowed and all fields are
automatically escaped, just like with ``insert()``.

**$builder->set()**

This function enables you to set values for inserts or updates.

**It can be used instead of passing a data array directly to the insert
or update functions:**

::

	$builder->set('name', $name);
	$builder->insert();  // Produces: INSERT INTO mytable (`name`) VALUES ('{$name}')

If you use multiple function called they will be assembled properly
based on whether you are doing an insert or an update::

	$builder->set('name', $name);
	$builder->set('title', $title);
	$builder->set('status', $status);
	$builder->insert();

**set()** will also accept an optional third parameter (``$escape``), that
will prevent data from being escaped if set to FALSE. To illustrate the
difference, here is ``set()`` used both with and without the escape
parameter.

::

	$builder->set('field', 'field+1', FALSE);
	$builder->where('id', 2);
	$builder->update(); // gives UPDATE mytable SET field = field+1 WHERE `id` = 2

	$builder->set('field', 'field+1');
	$builder->where('id', 2);
	$builder->update(); // gives UPDATE `mytable` SET `field` = 'field+1' WHERE `id` = 2

You can also pass an associative array to this function::

	$array = [
		'name'   => $name,
		'title'  => $title,
		'status' => $status
	];

	$builder->set($array);
	$builder->insert();

Or an object::

	/*
	class Myclass {
		public $title   = 'My Title';
		public $content = 'My Content';
		public $date    = 'My Date';
	}
	*/

	$object = new Myclass;
	$builder->set($object);
	$builder->insert();

**$builder->update()**

Generates an update string and runs the query based on the data you
supply. You can pass an **array** or an **object** to the function. Here
is an example using an array::

	$data = [
		'title' => $title,
		'name'  => $name,
		'date'  => $date
	];

	$builder->where('id', $id);
	$builder->update($data);
	// Produces:
	//
	//	UPDATE mytable
	//	SET title = '{$title}', name = '{$name}', date = '{$date}'
	//	WHERE id = $id

Or you can supply an object::

	/*
	class Myclass {
		public $title   = 'My Title';
		public $content = 'My Content';
		public $date    = 'My Date';
	}
	*/

	$object = new Myclass;
	$builder->where('id', $id);
	$builder->update($object);
	// Produces:
	//
	// UPDATE `mytable`
	// SET `title` = '{$title}', `name` = '{$name}', `date` = '{$date}'
	// WHERE id = `$id`

.. note:: All values are escaped automatically producing safer queries.

You'll notice the use of the $builder->where() function, enabling you
to set the WHERE clause. You can optionally pass this information
directly into the update function as a string::

	$builder->update($data, "id = 4");

Or as an array::

	$builder->update($data, ['id' => $id]);

You may also use the $builder->set() function described above when
performing updates.

**$builder->updateBatch()**

Generates an update string based on the data you supply, and runs the query.
You can either pass an **array** or an **object** to the function.
Here is an example using an array::

	$data = [
	   [
	      'title' => 'My title' ,
	      'name'  => 'My Name 2' ,
	      'date'  => 'My date 2'
	   ],
	   [
	      'title' => 'Another title' ,
	      'name'  => 'Another Name 2' ,
	      'date'  => 'Another date 2'
	   ]
	];

	$builder->updateBatch($data, 'title');

	// Produces:
	// UPDATE `mytable` SET `name` = CASE
	// WHEN `title` = 'My title' THEN 'My Name 2'
	// WHEN `title` = 'Another title' THEN 'Another Name 2'
	// ELSE `name` END,
	// `date` = CASE
	// WHEN `title` = 'My title' THEN 'My date 2'
	// WHEN `title` = 'Another title' THEN 'Another date 2'
	// ELSE `date` END
	// WHERE `title` IN ('My title','Another title')

The first parameter is an associative array of values, the second parameter is the where key.

.. note:: All values are escaped automatically producing safer queries.

.. note:: ``affectedRows()`` won't give you proper results with this method,
	due to the very nature of how it works. Instead, ``updateBatch()``
	returns the number of rows affected.

**$builder->getCompiledUpdate()**

This works exactly the same way as ``$builder->getCompiledInsert()`` except
that it produces an UPDATE SQL string instead of an INSERT SQL string.

For more information view documentation for `$builder->getCompiledInsert()`.

.. note:: This method doesn't work for batched updates.

*************
Deleting Data
*************

**$builder->delete()**

Generates a delete SQL string and runs the query.

::

	$builder->delete(['id' => $id]);  // Produces: // DELETE FROM mytable  // WHERE id = $id

The first parameter is the where clause.
You can also use the where() or or_where() functions instead of passing
the data to the first parameter of the function::

	$builder->where('id', $id);
	$builder->delete();

	// Produces:
	// DELETE FROM mytable
	// WHERE id = $id

If you want to delete all data from a table, you can use the truncate()
function, or empty_table().

**$builder->emptyTable()**

Generates a delete SQL string and runs the
query::

	  $builder->emptyTable('mytable'); // Produces: DELETE FROM mytable

**$builder->truncate()**

Generates a truncate SQL string and runs the query.

::

	$builder->truncate();

	// Produce:
	// TRUNCATE mytable

.. note:: If the TRUNCATE command isn't available, truncate() will
	execute as "DELETE FROM table".

**$builder->getCompiledDelete()**

This works exactly the same way as ``$builder->getCompiledInsert()`` except
that it produces a DELETE SQL string instead of an INSERT SQL string.

For more information view documentation for $builder->getCompiledInsert().

***************
Method Chaining
***************

Method chaining allows you to simplify your syntax by connecting
multiple functions. Consider this example::

	$query = $builder->select('title')
			 ->where('id', $id)
			 ->limit(10, 20)
			 ->get();

.. _ar-caching:

***********************
Resetting Query Builder
***********************

**$builder->resetQuery()**

Resetting Query Builder allows you to start fresh with your query without
executing it first using a method like $builder->get() or $builder->insert().

This is useful in situations where you are using Query Builder to generate SQL
(ex. ``$builder->getCompiledSelect()``) but then choose to, for instance,
run the query::

    // Note that the second parameter of the get_compiled_select method is FALSE
    $sql = $builder->select(['field1','field2'])
                   ->where('field3',5)
                   ->getCompiledSelect(false);

    // ...
    // Do something crazy with the SQL code... like add it to a cron script for
    // later execution or something...
    // ...

    $data = $builder->get()->getResultArray();

    // Would execute and return an array of results of the following query:
    // SELECT field1, field1 from mytable where field3 = 5;

***************
Class Reference
***************

.. php:class:: \CodeIgniter\Database\BaseBuilder

	.. php:method:: resetQuery()

		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Resets the current Query Builder state. Useful when you want
		to build a query that can be canceled under certain conditions.

	.. php:method:: countAllResults([$reset = TRUE])

		:param	bool	$reset: Whether to reset values for SELECTs
		:returns:	Number of rows in the query result
		:rtype:	int

		Generates a platform-specific query string that counts
		all records returned by an Query Builder query.

	.. php:method:: countAll([$reset = TRUE])

		:param	bool	$reset: Whether to reset values for SELECTs
		:returns:	Number of rows in the query result
		:rtype:	int

		Generates a platform-specific query string that counts
		all records returned by an Query Builder query.

	.. php:method:: get([$limit = NULL[, $offset = NULL[, $reset = TRUE]]]])

		:param	int	$limit: The LIMIT clause
		:param	int	$offset: The OFFSET clause
		:param 	bool $reset: Do we want to clear query builder values?
		:returns:	\CodeIgniter\Database\ResultInterface instance (method chaining)
		:rtype:	\CodeIgniter\Database\ResultInterface

		Compiles and runs SELECT statement based on the already
		called Query Builder methods.

	.. php:method:: getWhere([$where = NULL[, $limit = NULL[, $offset = NULL[, $reset = TRUE]]]]])

		:param	string	$where: The WHERE clause
		:param	int	$limit: The LIMIT clause
		:param	int	$offset: The OFFSET clause
		:param 	bool $reset: Do we want to clear query builder values?
		:returns:	\CodeIgniter\Database\ResultInterface instance (method chaining)
		:rtype:	\CodeIgniter\Database\ResultInterface

		Same as ``get()``, but also allows the WHERE to be added directly.

	.. php:method:: select([$select = '*'[, $escape = NULL]])

		:param	string	$select: The SELECT portion of a query
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a SELECT clause to a query.

	.. php:method:: selectAvg([$select = ''[, $alias = '']])

		:param	string	$select: Field to compute the average of
		:param	string	$alias: Alias for the resulting value name
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a SELECT AVG(field) clause to a query.

	.. php:method:: selectMax([$select = ''[, $alias = '']])

		:param	string	$select: Field to compute the maximum of
		:param	string	$alias: Alias for the resulting value name
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a SELECT MAX(field) clause to a query.

	.. php:method:: selectMin([$select = ''[, $alias = '']])

		:param	string	$select: Field to compute the minimum of
		:param	string	$alias: Alias for the resulting value name
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a SELECT MIN(field) clause to a query.

	.. php:method:: selectSum([$select = ''[, $alias = '']])

		:param	string	$select: Field to compute the sum of
		:param	string	$alias: Alias for the resulting value name
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a SELECT SUM(field) clause to a query.

	.. php:method:: selectCount([$select = ''[, $alias = '']])

		:param	string	$select: Field to compute the average of
		:param	string	$alias: Alias for the resulting value name
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a SELECT COUNT(field) clause to a query.

	.. php:method:: distinct([$val = TRUE])

		:param	bool	$val: Desired value of the "distinct" flag
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Sets a flag which tells the query builder to add
		a DISTINCT clause to the SELECT portion of the query.

	.. php:method:: from($from[, $overwrite = FALSE])

                :param	mixed	$from: Table name(s); string or array
                :param	bool	$overwrite: Should we remove the first table existing?
                :returns:	BaseBuilder instance (method chaining)
                :rtype:	BaseBuilder

		Specifies the FROM clause of a query.

	.. php:method:: join($table, $cond[, $type = ''[, $escape = NULL]])

		:param	string	$table: Table name to join
		:param	string	$cond: The JOIN ON condition
		:param	string	$type: The JOIN type
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a JOIN clause to a query.

	.. php:method:: where($key[, $value = NULL[, $escape = NULL]])

		:param	mixed	$key: Name of field to compare, or associative array
		:param	mixed	$value: If a single key, compared to this value
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance
		:rtype:	object

		Generates the WHERE portion of the query.
                Separates multiple calls with 'AND'.

	.. php:method:: orWhere($key[, $value = NULL[, $escape = NULL]])

		:param	mixed	$key: Name of field to compare, or associative array
		:param	mixed	$value: If a single key, compared to this value
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance
		:rtype:	object

		Generates the WHERE portion of the query.
                Separates multiple calls with 'OR'.

	.. php:method:: orWhereIn([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	        $key: The field to search
		:param	array|Closure   $values: Array of target values, or anonymous function for subquery
		:param	bool	        $escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance
		:rtype:	object

		Generates a WHERE field IN('item', 'item') SQL query,
                joined with 'OR' if appropriate.

	.. php:method:: orWhereNotIn([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	        $key: The field to search
		:param	array|Closure   $values: Array of target values, or anonymous function for subquery
		:param	bool	        $escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance
		:rtype:	object

		Generates a WHERE field NOT IN('item', 'item') SQL query,
                joined with 'OR' if appropriate.

	.. php:method:: whereIn([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	        $key: Name of field to examine
		:param	array|Closure   $values: Array of target values, or anonymous function for subquery
		:param	bool            $escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance
		:rtype:	object

		Generates a WHERE field IN('item', 'item') SQL query,
                joined with 'AND' if appropriate.

	.. php:method:: whereNotIn([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	        $key: Name of field to examine
		:param	array|Closure   $values: Array of target values, or anonymous function for subquery
		:param	bool	        $escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance
		:rtype:	object

		Generates a WHERE field NOT IN('item', 'item') SQL query,
                joined with 'AND' if appropriate.

	.. php:method:: groupStart()

		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Starts a group expression, using ANDs for the conditions inside it.

	.. php:method:: orGroupStart()

		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Starts a group expression, using ORs for the conditions inside it.

	.. php:method:: notGroupStart()

		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Starts a group expression, using AND NOTs for the conditions inside it.

	.. php:method:: orNotGroupStart()

		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Starts a group expression, using OR NOTs for the conditions inside it.

	.. php:method:: groupEnd()

		:returns:	BaseBuilder instance
		:rtype:	object

		Ends a group expression.

	.. php:method:: like($field[, $match = ''[, $side = 'both'[, $escape = NULL[, $insensitiveSearch = FALSE]]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:param	bool    $insensitiveSearch: Whether to force a case-insensitive search
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a LIKE clause to a query, separating multiple calls with AND.

	.. php:method:: orLike($field[, $match = ''[, $side = 'both'[, $escape = NULL[, $insensitiveSearch = FALSE]]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:param	bool    $insensitiveSearch: Whether to force a case-insensitive search
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a LIKE clause to a query, separating multiple class with OR.

	.. php:method:: notLike($field[, $match = ''[, $side = 'both'[, $escape = NULL[, $insensitiveSearch = FALSE]]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:param	bool    $insensitiveSearch: Whether to force a case-insensitive search
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a NOT LIKE clause to a query, separating multiple calls with AND.

	.. php:method:: orNotLike($field[, $match = ''[, $side = 'both'[, $escape = NULL[, $insensitiveSearch = FALSE]]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:param	bool    $insensitiveSearch: Whether to force a case-insensitive search
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a NOT LIKE clause to a query, separating multiple calls with OR.

	.. php:method:: having($key[, $value = NULL[, $escape = NULL]])

		:param	mixed	$key: Identifier (string) or associative array of field/value pairs
		:param	string	$value: Value sought if $key is an identifier
		:param	string	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a HAVING clause to a query, separating multiple calls with AND.

	.. php:method:: orHaving($key[, $value = NULL[, $escape = NULL]])

		:param	mixed	$key: Identifier (string) or associative array of field/value pairs
		:param	string	$value: Value sought if $key is an identifier
		:param	string	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a HAVING clause to a query, separating multiple calls with OR.

	.. php:method:: orHavingIn([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	        $key: The field to search
		:param	array|Closure   $values: Array of target values, or anonymous function for subquery
		:param	bool	        $escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance
		:rtype:	object

		Generates a HAVING field IN('item', 'item') SQL query,
                joined with 'OR' if appropriate.

	.. php:method:: orHavingNotIn([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	        $key: The field to search
		:param	array|Closure   $values: Array of target values, or anonymous function for subquery
		:param	bool	        $escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance
		:rtype:	object

		Generates a HAVING field NOT IN('item', 'item') SQL query,
                joined with 'OR' if appropriate.

	.. php:method:: havingIn([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	        $key: Name of field to examine
		:param	array|Closure   $values: Array of target values, or anonymous function for subquery
		:param	bool            $escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance
		:rtype:	object

		Generates a HAVING field IN('item', 'item') SQL query,
                joined with 'AND' if appropriate.

	.. php:method:: havingNotIn([$key = NULL[, $values = NULL[, $escape = NULL]]])

		:param	string	        $key: Name of field to examine
		:param	array|Closure   $values: Array of target values, or anonymous function for subquery
		:param	bool	        $escape: Whether to escape values and identifiers
		:param	bool            $insensitiveSearch: Whether to force a case-insensitive search
		:returns:	BaseBuilder instance
		:rtype:	object

		Generates a HAVING field NOT IN('item', 'item') SQL query,
                joined with 'AND' if appropriate.

	.. php:method:: havingLike($field[, $match = ''[, $side = 'both'[, $escape = NULL[, $insensitiveSearch = FALSE]]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:param	bool    $insensitiveSearch: Whether to force a case-insensitive search
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a LIKE clause to a HAVING part of the query, separating multiple calls with AND.

	.. php:method:: orHavingLike($field[, $match = ''[, $side = 'both'[, $escape = NULL[, $insensitiveSearch = FALSE]]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:param	bool    $insensitiveSearch: Whether to force a case-insensitive search
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a LIKE clause to a HAVING part of the query, separating multiple class with OR.

	.. php:method:: notHavingLike($field[, $match = ''[, $side = 'both'[, $escape = NULL[, $insensitiveSearch = FALSE]]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:param	bool    $insensitiveSearch: Whether to force a case-insensitive search
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a NOT LIKE clause to a HAVING part of the query, separating multiple calls with AND.

	.. php:method:: orNotHavingLike($field[, $match = ''[, $side = 'both'[, $escape = NULL[, $insensitiveSearch = FALSE]]]])

		:param	string	$field: Field name
		:param	string	$match: Text portion to match
		:param	string	$side: Which side of the expression to put the '%' wildcard on
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a NOT LIKE clause to a HAVING part of the query, separating multiple calls with OR.

	.. php:method:: havingGroupStart()

		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Starts a group expression for HAVING clause, using ANDs for the conditions inside it.

	.. php:method:: orHavingGroupStart()

		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Starts a group expression for HAVING clause, using ORs for the conditions inside it.

	.. php:method:: notHavingGroupStart()

		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Starts a group expression for HAVING clause, using AND NOTs for the conditions inside it.

	.. php:method:: orNotHavingGroupStart()

		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Starts a group expression for HAVING clause, using OR NOTs for the conditions inside it.

	.. php:method:: havingGroupEnd()

		:returns:	BaseBuilder instance
		:rtype:	object

		Ends a group expression for HAVING clause.

	.. php:method:: groupBy($by[, $escape = NULL])

		:param	mixed	$by: Field(s) to group by; string or array
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds a GROUP BY clause to a query.

	.. php:method:: orderBy($orderby[, $direction = ''[, $escape = NULL]])

		:param	string	$orderby: Field to order by
		:param	string	$direction: The order requested - ASC, DESC or random
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds an ORDER BY clause to a query.

	.. php:method:: limit($value[, $offset = 0])

		:param	int	$value: Number of rows to limit the results to
		:param	int	$offset: Number of rows to skip
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds LIMIT and OFFSET clauses to a query.

	.. php:method:: offset($offset)

		:param	int	$offset: Number of rows to skip
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds an OFFSET clause to a query.

	.. php:method:: set($key[, $value = ''[, $escape = NULL]])

		:param	mixed	$key: Field name, or an array of field/value pairs
		:param	string	$value: Field value, if $key is a single field
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds field/value pairs to be passed later to ``insert()``,
		``update()`` or ``replace()``.

	.. php:method:: insert([$set = NULL[, $escape = NULL]])

		:param	array	$set: An associative array of field/value pairs
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Compiles and executes an INSERT statement.

	.. php:method:: insertBatch([$set = NULL[, $escape = NULL[, $batch_size = 100]]])

		:param	array	$set: Data to insert
		:param	bool	$escape: Whether to escape values and identifiers
		:param	int	$batch_size: Count of rows to insert at once
		:returns:	Number of rows inserted or FALSE on failure
		:rtype:	mixed

		Compiles and executes batch ``INSERT`` statements.

		.. note:: When more than ``$batch_size`` rows are provided, multiple
			``INSERT`` queries will be executed, each trying to insert
			up to ``$batch_size`` rows.

	.. php:method:: setInsertBatch($key[, $value = ''[, $escape = NULL]])

		:param	mixed	$key: Field name or an array of field/value pairs
		:param	string	$value: Field value, if $key is a single field
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds field/value pairs to be inserted in a table later via ``insertBatch()``.

	.. php:method:: update([$set = NULL[, $where = NULL[, $limit = NULL]]])

		:param	array	$set: An associative array of field/value pairs
		:param	string	$where: The WHERE clause
		:param	int	$limit: The LIMIT clause
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Compiles and executes an UPDATE statement.

	.. php:method:: updateBatch([$set = NULL[, $value = NULL[, $batch_size = 100]]])

		:param	array	$set: Field name, or an associative array of field/value pairs
		:param	string	$value: Field value, if $set is a single field
		:param	int	$batch_size: Count of conditions to group in a single query
		:returns:	Number of rows updated or FALSE on failure
		:rtype:	mixed

		Compiles and executes batch ``UPDATE`` statements.

		.. note:: When more than ``$batch_size`` field/value pairs are provided,
			multiple queries will be executed, each handling up to
			``$batch_size`` field/value pairs.

	.. php:method:: setUpdateBatch($key[, $value = ''[, $escape = NULL]])

		:param	mixed	$key: Field name or an array of field/value pairs
		:param	string	$value: Field value, if $key is a single field
		:param	bool	$escape: Whether to escape values and identifiers
		:returns:	BaseBuilder instance (method chaining)
		:rtype:	BaseBuilder

		Adds field/value pairs to be updated in a table later via ``updateBatch()``.

	.. php:method:: replace([$set = NULL])

		:param	array	$set: An associative array of field/value pairs
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Compiles and executes a REPLACE statement.

	.. php:method:: delete([$where = ''[, $limit = NULL[, $reset_data = TRUE]]])

		:param	string	$where: The WHERE clause
		:param	int	$limit: The LIMIT clause
		:param	bool	$reset_data: TRUE to reset the query "write" clause
		:returns:	BaseBuilder instance (method chaining) or FALSE on failure
		:rtype:	mixed

		Compiles and executes a DELETE query.

    .. php:method:: increment($column[, $value = 1])

        :param string $column: The name of the column to increment
        :param int    $value:  The amount to increment the column by

        Increments the value of a field by the specified amount. If the field
        is not a numeric field, like a VARCHAR, it will likely be replaced
        with $value.

    .. php:method:: decrement($column[, $value = 1])

        :param string $column: The name of the column to decrement
        :param int    $value:  The amount to decrement the column by

        Decrements the value of a field by the specified amount. If the field
        is not a numeric field, like a VARCHAR, it will likely be replaced
        with $value.

	.. php:method:: truncate()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Executes a TRUNCATE statement on a table.

		.. note:: If the database platform in use doesn't support TRUNCATE,
			a DELETE statement will be used instead.

	.. php:method:: emptyTable()

		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		Deletes all records from a table via a DELETE statement.

	.. php:method:: getCompiledSelect([$reset = TRUE])

		:param	bool	$reset: Whether to reset the current QB values or not
		:returns:	The compiled SQL statement as a string
		:rtype:	string

		Compiles a SELECT statement and returns it as a string.

	.. php:method:: getCompiledInsert([$reset = TRUE])

		:param	bool	$reset: Whether to reset the current QB values or not
		:returns:	The compiled SQL statement as a string
		:rtype:	string

		Compiles an INSERT statement and returns it as a string.

	.. php:method:: getCompiledUpdate([$reset = TRUE])

		:param	bool	$reset: Whether to reset the current QB values or not
		:returns:	The compiled SQL statement as a string
		:rtype:	string

		Compiles an UPDATE statement and returns it as a string.

	.. php:method:: getCompiledDelete([$reset = TRUE])

		:param	bool	$reset: Whether to reset the current QB values or not
		:returns:	The compiled SQL statement as a string
		:rtype:	string

		Compiles a DELETE statement and returns it as a string.
