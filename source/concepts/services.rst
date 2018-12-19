########
Services
########

.. contents::
    :local:
    :depth: 2

Introduction
============

All of the classes within CodeIgniter are provided as "services". This simply means that, instead
of hard-coding a class name to load, the classes to call are defined within a very simple
configuration file. This file acts as a type of factory to create new instances of the required class.
CodeIgniter 내의 모든 클래스는 "서비스"로 제공됩니다. 이것은로드 할 클래스 이름을 하드 코딩하는 대신 호출 할 클래스가 매우 간단한 구성 파일 내에서 정의된다는 것을 의미합니다. 이 파일은 필수 클래스의 새 인스턴스를 작성하는 팩토리 유형으로 작동합니다.

A quick example will probably make things clearer, so imagine that you need to pull in an instance
of the Timer class. The simplest method would simply be to create a new instance of that class
빠른 예제를 사용하면 더 명확 해 지므로 Timer 클래스의 인스턴스를 가져와야한다고 상상해보십시오. 가장 간단한 방법은 해당 클래스의 새 인스턴스를 만드는 것입니다.

::

	$timer = new \CodeIgniter\Debug\Timer();

And this works great. Until you decide that you want to use a different timer class in its place.
Maybe this one has some advanced reporting the default timer does not provide. In order to do this,
you now have to locate all of the locations in your application that you have used the timer class.
Since you might have left them in place to keep a performance log of your application constantly
running, this might be a time-consuming and error-prone way to handle this. That's where services
come in handy.
그리고 위대한 작품. 그 자리에서 다른 타이머 클래스를 사용하기로 결정할 때까지. 기본 타이머가 제공하지 않는 고급보고가있을 수 있습니다. 이렇게하려면 이제 타이머 클래스를 사용하는 응용 프로그램의 모든 위치를 찾아야합니다. 응용 프로그램의 성능 로그를 지속적으로 유지하기 위해 이들을 그대로 두었을 수도 있기 때문에이 작업은 시간이 많이 걸리고 오류가 발생하기 쉬운 방법 일 수 있습니다. 그것이 서비스가 편리 해지는 곳입니다.

Instead of creating the instance ourself, we let a central class create an instance of the
class for us. This class is kept very simple. It only contains a method for each class that we want
to use as a service. The method typically returns a shared instance of that class, passing any dependencies
it might have into it. Then, we would replace our timer creation code with code that calls this new class
인스턴스를 직접 작성하는 대신 중앙 클래스에서 우리를 위해 클래스의 인스턴스를 만들도록합니다. 이 클래스는 매우 단순하게 유지됩니다. 여기에는 서비스로 사용할 각 클래스에 대한 메소드 만 포함됩니다. 이 메소드는 일반적으로 클래스의 공유 인스턴스를 반환하고 종속 관계를 공유 인스턴스로 전달합니다. 그런 다음 타이머 생성 코드를이 새 클래스를 호출하는 코드로 바꿉니다.

::

	$timer = \Config\Services::timer();

When you need to change the implementation used, you can modify the services configuration file, and
the change happens automatically throughout your application without you having to do anything. Now
you just need to take advantage of any new functionality and you're good to go. Very simple and
error-resistant.
사용 된 구현을 변경해야하는 경우 서비스 구성 파일을 수정할 수 있으며, 변경 작업 없이도 응용 프로그램 전체에서 자동으로 변경됩니다. 이제 새로운 기능을 활용하면 좋은 것입니다. 매우 간단하고 오류가 발생하지 않습니다.

.. note:: It is recommended to only create services within controllers. Other files, like models and libraries should have the dependencies either passed into the constructor or through a setter method.
          컨트롤러 내에서만 서비스를 생성하는 것이 좋습니다. 모델과 라이브러리와 같은 다른 파일은 생성자에 전달 된 종속성을 갖거나 setter 메서드를 통해 전달되어야합니다.


Convenience Functions
---------------------

Two functions have been provided for getting a service. These functions are always available.
서비스를 받기위한 두 가지 기능이 제공됩니다. 이 기능은 항상 사용할 수 있습니다.

The first is ``service()`` which returns a new instance of the requested service. The only
required parameter is the service name. This is the same as the method name within the Services
file always returns a SHARED instance of the class, so calling the function multiple times should
always return the same instance
첫 번째는 service()요청 된 서비스의 새 인스턴스를 반환하는 것입니다. 유일한 필수 매개 변수는 서비스 이름입니다. 이는 서비스 파일 내의 메소드 이름이 항상 클래스의 SHARED 인스턴스를 리턴하므로 함수를 여러 번 호출하면 항상 동일한 인스턴스를 리턴해야합니다.

::

	$logger = service('logger');

If the creation method requires additional parameters, they can be passed after the service name
생성 메소드에 추가 매개 변수가 필요한 경우 서비스 이름 뒤에 전달할 수 있습니다.

::

	$renderer = service('renderer', APPPATH.'views/');

The second function, ``single_service()`` works just like ``service()`` but returns a new instance of
the class
두 번째 함수는 single_service()작동 service()하지만 클래스의 새 인스턴스를 반환합니다.

::

	$logger = single_service('logger');

Defining Services
=================

To make services work well, you have to be able to rely on each class having a constant API, or
`interface <http://php.net/manual/en/language.oop5.interfaces.php>`_, to use. Almost all of
CodeIgniter's classes provide an interface that they adhere to. When you want to extend or replace
core classes, you only need to ensure you meet the requirements of the interface and you know that
the classes are compatible.
서비스가 잘 작동하도록하려면 상수 API 또는 인터페이스 가있는 각 클래스를 사용하여 의존 할 수 있어야 합니다. CodeIgniter의 거의 모든 클래스는 준수하는 인터페이스를 제공합니다. 핵심 클래스를 확장하거나 교체하려면 인터페이스의 요구 사항을 충족시키고 클래스가 호환 가능하다는 것을 알고 있어야합니다.

For example, the ``RouterCollection`` class implements the ``RouterCollectionInterface``. When you
want to create a replacement that provides a different way to create routes, you just need to
create a new class that implements the ``RouterCollectionInterface``
예를 들어, RouterCollection클래스는를 구현합니다 RouterCollectionInterface. 경로를 만드는 다른 방법을 제공하는 대체품을 만들려면 다음을 구현하는 새 클래스를 만들어야합니다 RouterCollectionInterface.

::

	class MyRouter implements \CodeIgniter\Router\RouteCollectionInterface
	{
		// Implement required methods here.
	}

Finally, modify **/app/Config/Services.php** to create a new instance of ``MyRouter``
instead of ``CodeIgniter\Router\RouterCollection``
마지막으로 /app/Config/Services.php 를 수정 MyRouter 하여 CodeIgniter\Router\RouterCollection다음 대신에 새 인스턴스를 만듭니다 .

::

	public static function routes()
	{
		return new \App\Router\MyRouter();
	}

Allowing Parameters
-------------------

In some instances, you will want the option to pass a setting to the class during instantiation.
Since the services file is a very simple class, it is easy to make this work.
경우에 따라 인스턴스화 중에 클래스에 설정을 전달하는 옵션이 필요합니다. services 파일은 매우 간단한 클래스이므로이 작업을 쉽게 수행 할 수 있습니다.

A good example is the ``renderer`` service. By default, we want this class to be able
to find the views at ``APPPATH.views/``. We want the developer to have the option of
changing that path, though, if their needs require it. So the class accepts the ``$viewPath``
as a constructor parameter. The service method looks like this
좋은 예가 renderer서비스입니다. 기본적으로이 클래스는에서보기를 찾을 수 있기를 원합니다 APPPATH.views/. 개발자는 필요에 따라 개발자가 해당 경로를 변경할 수있는 옵션을 원합니다. 따라서 클래스는 $viewPath 생성자 매개 변수로를 허용합니다 . 서비스 메소드는 다음과 같습니다.

::

	public static function renderer($viewPath=APPPATH.'views/')
	{
		return new \CodeIgniter\View\View($viewPath);
	}

This sets the default path in the constructor method, but allows for easily changing
the path it uses
이것은 생성자 메서드에서 기본 경로를 설정하지만 사용하는 경로를 쉽게 변경할 수 있습니다.

::

	$renderer = \Config\Services::renderer('/shared/views');

Shared Classes
-----------------

There are occasions where you need to require that only a single instance of a service
is created. This is easily handled with the ``getSharedInstance()`` method that is called from within the
factory method. This handles checking if an instance has been created and saved
within the class, and, if not, creates a new one. All of the factory methods provide a
``$getShared = true`` value as the last parameter. You should stick to the method also
서비스 인스턴스를 하나만 만들도록 요구해야하는 경우가 있습니다. 이것은 getSharedInstance()팩토리 메서드 내에서 호출되는 메서드 로 쉽게 처리됩니다 . 이것은 인스턴스가 생성되어 클래스 내에 저장되었는지 검사하고, 그렇지 않은 경우 새 인스턴스를 만듭니다. 모든 팩토리 메소드 는 마지막 매개 변수로서 값을 제공합니다 . 당신은 또한 방법을 고수해야한다 :$getShared = true

::

    class Services
    {
        public static function routes($getShared = false)
        {
            if (! $getShared)
            {
                return new \CodeIgniter\Router\RouteCollection();
            }

            return static::getSharedInstance('routes');
        }
    }

Service Discovery
-----------------

CodeIgniter can automatically discover any Config\Services.php files you may have created within any defined namespaces.
This allows simple use of any module Services files. In order for custom Services files to be discovered, they must
meet these requirements:
CodeIgniter는 정의 된 네임 스페이스 내에서 생성 한 모든 ConfigServices.php 파일을 자동으로 검색 할 수 있습니다. 이렇게하면 모든 모듈 서비스 파일을 간단하게 사용할 수 있습니다. 사용자 지정 서비스 파일을 검색하려면 다음 요구 사항을 충족해야합니다.

- It's namespace must be defined ``Config\Autoload.php``
  네임 스페이스가 정의되어야합니다. Config\Autoload.php
- Inside the namespace, the file must be found at ``Config\Services.php``
  네임 스페이스 내부에서 파일을 찾아야합니다. Config\Services.php
- It must extend ``CodeIgniter\Config\BaseService``
  확장해야합니다. CodeIgniter\Config\BaseService

A small example should clarify this.
작은 예제가이를 분명히해야합니다.

Imagine that you've created a new directory, ``Blog`` in your root directory. This will hold a blog module with controllers,
models, etc, and you'd like to make some of the classes available as a service. The first step is to create a new file:
``Blog\Config\Services.php``. The skeleton of the file should be
Blog루트 디렉토리에 새 디렉토리를 만들었다 고 가정 해보십시오. 이렇게하면 컨트롤러, 모델 등이있는 블로그 모듈이 보관되며 클래스 중 일부를 서비스로 사용 가능하게 만들고 싶습니다. 첫 번째 단계는 새 파일을 만드는 것 Blog\Config\Services.php입니다. 파일의 골격은 다음과 같아야합니다.

::

    <?php namespace Blog\Config;

    use CodeIgniter\Config\BaseService;

    class Services extends BaseService
    {
        public static function postManager()
        {
            ...
        }
    }

Now you can use this file as described above. When you want to grab the posts service from any controller, you
would simply use the framework's ``Config\Services`` class to grab your service
이제 위에서 설명한대로이 파일을 사용할 수 있습니다. 컨트롤러에서 게시물 서비스 Config\Services를 가져 오려면 프레임 워크 클래스를 사용 하여 서비스를 가져옵니다.

::

    $postManager = Config\Services::postManager();

.. note:: If multiple Services file have the same method name, the first one found will be the instance returned.
          여러 서비스 파일의 메소드 이름이 같으면 맨 처음 발견 된 인스턴스가 리턴 된 인스턴스가됩니다.
