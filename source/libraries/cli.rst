###########
CLI 라이브러리
###########

CodeIgniter's CLI library makes creating interactive command-line scripts simple, including:
CodeIgniter의 CLI 라이브러리는 다음을 포함하여 대화형 명령행 스크립트를 간단하게 만들수 있습니다.

* Prompting the user for more information 사용자에게 자세한 정보를 묻습니다.
* Writing multi-colored text the terminal 멀티 컬러 텍스트를 터미널에 씁니다.
* 신호음 (be nice!)
* 긴 작업의 진행률 표시
* Wrapping long text lines to fit the window. 윈도우에 맞게 긴 텍스트 줄을 감싸는 중입니다.

.. contents:: Page Contents

클래스 초기화하기
======================

You do not need to create an instance of the CLI library, since all of it's methods are static. Instead, you simply
need to ensure your controller can locate it via a ``use`` statement above your class
CLI 라이브러리의 인스턴스는 정적이기 때문에 CLI 라이브러리의 인스턴스를 만들 필요가 없습니다. 대신 컨트롤러가 ``use`` 클래스 위에 있는 문장을 통해 컨트롤러를 찾을 수 있도록해야합니다 .

::

	<?php
	use \CodeIgniter\CLI\CLI;

	class MyController extends \CodeIgniter\Controller
	{
		. . .
	}

The class is automatically initialized when the file is loaded the first time.
이 클래스는 파일이 처음로드 될 때 자동으로 초기화됩니다.

사용자로부터 입력 받기
===========================

Sometimes you need to ask the user for more information. They might not have provided optional command-line
arguments, or the script may have encountered an existing file and needs confirmation before overwriting. This is
handled with the ``prompt()`` method.
때로는 사용자에게 더 많은 정보를 요구해야합니다. 선택적 명령 줄 인수를 제공하지 않았거나 스크립트가 기존 파일을 발견하여 덮어 쓰기 전에 확인해야 할 수도 있습니다. 이 ``prompt()`` 메소드로 처리됩니다 .

You can provide a question by passing it in as the first parameter
질문을 첫 번째 매개 변수로 전달하여 질문을 제공 할 수 있습니다.

::

	$color = CLI::prompt('What is your favorite color?');

You can provide a default answer that will be used if the user just hits enter by passing the default in the
second parameter
사용자가 두 번째 매개 변수에 기본값을 전달하여 입력을 누르는 경우에 사용되는 기본 응답을 제공 할 수 있습니다.

::

	$color = CLI::prompt('What is your favorite color?', 'blue');

You can restrict the acceptable answers by passing in an array of allowed answers as the second parameter
허용 된 응답의 배열을 두 번째 매개 변수로 전달하여 허용되는 대답을 제한 할 수 있습니다.

::

	$overwrite = CLI::prompt('File exists. Overwrite?', ['y','n']);

Finally, you can pass validation rules to the answer input as the third parameter
마지막으로 세 번째 매개 변수로 응답 입력에 유효성 검사 규칙을 전달할 수 있습니다.

::

	$email = CLI::prompt('What is your email?', null, 'required|valid_email');

피드백 제공
==================

**write()**

Several methods are provided for you to provide feedback to your users. This can be as simple as a single status update
or a complex table of information that wraps to the user's terminal window. At the core of this is the ``write()``
method which takes the string to output as the first parameter
사용자에게 피드백을 제공하는 몇 가지 방법이 제공됩니다. 단일 상태 업데이트 나 사용자 터미널 창으로 묶인 복잡한 정보 테이블처럼 간단 할 수 있습니다. 이 핵심은 문자열을 첫 번째 매개 변수로 출력 하는 ``write()`` 메서드입니다.

::

	CLI::write('The rain in Spain falls mainly on the plains.');

You can change the color of the text by passing in a color name as the first parameter
색상 이름을 두 번째 매개 변수로 전달하여 텍스트 색상을 변경할 수 있습니다.

::

	CLI::write('File created.', 'green');

This could be used to differentiate messages by status, or create 'headers' by using a different color. You can
even set background colors by passing the color name in as the third parameter
이것은 메시지를 상태에 따라 차별화하거나 다른 색상을 사용하여 '헤더'를 만드는 데 사용할 수 있습니다. 색상 이름을 세 번째 매개 변수로 전달하여 배경색을 설정할 수도 있습니다.

::

	CLI::write('File overwritten.', 'light_red', 'dark_gray');

다음과 같은 색상을 사용할 수 있습니다.

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

**color()**

While the ``write()`` command will write a single line to the terminal, ending it with a EOL character, you can
use the ``color()`` method to make a string fragment that can be used in the same way, except that it will not force
an EOL after printing. This allows you to create multiple outputs on the same row. Or, more commonly, you can use
it inside of a ``write()`` method to create a string of a different color inside
``write()`` 명령이 EOL 문자로 끝나는 터미널에 한 줄을 쓰는 동안이 ``color()`` 방법을 사용하여 인쇄 후 EOL을 강제 실행하지 않는다는 점을 제외하면 같은 방법으로 사용할 수있는 문자열 단편을 만들 수 있습니다. 이를 통해 동일한 행에 여러 개의 출력을 만들 수 있습니다. 또는 더 일반적으로 ``write()`` 메서드 내부에서 다른 색상의 문자열을 만들 수 있습니다.

::

	CLI::write("fileA \t". CLI::color('/path/to/file', 'white'), 'yellow');

This example would write a single line to the window, with ``fileA`` in yellow, followed by a tab, and then
``/path/to/file`` in white text.
이 예에서는 창 fileA에 노란색 으로 한 행을 쓰고 그 다음에 탭을 넣은 다음 ``/path/to/file`` 흰색 텍스트로 작성합니다.

**error()**

If you need to output errors, you should use the appropriately named ``error()`` method. This writes light-red text
to STDERR, instead of STDOUT, like ``write()`` and ``color()`` do. This can be useful if you have scripts watching
for errors so they don't have to sift through all of the information, only the actual error messages. You use it
exactly as you would the ``write()`` method
오류를 출력해야하는 경우 적절하게 명명 된 ``error()`` 메서드를 사용해야합니다 . 이 같은 대신 STDOUT의, STDERR에 밝은 빨간색 텍스트를 기록 ``write()`` 하고 ``color()`` 않습니다. 이 스크립트는 오류를 감시하는 스크립트를 갖고있어 모든 정보를 탐색 할 필요가 없으며 실제 오류 메시지 만 표시 할 때 유용 할 수 있습니다. ``write()`` 메서드 와 똑같이 사용합니다 .

::

	CLI::error('Cannot write to file: '. $file);

**wrap()**

This command will take a string, start printing it on the current line, and wrap it to a set length on new lines.
This might be useful when displaying a list of options with descriptions that you want to wrap in the current
window and not go off screen
이 명령은 문자열을 취해 현재 행에서 인쇄를 시작하고 새 행의 지정된 길이로 줄 바꿈합니다. 이 옵션은 현재 창에서 줄 바꿈을하고 화면에서 벗어나지 않을 설명과 함께 옵션 목록을 표시 할 때 유용 할 수 있습니다.

::

	CLI::color("task1\t", 'yellow');
	CLI::wrap("Some long description goes here that might be longer than the current window.");

By default the string will wrap at the terminal width. Windows currently doesn't provide a way to determine
the window size, so we default to 80 characters. If you want to restrict the width to something shorter that
you can be pretty sure fits within the window, pass the maximum line-length as the second parameter. This
will break the string at the nearest word barrier so that words are not broken.
기본적으로 문자열은 터미널 폭에서 줄 바꿈됩니다. Windows는 현재 창 크기를 결정하는 방법을 제공하지 않으므로 기본값은 80 자입니다. 너비를 윈도우 내에서 잘 맞을 수 있도록 더 짧게 제한하려면 두 번째 매개 변수로 최대 줄 길이를 전달하십시오. 이렇게하면 단어가 깨지지 않도록 가장 가까운 단어 장벽의 문자열이 손상됩니다.

::

	// Wrap the text at max 20 characters wide
	CLI::wrap($description, 20);

You may find that you want a column on the left of titles, files, or tasks, while you want a column of text
on the right with their descriptions. By default, this will wrap back to the left edge of the window, which
doesn't allow things to line up in columns. In cases like this, you can pass in a number of spaces to pad
every line after the first line, so that you will have a crisp column edge on the left
제목, 파일 또는 작업의 왼쪽에 열이 있고 그 오른쪽에 텍스트 열이있는 설명을 원할 수 있습니다. 기본적으로이 작업은 윈도우의 왼쪽 가장자리로 되돌아 가서 항목이 열에 정렬되지 않게합니다. 이와 같은 경우 첫 번째 줄 다음에 모든 줄을 채우기 위해 여러 공백을 사용할 수 있으므로 왼쪽에 선명한 가장자리가 생깁니다.

::

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
다음과 같이 만들 수 있습니다.

.. code-block:: none

    task1a     Lorem Ipsum is simply dummy
               text of the printing and typesetting
               industry.
    task1abc   Lorem Ipsum has been the industry's
               standard dummy text ever since the

**newLine()**

The ``newLine()`` method displays a blank line to the user. It does not take any parameters
newLine()메서드는 사용자에게 빈 줄을 표시합니다. 매개 변수를 사용하지 않습니다.

::

	CLI::newLine();

**clearScreen()**

You can clear the current terminal window with the ``clearScreen()`` method. In most versions of Windows, this will
simply insert 40 blank lines since Windows doesn't support this feature. Windows 10 bash integration should change
this
``clearScreen()`` 메소드를 사용하여 현재 터미널 창을 지울 수 있습니다 . 대부분의 Windows 버전에서는 Windows가이 기능을 지원하지 않기 때문에 40 개의 빈 줄을 삽입하기 만합니다. Windows 10 bash 통합은 다음과 같이 변경해야합니다.

::

	CLI::clearScreen();

**showProgress()**

If you have a long-running task that you would like to keep the user updated with the progress, you can use the
``showProgress()`` method which displays something like the following:
사용자가 진행 상황을 업데이트하기를 원하는 장기 실행 작업이 있는 경우 다음과 같은 ``showProgress()`` 메서드를 사용할 수 있습니다 .

.. code-block:: none

	[####......] 40% Complete

This block is animated in place for a very nice effect.
이 블록은 아주 좋은 효과를 내기 위해 에니메이션을 제공합니다.

To use it, pass in the current step as the first parameter, and the total number of steps as the second parameter.
The percent complete and the length of the display will be determined based on that number. When you are done,
pass ``false`` as the first parameter and the progress bar will be removed.
이를 사용하려면 현재 단계를 첫 번째 매개 변수로 전달하고 총 계단 수를 두 번째 매개 변수로 전달하십시오. 디스플레이의 완료율과 길이는 해당 숫자를 기반으로 결정됩니다. 완료되면 ``false`` 첫 번째 매개 변수로 전달 하면 진행률 표시 줄이 제거됩니다.

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
선택적으로 대기 메시지를 표시하고 키를 누를 때까지 기다리는 특정 시간 (초)을 기다립니다.

::

        // wait for specified interval, with countdown displayed
        CLI::wait($seconds, true);

        // show continuation message and wait for input
        CLI::wait(0, false);

        // wait for specified interval
        CLI::wait($seconds, false);
