###########
컨트롤러
###########

컨트롤러는 HTTP 요청 처리 방법을 결정하며, 어플리케이션의 핵심입니다.

.. contents::
    :local:
    :depth: 2


컨트롤러란 무엇입니까?
=========================

컨트롤러는 URI와 연결될 수 있는 방식으로 이름 붙여진 클래스 파일입니다.

다음 URI를 살펴보세요.

::

	example.com/index.php/blog/

위의 예제에서 CodeIgniter는 Blog.php 라는 컨트롤러를 찾아 로드하려고 시도합니다.

**컨트롤러 이름이 URI의 첫 번째 세그먼트와 일치하면 로드됩니다.**

해봅시다 - Hello World!
==========================

간단한 컨트롤러를 만들어 실제로 볼 수 있도록 하겠습니다. 에디터를 사용하여 Blog.php 라는 파일을 만들고 다음 코드를 넣습니다.

::

	<?php namespace App\Controllers;

	use CodeIgniter\Controller;

	class Blog extends Controller
        {
		public function index()
		{
			echo 'Hello World!';
		}
	}

이 파일을 **/app/Controllers/** 디렉토리에 저장합니다.

.. important:: 'Blog.php'는 대문자 'B'로 시작되어야 합니다.

이제 이와 유사한 URL을 사용하여 사이트를 방문하십시오.

::

	example.com/index.php/blog

제대로 했다면 결과는::

	Hello World!

.. important:: 클래스 이름은 대문자로 시작해야합니다.

올바른 예::

	<?php namespace App\Controllers;

	use CodeIgniter\Controller;

	class Blog extends Controller {

	}

틀린 예::

	<?php namespace App\Controllers;

	use CodeIgniter\Controller;

	class blog extends Controller {

	}

여러분이 작성한 컨트롤러가 모든 메서드를 상속받을 수 있도록 상위 컨트롤러 클래스를 확장해야 합니다.

메서드
=========

위 예제에서 메서드 이름은 ``index()``\ 입니다.
URI의 **두 번째 세그먼트**\ 가 비어 있으면 "index" 메서드가 항상 기본적으로 로드됩니다.
"Hello World" 메시지를 표시하는 다른 방법은 다음과 같습니다.

::

	example.com/index.php/blog/index/

**URI의 두 번째 세그먼트는 컨트롤러에서 호출할 메서드를 결정합니다.**

컨트롤러에 새로운 메서드를 추가해 봅시다.

::

	<?php namespace App\Controllers;

	use CodeIgniter\Controller;

	class Blog extends Controller
        {

		public function index()
		{
			echo 'Hello World!';
		}

		public function comments()
		{
			echo 'Look at this!';
		}
	}

이제 다음 URL을 로드하여 comments 메서드를 봅니다.::

	example.com/index.php/blog/comments/

새로운 메시지가 표시됩니다.

메서드에 URI 세그먼트 전달
====================================

URI에 세 개 이상의 세그먼트가 포함되어 있으면 메서드에 매개 변수(parameters)로 전달됩니다.

예를 들어 이와 같은 URI가 있다고 가정 해 봅시다.::

	example.com/index.php/products/shoes/sandals/123

메서드에 URI 세그먼트 3과 세그먼트 4가 전달됩니다. ("sandals" 와 "123")::

	<?php namespace App\Controllers;

	use CodeIgniter\Controller;

	class Products extends Controller
        {

		public function shoes($sandals, $id)
		{
			echo $sandals;
			echo $id;
		}
	}

.. important:: :doc:`URI 라우팅 <routing>` 기능을 사용하는 경우 메서드에 전달 된 세그먼트가 다시 라우팅됩니다.

기본 컨트롤러 정의
=============================

사이트 루트 URL만 요청하는 경우와 같이 URI가 없는 경우, 기본 컨트롤러를 로드하도록 CodeIgniter에 지시할 수 있습니다.
기본 컨트롤러를 지정하려면 **app/Config/Routes.php** 파일을 열고 아래 부분을 수정하십시오.

::

	$routes->setDefaultController('Blog');

여기서 'Blog'는 사용하려는 기본 컨트롤러 클래스의 이름입니다.
URI 세그먼트를 지정하지 않고 기본 index.php 파일을 로드하면 기본적으로 "Hello World" 메시지가 표시됩니다.

자세한 내용은 :doc:`URI 라우팅 <routing>` 설명서의 "라우트 구성 옵션" 섹션을 참조하십시오.

리매핑 메서드 호출
======================

위에서 언급 한 바와 같이, URI의 두 번째 세그먼트는 일반적으로 컨트롤러에서 호출되는 메서드를 결정합니다.
``_remap()`` 메서드를 사용하면 CodeIgniter의 이 동작을 재정의 할 수 있습니다.

::

	public function _remap()
	{
		// Some code here...
	}

.. important:: 컨트롤러에 _remap()\ 이라는 메서드가 포함되어 있으면 URI에 포함 된 내용에 관계없이 **항상** 호출됩니다.
	URI는 어떤 메서드가 호출되는지 판별하여 사용자 고유의 메서드 라우팅 규칙을 정의할 수 있는 일반적인 동작을 대체합니다.

재정의 된 메서드 호출(일반적으로 URI의 두 번째 세그먼트)은 ``_remap()`` 메서드에 매개 변수로 전달됩니다.
::

	public function _remap($method)
	{
		if ($method === 'some_method')
		{
			$this->$method();
		}
		else
		{
			$this->default_method();
		}
	}

메서드 이름 뒤의 추가 세그먼트는 ``_remap()``\ 에 전달됩니다.
이러한 매개 변수는 CodeIgniter의 기본 동작을 에뮬레이트하기 위해 메서드로 전달될 수 있습니다.

Example::

	public function _remap($method, ...$params)
	{
		$method = 'process_'.$method;
		if (method_exists($this, $method))
		{
			return $this->$method(...$params);
		}
		throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound();
	}

비공개 메서드
===============

경우에 따라 외부에 특정 메서드를 숨겨야할 수도 있습니다.
메서드를 private 또는 protected로 선언하면 URL 요청을 통해 접근할 수 없습니다.
이와 같은 방법을 사용한 예입니다.

::

	protected function utility()
	{
		// some code
	}

아래와 같이 URL을 통해 액세스하려고 하면 동작하지 않습니다.

::

	example.com/index.php/blog/utility/

컨트롤러를 하위 디렉토리로 구성
================================================

CodeIgniter를 사용하면 컨트롤러를 하위(sub) 디렉터리에 계층적으로 구성하여 큰 어플리케이션을 구축할 수 있습니다.

메인 *app/Controllers/* 아래에 하위 디렉토리를 만들고 그 안에 컨트롤러 클래스를 배치하십시오.

.. note:: 이 기능을 사용할 때 URI의 첫 번째 세그먼트는 폴더를 지정해야 합니다.
	예를 들어 다음과 같은 컨트롤러가 있다고 가정해 봅시다.
	
	::

		app/Controllers/products/Shoes.php

	위의 컨트롤러를 호출하기 위한 URI는 다음과 같습니다.
	
	::

		example.com/index.php/products/shoes/show/123

각 하위 디렉토리에는 URL에 하위 디렉토리만 호출하는 경우를 위하여 기본 컨트롤러가 지정할 수 있습니다.
*app/Config/Routes.php* 파일의 'default_controller'\ 에 이를 위한 컨트롤러를 지정하십시오.

CodeIgniter에서는 :doc:`URI 라우팅 <routing>` 기능을 사용하여 URI를 다시 매핑할 수도 있습니다.

포함된 속성
===================

생성하는 모든 컨트롤러는 ``CodeIgniter\Controller`` 클래스를 확장해야 합니다.
이 클래스는 모든 컨트롤러에서 사용할 수 있는 몇 가지 기능을 제공합니다.

**Request Object**

어플리케이션의 :doc:`Request 인스턴스 </incoming/request>`\ 는 클래스의 ``$this->request`` 속성으로 제공됩니다.

**Response Object**

어플리케이션의 :doc:`Response 인스턴스 </outgoing/response>`\ 는 클래스의 ``$this->response`` 속성으로 제공됩니다.

**Logger Object**

:doc:`Logger <../general/logging>` 클래스의 인스턴스는 클래스 ``$this->logger`` 속성으로 제공됩니다.

**forceHTTPS**

HTTPS를 통해 메서드에 액세스할 수있는 편리한 메서드를 모든 컨트롤러에서 사용할 수 있습니다.

::

	if (! $this->request->isSecure())
	{
		$this->forceHTTPS();
	}

기본적으로, HTTP Strict Transport Security 헤더를 지원하는 최신 브라우저는 이 호출을 통하여 HTTPS가 아닌 호출을 1년 동안 HTTPS 호출로 변환하도록 강제합니다.
지속 시간(초)은 매개 변수를 전달하여 수정할 수 있습니다.

::

	if (! $this->request->isSecure())
	{
		$this->forceHTTPS(31536000);    // one year
	}

.. note:: 숫자 대신 YEAR, MONTH등 :doc:`시간 기반 상수 </general/common_functions>`\ 를 사용할 수도 있습니다.

헬퍼
-------

클래스 속성에 헬퍼를 배열로 정의할 수 있습니다.
컨트롤러가 로드될 때마다 정의된 헬퍼도 자동으로 로드되며, 컨트롤러 내부의 어느 위치에서든 헬퍼에 정의된 메서드를 사용할 수 있습니다.

::

	namespace App\Controllers;
        use CodeIgniter\Controller;

	class MyController extends Controller
	{
		protected $helpers = ['url', 'form'];
	}

데이터 검증
======================

컨트롤러는 데이터를 좀 더 간단하게 검증할 수 있는 방법을 제공합니다. 
이는 매개 변수로 테스트할 규칙을 배열로 전달하고, 검증을 통과하지 못한 항목을 표시할 사용자 정의 오류 메시지를 배열로 받을수 있습니다.
이 데이타는 컨트롤러 내부의 **$this->request** 인스턴스를 사용하여 가져옵니다.
:doc:`유효성 검사 라이브러리 문서 </libraries/validation>`\ 에는 이에 대한 메시지 배열의 형식과 사용 가능한 규칙에 대한 세부 정보가 있습니다.

::

    public function updateUser(int $userID)
    {
        if (! $this->validate([
            'email' => "required|is_unique[users.email,id,{$userID}]",
            'name'  => 'required|alpha_numeric_spaces'
        ]))
        {
            return view('users/update', [
                'errors' => $this->validator->getErrors()
            ]);
        }

        // do something here if successful...
    }

``Config\Validation.php``\ 에 정의된 규칙의 그룹 이름을 ``$rules`` 배열에 명시하여 간단하게 구성 파일에 정의된 규칙을 적용할 수 있습니다.

::

    public function updateUser(int $userID)
    {
        if (! $this->validate('userRules'))
        {
            return view('users/update', [
                'errors' => $this->validator->getErrors()
            ]);
        }

        // do something here if successful...
    }

.. note:: 모델에서 유효성 검사를 자동으로 처리할 수 있습니다.
		유효성 검사를 처리하는 위치는 사용자의 결정에 달려 있으며, 상황에 따라 컨트롤러에서 하는 것보다 단순할 수도 있고 그 반대인 경우도 있습니다.

이게 다임!
============

이것이 컨트롤러에 대해 알아야 할 모든 것입니다.
