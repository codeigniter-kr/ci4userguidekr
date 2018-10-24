###########
View Parser
###########

.. contents::
    :local:
    :depth: 2

The View Parser can perform simple text substitution for
pseudo-variables contained within your view files.
It can parse simple variables or variable tag pairs.
뷰 파서는 뷰 파일에 포함 된 의사 변수에 대해 간단한 텍스트 대체를 수행 할 수 있습니다. 간단한 변수 또는 변수 태그 쌍을 구문 분석 할 수 있습니다.

Pseudo-variable names or control constructs are enclosed in braces, like this
의사 변수 이름이나 제어 구문은 다음과 같이 중괄호로 묶습니다.

::

	<html>
	<head>
		<title>{blog_title}</title>
	</head>
	<body>
		<h3>{blog_heading}</h3>

		{blog_entries}
			<h5>{title}</h5>
			<p>{body}</p>
		{/blog_entries}

	</body>
	</html>

These variables are not actual PHP variables, but rather plain text
representations that allow you to eliminate PHP from your templates
(view files).
이 변수는 실제 PHP 변수가 아니라 템플릿 (보기 파일)에서 PHP를 제거 할 수있는 일반 텍스트 표현입니다.

.. note:: CodeIgniter does **not** require you to use this class since
	using pure PHP in your view pages (for instance using the
	:doc:`View renderer </general/view_renderer>` )
	lets them run a little faster.
	However, some developers prefer to use some form of template engine if
	they work with designers who they feel would find some
	confusion working with PHP.
	CodeIgniter는 보기 페이지에서 순수 PHP를 사용하기 때문에 (예를 들어, 뷰 렌더러를 사용하여 ) 조금 더 빨리 실행할 수 있기 때문에이 클래스를 사용할 것을 요구 하지 않습니다 . 그러나 일부 개발자는 PHP로 작업하는 데 다소 혼란을 느끼는 디자이너와 작업 할 때 어떤 형태의 템플릿 엔진을 선호합니다.

***************************
Using the View Parser Class
***************************

The simplest method to load the parser class is through its service
파서 클래스를로드하는 가장 간단한 방법은 서비스를 이용하는 것입니다.

::

	$parser = \Config\Services::parser();

Alternately, if you are not using the ``Parser`` class as your default renderer, you
can instantiate it directly
또는 Parser클래스를 기본 렌더러로 사용하지 않는 경우 클래스를 직접 인스턴스화 할 수 있습니다.

::

	$parser = new \CodeIgniter\View\Parser();

Then you can use any of the three standard rendering methods that it provides:
**render(viewpath, options, save)**, **setVar(name, value, context)** and
**setData(data, context)**. You will also be able to specify delimiters directly,
through the **setDelimiters(left,right)** method.
그런 다음 render (viewpath, options, save) , setVar (name, value, context) 및 setData (data, context) 의 세 가지 표준 렌더링 메서드를 사용할 수 있습니다 . setDelimiters (왼쪽, 오른쪽) 메소드를 통해 분리 문자를 직접 지정할 수도 있습니다 .

Using the ``Parser``, your view templates are processed only by the Parser
itself, and not like a conventional view PHP script. PHP code in such a script
is ignored by the parser, and only substitutions are performed.
``Parser`` 를 사용하면 뷰 템플릿은 파서 자체만으로 처리되며 일반적인 뷰 PHP 스크립트와는 다릅니다. 이러한 스크립트의 PHP 코드는 파서에 의해 무시되고 대체 만 수행됩니다.

This is purposeful: view files with no PHP.
이것은 목적이 있습니다 : PHP가없는 파일보기.

What It Does
============

The ``Parser`` class processes "PHP/HTML scripts" stored in the application's view path.
These scripts have a ``.php`` extension, but can not contain any PHP.
이 Parser클래스는 애플리케이션의 뷰 경로에 저장된 "PHP / HTML 스크립트"를 처리합니다. 이 스크립트에는 .php확장 기능이 있지만 PHP는 포함 할 수 없습니다.

Each view parameter (which we refer to as a pseudo-variable) triggers a substitution,
based on the type of value you provided for it. Pseudo-variables are not
extracted into PHP variables; instead their value is accessed through the pseudo-variable
syntax, where its name is referenced inside braces.
각 뷰 매개 변수 (의사 변수로 참조)는 사용자가 제공 한 값의 유형에 따라 대체를 트리거합니다. 의사 변수는 PHP 변수로 추출되지 않습니다. 대신 그들의 값은 가상 변수 구문을 통해 액세스됩니다.이 이름은 중괄호 안에 참조됩니다.

The Parser class uses an associative array internally, to accumulate pseudo-variable
settings until you call its ``render()``. This means that your pseudo-variable names
need to be unique, or a later parameter setting will over-ride an earlier one.
Parser 클래스는 연관 배열을 내부적으로 사용하여 의사 변수 설정을 호출 할 때까지 축적합니다 render(). 이는 가상 변수 이름이 고유해야하거나 나중에 매개 변수 설정이 이전 매개 변수를 오버라이드한다는 것을 의미합니다.

This also impacts escaping parameter values for different contexts inside your
script. You will have to give each escaped value a unique parameter name.
이것은 또한 스크립트 내의 다른 컨텍스트에 대한 이스케이프 매개 변수 값에 영향을줍니다. 이스케이프 된 각 값에 고유 한 매개 변수 이름을 지정해야합니다.

Parser templates
================

You can use the ``render()`` method to parse (or render) simple templates,
like this
이 render()메소드를 사용하면 다음과 같이 간단한 템플릿을 구문 분석 (또는 렌더링) 할 수 있습니다 .

::

	$data = [
		'blog_title'   => 'My Blog Title',
		'blog_heading' => 'My Blog Heading'
	];

	echo $parser->setData($data)
	             ->render('blog_template');

View parameters are passed to ``setData()`` as an associative
array of data to be replaced in the template. In the above example, the
template would contain two variables: {blog_title} and {blog_heading}
The first parameter to ``render()`` contains the name of the :doc:`view
file <../general/views>` (in this example the file would be called blog_template.php),
뷰 매개 변수는 setData()템플릿에서 대체 할 데이터의 연관 배열로 전달됩니다 . 위의 예에서 템플릿에는 {blog_title}과 {blog_heading}의 두 변수가 포함됩니다. 첫 번째 매개 변수 render()는 보기 파일 의 이름 을 포함 합니다 (이 예에서는 blog_template.php라고합니다).

Parser Configuration Options
============================

Several options can be passed to the ``render()`` or ``renderString()`` methods.
여러 옵션이 render()또는 renderString()메소드에 전달 될 수 있습니다 .

-   ``cache`` - the time in seconds, to save a view's results; ignored for renderString()
				보기의 결과를 저장하는 시간 (초). renderString ()에서 무시됩니다.
-   ``cache_name`` - the ID used to save/retrieve a cached view result; defaults to the viewpath;
		ignored for renderString()
		캐시 된 뷰 결과를 저장 / 검색하는 데 사용되는 ID. 기본값은 viewpath입니다. renderString ()에서 무시됩니다.
-   ``saveData`` - true if the view data parameters should be retained for subsequent calls;
		default is **false**
		이후의 호출로 뷰 데이터 파라미터를 보관 유지하는 경우는 true, 그렇지 않은 경우는 false 기본값은 false입니다.
-	``cascadeData`` - true if pseudo-variable settings should be passed on to nested
		substitutions; default is **true**
		가상 변수 설정을 중첩에 전달해야하는 경우 true 대체; 기본값은 true입니다.

::

	echo $parser->render('blog_template', [
		'cache'      => HOUR,
		'cache_name' => 'something_unique',
	]);

***********************
Substitution Variations
***********************

There are three types of substitution supported: simple, looping, and nested.
Substitutions are performed in the same sequence that pseudo-variables were added.
지원되는 대체 유형에는 단순, 반복 및 중첩의 세 가지 유형이 있습니다. 대체는 의사 변수가 추가 된 동일한 순서로 수행됩니다.

The **simple substitution** performed by the parser is a one-to-one
replacement of pseudo-variables where the corresponding data parameter
has either a scalar or string value, as in this example
간단한 교체 파서 수행은 해당 데이터 파라미터가이 예와 같이, 하나 또는 문자열 스칼라 값을 갖는 의사 - 변수의 일대일 대체

::

	$template = '<head><title>{blog_title}</title></head>';
	$data     = ['blog_title' => 'My ramblings'];

	echo $parser->setData($data)->renderString($template);

	// Result: <head><title>My ramblings</title></head>

The ``Parser`` takes substitution a lot further with "variable pairs",
used for nested substitutions or looping, and with some advanced
constructs for conditional substitution.
``Parser`` 는 중첩 된 대체 또는 루프에 사용 "변수 쌍"과 조건부 교체의 일부 고급 구조와 많은 추가 대체를합니다.

When the parser executes, it will generally
파서가 실행되면 일반적으로

-	handle any conditional substitutions 조건부 대체를 처리한다.
-	handle any nested/looping substitutions 중첩 / 반복 루핑을 처리합니다.
-	handle the remaining single substitutions 남은 단일 치환을 다룬다.

Loop Substitutions
==================

A loop substitution happens when the value for a pseudo-variable is
a sequential array of arrays, like an array of row settings.
루프 변수는 가상 변수의 값이 배열의 배열과 같은 배열의 순차 배열 일 때 발생합니다.

The above example code allows simple variables to be replaced. What if
you would like an entire block of variables to be repeated, with each
iteration containing new values? Consider the template example we showed
at the top of the page
위의 예제 코드를 사용하면 간단한 변수를 대체 할 수 있습니다. 각 반복에 새로운 값이 포함 된 전체 변수 블록을 반복 하시겠습니까? 페이지 상단에 표시된 템플릿 예제를 고려하십시오.

::

	<html>
	<head>
		<title>{blog_title}</title>
	</head>
	<body>
		<h3>{blog_heading}</h3>

		{blog_entries}
			<h5>{title}</h5>
			<p>{body}</p>
		{/blog_entries}

	</body>
	</html>

In the above code you'll notice a pair of variables: {blog_entries}
data... {/blog_entries}. In a case like this, the entire chunk of data
between these pairs would be repeated multiple times, corresponding to
the number of rows in the "blog_entries" element of the parameters array.
위의 코드에서 {blog_entries} data ... {/ blog_entries} 변수의 한 쌍을 알 수 있습니다. 이와 같은 경우, 이러한 쌍 사이의 전체 데이터 덩어리는 parameters 배열의 "blog_entries"요소에있는 행 수에 해당하는 여러 번 반복됩니다.

Parsing variable pairs is done using the identical code shown above to
parse single variables, except, you will add a multi-dimensional array
corresponding to your variable pair data. Consider this example
변수 쌍을 파싱하는 것은 위에 표시된 동일한 코드를 사용하여 단일 변수를 구문 분석합니다. 단, 변수 쌍 데이터에 해당하는 다차원 배열을 추가합니다. 다음 예제를 고려하십시오.

::

	$data = array(
		'blog_title'   => 'My Blog Title',
		'blog_heading' => 'My Blog Heading',
		'blog_entries' => array(
			['title' => 'Title 1', 'body' => 'Body 1'],
			['title' => 'Title 2', 'body' => 'Body 2'],
			['title' => 'Title 3', 'body' => 'Body 3'],
			['title' => 'Title 4', 'body' => 'Body 4'],
			['title' => 'Title 5', 'body' => 'Body 5']
		)
	);

	echo $parser->setData($data)
	             ->render('blog_template');

The value for the pseudo-variable ``blog_entries`` is a sequential
array of associative arrays. The outer level does not have keys associated
with each of the nested "rows".
의사 변수의 값 blog_entries은 연관 배열의 순차 배열입니다. 외부 레벨에는 각각의 중첩 된 "행"과 연관된 키가 없습니다.

If your "pair" data is coming from a database result, which is already a
multi-dimensional array, you can simply use the database ``getResultArray()``
method
이미 "다차원 배열"인 데이터베이스 결과에서 "쌍"데이터를 가져 오는 경우 데이터베이스 getResultArray() 메서드 를 사용하면됩니다.

::

	$query = $db->query("SELECT * FROM blog");

	$data = array(
		'blog_title'   => 'My Blog Title',
		'blog_heading' => 'My Blog Heading',
		'blog_entries' => $query->getResultArray()
	);

	echo $parser->setData($data)
	             ->render('blog_template');

If the array you are trying to loop over contains objects instead of arrays,
the parser will first look for an ``asArray`` method on the object. If it exists,
that method will be called and the resulting array is then looped over just as
described above. If no ``asArray`` method exists, the object will be cast as
an array and its public properties will be made available to the Parser.
루프를 반복하려는 배열에 배열 대신 객체가 포함되어 있으면 파서는 먼저 객체에 대해 ``asArray`` 메소드를 찾습니다. 존재할 경우 그 메소드를 호출하여 결과의 배열은 전술 한 것처럼 반복 처리됩니다. ``asArray`` 메서드가 존재하지 않는 경우, 객체는 배열로서 캐스트되어 그 퍼블릭 프로퍼티를 Parser가 사용 가능하게됩니다.

This is especially useful with the Entity classes, which has an asArray method
that returns all public and protected properties (minus the _options property) and
makes them available to the Parser.
이것은 특히 모든 public 및 protected 속성 (_options 속성 제외)을 반환하고 파서에서 사용할 수 있도록하는 asArray 메서드가있는 Entity 클래스에서 유용합니다.

Nested Substitutions
====================

A nested substitution happens when the value for a pseudo-variable is
an associative array of values, like a record from a database
중첩 된 대체는 의사 변수의 값이 데이터베이스의 레코드와 같은 값의 연관 배열 일 때 발생합니다.

::

	$data = array(
		'blog_title'   => 'My Blog Title',
		'blog_heading' => 'My Blog Heading',
		'blog_entry'   => array(
			'title' => 'Title 1', 'body' => 'Body 1'
		)
	);

	echo $parser->setData($data)
	             ->render('blog_template');

The value for the pseudo-variable ``blog_entry`` is an associative
array. The key/value pairs defined inside it will be exposed inside
the variable pair loop for that variable.
의사 변수의 값 blog_entry은 연관 배열입니다. 내부에 정의 된 키 / 값 쌍은 해당 변수에 대한 변수 쌍 루프 내부에 노출됩니다.

A ``blog_template`` that might work for the above
blog_template위의 경우 작동 할 수 있는 A

::

	<h1>{blog_title} - {blog_heading}</h1>
	{blog_entry}
		<div>
			<h2>{title}</h2>
			<p>{body}{/p}
		</div>
	{/blog_entry}

If you would like the other pseudo-variables accessible inside the "blog_entry"
scope, then make sure that the "cascadeData" option is set to true.
"blog_entry"범위 내에서 다른 의사 변수에 액세스 할 수있게하려면 "cascadeData"옵션이 true로 설정되어 있는지 확인하십시오.

Comments
========

You can place comments in your templates that will be ignored and removed during parsing by wrapping the
comments in a ``{#  #}`` symbols.
템플릿에 주석을 넣을 수 있습니다 . 이 주석은 심볼에 주석을 래핑하여 구문 분석 중에 무시되고 제거 됩니다.{#  #}

::

	{# This comment is removed during parsing. #}
	{blog_entry}
		<div>
			<h2>{title}</h2>
			<p>{body}{/p}
		</div>
	{/blog_entry}

Cascading Data
==============

With both a nested and a loop substitution, you have the option of cascading
data pairs into the inner substitution.
중첩 및 루프 대체 모두를 사용하면 내부 쌍으로 데이터 쌍을 케스케이드 (cascading) 할 수 있습니다.

The following example is not impacted by cascading
다음 예제는 계단식 배열의 영향을받지 않습니다.

::

	$template = '{name} lives in {location}{city} on {planet}{/location}.';

	$data = [
		'name'     => 'George',
		'location' => [ 'city' => 'Red City', 'planet' => 'Mars' ]
	];

	echo $parser->setData($data)->renderString($template);
	// Result: George lives in Red City on Mars.

This example gives different results, depending on cascading
이 예제는 계단식 배열에 따라 다른 결과를 제공합니다.

::

	$template = '{location}{name} lives in {city} on {planet}{/location}.';

	$data = [
		'name'     => 'George',
		'location' => [ 'city' => 'Red City', 'planet' => 'Mars' ]
	];

	echo $parser->setData($data)->renderString($template, ['cascadeData'=>false]);
	// Result: {name} lives in Red City on Mars.

	echo $parser->setData($data)->renderString($template, ['cascadeData'=>true]);
	// Result: George lives in Red City on Mars.

Preventing Parsing
==================

You can specify portions of the page to not be parsed with the ``{noparse}{/noparse}`` tag pair. Anything in this
section will stay exactly as it is, with no variable substitution, looping, etc, happening to the markup between the brackets.
페이지의 일부를 {noparse}{/noparse}태그 쌍 과 함께 구문 분석하지 않도록 지정할 수 있습니다 . 이 섹션의 내용은 대괄호 사이의 마크 업에 발생하는 변수 대체, 루핑 등이없는 그대로 그대로 유지됩니다.

::

	{noparse}
		<h1>Untouched Code</h1>
	{/noparse}

Conditional Logic
=================

The Parser class supports some basic conditionals to handle ``if``, ``else``, and ``elseif`` syntax. All ``if``
blocks must be closed with an ``endif`` tag
파서 클래스는 처리하기 위해 몇 가지 기본 조건문을 지원 if, else및 elseif구문. 모든 if 블록을 endif태그 로 닫아야합니다 .

::

	{if $role=='admin'}
		<h1>Welcome, Admin!</h1>
	{endif}

This simple block is converted to the following during parsing
이 간단한 블록은 구문 분석하는 동안 다음과 같이 변환됩니다.

::

	<?php if ($role=='admin'): ?>
		<h1>Welcome, Admin!</h1>
	<?php endif ?>

All variables used within if statements must have been previously set with the same name. Other than that, it is
treated exactly like a standard PHP conditional, and all standard PHP rules would apply here. You can use any
of the comparison operators you would normally, like ``==``, ``===``, ``!==``, ``<``, ``>``, etc.
if 문에서 사용되는 모든 변수는 이전에 동일한 이름으로 설정되어 있어야합니다. 그 외, 그것은 표준 PHP 조건문과 똑같이 취급되며 모든 표준 PHP 규칙이 여기에 적용됩니다. 당신은 비교 연산자 당신 것 일반적으로 같은 어떤 사용할 수 있습니다 ==, ===, !==, <, >, 등

::

	{if $role=='admin'}
		<h1>Welcome, Admin</h1>
	{elseif $role=='moderator'}
		<h1>Welcome, Moderator</h1>
	{else}
		<h1>Welcome, User</h1>
	{endif}

.. note:: In the background, conditionals are parsed using an **eval()**, so you must ensure that you take
	care with the user data that is used within conditionals, or you could open your application up to security risks.
	백그라운드에서 조건문은 eval ()을 사용하여 구문 분석 되므로 조건 내에서 사용되는 사용자 데이터를주의 깊게 살펴야하며 그렇지 않으면 보안 위험까지 응용 프로그램을 열 수 있습니다.

Escaping Data
=============

By default, all variable substitution is escaped to help prevent XSS attacks on your pages. CodeIgniter's ``esc`` method
supports several different contexts, like general **html**, when it's in an HTML **attr*, in **css**, etc. If nothing
else is specified, the data will be assumed to be in an HTML context. You can specify the context used by using the **esc**
filter
기본적으로 페이지에 대한 XSS 공격을 막기 위해 모든 변수 대체가 이스케이프 처리됩니다. CodeIgniter의 esc메소드는 일반적인 HTML 과 같은 여러 가지 컨텍스트를 지원 합니다 (HTML attr *, ** css 등). 다른 것이 지정되지 않으면 데이터는 HTML 컨텍스트로 간주됩니다. esc 필터 를 사용하여 사용되는 컨텍스트를 지정할 수 있습니다 .

::

	{ user_styles | esc(css) }
	<a href="{ user_link | esc(attr) }">{ title }</a>

There will be times when you absolutely need something to used and NOT escaped. You can do this by adding exclamation
marks to the opening and closing braces
당신이 절대적으로 필요로하고 탈출하지 않을 때가있을 것입니다. 여는 중괄호와 닫는 중괄호에 느낌표를 추가하여이 작업을 수행 할 수 있습니다.

::

	{! unescaped_var !}

Filters
=======

Any single variable substitution can have one or more filters applied to it to modify the way it is presented. These
are not intended to drastically change the output, but provide ways to reuse the same variable data but with different
presentations. The **esc** filter discussed above is one example. Dates are another common use case, where you might
need to format the same data differently in several sections on the same page.
모든 단일 변수 대체에는 하나 이상의 필터가 적용되어 표시 방법을 수정할 수 있습니다. 이것들은 출력을 크게 변경시키지 않고 동일한 변수 데이터를 재사용 할 수있는 방법을 제공하지만 다른 프리젠 테이션으로 제공합니다. ESC의 상술 된 필터는 하나의 예이다. 날짜는 동일한 페이지의 여러 섹션에서 동일한 데이터를 다르게 형식화해야 할 수도있는 또 다른 일반적인 사용 사례입니다.

Filters are commands that come after the pseudo-variable name, and are separated by the pipe symbol, ``|``
필터는 의사 변수 이름 뒤에 오는 명령이며 파이프 기호 ``|`` 로 구분됩니다

::

	// -55 is displayed as 55
	{ value|abs  }

If the parameter takes any arguments, they must be separated by commas and enclosed in parentheses
매개 변수에 인수가있는 경우 쉼표로 구분하고 괄호로 묶어야합니다.

::

	{ created_at|date(Y-m-d) }

Multiple filters can be applied to the value by piping multiple ones together. They are processed in order, from
left to right
여러 필터를 함께 연결하면 여러 필터를 값에 적용 할 수 있습니다. 그들은 왼쪽에서 오른쪽 순서대로 처리됩니다.

::

	{ created_at|date_modify(+5 days)|date(Y-m-d) }

Provided Filters
----------------

The following filters are available when using the parser:
파서를 사용할 때 다음 필터를 사용할 수 있습니다.

==================== ========================== ==================================================================== =================================
Filter               Arguments                  Description                                                          Example
==================== ========================== ==================================================================== =================================
abs                                             숫자의 절대 값을 표시합니다.                                         { v|abs }
capitalize                                      문장의 첫 문자는 대문자로 나머지는 모두 소문자로 문자열을            { v|capitalize}
                                                표시합니다.
date                 format (Y-m-d)             PHP **date** 호환 형식 문자열.                                       { v|date(Y-m-d) }
date_modify          value to add/subtract      A **strtotime** compatible string to modify the date, like           { v|date_modify(+1 day) }
                                                ``+5 day`` or ``-1 week``.
default              default value              변수가 비어 있거나 정의되지 않은 경우 기본값을 표시합니다.           { v|default(just in case) }
esc                  html, attr, css, js        Specifies the context to escape the data.                            { v|esc(attr) }
excerpt              phrase, radius             Returns the text within a radius of words from a given phrase.       { v|excerpt(green giant, 20) }
                                                Same as **excerpt** helper function.
highlight            phrase                     Highlights a given phrase within the text using '<mark></mark>'
                                                tags.                                                                { v|highlight(view parser) }
highlight_code                                  Highlights code samples with HTML/CSS.                               { v|highlight_code }
limit_chars          limit                      Limits the number of chracters to $limit.                            { v|limit_chars(100) }
limit_words          limit                      Limits the number of words to $limit.                                { v|limit_words(20) }
local_currency       currency, locale           Displays a localized version of a currency. "currency" value is any  { v|local_currency(EUR,en_US) }
                                                3-letter ISO 4217 currency code.
local_number         type, precision, locale    Displays a localized version of a number. "type" can be one of:      { v|local_number(decimal,2,en_US) }
                                                decimal, currency, percent, scientific, spellout, ordinal, duration.
lower                                           Converts a string to lowercase.                                      { v|lower }
nl2br                                           Replaces all newline characters (\n) to an HTML <br/> tag.           { v|nl2br }
number_format        places                     Wraps PHP **number_format** function for use within the parser.      { v|number_format(3) }
prose                                           Takes a body of text and uses the **auto_typography()** method to    { v|prose }
                                                turn it into prettier, easier-to-read, prose.
round                places, type               Rounds a number to the specified places. Types of **ceil** and       { v|round(3) } { v|round(ceil) }
                                                **floor** can be passed to use those functions instead.
strip_tags           allowed chars              Wraps PHP **strip_tags**. Can accept a string of allowed tags.       { v|strip_tags(<br>) }
title                                           Displays a "title case" version of the string, with all lowercase,   { v|title }
                                                and each word capitalized.
upper                                           Displays the string in all uppercase.                                { v|upper }
==================== ========================== ==================================================================== =================================

"local_number" 필터와 관련된 자세한 내용은  `PHP의 NumberFormatter <http://php.net/manual/en/numberformatter.create.php>`_ 를 참조하십시오.

Custom Filters
--------------

You can easily create your own filters by editing **application/Config/View.php** and adding new entries to the
``$filters`` array. Each key is the name of the filter is called by in the view, and its value is any valid PHP
callable
**application/Config/View.php** 를 편집 하고 $filters배열에 새 항목을 추가 하여 자신 만의 필터를 쉽게 만들 수 있습니다 . 각 키는 뷰에서 호출되는 필터의 이름이고, 그 값은 유효한 PHP 호출 가능합니다.

::

	public $filters = [
		'abs'        => '\CodeIgniter\View\Filters::abs',
		'capitalize' => '\CodeIgniter\View\Filters::capitalize',
	];

PHP Native functions as Filters
-------------------------------

You can easily use native php function as filters by editing **application/Config/View.php** and adding new entries to the
``$filters`` array.Each key is the name of the native PHP function is called by in the view, and its value is any valid native PHP
function prefixed with
**application/Config/View.php** 를 편집 하고 $filters배열에 새 항목을 추가하여 기본 PHP 함수를 필터로 쉽게 사용할 수 있습니다 . 각 키는 네이티브 PHP 함수의 이름이며 뷰에서 호출되며 값은 유효한 네이티브입니다 PHP 함수 접두사

::

	public $filters = [
		'str_repeat' => '\str_repeat',
	];

Parser Plugins
==============

Plugins allow you to extend the parser, adding custom features for each project. They can be any PHP callable, making
them very simple to implement. Within templates, plugins are specified by ``{+ +}`` tags
플러그인을 사용하면 파서를 확장하고 각 프로젝트에 사용자 정의 기능을 추가 할 수 있습니다. PHP를 호출 할 수 있기 때문에 매우 간단하게 구현할 수 있습니다. 템플릿 내에서 플러그인은 태그 로 지정됩니다 .{+ +}

::

	{+ foo +} inner content {+ /foo +}

This example shows a plugin named **foo**. It can manipulate any of the content between its opening and closing tags.
In this example, it could work with the text " inner content ". Plugins are processed before any pseudo-variable
replacements happen.
이 예제는 foo 라는 플러그인을 보여줍니다 . 시작 태그와 닫기 태그 사이의 내용을 조작 할 수 있습니다. 이 예제에서는 텍스트 "내부 내용"을 사용할 수 있습니다. 의사 변수 대체가 일어나기 전에 플러그인이 처리됩니다.

While plugins will often consist of tag pairs, like shown above, they can also be a single tag, with no closing tag
플러그인은 종종 위에 표시된 것과 같이 태그 쌍으로 구성되는 경우도 있지만 태그가없는 단일 태그 일 수도 있습니다.

::

	{+ foo +}

Opening tags can also contain parameters that can customize how the plugin works. The parameters are represented as
key/value pairs
여는 태그에는 플러그인 작동 방식을 사용자 정의 할 수있는 매개 변수가 포함될 수도 있습니다. 매개 변수는 키 / 값 쌍으로 표시됩니다.

::

	{+ foo bar=2 baz="x y" }

Parameters can also be single values
매개 변수도 단일 값일 수 있습니다.

::

	{+ include somefile.php +}

Provided Plugins
----------------

The following plugins are available when using the parser:
파서를 사용할 때 다음 플러그인을 사용할 수 있습니다.

==================== ========================== ================================================================================== ================================================================
Plugin               Arguments                  Description                                                           			   Example
==================== ========================== ================================================================================== ================================================================
current_url                                     Alias for the current_url helper function.                            			   {+ current_url +}
previous_url                                    Alias for the previous_url helper function.                           			   {+ previous_url +}
site_url                                        Alias for the site_url helper function                                             {+ site_url "login" +}
mailto               email, title, attributes   Alias for the mailto helper function.                                 			   {+ mailto email=foo@example.com title="Stranger Things" +}
safe_mailto          email, title, attributes   Alias for the safe_mailto helper function.                            			   {+ safe_mailto email=foo@example.com title="Stranger Things" +}
lang                 language string            Alias for the lang helper function.                                    			   {+ lang number.terabyteAbbr +}
validation_errors    fieldname(optional)        Returns either error string for the field (if specified) or all validation errors. {+ validation_errors +} , {+ validation_errors field="email" +}
route                route name                 Alias for the route_to helper function                                             {+ route "login" +}
==================== ========================== ================================================================================== ================================================================

Registering a Plugin
--------------------

At its simplest, all you need to do to register a new plugin and make it ready for use is to add it to the
**application/Config/View.php**, under the **$plugins** array. The key is the name of the plugin that is
used within the template file. The value is any valid PHP callable, including static class methods, and closures
가장 간단한 방법으로 새 플러그인을 등록하고 사용할 준비를하기 위해 $ plugins 배열 아래 **application/Config/View.php** 에 추가하기만 하면 됩니다. 키는 템플릿 파일 내에서 사용되는 플러그인의 이름입니다. 값은 정적 클래스 메소드 및 클로저를 포함하여 유효한 PHP 호출 가능 클래스입니다.

::

	public $plugins = [
		'foo'	=> '\Some\Class::methodName',
		'bar'	=> function($str, array $params=[]) {
			return $str;
		},
	];

If the callable is on its own, it is treated as a single tag, not a open/close one. It will be replaced by
the return value from the plugin
호출 가능 객체가 자체적으로 존재하는 경우, 하나의 태그로 처리되고 열기 / 닫기 태그로 처리되지 않습니다. 플러그인의 반환 값으로 대체됩니다.

::

	public $plugins = [
		'foo'	=> '\Some\Class::methodName'
	];

	// Tag is replaced by the return value of Some\Class::methodName static function.
	{+ foo +}

If the callable is wrapped in an array, it is treated as an open/close tag pair that can operate on any of
the content between its tags
호출 가능 객체가 배열에 래핑 된 경우 태그 사이의 내용에서 작동 할 수있는 열기 / 닫기 태그 쌍으로 처리됩니다.

::

	public $plugins = [
		'foo' => ['\Some\Class::methodName']
	];

	{+ foo +} inner content {+ /foo +}

***********
Usage Notes
***********

If you include substitution parameters that are not referenced in your
template, they are ignored
템플릿에서 참조되지 않은 대체 매개 변수를 포함하면 무시됩니다.

::

	$template = 'Hello, {firstname} {lastname}';
	$data = array(
		'title' => 'Mr',
		'firstname' => 'John',
		'lastname' => 'Doe'
	);
	echo $parser->setData($data)
	             ->renderString($template);

	// Result: Hello, John Doe

If you do not include a substitution parameter that is referenced in your
template, the original pseudo-variable is shown in the result
템플릿에서 참조되는 대체 매개 변수를 포함하지 않으면 원래의 의사 변수가 결과에 표시됩니다.

::

	$template = 'Hello, {firstname} {initials} {lastname}';
	$data = array(
		'title'     => 'Mr',
		'firstname' => 'John',
		'lastname'  => 'Doe'
	);
	echo $parser->setData($data)
	             ->renderString($template);

	// Result: Hello, John {initials} Doe

If you provide a string substitution parameter when an array is expected,
i.e. for a variable pair, the substitution is done for the opening variable
pair tag, but the closing variable pair tag is not rendered properly
배열이 예상 될 때 문자열 대입 매개 변수를 제공하면 (즉, 변수 쌍의 경우) 여는 변수 쌍 태그에 대해 대체가 수행되지만 닫기 변수 쌍 태그가 올바르게 렌더링되지 않습니다.

::

	$template = 'Hello, {firstname} {lastname} ({degrees}{degree} {/degrees})';
	$data = array(
		'degrees'   => 'Mr',
		'firstname' => 'John',
		'lastname'  => 'Doe',
		'titles'    => array(
			array('degree' => 'BSc'),
			array('degree' => 'PhD')
		)
	);
	echo $parser->setData($data)
	             ->renderString($template);

	// Result: Hello, John Doe (Mr{degree} {/degrees})

View Fragments
==============

You do not have to use variable pairs to get the effect of iteration in
your views. It is possible to use a view fragment for what would be inside
a variable pair, and to control the iteration in your controller instead
of in the view.
뷰에서 반복 효과를 얻기 위해 변수 쌍을 사용할 필요는 없습니다. 변수 쌍 내부에있는 뷰 조각을 사용하고 뷰가 아닌 컨트롤러에서 반복을 제어 할 수 있습니다.

An example with the iteration controlled in the view
뷰에서 제어되는 반복을 사용한 예

::

	$template = '<ul>{menuitems}
		<li><a href="{link}">{title}</a></li>
	{/menuitems}</ul>';

	$data = array(
		'menuitems' => array(
			array('title' => 'First Link', 'link' => '/first'),
			array('title' => 'Second Link', 'link' => '/second'),
		)
	);
	echo $parser->setData($data)
	             ->renderString($template);

결과

::

	<ul>
		<li><a href="/first">First Link</a></li>
		<li><a href="/second">Second Link</a></li>
	</ul>

An example with the iteration controlled in the controller,
using a view fragment::

	$temp = '';
	$template1 = '<li><a href="{link}">{title}</a></li>';
	$data1 = array(
		array('title' => 'First Link', 'link' => '/first'),
		array('title' => 'Second Link', 'link' => '/second'),
	);

	foreach ($data1 as $menuitem)
	{
		$temp .= $parser->setData($menuItem)->renderString();
	}

	$template = '<ul>{menuitems}</ul>';
	$data = array(
		'menuitems' => $temp
	);
	echo $parser->setData($data)
	             ->renderString($template);

Result::

	<ul>
		<li><a href="/first">First Link</a></li>
		<li><a href="/second">Second Link</a></li>
	</ul>

***************
Class Reference
***************

.. php:class:: CodeIgniter\\View\\Parser

	.. php:method:: render($view[, $options[, $saveData=false]]])

		:param  string  $view: File name of the view source
		:param  array   $options: Array of options, as key/value pairs
		:param  boolean $saveData: If true, will save data for use with any other calls, if false, will clean the data after rendering the view.
		:returns: The rendered text for the chosen view
		:rtype: string

    		Builds the output based upon a file name and any data that has already been set::

			echo $parser->render('myview');

        Options supported:

	        -   ``cache`` - the time in seconds, to save a view's results
	        -   ``cache_name`` - the ID used to save/retrieve a cached view result; defaults to the viewpath
	        -   ``cascadeData`` - true if the data pairs in effect when a nested or loop substitution occurs should be propagated
	        -   ``saveData`` - true if the view data parameter should be retained for subsequent calls
	        -   ``leftDelimiter`` - the left delimiter to use in pseudo-variable syntax
	        -   ``rightDelimiter`` - the right delimiter to use in pseudo-variable syntax

		Any conditional substitutions are performed first, then remaining
		substitutions are performed for each data pair.

	.. php:method:: renderString($template[, $options[, $saveData=false]]])

		:param  string  $template: View source provided as a string
    		:param  array   $options: Array of options, as key/value pairs
    		:param  boolean $saveData: If true, will save data for use with any other calls, if false, will clean the data after rendering the view.
    		:returns: The rendered text for the chosen view
    		:rtype: string

    		Builds the output based upon a provided template source and any data that has already been set::

			echo $parser->render('myview');

        Options supported, and behavior, as above.

	.. php:method:: setData([$data[, $context=null]])

		:param  array   $data: Array of view data strings, as key/value pairs
    		:param  string  $context: The context to use for data escaping.
    		:returns: The Renderer, for method chaining
    		:rtype: CodeIgniter\\View\\RendererInterface.

    		Sets several pieces of view data at once::

			$renderer->setData(['name'=>'George', 'position'=>'Boss']);

        Supported escape contexts: html, css, js, url, or attr or raw.
		If 'raw', no escaping will happen.

	.. php:method:: setVar($name[, $value=null[, $context=null]])

		:param  string  $name: Name of the view data variable
    		:param  mixed   $value: The value of this view data
    		:param  string  $context: The context to use for data escaping.
    		:returns: The Renderer, for method chaining
    		:rtype: CodeIgniter\\View\\RendererInterface.

    		Sets a single piece of view data::

			$renderer->setVar('name','Joe','html');

        Supported escape contexts: html, css, js, url, attr or raw.
		If 'raw', no escaping will happen.

	.. php:method:: setDelimiters($leftDelimiter = '{', $rightDelimiter = '}')

		:param  string  $leftDelimiter: Left delimiter for substitution fields
    		:param  string  $rightDelimiter: right delimiter for substitution fields
    		:returns: The Renderer, for method chaining
    		:rtype: CodeIgniter\\View\\RendererInterface.

    		Over-ride the substitution field delimiters::

			$renderer->setDelimiters('[',']');
