#####################
HTML Table 클래스
#####################

테이블 클래스는 배열 또는 데이터베이스 결과 세트에서 HTML 테이블을 자동 생성할 수있는 메소드를 제공합니다.

.. contents::
    :local:
    :depth: 2

*********************
Table 클래스 사용
*********************

클래스 초기화
======================

Table 클래스는 서비스로 제공되지 않으며 "일반적으로" 인스턴스화해야 합니다.

::

	$table = new \CodeIgniter\View\Table();

Examples
========

다음은 다차원 배열에서 테이블을 만드는 방법을 보여주는 예입니다.
첫 번째 배열 인덱스는 테이블 제목이 됩니다(또는 아래 함수 참조에 설명된 ``setHeading()`` 메소드를 사용하여 자신의 제목을 설정할 수 있습니다).

::

	$table = new \CodeIgniter\View\Table();

	$data = [
		['Name', 'Color', 'Size'],
		['Fred', 'Blue', 'Small'],
		['Mary', 'Red', 'Large'],
		['John', 'Green', 'Medium']
	];

	echo $table->generate($data);

다음은 데이터베이스 쿼리 결과에서 생성된 테이블의 예입니다.
테이블 클래스는 테이블 이름을 기반으로 자동으로 제목을 생성합니다(또는 아래 함수 참조에 설명된 ``setHeading()`` 메소드를 사용하여 자신의 제목을 설정할 수 있습니다).

::

	$table = new \CodeIgniter\View\Table();

	$query = $db->query('SELECT * FROM my_table');

	echo $table->generate($query);

다음은 이산 매개 변수를 사용하여 테이블을 작성하는 예입니다.

::

	$table = new \CodeIgniter\View\Table();

	$table->setHeading('Name', 'Color', 'Size');

	$table->addRow('Fred', 'Blue', 'Small');
	$table->addRow('Mary', 'Red', 'Large');
	$table->addRow('John', 'Green', 'Medium');

	echo $table->generate();

개별 매개 변수대신 배열이 사용하는 동일한 예가 있습니다.

::

	$table = new \CodeIgniter\View\Table();

	$table->setHeading(['Name', 'Color', 'Size']);

	$table->addRow(['Fred', 'Blue', 'Small']);
	$table->addRow(['Mary', 'Red', 'Large']);
	$table->addRow(['John', 'Green', 'Medium']);

	echo $table->generate();

테이블 모양 변경
===============================

테이블 클래스를 사용하면 레이아웃 디자인을 지정할 수있는 테이블 템플릿을 설정할 수 있습니다.
템플릿 프로토 타입은 다음과 같습니다.

::

    $template = [
        'table_open'         => '<table border="0" cellpadding="4" cellspacing="0">',

        'thead_open'         => '<thead>',
        'thead_close'        => '</thead>',

        'heading_row_start'  => '<tr>',
        'heading_row_end'    => '</tr>',
        'heading_cell_start' => '<th>',
        'heading_cell_end'   => '</th>',

        'tfoot_open'         => '<tfoot>',
        'tfoot_close'        => '</tfoot>',

        'footing_row_start'  => '<tr>',
        'footing_row_end'    => '</tr>',
        'footing_cell_start' => '<td>',
        'footing_cell_end'   => '</td>',

        'tbody_open'         => '<tbody>',
        'tbody_close'        => '</tbody>',

        'row_start'          => '<tr>',
        'row_end'            => '</tr>',
        'cell_start'         => '<td>',
        'cell_end'           => '</td>',

        'row_alt_start'      => '<tr>',
        'row_alt_end'        => '</tr>',
        'cell_alt_start'     => '<td>',
        'cell_alt_end'       => '</td>',

        'table_close'        => '</table>'
    ];

    $table->setTemplate($template);

.. note:: 템플릿에는 두 개의 "행" 블록 세트가 있습니다. 이를 통해 데이터를 나타내는 행별 배경색 또는 디자인 요소를 번갈아 나오도록 만들수 있습니다.

완전한 템플릿을 제출할 필요는 없습니다.
레이아웃의 일부만 변경해야하는 경우 해당 요소만 제출하면 됩니다.
이 예에서는 테이블 열기 태그만 변경됩니다.

::

	$template = [
		'table_open' => '<table border="1" cellpadding="2" cellspacing="1" class="mytable">'
	];

	$table->setTemplate($template);
	
템플릿 설정 배열을 Table 클래스 생성자에 전달하여 기본값을 설정할 수도 있습니다.

::

	$customSettings = [
		'table_open' => '<table border="1" cellpadding="2" cellspacing="1" class="mytable">'
	];

	$table = new \CodeIgniter\View\Table($customSettings);


***************
Class Reference
***************

.. php:class:: Table

	.. attribute:: $function = null

		모든 셀 데이터에 PHP 함수 또는 유효한 함수 배열 객체를 지정할 수 있습니다.

		::

			$table = new \CodeIgniter\View\Table();

			$table->setHeading('Name', 'Color', 'Size');
			$table->addRow('Fred', '<strong>Blue</strong>', 'Small');

			$table->function = 'htmlspecialchars';
			echo $table->generate();

		위의 예제에서 모든 셀 데이터는 PHP의 :php:func:`htmlspecialchars()` 함수를 통해 실행됩니다.
		
		::

			<td>Fred</td><td>&lt;strong&gt;Blue&lt;/strong&gt;</td><td>Small</td>

	.. php:method:: generate([$tableData = null])

		:param	mixed	$tableData: 테이블 행을 채울 데이터
		:returns:	HTML table
		:rtype:	string

		생성 된 테이블이 포함된 문자열을 리턴합니다. 배열 또는 데이터베이스 결과 객체일 수 있는 선택적 매개 변수를 승인합니다.

	.. php:method:: setCaption($caption)

		:param	string	$caption: 테이블 캡션
		:returns:	메소드 체이닝을 위한 Table 객체
		:rtype:	Table

		테이블에 캡션을 추가합니다.

		::

			$table->setCaption('Colors');

	.. php:method:: setHeading([$args = [] [, ...]])

		:param	mixed	$args: 테이블 열 제목 배열 또는 문자열
		:returns:	메소드 체이닝을 위한 Table 객체
		:rtype:	Table

		배열 또는 이산 매개 변수를 통하여 테이블 제목을 설정합니다. 
		
		::

			$table->setHeading('Name', 'Color', 'Size'); // or

			$table->setHeading(['Name', 'Color', 'Size']);

	.. php:method:: setFooting([$args = [] [, ...]])

		:param	mixed	$args: 테이블 푸터(footer) 배열 또는 문자열
		:returns:	메소드 체이닝을 위한 Table 객체
		:rtype:	Table

		배열 또는 이산 매개 변수를 통하여 테이블 푸터(footer)를 설정합니다. 
		
		::

			$table->setFooting('Subtotal', $subtotal, $notes); // or

			$table->setFooting(['Subtotal', $subtotal, $notes]);

	.. php:method:: addRow([$args = [][, ...]])

		:param	mixed	$args: 행에 출력될 배열 또는 문자열
		:returns:	메소드 체이닝을 위한 Table 객체
		:rtype:	Table

		배열 또는 이산 매개 변수를 통하여 테이블 행(row)를 설정합니다. 
		
		::

			$table->addRow('Blue', 'Red', 'Green'); // or

			$table->addRow(['Blue', 'Red', 'Green']);

		개별 셀의 태그 속성을 설정하려면 해당 셀에 대해 연관 배열을 사용할 수 있습니다.
		연관 키 **data**\ 는 셀의 데이터를 정의합니다. 
		key => val 쌍은 HTML 태그 key='val' 속성(attribute)으로 추가됩니다.
		
		::

			$cell = ['data' => 'Blue', 'class' => 'highlight', 'colspan' => 2];
			$table->addRow($cell, 'Red', 'Green');

			// generates
			// <td class='highlight' colspan='2'>Blue</td><td>Red</td><td>Green</td>

	.. php:method:: makeColumns([$array = [] [, $columnLimit = 0]])

		:param	array	$array: 여러 행의 데이터를 포함하는 배열
		:param	int	$columnLimit: 테이블의 열 수
		:returns:	HTML 테이블 열
		:rtype:	array

		이 방법은 1차원 배열을 사용하여 원하는 열과 동일한 깊이를 가진 다차원 배열을 만듭니다.
		이를 이용하여 고정된 열 수를 가진 테이블에 많은 요소가 있는 단일 배열을 표시 할 수 있습니다. 다음 예를 고려하십시오::

			$list = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve'];

			$newList = $table->makeColumns($list, 3);

			$table->generate($newList);

			// Generates a table with this prototype

			<table border="0" cellpadding="4" cellspacing="0">
			<tr>
			<td>one</td><td>two</td><td>three</td>
			</tr><tr>
			<td>four</td><td>five</td><td>six</td>
			</tr><tr>
			<td>seven</td><td>eight</td><td>nine</td>
			</tr><tr>
			<td>ten</td><td>eleven</td><td>twelve</td></tr>
			</table>


	.. php:method:: setTemplate($template)

		:param	array	$template: 템플릿 값을 포함하는 연관 배열
		:returns:	성공하면 true, 실패하면 false
		:rtype:	bool

		전체 또는 부분 템플릿을 설정합니다.

		::

			$template = [
				'table_open'  => '<table border="1" cellpadding="2" cellspacing="1" class="mytable">'
			];
		
			$table->setTemplate($template);

	.. php:method:: setEmpty($value)

		:param	mixed	$value: 빈 셀에 넣을 값
		:returns:	메소드 체이닝을 위한 Table 객체
		:rtype:	Table

		비어있는 테이블 셀에서 사용할 기본값을 설정합니다.
		다음 예는 빈칸(&nbsp;)을 설정합니다
		
		::

			$table->setEmpty("&nbsp;");

	.. php:method:: clear()

		:returns:	메소드 체이닝을 위한 Table 객체
		:rtype:	Table

		테이블 제목, 행 데이터 및 캡션을 지웁니다.
		데이터가 다른 여러 테이블을 표시할 때 ,사용한 이전 테이블 정보를 삭제합니다.

		Example ::

			$table = new \CodeIgniter\View\Table();


			$table->setCaption('Preferences')
				->setHeading('Name', 'Color', 'Size')
				->addRow('Fred', 'Blue', 'Small')
				->addRow('Mary', 'Red', 'Large')
				->addRow('John', 'Green', 'Medium');

			echo $table->generate();

			$table->clear();

			$table->setCaption('Shipping')
				->setHeading('Name', 'Day', 'Delivery')
				->addRow('Fred', 'Wednesday', 'Express')
				->addRow('Mary', 'Monday', 'Air')
				->addRow('John', 'Saturday', 'Overnight');

			echo $table->generate();
