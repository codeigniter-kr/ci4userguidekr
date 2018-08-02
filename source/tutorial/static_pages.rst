############
Static pages
############

**참고:** 이 튜토리얼은 CodeIgniter를 다운로드하고 개발 환경에  :doc:`프레임워크를 설치 <../installation/index>` 했다고 가정 합니다.


가장 먼저 할 일은 static pages를 처리 할 **controller** 를 설정하는 것
입니다. 컨트롤러는 단순히 작업을 위임하는 데 도움이되는 클래스로 웹 
응용 프로그램의 접착제입니다.

예를 들어,

	http://example.com/news/latest/10

우리는 "news"라는 컨트롤러가 있다고 상상할 수 있습니다. 뉴스에서 호출되는
메소드는 "latest"입니다. news 메소드는 10 개의 뉴스 항목을 가져와 페이지에
표시하는 것입니다. MVC에서는 다음과 같은 URL 패턴을 자주 볼 수 있습니다.

	http://example.com/[controller-class]/[controller-method]/[arguments]

URL 스키마가 복잡 해짐에 따라 변경 될 수 있습니다. 그러나 지금은 이것으로
충분합니다.

다음 코드를 사용하여 *application/Controllers/Pages.php* 에 파일을 만듭니다 .

::

	<?php
	class Pages extends CodeIgniter\Controller {

		public function view($page = 'home')
		{
		}
	}



``$page`` 인수 한개를 허용하는 ``view`` 메소드를 가진 ``Pages`` 라는 이름의 클래스를 
작성했습니다. ``Pages`` 클래스는 ``CodeIgniter\Controller`` 클래스를 상속 받았습니다.
새로 작성된 ``Pages`` 클래스는 ``CodeIgniter\Controller`` 클래스 
(*system/Controller.php*) 에 정의 된 메서드 및 변수에 액세스 할 수 있습니다.

**컨트롤러는 웹 응용 프로그램에 대한 모든 요청의 중심** 이 될 것입니다.
다른 PHP 클래스와 마찬가지로, 컨트롤러내에서 ``$this`` 로 참조하십시오.


첫 번째 메소드을 만들었으니 이제 기본 페이지 템플릿을 만들어 보겠습니다. 
페이지의 footer와 header 역할을하는 두 개의 "views"(페이지 템플리트)를 만들 것입니다.

header 파일 *application/Views/templates/header.php* 를 만들고 다음 코드를 추가합니다.

::

	<!doctype html>
	<html>
	<head>
		<title>CodeIgniter Tutorial</title>
	</head>
	<body>

		<h1><?= $title; ?></h1>


헤더에는 메인 view를 로드하기 전에 제목과 함께 표시하려는 기본 HTML 코드가
들어 있습니다. 또한 나중에 컨트롤러에서 정의 할 ``$title`` 변수의 값을 출력 
할 것입니다. 이제 *application/Views/templates/footer.php* 에 다음 코드를 포함
하는 footer를 만듭니다 .

::

		<em>&copy; 2016</em>
	</body>
	</html>

컨트롤러에 logic 추가하기
------------------------------


이전에 컨트롤러 ``view()`` 메서드를 설정했습니다 . 이 메서드는 로드 할 
페이지 이름을 받는 하나의 매개 변수를 가지고 있습니다. Static page 템플릿은
*application/Views/pages/* 디렉터리에 있습니다.

그 디렉토리에*home.php* 와 *about.php* 라는 두 개의 파일을 생성 하십시오.
이 파일들 안에 출력하기 원하는 텍스트를 입력하고 저장하십시오. 특히 원본이 
아닌 경우 "Hello World!"를 사용해보세요.

해당 페이지를 로드하려면 요청한 페이지가 실제로 존재하는지 확인해야합니다.

::

	public function view($page = 'home')
	{
		if ( ! file_exists(APPPATH.'/Views/pages/'.$page.'.php'))
		{
		    // Whoops, we don't have a page for that!
		    throw new \CodeIgniter\Exceptions\PageNotFoundException($page);
		}

		$data['title'] = ucfirst($page); // Capitalize the first letter

		echo view('templates/header', $data);
		echo view('pages/'.$page, $data);
		echo view('templates/footer', $data);
	}

이제 페이지가 존재하면 header와 footer를 포함하여 로드되고 사용자에게 
표시됩니다. 페이지가 존재하지 않으면 "404 Page not found"오류가 표시
됩니다.

이 메서드의 첫 번째 줄은 페이지가 실제로 있는지 여부를 확인합니다. 
PHP의 ``file_exists()`` 함수는 파일이 예상되는 위치에 있는지 여부를 확인하는데
사용됩니다. ``PageNotFoundException`` 은 기본 오류 페이지를 표시하도록하는
CodeIgniter의 예외입니다.

header 템플릿에서 ``$title`` 변수는 페이지 제목을 사용자 정의하는데 
사용되었습니다. title 값은 이 메서드에서 정의되지만 변수에 값을 할당하는
대신 ``$data`` 배열 의 title 요소에 할당됩니다.

마지막으로해야 할 일은 뷰를 표시하기 위해 로드하는 것입니다. ``view()`` 메서드의
두 번째 매개 변수는 값을 view로 전달하는 데 사용됩니다. ``$data`` 배열의 각 값 은
해당 키 이름이있는 변수에 지정됩니다. 따라서 ``$data['title']`` 컨트롤러 의 값은
view의 ``$title`` 값과 동일합니다 .

.. note:: **view()** 함수에 전달된 모든 파일 및 디렉토리 이름은 실제 디렉토리 및
   파일 자체의 대소문자와 일치해야 하며 그렇지 않으면 시스템은 대소문자가 구분되는
   플랫폼에서 오류를 발생시킵니다.

Routing
-------

이제 컨트롤러가 작동 중입니다! 브라우저에 ``[your-site-url]index.php/pages/view``
를 입력하여 페이지에 접속해 보세요. ``index.php/pages/view/about`` 접속하면 
header와 footer를 포함한 about 페이지가 표시됩니다.

사용자 지정 라우팅 규칙을 사용하면 모든 URI를 모든 컨트롤러 및 메서드에
매핑 할 수 있으며, 일반적인 규칙을 벗어날 수 있습니다. 
``http://example.com/[controller-class]/[controller-method]/[arguments]``

한번 해봅시다. *application/Config/Routes.php* 에 있는 라우팅 파일을 열고 다음 두 줄을 
추가하고 ``$route`` 변수에 추가된 다른 모든 코드는 제거하십시오 .

::

	$routes->setDefaultController('Pages/view');
	$routes->add('(:any)', 'Pages::view/$1');

CodeIgniter는 라우팅 규칙을 위에서 아래로 읽고 요청에 대해 첫 번째로
일치하는 규칙으로 라우팅합니다. 각 규칙은 슬래시로 구분 된 컨트롤러
및 메서드 이름에 매핑 된 정규 표현식입니다. 요청이 들어 오면 
CodeIgniter는 첫 번째 일치 항목을 찾고 적절한 컨트롤러와 메소드에 
인수를 사용하여 호출합니다.

라우팅에 대한 자세한 내용은 URI 라우팅 :doc:`설명서 <../general/routing>`
를 참조하십시오.

여기서 ``$routes`` 배열 의 두 번째 규칙 ``(:any)`` 는 와일드 카드 문자열이며
모든 요청 과 일치 합니다. 매개 변수를 ``Pages`` 클래스 의 ``view()`` 
메서드에 전달합니다.

기본 컨트롤러를 사용하려면 경로를 처리하는 다른 경로가 정의되어 있지 
않은지 확인해야합니다. 기본적으로 경로 파일 에는 사이트 루트 (/)를 처리하는
경로가 있습니다. 다음 경로를 삭제하여 Pages 컨트롤러가 우리 홈 페이지를 
처리하는지 확인하십시오.

	$routes->add('/', 'Home::index');

지금 ``index.php/about`` 에 방문하세요. pages 컨트롤러의 ``view()`` 메소드로 
올바르게 라우팅 되었나요? 굉장하죠!