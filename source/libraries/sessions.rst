###################
세션 라이브러리
###################

Session 클래스를 사용하면 사용자의 "상태"를 유지하고 사이트를 탐색하는 동안 활동을 추적할 수 있습니다.

CodeIgniter에는 목차의 마지막 섹션에서 볼 수 있는 몇 가지 세션 스토리지 드라이버가 제공됩니다.

.. contents::
    :local:
    :depth: 2

세션 클래스 사용
*******************

세션 초기화
=================

세션은 일반적으로 각 페이지를 로드할 때마다 전체적으로 실행되므로 세션 클래스를 초기화해야 합니다.

세션에 액세스하고 초기화하려면

.. literalinclude:: sessions/001.php

``$config`` 매개 변수는 선택 사항이며, 제공되지 않으면 서비스 레지스터가 기본 설정을 인스턴스화 합니다.

로드되면, 세션 라이브러리 객체를 사용할 수 있습니다

::

	$session

또는 기본 구성 옵션을 사용하는 헬퍼 기능을 사용할 수 있습니다.
이 버전은 읽기 쉽지만 구성 옵션이 없습니다.

.. literalinclude:: sessions/002.php

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

CodeIgniter v2.x의 세션은 잠금을 구현하지 않았으므로, 동일한 세션을 사용하는 두 개의 HTTP 요청이 동시에 실행될 수 있었습니다. - 보다 적절한 기술 용어를 사용하면 요청이 차단되지 않았습니다.

그러나 세션 컨텍스트에 대해 비차단 요청은 안전하지 않음을 의미하기도 합니다. 
한 요청에서 세션 데이터(또는 세션 ID 재생성)를 수정하면 두 번째 동시 요청의 실행을 방해할 수 있기 때문입니다. 
이러한 세부 사항은 많은 문제의 근원이며, CodeIgniter 4가 세션 라이브러리를 완전히 다시 작성된 주된 이유입니다.

왜 우리가 이것을 말합니까? 
성능 문제의 원인을 찾은 후에는 세션 잠금이 문제라는 결론을 내릴 수 있으므로 세션 잠금을 제거하는 방법을 조사 할 수 있습니다.

그렇게 하지 마세요! 잠금 장치를 제거하는 것은 **잘못된** 방법이며, 더 많은 문제를 일으킬 수 있습니다!

잠금은 문제가 아니며 해결책입니다. 
문제는 여전히 세션을 이미 처리했지만 더 이상 필요하지 않은 상태에서 열어두는 것 입니다.
따라서 현재 요청이 더 이상 세션을 필요하지 않다면 세션을 아래와 같이 닫아주세요.

.. literalinclude:: sessions/003.php

세션 데이터란 무엇입니까?
============================

세션 데이터는 단순히 특정 세션 ID(cookie)와 연결된 배열입니다.

PHP에서 세션을 사용해 본 적이 있다면 PHP의 `$_SESSION superglobal <https://www.php.net/manual/en/reserved.variables.session.php>`_\ 에 익숙해야 합니다.(그렇지 않은 경우 해당 링크의 내용을 읽으십시오.)

CodeIgniter는 PHP에서 제공하는 세션 핸들러 메커니즘을 사용하는 것과 동일한 방법으로 세션 데이터에 액세스합니다.
세션 데이터를 사용하는 것은``$ _SESSION ''배열을 조작 (읽기, 설정 및 설정 해제)하는 것만 큼 간단합니다.

또한 CodeIgniter는 아래에서 자세히 설명하는 두 가지 특수 유형의 세션 데이터 (flashdata 및 tempdata)도 제공합니다.

세션 데이터 검색
=======================

세션 배열의 모든 정보는 ``$_SESSION`` superglobal을 통해 사용할 수 있습니다

.. literalinclude:: sessions/004.php

또는 기존의 접근자 메소드를 통해

.. literalinclude:: sessions/005.php

또는 매직 게터(magic gatter)를 통해

.. literalinclude:: sessions/006.php

또는 세션 헬퍼 메소드를 통해서도

.. literalinclude:: sessions/007.php

여기서 ``item``\ 은 가져 오려는 항목에 해당하는 배열 키입니다.
예를 들어, 이전에 저장된 'name' 항목을 ``$name`` 변수에 할당하려면 다음과 같이 합니다.

.. literalinclude:: sessions/008.php

.. note:: 액세스하려는 항목이 존재하지 않으면 ``get()`` 메소드는 null을 반환합니다.

기존 사용자 데이터를 모두 검색하려면 항목 키를 생략하면 됩니다. (magic getter 는 단일 속성 값에 대해서만 작동합니다)

.. literalinclude:: sessions/009.php

세션 데이터 추가
===================

특정 사용자가 사이트에 로그인한다고 가정해 보겠습니다. 
인증되면 사용자 이름과 전자 메일 주소를 세션에 추가하여 필요할 때 데이터베이스 쿼리를 실행할 필요없이 해당 데이터를 전체적으로 사용할 수 있습니다.

다른 변수와 마찬가지로 간단히 ``$_SESSION`` 배열 또는 ``$session``\ 의 속성에 데이터를 할당할 수 있습니다.

이전 userdata 메소드는 더 이상 사용되지 않지만, 새로운 세션 데이터를 포함하는 배열을 ``set()`` 메소드로 전달할 수 있습니다.

.. literalinclude:: sessions/010.php

여기서 ``$array``\ 는 새 데이터를 포함하는 연관 배열입니다.
여기에 예가 있습니다.

.. literalinclude:: sessions/011.php

``set()``\ 은 한 번에 하나의 값으로 세션 데이터를 추가하는 것도 지원합니다

.. literalinclude:: sessions/012.php

세션 값이 존재하는지 확인하려면 ``isset()``\ 으로 확인하십시오.

.. literalinclude:: sessions/013.php

또는 ``has()``\ 를 호출 할 수도 있습니다.

.. literalinclude:: sessions/014.php

세션 데이터에 새로운 값 제공
=================================

push 메소드는 배열인 세션 값으로 새로운 값을 푸시하는 데 사용됩니다.
예를 들어, 'hobbies' 키에 일련의 취미가 포함된 경우 다음과 같이 배열에 새로운 값을 추가할 수 있습니다

.. literalinclude:: sessions/015.php

세션 데이터 제거
=====================

다른 변수와 마찬가지로 ``$_SESSION``\ 의 값 설정 해제는 ``unset()``\ 을 통해 수행합니다.

.. literalinclude:: sessions/016.php

또한 ``set()``\ 을 사용하여 세션에 정보를 추가할 수 있는 것처럼 세션 키를 ``remove()``\ 메소드에 전달하여 정보를 제거할 수 있습니다.
예를 들어, 세션 데이터 배열에서 'some_name'\ 을 제거하려는 경우

.. literalinclude:: sessions/017.php

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

.. literalinclude:: sessions/019.php

여러 항목을 플래시 데이터로 표시하려면 키를 배열로 전달하면됩니다.

.. literalinclude:: sessions/020.php

플래시 데이터를 추가하려면

.. literalinclude:: sessions/021.php

또는 ``setFlashdata()`` 메소드를 사용하여

.. literalinclude:: sessions/022.php

``set()``\ 과 같은 방식으로 ``setFlashdata()``\ 에 배열을 전달할 수도 있습니다.

플래시 데이터 변수를 읽는 것은 ``$_SESSION``\ 을 통해 일반 세션 데이터를 읽는 것과 같습니다.

.. literalinclude:: sessions/023.php

.. important:: ``get()`` 메소드는 키로 단일 항목을 검색할 때 플래시 데이터 항목을 반환합니다. 그러나 세션에서 모든 사용자 데이터를 가져올 때 플래시 데이터를 반환하지 않습니다.

``getFlashdata()`` 메소드를 사용하면 "flashdata"\ 의 값만 가져올 수 있습니다

.. literalinclude:: sessions/024.php

모든 플래시 데이터가 있는 배열을 얻으려면 키 매개 변수를 생략하십시오.

.. literalinclude:: sessions/025.php

.. note:: ``getFlashdata()`` 메소드는 항목을 찾을 수 없는 경우 null을 리턴합니다.

추가 요청을 통해 플래시 데이터 변수를 유지해야 하는 경우 ``keepFlashdata()`` 메소드를 사용하여 이를 수행 할 수 있습니다.
단일 항목 또는 플래시 데이터 항목 배열을 전달하여 유지합니다.

.. literalinclude:: sessions/026.php

Tempdata
===============

CodeIgniter는 특정 만료 시간을 가지는 세션 데이터 "tempdata"도 지원합니다. 
값이 만료되거나, 세션이 만료되거나, 삭제되면 값이 자동으로 제거됩니다.

flashdata와 마찬가지로 tempdata 변수는 CodeIgniter 세션 처리기에 의해 내부적으로 관리됩니다.

기존 항목을 "tempdata"로 전환하려면 해당 키와 만료 시간 (초)을 ``markAsTempdata()`` 메소드에 전달하면 됩니다.

.. literalinclude:: sessions/027.php

모두 동일한 만료 시간을 원하는지 여부에 따라 두 가지 방법으로 여러 항목을 tempdata로 표시할 수 있습니다.

.. literalinclude:: sessions/028.php

tempdata를 추가하려면

.. literalinclude:: sessions/029.php

또는 ``setTempdata()`` 메소드를 사용하여

.. literalinclude:: sessions/030.php

``set_tempdata()``\ 에 배열을 전달할 수 있습니다.

.. literalinclude:: sessions/031.php

.. note:: 만료를 생략하거나 0으로 설정하면 기본 활성 시간 값인 300 초(5 분)가 사용됩니다.

tempdata 변수를 읽으려면 ``$_SESSION`` 슈퍼 전역 배열을 통해 액세스할 수 있습니다

.. literalinclude:: sessions/032.php

.. important:: ``get()`` 메소드는 키로 단일 항목을 검색할 때 tempdata 항목을 반환합니다. 그러나 세션에서 모든 사용자 데이터를 가져 오면 tempdata를 반환하지 않습니다.

``getTempdata()`` 메소드를 사용하여 "tempdata"\ 의 값만 가져올수 있습니다

.. literalinclude:: sessions/033.php

물론 기존의 모든 tempdata를 검색하려는 경우

.. literalinclude:: sessions/034.php

.. note:: ``getTempdata()`` 메소드는 항목을 찾을 수 없는 경우 null을 리턴합니다.

만료되기 전에 tempdata 값을 제거해야 하는 경우 ``$_SESSION`` 배열에서 직접 설정을 해제 할 수 있습니다.

.. literalinclude:: sessions/035.php

그러나 이 특정 항목을 tempdata로 만드는 마커를 제거하지는 않으므로 (다음 HTTP 요청에서 무효화 됨) 동일한 요청에서 동일한 키를 재사용하려는 경우 ``removeTempdata()`` 메소드를 호출합니다.

.. literalinclude:: sessions/036.php

세션 파괴
====================

현재 세션을 지우려면 (예 : 로그 아웃 중) PHP의 `session_destroy() <https://www.php.net/session_destroy>`_ 함수 또는 라이브러리의 ``destroy()`` 메소드를 사용하면됩니다.
둘 다 정확히 같은 방식으로 작동합니다.

.. literalinclude:: sessions/037.php

.. note:: 동일한 요청 중에 수행한 마지막 세션 관련 작업이어야 합니다. 모든 세션 데이터 (플래시 데이터 및 tmpdata 포함)는 영구적으로 삭제되며 세션을 삭제한 후 동일한 요청 중에 기능을 사용할 수 없습니다.

``stop()`` 메소드를 사용하여 이전 session_id와 모든 데이터를 삭제하고, 세션 ID가 포함된 쿠키를 삭제하여 세션을 완전히 종료할 수 있습니다

.. literalinclude:: sessions/038.php

세션 메타 데이터 액세스
==========================

이전 CodeIgniter 버전에서 세션 데이터 배열에 4개의 항목이 포함되었습니다: 'session_id', 'ip_address', 'user_agent', 'last_activity'.

이 항목들은 세션의 작동 방식에 대한 세부 사항을 위한 것이지만 이제는 새로운 구현에 더 이상 필요하지 않습니다.
그러나 어플리케이션이 이러한 값에 의존한다면, 다음과 같은 방법으로 액세스할 수 있습니다.

  - session_id: ``$session->session_id`` 또는 ``session_id()`` (PHP 내장 함수)
  - ip_address: ``$_SERVER['REMOTE_ADDR']``
  - user_agent: ``$_SERVER['HTTP_USER_AGENT']`` (unused by sessions)
  - last_activity: Depends on the storage, no straightforward way. Sorry!

세션 환경 설정
***********************

CodeIgniter는 일반적으로 모든 것을 즉시 사용할 수 있도록 합니다.
그러나 세션은 모든 응용 프로그램에서 매우 민감한 구성 요소이므로 신중하게 구성해야합니다. 
시간을내어 모든 옵션과 그 효과를 고려하십시오.

**app/Config/App.php** 파일에서 다음 세션 관련 환경 설정을 찾을 수 있습니다.

============================== ============================================ ================================================ ============================================================================================
Preference                     Default                                      Options                                          Description
============================== ============================================ ================================================ ============================================================================================
**sessionDriver**              CodeIgniter\\Session\\Handlers\\FileHandler  CodeIgniter\\Session\\Handlers\\FileHandler      사용할 세션 스토리지 드라이버
                                                                            CodeIgniter\\Session\\Handlers\\DatabaseHandler
                                                                            CodeIgniter\\Session\\Handlers\\MemcachedHandler
                                                                            CodeIgniter\\Session\\Handlers\\RedisHandler
                                                                            CodeIgniter\\Session\\Handlers\\ArrayHandler
**sessionCookieName**          ci_session                                   [A-Za-z\_-] characters only                      세션 쿠키에 사용되는 이름
**sessionExpiration**          7200 (2 hours)                               Time in seconds (integer)                        세션이 지속되기를 원하는 시간 (초), 
                                                                                                                             만료되지 않는 세션을 원할 경우 (브라우저가 닫힐 때까지) 값을 0으로 설정하십시오.
**sessionSavePath**            null                                         None                                             사용중인 드라이버에 따라 저장 위치를 지정
**sessionMatchIP**             false                                        true/false (boolean)                             세션 쿠키를 읽을 때 사용자의 IP 주소를 확인할지 여부,
                                                                                                                             일부 ISP는 동적으로 IP를 변경하므로 만료되지 않는 세션을 원할 경우 false로 설정합십시오.
**sessionTimeToUpdate**        300                                          Time in seconds (integer)                        이 옵션은 세션 클래스가 자신을 재생성하고 새 세션 ID를 작성하는 빈도를 제어합니다. 
                                                                                                                             0 으로 설정하면 세션 ID 재생성이 비활성화됩니다.
**sessionRegenerateDestroy**   false                                        true/false (boolean)                             세션 ID를 자동 재생성 할 때 이전 세션 ID와 연관된 세션 데이터를 삭제할지 여부,
                                                                                                                             false로 설정하면 나중에 가비지 콜렉터가 데이터를 삭제합니다.
============================== ============================================ ================================================ ============================================================================================

.. note:: 세션 라이브러리는 PHP의 세션 관련 INI 설정과 위의 항목 중 하나라도 구성되지 않은 경우, 최후의 수단으로 'sess_expire_on_close'\ 와 같은 레거시 CI 설정을 가져 오려고 시도합니다.
	그러나 예기치 않은 결과가 발생하거나 나중에 변경될 수 있으므로 이 방법에 의존해서는 안됩니다. 모든 것을 올바르게 구성하십시오.

.. note:: ``sessionExpiration``\ 을 ``0``\ 으로 설정하면 PHP가 설정한 세션 관리의 ``session.gc_maxlifetime`` 설정 값 그대로(기본값 ``1440``) 사용됩니다.
	이 값은 필요에 따라 ``php.ini`` 또는 ``ini_set()``\ 을 통해 변경 가능 합니다.

위의 값 외에도 쿠키 및 기본 드라이버는 :doc:`IncomingRequest </incoming/incomingrequest>`\ 와 :doc:`Security <security>` 클래스에서 공유하는 다음 구성 값을 적용합니다.

==================== =============== ===========================================================================
Preference           Default         Description
==================== =============== ===========================================================================
**cookieDomain**     ''              세션 적용 도메인
**cookiePath**       /               세션 적용 가능 경로
**cookieSecure**     false           암호화된 (HTTPS) 연결에서만 세션 쿠키를 작성할 지 여부
**cookieSameSite**   Lax             세션 쿠키에 대한 SameSite 설정
==================== =============== ===========================================================================

.. note::'cookieHTTPOnly' 설정은 세션에 영향을 미치지 않습니다.
	대신 보안상의 이유로 HttpOnly 매개 변수가 항상 사용되며, ``Config\Cookie::$prefix`` 설정은 완전히 무시됩니다.

세션 드라이버
**************

이미 언급했듯이 세션 라이브러리는 다음 4가지개의 사용할 수 있는 핸들러 또는 스토리지 엔진을 제공합니다.

  - CodeIgniter\\Session\\Handlers\\FileHandler
  - CodeIgniter\\Session\\Handlers\\DatabaseHandler
  - CodeIgniter\\Session\\Handlers\\MemcachedHandler
  - CodeIgniter\\Session\\Handlers\\RedisHandler
  - CodeIgniter\\Session\\Handlers\\ArrayHandler

``FileHandler`` 드라이버는 가장 안전한 선택이며, 모든 곳에서 작동할 것으로 예상되기 때문에 세션이 초기화 될 때 기본적으로 사용됩니다. (모든 환경에는 파일 시스템이 있습니다)

그러나 다른 드라이버는 **app/Config/App.php** 파일의 ``public $sessionDriver``\ 을 통해 선택할 수 있습니다. (원하는 경우)
모든 드라이버는 각기 다른 주의 사항이 있으며, 이를 염두에 두어야합니다. 
따라서 선택하기 전에 반드시 아래 부분을 잘 읽어보십시오.

.. note:: ArrayHandler는 테스트할 때 사용되며, PHP배열에 모든 세션 데이터를 저장하여 데이터가 테스트 이후 유지되는 것을 방지합니다.

FileHandler 드라이버 (기본)
=============================================

'FileHandler' 드라이버는 파일 시스템을 사용하여 세션 데이터를 저장합니다.

PHP의 기본 세션 구현과 똑같이 작동고 안전하다고 말할 수 있지만, 이것이 중요한 세부사항의 경우 기본 세션과 동일한 코드가 아니며 몇 가지 제한 사항과 장점이 있습니다.

좀 더 구체적으로 말하면 session.save_path <https://www.php.net/manual/en/session.configuration.php#ini.session.save-path>_\ 에서 사용되는 PHP의 디렉토리 레벨 및 모드 형식을 지원하지 않습니다. 
안전을 위해 대부분의 옵션이 하드 코딩되어 있으며, ``public $sessionSavePath``\ 는 절대 경로만 지원됩니다.

알아야 할 또 다른 중요한 사항은 공개적으로 읽거나 공유 디렉토리를 사용하여 세션 파일을 저장하지 않도록 하는 것입니다.
선택한 *sessionSavePath* 디렉토리의 내용을 볼 수있는 권한이 *당신에게만* 있는지 확인하십시오.
그렇지 않으면 이를 수행할 수 있는 모든 사람이 현재 세션 ("sessiion fixation" 공격이라고도 함)을 도용할 수 있습니다.

유닉스 계열 운영 체제에서, 이것은 일반적으로 `chmod` 명령을 통해 해당 디렉토리에 대한 0700 모드 권한을 설정함으로써 달성되며, 디렉토리 소유자만 디렉토리에 대한 읽기 및 쓰기 작업을 수행할 수 있습니다.
그러나 스크립트를 실행하는 시스템 사용자는 일반적으로 사용자 자신이 아니라 'www-data'\ 와 같은 것이기 때문에 이러한 권한을 설정하면 어플리케이션이 동작하지 않을수 있으므로 주의하십시오.

환경에 따라 아래와 같은 작업을 수행합니다.

::

	mkdir /<path to your application directory>/Writable/sessions/
	chmod 0700 /<path to your application directory>/Writable/sessions/
	chown www-data /<path to your application directory>/Writable/sessions/

보너스 팁
-------------------

파일 저장 공간이 일반적으로 느리기 때문에 여러분중 일부는 다른 세션 드라이버를 선택하게 될 것입니다. 하지만 이것은 반만 맞습니다.

매우 기본적인 테스트는 아마도 SQL 데이터베이스가 더 빠르다고 생각하도록 속이는 것입니다. 
그러나 99%의 경우 현재 세션이 거의 없는 동안에만 해당됩니다.
세션 수가 많아지고, 서버로드가 증가할수록 (시간이 중요 함) 파일 시스템은 거의 모든 관계형 데이터베이스보다 지속적으로 성능이 뛰어납니다.

또한 성능이 유일한 관심사라면 파일 세션을 `tmpfs <http://eddmann.com/posts/storing-php-sessions-file-caches-in-memory-using-tmpfs/>`_ 에 저장하는 방법도 있습니다. (경고 : 외부 리소스)


DatabaseHandler 드라이버
=============================

'DatabaseHandler' 드라이버는 MySQL 또는 PostgreSQL과 같은 관계형 데이터베이스를 사용하여 세션을 저장합니다. 
이는 개발자가 어플리케이션내에서 세션 데이터에 쉽게 액세스할 수 있기 때문에 많은 사용자에게 인기있는 선택입니다. 
이는 데이터베이스의 다른 테이블 일뿐입니다.

그러나 몇 가지 조건을 충족해야합니다.

	- 영구 연결(persistent connection)을 사용할 수 없습니다.

'DatabaseHandler' 세션 드라이버를 사용하려면 세션 테이블을 만든 다음 이를 ``$sessionSavePath``\ 의 값으로 설정해야 합니다.
예를 들어 테이블 이름으로 'ci_sessions'을 사용하려면 다음과 같이합니다.

.. literalinclude:: sessions/039.php

물론 데이터베이스 테이블을 생성하십시오 ...

MySQL

::

	CREATE TABLE IF NOT EXISTS `ci_sessions` (
		`id` varchar(128) NOT null,
		`ip_address` varchar(45) NOT null,
		`timestamp` timestamp DEFAULT CURRENT_TIMESTAMP NOT null,
		`data` blob NOT null,
		KEY `ci_sessions_timestamp` (`timestamp`)
	);

PostgreSQL

::

	CREATE TABLE "ci_sessions" (
		"id" varchar(128) NOT null,
		"ip_address" inet NOT null,
		"timestamp" timestamptz DEFAULT CURRENT_TIMESTAMP NOT null,
		"data" bytea DEFAULT '' NOT null
	);

	CREATE INDEX "ci_sessions_timestamp" ON "ci_sessions" ("timestamp");

또한 **'sessionMatchIP' 설정에 따라 기본 키를 추가**\ 해야 합니다. 
아래 예제는 MySQL과 PostgreSQL 모두에서 작동합니다.

::

	// When sessionMatchIP = true
	ALTER TABLE ci_sessions ADD PRIMARY KEY (id, ip_address);

	// When sessionMatchIP = false
	ALTER TABLE ci_sessions ADD PRIMARY KEY (id);

	// To drop a previously created primary key (use when changing the setting)
	ALTER TABLE ci_sessions DROP PRIMARY KEY;

사용할 데이터베이스 그룹 이름을 **application\Config\App.php** 파일의 ``$sessionDBGroup``\ 에 지정할 수 있습니다.

.. literalinclude:: sessions/040.php

직접 이 작업을 모두 수행하지 않으려면 cli에서 ``make:migration --session`` 명령을 사용하여 마이그레이션 파일을 생성하십시오.

::

  > php spark make:migration --session
  > php spark migrate

이 명령은 코드를 생성할 때 **sessionSavePath**\ 와 **sessionMatchIP** 설정을 고려합니다.

.. important:: 다른 데이터베이스 플랫폼은 잠금 메커니즘에 접근할 수 없기 때문에 MySQL 및 PostgreSQL 데이터베이스만 공식적으로 지원됩니다.
	특히 AJAX를 많이 사용하는 경우 잠금없이 세션을 사용할 경우 문제가 발생할 수 있으므로, 잠금을 지원하지 않는 경우는 지원하지 않습니다.
	성능 문제가 발생한다면 세션 데이터 처리를 완료한 후 ``session_write_close()``\ 를 사용하십시오.

RedisHandler 드라이버
============================

.. note:: Redis의 잠금 메커니즘에 직접 접근할 수 없으므로 ,이 드라이버의 잠금은 최대 300초 동안 유지되는 별도의 값으로 에뮬레이션됩니다.

Redis는 고성능으로 인해 캐싱에 일반적으로 사용되는 스토리지 엔진으로 'RedisHandler' 세션 드라이버를 사용하는 가장 큰 이유입니다.

단점은 관계형 데이터베이스만큼 편재적이지 않으며 시스템에 `phpredis <https://github.com/phpredis/phpredis>`_ PHP 확장이 설치되어 있어야 하며, PHP 번들로 제공되지 않는다는 것입니다.
이미 Redis에 익숙하고 다른 목적으로 사용하는 경우 RedisHandler 드라이버를 사용하고 있을 가능성이 있습니다.

'FileHandler'\ 와 'DatabaseHandler' 드라이버와 마찬가지로 ``$sessionSavePath`` 설정을 통해 세션의 저장 위치를 ​​구성합니다.
'RedisHandler' 형식(format)은 약간 다르며 복잡합니다.
*phpredis* 확장의 README 파일에 잘 설명되므로 링크해 드립니다.

	https://github.com/phpredis/phpredis#php-session-handler

.. warning:: CodeIgniter의 세션 라이브러리는 실제 'redis'\ 의 ``session.save_handler``\ 를 사용하지 않습니다.
	위 링크에서 **오직** 경로 형식(path format)만 참고하십시오.

그러나 대부분의 경우, 간단한 ``host:port``\ 쌍만 있어도 충분합니다

.. literalinclude:: sessions/041.php

MemcachedHandler 드라이버
=================================

.. note:: Memcached의 잠금 메커니즘에 직접 접근할 수 없으므로, 이 드라이버의 잠금은 최대 300초 동안 유지되는 별도의 값으로 에뮬레이션됩니다.

'MemcachedHandler' 드라이버는 PHP의 `Memcached <https://www.php.net/memcached>`_ 확장이 PECL과 일부 Linux를 통해 배포되기 때문에 가용성을 제외하고 모든면에서 'RedisHandler' 드라이버와 매우 유사합니다. 
배포판은 설치하기 쉬운 패키지로 제공됩니다.

그 외에도 Redis에 대한 의도적인 편견이 없다면 Memcached에 대해 언급할 점이 별로 다르지 않습니다. 
일반적으로 캐싱에 사용되며 속도로 유명한 인기있는 제품이기도 합니다.

그러나 Memcached가 제공하는 유일한 보증은 Y초 후에 값 X가 만료되도록 설정하면 Y초가 지난후에 삭제된다는 것입니다 (그러나 반드시 그 시간보다 빨리 만료되지는 않습니다).
이것은 매우 드물게 발생하지만 세션이 손실될 수 있으므로 고려해야 합니다.

``$sessionSavePath`` 형식(format)은 ``host:port`` 쌍으로 매우 간단합니다.

.. literalinclude:: sessions/042.php

보너스 팁
--------------

콜론으로 구분된 세 번째 (``: weight``) 값으로 옵션 *weight* 매개 변수를 사용하는 다중 서버 구성도 지원되지만, 신뢰할 수 있는지 테스트하지 않았다는 점에 유의해야 합니다.

(여러 위험을 감수하고) 이 기능을 직접 시험해보고 싶다면 서버의 여러 경로를 쉼표(,)로 구분하여 작성합니다.

.. literalinclude:: sessions/043.php
