############
News section
############

이전 섹션에서는 정적 페이지를 포함하는 클래스를 작성하여 프레임 워크의
몇 가지 기본 개념을 살펴 보고, 사용자 라우팅 규칙을 추가하여 URI를 
정리했습니다. 이제 동적 컨텐츠를 소개하고 데이터베이스를 사용할 차례입니다.

모델(Model) 설정
---------------------

컨트롤러에 바로 데이터베이스 작업을 작성하는 대신 쿼리를 모델에 작성하면
나중에 다시 사용하기 쉽습니다. 모델은 데이터베이스나 다른 데이터 저장소의
정보를 검색, 삽입 및 업데이트하는 곳입니다. 모델은 데이터에 대한 액세스를
제공합니다.

*application/Models/* 디렉토리에 *NewsModel.php* 라는 새 파일을 만들고 
다음 코드를 추가하십시오. :doc:`여기 <../database/configuration>` 에 설명
된대로 데이터베이스를 올바르게 구성했는지 확인 하십시오.

::

	<?php

	namespace App\Models;

	class NewsModel extends \CodeIgniter\Model
	{
		protected $table = 'news';
	}


이 코드는 이전에 사용 된 컨트롤러 코드와 유사합니다. ``CodeIgniter\Model`` 을 
확장하여 새 모델을 작성 하고 데이터베이스 라이브러리를 로드합니다 . 이렇게하면
데이터베이스 클래스를 ``$ this-> db`` 객체를 통해 사용할 수 있게됩니다..


데이터베이스를 조회하기 전에 데이터베이스 스키마를 작성해야합니다. 
데이터베이스에 연결하고 아래의 SQL 명령을 실행하십시오 (MySQL). 
그리고 몇 가지 시드 데이타를 추가하십시오. 지금은 테이블 생성에 필요한 쿼리를
보여 드리 겠지만 더 유용한 데이터베이스 설정을 만들기 위해서는 :doc:`마이그레이션 <../dbmgmt/migration>` 및
:doc:`시드 <../dbmgmt/seeds>` 에 대해 알아야 합니다.

::

	CREATE TABLE news (
		id int(11) NOT NULL AUTO_INCREMENT,
		title varchar(128) NOT NULL,
		slug varchar(128) NOT NULL,
		text text NOT NULL,
		PRIMARY KEY (id),
		KEY slug (slug)
	);


이제 데이터베이스와 모델이 설정되었으므로 데이터베이스에서 모든 게시물을
가져올 수 있는 방법이 필요합니다. 이를 위해 CodeIgniter — 
:doc:`Query Builder <../database/query_builder>` —에 포함 된 데이터베이스
추상화 계층이 사용됩니다. 이렇게 '쿼리'를 한 번 작성하면 :doc:`지원되는 모든
데이터베이스 시스템 <../intro/requirements>` 에서 작동되게 할 수 있습니다.
Model 클래스를 사용하면 쿼리 작성기(Query Builder)로 쉽게 작업 할 수 있으며 
데이터를보다 쉽게 작업 할 수있는 몇 가지 추가 도구를 제공합니다. 
모델에 다음 코드를 추가하십시오.

::

	public function getNews($slug = false)
	{
		if ($slug === false)
		{
			return $this->findAll();
		}

		return $this->asArray()
		             ->where(['slug' => $slug])
		             ->first();
	}

이 코드를 사용하면 두 가지 다른 쿼리를 수행 할 수 있습니다. 모든 뉴스 
기록을 가져올 수 있으며, 자신의 `slug <#>`_ 로 뉴스 항목을 얻을 수 있습니다.
``$slug`` 쿼리를 실행하기 전에 변수가 삭제되지 않았다는 사실을 알았을
수도 있습니다 . :doc:`Query Builder <../database/query_builder>` 가 이 작업을 수행합니다.

모델 클래스에서 제공 된는 ``findAll()`` 과 ``first()`` 두 가지 메소드가 여기에 사용되었습니다.
이 메소드들은 **NewsModel** 클래스 ``$table`` 속성에 설정한 값을 기반으로 사용할
테이블을 이미 알고 있습니다. 이 메소드들은 쿼리 작성기(Query Builder)를 사용하여 현재
테이블에 명령을 실행하고 Select한 결과 값을 배열로 반환하는 헬퍼 메서드입니다.
이 예제에서는 ``findAll()`` 이 객체의 배열을 반환합니다.

뉴스 표시
----------------

이제 쿼리가 작성되었으므로 사용자에게 뉴스 항목을 표시 할 view에 모델을 연결해야합니다.
이전에 작성한 ``Pages`` 컨트롤러에서 이 작업을 수행 할 수 있지만 명확함을
위해 새 ``News`` 컨트롤러를 *application/Controllers/News.php* 에 만듭니다.

::

	<?php namespace App\Controllers;

	use App\Models\NewsModel;

	class News extends \CodeIgniter\Controller
	{
		public function index()
		{
			$model = new NewsModel();

			$data['news'] = $model->getNews();
		}

		public function view($slug = null)
		{
			$model = new NewsModel();

			$data['news'] = $model->getNews($slug);
		}
	}


코드를 보면 앞에서 만든 파일과 약간의 유사점을 볼 수 있습니다.
먼저, 핵심적인 CodeIgniter 클래스인 ``Controller`` 를 확장합니다.
이 클래스는 몇가지 도우미 메소드와 ``Request`` 와 ``Response`` 
정보를 디스크에 저장하기위한 클래스 ``Logger`` 객체에 접근 할 수 있게
해줍니다.


다음으로, 모든 뉴스 항목을 보는 방법과 특정 뉴스 항목을 보는 방법 두 가지가
있습니다. ``$slug`` 변수가 두 번째 메소드에서 모델의 메소드로 전달됨을 알 
수 있습니다 . 이 모델은 슬러그를 사용하여 반환 할 뉴스 항목을 식별합니다.

이제 데이터는 컨트롤러를 통해 모델에서 검색되지만 아무 것도 표시되지 
않습니다. 다음으로 할 일은이 데이터를 view에 전달하는 것입니다. 다음과 같이
``index()`` 메소드를 수정하십시오 .

::

	public function index()
	{
		$model = new NewsModel();

		$data = [
			'news'  => $model->getNews(),
			'title' => 'News archive',
		];

		echo view('templates/header', $data);
		echo view('news/index', $data);
		echo view('templates/footer');
	}

위의 코드는 모델의 모든 뉴스 레코드를 가져 와서 변수에 할당합니다. 
제목의 값도 ``$data['title']`` 요소에 할당되어 모든 데이터가 뷰에 전달됩니다.
이제 뉴스 항목을 렌더링하는 view를 만들어야합니다. *application/Views/news/index.php*
에 다음 코드를 추가하세요.

::

	<h2><?= $title ?></h2>

	<?php if (! empty($news) && is_array($news)) : ?>

		<?php foreach ($news as $news_item): ?>

			<h3><?= $news_item['title'] ?></h3>

			<div class="main">
				<?= $news_item['text'] ?>
			</div>
			<p><a href="<?= '/news/'.$news_item['slug'] ?>">View article</a></p>

		<?php endforeach; ?>

	<?php else : ?>

		<h3>No News</h3>

		<p>Unable to find any news for you.</p>

	<?php endif ?>

여기에서는 각 뉴스 항목이 반복되어 사용자에게 표시됩니다. HTML과 혼합된
PHP로 템플릿을 작성한 것을 볼 수 있습니다. 템플릿 언어를 사용하고 싶다면
CodeIgniter의 :doc:`View Parser </outgoing/view_parser>` 나 third party
파서를 사용할 수 있습니다.


이제 뉴스 개요 페이지가 완료되었습니다. 아직 개별 뉴스 항목을 표시 할 
페이지는 없습니다. 이전에 생성 된 모델은 이 기능을 위해 쉽게 사용할 수
있도록 만들어졌습니다. 컨트롤러에 코드를 추가하고 새 view를 만들어야 
합니다. ``News`` 컨트롤러로 돌아가서 ``view()`` 를 다음과 같이 업데이트 하십시오.

::

	public function view($slug = NULL)
	{
		$model = new NewsModel();

		$data['news'] = $model->getNews($slug);

		if (empty($data['news']))
		{
			throw new \CodeIgniter\PageNotFoundException('Cannot find the page: '. $slug);
		}

		$data['title'] = $data['news']['title'];

		echo view('templates/header', $data);
		echo view('news/view', $data);
		echo view('templates/footer');
	}


매개 변수없이 ``getNews()`` 메서드를 호출하는 대신 ``$slug`` 변수가 
전달되므로 특정 뉴스 항목이 반환됩니다. 이제 남은일은 view를 생성하는 것
입니다. *application/Views/news/view.php* 파일에 다음 코드를 입력하십시오.

::

	<?php
	echo '<h2>'.$news['title'].'</h2>';
	echo $news['text'];

Routing
-------

방금 작성한 컨트롤러를 보려면 이전에 작성된 와일드 카드 라우팅 규칙에
추가 라우트가 필요합니다. 라우팅 파일 (*application/config/routes.php*) 을
다음과 같이 수정하십시오 . 이렇게하면 요청이 ``Pages`` 컨트롤러로 전달
되는 않고 ``News`` 컨트롤러에 도달 하게됩니다. 첫 번째 줄은 슬러그가있는 
URI를 ``News`` 컨트롤러 의 ``view()`` 메서드로 라우팅합니다.

::

	$routes->get('news/(:segment)', 'News::view/$1');
	$routes->get('news', 'News::index');
	$routes->get('(:any)', 'Pages::view/$1');

브라우저에서 document root로 이동 한 다음 index.php news를 입력하여 뉴스를보십시오.
