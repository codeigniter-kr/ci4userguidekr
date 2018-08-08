**************************
Debugging Your Application
**************************

.. contents:: Table of Contents
	:depth: 3

================
Replace var_dump
================

While using XDebug and a good IDE can be indispensable to debug your application, sometimes a quick ``var_dump()`` is
all you need. CodeIgniter makes that even better by bundling in the excellent `Kint <https://raveren.github.io/kint/>`_
debugging tool for PHP. This goes way beyond your usual tool, providing many alternate pieces of data, like formatting
timestamps into recognizable dates, showing you hexcodes as colors, display array data like a table for easy reading,
and much, much more.
XDebug와 좋은 IDE는 애플리케이션을 디버그하는 데 없어서는 안될 때가 있지만 때로는 빠른 ``var_dump()`` 것이 전부입니다. CodeIgniter는 PHP를위한 훌륭한 Kint 디버깅 툴을 번들로 묶어서 더 멋지게 만듭니다 . 이것은 평소 도구를 넘어서서, 타임 스탬프를 인식 가능한 날짜로 포맷하고, 색상으로 헥스 코드를 표시하고, 읽기 쉽도록 테이블과 같은 배열 데이터를 표시하는 등의 많은 데이터 조각을 제공합니다.

Enabling Kint
=============

By default, Kint is enabled in **development** and **testing** environments only. This can be altered by modifying
the ``$useKint`` value in the environment configuration section of the main **index.php** file
기본적으로 Kint는 개발 및 테스트 환경에서만 사용 가능 합니다. 이것은 $useKint주 index.php 파일 의 환경 설정 섹션에서 값 을 수정하여 변경할 수 있습니다 

::

    $useKint = true;

Using Kint
==========

**d()**

The ``d()`` method dumps all of the data it knows about the contents passed as the only parameter to the screen, and
allows the script to continue executing
이 ``d()`` 메서드는 유일한 매개 변수로 전달 된 내용에 대해 알고있는 모든 데이터를 화면에 덤프하고 스크립트가 계속 실행되도록합니다.

::

    d($_SERVER);

**ddd()**

This method is identical to ``d()``, except that it also ``dies()`` and no further code is executed this request.
이 메소드는 d(), dies()이 요구를 실행 한 코드는 더 이상 존재하지 않는다는 점을 제외하고 는 동일합니다 .

**trace()**

This provides a backtrace to the current execution point, with Kint's own unique spin
Kint의 고유 한 스핀을 사용하여 현재 실행 지점에 백 트레이스를 제공합니다.

::

    Kint::trace();

For more information, see `Kint's page <https://raveren.github.io/kint/>`_.
자세한 내용은 `Kint's page <https://raveren.github.io/kint/>`_ 를 참조하십시오.

=================
The Debug Toolbar
=================

The Debug Toolbar provides at-a-glance information about the current page request, including benchmark results,
queries you have run, request and response data, and more. This can all prove very useful during development
to help you debug and optimize.
디버그 툴바는 벤치 마크 결과, 실행 한 쿼리, 요청 및 응답 데이터 등을 포함하여 현재 페이지 요청에 대한 정보를 한눈에 파악할 수있게 해줍니다. 디버깅 및 최적화에 도움이되는 개발 중에이 모든 것이 매우 유용합니다.

.. note:: The Debug Toolbar is still under construction with several planned features not yet implemented.
		  디버그 툴바는 아직 구현되지 않은 몇 가지 계획된 기능으로 구성 중입니다.

Enabling the Toolbar
====================

The toolbar is enabled by default in any environment *except* production. It will be shown whenever the
constant CI_DEBUG is defined and it's value is positive. This is defined in the boot files (i.e.
application/Config/Boot/development.php) and can be modified there to determine what environments it shows
itself in.
도구 모음은 프로덕션을 제외한 모든 환경에서 기본적으로 사용됩니다 . 상수 CI_DEBUG가 정의되고 값이 양수일 때마다 표시됩니다. 이것은 부팅 파일 (예 : application/Config/Boot/development.php)에 정의되어 있으며,이 파일을 수정하여 자신이 어떤 환경을 보여줄지 결정할 수 있습니다.

The toolbar itself is displayed as an :doc:`After Filter </general/filters>`. You can stop it from ever
running by removing it from the ``$globals`` property of **application/Config/Filters.php**.
도구 모음 자체는 :doc:`After Filter </general/filters>` 로 표시됩니다 . **application/Config/Filters.php** 의 ``$globals`` 속성 에서 제거하여 실행을 멈출 수 있습니다 .

Choosing What to Show
---------------------

CodeIgniter ships with several Collectors that, as the name implies, collect data to display on the toolbar. You
can easily make your own to customize the toolbar. To determine which collectors are shown, again head over to
the App configuration file
CodeIgniter에는 이름에서 알 수 있듯이 툴바에 표시 할 데이터를 수집하는 여러 Collector가 함께 제공됩니다. 자신 만의 툴바를 쉽게 만들 수 있습니다. 표시되는 콜렉터를 확인하려면 다시 App 구성 파일로 넘어갑니다.

::

	public $toolbarCollectors = [
		'CodeIgniter\Debug\Toolbar\Collectors\Timers',
		'CodeIgniter\Debug\Toolbar\Collectors\Database',
		'CodeIgniter\Debug\Toolbar\Collectors\Logs',
		'CodeIgniter\Debug\Toolbar\Collectors\Views',
 		'CodeIgniter\Debug\Toolbar\Collectors\Cache',
		'CodeIgniter\Debug\Toolbar\Collectors\Files',
		'CodeIgniter\Debug\Toolbar\Collectors\Routes',
	];

Comment out any collectors that you do not want to show. Add custom Collectors here by providing the fully-qualified
class name. The exact collectors that appear here will affect which tabs are shown, as well as what information is
shown on the Timeline.
보여주고 싶지 않은 수집가를 주석으로 처리하십시오. 완전한 클래스 이름을 제공하여 여기에 사용자 정의 수집기를 추가하십시오. 여기에 나타나는 정확한 수집자는 어떤 탭이 표시되는지, 타임 라인에 표시되는 정보에 영향을줍니다.

.. note:: Some tabs, like Database and Logs, will only display when they have content to show. Otherwise, they
    are removed to help out on smaller displays.
    데이터베이스 및 로그와 같은 일부 탭은 표시 할 내용이있는 경우에만 표시됩니다. 그렇지 않은 경우 작은 디스플레이에 도움을주기 위해 제거됩니다.

The Collectors that ship with CodeIgniter are:
CodeIgniter와 함께 제공되는 수집기는 다음과 같습니다.

* **Timers** collects all of the benchmark data, both by the system and by your application. 시스템과 응용 프로그램 모두에서 모든 벤치 마크 데이터를 수집
* **Database** Displays a list of queries that all database connections have performed, and their execution time. 모든 데이터베이스 연결이 수행 한 쿼리 목록과 실행 시간을 표시
* **Logs** Any information that was logged will be displayed here. In long-running systems, or systems with many items being logged, this can cause memory issues and should be disabled. 기록 된 모든 정보가 여기에 표시됩니다. 장기 실행 시스템 또는 많은 항목이 기록 된 시스템에서는 메모리 문제가 발생할 수 있으므로 사용하지 않아야합니다.
* **Views** Displays render time for views on the timeline, and shows any data passed to the views on a separate tab. 타임 라인의보기에 대한 렌더링 시간을 표시하고 별도 탭의보기에 전달 된 모든 데이터를 표시
* **Cache** Will display information about cache hits and misses, and execution times. 캐시 적중 및 누락 및 실행 시간에 대한 정보를 표시
* **Files** displays a list of all files that have been loaded during this request. 요청 중에로드 된 모든 파일의 목록을 표시
* **Routes** displays information about the current route and all routes defined in the system. 현재 경로 및 시스템에 정의 된 모든 경로에 대한 정보를 표시

Setting Benchmark Points
========================

In order for the Profiler to compile and display your benchmark data you must name your mark points using specific syntax.
프로파일러가 벤치 마크 데이터를 컴파일하고 표시하려면 특정 구문을 사용하여 마크 포인트의 이름을 지정해야합니다.

Please read the information on setting Benchmark points in the :doc:`Benchmark Library </libraries/benchmark>` page.
:doc:`Benchmark Library </libraries/benchmark>` 페이지 에서 벤치 마크 포인트 설정에 대한 정보를 읽으십시오 .

Creating Custom Collectors
==========================

Creating custom collectors is a straightforward task. You create a new class, fully-namespaced so that the autoloader
can locate it, that extends ``CodeIgniter\Debug\Toolbar\Collectors\BaseCollector``. This provides a number of methods
that you can override, and has four required class properties that you must correctly set depending on how you want
the Collector to work
사용자 정의 콜렉터 작성은 간단한 작업입니다. 오토로더가 자동으로 네임 스페이스를 찾아 확장 할 수 있도록 완전히 클래스 된 새 클래스를 작성합니다 CodeIgniter\Debug\Toolbar\Collectors\BaseCollector. 이렇게하면 재정의 할 수있는 여러 가지 방법이 제공되며 수집기 작동 방법에 따라 올바르게 설정해야하는 네 가지 필수 클래스 속성이 있습니다.

::

	<?php namespace MyNamespace;

	use CodeIgniter\Debug\Toolbar\Collectors\BaseCollector;

	class MyCollector extends BaseCollector
	{
		protected $hasTimeline   = false;

		protected $hasTabContent = false;

		protected $hasVarData    = false;

		protected $title         = '';
	}

**$hasTimeline** should be set to ``true`` for any Collector that wants to display information in the toolbar's
timeline. If this is true, you will need to implement the ``formatTimelineData()`` method to format and return the
data for display.
**$hasTimeline** 은 ``true`` 툴바의 타임 라인에 정보를 표시하고자하는 콜렉터 에 대해 설정되어야합니다 . 이것이 true 라면, ``formatTimelineData()`` 표시 할 데이터를 형식화하고 리턴하는 메소드를 구현해야합니다 .

**$hasTabContent** should be ``true`` if the Collector wants to display its own tab with custom content. If this
is true, you will need to provide a ``$title``, implement the ``display()`` method to render out tab's contents,
and might need to implement the ``getTitleDetails()`` method if you want to display additional information just
to the right of the tab content's title.
``true`` Collector가 사용자 정의 컨텐츠가있는 자체 탭을 표시하려면 **$hasTabContent** 가 있어야합니다 . 이것이 사실이라면, 당신은을 제공해야합니다 ``$title`` 구현 ``display()`` 탭의 내용을 렌더링하는 방법을하고 구현해야 할 수도 있습니다 ``getTitleDetails()`` 그냥 탭 내용의 제목의 오른쪽에 추가 정보를 표시 할 경우 방법.

**$hasVarData** should be ``true`` if this Collector wants to add additional data to the ``Vars`` tab. If this
is true, you will need to implement the ``getVarData()`` method.
**$hasVarData** 는 ``true`` 이 Collector가 ``Vars`` 탭에 추가 데이터를 추가하려는 경우 이어야합니다 . 이것이 사실이라면 ``getVarData()`` 메소드 를 구현해야합니다 .

**$title** is displayed on open tabs.
**$title** 이 열린 탭에 표시됩니다.

Displaying a Toolbar Tab
------------------------

To display a toolbar tab you must:
도구 모음 탭을 표시하려면 다음을 수행해야합니다.

1. Fill in ``$title`` with the text displayed as both the toolbar title and the tab header.
2. Set ``$hasTabContent`` to ``true``.
3. Implement the ``display()`` method.
4. Optionally, implement the ``getTitleDetails()`` method.

The ``display()`` creates the HTML that is displayed within the tab itself. It does not need to worry about
the title of the tab, as that is automatically handled by the toolbar. It should return a string of HTML.
``display()`` 탭 자체에 표시되는 HTML을 생성합니다. 탭의 제목은 툴바에서 자동으로 처리되므로 걱정할 필요가 없습니다. HTML 문자열을 반환해야합니다.

The ``getTitleDetails()`` method should return a string that is displayed just to the right of the tab's title.
it can be used to provide additional overview information. For example, the Database tab displays the total
number of queries across all connections, while the Files tab displays the total number of files.
``getTitleDetails()`` 메서드는 탭의 제목 오른쪽에 표시된 문자열을 반환해야합니다. 추가 개요 정보를 제공하는 데 사용할 수 있습니다. 예를 들어 데이터베이스 탭에는 모든 연결에서의 총 쿼리 수가 표시되는 반면 파일 탭에는 총 파일 수가 표시됩니다.

Providing Timeline Data
-----------------------

To provide information to be displayed in the Timeline you must:
타임 라인에 표시 할 정보를 제공하려면 다음을 수행해야합니다.

1. Set ``$hasTimeline`` to ``true``.
2. Implement the ``formatTimelineData()`` method.

The ``formatTimelineData()`` method must return an array of arrays formatted in a way that the timeline can use
it to sort it correctly and display the correct information. The inner arrays must include the following information
formatTimelineData()메서드는 타임 라인이 올바르게 정렬하고 올바른 정보를 표시하는 데 사용할 수있는 방식으로 배열 된 배열의 배열을 반환해야합니다. 내부 배열에는 다음 정보가 포함되어야합니다.

::

	$data[] = [
		'name'      => '',     // Name displayed on the left of the timeline 타임 라인의 왼쪽에 표시되는 이름 
		'component' => '',     // Name of the Component listed in the middle of timeline  타임 라인의 중간에 나열된 컴포넌트의 이름
		'start'     => 0.00,   // 시작 시간, like microtime(true)
		'duration'  => 0.00    // duration, like mircrotime(true) - microtime(true)
	];

Providing Vars
--------------

To add data to the Vars tab you must:
Vars 탭에 데이터를 추가하려면 다음을 수행해야합니다.

1. Set ``$hasVarData`` to ``true``
2. Implement ``getVarData()`` method.

The ``getVarData()`` method should return an array containing arrays of key/value pairs to display. The name of the
outer array's key is the name of the section on the Vars tab
``getVarData()`` 메소드는 표시 할 키 / 값 쌍의 배열을 포함하는 배열을 반환해야합니다. 외부 배열의 키 이름은 Vars 탭의 섹션 이름입니다.

::

	$data = [
		'section 1' => [
		    'foo' => 'bar',
		    'bar' => 'baz'
		],
		'section 2' => [
		    'foo' => 'bar',
		    'bar' => 'baz'
		]
	 ];
