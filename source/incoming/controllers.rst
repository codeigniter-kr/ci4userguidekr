###########
컨트롤러
###########

Controllers are the heart of your application, as they determine how HTTP requests should be handled.
컨트롤러는 HTTP 요청 처리 방법을 결정할 때 응용 프로그램의 핵심입니다.

.. contents::
    :local:
    :depth: 2

컨트롤러란 무엇입니까?
=====================

A Controller is simply a class file that is named in a way that it can be associated with a URI.
컨트롤러는 단순히 URI와 연관 될 수있는 방식으로 명명 된 클래스 파일입니다.

Consider this URI
다음 URI를 고려하십시오.

::

	example.com/index.php/blog/

In the above example, CodeIgniter would attempt to find a controller named Blog.php and load it.
위의 예에서 CodeIgniter는 Blog.php라는 컨트롤러를 찾고로드하려고합니다.

**When a controller's name matches the first segment of a URI, it will be loaded.**
컨트롤러의 이름이 URI의 첫 번째 세그먼트와 일치하면로드됩니다.

Let's try it: Hello World!
==========================

Let's create a simple controller so you can see it in action. Using your text editor, create a file called Blog.php,
and put the following code in it
간단한 컨트롤러를 만들어 실제 상황을 볼 수 있습니다. 텍스트 편집기를 사용하여 Blog.php라는 파일을 만들고 다음 코드를 입력하십시오.

::

	<?php
	class Blog extends \CodeIgniter\Controller
	{
		public function index()
		{
			echo 'Hello World!';
		}
	}

Then save the file to your **/application/Controllers/** directory.
그런 다음 / application / Controllers / 디렉토리에 파일을 저장하십시오.

.. important:: The file must be called 'Blog.php', with a capital 'B'.
			   파일은 'B'와 함께 'Blog.php'라고해야합니다.

Now visit your site using a URL similar to this
이제 이와 비슷한 URL을 사용하여 사이트를 방문하십시오.

::

	example.com/index.php/blog

If you did it right, you should see
너가 그것을 올바르게하면, 너는 볼 것임에 틀림 없다

::

	Hello World!

.. important:: Class names must start with an uppercase letter.
			   클래스 이름은 대문자로 시작해야합니다.

This is valid
이것은 유효합니다

::

	<?php
	class Blog extends \CodeIgniter\Controller {

	}

This is **not** valid
이것은 유효 하지 않습니다 

::

	<?php
	class blog extends \CodeIgniter\Controller {

	}

Also, always make sure your controller extends the parent controller
class so that it can inherit all its methods.
또한 항상 컨트롤러가 부모 컨트롤러 클래스를 확장하여 모든 메서드를 상속받을 수 있는지 확인하십시오.

Methods
=======

In the above example the method name is ``index()``. The "index" method
is always loaded by default if the **second segment** of the URI is
empty. Another way to show your "Hello World" message would be this
위의 예제에서 메소드 이름은 index()입니다. "index"메서드는 URI 의 두 번째 세그먼트 가 비어있는 경우 항상 기본적으로로드됩니다 . "Hello World"메시지를 표시하는 또 다른 방법은 다음과 같습니다.

::

	example.com/index.php/blog/index/

**The second segment of the URI determines which method in the
controller gets called.**
URI의 두 번째 세그먼트는 컨트롤러에서 어떤 메소드가 호출되는지 결정합니다.

Let's try it. Add a new method to your controller
해 보자. 귀하의 컨트롤러에 새로운 방법을 추가하십시오

::

	<?php
	class Blog extends \CodeIgniter\Controller {

		public function index()
		{
			echo 'Hello World!';
		}

		public function comments()
		{
			echo 'Look at this!';
		}
	}

Now load the following URL to see the comment method
이제 다음 URL을로드하여 주석 메서드를 봅니다.

::

	example.com/index.php/blog/comments/

You should see your new message.
새 메시지가 나타납니다.

Passing URI Segments to your methods
====================================

If your URI contains more than two segments they will be passed to your
method as parameters.
URI에 두 개 이상의 세그먼트가 있으면 매개 변수로 메소드에 전달됩니다.

For example, let's say you have a URI like this
예를 들어 다음과 같은 URI가 있다고 가정 해 보겠습니다.

::

	example.com/index.php/products/shoes/sandals/123

Your method will be passed URI segments 3 and 4 ("sandals" and "123")
메서드에는 URI 세그먼트 3과 4 ( "샌들"과 "123")가 전달됩니다.

::

	<?php
	class Products extends \CodeIgniter\Controller {

		public function shoes($sandals, $id)
		{
			echo $sandals;
			echo $id;
		}
	}

.. important:: If you are using the :doc:`URI Routing <routing>`
	feature, the segments passed to your method will be the re-routed
	ones.
	URI 라우팅 기능을 사용하는 경우 메서드에 전달 된 세그먼트는 재 라우팅 된 세그먼트가됩니다.

Defining a Default Controller
=============================

CodeIgniter can be told to load a default controller when a URI is not
present, as will be the case when only your site root URL is requested.
To specify a default controller, open your **application/Config/Routes.php**
file and set this variable
CodeIgniter는 사이트 루트 URL 만 요청할 때와 같이 URI가 없으면 기본 컨트롤러를로드하라는 메시지를 표시 할 수 있습니다. 기본 컨트롤러를 지정하려면 application/Config/Routes.php 파일을 열고이 변수를 설정하십시오.

::

	$routes->setDefaultController('Blog');

Where 'Blog' is the name of the controller class you want used. If you now
load your main index.php file without specifying any URI segments you'll
see your "Hello World" message by default.
여기서 'Blog'는 사용하려는 컨트롤러 클래스의 이름입니다. URI 세그먼트를 지정하지 않고 기본 index.php 파일을로드하면 기본적으로 "Hello World"메시지가 표시됩니다.

For more information, please refer to the "Routes Configuration Options" section of the
:doc:`URI Routing <routing>` documentation.
자세한 내용은 URI 라우팅 설명서 의 "경로 구성 옵션"섹션을 참조하십시오.

Remapping Method Calls
======================

As noted above, the second segment of the URI typically determines which
method in the controller gets called. CodeIgniter permits you to override
this behavior through the use of the ``_remap()`` method
위에서 언급했듯이 URI의 두 번째 세그먼트는 일반적으로 컨트롤러의 어떤 메소드가 호출되는지를 결정합니다. CodeIgniter를 사용하면 _remap()메소드 사용을 통해이 동작을 재정의 할 수 있습니다 .

::

	public function _remap()
	{
		// Some code here...
	}

.. important:: If your controller contains a method named _remap(),
	it will **always** get called regardless of what your URI contains. It
	overrides the normal behavior in which the URI determines which method
	is called, allowing you to define your own method routing rules.
	컨트롤러에 _remap () 메서드가 있으면 URI에 상관없이 항상 호출됩니다. 이 메소드는 URI가 어떤 메소드가 호출되는지 결정하는 정상적인 동작을 무시하므로 사용자 고유의 메소드 라우팅 규칙을 정의 할 수 있습니다.

The overridden method call (typically the second segment of the URI) will
be passed as a parameter to the ``_remap()`` method
재정의 된 메서드 호출 (일반적으로 URI의 두 번째 세그먼트)은 _remap()메서드에 매개 변수로 전달됩니다 .

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
메서드 이름 뒤에 여분의 세그먼트가 전달됩니다 _remap(). CodeIgniter의 기본 동작을 에뮬레이트하기 위해 이러한 매개 변수를 메서드에 전달할 수 있습니다.

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

In some cases you may want certain methods hidden from public access.
In order to achieve this, simply declare the method as being private
or protected and it will not be served via a URL request. For example,
if you were to have a method like this
경우에 따라 공개 액세스에서 특정 방법을 숨길 수 있습니다. 이를 달성하려면 메소드를 개인용 또는 보호 된 것으로 선언하고 URL 요청을 통해 메소드를 제공하지 마십시오. 예를 들어, 다음과 같은 메소드가있는 경우

::

	protected function utility()
	{
		// some code
	}

Trying to access it via the URL, like this, will not work
URL을 통해 액세스하려고하면 다음과 같이 작동하지 않습니다.

::

	example.com/index.php/blog/utility/

Organizing Your Controllers into Sub-directories
================================================

If you are building a large application you might want to hierarchically
organize or structure your controllers into sub-directories. CodeIgniter
permits you to do this.
대형 응용 프로그램을 빌드하는 경우 컨트롤러를 하위 디렉토리로 계층 적으로 구성하거나 구조화 할 수 있습니다. CodeIgniter는 이것을 허용합니다.

Simply create sub-directories under the main *application/Controllers/*
one and place your controller classes within them.
주 응용 프로그램 / Controllers / one 하위에 하위 디렉토리를 만들고 그 안에 컨트롤러 클래스를 배치하면됩니다.

.. note:: When using this feature the first segment of your URI must
	specify the folder. For example, let's say you have a controller located
	here
	이 기능을 사용하는 경우 URI의 첫 번째 세그먼트에서 폴더를 지정해야합니다. 예를 들어 여기에 컨트롤러가 있다고 가정 해 보겠습니다.
	
	::

		application/controllers/products/Shoes.php

	To call the above controller your URI will look something like this
	위의 컨트롤러를 호출하려면 URI가 다음과 같이 표시됩니다.
	
	::

		example.com/index.php/products/shoes/show/123

Each of your sub-directories may contain a default controller which will be
called if the URL contains *only* the sub-directory. Simply put a controller
in there that matches the name of your 'default_controller' as specified in
your *application/Config/Routes.php* file.
각 하위 디렉토리에는 URL 에 하위 디렉토리 만 포함되어있는 경우 호출 될 기본 컨트롤러가있을 수 있습니다 . application / Config / Routes.php 파일에 지정된대로 'default_controller'의 이름과 일치하는 컨트롤러를 입력하기 만하면 됩니다.

CodeIgniter also permits you to remap your URIs using its :doc:`URI Routing <routing>` feature.
CodeIgniter에서는 URI 라우팅 기능을 사용하여 URI 를 다시 매핑 할 수도 있습니다.

Included Properties
===================

Every controller you create should extend ``CodeIgniter\Controller`` class.
This class provides several features that are available to all of your controllers.
당신이 만드는 모든 컨트롤러는 CodeIgniter\Controller클래스 를 확장해야합니다 . 이 클래스는 모든 컨트롤러에서 사용할 수있는 몇 가지 기능을 제공합니다.

**Request Object**

The application's main :doc:`Request Instance </incoming/request>` is always available
as a class property, ``$this->request``.
응용 프로그램의 기본 요청 인스턴스 는 항상 클래스 속성으로 사용할 수 있습니다 $this->request.

**Response Object**

The application's main :doc:`Response Instance </outgoing/response>` is always available
as a class property, ``$this->response``.
응용 프로그램의 주 응답 인스턴스 는 항상 클래스 속성으로 사용할 수 있습니다 $this->response.

**Logger Object**

An instance of the :doc:`Logger <../general/logging>` class is available as a class property,
``$this->logger``.
Logger 클래스 의 인스턴스 는 클래스 속성으로 사용할 수 있습니다 $this->logger.

**forceHTTPS**

A convenience method for forcing a method to be accessed via HTTPS is available within all
controllers
HTTPS를 통해 메소드에 액세스하도록하는 편리한 메소드는 모든 컨트롤러에서 사용할 수 있습니다.

::

	if (! $this->request->isSecure())
	{
		$this->forceHTTPS();
	}

By default, and in modern browsers that support the HTTP Strict Transport Security header, this
call should force the browser to convert non-HTTPS calls to HTTPS calls for one year. You can
modify this by passing the duration (in seconds) as the first parameter
기본적으로 HTTP Strict Transport Security 헤더를 지원하는 최신 브라우저에서이 호출은 브라우저가 HTTPS가 아닌 호출을 HTTPS 호출로 1 년 동안 변환하도록합니다. 지속 시간 (초)을 첫 번째 매개 변수로 전달하여이를 수정할 수 있습니다.

::

	if (! $this->request->isSecure())
	{
		$this->forceHTTPS(31536000);    // one year
	}

.. note:: A number of :doc:`time-based constants </general/common_functions>` are always available for you to use, including YEAR, MONTH, and more.
		  다수의 시간 기반의 상수는 사용하기 년, 월, 등을 포함, 항상 사용할 수 있습니다.

helpers
-------

You can define an array of helper files as a class property. Whenever the controller is loaded,
these helper files will be automatically loaded into memory so that you can use their methods anywhere
inside the controller
헬퍼 파일 배열을 클래스 속성으로 정의 할 수 있습니다. 컨트롤러가로드 될 때마다 이러한 헬퍼 파일이 자동으로 메모리에로드되므로 컨트롤러 내부의 아무 곳에서나 해당 메서드를 사용할 수 있습니다.

::

	class MyController extends \CodeIgniter\Controller
	{
		protected $helpers = ['url', 'form'];
	}

Validating $_POST data
======================

The controller also provides a convenience method to make validating $_POST data a little simpler, ``validate()`` that
takes an array of rules to test against as the first parameter, and, optionally,
an array of custom error messages to display if the items don't pass. Internally, this uses the controller's
**$this->request** instance to get the POST data through. The :doc:`Validation Library docs </libraries/validation>`
has details on the format of the rules and messages arrays, as well as available rules.
또한 컨트롤러는 $ _POST 데이터의 유효성을 검사하는 데 편리한 방법을 제공하며 validate(), 첫 번째 매개 변수로 테스트 할 규칙 배열을 사용하고 항목이 통과하지 않을 경우 표시 할 사용자 지정 오류 메시지 배열 (선택 사항)을 제공합니다. . 내부적으로 이것은 컨트롤러의 $ this-> 요청 인스턴스를 사용하여 POST 데이터를 가져옵니다. 검증 라이브러리 문서는 규칙과 메시지 배열의 형식에 대한 자세한 내용뿐만 아니라 가능한 규칙이 있습니다

::

    public function updateUser(int $userID)
    {
        if (! $this->validate([
            'email' => "required|is_unique[users.email,id,{$userID}]",
            'name'  => 'required|alpha_numeric_spaces'
        ]))
        {
            return view('users/update', [
                'errors' => $this->errors
            ]);
        }

        // do something here if successful...
    }

If you find it simpler to keep the rules in the configuration file, you can replace the $rules array with the
name of the group, as defined in ``Config\Validation.php``
구성 파일에 규칙을 유지하는 것이 더 간단하다면 $ rules 배열을 다음에 정의 된대로 그룹의 이름으로 바꿀 수 있습니다 Config\Validation.php.

::

    public function updateUser(int $userID)
    {
        if (! $this->validate('userRules'))
        {
            return view('users/update', [
                'errors' => $this->errors
            ]);
        }

        // do something here if successful...
    }

.. note:: Validation can also be handled automatically in the model. Where you handle validation is up to you,
            and you will find that some situations are simpler in the controller than then model, and vice versa.
          유효성 검사는 모델에서 자동으로 처리 될 수도 있습니다. 유효성 검사를 처리하는 곳은 당신에게 달려 있으며, 컨트롤러에서 모델보다 컨트롤러에서 더 단순한 상황을 발견 할 수 있습니다.

That's it!
==========

That, in a nutshell, is all there is to know about controllers.
요컨대, 컨트롤러에 대해 알아야 할 것이 전부입니다.