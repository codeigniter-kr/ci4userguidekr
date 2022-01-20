########
뷰(View)
########

.. contents::
    :local:
    :depth: 2

뷰는 단순히 웹 페이지 또는 머리글, 바닥 글, 사이드 바 등과 같은 페이지 조각입니다. 
계층별 구성이 필요한 경우 뷰에서 다른 뷰를 유연하게 포함시킬수 있습니다.

뷰는 직접 호출되지 않으며 컨트롤러가 로드해야 합니다.
MVC 프레임워크에서는 컨트롤러가 교통경찰 역할을 하므로 특정 뷰를 가져오는 역할을 합니다.
:doc:`컨트롤러 </incoming/controllers>` 아직 페이지를 읽지 않았다면 먼저 읽어보세요.

컨트롤러 페이지에서 생성한 예제 컨트롤러를 사용하여 해당 페이지에 뷰를 추가해 봅시다.

뷰 만들기
===============

텍스트 에디터를 사용하여 ``blog_view.php``\ 라는 파일을 만들고 다음을 입력하세요.

::

	<html>
        <head>
            <title>My Blog</title>
        </head>
        <body>
            <h1>Welcome to my Blog!</h1>
        </body>
	</html>

**app/Views** 디렉토리에 파일을 저장하십시오.

뷰 표시
=================

특정 뷰 파일을 로드하고 표시하려면 다음 기능을 사용하십시오.

::

	echo view('name');

*name*\ 은 뷰 파일의 이름입니다.

.. important:: 파일 확장자가 생략되면 뷰는 ``.php`` 확장자를 기본으로 사용합니다.

이제 ``Blog.php``\ 라는 컨트롤러 파일을 열고 echo view 부분을 수정합니다.

::

	<?php 
	
	namespace App\Controllers;

	class Blog extends \CodeIgniter\Controller
	{
		public function index()
		{
			echo view('blog_view');
		}
	}

다음과 비슷한 URL을 사용하여 사이트를 방문하면 새로운 뷰가 표시됩니다.

::

	example.com/index.php/blog/

.. note:: 모든 예제가 뷰를 echo문을 사용하여 표시 하지만 뷰의 출력을 캡처하여 반환할 수 있습니다.

다중(Multiple) 뷰 로드
==========================

CodeIgniter는 컨트롤러에서 ``view()``\를 여러 호출하여도 똑똑하게 처리합니다.
둘 이상의 호출이 발생하면 출력에 추가됩니다.
예를 들자면 머리글, 메뉴, 내용, 바닥글 뷰를 조합하여 출력하기 원할 수 있습니다. 
다음과 같이하면 됩니다.

::

	<?php 
	
	namespace App\Controllers;

	class Page extends \CodeIgniter\Controller
	{
		public function index()
		{
			$data = [
				'page_title' => 'Your title',
			];

			echo view('header');
			echo view('menu');
			echo view('content', $data);
			echo view('footer');
		}
	}

위의 예에서는 "동적으로 추가 된 데이터"\ 를 사용하고 있습니다. 이에 대한 부분은 아래에서 설명하고 있습니다.

하위 디렉토리에 뷰 저장
====================================

계층별의 조직화를 선호한다면 뷰 파일을 하위 디렉토리에 저장할 수 있습니다.
이렇게한 경우 뷰를 로드하려면 디렉토리 이름을 포함시켜야 합니다.

::

	echo view('directory_name/file_name');

네임스페이스 뷰
================

네임스페이스가 있는 **View** 디렉토리에 뷰를 저장하고, 네임스페이스가 있는 것처럼 해당 뷰를 로드할 수 있습니다.
PHP는 네임스페이스에 클래스가 아닌 파일 로드를 지원하지 않지만, CodeIgniter는 이 기능을 제공하여 쉽게 재사용하거나 배포할 수 있도록 모듈과 같은 방식으로 뷰를 함께 패키지화할 수 있습니다.

:doc:`오토로더 </concepts/autoloader>`\ 에 PSR-4 매핑 설정이 있는 ``Blog`` 디렉토리가 있다면, 뷰 파일도 ``Example\Blog``\ 처럼 네임스페이스를 붙여 불러올 수 있습니다.
다음은 네임스페이스를 뷰 이름앞에 추가하여 **example/blog/Views** 디렉토리에서 **blog_view.php** 파일을 로드하는 예입니다.

::

    echo view('Example\Blog\Views\BlogView');

.. _caching-views:

뷰 캐싱
=============

``view`` 명령의 세 번째 매개 변수에 ``cache`` 옵션을 전달하여 뷰를 캐시(cache)할 수 있습니다.

::

    // Cache the view for 60 seconds
    echo view('file_name', $data, ['cache' => 60]);

기본적으로 뷰는 뷰 파일과 동일한 이름을 사용하여 캐시됩니다.
``cache_name`` 옵션과 사용하려는 캐시 ID를 전달하여 이를 바꿀수 있습니다.

::

    // Cache the view for 60 seconds
    echo view('file_name', $data, ['cache' => 60, 'cache_name' => 'my_cached_view']);

뷰에 동적 데이터 추가
===============================

뷰 함수의 두 번째 매개 변수에 배열을 통해 컨트롤러에서 뷰로 데이터를 전달할 수 있습니다.
다음 예를 보십시오.

::

	$data = [
		'title'   => 'My title',
		'heading' => 'My Heading',
		'message' => 'My Message',
	];

	echo view('blog_view', $data);

컨트롤러 파일에 시도해 봅시다. 컨트롤러 파일을 열고 아래 코드를 추가하십시오.

::

	<?php 
	
	namespace App\Controllers;

	class Blog extends \CodeIgniter\Controller
	{
		public function index()
		{
			$data['title']   = "My Real Title";
			$data['heading'] = "My Real Heading";

			echo view('blog_view', $data);
		}
	}

이제 뷰 파일을 열고 데이터의 아래와 같이 텍스트를 배열 키에 해당하는 변수로 변경하십시오.

::

	<html>
        <head>
            <title><?= esc($title) ?></title>
        </head>
        <body>
            <h1><?= esc($heading) ?></h1>
        </body>
	</html>

그런 다음 사용중인 URL에서 페이지를 로드하면 변수가 바뀐것을 볼 수 있습니다.

전달된 데이터는 호출된 `view`\ 에 대해 한 번만 사용 가능합니다.
단일 요청에서 `view` 함수를 여러번 호출한다면 각 뷰 호출에 데이터를 전달해야 합니다.
이렇게 하면 모든 데이터가 다른 뷰로 "전달"되지 않아 문제가 발생할 수 있습니다.
`view` 함수의 세 번째 매개 변수 `$option` 배열에 `saveData` 옵션을 사용하여 데이터를 유지할 수 있습니다.

::

	$data = [
		'title'   => 'My title',
		'heading' => 'My Heading',
		'message' => 'My Message',
	];

	echo view('blog_view', $data, ['saveData' => true]);

**app/Config/Views.php** 의 ``$saveData``\ 를 ``true``\ 로 설정하면 옵션을 별도로 설정하지 않아도 뷰(view) 함수가 데이터를 유지합니다.

루프(Loop) 만들기
======================

뷰 파일에 전달하는 데이터 배열은 단순한 변수로 제한되지 않습니다.
다차원 배열을 전달할 수 있으며, 여러 행을 생성하기 위해 반복될 수 있습니다.
일반적으로 데이터베이스에서 데이터를 가져오면 다차원 배열 형식이 되는데 이것이 좋은 예입니다.

다음은 간단한 예입니다. 다음을 컨트롤러에 추가하십시오.

::

	<?php 
	
	namespace App\Controllers;

	class Blog extends \CodeIgniter\Controller
	{
		public function index()
		{
			$data = [
				'todo_list' => ['Clean House', 'Call Mom', 'Run Errands'],
				'title'     => 'My Real Title',
				'heading'   => 'My Real Heading',
			];

			echo view('blog_view', $data);
		}
	}

이제 뷰 파일을 열고 루프를 만듭니다.

::

	<html>
	<head>
		<title><?= esc($title) ?></title>
	</head>
	<body>
		<h1><?= esc($heading) ?></h1>

		<h3>My Todo List</h3>

		<ul>
		<?php foreach ($todo_list as $item): ?>

			<li><?= esc($item) ?></li>

		<?php endforeach ?>
		</ul>

	</body>
	</html>
