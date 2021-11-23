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

``$builder->get()``

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

    foreach ($query->getResult() as $row) {
        echo $row->title;
    }

결과 생성에 대한 자세한 내용은 :doc:`결과(result) 함수 <results>` 페이지를 참조하십시오.

**$builder->getCompiledSelect()**

``$builder->get()``\ 처럼 select 쿼리를 컴파일하지만 쿼리를 *실행*\ 하지는 않습니다.
이 메소드는 SQL 쿼리를 문자열로 반환합니다.

Example::

    $sql = $builder->getCompiledSelect();
    echo $sql;

    // Prints string: SELECT * FROM mytable

첫 번째 매개 변수를 사용하면 쿼리 빌더의 쿼리를 재설정할지 여부를 설정할 수 있습니다. (기본적으로 ``$builder->get()``\ 을 사용할 때와 같이 재설정됩니다)

::

    echo $builder->limit(10,20)->getCompiledSelect(false);

    // Prints string: SELECT * FROM mytable LIMIT 20, 10
    // (in MySQL. Other databases have slightly different syntax)

    echo $builder->select('title, content, date')->getCompiledSelect();

    // Prints string: SELECT title, content, date FROM mytable LIMIT 20, 10

위 예제에서 두 번째 쿼리가 ``$builder->from()``\ 을 사용하거나, 테이블 이름을 첫 번째 매개 변수에 전달하지 않았다는 것에 주목하십시오.
이렇게 사용 가능한 이유는 ``$builder->get()``\ 을 사용하여 쿼리가 실행되지 않았기 때문이며, 값을 재설정해야 한다면 ``$builder->resetQuery()``\ 를 사용해야 합니다.

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

``$builder->select()``\ 는 두 번째 매개 변수를 옵션으로 허용하며, 이를 ``false``\ 로 설정하면 CodeIgniter는 필드 또는 테이블 이름을 보호하지 않습니다.
필드의 자동 이스케이프가 필드를 손상시킬 수 있는 복합 선택문이 필요한 경우에 유용합니다.

::

    $builder->select('(SELECT SUM(payments.amount) FROM payments WHERE payments.invoice_id=4) AS amount_paid', false);
    $query = $builder->get();

**$builder->selectMax()**

쿼리의 ``SELECT MAX(field)`` 부분을 작성합니다.
옵션으로 두 번째 매개 변수에 결과 필드의 이름을 전달하여 바꿀 수 있습니다.

::

    $builder->selectMax('age');
    $query = $builder->get();
	// Produces: SELECT MAX(age) as age FROM mytable

    $builder->selectMax('age', 'member_age');
    $query = $builder->get();
	// Produces: SELECT MAX(age) as member_age FROM mytable

**$builder->selectMin()**

쿼리의 "SELECT MIN(field)" 부분을 작성합니다.
selectMax()와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.

::

    $builder->selectMin('age');
    $query = $builder->get();
	// Produces: SELECT MIN(age) as age FROM mytable

**$builder->selectAvg()**

쿼리의 "SELECT AVG(field)" 부분을 작성합니다.
selectMax()와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.

::

    $builder->selectAvg('age');
    $query = $builder->get();
	// Produces: SELECT AVG(age) as age FROM mytable

**$builder->selectSum()**

쿼리의 "SELECT SUM(field)" 부분을 작성합니다.
selectMax()와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.

::

    $builder->selectSum('age');
    $query = $builder->get();
	// Produces: SELECT SUM(age) as age FROM mytable

**$builder->selectCount()**

쿼리의 "SELECT COUNT(field)" 부분을 작성합니다.
selectMax()와 마찬가지로 결과 필드의 이름을 바꾸는 두 번째 매개 변수를 옵션으로 제공합니다.


.. note:: 이 메소드는 ``groupBy()``\ 와 함께 사용할 때 특히 유용합니다. 카운트 결과는 일반적으로 ``countAll()`` 또는 ``countAllResults()``\ 를 참조하십시오.

::

    $builder->selectCount('age');
    $query = $builder->get();
	// Produces: SELECT COUNT(age) as age FROM mytable

**$builder->from()**

쿼리의 FROM 부분을 작성합니다.

::

    $builder = $db->table('users');
    $builder->select('title, content, date');
    $builder->from('mytable');
    $query = $builder->get();
	// Produces: SELECT title, content, date FROM mytable

.. note:: 앞에서 설명한 것처럼 쿼리의 FROM 부분은 $db->table() 함수에서 지정할 수 있습니다. from()에 대한 추가 호출은 쿼리의 FROM 부분에 더 많은 테이블을 추가합니다.

**$builder->join()**

쿼리의 JOIN 부분을 작성합니다.

::

    $builder = db->table('blogs');
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

.. note:: 이 함수에 전달된 모든 값(사용자 지정 문자열은 제외됨)은 자동으로 이스케이프되어 안전한 쿼리를 생성합니다.

.. note:: ``$builder->where()``\ 는 세 번째 매개 변수를 옵션으로 허용하며, ``false``\ 로 설정하면 CodeIgniter는 필드 또는 테이블 이름을 보호하지 않습니다.

#. **key/value 방법:**

    ::

        $builder->where('name', $name);
		// Produces: WHERE name = 'Joe'

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
        $builder->where('id <', $id);
		// Produces: WHERE name != 'Joe' AND id < 45

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

    
    문자열 내에 사용자 지정 데이터를 사용하는 경우 데이터를 수동으로 이스케이프해야 합니다.
    그렇지 않으면 SQL 주입(SQL injections)이 발생할 수 있습니다.

    ::

        $name = $builder->db->escape('Joe');
        $where = "name={$name} AND status='boss' OR status='active'";
        $builder->where($where);

#. **서브 쿼리:**

    익명 함수를 사용하여 서브 쿼리를 만들 수 있습니다.

    ::

        $builder->where('advance_amount <', function (BaseBuilder $builder) {
            return $builder->select('MAX(advance_amount)', false)->from('orders')->where('id >', 2);
        });
        // Produces: WHERE "advance_amount" < (SELECT MAX(advance_amount) FROM "orders" WHERE "id" > 2)

**$builder->orWhere()**

이 함수는 여러 인스턴스가 OR로 결합된다는 점을 제외하고 위의 함수와 동일합니다.

::

    $builder->where('name !=', $name);
    $builder->orWhere('id >', $id);
	// Produces: WHERE name != 'Joe' OR id > 50

**$builder->whereIn()**

적절한 경우 AND로 결합된 ``WHERE field IN ('item', 'item')`` SQL 쿼리를 생성합니다.

::

    $names = ['Frank', 'Todd', 'James'];
    $builder->whereIn('username', $names);
    // Produces: WHERE username IN ('Frank', 'Todd', 'James')

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

::

    $builder->whereIn('id', function (BaseBuilder $builder) {
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

    $builder->orWhereIn('id', function (BaseBuilder $builder) {
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

    $builder->whereNotIn('id', function (BaseBuilder $builder) {
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

    $builder->orWhereNotIn('id', function (BaseBuilder $builder) {
        return $builder->select('job_id')->from('users_jobs')->where('user_id', 3);
    });

    // Produces: OR "id" NOT IN (SELECT "job_id" FROM "users_jobs" WHERE "user_id" = 3)

************************
유사한 데이터 찾기
************************

**$builder->like()**

이 메소드를 사용하면 검색에 유용한 **LIKE**\ 절을 생성할 수 있습니다.

.. note:: 이 메소드에 전달된 모든 값은 자동으로 이스케이프됩니다.

.. note:: 모든 ``like*`` 메소드의 변형은 메소드의 다섯 번째 매개 변수에 ``true``\ 를 전달하여 대소문자를 구분하지 않는 검색을 수행하도록 강제할 수 있습니다.
    그렇지 않으면 가능한 경우 플랫폼별 기능을 사용하여 값을 소문자로 만듭니다. (예 :``HAVING LOWER (column) LIKE '% search %'``).
    이를 위해서는 ``column`` 대신 ``LOWER(column)``\ 에 대해 인덱스를 작성해야 할 수 있습니다.

#. **key/value 방법:**

    ::

        $builder->like('title', 'match');
        // Produces: WHERE `title` LIKE '%match%' ESCAPE '!'

    메소드 호출을 여러번 하게되면 AND와 함께 체인으로 연결됩니다::

        $builder->like('title', 'match');
        $builder->like('body', 'match');
        // WHERE `title` LIKE '%match%' ESCAPE '!' AND  `body` LIKE '%match%' ESCAPE '!'

    와일드카드(%)의 위치를 제어하려면 옵션으로 지정된 세 번째 인수를 사용합니다.
    옵션은 'before', 'after', 'both'(기본값)입니다.

    ::

        $builder->like('title', 'match', 'before');    // Produces: WHERE `title` LIKE '%match' ESCAPE '!'
        $builder->like('title', 'match', 'after');    // Produces: WHERE `title` LIKE 'match%' ESCAPE '!'
        $builder->like('title', 'match', 'both');    // Produces: WHERE `title` LIKE '%match%' ESCAPE '!'

#. **연관 배열 방법:**

    ::

        $array = ['title' => $match, 'page1' => $match, 'page2' => $match];
        $builder->like($array);
        // WHERE `title` LIKE '%match%' ESCAPE '!' AND  `page1` LIKE '%match%' ESCAPE '!' AND  `page2` LIKE '%match%' ESCAPE '!'

**$builder->orLike()**

이 메소드는 여러 인스턴스가 OR로 결합된다는 점을 제외하면 위의 메소드와 동일합니다.

::

    $builder->like('title', 'match'); $builder->orLike('body', $match);
    // WHERE `title` LIKE '%match%' ESCAPE '!' OR  `body` LIKE '%match%' ESCAPE '!'

**$builder->notLike()**

이 메소드는 NOT LIKE문을 생성한다는 점을 제외하면 ``like()``\ 와 동일합니다.

::

    $builder->notLike('title', 'match'); // WHERE `title` NOT LIKE '%match% ESCAPE '!'

**$builder->orNotLike()**

이 메소드는 여러 인스턴스가 OR로 결합된다는 점을 제외하면 ``notLike()``\ 와 동일합니다.

::

    $builder->like('title', 'match');
    $builder->orNotLike('body', 'match');
    // WHERE `title` LIKE '%match% OR  `body` NOT LIKE '%match%' ESCAPE '!'

**$builder->groupBy()**

검색어의 GROUP BY 부분을 작성합니다.

::

    $builder->groupBy("title");
	// Produces: GROUP BY title

여러 값의 배열을 전달할 수도 있습니다.

::

    $builder->groupBy(["title", "date"]);
	// Produces: GROUP BY title, date

**$builder->distinct()**

"DISTINCT" 키워드를 쿼리에 추가합니다.

::

    $builder->distinct();
    $builder->get();
	// Produces: SELECT DISTINCT * FROM mytable

**$builder->having()**

쿼리의 HAVING 부분을 작성합니다.
가능한 구문은 2개이며, 인수는 1개 또는 2개입니다.

::

    $builder->having('user_id = 45'); // Produces: HAVING user_id = 45
    $builder->having('user_id',  45); // Produces: HAVING user_id = 45

여러 값의 배열을 전달할 수도 있습니다.

::

    $builder->having(['title =' => 'My Title', 'id <' => $id]);
    // Produces: HAVING title = 'My Title', id < 45

CodeIgniter는 기본적으로 쿼리를 이스케이프하여 데이터베이스에 전송합니다. 이스케이프되는 것을 방지하고 싶다면 옵션으로 지정된 세 번째 인수를 ``false``\ 로 설정하십시오.

::

    $builder->having('user_id',  45); // Produces: HAVING `user_id` = 45 in some databases such as MySQL
    $builder->having('user_id',  45, false); // Produces: HAVING user_id = 45

**$builder->orHaving()**

``having()``\ 과 동일하며 여러 절을 "OR"로 구분합니다.

**$builder->havingIn()**

적절한 경우 AND로 결합된 ``HAVING field IN ( 'item', 'item')`` SQL쿼리를 생성합니다.

::

    $groups = [1, 2, 3];
    $builder->havingIn('group_id', $groups);
    // Produces: HAVING group_id IN (1, 2, 3)

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

::

    $builder->havingIn('id', function (BaseBuilder $builder) {
        return $builder->select('user_id')->from('users_jobs')->where('group_id', 3);
    });
    // Produces: HAVING "id" IN (SELECT "user_id" FROM "users_jobs" WHERE "group_id" = 3)

**$builder->orHavingIn()**

적절한 경우 OR로 결합된 ``HAVING field IN ( 'item', 'item')`` SQL 쿼리를 생성합니다.

::

    $groups = [1, 2, 3];
    $builder->orHavingIn('group_id', $groups);
    // Produces: OR group_id IN (1, 2, 3)

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

::

    $builder->orHavingIn('id', function (BaseBuilder $builder) {
        return $builder->select('user_id')->from('users_jobs')->where('group_id', 3);
    });

    // Produces: OR "id" IN (SELECT "user_id" FROM "users_jobs" WHERE "group_id" = 3)

**$builder->havingNotIn()**

적절한 경우 AND로 결합된 ``HAVING field NOT IN ( 'item', 'item')`` SQL 쿼리를 생성합니다.

::

    $groups = [1, 2, 3];
    $builder->havingNotIn('group_id', $groups);
    // Produces: HAVING group_id NOT IN (1, 2, 3)

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

::

    $builder->havingNotIn('id', function (BaseBuilder $builder) {
        return $builder->select('user_id')->from('users_jobs')->where('group_id', 3);
    });

    // Produces: HAVING "id" NOT IN (SELECT "user_id" FROM "users_jobs" WHERE "group_id" = 3)


**$builder->orHavingNotIn()**

적절한 경우 OR로 결합된 ``HAVING field NOT IN ( 'item', 'item')`` SQL 쿼리를 생성합니다.

::

    $groups = [1, 2, 3];
    $builder->havingNotIn('group_id', $groups);
    // Produces: OR group_id NOT IN (1, 2, 3)

값 배열 대신 서브 쿼리를 사용할 수 있습니다.

::

    $builder->orHavingNotIn('id', function (BaseBuilder $builder) {
        return $builder->select('user_id')->from('users_jobs')->where('group_id', 3);
    });

    // Produces: OR "id" NOT IN (SELECT "user_id" FROM "users_jobs" WHERE "group_id" = 3)

**$builder->havingLike()**

이 메소드를 사용하면 HAVING 부분 대해 **LIKE** 절을 생성할 수 있으며 검색에 유용합니다.

.. note:: 이 메소드에 전달 된 모든 값은 자동으로 이스케이프됩니다.

.. note:: 모든 ``havingLike*`` 메소드의 변형은 메소드의 다섯 번째 매개 변수에 ``true``\ 를 전달하여 대소문자를 구분하지 않는 검색을 수행하도록 강제할 수 있습니다.
    그렇지 않으면 가능한 경우 플랫폼별 기능을 사용하여 값을 소문자로 만듭니다. (예 :``HAVING LOWER (column) LIKE '% search %'``).
    이를 위해서는 ``column`` 대신 ``LOWER(column)``\ 에 대해 인덱스를 작성해야 할 수 있습니다.

#. **key/value 방법:**

    ::

        $builder->havingLike('title', 'match');
        // Produces: HAVING `title` LIKE '%match%' ESCAPE '!'

    메소드를 여러번 호출하는 경우 AND와 함께 체인으로 연결됩니다.

    ::

        $builder->havingLike('title', 'match');
        $builder->havingLike('body', 'match');
        // HAVING `title` LIKE '%match%' ESCAPE '!' AND  `body` LIKE '%match% ESCAPE '!'

    와일드카드(%)의 위치를 제어하려면 옵션으로 지정된 세 번째 인수를 사용합니다.
    옵션은 'before', 'after', 'both'(기본값)입니다.

    ::

        $builder->havingLike('title', 'match', 'before');    // Produces: HAVING `title` LIKE '%match' ESCAPE '!'
        $builder->havingLike('title', 'match', 'after');    // Produces: HAVING `title` LIKE 'match%' ESCAPE '!'
        $builder->havingLike('title', 'match', 'both');    // Produces: HAVING `title` LIKE '%match%' ESCAPE '!'

#. **연관 배열 방법:**

    ::

        $array = ['title' => $match, 'page1' => $match, 'page2' => $match];
        $builder->havingLike($array);
        // HAVING `title` LIKE '%match%' ESCAPE '!' AND  `page1` LIKE '%match%' ESCAPE '!' AND  `page2` LIKE '%match%' ESCAPE '!'

**$builder->orHavingLike()**

이 메소드는 여러 인스턴스가 OR로 결합된다는 점을 제외하면 위의 메소드와 동일합니다.

::

    $builder->havingLike('title', 'match'); $builder->orHavingLike('body', $match);
    // HAVING `title` LIKE '%match%' ESCAPE '!' OR  `body` LIKE '%match%' ESCAPE '!'

**$builder->notHavingLike()**

이 메소드는 NOT LIKE문을 생성한다는 점을 제외하면 ``havingLike()``\ 와 동일합니다.

::

    $builder->notHavingLike('title', 'match');
	// HAVING `title` NOT LIKE '%match% ESCAPE '!'

**$builder->orNotHavingLike()**

이 메소드는 여러 인스턴스가 OR로 결합된다는 점을 제외하면 ``notHavingLike()``\ 와 동일합니다.

::

    $builder->havingLike('title', 'match');
    $builder->orNotHavingLike('body', 'match');
    // HAVING `title` LIKE '%match% OR  `body` NOT LIKE '%match%' ESCAPE '!'

****************
결과 정렬
****************

**$builder->orderBy()**


ORDER BY 절을 설정합니다.

첫 번째 매개 변수에는 정렬하려는 열(column) 이름이 포함됩니다.

두 번째 매개 변수를 사용하면 정렬 방향을 설정할 수 있습니다.
값은 **ASC**, **DESC**, **RANDOM**.

::

    $builder->orderBy('title', 'DESC');
    // Produces: ORDER BY `title` DESC

첫 번째 매개 변수에 사용자 정의 문자열을 전달할 수도 있습니다

::

    $builder->orderBy('title DESC, name ASC');
    // Produces: ORDER BY `title` DESC, `name` ASC

여러개의 필드가 필요한 경우 함수를 여러번 호출할 수 있습니다.

::

    $builder->orderBy('title', 'DESC');
    $builder->orderBy('name', 'ASC');
    // Produces: ORDER BY `title` DESC, `name` ASC

방향 옵션을 **RANDOM**\ 으로 할 때 숫자로 지정하지 않으면 첫 번째 매개 변수가 무시됩니다.

::

    $builder->orderBy('title', 'RANDOM');
    // Produces: ORDER BY RAND()

    $builder->orderBy(42, 'RANDOM');
    // Produces: ORDER BY RAND(42)

.. note:: 무작위 순서는 현재 Oracle에서 지원되지 않으며 대신 ASC로 기본 설정됩니다.

******************************************
결과 제한(Limit) 또는 카운팅(Counting)
******************************************

**$builder->limit()**

쿼리에서 반환하려는 행 수를 제한할 수 있습니다

::

    $builder->limit(10);  // Produces: LIMIT 10

두 번째 매개 변수를 사용하면 결과 오프셋을 설정할 수 있습니다.

::

    $builder->limit(10, 20);
	// Produces: LIMIT 20, 10 (in MySQL. Other databases have slightly different syntax)


**$builder->countAllResults()**

쿼리 빌더를 통해 조건에 맞는 행의 갯수를 반환합니다.
``where()``, ``orWhere()``, ``like()``, ``orLike()``\ 등과 같은 쿼리 빌더 메소드를 허용합니다.

::

    echo $builder->countAllResults();  // Produces an integer, like 25
    $builder->like('title', 'match');
    $builder->from('my_table');
    echo $builder->countAllResults(); // Produces an integer, like 17

그러나 이 메소드는 ``select()``에 전달했을 수 있는 모든 필드 값을 재설정합니다.
유지하고 싶다면 첫 번째 매개 변수로 ``false``\ 를 전달합니다.

::

    echo $builder->countAllResults(false); // Produces an integer, like 17

**$builder->countAll()**

특정 테이블의 모든 행의 갯수를 반환니다.

::

    echo $builder->countAll(); // Produces an integer, like 25

countAllResult 메소드와 마찬가지로 이 메소드도 ``select()``\ 에 전달되었을 수 있는 모든 필드 값을 재설정합니다.
유지하고 싶다면 첫 번째 매개 변수로 ``false``\ 를 전달합니다.

**************
쿼리 그룹화
**************

쿼리 그룹화를 사용하면 WHERE절 그룹을 괄호로 묶어 그룹을 만들 수 있습니다.
이를 이요하여 복잡한 WHERE절을 쿼리로 만들 수 있습니다. 
중첩 그룹이 지원됩니다.

::

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

.. note:: 그룹은 균형을 유지해야합니다. 모든 ``groupStart()``\ 가 ``groupEnd()``\ 와 쌍으로 일치하는지 확인하십시오.

**$builder->groupStart()**

쿼리의 WHERE절에 여는 괄호를 추가하여 새 그룹을 시작합니다.

**$builder->orGroupStart()**

쿼리의 WHERE절에 'OR' 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

**$builder->notGroupStart()**

쿼리의 WHERE절에 'NOT' 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

**$builder->orNotGroupStart()**

쿼리의 WHERE절에 'OR NOT' 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

**$builder->groupEnd()**

쿼리의 WHERE절에 닫는 괄호를 추가하여 현재 그룹을 종료합니다.

**$builder->havingGroupStart()**

쿼리의 HAVING절에 여는 괄호를 추가하여 새 그룹을 시작합니다.

**$builder->orHavingGroupStart()**

쿼리의 HAVING절에 'OR' 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

**$builder->notHavingGroupStart()**

쿼리의 HAVING절에 'NOT' 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

**$builder->orNotHavingGroupStart()**

쿼리의 HAVING절에 'OR NOT' 접두사와 함께 여는 괄호를 추가하여 새 그룹을 시작합니다.

**$builder->havingGroupEnd()**

쿼리의 HAVING절에 닫는 괄호를 추가하여 현재 그룹을 종료합니다.

********************
Inserting 데이타
********************

**$builder->insert()**

제공한 데이터를 기반으로 Insert 문자열을 생성하고 쿼리를 실행합니다.
**배열** 또는 **객체(object)**\ 를 함수에 전달할 수 있습니다. 
다음은 배열을 사용하는 예입니다

::

    $data = [
        'title' => 'My title',
        'name'  => 'My Name',
        'date'  => 'My date',
    ];

    $builder->insert($data);
    // Produces: INSERT INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date')

첫 번째 매개 변수는 값의 연관 배열입니다.

다음은 객체를 사용하는 예입니다

::

    class Myclass 
    {
        public $title   = 'My Title';
        public $content = 'My Content';
        public $date    = 'My Date';
    }

    $object = new Myclass;
    $builder->insert($object);
    // Produces: INSERT INTO mytable (title, content, date) VALUES ('My Title', 'My Content', 'My Date')

첫 번째 매개 변수는 객체입니다.

.. note:: 모든 값은 자동으로 이스케이프됩니다.

**$builder->ignore()**

제공한 데이터를 기반으로 인서트 무시 문자열(insert ignore string)을 생성하고 쿼리를 실행합니다.
따라서 동일한 기본 키를 가진 항목이 이미 있으면 쿼리가 인서트(insert)되지 않습니다.
선택적으로 **boolean**\ 을 함수에 전달할 수 있습니다.

위 예제의 배열을 사용한 예제입니다.

::

    $data = [
        'title' => 'My title',
        'name'  => 'My Name',
        'date'  => 'My date',
    ];

    $builder->ignore(true)->insert($data);
    // Produces: INSERT OR IGNORE INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date')


**$builder->getCompiledInsert()**

``$builder->insert()``\ 와 같이 Insert 쿼리를 컴파일하지만 쿼리를 *실행*\ 하지는 않습니다.
이 메소드는 SQL 쿼리를 문자열로 반환합니다.

Example::

    $data = [
        'title' => 'My title',
        'name'  => 'My Name',
        'date'  => 'My date',
    ];

    $sql = $builder->set($data)->getCompiledInsert('mytable');
    echo $sql;

    // Produces string: INSERT INTO mytable (`title`, `name`, `date`) VALUES ('My title', 'My name', 'My date')

두 번째 매개 변수를 사용하면 쿼리 빌더의 쿼리를 재설정할 지 여부를 설정할 수 있습니다. (기본적으로 ``$builder->insert()``\ 와 같습니다)

::

    echo $builder->set('title', 'My Title')->getCompiledInsert('mytable', false);

    // Produces string: INSERT INTO mytable (`title`) VALUES ('My Title')

    echo $builder->set('content', 'My Content')->getCompiledInsert();

    // Produces string: INSERT INTO mytable (`title`, `content`) VALUES ('My Title', 'My Content')

위 예제에서 주목할 점은 두 번째 쿼리는 ``$builder->from()``\ 을 사용하거나, 첫 번째 매개 변수에 테이블 이름을 전달하지 않았다는 것입니다.
이것이 작동하는 이유는  ``$builder->resetQuery()``\ 를 사용하여 값을 재설정하거나, ``$builder->insert()``\ 를 사용하여 쿼리가 실행되지 않았기 때문입니다.

.. note:: 이 방법은 insertBatch() 에서는 작동하지 않습니다.

**$builder->insertBatch()**

제공한 데이터를 기반으로 Insert 문자열을 생성하고 쿼리를 실행합니다.
**배열** 또는 **객체(object)**\ 를 함수에 전달할 수 있습니다. 
다음은 배열을 사용하는 예입니다

::

    $data = [
        [
            'title' => 'My title',
            'name'  => 'My Name',
            'date'  => 'My date',
        ],
        [
            'title' => 'Another title',
            'name'  => 'Another Name',
            'date'  => 'Another date',
        ]
    ];

    $builder->insertBatch($data);
    // Produces: INSERT INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date'),  ('Another title', 'Another name', 'Another date')

첫 번째 매개 변수는 값의 연관 배열입니다.

.. note:: 모든 값은 자동으로 이스케이프됩니다.

*******************
Updating 데이타
*******************

**$builder->replace()**

이 메소드는 기본적으로 *PRIMARY* 와 *UNIQUE* 키를 기준으로 ``DELETE + INSERT``\ 에 대한 SQL 표준인 ``REPLACE``\ 문을 실행합니다.
이것으로 당신은 ``select()``, ``update()``, ``delete()``, ``insert()``\ 의 조합으로 구성된 복잡한 논리를 구현할 필요가 없어집니다.

::

    $data = [
        'title' => 'My title',
        'name'  => 'My Name',
        'date'  => 'My date',
    ];

    $builder->replace($data);

    // Executes: REPLACE INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date')

위의 예에서 *title* 필드가 기본 키라고 가정하면 *title* 값으로 'My title'\ 이 포함된 행은 새 행 데이터로 대체되어 삭제됩니다.

``set()`` 메소드 사용도 허용되며 ``insert()``\ 와 마찬가지로 모든 필드가 자동으로 이스케이프됩니다.

**$builder->set()**

이 기능을 사용하면 Insert 또는 Update 값을 설정할 수 있습니다.

**데이터 배열을 직접 Insert 또는 Update\ 로 전달하는 대신 사용할 수 있습니다.**

::

    $builder->set('name', $name);
    $builder->insert();
	// Produces: INSERT INTO mytable (`name`) VALUES ('{$name}')

여러번 사용하는 경우 Insert 또는 Update 수행 여부에 따라 올바르게 조립됩니다.

::

    $builder->set('name', $name);
    $builder->set('title', $title);
    $builder->set('status', $status);
    $builder->insert();

**set()**\ 은 옵션으로 세 번째 매개 변수 (``$escape``)도 허용하며 이 값을 ``false``\ 로 설정하면 데이터가 이스케이프되지 않습니다.
차이점을 설명하기 위해 다음 예제는 이스케이프 매개 변수를 사용하거나 사용하지 않고 ``set()``\ 을 사용합니다.

::

    $builder->set('field', 'field+1', false);
    $builder->where('id', 2);
    $builder->update();
	// gives UPDATE mytable SET field = field+1 WHERE `id` = 2

    $builder->set('field', 'field+1');
    $builder->where('id', 2);
    $builder->update();
	// gives UPDATE `mytable` SET `field` = 'field+1' WHERE `id` = 2

이 메소드에 연관 배열을 전달할 수 있습니다

::

    $array = [
        'name'   => $name,
        'title'  => $title,
        'status' => $status,
    ];

    $builder->set($array);
    $builder->insert();

또는 객체

::

    class Myclass 
    {
        public $title   = 'My Title';
        public $content = 'My Content';
        public $date    = 'My Date';
    }

    $object = new Myclass;
    $builder->set($object);
    $builder->insert();

**$builder->update()**

업데이트 문자열을 생성하고 제공한 데이터를 기반으로 쿼리를 실행합니다.
**배열** 또는 **객체**\ 를 함수에 전달할 수 있습니다.
다음은 배열을 사용하는 예입니다

::

    $data = [
        'title' => $title,
        'name'  => $name,
        'date'  => $date,
    ];

    $builder->where('id', $id);
    $builder->update($data);
    // Produces:
    //
    //    UPDATE mytable
    //    SET title = '{$title}', name = '{$name}', date = '{$date}'
    //    WHERE id = $id

또는 객체를 제공할 수 있습니다.

::

    class Myclass 
    {
        public $title   = 'My Title';
        public $content = 'My Content';
        public $date    = 'My Date';
    }

    $object = new Myclass;
    $builder->where('id', $id);
    $builder->update($object);
    // Produces:
    //
    // UPDATE `mytable`
    // SET `title` = '{$title}', `name` = '{$name}', `date` = '{$date}'
    // WHERE id = `$id`

.. note:: 모든 값은 자동으로 이스케이프됩니다.

``$builder->where()`` 함수를 사용하면 WHERE절을 설정할 수 있습니다.
선택적으로 이 정보를 문자열로 업데이트 함수에 직접 전달할 수 있습니다

::

    $builder->update($data, "id = 4");

또는 배열로

::

    $builder->update($data, ['id' => $id]);

업데이트를 수행할 때 위에서 설명한 ``$builder->set()`` 메소드를 사용할 수도 있습니다.

**$builder->updateBatch()**

업데이트 문자열을 생성하고 제공한 데이터를 기반으로 쿼리를 실행합니다.
**배열** 또는 **객체**\ 를 함수에 전달할 수 있습니다.
다음은 배열을 사용하는 예입니다

::

    $data = [
       [
          'title' => 'My title' ,
          'name'  => 'My Name 2' ,
          'date'  => 'My date 2',
       ],
       [
          'title' => 'Another title' ,
          'name'  => 'Another Name 2' ,
          'date'  => 'Another date 2',
       ],
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

첫 번째 매개 변수는 값의 연관 배열이고, 두 번째 매개 변수는 where절에 사용할 키입니다.

.. note:: 모든 값은 자동으로 이스케이프됩니다.

.. note:: ``affectedRows()``는 작동 방식이 달라 이 메소드에 대한 적절한 결과를 제공하지 않습니다. 대신 ``updateBatch()``\ 는 영향을 받는 행 수를 반환합니다.

**$builder->getCompiledUpdate()**

이것은 INSERT SQL 문자열대신 UPDATE SQL 문자열을 생성한다는 점을 제외하고 ``$builder->getCompiledInsert()``\ 와 동일한 방식으로 작동합니다.

자세한 내용은 `$builder->getCompiledInsert()`\ 에 대한 설명서를 참조하십시오.

.. note:: updateBatch()\ 는 이 메소드가 작동하지 않습니다.

**********************
데이터 삭제(Deleting)
**********************

**$builder->delete()**

DELETE SQL 문자열을 생성하고 쿼리를 실행합니다.

::

    $builder->delete(['id' => $id]);  // Produces: // DELETE FROM mytable  // WHERE id = $id

첫 번째 매개 변수는 where절입니다.
함수의 첫 번째 매개 변수에 데이터를 전달하는 대신 ``where()`` 또는 ``or_where()`` 함수를 사용할 수 있습니다.

::

    $builder->where('id', $id);
    $builder->delete();

    // Produces:
    // DELETE FROM mytable
    // WHERE id = $id

테이블에서 모든 데이터를 삭제하려면 ``truncate()`` 함수 또는 ``emptyTable()`` 함수를 사용합니다.

**$builder->emptyTable()**

DELETE SQL 문자열을 생성하고 쿼리를 실행합니다.

::

      $builder->emptyTable('mytable'); 
	  // Produces: DELETE FROM mytable

**$builder->truncate()**

TRUNCATE SQL 문자열을 생성하고 쿼리를 실행합니다.

::

    $builder->truncate();

    // Produce:
    // TRUNCATE mytable

.. note:: TRUNCATE 명령을 사용할 수 없으면 truncate()가 "DELETE FROM table"\ 로 실행됩니다.

**$builder->getCompiledDelete()**

이것은 INSERT SQL 문자열 대신 DELETE SQL 문자열을 생성한다는 점을 제외하고 ``$builder->getCompiledInsert()``\ 와 동일한 방식으로 작동합니다.

자세한 내용은 $builder->getCompiledInsert() 설명서를 참조하십시오.

***************************
메소드 체이닝(Chaining)
***************************

메소드 체인을 사용하면 여러 함수를 연결하여 구문을 단순화 할 수 있습니다.
다음 예제를 살펴보십시오.

::

    $query = $builder->select('title')
             ->where('id', $id)
             ->limit(10, 20)
             ->get();

.. _ar-caching:

***********************
쿼리 빌더 재설정
***********************

``$builder->resetQuery()``

쿼리 빌더를 재 설정하면 ``$builder->get()`` 또는 ``$builder->insert()``\ 와 같은 메소드를 사용하여 쿼리를 실행하지 않고 쿼리를 새로 시작할 수 있습니다.

이는 쿼리 빌더를 사용하여 SQL을 생성(ex. ``$builder->getCompiledSelect()``)한 후 다음 작업을 진행시 유용합니다.

::

    // Note that the second parameter of the ``get_compiled_select`` method is false
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

.. php:class:: CodeIgniter\\Database\\BaseBuilder

    .. php:method:: db()

        :returns: 사용중인 데이터베이스 연결
        :rtype: ``ConnectionInterface``

        연결된 데이터베이스 객체를  ``$db``\ 로 반환합니다.
        ``insertID()``\ 나 ``errors()``\ 와 같이 쿼리빌더(Query Builder)에서 직접 사용할 수 없는 ``ConnectionInterface`` 메소드를 액세스할 때 유용합니다.

    .. php:method:: resetQuery()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리 빌더 상태를 재설정합니다.
        특정 조건에서 쿼리를 작성 취소하려는 경우에 유용합니다.

    .. php:method:: countAllResults([$reset = true])

        :param bool $reset: SELECT 재설정 여부
        :returns: 쿼리 결과의 행의 갯수
        :rtype: int

        쿼리 빌더를 통하여 반환한 모든 레코드를 수를 계산하는 플랫폼별 쿼리 문자열을 생성 실행합니다.

    .. php:method:: countAll([$reset = true])

        :param bool $reset: SELECT 재설정 여부
        :returns: 쿼리 결과의 행의 갯수
        :rtype: int

        쿼리 빌더를 통하여 반환한 모든 레코드를 수를 계산하는 플랫폼별 쿼리 문자열을 생성 실행합니다.

    .. php:method:: get([$limit = null[, $offset = null[, $reset = true]]]])

        :param int $limit: LIMIT 절
        :param int $offset: OFFSET 절
        :param bool $reset: 쿼리 빌더 값 재설정 여부
        :returns: ``\CodeIgniter\Database\ResultInterface`` instance (method chaining)
        :rtype: ``\CodeIgniter\Database\ResultInterface``

        호출된 쿼리 빌더 메소드를 기반으로 SELECT 문을 컴파일하고 실행합니다.

    .. php:method:: getWhere([$where = null[, $limit = null[, $offset = null[, $reset = true]]]]])

        :param string $where: WHERE 절
        :param int $limit: LIMIT 절
        :param int $offset: OFFSET 절
        :param bool $reset: 쿼리 빌더 값 재설정 여부
        :returns: ``\CodeIgniter\Database\ResultInterface`` instance (method chaining)
        :rtype: ``\CodeIgniter\Database\ResultInterface``

        ``get()``\ 과 동일하지만 WHERE를 직접 추가할 수 있습니다.

    .. php:method:: select([$select = '*'[, $escape = null]])

        :param string $select: 쿼리의 SELECT 부분
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT절을 추가합니다.

    .. php:method:: selectAvg([$select = ''[, $alias = '']])

        :param string $select: 평균을 계산하는 필드
        :param string $alias: 결과 값 이름의 별명
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT AVG(field)절을 추가합니다.

    .. php:method:: selectMax([$select = ''[, $alias = '']])

        :param string $select: 최대 값을 계산하는 필드
        :param string $alias: 결과 값 이름의 별명
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT MAX(field)절을 추가합니다.

    .. php:method:: selectMin([$select = ''[, $alias = '']])

        :param string $select: 최소 값을 계산하는 필드
        :param string $alias: 결과 값 이름의 별명
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT MIN(field)절을 추가합니다.

    .. php:method:: selectSum([$select = ''[, $alias = '']])

        :param string $select: 합계를 계산하는 필드
        :param string $alias: 결과 값 이름의 별명
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT SUM(field)절을 추가합니다.

    .. php:method:: selectCount([$select = ''[, $alias = '']])

        :param string $select: 카운트할 필드
        :param string $alias: 결과 값 이름의 별명
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 SELECT COUNT(field)절을 추가합니다.

    .. php:method:: distinct([$val = true])

        :param bool $val: "distinct" 플래그 설정 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리 빌더가 DISTINCT 절을 쿼리의 SELECT 부분에 추가하도록 지시하는 플래그를 설정합니다.

    .. php:method:: from($from[, $overwrite = false])

        :param mixed $from: 테이블 명; string 또는 array
        :param bool $overwrite: 기존 설정된 첫 번째 테이블 제거 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리의 FROM 절을 지정합니다.

    .. php:method:: join($table, $cond[, $type = ''[, $escape = null]])

        :param string $table: 결합(Join)할 테이블 이름
        :param string $cond: JOIN ON 조건
        :param string $type: JOIN type
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 JOIN절을 추가합니다.

    .. php:method:: where($key[, $value = null[, $escape = null]])

        :param mixed $key: 비교할 필드 이름 또는 연관 배열
        :param mixed $value: 단일 키인 경우 이 값과 비교
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        쿼리의 WHERE 부분을 생성합니다. 여러번 호출할 경우 'AND'로 연결합니다.

    .. php:method:: orWhere($key[, $value = null[, $escape = null]])

        :param mixed $key: 비교할 필드 이름 또는 연관 배열
        :param mixed $value: 단일 키인 경우 이 값과 비교
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        쿼리의 WHERE 부분을 생성합니다. 여러번 호출할 경우 'OR'로 연결합니다.

    .. php:method:: orWhereIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검색할 필드
        :param array|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리의 WHERE field IN('item', 'item') 부분을 생성합니다. 'OR'로 연결합니다.

    .. php:method:: orWhereNotIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검색할 필드
        :param array|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리의 WHERE field NOT IN('item', 'item') 부분을 생성합니다. 'OR'로 연결합니다.

    .. php:method:: whereIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검사 할 필드 이름
        :param array|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리의 WHERE field IN('item', 'item') 부분을 생성합니다. 'AND'로 연결합니다.

    .. php:method:: whereNotIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검사 할 필드 이름
        :param array|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리의 WHERE field NOT IN('item', 'item') 부분을 생성합니다. 'AND'로 연결합니다.

    .. php:method:: groupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        AND를 사용하여 그룹 표현식을 시작합니다.

    .. php:method:: orGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        OR을 사용하여 그룹 표현식을 시작합니다.

    .. php:method:: notGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        AND NOT을 사용하여 그룹 표현식을 시작합니다.

    .. php:method:: orNotGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        OR NOT을 사용하여 그룹 표현식을 시작합니다.

    .. php:method:: groupEnd()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: object

        그룹 표현식을 종료합니다.

    .. php:method:: like($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: Field name
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 AND를 사용하여 LIKE 절을 쿼리에 추가합니다.

    .. php:method:: orLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 OR을 사용하여 LIKE 절을 쿼리에 추가합니다.

    .. php:method:: notLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 AND를 사용하여 NOT LIKE 절을 쿼리에 추가합니다.

    .. php:method:: orNotLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 OR을 사용하여 NOT LIKE 절을 쿼리에 추가합니다.

    .. php:method:: having($key[, $value = null[, $escape = null]])

        :param mixed $key: 필드/값 쌍의 식별자(문자열) 또는 연관 배열
        :param string $value: Value sought if $key is an identifier
        :param string $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 AND를 사용하여 HAVING 절을 쿼리에 추가합니다.

    .. php:method:: orHaving($key[, $value = null[, $escape = null]])

        :param mixed $key: 필드/값 쌍의 식별자(문자열) 또는 연관 배열
        :param string $value: Value sought if $key is an identifier
        :param string $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 OR을 사용하여 HAVING 절을 쿼리에 추가합니다.

    .. php:method:: orHavingIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검색할 필드
        :param array|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리에 HAVING field IN('item', 'item') 절을 추가합니다. OR로 분리.

    .. php:method:: orHavingNotIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검색할 필드
        :param array|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리에 HAVING field NOT IN('item', 'item') 절을 추가합니다. OR로 분리.

    .. php:method:: havingIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검사 할 필드 이름
        :param array|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리에 HAVING field IN('item', 'item') 절을 추가합니다. AND로 분리.

    .. php:method:: havingNotIn([$key = null[, $values = null[, $escape = null]]])

        :param string $key: 검사 할 필드 이름
        :param array|Closure $values: 대상 값 배열 또는 서브 쿼리에 대한 익명 함수
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance
        :rtype: object

        SQL 쿼리에 HAVING field NOT IN('item', 'item') 절을 추가합니다. AND로 분리.

    .. php:method:: havingLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 AND를 사용하여 HAVING 부분에 LIKE 절을 쿼리에 추가합니다.

    .. php:method:: orHavingLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 OR을 사용하여 HAVING 부분에 LIKE 절을 쿼리에 추가합니다.

    .. php:method:: notHavingLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :param bool $insensitiveSearch: 대소문자를 구분하지 않고 검색할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 AND를 사용하여 HAVING 부분에 NOT LIKE 절을 쿼리에 추가합니다.

    .. php:method:: orNotHavingLike($field[, $match = ''[, $side = 'both'[, $escape = null[, $insensitiveSearch = false]]]])

        :param string $field: 필드명
        :param string $match: 일치할 텍스트 부분
        :param string $side: 와일드 카드(%)를 넣을 위치
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        여러번 호출할 경우 OR을 사용하여 HAVING 부분에 NOT LIKE 절을 쿼리에 추가합니다.

    .. php:method:: havingGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        AND를 사용하여 HAVING 절에 대한 그룹 표현식을 시작합니다.

    .. php:method:: orHavingGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        OR을 사용하여 HAVING 절에 대한 그룹 표현식을 시작합니다.

    .. php:method:: notHavingGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        AND NOT을 사용하여 HAVING 절에 대한 그룹 표현식을 시작합니다.

    .. php:method:: orNotHavingGroupStart()

        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        OR NOT을 사용하여 HAVING 절에 대한 그룹 표현식을 시작합니다.

    .. php:method:: havingGroupEnd()

        :returns: ``BaseBuilder`` instance
        :rtype: object

        HAVING 절에 대한 그룹 표현식을 종료합니다.

    .. php:method:: groupBy($by[, $escape = null])

        :param mixed $by: Field(s) to group by; string or array
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 GROUP BY절을 추가합니다.

    .. php:method:: orderBy($orderby[, $direction = ''[, $escape = null]])

        :param string $orderby: 정렬할 필드
        :param string $direction: The order requested - ASC, DESC or random
        :param bool $escape: 값과 식별자를 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 ORDER BY절을 추가합니다.

    .. php:method:: limit($value[, $offset = 0])

        :param int $value: 결과를 제한할 행 수
        :param int $offset: 건너 뛸 행 수
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 LIMIT and OFFSET절을 추가합니다.

    .. php:method:: offset($offset)

        :param int $offset: 건너 뛸 행 수
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        쿼리에 OFFSET절을 추가합니다.

    .. php:method:: set($key[, $value = ''[, $escape = null]])

        :param mixed $key: 필드 이름 또는 필드/값 쌍 배열
        :param string $value: $key가 단일 필드인 경우 필드 값
        :param bool $escape: 값을 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        ``insert()``, ``update()``, ``replace()``\ 에 전달할 필드/값 쌍을 추가합니다.

    .. php:method:: insert([$set = null[, $escape = null]])

        :param array $set: 필드/값 쌍 배열
        :param bool $escape: 값을 이스케이프할지 여부
        :returns: true on success, false on failure
        :rtype: bool

        INSERT 문을 컴파일하고 실행합니다.

    .. php:method:: insertBatch([$set = null[, $escape = null[, $batch_size = 100]]])

        :param array $set: Insert할 데이터
        :param bool $escape: 값을 이스케이프할지 여부
        :param int $batch_size: 한 번에 Insert할 행의 수
        :returns: Insert된 행의 수, 실패시 false
        :rtype: mixed

        배치 ``INSERT``\ 문을 컴파일하고 실행합니다.

        .. note:: ``$batch_size`` 이상의 행이 제공되면, 각각 ``$batch_size`` 행을 Insert하려고 하는 여러 INSERT 쿼리가 실행됩니다.

    .. php:method:: setInsertBatch($key[, $value = ''[, $escape = null]])

        :param mixed $key: 필드 이름 또는 필드/값 쌍 배열
        :param string $value: $key가 단일 필드인 경우 필드 값
        :param bool $escape: 값을 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        ``insertBatch()``\ 를 통해 테이블에 Insert할 필드/값 쌍을 추가합니다.

    .. php:method:: update([$set = null[, $where = null[, $limit = null]]])

        :param array $set: 필드/값 쌍의 연관 배열
        :param string $where: WHERE 절
        :param int $limit: LIMIT 절
        :returns: true on success, false on failure
        :rtype: bool

        UPDATE 문을 컴파일하고 실행합니다.

    .. php:method:: updateBatch([$set = null[, $value = null[, $batch_size = 100]]])

        :param array $set: 필드 이름 또는 필드/값 쌍의 연관 배열
        :param string $value: $set가 단일 필드인 경우 필드 값
        :param int $batch_size: 단일 쿼리에 그룹화할 조건 수입니다.
        :returns: 업데이트된 행 수 또는 실패 시 ``false``\ 입니다.
        :rtype: mixed

        배치 ``UPDATE``\ 문을 컴파일하고 실행합니다.

        .. note:: ``$batch_size`` 이상의 필드/값 쌍이 제공되면 각각 ``$batch_size`` 필드/값 쌍을 Update하는 여러 쿼리가 실행됩니다.

    .. php:method:: setUpdateBatch($key[, $value = ''[, $escape = null]])

        :param mixed $key: 필드 이름 또는 필드/값 쌍 배열
        :param string $value: $key가 단일 필드인 경우 필드 값
        :param bool $escape: 값을 이스케이프할지 여부
        :returns: ``BaseBuilder`` instance (method chaining)
        :rtype: ``BaseBuilder``

        ``updateBatch()``\ 를 통해 테이블에서 업데이트할 필드/값 쌍을 추가합니다.

    .. php:method:: replace([$set = null])

        :param array $set: 필드/값 쌍의 연관 배열
        :returns: true on success, false on failure
        :rtype: bool

        REPLACE 문을 컴파일하고 실행합니다.

    .. php:method:: delete([$where = ''[, $limit = null[, $reset_data = true]]])

        :param string $where: WHERE 절
        :param int $limit: LIMIT 절
        :param bool $reset_data: 쿼리 "write" 절을 재설정하려면 true
        :returns: ``BaseBuilder`` instance (method chaining) or false on failure
        :rtype: mixed

        DELETE 쿼리를 컴파일하고 실행합니다.

    .. php:method:: increment($column[, $value = 1])

        :param string $column: 증가시킬 열(column)의 이름
        :param int $value:  증가시키는 양

        필드 값을 지정된 양만큼 증가시킵니다.
        필드가 VARCHAR와 같은 숫자 필드가 아닌 경우 $value로 대체될 수 있습니다.

    .. php:method:: decrement($column[, $value = 1])

        :param string $column: 감소시킬 열(column)의 이름
        :param int $value:  감소시키는 양

        필드 값을 지정된 양만큼 감소시킵니다.
        필드가 VARCHAR와 같은 숫자 필드가 아닌 경우 $value로 대체될 수 있습니다.

    .. php:method:: truncate()

        :returns: true on success, false on failure
        :rtype: bool

        테이블에서 TRUNCATE 문을 실행합니다.

        .. note:: 사용중인 데이터베이스 플랫폼이 TRUNCATE를 지원하지 않으면 DELETE 문이 대신 사용됩니다.

    .. php:method:: emptyTable()

        :returns: true on success, false on failure
        :rtype: bool

        DELETE 문을 통해 테이블에서 모든 레코드를 삭제합니다.

    .. php:method:: getCompiledSelect([$reset = true])

        :param bool $reset: 현재 QB 값을 재설정할지 여부
        :returns: 컴파일된 SQL 문의 문자열
        :rtype: string

        SELECT 문을 컴파일하여 문자열로 반환합니다.

    .. php:method:: getCompiledInsert([$reset = true])

        :param bool $reset: 현재 QB 값을 재설정할지 여부
        :returns: 컴파일된 SQL 문의 문자열
        :rtype: string

        INSERT 문을 컴파일하여 문자열로 리턴합니다.

    .. php:method:: getCompiledUpdate([$reset = true])

        :param bool $reset: 현재 QB 값을 재설정할지 여부
        :returns: 컴파일된 SQL 문의 문자열
        :rtype: string

        UPDATE 문을 컴파일하여 문자열로 리턴합니다.

    .. php:method:: getCompiledDelete([$reset = true])

        :param bool $reset: 현재 QB 값을 재설정할지 여부
        :returns: 컴파일된 SQL 문의 문자열
        :rtype: string

        DELETE 문을 컴파일하여 문자열로 리턴합니다.
