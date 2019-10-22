###########
컨트롤러
###########

컨트롤러는 HTTP 요청 처리 방법을 결정하며, 어플리케이션의 핵심입니다.

.. contents::
    :local:
    :depth: 2


컨트롤러란 무엇입니까?
=========================

컨트롤러는 URI와 연결될 수 있는 방식으로 이름 붙여진 클래스 파일이다.

다음 URI를 살펴보세요.::

	example.com/index.php/blog/

위의 예제에서 CodeIgniter는 Blog.php 라는 컨트롤러를 찾아 로드하려고 시도합니다.

**컨트롤러 이름이 URI의 첫 번째 세그먼트와 일치하면 로드됩니다.**

해봅시다 - Hello World!
==========================

간단한 컨트롤러를 만들어 실제로 볼 수 있도록 하겠습니다. 에디터를 사용하여 Blog.php 라는 파일을 만들고 다음 코드를 넣습니다.::

	<?php namespace App\Controllers;

	use CodeIgniter\Controller;

	class Blog extends Controller
        {
		public function index()
		{
			echo 'Hello World!';
		}
	}

그런 다음 파일을 **/app/Controllers/** 디렉토리에 저장하십시오.

.. important:: 'Blog.php'는 대문자 'B'로 시작되어야 합니다.

이제 이와 유사한 URL을 사용하여 사이트를 방문하십시오.::

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

또한 컨트롤러가 항상 모든 메서드를 상속할 수 있도록 상위 컨트롤러 클래스를 확장해야 합니다.

메서드
=========

위 예제에서 메서드 이름은 ``index()``\ 입니다.
URI의 **두 번째 세그먼트**\ 가 비어 있으면 "index" 메서드가 항상 기본적으로 로드됩니다.
"Hello World" 메시지를 표시하는 다른 방법은 다음과 같습니다.::

	example.com/index.php/blog/index/

**URI의 두 번째 세그먼트는 컨트롤러에서 호출할 메서드를 결정합니다.**

컨트롤러에 새로운 메서드를 추가해봅시다.::

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

이제 다음 URL을로드하여 comments 메서드를 봅니다.::

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

Any extra segments after the method name are passed into ``_remap()``. These parameters can be passed to the method
to emulate CodeIgniter's default behavior.

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

Private methods
===============

In some cases, you may want certain methods hidden from public access.
In order to achieve this, simply declare the method as being private
or protected and it will not be served via a URL request. For example,
if you were to have a method like this::

	protected function utility()
	{
		// some code
	}

Trying to access it via the URL, like this, will not work::

	example.com/index.php/blog/utility/

Organizing Your Controllers into Sub-directories
================================================

If you are building a large application you might want to hierarchically
organize or structure your controllers into sub-directories. CodeIgniter
permits you to do this.

Simply create sub-directories under the main *app/Controllers/*
one and place your controller classes within them.

.. note:: When using this feature the first segment of your URI must
	specify the folder. For example, let's say you have a controller located
	here::

		app/Controllers/products/Shoes.php

	To call the above controller your URI will look something like this::

		example.com/index.php/products/shoes/show/123

Each of your sub-directories may contain a default controller which will be
called if the URL contains *only* the sub-directory. Simply put a controller
in there that matches the name of your 'default_controller' as specified in
your *app/Config/Routes.php* file.

CodeIgniter also permits you to remap your URIs using its :doc:`URI Routing <routing>` feature.


Included Properties
===================

Every controller you create should extend ``CodeIgniter\Controller`` class.
This class provides several features that are available to all of your controllers.

**Request Object**

The application's main :doc:`Request Instance </incoming/request>` is always available
as a class property, ``$this->request``.

**Response Object**

The application's main :doc:`Response Instance </outgoing/response>` is always available
as a class property, ``$this->response``.

**Logger Object**

An instance of the :doc:`Logger <../general/logging>` class is available as a class property,
``$this->logger``.

**forceHTTPS**

A convenience method for forcing a method to be accessed via HTTPS is available within all
controllers::

	if (! $this->request->isSecure())
	{
		$this->forceHTTPS();
	}

By default, and in modern browsers that support the HTTP Strict Transport Security header, this
call should force the browser to convert non-HTTPS calls to HTTPS calls for one year. You can
modify this by passing the duration (in seconds) as the first parameter::

	if (! $this->request->isSecure())
	{
		$this->forceHTTPS(31536000);    // one year
	}

.. note:: A number of :doc:`time-based constants </general/common_functions>` are always available for you to use, including YEAR, MONTH, and more.

helpers
-------

You can define an array of helper files as a class property. Whenever the controller is loaded,
these helper files will be automatically loaded into memory so that you can use their methods anywhere
inside the controller::

	namespace App\Controllers;
        use CodeIgniter\Controller;

	class MyController extends Controller
	{
		protected $helpers = ['url', 'form'];
	}

Validating data
======================

The controller also provides a convenience method to make validating data a little simpler, ``validate()`` that
takes an array of rules to test against as the first parameter, and, optionally,
an array of custom error messages to display if the items don't pass. Internally, this uses the controller's
**$this->request** instance to get the data through. The :doc:`Validation Library docs </libraries/validation>`
has details on the format of the rules and messages arrays, as well as available rules.::

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

If you find it simpler to keep the rules in the configuration file, you can replace the $rules array with the
name of the group, as defined in ``Config\Validation.php``::

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

.. note:: Validation can also be handled automatically in the model. Where you handle validation is up to you,
            and you will find that some situations are simpler in the controller than then model, and vice versa.

That's it!
==========

That, in a nutshell, is all there is to know about controllers.
