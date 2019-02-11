Events
#####################################

CodeIgniter의 이벤트 기능은 코어 파일을 해킹하지 않고 프레임 워크의 내부 동작을 활용할 수있는 방법을 제공합니다. 
CodeIgniter가 실행되면 특정 실행 프로세스가 수행됩니다. 그러나 실행 프로세스의 특정 단계에서 어떤 작업을 수행하려는 경우가
있을 수 있습니다. 예를 들어 컨트롤러가 로드되기 직전에 스크립트를 실행하거나 직후에 스크립트를 실행하거나 다른 위치에서 자체 
스크립트 중 하나를 트리거 할 수 있습니다.

Events work on a *publish/subscribe* pattern, where an event, is triggered at some point during the script execution.
Other scripts can "subscribe" to that event by registering with the Events class to let it know they want to perform an
action when that event is triggered.
이벤트는 스크립트 실행 중 어느 시점에서 이벤트가 트리거 되는 *publish/subscribe* 패턴에서 작동합니다. 
다른 스크립트는 이벤트 클래스에 등록하여 이벤트가 트리거 될 때 수행된다것을 알 수 있도록 해당 이벤트를 "등록"할 수 있습니다.

Enabling Events
===============

이벤트는 항상 사용 가능하며 전역적으로 사용 가능합니다.

Defining an Event
=================

대부분의 이벤트는 **app/Config/Events.php** 파일 내에서 정의 됩니다. 이벤트 클래스의 ``on()`` 메소드를 사용하여 이벤트를 등록 할 수 있습니다. 첫 번째 매개 변수는 구독 할 이벤트의 이름입니다. 두 번째 매개 변수는 해당 이벤트가 트리거 될 때 실행될 호출 가능한 함수입니다.

::

	use CodeIgniter\Events\Events;

	Events::on('pre_system', ['MyClass', 'MyFunction']);

이 예에서는 **pre_controller** 이벤트가 실행될 때마다의 인스턴스 ``MyClass``\ 가 만들어지고 ``MyFunction`` 메서드가 실행됩니다. 
두 번째 매개 변수는 PHP가 인식 할 수 있는 `호출 가능 <http://php.net/manual/en/function.is-callable.php>`_ 형식입니다 .

::

	// Call a standalone function
	Events::on('pre_system', 'some_function');

	// Call on an instance method
	$user = new User();
	Events::on('pre_system', [$user, 'some_method']);

	// Call on a static method
	Events::on('pre_system', 'SomeClass::someMethod');

	// Use a Closure
	Events::on('pre_system', function(...$params)
	{
		. . .
	});

Setting Priorities
------------------

Since multiple methods can be subscribed to a single event, you will need a way to define in what order those methods
are called. You can do this by passing a priority value as the third parameter of the ``on()`` method. Lower values
are executed first, with a value of 1 having the highest priority, and there being no limit on the lower values
하나의 이벤트에 여러 메소드를 등록 할 수 있으므로 이러한 메소드가 호출되는 순서를 정의하는 방법이 필요합니다. on()메서드 의 세 번째 매개 변수로 우선 순위 값을 전달하여이 작업을 수행 할 수 있습니다 . 가장 낮은 우선 순위 값 1을 갖는 하위 값이 먼저 실행되며 낮은 값에는 제한이 없습니다.

::

    Events::on('post_controller_constructor', 'some_function', 25);

Any subscribers with the same priority will be executed in the order they were defined.
동일한 우선 순위를 가진 모든 가입자는 정의 된 순서대로 실행됩니다.

Three constants are defined for your use, that set some helpful ranges on the values. You are not required to use these
but you might find they aid readability
세 가지 상수가 정의되어 값에 유용한 범위를 설정합니다. 이들을 사용할 필요는 없지만 가독성을 높이는 데 도움이 될 수 있습니다.

::

	define('EVENT_PRIORITY_LOW', 200);
	define('EVENT_PRIORITY_NORMAL', 100);
	define('EVENT_PRIORITY_HIGH', 10);

Once sorted, all subscribers are executed in order. If any subscriber returns a boolean false value, then execution of
the subscribers will stop.
일단 정렬되면 모든 가입자가 순서대로 실행됩니다. 구독자가 부울 false 값을 반환하면 구독자의 실행이 중지됩니다.

Publishing your own Events
==========================

The Events library makes it simple for you to create events in your own code, also. To use this feature, you would simply
need to call the ``trigger()`` method on the **Events** class with the name of the event
이벤트 라이브러리를 사용하면 자신의 코드로 이벤트를 간단하게 작성할 수 있습니다. 이 기능을 사용하려면 이벤트 클래스 의 trigger()메서드를 이벤트 이름과 함께 호출하면 됩니다 .

::

	\CodeIgniter\Events\Events::trigger('some_event');

You can pass any number of arguments to the subscribers by adding them as additional parameters. Subscribers will be
given the arguments in the same order as defined
추가 매개 변수로 인수를 추가하여 구독자에게 여러 개의 인수를 전달할 수 있습니다. 구독자에게는 정의 된 순서대로 인수가 제공됩니다.

::

	\CodeIgniter\Events\Events::trigger('some_events', $foo, $bar, $baz);

	Events::on('some_event', function($foo, $bar, $baz) {
		...
	});

Simulating Events
=================

During testing, you might not want the events to actually fire, as sending out hundreds of emails a day is both slow
and counter-productive. You can tell the Events class to only simulate running the events with the ``simulate()`` method.
When **true**, all events will be skipped over during the trigger method. Everything else will work as normal, though.
테스트하는 동안 하루에 수 백 통의 이메일을 보내는 것은 느리고 역효과를 낳기 때문에 실제로 이벤트가 발생하는 것을 원하지 않을 수 있습니다. simulate()메소드를 사용 하여 이벤트를 실행하는 것만 시뮬레이션하도록 이벤트 클래스에 지시 할 수 있습니다 . 때 사실 , 모든 이벤트가 트리거 방법 중 스킵됩니다. 하지만 다른 모든 것은 정상적으로 작동합니다.

::

    Events::simulate(true);

You can stop simulation by passing false
false를 전달하여 시뮬레이션을 중지 할 수 있습니다.

::

    Events::simulate(false);

Event Points
============

The following is a list of available event points within the CodeIgniter core code:
다음은 CodeIgniter 핵심 코드에서 사용 가능한 이벤트 포인트 목록입니다.

* **pre_system** Called very early during system execution. Only the benchmark and events class have been loaded at this point. No routing or other processes have happened.
				 시스템 실행 중에 매우 일찍 호출됩니다. 이 시점에서 벤치 마크 및 이벤트 클래스 만로드되었습니다. 라우팅이나 다른 프로세스가 발생하지 않았습니다.
* **post_controller_constructor** Called immediately after your controller is instantiated, but prior to any method calls happening.
								  컨트롤러가 인스턴스화 된 직후에 메서드 호출이 일어나기 전에 호출됩니다.
* **post_system** Called after the final rendered page is sent to the browser, at the end of system execution after the finalized data is sent to the browser.
				  최종 렌더링 된 페이지가 브라우저로 전송 된 후 호출되며 최종화 된 데이터가 브라우저로 전송 된 후 시스템 실행이 끝날 때 호출됩니다.
