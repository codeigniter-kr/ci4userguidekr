####################
뷰 파서(View Parser)
####################

.. contents::
    :local:
    :depth: 2

뷰 파서는 뷰 파일에 포함된 유사 변수에 대한 간단한 텍스트 대체를 수행합니다.
간단한 변수 또는 변수 태그 쌍을 구문 분석할 수 있습니다.

유사 변수 이름 또는 제어 구문은 다음과 같이 중괄호로 묶습니다.

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

이러한 유사변수는 실제 PHP 변수가 아니며 템플릿(뷰 파일)에서 PHP 코드를 제거할 수 있는 일반 텍스트 표현입니다.

.. note:: CodeIgniter는 뷰 페이지에서 순수 PHP를 사용하면(예를 들면 doc:`뷰 랜더러 </outgoing/view_renderer>`) 좀 더 빠르게 실행할 수 있으므로 이 클래스를 사용할 필요가 없습니다.
	그러나 일부 개발자는 PHP를 사용하는데 혼란을 느끼는 디자이너와 함께 작업할 경우 특정 형식의 템플릿 엔진을 선호합니다.

***************************
뷰 파서 클래스 사용하기
***************************

파서 클래스를 로드하는 가장 간단한 방법은 서비스를 통하는 것입니다.

.. literalinclude:: view_parser/001.php

``Parser`` 클래스를 기본 렌더러로 사용하지 않는다면 직접 인스턴스화할 수 있습니다

.. literalinclude:: view_parser/002.php

로드가 완료되면 제공하는 세 가지 표준 렌더링 방법중 하나를 사용할 수 있습니다 : ``render()``, ``setVar()``, ``setData()``. 
``setDelimiters()`` 메소드를 통해 구분자를 직접 지정할 수도 있습니다.

.. important:: ``Parser``\ 를 사용한 뷰 템플릿은 일반적인 뷰 PHP 스크립트와 달리 파서에서만 처리됩니다. 뷰 템플릿에 포함된 PHP 코드는 파서에 의해 무시되며 대체 코드만 수행됩니다.

.. note:: 이것의 목적: PHP 코드가 없는 뷰 파일.

파서가 하는 일
==================

``Parser`` 클래스는 어플리케이션의 뷰 경로에 저장된 "PHP/HTML 스크립트"\ 를 처리합니다.
이 스크립트는 PHP 코드를 포함할 수 없습니다.

각 뷰의 매개 변수(의사 변수라고 함)는 사용자가 제공한 값의 유형에 따라 대체를 유발합니다.
유사 변수는 PHP 변수로 추출되지 않습니다. 
그 대신 값은 유사 변수 구문을 통해 액세스되며 이름은 중괄호 안에서 참조됩니다.

Parser 클래스는 내부적으로 연관 배열을 사용하여 ``render()``\ 를 호출 할 때까지 의사 변수 설정을 누적합니다.
이는 의사 변수 이름이 고유해야 하거나, 나중에 설정된 매개 변수가 같은 이름의 이전 매개 변수보다 우선함을 의미합니다.

또한 스크립트 내부의 다른 컨텍스트에 대한 이스케이프 매개 변수 값에 영향을 줍니다.
이스케이프된 각 값에 고유한 매개 변수 이름을 지정해야 합니다.

파서 템플릿
================

``render()`` 메소드를 사용하여 다음과 같이 간단한 템플릿을 구문 분석(또는 렌더링)할 수 있습니다.

.. literalinclude:: view_parser/003.php

뷰 파라미터는 템플릿에서 교체할 데이터의 연관 배열로 ``setData()``\ 에 전달됩니다.
위 예제에서 템플릿은 두 개의 변수를 포함합니다: ``{blog_title}``\ 과 ``{blog_heading}``
``render()``\ 에 대한 첫 번째 매개 변수는 :doc:`뷰 파일 </outgoing/views>`\ 의 이름입니다. 
여기서 *log_template*\ 가 뷰 파일의 이름입니다.

.. important:: 파일 확장자가 생략되면 뷰 확장자는 .php입니다.

파서 구성 옵션
============================

``render()`` 또는 ``renderString()`` 메소드에 여러 옵션을 전달할 수 있습니다.

-   ``cache`` - 뷰 결과를 저장하는 시간(초); renderString()은 무시
-   ``cache_name`` - 캐시된 뷰 결과를 저장/검색하는데 사용되는 ID; 기본적으로 viewpath; renderString()은 무시
-   ``saveData`` - 후속 호출에 대해 뷰 데이터 매개 변수를 유지해야 하는 경우 true, 기본 값은 **true**
-	``cascadeData`` - 의사 변수 설정을 중첩된 대체로 전달해야 하는 경우 true; 기본 값은 **true**

.. literalinclude:: view_parser/004.php

***********************
대체 변형
***********************

대체 유형은 세 가지가 지원됩니다: simple, looping, nested.
유사 변수가 추가된 것과 동일한 순서로 대체가 수행됩니다.

파서가 수행하는 **단순 치환**\ 은 아래 예에서와 같이 해당 데이터 매개 변수에 스칼라 또는 문자열 값이 있는 의사 변수의 일대일 대체입니다.

.. literalinclude:: view_parser/005.php

``Parser``\ 는 중첩된 대체 또는 루프에 사용되는 "변수 쌍"\ 과 조건부 대체를 위한 고급 구성으로 대체를 훨씬 더 많이 수행합니다.

파서는 실행될 때 일반적으로

-	조건부 대체 처리
-	중첩/루프 대체 처리
-	나머지 단일 치환 처리

루프 대체
==================

의사 변수의 값이 배열의 순차적 배열인 경우 루프 대체가 발생합니다.

위의 예제 코드를 사용하면 간단한 변수를 바꿀 수 있습니다.
각 루프마다 새로운 값이 포함된 전체 변수 블록을 반복하려면 어떻게해야 합니까?
페이지 상단에 표시된 템플릿 예제를 고려하십시오.

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

위의 코드에서 한 쌍의 변수를 볼 수 있습니다: ``{blog_entries}`` data... ``{/blog_entries}``. 
이와 같은 경우에, 이들 쌍들 사이의 전체 데이터 청크는 파라미터 배열의 "blog_entries" 요소의 행 수에 대응하여 여러 번 반복 됩니다.

변수 쌍 구문 분석은 단일 변수를 구문 분석하기 위해 위에 표시된 동일한 코드를 사용하지만 데이터에 다차원 배열을 추가합니다.
아래 예제를 고려하십시오

.. literalinclude:: view_parser/006.php

의사 변수 ``blog_entries``\ 의 값은 일련의 연관 배열입니다.
외부 레벨은 중첩된 "행"\ 과 관련된 키를 가지고 있지 않습니다.

데이터가 다차원 배열인 결과를 데이터베이스에서 얻고 싶다면 ``getResultArray()`` 메소드를 사용하면 됩니다.

.. literalinclude:: view_parser/007.php

반복하려는 배열에 배열 대신 객체라면 파서는 먼저 객체에서 ``asArray()`` 메소드를 찾습니다.
``asArray()`` 메소드가 존재한다면 해당 메소드를 호출하여 얻은 결과 배열을 위에서 설명한대로 반복합니다.
``asArray()`` 메소드가 없으면 객체가 배열로 캐스트(cast)되고 해당 퍼블릭 속성이 파서에 제공됩니다.

이는 파서가 사용할 수 있는 asArray 메소드가 있는 Entity 클래스에 특히 유용합니다.

중첩된 대체
====================

의사 변수의 값이 데이터베이스의 레코드와 같은 연관 배열인 경우 중첩 대체가 발생합니다.

.. literalinclude:: view_parser/008.php

의사 변수 ``blog_entry``\ 의 값은 연관 배열이며 각 키/값 쌍은 해당 변수의 루프안에 노출됩니다.

위와 데이터로 작동하는 **blog_template.php**

::

	<h1>{blog_title} - {blog_heading}</h1>
	{blog_entry}
		<div>
			<h2>{title}</h2>
			<p>{body}</p>
		</div>
	{/blog_entry}

``blog_entry`` 범위내에서 다른 유사 변수에 액세스할 수 있도록 하려면 ``cascadeData`` 옵션이 true로 설정되어 있는지 확인하십시오.

주석
========

주석은 ``{#  #}`` 기호로 묶어 템플릿에 배치할 수 있으며, 파싱(Parsing)하면서 무시되고 제거됩니다.

::

	{# This comment is removed during parsing. #}
	{blog_entry}
		<div>
			<h2>{title}</h2>
			<p>{body}</p>
		</div>
	{/blog_entry}

계단식 데이터
================

중첩 및 루프 대체 둘 다 데이터 쌍을 계단식으로 배열할 수 있습니다.

다음 예제는 계단식의 영향을 받지 않습니다.

.. literalinclude:: view_parser/009.php

이 예는 계단식 배열에 따라 다른 결과를 제공합니다

.. literalinclude:: view_parser/010.php

파싱 방지
==================

파싱되지 않아야 하는 페이지 부분을 ``{noparse}`` ``{/noparse}`` 태그 쌍을 사용하여 지정할 수 있습니다.
이 섹션의 모든 내용은 변수 대체, 루핑등이 발생하지 않고 그대로 유지됩니다.

::

	{noparse}
		<h1>Untouched Code</h1>
	{/noparse}

논리 조건
=================

파서 클래스는 ``if``, ``else``, ``elseif`` 구문을 처리하기 위한 몇 가지 기본 조건을 지원합니다.
모든 ``if`` 블록은 ``endif`` 태그로 닫아야 합니다.

::

	{if $role=='admin'}
		<h1>Welcome, Admin!</h1>
	{endif}

이 블록은 파싱할 때 다음과 같이 변환됩니다.

.. literalinclude:: view_parser/011.php

if 문에 사용된 모든 변수는 이전과 같은 이름으로 설정되어 있어야 합니다.
그 외 나머지는 표준 PHP 조건부와 동일하게 취급되며 모든 표준 PHP 규칙이 여기에 적용됩니다.
``==``, ``===``, ``!==``, ``<``, ``>``\ 등과 같은 일반적으로 사용하는 비교 연산자를 사용할 수 있습니다.

::

	{if $role=='admin'}
		<h1>Welcome, Admin</h1>
	{elseif $role=='moderator'}
		<h1>Welcome, Moderator</h1>
	{else}
		<h1>Welcome, User</h1>
	{endif}

.. warning:: 백그라운드에서 ``eval()``\ 을 사용하여 조건부 구문을 분석하므로 조건부에서 사용되는 사용자 데이터를 주의하여 관리해야합니다. 그렇지 않으면 보안 위험에 따라 어플리케이션 코드가 노출될 수 있습니다.

조건부 구분 기호 변경
-----------------------

템플릿에 다음과 같은 JavaScript 코드가 있는 경우 조건부로 해석될 수 있는 문자열이 있기 때문에 구문 분석기가 구문 오류를 발생시킵니다.

::

    <script type="text/javascript">
        var f = function() {
            if (hasAlert) {
                alert('{message}');
            }
        }
    </script>

다음은 잘못된 해석을 피하기 위해 ``setConditionalDelimiters()`` 메소드를 사용하여 구분 기호를 조건부로 변경할 수 있습니다.

.. literalinclude:: view_parser/027.php

다음은 템플릿에 코드를 작성합니다.

::

    {% if $role=='admin' %}
        <h1>Welcome, Admin</h1>
    {% else %}
        <h1>Welcome, User</h1>
    {% endif %}

이스케이프 데이터
====================

기본적으로 XSS 공격을 방지하기 위해 페이지의 모든 변수 대체는 이스케이프됩니다.
CodeIgniter의 ``esc()`` 메소드는 HTML ``attr``, ``css``\ 등을 위해 ``html``\ 과 같은 여러 가지 컨텍스트를 지원합니다.
컨텍스트를 지정하지 않으면 데이터는 HTML로 간주됩니다.
``esc()`` 필터를 사용하여 컨텍스트 지정을 바꿀 수 있습니다.

::

	{ user_styles | esc(css) }
	<a href="{ user_link | esc(attr) }">{ title }</a>

이스케이프되지 않아야 할 것이 절대적으로 필요할 때가 있습니다.
여는 중괄호({)와 닫는 중괄호(})에 느낌표(!)를 추가하면 됩니다.

::

	{! unescaped_var !}

필터
=======

단일 변수 대체는 표시되는 방식을 수정하기 위해 하나 이상의 필터가 적용될 수 있습니다.
이것들은 출력을 대폭 변경하기 위한 것이 아니라 동일한 변수 데이터를 재사용하지만 다른 프리젠테이션으로 재사용할 수 있는 방법을 제공합니다.
위에서 설명한 ``esc`` 필터가 좋은 예입니다.
날짜는 다른 일반적인 사용 사례로, 동일한 페이지의 여러 섹션에서 동일한 데이터를 다르게 형식화해야 할 수도 있습니다.

필터는 의사 변수 이름 뒤에 오는 명령이며 파이프 기호(``|``)로 구분됩니다.

::

	// -55 is displayed as 55
	{ value|abs  }

매개 변수가 인수를 사용한다면 쉼표(``,``)로 분리하고 괄호로 묶어야합니다.

::

	{ created_at|date(Y-m-d) }

여러 필터를 함께 파이핑하여 여러 필터를 값에 적용할 수 있습니다.
왼쪽에서 오른쪽으로 순서대로 처리됩니다.

::

	{ created_at|date_modify(+5 days)|date(Y-m-d) }

Provided Filters
----------------

파서를 사용할 때 다음 필터를 사용할 수 있습니다

================ ================= =========================================================== ======================================
Filter           Arguments         Description                                                  Example
================ ================= =========================================================== ======================================
abs                                Displays the absolute value of a number.                    { v|abs }

capitalize                         Displays the string in sentence case: all lowercase         { v|capitalize}
                                   with firstletter capitalized.

date              format (Y-m-d)   A PHP **date**-compatible formatting string.                { v|date(Y-m-d) }

date_modify       value to add     A **strtotime** compatible string to modify the date,       { v|date_modify(+1 day) }
                  / subtract       like ``+5 day`` or ``-1 week``.

default           default value    Displays the default value if the variable is empty or      { v|default(just in case) }
                                   undefined.

esc               html, attr,      Specifies the context to escape the data.                   { v|esc(attr) }
                  css, js

excerpt           phrase, radius   Returns the text within a radius of words from a given      { v|excerpt(green giant, 20) }
                                   phrase. Same as **excerpt** helper function.

highlight         phrase           Highlights a given phrase within the text using             { v|highlight(view parser) }
                                   '<mark></mark>' tags.

highlight_code                     Highlights code samples with HTML/CSS.                      { v|highlight_code }

limit_chars       limit            Limits the number of characters to $limit.                  { v|limit_chars(100) }

limit_words       limit            Limits the number of words to $limit.                       { v|limit_words(20) }

local_currency    currency, locale Displays a localized version of a currency. "currency"      { v|local_currency(EUR,en_US) }
                                   valueis any 3-letter ISO 4217 currency code.

local_number      type, precision, Displays a localized version of a number. "type" can be     { v|local_number(decimal,2,en_US) }
                  locale           one of: decimal, currency, percent, scientific, spellout,
                                   ordinal, duration.

lower                              Converts a string to lowercase.                             { v|lower }

nl2br                              Replaces all newline characters (\n) to an HTML <br/> tag.  { v|nl2br }

number_format     places           Wraps PHP **number_format** function for use within the     { v|number_format(3) }
                                   parser.

prose                              Takes a body of text and uses the **auto_typography()**     { v|prose }
                                   method to turn it into prettier, easier-to-read, prose.

round             places, type     Rounds a number to the specified places. Types of **ceil**  { v|round(3) } { v|round(ceil) }
                                   and **floor** can be passed to use those functions instead.

strip_tags        allowed chars    Wraps PHP **strip_tags**. Can accept a string of allowed    { v|strip_tags(<br>) }
                                   tags.

title                              Displays a "title case" version of the string, with all     { v|title }
                                   lowercase, and each word capitalized.

upper                              Displays the string in all uppercase.                       { v|upper }
================ ================= =========================================================== ======================================

"local_number" 필터와 관련된 자세한 내용은 `PHP의 NumberFormatter <https://www.php.net/manual/en/numberformatter.create.php>`_\ 를 참조하십시오.

사용자 정의 필터
--------------------

**app/Config/View.php**\ 의 ``$filters`` 배열에 새 항목을 추가하여 자신만의 필터를 쉽게 만들 수 있습니다.
각 키는 뷰에서 필터로 호출될 이름이며 값은 호출 가능해야 합니다.

.. literalinclude:: view_parser/012.php

PHP 네이티브 함수 필터
-------------------------------

**app/Config/View.php**\ 의 ``$filters`` 새 항목을 추가하여 PHP 함수를 필터로 사용할 수 있습니다.
각 키는 뷰에서 호출되는 고유 PHP 함수명 이며, 그 값은 PHP 함수입니다.

.. literalinclude:: view_parser/013.php

파서 플러그인
==============

플러그인을 사용하면 파서를 확장하여 사용자 정의 기능을 추가할 수 있습니다.
PHP를 호출할 수 있으므로 구현하기 매우 간단합니다.
템플릿내에서 플러그인은 ``{+ +}`` 태그로 지정됩니다

::

	{+ foo +} inner content {+ /foo +}

이 예제는 **foo**\ 라는 플러그인을 보여줍니다.
여는 태그와 닫는 태그 사이의 내용을 조작할 수 있습니다.
이 예에서는 " inner content " 텍스트로 작업합니다.
의사 변수 교체가 발생하기 전에 플러그인이 처리됩니다.

플러그인은 종종 위에 표시된 것처럼 태그 쌍으로 구성되지만 닫는 태그가 없는 단일 태그일 수도 있습니다.

::

	{+ foo +}

여는 태그에는 플러그인 작동 방식을 사용자 정의할 수 있는 매개 변수가 포함될 수도 있습니다.

::

	{+ foo bar=2 baz="x y" +}

매개 변수는 단일 값일 수도 있습니다.

::

	{+ include somefile.php +}

제공되는 플러그인
--------------------

파서를 사용할 때 다음 플러그인을 사용할 수 있습니다.

================== ========================= ============================================ ================================================================
Plugin             Arguments                 Description                                    Example
================== ========================= ============================================ ================================================================
current_url                                  Alias for the current_url helper function.   {+ current_url +}
previous_url                                 Alias for the previous_url helper function.  {+ previous_url +}
siteURL                                      Alias for the site_url helper function.      {+ siteURL "login" +}
mailto             email, title, attributes  Alias for the mailto helper function.        {+ mailto email=foo@example.com title="Stranger Things" +}
safe_mailto        email, title, attributes  Alias for the safe_mailto helper function.   {+ safe_mailto email=foo@example.com title="Stranger Things" +}
lang               language string           Alias for the lang helper function.          {+ lang number.terabyteAbbr +}
validation_errors  fieldname(optional)       Returns either error string for the field    {+ validation_errors +} , {+ validation_errors field="email" +}
                                             (if specified) or all validation errors.
route              route name                Alias for the route_to helper function.      {+ route "login" +}
csp_script_nonce                             Alias for the csp_script_nonce helper        {+ csp_script_nonce +}
                                             function.
csp_style_nonce                              Alias for the csp_style_nonce helper         {+ csp_style_nonce +}
                                             function.
================== ========================= ============================================ ================================================================

플러그인 등록
--------------------

새 플러그인을 등록하려면 **app/Config/View.php**\ 의 ``$plugins`` 배열에 추가하면 됩니다.
키는 템플릿 파일에서 사용되는 플러그인의 이름입니다.
값은 정적 클래스 메소드와 같이 호출 가능해야 합니다.

.. literalinclude:: view_parser/014.php

클로저를 사용할 수도 있지만 구성 파일의 생성자에서만 정의할 수 있습니다.

.. literalinclude:: view_parser/015.php

호출 가능 항목이 단독으로 있는 경우, 열기/닫기 태그가 아닌 단일 태그로 취급되며, 플러그인의 반환 값으로 대체됩니다.

.. literalinclude:: view_parser/016.php

호출 가능 항목이 배열로 래핑된 경우 태그 사이의 모든 컨텐츠를 조작할 수 있는 열기/닫기 태그 쌍으로 처리됩니다.

.. literalinclude:: view_parser/017.php

***********
사용법 노트
***********

템플릿에서 참조되지 않은 대체 매개 변수를 포함하면 무시됩니다.

.. literalinclude:: view_parser/018.php

템플릿에서 참조되는 대체 매개 변수를 포함하지 않으면 유사 변수 그대로 결과에 표시됩니다.

.. literalinclude:: view_parser/019.php

배열이 예상 될 때(예 : 변수 쌍에 대해) 문자열 대체 매개 변수를 제공하면, 여는 변수 쌍 태그에 대한 대체가 수행되지만 닫는 변수 쌍 태그가 올바르게 렌더링되지 않습니다.

.. literalinclude:: view_parser/020.php

뷰 조각(Fragment)
=====================

뷰에서 루프를 사용하기 위해 변수 쌍을 사용할 필요는 없습니다.
변수 쌍 안에 있는 것에 대해 뷰 조각을 사용하고 뷰 대신 컨트롤러에서 반복을 제어할 수 있습니다.

뷰에서 반복이 제어되는 예::

	$template = '<ul>{menuitems}
		<li><a href="{link}">{title}</a></li>
	{/menuitems}</ul>';

	$data = [
		'menuitems' => [
			['title' => 'First Link', 'link' => '/first'],
			['title' => 'Second Link', 'link' => '/second'],
		]
	];
	echo $parser->setData($data)->renderString($template);

Result::

	<ul>
		<li><a href="/first">First Link</a></li>
		<li><a href="/second">Second Link</a></li>
	</ul>

뷰 조각을 사용하여 컨트롤러에서 루프를 제어하는 예

.. literalinclude:: view_parser/021.php

Result::

	<ul>
		<li><a href="/first">First Link</a></li>
		<li><a href="/second">Second Link</a></li>
	</ul>

***************
Class Reference
***************

.. php:namespace:: CodeIgniter\View

.. php:class:: Parser

	.. php:method:: render($view[, $options[, $saveData = false]])

		:param  string  $view: 뷰 소스의 파일 이름
		:param  array   $options: 옵션 배열, 키/값 쌍
		:param  boolean $saveData: true인 경우 다른 호출에 사용할 데이터 저장, false인 경우 뷰를 렌더링한 후 데이터 정리
		:returns: 선택된 뷰의 렌더링 된 텍스트
		:rtype: string

		파일 이름과 설정된 데이터를 기반으로 출력을 빌드합니다.

		.. literalinclude:: view_parser/022.php

        지원되는 옵션:

	        - ``cache`` - 뷰 결과를 저장하는 시간(초)
	        - ``cache_name`` - 캐시된 뷰 결과를 저장/검색하는 데 사용되는 ID; 기본적으로 viewpath
	        - ``cascadeData`` - 중첩 또는 루프 대체가 발생할 때 데이터가 전파 되어야 하는 경우 true
	        - ``saveData`` - 후속 호출에 대해 뷰 데이터 매개 변수를 유지해야하는 경우 true
	        - ``leftDelimiter`` - 의사 변수 구문에서 사용할 왼쪽 구분 기호
	        - ``rightDelimiter`` - 의사 변수 구문에 사용할 오른쪽 구분 기호

		모든 조건부 대체가 먼저 수행된 다음 각 데이터 쌍에 대해 나머지 대체가 수행됩니다.

	.. php:method:: renderString($template[, $options[, $saveData = false]])

		:param  string  $template: 뷰 소스 문자열
		:param  array   $options: 옵션 배열, 키/값 쌍
		:param  boolean $saveData: true인 경우 다른 호출에 사용할 데이터 저장, false 인 경우 뷰를 렌더링한 후 데이터 정리
		:returns: 선택된 뷰의 렌더링 된 텍스트
		:rtype: string

		제공된 템플릿 소스와 설정된 데이터를 기반으로 출력을 빌드합니다.

		.. literalinclude:: view_parser/023.php

       지원되는 옵션은 render()와 동일함

	.. php:method:: setData([$data[, $context = null]])

		:param  array   $data: 뷰 데이터 문자열의 배열, 키/값 쌍
		:param  string  $context: 데이터 이스케이프에 사용할 컨텍스트
		:returns: 메소드 체이닝을 위한 Renderer 객체
		:rtype: CodeIgniter\\View\\RendererInterface.

		한 번에 여러 개의 뷰 데이터를 설정합니다.
		
		.. literalinclude:: view_parser/024.php

        지원되는 이스케이프 컨텍스트: ``html``, ``css``, ``js``, ``url``, ``attr``, ``raw``.
		'raw'\ 면 이스케이프가 발생하지 않습니다.

	.. php:method:: setVar($name[, $value=null[, $context = null]])

		:param  string  $name: 뷰 데이터 변수명
		:param  mixed   $value: 뷰 데이터의 값
		:param  string  $context: 데이터 이스케이프에 사용할 컨텍스트
		:returns: 메소드 체이닝을 위한 Renderer 객체
		:rtype: CodeIgniter\\View\\RendererInterface.

		한 개의 뷰 데이터를 설정합니다
		
		.. literalinclude:: view_parser/025.php

        지원되는 이스케이프 컨텍스트: ``html``, ``css``, ``js``, ``url``, ``attr``, ``raw``.
		'raw'\ 면 이스케이프가 발생하지 않습니다.

	.. php:method:: setDelimiters($leftDelimiter = '{', $rightDelimiter = '}')

		:param  string  $leftDelimiter: 대체 필드의 왼쪽 분리 문자
		:param  string  $rightDelimiter: 대체 필드의 오른족쪽 분리 문자
		:returns: 메소드 체이닝을 위한 Renderer 객체
		:rtype: CodeIgniter\\View\\RendererInterface.

		대체 필드 구분자를 재정의합니다.
		
		.. literalinclude:: view_parser/026.php

    .. php:method:: setConditionalDelimiters($leftDelimiter = '{', $rightDelimiter = '}')

        :param  string  $leftDelimiter: 조건부 구분 왼쪽 기호
        :param  string  $rightDelimiter: 조건부 구분 오른쪽 기호
        :returns: 메소드 체이닝을 위한 Renderer 객체
        :rtype: CodeIgniter\\View\\RendererInterface.

        조건부 구분 기호 재정의.		

        .. literalinclude:: view_parser/027.php