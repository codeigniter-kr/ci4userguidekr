##################################
데이터베이스 빠른 시작: 샘플 코드
##################################

다음 페이지에는 데이터베이스 클래스 사용 방법을 보여주는 예제 코드가 있습니다. 자세한 내용은 각 기능을 설명하는 개별 페이지를 참조하십시오.

데이터베이스 클래스 초기화
===============================

The following code loads and initializes the database class based on
your :doc:`configuration <configuration>` settings::

	$db = \Config\Database::connect();

클래스가 로드되면 아래에서 설명하는대로 사용할 수 있습니다.

Note: If all your pages require database access you can connect
automatically. See the :doc:`connecting <connecting>` page for details.

Standard Query With Multiple Results (Object Version)
=====================================================

::

	$query = $db->query('SELECT name, title, email FROM my_table');
	$results = $query->getResult();

	foreach ($results as $row)
	{
		echo $row->title;
		echo $row->name;
		echo $row->email;
	}

	echo 'Total Results: ' . count($results);

The above getResult() function returns an array of **objects**. Example:
$row->title

Standard Query With Multiple Results (Array Version)
====================================================

::

	$query   = $db->query('SELECT name, title, email FROM my_table');
	$results = $query->getResultArray();

	foreach ($results as $row)
	{
		echo $row['title'];
		echo $row['name'];
		echo $row['email'];
	}

The above getResultArray() function returns an array of standard array
indexes. Example: $row['title']

Standard Query With Single Result
=================================

::

	$query = $db->query('SELECT name FROM my_table LIMIT 1');
	$row   = $query->getRow();
	echo $row->name;

The above getRow() function returns an **object**. Example: $row->name

Standard Query With Single Result (Array version)
=================================================

::

	$query = $db->query('SELECT name FROM my_table LIMIT 1');
	$row   = $query->getRowArray();
	echo $row['name'];

The above getRowArray() function returns an **array**. Example:
$row['name']

Standard Insert
===============

::

	$sql = "INSERT INTO mytable (title, name) VALUES (".$db->escape($title).", ".$db->escape($name).")";
	$db->query($sql);
	echo $db->getAffectedRows();

Query Builder Query
===================

The :doc:`Query Builder Pattern <query_builder>` gives you a simplified
means of retrieving data::

	$query = $db->table('table_name')->get();

	foreach ($query->getResult() as $row)
	{
		echo $row->title;
	}

The above get() function retrieves all the results from the supplied
table. The :doc:`Query Builder <query_builder>` class contains a full
compliment of functions for working with data.

Query Builder Insert
====================

::

	$data = [
		'title' => $title,
		'name'  => $name,
		'date'  => $date
	];

	$db->table('mytable')->insert($data);  // Produces: INSERT INTO mytable (title, name, date) VALUES ('{$title}', '{$name}', '{$date}')

