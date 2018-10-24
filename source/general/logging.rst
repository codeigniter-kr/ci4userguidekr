###################
Logging Information
###################

.. contents::
    :local:
    :depth: 2

You can log information to the local log files by using the ``log_message()`` method. You must supply
the "level" of the error in the first parameter, indicating what type of message it is (debug, error, etc).
The second parameter is the message itself
이 log_message()방법 을 사용하여 로컬 로그 파일에 정보를 기록 할 수 있습니다 . 첫 번째 매개 변수에 오류의 "수준"을 제공해야합니다 (즉, 디버그, 오류 등). 두 번째 매개 변수는 메시지 자체입니다.

::

	if ($some_var == '')
	{
		log_message('error', 'Some variable did not contain a value.');
	}

There are eight different log levels, matching to the `RFC 5424 <http://tools.ietf.org/html/rfc5424>`_ levels, and they are as follows:
RFC 5424 레벨과 일치하는 8 개의 서로 다른 로그 레벨 이 있으며, 다음과 같습니다.

* **debug** - Detailed debug information.
* **info** - Interesting events in your application, like a user logging in, logging SQL queries, etc.
* **notice** - Normal, but significant events in your application.
* **warning** - Exceptional occurrences that are not errors, like the user of deprecated APIs, poor use of an API, or other undesirable things that are not necessarily wrong.
* **error** - Runtime errors that do not require immediate action but should typically be logged and monitored.
* **critical** - Critical conditions, like an application component not available, or an unexpected exception.
* **alert** - Action must be taken immediately, like when an entire website is down, the database unavailable, etc.
* **emergency** - The system is unusable.

The logging system does not provide ways to alert sysadmins or webmasters about these events, they solely log
the information. For many of the more critical event levels, the logging happens automatically by the
Error Handler, described above.
로깅 시스템은 시스템 관리자 나 웹 마스터에게 이러한 이벤트에 대해 경고하는 방법을 제공하지 않으며 정보를 기록합니다. 보다 중요한 이벤트 레벨의 많은 부분에서, 로깅은 위에서 설명한 오류 처리기에 의해 자동으로 발생합니다.

Configuration
=============

You can modify which levels are actually logged, as well as assign different Loggers to handle different levels, within
the ``/application/Config/Logger.php`` configuration file.
/application/Config/Logger.php구성 파일 내에서 실제로 로깅되는 레벨을 수정하고 여러 로거를 지정하여 여러 레벨을 처리 할 수 있습니다.

The ``threshold`` value of the config file determines which levels are logged across your application. If any levels
are requested to be logged by the application, but the threshold doesn't allow them to log currently, they will be
ignored. The simplest method to use is to set this value to the minimum level that you want to have logged. For example,
if you want to log debug messages, and not information messages, you would set the threshold to ``5``. Any log requests with
a level of 5 or less (which includes runtime errors, system errors, etc) would be logged and info, notices, and warnings
would be ignored
thresholdconfig 파일 의 값은 응용 프로그램에 기록되는 레벨을 결정합니다. 응용 프로그램에서 모든 레벨을 로깅하도록 요청했지만 임계 값으로 인해 현재 로그 할 수 없으면 무시됩니다. 가장 간단한 방법은이 값을 기록하려는 최소 수준으로 설정하는 것입니다. 예를 들어 정보 메시지가 아닌 디버그 메시지를 기록하려면 임계 값을로 설정하십시오 5. 레벨 5 이하 (런타임 오류, 시스템 오류 등을 포함)의 로그 요청은 기록되며 정보,주의 사항 및 경고는 무시됩니다.

::

	public $threshold = 5;

A complete list of levels and their corresponding threshold value is in the configuration file for your reference.
레벨 및 해당 임계 값의 전체 목록은 참조 용 구성 파일에 있습니다.

You can pick and choose the specific levels that you would like logged by assigning an array of log level numbers
to the threshold value
로그 레벨 번호의 배열을 임계 값에 할당하여 기록하려는 특정 레벨을 선택하고 선택할 수 있습니다.

::

	// Log only debug and info type messages
	public $threshold = [5, 8];

Using Multiple Log Handlers
---------------------------

The logging system can support multiple methods of handling logging running at the same time. Each handler can
be set to handle specific levels and ignore the rest. Currently, two handlers come with a default install:
로깅 시스템은 동시에 실행되는 로깅을 처리하는 여러 가지 방법을 지원할 수 있습니다. 각 핸들러는 특정 레벨을 처리하고 나머지는 무시하도록 설정할 수 있습니다. 현재 두 개의 핸들러에는 기본 설치가 있습니다.

- **File Handler** is the default handler and will create a single file for every day locally. This is the
  recommended method of logging.
  기본 처리기이며 매일 로컬로 단일 파일을 만듭니다. 이것은 권장되는 기록 방법입니다.
- **ChromeLogger Handler** If you have the `ChromeLogger extension <https://craig.is/writing/chrome-logger>`_
  installed in the Chrome web browser, you can use this handler to display the log information in
  Chrome's console window.
  당신이있는 경우 ChromeLogger 확장 크롬 웹 브라우저에 설치, 당신은 크롬의 콘솔 창에 로그 정보를 표시하려면이 핸들러를 사용할 수 있습니다.

The handlers are configured in the main configuration file, in the ``$handlers`` property, which is simply
an array of handlers and their configuration. Each handler is specified with the key being the fully
name-spaced class name. The value will be an array of varying properties, specific to each handler.
Each handler's section will have one property in common: ``handles``, which is an array of log level
*names* that the handler will log information for.
핸들러는 기본 구성 파일의 $handlers등록 정보에서 구성되며, 단순히 핸들러 배열과 해당 구성입니다. 각 핸들러는 키가 완전한 네임 스페이스의 클래스 이름으로 지정됩니다. 이 값은 각 핸들러마다 고유 한 다양한 속성의 배열입니다. 각 처리기의 섹션에는 공통적으로 하나의 등록 정보가 있습니다. 이는 처리기가 정보를 기록하는 handles로그 수준 이름 의 배열입니다 .

::

	public $handlers = [

		//--------------------------------------------------------------------
		// File Handler
		//--------------------------------------------------------------------

		'CodeIgniter\Log\Handlers\FileHandler' => [

			'handles' => ['critical', 'alert', 'emergency', 'debug', 'error', 'info', 'notice', 'warning'],
		]
	];

Modifying the Message With Context
==================================

You will often want to modify the details of your message based on the context of the event being logged.
You might need to log a user id, an IP address, the current POST variables, etc. You can do this by use
placeholders in your message. Each placeholder must be wrapped in curly braces. In the third parameter,
you must provide an array of placeholder names (without the braces) and their values. These will be inserted
into the message string
로그되는 이벤트의 컨텍스트를 기반으로 메시지의 세부 사항을 수정하려고합니다. 사용자 ID, IP 주소, 현재 POST 변수 등을 기록해야 할 수도 있습니다. 메시지의 자리 표시자를 사용하여이 작업을 수행 할 수 있습니다. 각 자리 표시자는 중괄호로 묶어야합니다. 세 번째 매개 변수에서는 자리 표시 자 이름 배열 (중괄호없이)과 해당 값을 제공해야합니다. 다음 메시지 문자열에 삽입됩니다.

::

	// Generates a message like: User 123 logged into the system from 127.0.0.1
	$info = [
		'id' => $user->id,
		'ip_address' => $this->request->ip_address()
	];

	log_message('info', 'User {id} logged into the system from {ip_address}', $info);

If you want to log an Exception or an Error, you can use the key of 'exception', and the value being the
Exception or Error itself. A string will be generated from that object containing the error message, the
file name and line number.  You must still provide the exception placeholder in the message
예외 또는 오류를 기록하려면 '예외'키를 사용하고 값은 예외 또는 오류 자체를 사용할 수 있습니다. 오류 메시지, 파일 이름 및 행 번호가 들어있는 해당 객체에서 문자열이 생성됩니다. 메시지에 예외 자리 표시자를 계속 제공해야합니다.

::

	try
	{
		... Something throws error here
	}
	catch (\Exception $e)
	{
		log_message('error', '[ERROR] {exception}', ['exception' => $e]);
	}

Several core placeholders exist that will be automatically expanded for you based on the current page request:
현재 페이지 요청을 기반으로 자동으로 확장되는 몇 가지 핵심 자리 표시자가 존재합니다.

+----------------+---------------------------------------------------+
| Placeholder    | Inserted value                                    |
+================+===================================================+
| {post_vars}    | $_POST variables                                  |
+----------------+---------------------------------------------------+
| {get_vars}     | $_GET variables                                   |
+----------------+---------------------------------------------------+
| {session_vars} | $_SESSION variables                               |
+----------------+---------------------------------------------------+
| {env}          | Current environment name, i.e. development        |
+----------------+---------------------------------------------------+
| {file}         | The name of file calling the logger               |
+----------------+---------------------------------------------------+
| {line}         | The line in {file} where the logger was called    |
+----------------+---------------------------------------------------+
| {env:foo}      | The value of 'foo' in $_ENV                       |
+----------------+---------------------------------------------------+

Using Third-Party Loggers
=========================

You can use any other logger that you might like as long as it extends from either
``Psr\Log\LoggerInterface`` and is `PSR3 <http://www.php-fig.org/psr/psr-3/>`_ compatible. This means
that you can easily drop in use for any PSR3-compatible logger, or create your own.
당신은 당신이 한 그 중 하나에서 확장으로 같은 수있는 다른 로거 사용 Psr\Log\LoggerInterface하고있다 하는 PSR 호환. 즉, PSR3 호환 로거에서 쉽게 사용 중지하거나 직접 만들 수 있습니다.

You must ensure that the third-party logger can be found by the system, by adding it to either
the ``/application/Config/Autoload.php`` configuration file, or through another autoloader,
like Composer. Next, you should modify ``/application/Config/Services.php`` to point the ``logger``
alias to your new class name.
타사 로거를 시스템에서 찾 /application/Config/Autoload.php거나 구성 파일이나 Composer와 같은 다른 자동 공급기를 통해 추가 할 수 있어야합니다 . 그런 다음 별칭을 새 클래스 이름 /application/Config/Services.php으로 가리 키도록 수정해야합니다 logger.

Now, any call that is done through the ``log_message()`` function will use your library instead.
이제 log_message()함수를 통해 수행 된 모든 호출은 대신 라이브러리를 사용합니다.

LoggerAware Trait
=================

If you would like to implement your libraries in a framework-agnostic method, you can use
the ``CodeIgniter\Log\LoggerAwareTrait`` which implements the ``setLogger()`` method for you.
Then, when you use your library under different environments for frameworks, your library should
still be able to log as it would expect, as long as it can find a PSR3 compatible logger.
라이브러리를 프레임 워크에 무관 한 방법 CodeIgniter\Log\LoggerAwareTrait으로 구현하려는 경우이 방법을 구현하는 라이브러리를 사용할 수 setLogger()있습니다. 그런 다음 프레임 워크 용 서로 다른 환경에서 라이브러리를 사용하는 경우 PSR3 호환 로거를 찾을 수있는 한 라이브러리는 예상대로 로그 할 수 있어야합니다.
