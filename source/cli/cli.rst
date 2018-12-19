########################
Command Line을 통한 실행
########################

As well as calling an applications :doc:`Controllers </incoming/controllers>`
via the URL in a browser they can also be loaded via the command-line
interface (CLI).
브라우저의 URL을 통해 애플리케이션 :doc:`컨트롤러 </incoming/controllers>` 를 호출하는 것은 물론 명령 줄 인터페이스 (CLI)를 통해로드 할 수도 있습니다.

.. contents::
    :local:
    :depth: 2

CLI 란 무엇입니까?
===================

The command-line interface is a text-based method of interacting with
computers. For more information, check the `Wikipedia
article <http://en.wikipedia.org/wiki/Command-line_interface>`_.
명령 줄 인터페이스는 텍스트 기반의 컴퓨터 상호 작용 방식입니다. 
자세한 내용은 `Wikipedia article <http://en.wikipedia.org/wiki/Command-line_interface>`_
를 확인 하십시오 .

왜  command-line을 통해 실행합니까?
===================================

There are many reasons for running CodeIgniter from the command-line,
but they are not always obvious.
CodeIgniter를  command-line에서 실행하는 데에는 여러 가지 이유가 있지만 항상 명확하지는 않습니다.

-  wget 이나 curl 을 사용하지 않고 cron-jobs 실행
-  Make your cron-jobs inaccessible from being loaded in the URL by
   checking the return value of :php:func:`is_cli()`.
   :php:func:`is_cli()` 의 반환 값을 확인하여 cron-jobs 액세스 할 수 없도록 URL을 사용하여 로드되지 않게하십시오.
-  Make interactive "tasks" that can do things like set permissions,
   prune cache folders, run backups, etc.
   권한 설정, 캐시 폴더 정리, 백업 실행 등과 같은 작업을 할 수있는 대화 형 "tasks" 을 만드십시오.
-  Integrate with other applications in other languages. For example, a
   random C++ script could call one command and run code in your models!
   다른 언어로 다른 응용 프로그램과 통합하십시오. 예를 들어 임의의 C ++ 스크립트는 하나의 명령을 호출하고 모델에서 코드를 실행할 수 있습니다.

Let's try it: Hello World!
==========================

Let's create a simple controller so you can see it in action. Using your
text editor, create a file called Tools.php, and put the following code
in it
간단한 컨트롤러를 만들어 실제 상황을 볼 수 있습니다. 텍스트 편집기를 사용하여 Tools.php 파일을 만들고 다음 코드를 입력하십시오 

::

	namespace App\Controller;
	
	use CodeIgniter\Controller;

	class Tools extends Controller {

		public function message($to = 'World')
		{
			echo "Hello {$to}!".PHP_EOL;
		}
	}

Then save the file to your **app/Controllers/** directory.
그런 다음 응용 프로그램 **app/Controllers/** 에 파일을 저장하십시오 

Now normally you would visit the your site using a URL similar to this
이제는 일반적으로 다음과 유사한 URL을 사용하여 사이트를 방문하게됩니다.

::

	example.com/index.php/tools/message/to

Instead, we are going to open Terminal in Mac/Linux or go to Run > "cmd"
in Windows and navigate to our CodeIgniter project's web root.
대신, 우리는 Mac / Linux에서 Terminal을 열거나 Windows에서 Run> "cmd"로 가서 CodeIgniter 프로젝트의 웹 루트로 이동합니다.

.. code-block:: bash

	$ cd /path/to/project/public
	$ php index.php tools message

If you did it right, you should see *Hello World!* printed.
너가 그것을 올바르게하면, 너는 *Hello World!* 을보아야한다.

.. code-block:: bash

	$ php index.php tools message "John Smith"

Here we are passing it a argument in the same way that URL parameters
work. "John Smith" is passed as a argument and output is
여기서는 URL 매개 변수가 작동하는 것과 같은 방식으로 인수를 전달합니다. "John Smith"가 인수로 전달되고 출력은 다음과 같습니다.

::

	Hello John Smith!

That's the basics!
==================

That, in a nutshell, is all there is to know about controllers on the
command line. Remember that this is just a normal controller, so routing
and ``_remap()`` works fine.
요컨대, 커맨드 라인에서 컨트롤러에 대해 알아야 할 것이 있습니다. 이 컨트롤러는 정상적인 컨트롤러이므로 라우팅 및 정상적으로 ``_remap()`` 작동합니다.

However, CodeIgniter provides additional tools to make creating CLI-accessible
scripts even more pleasant, include CLI-only routing, and a library that helps
you with CLI-only tools.
그러나 CodeIgniter는 CLI 액세스 가능 스크립트 작성을 더욱 즐겁게하고 CLI 전용 라우팅 및 CLI 전용 도구를 사용하는 데 도움이되는 라이브러리를 포함하는 추가 도구를 제공합니다.

CLI 전용 라우팅
----------------

In your **Routes.php** file you can create routes that are only accessible from
the CLI as easily as you would create any other route. Instead of using the ``get()``,
``post()``, or similar method, you would use the ``cli()`` method. Everything else
works exactly like a normal route definition
당신에 **Routes.php** 당신은 쉽게 당신이 다른 경로를 생성하는 것처럼 CLI에서만 액세스 할 수있는 경로를 만들 수 있습니다 파일. 대신에 사용하는 ``get()``, ``post()`` 또는 유사한 방법을, 당신은 사용하는 것이 ``cli()`` 방법. 다른 모든 것은 정상 경로 정의와 똑같이 작동합니다.

::

    $routes->cli('tools/message/(:segment)', 'Tools::message/$1');

자세한 내용은 :doc:`Routes </incoming/routing>` 페이지를 참조하십시오.

CLI 라이브러리
---------------

The CLI library makes working with the CLI interface simple.
It provides easy ways to output text in multiple colors to the terminal window. It also
allows you to prompt a user for information, making it easy to build flexible, smart tools.
CLI 라이브러리는 CLI 인터페이스로 작업하는 것을 단순하게 만듭니다. 터미널 창에 여러 색상의 텍스트를 출력하는 쉬운 방법을 제공합니다. 또한 사용자에게 정보를 요구할 수 있으므로 유연하고 스마트 한 도구를 쉽게 만들 수 있습니다.

자세한 내용은 :doc:`CLI Library </cli/cli_library>` 페이지를 참조하십시오.
