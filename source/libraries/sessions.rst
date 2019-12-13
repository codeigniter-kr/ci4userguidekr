###################
세션 라이브러리
###################

Session 클래스를 사용하면 사용자의 "상태"를 유지하고 사이트를 탐색하는 동안 활동을 추적할 수 있습니다.

CodeIgniter에는 목차의 마지막 섹션에서 볼 수 있는 몇 가지 세션 스토리지 드라이버가 제공됩니다.

.. contents::
    :local:
    :depth: 2

.. raw:: html

  <div class="custom-index container"></div>

세션 클래스 사용
*******************

세션 초기화
=================

세션은 일반적으로 각 페이지를 로드할 때마다 전체적으로 실행되므로 세션 클래스를 초기화해야 합니다.

세션에 액세스하고 초기화하려면

::

	$session = \Config\Services::session($config);

``$config`` 매개 변수는 선택 사항이며, 제공되지 않으면 서비스 레지스터가 기본 설정을 인스턴스화 합니다.

로드되면, 세션 라이브러리 객체를 사용할 수 있습니다

::

	$session

또는 기본 구성 옵션을 사용하는 헬퍼 기능을 사용할 수 있습니다.
이 버전은 읽기 쉽지만 구성 옵션이 없습니다.

::

	$session = session();

세션은 어떻게 작동합니까?
=============================

페이지가 로드되면 세션 클래스는 사용자의 브라우저에서 유효한 세션 쿠키가 전송되는지 확인합니다.
세션 쿠키가 존재하지 않거나, 서버에 저장된 쿠키와 일치하지 않거나, 만료된 경우 새 세션이 생성되고 저장됩니다.

유효한 세션이 존재하면 해당 정보가 업데이트됩니다. 
업데이트할 때마다 세션 ID가 다시 생성될 수 있습니다.

일단 Session 클래스가 초기화되면 자동으로 실행된다는 것을 이해하는 것이 중요합니다.
위의 동작을 발생시키기 위해 수행해야 할 작업은 없습니다.
아래에서 볼 수 있듯이 세션 데이터로 작업할 수 있지만, 세션을 읽고, 쓰고, 업데이트하는 프로세스는 자동입니다.

.. note:: 세션 라이브러리는 HTTP 프로토콜을 기반으로 하는 개념이므로 CLI에서는 자동으로 중지됩니다.

동시성에 대한 메모
------------------------

AJAX 사용량이 많은 웹 사이트를 개발하지 않는다면 이 섹션을 건너 뛸 수 있습니다.
그러나 세션으로 인해 성능 문제가 발생한다면, 이 메모를 참고 하십시오.

이전 버전의 CodeIgniter의 세션은 잠금을 구현하지 않았으므로, 동일한 세션을 사용하는 두 개의 HTTP 요청이 동시에 실행될 수 있었습니다. - 보다 적절한 기술 용어를 사용하면 요청이 차단되지 않았습니다.

그러나 세션 컨텍스트에 대해 비차단 요청은 안전하지 않음을 의미하기도 합니다. 
한 요청에서 세션 데이터(또는 세션 ID 재생성)를 수정하면 두 번째 동시 요청의 실행을 방해할 수 있기 때문입니다. 
이러한 세부 사항은 많은 문제의 근원이며, CodeIgniter 4가 세션 라이브러리를 완전히 다시 작성된 주된 이유입니다.

왜 우리가 이것을 말합니까? 
성능 문제의 원인을 찾은 후에는 세션 잠금이 문제라는 결론을 내릴 수 있으므로 세션 잠금을 제거하는 방법을 조사 할 수 있습니다.

그렇게 하지 마세요! 잠금 장치를 제거하는 것은 **잘못된** 방법이며, 더 많은 문제를 일으킬 수 있습니다!

잠금은 문제가 아니며 해결책입니다. 
문제는 여전히 세션을 이미 처리했지만 더 이상 필요하지 않은 상태에서 열어두는 것 입니다.
따라서 현재 요청이 더 이상 세션을 필요하지 않다면 세션을 아래와 같이 닫아주세요.

::

    $session->destroy();

세션 데이터란 무엇입니까?
============================

세션 데이터는 단순히 특정 세션 ID(cookie)와 연결된 배열입니다.

If you've used sessions in PHP before, you should be familiar with PHP's `$_SESSION superglobal <http://php.net/manual/en/reserved.variables.session.php>`_ (if not, please read the content on that link).

CodeIgniter gives access to its session data through the same means, as it uses the session handlers' mechanism provided by PHP. 
Using session data is as simple as manipulating (read, set and unset values) the ``$_SESSION`` array.

In addition, CodeIgniter also provides 2 special types of session data that are further explained below: flashdata and tempdata.
PHP에서 세션을 사용해 본 적이 있다면 PHP의 `$_SESSION superglobal <http://php.net/manual/en/reserved.variables.session.php>`_\ 에 익숙해야 합니다.(그렇지 않은 경우 해당 링크의 내용을 읽으십시오.)

CodeIgniter는 PHP에서 제공하는 세션 핸들러 메커니즘을 사용하는 것과 동일한 방법으로 세션 데이터에 액세스합니다.
세션 데이터를 사용하는 것은``$ _SESSION ''배열을 조작 (읽기, 설정 및 설정 해제)하는 것만 큼 간단합니다.

또한 CodeIgniter는 아래에서 자세히 설명하는 두 가지 특수 유형의 세션 데이터 (flashdata 및 tempdata)도 제공합니다.

세션 데이터 검색
=======================

세션 배열의 모든 정보는 ``$_SESSION`` superglobal을 통해 사용할 수 있습니다

::

	$_SESSION['item']

또는 기존의 접근자 메소드를 통해

::

	$session->get('item');

또는 매직 게터(magic gatter)를 통해

::

	$session->item

또는 세션 헬퍼 메소드를 통해서도

::

	session('item');

여기서 ``item``\ 은 가져 오려는 항목에 해당하는 배열 키입니다.
예를 들어, 이전에 저장된 'name' 항목을 ``$name`` 변수에 할당하려면 다음과 같이 합니다.

::

	$name = $_SESSION['name'];

	// or:

	$name = $session->name

	// or:

	$name = $session->get('name');

.. note:: 액세스하려는 항목이 존재하지 않으면 ``get()`` 메소드는 NULL을 반환합니다.

기존 사용자 데이터를 모두 검색하려면 항목 키를 생략하면 됩니다. (magic getter 는 단일 속성 값에 대해서만 작동합니다)

::

	$_SESSION

	// or:

	$session->get();

세션 데이터 추가
===================

Let's say a particular user logs into your site. Once authenticated, you could add their username and e-mail address to the session, making that data globally available to you without having to run a database query when you need it.

You can simply assign data to the ``$_SESSION`` array, as with any other variable. Or as a property of ``$session``.

The former userdata method is deprecated, but you can pass an array containing your new session data to the ``set()`` method::
특정 사용자가 사이트에 로그인한다고 가정해 보겠습니다. 
인증되면 사용자 이름과 전자 메일 주소를 세션에 추가하여 필요할 때 데이터베이스 쿼리를 실행할 필요없이 해당 데이터를 전체적으로 사용할 수 있습니다.

다른 변수와 마찬가지로 간단히 ``$_SESSION`` 배열 또는 ``$session``\ 의 속성에 데이터를 할당할 수 있습니다.

이전 userdata 메소드는 더 이상 사용되지 않지만, 새로운 세션 데이터를 포함하는 배열을 ``set()`` 메소드로 전달할 수 있습니다.

::

	$session->set($array);

여기서 ``$array``\ 는 새 데이터를 포함하는 연관 배열입니다.
여기에 예가 있습니다.

::

	$newdata = [
		'username'  => 'johndoe',
		'email'     => 'johndoe@some-site.com',
		'logged_in' => TRUE
	];

	$session->set($newdata);

``set()``\ 은 한 번에 하나의 값으로 세션 데이터를 추가하는 것도 지원합니다

::

	$session->set('some_name', 'some_value');

세션 값이 존재하는지 확인하려면 ``isset()``\ 으로 확인하십시오.

::

	// returns FALSE if the 'some_name' item doesn't exist or is NULL,
	// TRUE otherwise:
	isset($_SESSION['some_name'])

또는 ``has()``\ 를 호출 할 수도 있습니다.

::

	$session->has('some_name');

세션 데이터에 새로운 값 제공
=================================

push 메소드는 배열인 세션 값으로 새로운 값을 푸시하는 데 사용됩니다.
예를 들어, 'hobbies' 키에 일련의 취미가 포함된 경우 다음과 같이 배열에 새로운 값을 추가할 수 있습니다

::

$session->push('hobbies', ['sport'=>'tennis']);

세션 데이터 제거
=====================

다른 변수와 마찬가지로 ``$_SESSION``\ 의 값 설정 해제는 ``unset()``\ 을 통해 수행합니다.

::

	unset($_SESSION['some_name']);

	// or multiple values:

	unset(
		$_SESSION['some_name'],
		$_SESSION['another_name']
	);

또한 ``set()``\ 을 사용하여 세션에 정보를 추가할 수 있는 것처럼 세션 키를 ``remove()``\ 메소드에 전달하여 정보를 제거할 수 있습니다.
예를 들어, 세션 데이터 배열에서 'some_name'\ 을 제거하려는 경우

::

	$session->remove('some_name');

이 방법은 또한 설정 해제를 위해 일련의 항목 키를 허용합니다.

::

	$array_items = ['username', 'email'];
	$session->remove($array_items);

플래시 데이터
=================

CodeIgniter는 세션 데이터를 다음 요청에서만 사용한 다음 자동으로 지워지는 "flashdata"\ 를 지원합니다.

이는 일회성 정보, 오류 또는 상태 메시지 (예 : "레코드 2 삭제됨")에 매우 유용합니다.

flashdata 변수는 CodeIgniter 세션 핸들러내에서 관리되는 일반 세션 변수입니다.

기존 항목을 "flashdata"로 표시하려면

::

	$session->markAsFlashdata('item');

여러 항목을 플래시 데이터로 표시하려면 키를 배열로 전달하면됩니다.

::

	$session->markAsFlashdata(['item', 'item2']);

플래시 데이터를 추가하려면

::

	$_SESSION['item'] = 'value';
	$session->markAsFlashdata('item');

또는 ``setFlashdata()`` 메서드를 사용하여

::

	$session->setFlashdata('item', 'value');

``set()``\ 과 같은 방식으로 ``setFlashdata()``\ 에 배열을 전달할 수도 있습니다.

플래시 데이터 변수를 읽는 것은 ``$_SESSION``\ 을 통해 일반 세션 데이터를 읽는 것과 같습니다.

::

	$_SESSION['item']

.. important:: ``get()`` 메소드는 키로 단일 항목을 검색할 때 플래시 데이터 항목을 반환합니다. 그러나 세션에서 모든 사용자 데이터를 가져올 때 플래시 데이터를 반환하지 않습니다.

``getFlashdata()`` 메서드를 사용하면 "flashdata"\ 의 값만 가져올 수 있습니다

::

	$session->getFlashdata('item');

모든 플래시 데이터가 있는 배열을 얻으려면 키 매개 변수를 생략하십시오.

::

	$session->getFlashdata();

.. note:: ``getFlashdata()`` 메소드는 항목을 찾을 수 없는 경우 NULL을 리턴합니다.

추가 요청을 통해 플래시 데이터 변수를 유지해야 하는 경우 ``keepFlashdata()`` 메서드를 사용하여 이를 수행 할 수 있습니다.
단일 항목 또는 플래시 데이터 항목 배열을 전달하여 유지합니다.

::

	$session->keepFlashdata('item');
	$session->keepFlashdata(['item1', 'item2', 'item3']);

tempdata
===============

CodeIgniter는 특정 만료 시간을 가지는 세션 데이터 "tempdata"도 지원합니다. 
값이 만료되거나, 세션이 만료되거나, 삭제되면 값이 자동으로 제거됩니다.

flashdata와 마찬가지로 tempdata 변수는 CodeIgniter 세션 처리기에 의해 내부적으로 관리됩니다.

기존 항목을 "tempdata"로 전환하려면 해당 키와 만료 시간 (초)을 ``mark_as_temp()`` 메서드에 전달하면 됩니다.

::

	// 'item' will be erased after 300 seconds
	$session->markAsTempdata('item', 300);

모두 동일한 만료 시간을 원하는지 여부에 따라 두 가지 방법으로 여러 항목을 tempdata로 표시할 수 있습니다.

::

	// Both 'item' and 'item2' will expire after 300 seconds
	$session->markAsTempdata(['item', 'item2'], 300);

	// 'item' will be erased after 300 seconds, while 'item2'
	// will do so after only 240 seconds
	$session->markAsTempdata([
		'item'	=> 300,
		'item2'	=> 240
	]);

tempdata를 추가하려면

::

	$_SESSION['item'] = 'value';
	$session->markAsTempdata('item', 300); // Expire in 5 minutes

또는 ``setTempdata()`` 메서드를 사용하여

::

	$session->setTempdata('item', 'value', 300);

``set_tempdata()``\ 에 배열을 전달할 수 있습니다.
::

	$tempdata = ['newuser' => TRUE, 'message' => 'Thanks for joining!'];
	$session->setTempdata($tempdata, NULL, $expire);

.. note:: 만료를 생략하거나 0으로 설정하면 기본 활성 시간 값인 300 초(5 분)가 사용됩니다.

tempdata 변수를 읽으려면 ``$_SESSION`` 슈퍼 전역 배열을 통해 액세스할 수 있습니다

::

	$_SESSION['item']

.. important:: The ``get()`` method WILL return tempdata items when retrieving a single item by key. It will not return tempdata when grabbing all userdata from the session, however.

Or if you want to be sure that you're reading "tempdata" (and not any other kind), you can also use the ``getTempdata()`` method
``get()`` 메소드는 키로 단일 항목을 검색할 때 tempdata 항목을 반환합니다. 
그러나 세션에서 모든 사용자 데이터를 가져 오면 tempdata를 반환하지 않습니다.

``getTempdata()`` 메서드를 사용하여 "tempdata"\ 의 값만 가져올수 있습니다

::

	$session->getTempdata('item');

물론 기존의 모든 tempdata를 검색하려는 경우

::

	$session->getTempdata();

.. note:: ``getTempdata()`` 메소드는 항목을 찾을 수 없는 경우 NULL을 리턴합니다.

만료되기 전에 tempdata 값을 제거해야 하는 경우 ``$_SESSION`` 배열에서 직접 설정을 해제 할 수 있습니다.

::

	unset($_SESSION['item']);

그러나 이 특정 항목을 tempdata로 만드는 마커를 제거하지는 않으므로 (다음 HTTP 요청에서 무효화 됨) 동일한 요청에서 동일한 키를 재사용하려는 경우 ``removeTempdata()`` 메소드를 호출합니다.

::

	$session->removeTempdata('item');

세션 파괴
====================

현재 세션을 지우려면 (예 : 로그 아웃 중) PHP의 `session_destroy() <http://php.net/session_destroy>`_ 함수 또는 라이브러리의 ``destroy()`` 메소드를 사용하면됩니다.
둘 다 정확히 같은 방식으로 작동합니다.

::

	session_destroy();

	// or

	$session->destroy();

.. note:: 동일한 요청 중에 수행한 마지막 세션 관련 작업이어야 합니다. 모든 세션 데이터 (플래시 데이터 및 tmpdata 포함)는 영구적으로 삭제되며 세션을 삭제한 후 동일한 요청 중에 기능을 사용할 수 없습니다.

``stop()`` 메서드를 사용하여 이전 session_id와 모든 데이터를 삭제하고, 세션 ID가 포함된 쿠키를 삭제하여 세션을 완전히 종료할 수 있습니다

::

    $session->stop();

세션 메타 데이터 액세스
==========================

이전 CodeIgniter 버전에서 세션 데이터 배열에 4개의 항목이 포함되었습니다: 'session_id', 'ip_address', 'user_agent', 'last_activity'.

이 항목들은 세션의 작동 방식에 대한 세부 사항을 위한 것이지만 이제는 새로운 구현에 더 이상 필요하지 않습니다.
그러나 애플리케이션이 이러한 값에 의존한다면, 다음과 같은 방법으로 액세스할 수 있습니다.

  - session_id: ``session_id()``
  - ip_address: ``$_SERVER['REMOTE_ADDR']``
  - user_agent: ``$_SERVER['HTTP_USER_AGENT']`` (unused by sessions)
  - last_activity: Depends on the storage, no straightforward way. Sorry!

세션 환경 설정
***********************

CodeIgniter는 일반적으로 모든 것을 즉시 사용할 수 있도록 합니다.
그러나 세션은 모든 응용 프로그램에서 매우 민감한 구성 요소이므로 신중하게 구성해야합니다. 
시간을내어 모든 옵션과 그 효과를 고려하십시오.

**app/Config/App.php** 파일에서 다음 세션 관련 환경 설정을 찾을 수 있습니다.

============================== ========================================= ============================================== ============================================================================================
Preference                     Default                                   Options                                        Description
============================== ========================================= ============================================== ============================================================================================
**sessionDriver**              CodeIgniter\Session\Handlers\FileHandler  CodeIgniter\Session\Handlers\FileHandler       사용할 세션 스토리지 드라이버
                                                                         CodeIgniter\Session\Handlers\DatabaseHandler
                                                                         CodeIgniter\Session\Handlers\MemcachedHandler
                                                                         CodeIgniter\Session\Handlers\RedisHandler
                                                                         CodeIgniter\Session\Handlers\ArrayHandler
**sessionCookieName**          ci_session                                [A-Za-z\_-] characters only                    세션 쿠키에 사용되는 이름
**sessionExpiration**          7200 (2 hours)                            Time in seconds (integer)                      세션이 지속되기를 원하는 시간 (초), 
                                                                                                                        만료되지 않는 세션을 원할 경우 (브라우저가 닫힐 때까지) 값을 0으로 설정하십시오.
**sessionSavePath**            NULL                                      None                                           사용중인 드라이버에 따라 저장 위치를 지정
**sessionMatchIP**             FALSE                                     TRUE/FALSE (boolean)                           세션 쿠키를 읽을 때 사용자의 IP 주소를 확인할지 여부,
                                                                                                                        일부 ISP는 동적으로 IP를 변경하므로 만료되지 않는 세션을 원할 경우 FALSE로 설정합십시오.
**sessionTimeToUpdate**        300                                       Time in seconds (integer)                      이 옵션은 세션 클래스가 자신을 재생성하고 새 세션 ID를 작성하는 빈도를 제어합니다. 
                                                                                                                        0 으로 설정하면 세션 ID 재생성이 비활성화됩니다.
**sessionRegenerateDestroy**   FALSE                                     TRUE/FALSE (boolean)                           세션 ID를 자동 재생성 할 때 이전 세션 ID와 연관된 세션 데이터를 삭제할지 여부,
                                                                                                                        FALSE로 설정하면 나중에 가비지 콜렉터가 데이터를 삭제합니다.
============================== ========================================= ============================================== ============================================================================================

.. note:: 세션 라이브러리는 PHP의 세션 관련 INI 설정과 위의 항목 중 하나라도 구성되지 않은 경우, 최후의 수단으로 'sess_expire_on_close'\ 와 같은 레거시 CI 설정을 가져 오려고 시도합니다.
	그러나 예기치 않은 결과가 발생하거나 나중에 변경될 수 있으므로 이 방법에 의존해서는 안됩니다. 모든 것을 올바르게 구성하십시오.

In addition to the values above, the cookie and native drivers apply the following configuration values shared by the :doc:`IncomingRequest </incoming/incomingrequest>` and :doc:`Security <security>` classes:
위의 값 외에도 쿠키 및 기본 드라이버는 :doc:`IncomingRequest </incoming / incomingrequest>`및 : doc :`Security <security>`클래스에서 공유하는 다음 구성 값을 적용합니다.

================== =============== ===========================================================================
Preference         Default         Description
================== =============== ===========================================================================
**cookieDomain**   ''              The domain for which the session is applicable
**cookiePath**     /               The path to which the session is applicable
**cookieSecure**   FALSE           Whether to create the session cookie only on encrypted (HTTPS) connections
================== =============== ===========================================================================

.. note:: The 'cookieHTTPOnly' setting doesn't have an effect on sessions.
	Instead the HttpOnly parameter is always enabled, for security
	reasons. Additionally, the 'cookiePrefix' setting is completely
	ignored.

Session Drivers
*********************************************************************

As already mentioned, the Session library comes with 4 handlers, or storage
engines, that you can use:

  - CodeIgniter\Session\Handlers\FileHandler
  - CodeIgniter\Session\Handlers\DatabaseHandler
  - CodeIgniter\Session\Handlers\MemcachedHandler
  - CodeIgniter\Session\Handlers\RedisHandler
  - CodeIgniter\Session\Handlers\ArrayHandler

By default, the ``FileHandler`` Driver will be used when a session is initialized,
because it is the safest choice and is expected to work everywhere
(virtually every environment has a file system).

However, any other driver may be selected via the ``public $sessionDriver``
line in your **app/Config/App.php** file, if you chose to do so.
Have it in mind though, every driver has different caveats, so be sure to
get yourself familiar with them (below) before you make that choice.

.. note:: The ArrayHandler is used during testing and stores all data within
    a PHP array, while preventing the data from being persisted.

FileHandler Driver (the default)
==================================================================

The 'FileHandler' driver uses your file system for storing session data.

It can safely be said that it works exactly like PHP's own default session
implementation, but in case this is an important detail for you, have it
mind that it is in fact not the same code and it has some limitations
(and advantages).

To be more specific, it doesn't support PHP's `directory level and mode
formats used in session.save_path
<http://php.net/manual/en/session.configuration.php#ini.session.save-path>`_,
and it has most of the options hard-coded for safety. Instead, only
absolute paths are supported for ``public $sessionSavePath``.

Another important thing that you should know, is to make sure that you
don't use a publicly-readable or shared directory for storing your session
files. Make sure that *only you* have access to see the contents of your
chosen *sessionSavePath* directory. Otherwise, anybody who can do that, can
also steal any of the current sessions (also known as "session fixation"
attack).

On UNIX-like operating systems, this is usually achieved by setting the
0700 mode permissions on that directory via the `chmod` command, which
allows only the directory's owner to perform read and write operations on
it. But be careful because the system user *running* the script is usually
not your own, but something like 'www-data' instead, so only setting those
permissions will probably break your application.

Instead, you should do something like this, depending on your environment
::

	mkdir /<path to your application directory>/Writable/sessions/
	chmod 0700 /<path to your application directory>/Writable/sessions/
	chown www-data /<path to your application directory>/Writable/sessions/

Bonus Tip
--------------------------------------------------------

Some of you will probably opt to choose another session driver because
file storage is usually slower. This is only half true.

A very basic test will probably trick you into believing that an SQL
database is faster, but in 99% of the cases, this is only true while you
only have a few current sessions. As the sessions count and server loads
increase - which is the time when it matters - the file system will
consistently outperform almost all relational database setups.

In addition, if performance is your only concern, you may want to look
into using `tmpfs <http://eddmann.com/posts/storing-php-sessions-file-caches-in-memory-using-tmpfs/>`_,
(warning: external resource), which can make your sessions blazing fast.

DatabaseHandler Driver
==================================================================

The 'DatabaseHandler' driver uses a relational database such as MySQL or
PostgreSQL to store sessions. This is a popular choice among many users,
because it allows the developer easy access to the session data within
an application - it is just another table in your database.

However, there are some conditions that must be met:

  - You can NOT use a persistent connection.
  - You can NOT use a connection with the *cacheOn* setting enabled.

In order to use the 'DatabaseHandler' session driver, you must also create this
table that we already mentioned and then set it as your
``$sessionSavePath`` value.
For example, if you would like to use 'ci_sessions' as your table name,
you would do this::

	public $sessionDriver   = 'CodeIgniter\Session\Handlers\DatabaseHandler';
	public $sessionSavePath = 'ci_sessions';

And then of course, create the database table ...

For MySQL::

	CREATE TABLE IF NOT EXISTS `ci_sessions` (
		`id` varchar(128) NOT NULL,
		`ip_address` varchar(45) NOT NULL,
		`timestamp` int(10) unsigned DEFAULT 0 NOT NULL,
		`data` blob NOT NULL,
		KEY `ci_sessions_timestamp` (`timestamp`)
	);

For PostgreSQL::

	CREATE TABLE "ci_sessions" (
		"id" varchar(128) NOT NULL,
		"ip_address" varchar(45) NOT NULL,
		"timestamp" bigint DEFAULT 0 NOT NULL,
		"data" text DEFAULT '' NOT NULL
	);

	CREATE INDEX "ci_sessions_timestamp" ON "ci_sessions" ("timestamp");

You will also need to add a PRIMARY KEY **depending on your 'sessionMatchIP'
setting**. The examples below work both on MySQL and PostgreSQL::

	// When sessionMatchIP = TRUE
	ALTER TABLE ci_sessions ADD PRIMARY KEY (id, ip_address);

	// When sessionMatchIP = FALSE
	ALTER TABLE ci_sessions ADD PRIMARY KEY (id);

	// To drop a previously created primary key (use when changing the setting)
	ALTER TABLE ci_sessions DROP PRIMARY KEY;

You can choose the Database group to use by adding a new line to the
**application\Config\App.php** file with the name of the group to use::

  public $sessionDBGroup = 'groupName';

If you'd rather not do all of this by hand, you can use the ``session:migration`` command
from the cli to generate a migration file for you::

  > php spark session:migration
  > php spark migrate

This command will take the **sessionSavePath** and **sessionMatchIP** settings into account
when it generates the code.

.. important:: Only MySQL and PostgreSQL databases are officially
	supported, due to lack of advisory locking mechanisms on other
	platforms. Using sessions without locks can cause all sorts of
	problems, especially with heavy usage of AJAX, and we will not
	support such cases. Use ``session_write_close()`` after you've
	done processing session data if you're having performance
	issues.

RedisHandler Driver
==================================================================

.. note:: Since Redis doesn't have a locking mechanism exposed, locks for
	this driver are emulated by a separate value that is kept for up
	to 300 seconds.

Redis is a storage engine typically used for caching and popular because
of its high performance, which is also probably your reason to use the
'RedisHandler' session driver.

The downside is that it is not as ubiquitous as relational databases and
requires the `phpredis <https://github.com/phpredis/phpredis>`_ PHP
extension to be installed on your system, and that one doesn't come
bundled with PHP.
Chances are, you're only be using the RedisHandler driver only if you're already
both familiar with Redis and using it for other purposes.

Just as with the 'FileHandler' and 'DatabaseHandler' drivers, you must also configure
the storage location for your sessions via the
``$sessionSavePath`` setting.
The format here is a bit different and complicated at the same time. It is
best explained by the *phpredis* extension's README file, so we'll simply
link you to it:

	https://github.com/phpredis/phpredis#php-session-handler

.. warning:: CodeIgniter's Session library does NOT use the actual 'redis'
	``session.save_handler``. Take note **only** of the path format in
	the link above.

For the most common case however, a simple ``host:port`` pair should be
sufficient::

	public $sessionDiver    = 'CodeIgniter\Session\Handlers\RedisHandler';
	public $sessionSavePath = 'tcp://localhost:6379';

MemcachedHandler Driver
==================================================================

.. note:: Since Memcached doesn't have a locking mechanism exposed, locks
	for this driver are emulated by a separate value that is kept for
	up to 300 seconds.

The 'MemcachedHandler' driver is very similar to the 'RedisHandler' one in all of its
properties, except perhaps for availability, because PHP's `Memcached
<http://php.net/memcached>`_ extension is distributed via PECL and some
Linux distributions make it available as an easy to install package.

Other than that, and without any intentional bias towards Redis, there's
not much different to be said about Memcached - it is also a popular
product that is usually used for caching and famed for its speed.

However, it is worth noting that the only guarantee given by Memcached
is that setting value X to expire after Y seconds will result in it being
deleted after Y seconds have passed (but not necessarily that it won't
expire earlier than that time). This happens very rarely, but should be
considered as it may result in loss of sessions.

The ``$sessionSavePath`` format is fairly straightforward here,
being just a ``host:port`` pair::

	public $sessionDriver   = 'CodeIgniter\Session\Handlers\MemcachedHandler';
	public $sessionSavePath = 'localhost:11211';

Bonus Tip
--------------------------------------------------------

Multi-server configuration with an optional *weight* parameter as the
third colon-separated (``:weight``) value is also supported, but we have
to note that we haven't tested if that is reliable.

If you want to experiment with this feature (on your own risk), simply
separate the multiple server paths with commas::

	// localhost will be given higher priority (5) here,
	// compared to 192.0.2.1 with a weight of 1.
	public $sessionSavePath = 'localhost:11211:5,192.0.2.1:11211:1';
