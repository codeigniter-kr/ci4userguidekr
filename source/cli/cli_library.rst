##################
CLI 라이브러리
##################

CodeIgniter의 CLI 라이브러리를 사용하면 다음을 포함하여 대화식 명령 줄 스크립트를 간단하게 만들 수 있습니다.

* 사용자에게 더 많은 정보를 요구
* 터미널에 멀티 컬러 텍스트 쓰기
* 경고음 (좋아요!)
* 긴 작업 중에 진행률 표시 줄 표시
* 긴 텍스트 줄을 창에 맞게 줄 바꿈하십시오.

.. contents::
    :local:
    :depth: 2

클래스 초기화
======================

모든 메소드가 정적이므로 CLI 라이브러리의 인스턴스를 작성할 필요가 없습니다.
대신, 컨트롤러는 클래스 위의 ``use``\ 문을 통해 컨트롤러를 찾을 수 있어야 합니다.

::

	<?php namespace App\Controllers;

	use CodeIgniter\CLI\CLI;

	class MyController extends \CodeIgniter\Controller
	{
		. . .
	}

파일이 처음 로드될 때 클래스가 자동으로 초기화됩니다.

사용자로부터 입력 받기
===========================

때때로 사용자에게 추가 정보를 요청해야합니다. 
선택적 명령 행 인수를 제공하지 않았거나 스크립트에 기존 파일이 있어서 겹쳐 쓰기 전에 확인이 필요한 경우등..
이것은``prompt ()``메소드로 처리됩니다.

질문을 첫 번째 매개 변수로 전달하여 질문을 제공 할 수 있습니다.

::

	$color = CLI::prompt('What is your favorite color?');

두 번째 매개 변수에서 기본값을 전달하여 사용자가 Enter 키를 누르는 경우 사용할 기본 답변을 제공할 수 있습니다

::

	$color = CLI::prompt('What is your favorite color?', 'blue');

허용 된 답변의 배열을 두 번째 매개 변수로 전달하여 허용되는 답변을 제한할 수 있습니다.

::

	$overwrite = CLI::prompt('File exists. Overwrite?', ['y','n']);

마지막으로, 검증 규칙을 세 번째 매개 변수로 답변 입력에 전달할 수 있습니다.

::

	$email = CLI::prompt('What is your email?', null, 'required|valid_email');

피드백 제공
==================

**write()**

사용자에게 피드백을 제공하기 위해 몇 가지 방법이 제공됩니다.
이는 단일 상태 업데이트나 사용자의 터미널 창으로 래핑되는 복잡한 정보 테이블처럼 간단할 수 있습니다.
이것의 핵심은 문자열을 첫 번째 매개 변수로 출력하는 ``write()`` 메소드입니다

::

	CLI::write('The rain in Spain falls mainly on the plains.');

첫 번째 매개 변수로 색상 이름을 전달하여 텍스트 색상을 변경할 수 있습니다

::

	CLI::write('File created.', 'green');

상태별로 메시지를 구분하거나 다른 색상을 사용하여 '헤더'를 만드는 데 사용할 수 있습니다.
색 이름을 세 번째 매개 변수로 전달하여 배경색을 설정할 수도 있습니다

::

	CLI::write('File overwritten.', 'light_red', 'dark_gray');

다음과 같은 전경색을 사용할 수 있습니다:

* black
* dark_gray
* blue
* dark_blue
* light_blue
* green
* light_green
* cyan
* light_cyan
* red
* light_red
* purple
* light_purple
* light_yellow
* yellow
* light_gray
* white

더 작은 숫자를 배경색으로 사용할 수 있습니다:

* black
* blue
* green
* cyan
* red
* yellow
* light_gray
* magenta

**print()**

전후에 개행을 강요하지 않는다는 점을 제외하면 ``write()`` 메서드와 동일합니다.
대신 커서가 현재 어디에 있든지 화면에 인쇄합니다.
이를 통해 다른 호출에서 동일한 라인에 여러 항목을 인쇄할 수 있습니다.
이것은 상태를 보여주고 무언가를 한 다음 같은 줄에 "완료"를 인쇄할 때 특히 유용합니다.

::

    for ($i = 0; $i <= 10; $i++)
    {
        CLI::print($i);
    }

**color()**

``write()`` 명령은 터미널에 한 줄을 쓰고 EOL 문자로 끝나는 반면, 인쇄 후 EOL을 강제하지 않는다는 점을 제외하고 ``color()``메서드를 사용하여 동일한 문자열을 만들 수 있습니다 . 
이를 통해 동일한 행에 여러 출력을 만들 수 있습니다. 
또는 더 일반적으로 ``write()`` 메서드 내부에서 다른 색상의 문자열을 만들 수 있습니다

::

	CLI::write("fileA \t". CLI::color('/path/to/file', 'white'), 'yellow');

이 예제는 창에 ``fileS``\ 가 노란색으로 표시되고 탭이 오고 흰색 텍스트로 ``/path/to/file``\ 이 표시됩니다.

**error()**

If you need to output errors, you should use the appropriately named ``error()`` method. This writes light-red text
to STDERR, instead of STDOUT, like ``write()`` and ``color()`` do. This can be useful if you have scripts watching
for errors so they don't have to sift through all of the information, only the actual error messages. You use it
exactly as you would the ``write()`` method::

	CLI::error('Cannot write to file: '. $file);

**wrap()**

This command will take a string, start printing it on the current line, and wrap it to a set length on new lines.
This might be useful when displaying a list of options with descriptions that you want to wrap in the current
window and not go off screen::

	CLI::color("task1\t", 'yellow');
	CLI::wrap("Some long description goes here that might be longer than the current window.");

By default, the string will wrap at the terminal width. Windows currently doesn't provide a way to determine
the window size, so we default to 80 characters. If you want to restrict the width to something shorter that
you can be pretty sure fits within the window, pass the maximum line-length as the second parameter. This
will break the string at the nearest word barrier so that words are not broken.
::

	// Wrap the text at max 20 characters wide
	CLI::wrap($description, 20);

You may find that you want a column on the left of titles, files, or tasks, while you want a column of text
on the right with their descriptions. By default, this will wrap back to the left edge of the window, which
doesn't allow things to line up in columns. In cases like this, you can pass in a number of spaces to pad
every line after the first line, so that you will have a crisp column edge on the left::

	// Determine the maximum length of all titles
	// to determine the width of the left column
	$maxlen = max(array_map('strlen', $titles));

	for ($i=0; $i <= count($titles); $i++)
	{
		CLI::write(
			// Display the title on the left of the row
			$title[$i].'   '.
			// Wrap the descriptions in a right-hand column
			// with its left side 3 characters wider than
			// the longest item on the left.
			CLI::wrap($descriptions[$i], 40, $maxlen+3)
		);
	}

Would create something like this:

.. code-block:: none

    task1a     Lorem Ipsum is simply dummy
               text of the printing and typesetting
               industry.
    task1abc   Lorem Ipsum has been the industry's
               standard dummy text ever since the

**newLine()**

The ``newLine()`` method displays a blank line to the user. It does not take any parameters::

	CLI::newLine();

**clearScreen()**

You can clear the current terminal window with the ``clearScreen()`` method. In most versions of Windows, this will
simply insert 40 blank lines since Windows doesn't support this feature. Windows 10 bash integration should change
this::

	CLI::clearScreen();

**showProgress()**

If you have a long-running task that you would like to keep the user updated with the progress, you can use the
``showProgress()`` method which displays something like the following:

.. code-block:: none

	[####......] 40% Complete

This block is animated in place for a very nice effect.

To use it, pass in the current step as the first parameter, and the total number of steps as the second parameter.
The percent complete and the length of the display will be determined based on that number. When you are done,
pass ``false`` as the first parameter and the progress bar will be removed.
::

	$totalSteps = count($tasks);
	$currStep   = 1;

	foreach ($tasks as $task)
	{
		CLI::showProgress($currStep++, $totalSteps);
		$task->run();
	}

	// Done, so erase it...
	CLI::showProgress(false);

**table()**

::

	$thead = ['ID', 'Title', 'Updated At', 'Active'];
	$tbody = [
		[7, 'A great item title', '2017-11-15 10:35:02', 1],
		[8, 'Another great item title', '2017-11-16 13:46:54', 0]
	];

	CLI::table($tbody, $thead);

.. code-block:: none

	+----+--------------------------+---------------------+--------+
	| ID | Title                    | Updated At          | Active |
	+----+--------------------------+---------------------+--------+
	| 7  | A great item title       | 2017-11-16 10:35:02 | 1      |
	| 8  | Another great item title | 2017-11-16 13:46:54 | 0      |
	+----+--------------------------+---------------------+--------+

**wait()**

Waits a certain number of seconds, optionally showing a wait message and
waiting for a key press.

::

        // wait for specified interval, with countdown displayed
        CLI::wait($seconds, true);

        // show continuation message and wait for input
        CLI::wait(0, false);

        // wait for specified interval
        CLI::wait($seconds, false);
