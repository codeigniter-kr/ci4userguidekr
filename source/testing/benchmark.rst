############
벤치마킹
############

CodeIgniter provides two separate tools to help you benchmark your code and test different options:
the Timer and the Iterator. The Timer allows you to easily calculate the time between two points in the
execution of your script. The Iterator allows you to setup several variations and run those tests, recording
performance and memory statistics to help you decide which version is the best.
코드이그나이터(CodeIgniter)는 코드를 벤치 마크하고 다양한 옵션을 테스트하는 데 도움이되는 두 개의 개별 도구 인 Timer 및 Iterator를 제공합니다. Timer를 사용하면 스크립트 실행에서 두 지점 사이의 시간을 쉽게 계산할 수 있습니다. 반복기를 사용하면 여러 변형을 설정하고 테스트를 실행하고 성능 및 메모리 통계를 기록하여 어떤 버전이 가장 적합한 버전인지 판단 할 수 있습니다.

The Timer class is always active, being started from the moment the framework is invoked until right before
sending the output to the user, enabling a very accurate timing of the entire system execution.
Timer 클래스는 항상 활성화되어 프레임 워크가 호출 된 순간부터 출력을 사용자에게 보내기 전에 시작되어 전체 시스템 실행의 매우 정확한 타이밍을 가능하게합니다.

.. contents::
    :local:
    :depth: 2

===============
타이머 사용하기
===============

With the Timer, you can measure the time between two moments in the execution of your application. This makes
it simple to measure the performance of different aspects of your application. All measurement is done using
the ``start()`` and ``stop()`` methods.
Timer를 사용하면 응용 프로그램을 실행하는 데 걸리는 시간을 측정 할 수 있습니다. 이를 통해 응용 프로그램의 여러 측면에서 성능을 측정 할 수 있습니다. 모든 측정은 ``start()`` 및 ``stop()`` 메서드를 사용하여 수행됩니다 .

The ``start()`` methods takes a single parameter: the name of this timer. You can use any string as the name
of the timer. It is only used for you to reference later to know which measurement is which
``start()`` 메서드는 단일 매개 변수:timer 이름을 사용합니다. 모든 문자열을 타이머의 이름으로 사용할 수 있습니다. 나중에 어떤 측정이 어떤 것인지를 알기 위해서만 사용됩니다

::

	$benchmark = \Config\Services::timer();
	$benchmark->start('render view');

The ``stop()`` method takes the name of the timer that you want to stop as the only parameter, also
stop()메서드는 중지하려는 타이머의 이름을 유일한 매개 변수로 사용합니다.

::

	$benchmark->stop('render view');

The name is not case-sensitive, but otherwise must match the name you gave it when you started the timer.
이름은 대소 문자를 구분하지 않지만 타이머를 시작할 때 지정한 이름과 일치해야합니다.

Alternatively, you can use the :doc:`global function </general/common_functions>` ``timer()`` to start
and stop timers
또는 :doc:`전역 함수 </general/common_functions>` ``timer()`` 를 사용하여 타이머를 시작하고 중지할 수 있습니다 .

::

	// Start the timer
	timer('render view');
	// Stop a running timer,
	// if one of this name has been started
	timer('render view');

벤치 마크 포인트보기
=============================

When your application runs, all of the timers that you have set are collected by the Timer class. It does
not automatically display them, though. You can retrieve all of your timers by calling the ``getTimers()`` method.
This returns an array of benchmark information, including start, end, and duration
응용 프로그램이 실행되면 설정 한 모든 타이머가 Timer 클래스에 의해 수집됩니다. 그러나 자동으로 표시하지는 않습니다. ``getTimers()`` 메소드 를 호출하여 모든 타이머를 검색 할 수 있습니다 . start, end 및 duration과 같은 벤치 마크 정보의 배열을 반환합니다.

::

	$timers = $benchmark->getTimers();

	// Timers =
	array(
		'render view'  => array(
			'start'    => 1234567890,
			'end'      => 1345678920,
			'duration' => 15.4315      // number of seconds
		)
	)

You can change the precision of the calculated duration by passing in the number of decimal places you want shown as
the only parameter. The default value is 4 numbers behind the decimal point
표시된 매개 변수의 소수 자릿수를 전달하여 계산 된 지속 기간의 정밀도를 변경할 수 있습니다. 기본값은 소수점 뒤에 4 자리 숫자입니다.

::

	$timers = $benchmark->getTimers(6);

The timers are automatically displayed in the :doc:`Debub Toolbar </testing/debugging>`.
타이머는 자동으로 :doc:`Debub Toolbar </testing/debugging>` 에 표시됩니다 .

실행 시간 표시
=========================

While the ``getTimers()`` method will give you the raw data for all of the timers in your project, you can retrieve
the duration of a single timer, in seconds, with the ``getElapsedTime()`` method. The first parameter is the name of
the timer to display. The second is the number of decimal places to display. This defaults to 4
``getTimers()`` 메서드는 프로젝트의 모든 타이머에 대한 원시 데이터를 제공 하지만 ``getElapsedTime()`` 메서드를 사용하여 단일 타이머의 지속 시간을 초 단위로 가져올 수 있습니다 . 첫 번째 매개 변수는 표시 할 타이머의 이름입니다. 두 번째는 표시 할 소수 자릿수입니다. 기본값은 4입니다.

::

	echo timer()->getElapsedTime('render view');
	// Displays: 0.0234

==================
Iterator 사용하기
==================

The Iterator is a simple tool that is designed to allow you to try out multiple variations on a solution to
see the speed differences and different memory usage patterns. You can add any number of "tasks" for it to
run and the class will run the task hundreds or thousands of times to get a clearer picture of performance.
The results can then be retrieved and used by your script, or displayed as an HTML table.
반복기는 속도 차이와 다양한 메모리 사용 패턴을 확인하기 위해 솔루션에서 여러 변형을 시도 할 수 있도록 설계된 간단한 도구입니다. 원하는 수의 "작업"을 추가하여 실행할 수 있으며 클래스는 작업을 수 백 또는 수천 번 실행하여 성능을보다 명확하게 파악할 수 있습니다. 그런 다음 결과를 검색하여 스크립트에서 사용하거나 HTML 테이블로 표시 할 수 있습니다.

실행 할 작업 만들기
=====================

Tasks are defined within Closures. Any output the task creates will be discarded automatically. They are
added to the Iterator class through the ``add()`` method. The first parameter is a name you want to refer to
this test by. The second parameter is the Closure, itself
작업은 Closures 내에 정의됩니다. 작업이 생성 한 출력은 자동으로 삭제됩니다. 그것들은 ``add()`` 메서드를 통해 Iterator 클래스에 추가 됩니다. 첫 번째 매개 변수는이 테스트를 참조하려는 이름입니다. 두 번째 매개 변수는 클로저입니다.

::

	$iterator = new \CodeIgniter\Benchmark\Iterator();

	// Add a new task
	$iterator->add('single_concat', function()
		{
			$str = 'Some basic'.'little'.'string concatenation test.';
		}
	);

	// Add another task
	$iterator->add('double', function($a='little')
		{
			$str = "Some basic {$little} string test.";
		}
	);

작업 실행
=================

Once you've added the tasks to run, you can use the ``run()`` method to loop over the tasks many times.
By default, it will run each task 1000 times. This is probably sufficient for most simple tests. If you need
to run the tests more times than that, you can pass the number as the first parameter
실행할 작업을 추가하고 나면이 ``run()`` 메서드를 사용하여 여러 번 작업을 반복 할 수 있습니다 . 기본적으로 각 작업은 1000 번 실행됩니다. 이것은 아마도 대부분의 간단한 테스트에 충분할 것입니다. 이보다 더 많은 횟수로 테스트를 실행해야하는 경우 첫 번째 매개 변수로 숫자를 전달할 수 있습니다.

::

	// Run the tests 3000 times.
	$iterator->run(3000);

Once it has run, it will return an HTML table with the results of the test. If you don't want the results
displayed, you can pass in ``false`` as the second parameter
일단 실행되면 테스트 결과와 함께 HTML 테이블을 반환합니다. 결과를 표시하지 않으려면 ``false`` 를 두 번째 매개 변수로 전달할 수 있습니다 .

::

	// Don't display the results.
	$iterator->run(1000, false);
