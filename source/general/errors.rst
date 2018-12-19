##############
Error Handling
##############

CodeIgniter builds error reporting into your system through Exceptions, both the `SPL collection <http://php.net/manual/en/spl.exceptions.php>`_, as
well as a few custom exceptions that are provided by the framework. Depending on your environment's setup, the
default action when an error or exception is thrown is to display a detailed error report, unless the application
is running under the ``production`` environment. In this case, a more generic  message is displayed to
keep the best user experience for your users.
CodeIgniter는, 예외를 통해 시스템에보고 모두 오류를 구축 SPL 수집 뿐만 아니라 프레임 워크에서 제공되는 몇 가지 사용자 정의 예외. 환경 설정에 따라 오류 또는 예외가 발생할 때의 기본 동작은 응용 프로그램이 production환경에서 실행되고 있지 않으면 자세한 오류 보고서를 표시하는 것입니다. 이 경우보다 일반적인 메시지가 표시되어 사용자에게 최상의 사용자 환경을 제공합니다.

.. contents::
    :local:
    :depth: 2

Using Exceptions
================

This section is a quick overview for newer programmers, or developers who are not experienced with using exceptions.
이 섹션은 최신 프로그래머 또는 예외 사용 경험이없는 개발자를위한 빠른 개요입니다.

Exceptions are simply events that happen when the exception is "thrown". This halts the current flow of the script, and
execution is then sent to the error handler which displays the appropriate error page
예외는 단순히 예외가 "발생"될 때 발생하는 이벤트입니다. 그러면 스크립트의 현재 흐름이 중단되고 해당 오류 페이지를 표시하는 오류 처리기로 실행이 전송됩니다.

::

	throw new \Exception("Some message goes here");

If you are calling a method that might throw an exception, you can catch that exception using a ``try/catch`` block
예외를 throw 할 수있는 메서드를 호출하는 경우 ``try/catch`` 블록을 사용하여 해당 예외를 catch 할 수 있습니다.

::

	try {
		$user = $userModel->find($id);
	}
	catch (\Exception $e)
	{
		die($e->getMessage());
	}

If the ``$userModel`` throws an exception, it is caught and the code within the catch block is executed. In this example,
the scripts dies, echoing the error message that the ``UserModel`` defined.
(가) 경우 ``$userModel`` 예외를 throw, 그것은 적발되고 catch 블록 내에서 코드가 실행된다. 이 예에서 스크립트는 죽어서 ``UserModel`` 정의 된 오류 메시지를 echo 합니다 .

In this example, we catch any type of Exception. If we only want to watch for specific types of exceptions, like
a UnknownFileException, we can specify that in the catch parameter. Any other exceptions that are thrown and are
not child classes of the caught exception will be passed on to the error handler
이 예에서는 모든 유형의 Exception을 catch합니다. UnknownFileException과 같은 특정 유형의 예외 만 감시하려는 경우 catch 매개 변수에서이를 지정할 수 있습니다. 예외가 발생하고 catch 된 예외의 하위 클래스가 아닌 다른 예외는 오류 처리기로 전달됩니다.

::

	catch (\CodeIgniter\UnknownFileException $e)
	{
		// do something here...
	}

This can be handy for handling the error yourself, or for performing cleanup before the script ends. If you want
the error handler to function as normal, you can throw a new exception within the catch block
이는 직접 오류를 처리하거나 스크립트가 종료되기 전에 정리를 수행하는 경우에 유용 할 수 있습니다. 오류 처리기를 정상적으로 작동하게하려면 catch 블록 내에 새 예외를 throw 할 수 있습니다.

::

	catch (\CodeIgniter\UnknownFileException $e)
	{
		// do something here...

		throw new \RuntimeException($e->getMessage(), $e->getCode(), $e);
	}

Configuration
=============

By default, CodeIgniter will display all errors in the ``development`` and ``testing`` environments, and will not
display any errors in the ``production`` environment. You can change this by locating the environment configuration
portion at the top of the main ``index.php`` file.
기본적으로 CodeIgniter는 development및 testing환경의 모든 오류를 표시 하며 환경에 오류를 표시하지 않습니다 production. 기본 index.php파일 의 맨 위에 환경 구성 부분을 배치하여이를 변경할 수 있습니다.

.. important:: Disabling error reporting DOES NOT stop logs from being written if there are errors.
			   오류보고 사용 안 함 오류가있는 경우 로그 작성이 중지되지 않습니다.

Logging Exceptions
------------------

By default, all Exceptions other than 404 - Page Not Found exceptions are logged. This can be turned on and off
by setting the **$log** value of ``Config\Exceptions``
기본적으로 404 - Page Not Found 예외를 제외한 모든 예외가 기록됩니다. 이것은 다음의 $ log 값을 설정하여 켜고 끌 수 있습니다 ``Config\Exceptions``

::

    class Exceptions
    {
        public $log = true;
    }

To ignore logging on other status codes, you can set the status code to ignore in the same file
다른 상태 코드의 로깅을 무시하려면 같은 파일에서 상태 코드를 ignore로 설정할 수 있습니다.

::

    class Exceptions
    {
        public $ignoredCodes = [ 404 ];
    }

.. note:: It is possible that logging still will not happen for exceptions if your current Log settings
    are not setup to log **critical** errors, which all exceptions are logged as.
    현재 로그 설정이 중요한 오류 를 기록하도록 설정되어 있지 않은 경우 모든 예외가로 기록되므로 예외에 대한 기록이 여전히 발생하지 않을 수도 있습니다.

Custom Exceptions
=================

The following custom exceptions are available:
다음과 같은 사용자 지정 예외를 사용할 수 있습니다.

PageNotFoundException
---------------------

This is used to signal a 404, Page Not Found error. When thrown, the system will show the view found at
``/app/views/errors/html/error_404.php``. You should customize all of the error views for your site.
If, in ``Config/Routes.php``, you have specified a 404 Override, that will be called instead of the standard
404 page
404, Page Not Found 오류를 알리는 데 사용됩니다. 던져 질 때, 시스템은에서 발견 된 견해를 보여줄 것 /app/views/errors/html/error_404.php입니다. 사이트의 모든 오류보기를 사용자 지정해야합니다. 경우에 Config/Routes.php, 당신은 표준 404 페이지 대신 호출됩니다 404 재정의, 지정한

::

	if (! $page = $pageModel->find($id))
	{
		throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound();
	}

You can pass a message into the exception that will be displayed in place of the default message on the 404 page.
404 페이지의 기본 메시지 대신 표시되는 예외에 메시지를 전달할 수 있습니다.

ConfigException
---------------

This exception should be used when the values from the configuration class are invalid, or when the config class
is not the right type, etc
이 예외는 구성 클래스의 값이 유효하지 않거나 구성 클래스가 올바른 유형이 아닌 경우 등에 사용해야합니다.

::

	throw new \CodeIgniter\Exceptions\ConfigException();

This provides an HTTP status code of 500, and an exit code of 3.
HTTP 상태 코드 500, 종료 코드 3을 제공합니다.

DatabaseException
-----------------

This exception is thrown for database errors, such as when the database connection cannot be created,
or when it is temporarily lost
이 예외는 데이터베이스 연결을 만들 수 없거나 일시적으로 손실 된 경우와 같이 데이터베이스 오류가 발생할 때 throw됩니다.

::

	throw new \CodeIgniter\Database\Exceptions\DatabaseException();

This provides an HTTP status code of 500, and an exit code of 8.
HTTP 상태 코드 500 및 종료 코드 8을 제공합니다.