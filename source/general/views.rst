#####
Views
#####

A view is simply a web page, or a page fragment, like a header, footer, sidebar, etc. In fact,
views can flexibly be embedded within other views (within other views, etc.) if you need
this type of hierarchy.
뷰는 단순히 웹 페이지이거나 머리글, 바닥 글, 사이드 바 등과 같은 페이지 조각입니다. 실제로이 유형의 계층 구조가 필요한 경우보기가 다른보기 (다른보기 내에서) 내에 유연하게 포함될 수 있습니다.

Views are never called directly, they must be loaded by a controller. Remember that in an MVC framework,
the Controller acts as the traffic cop, so it is responsible for fetching a particular view. If you have
not read the :doc:`Controllers <controllers>` page, you should do so before continuing.
뷰는 직접 호출되지 않으며 컨트롤러에 의해로드되어야합니다. MVC 프레임 워크에서 컨트롤러는 교통 경찰의 역할을하므로 특정보기를 가져 오는 역할을 담당한다는 것을 기억하십시오. 컨트롤러 페이지를 읽지 않았다면 계속하기 전에 그렇게해야합니다.

Using the example controller you created in the controller page, let’s add a view to it.
컨트롤러 페이지에서 만든 예제 컨트롤러를 사용하여 컨트롤러 페이지에보기를 추가합시다.

Creating a View
===============

Using your text editor, create a file called ``BlogView.php`` and put this in it
텍스트 편집기를 사용하여 호출 된 파일을 작성 BlogView.php하고이 파일 에 다음을 입력하십시오.

::

	<html>
        <head>
            <title>My Blog</title>
        </head>
        <body>
            <h1>Welcome to my Blog!</h1>
        </body>
	</html>

Then save the file in your **application/Views** directory.
그런 다음 application / Views 디렉토리에 파일을 저장하십시오 .

Displaying a View
=================

To load and display a particular view file you will use the following function
특정 뷰 파일을로드하고 표시하려면 다음 함수를 사용합니다.

::

	echo view('name');

Where *name* is the name of your view file.
여기서 name 은보기 파일의 이름입니다.

.. important:: The .php file extension does not need to be specified, but all views are expected to end with the .php extension.
			   .php 파일 확장명을 지정할 필요는 없지만 모든보기는 .php 확장자로 끝나야합니다.

Now, open the controller file you made earlier called ``Blog.php``, and replace the echo statement with the view function
이제 이전에 호출 한 컨트롤러 파일을 열고 Blog.phpecho 문을 view 함수로 바꿉니다.

::

	class Blog extends \CodeIgniter\Controller
	{
		public function index()
		{
			echo view('BlogView');
		}
	}

If you visit your site using the URL you did earlier you should see your new view. The URL was similar to this
이전에 URL을 사용하여 사이트를 방문하면 새보기가 표시됩니다. URL은 다음과 유사합니다.

::

	example.com/index.php/blog/

.. note:: While all of the examples show echo the view directly, you can also return the output from the view, instead,
    and it will be appended to any captured output.
    모든 예제에서 뷰를 직접 보여 주지만 대신 뷰에서 출력을 반환 할 수 있으며 캡처 된 출력에 추가됩니다.

Loading Multiple Views
======================

CodeIgniter will intelligently handle multiple calls to ``view()`` from within a controller. If more than one
call happens they will be appended together. For example, you may wish to have a header view, a menu view, a
content view, and a footer view. That might look something like this
CodeIgniter는 view()컨트롤러 내에서 여러 호출을 지능적으로 처리합니다. 하나 이상의 호출이 발생하면 함께 추가됩니다. 예를 들어, 머리글보기, 메뉴보기, 내용보기 및 바닥 글보기가 필요할 수 있습니다. 그러면 다음과 같이 보일 수 있습니다.

::

	class Page extends \CodeIgniter\Controller
	{
		public function index()
		{
			$data = [
				'page_title' => 'Your title'
			];

			echo view('header');
			echo view('menu');
			echo view('content', $data);
			echo view('footer');
		}
	}

In the example above, we are using "dynamically added data", which you will see below.
위의 예에서 우리는 아래에서 볼 수있는 "동적으로 추가 된 데이터"를 사용하고 있습니다.

Storing Views within Sub-directories
====================================

Your view files can also be stored within sub-directories if you prefer that type of organization.
When doing so you will need to include the directory name loading the view.  Example
해당 유형의 조직을 원하면보기 파일을 하위 디렉토리에 저장할 수도 있습니다. 그렇게 할 때보기를로드하는 디렉토리 이름을 포함시켜야합니다. 예

::

	echo view('directory_name/file_name');

Namespaced Views
================

You can store views under a **View** directory that is namespaced, and load that view as if it was namespaced. While
PHP does not support loading non-class files from a namespace, CodeIgniter provides this feature to make it possible
to package your views together in a module-like fashion for easy re-use or distribution.
이름 공간을 가진 View 디렉토리 아래에 뷰를 저장할 수 있고 , 네임 스페이스가있는 것처럼 뷰를로드 할 수 있습니다. PHP는 네임 스페이스에서 클래스가 아닌 파일을로드하는 것을 지원하지 않지만, CodeIgniter는이 기능을 제공하여 쉽게 재사용하거나 배포 할 수 있도록 모듈과 같은 방식으로 뷰를 패키징 할 수 있습니다.

If you have ``Blog`` directory that has a PSR-4 mapping setup in the :doc:`Autoloader </concepts/autoloader>` living
under the namespace ``Example\Blog``, you could retrieve view files as if they were namespaced also. Following this
example, you could load the **BlogView** file from **/blog/views** by prepending the namespace to the view name
당신이있는 경우 Blog에서 PSR-4 매핑 설정이 디렉토리 자동 로더 네임 스페이스에서 살아 Example\Blog, 당신은 또한 네임 스페이스 것처럼보기 파일을 검색 할 수있다. 이 예제에 따라 네임 스페이스를 뷰 이름 앞에 추가하여 / blog / views 에서 BlogView 파일을 로드 할 수 있습니다.

::

    echo view('Example\Blog\Views\BlogView');

Caching Views
=============

You can cache a view with the ``view`` command by passing a ``cache`` option with the number of seconds to cache
the view for, in the third parameter
세 번째 매개 변수에서보기를 캐시 할 시간 (초) 옵션을 view전달 하여 명령 cache을 사용하여보기를 캐시 할 수 있습니다.

::

    // Cache the view for 60 seconds
    echo view('file_name', $data, ['cache' => 60]);

By default, the view will be cached using the same name as the view file itself. You can customize this by passing
along ``cache_name`` and the cache ID you wish to use
기본적으로보기는보기 파일 자체와 동일한 이름을 사용하여 캐시됩니다. ``cache_name`` 사용하려는 캐시 ID 와 함께 전달하여 맞춤 설정할 수 있습니다 .

::

    // Cache the view for 60 seconds
    echo view('file_name', $data, ['cache' => 60, 'cache_name' => 'my_cached_view']);

Adding Dynamic Data to the View
===============================

Data is passed from the controller to the view by way of an array in the second parameter of the view function.
Here's an example
데이터는 뷰 함수의 두 번째 매개 변수에서 배열을 통해 컨트롤러에서 뷰로 전달됩니다. 다음은 그 예입니다.

::

	$data = [
		'title'   => 'My title',
		'heading' => 'My Heading',
		'message' => 'My Message'
	];

	echo view('blogview', $data);

Let's try it with your controller file. Open it and add this code
컨트롤러 파일을 사용해 보겠습니다. 그것을 열고 다음 코드를 추가하십시오.

::

	class Blog extends \CodeIgniter\Controller
	{
		public function index()
		{
			$data['title']   = "My Real Title";
			$data['heading'] = "My Real Heading";

			echo view('blogview', $data);
		}
	}

Now open your view file and change the text to variables that correspond to the array keys in your data
이제 뷰 파일을 열고 텍스트를 데이터의 배열 키에 해당하는 변수로 변경하십시오.

::

	<html>
        <head>
            <title><?= $title ?></title>
        </head>
        <body>
            <h1><?= $heading ?></h1>
        </body>
	</html>

Then load the page at the URL you've been using and you should see the variables replaced.
그런 다음 사용중인 URL에 페이지를로드하면 대체 된 변수가 표시됩니다.

The data passed in is only available during one call to ``view``. If you call the function multiple times
in a single request, you will have to pass the desired data to each view. This keeps any data from "bleeding" into
other views, potentially causing issues. If you would prefer the data to persist, you can pass the ``saveData`` option
into the ``$option`` array in the third parameter.
전달 된 데이터는 하나의 보기 호출 중에 만 사용할 수 있습니다 . 단일 요청에서 함수를 여러 번 호출하면 각 뷰에 원하는 데이터를 전달해야합니다. 이렇게하면 모든 데이터가 "출혈"에서 다른보기로 유지되어 잠재적으로 문제를 일으킬 수 있습니다. 데이터가 지속되도록하려면 saveData 옵션을 세 번째 매개 변수 의 $ option 배열 로 전달하면 됩니다.

::

	$data = [
		'title'   => 'My title',
		'heading' => 'My Heading',
		'message' => 'My Message'
	];

	echo view('blogview', $data, ['saveData' => true]);

Additionally, if you would like the default functionality of the view method to be that it does save the data
between calls, you can set ``$saveData`` to **true** in **application/Config/Views.php**.
당신이 통화 사이의 데이터를 저장 않는 것으로보기 방법의 기본 기능을 좋아하면 또한, 당신은 설정할 수 있습니다 $saveData에 사실 에서 **application/Config/Views.php**.

Creating Loops
==============

The data array you pass to your view files is not limited to simple variables. You can pass multi dimensional
arrays, which can be looped to generate multiple rows. For example, if you pull data from your database it will
typically be in the form of a multi-dimensional array.
뷰 파일에 전달하는 데이터 배열은 간단한 변수에만 국한되지 않습니다. 다중 행을 생성하기 위해 반복 될 수있는 다차원 배열을 전달할 수 있습니다. 예를 들어 데이터베이스에서 데이터를 가져 오는 경우 일반적으로 다차원 배열 형식입니다.

Here’s a simple example. Add this to your controller
다음은 간단한 예입니다. 컨트롤러에 다음을 추가하십시오.

::

	class Blog extends \CodeIgniter\Controller
	{
		public function index()
		{
			$data = [
				'todo_list' => ['Clean House', 'Call Mom', 'Run Errands'],
				'title'     => "My Real Title",
				'heading'   => "My Real Heading"
			];

			echo view('blogview', $data);
		}
	}

Now open your view file and create a loop
이제 뷰 파일을 열고 루프를 만듭니다.

::

	<html>
	<head>
		<title><?= $title ?></title>
	</head>
	<body>
		<h1><?= $heading ?></h1>

		<h3>My Todo List</h3>

		<ul>
		<?php foreach ($todo_list as $item):?>

			<li><?= $item ?></li>

		<?php endforeach;?>
		</ul>

	</body>
	</html>
