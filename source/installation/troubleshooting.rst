###############
문제 해결
###############

다음은 일반적인 설치 문제와 제안된 해결 방법입니다.

.. contents::
    :local:
    :depth: 2

설치후 작동하는지 어떻게 알 수 있습니까?
-------------------------------------------

프로젝트 루트에서 명령 행 실행

::

    > php spark serve

브라우저의 ``http://localhost:8080``\ 을 입력하였을 때 Codeigniter4 시작 페이지를 표시해야 합니다.

|CodeIgniter4 Welcome|

URL에 index.php를 포함시켜야 동작합니다
-----------------------------------------

``/mypage/find/apple``\ 과 같은 URL은 작동하지 않지만 유사한 URL ``/index.php/mypage/find/apple``\ 은 작동한다면 (Apache의 경우) ``.htaccess`` 
규칙이 제대로 설정되지 않았거나, Apache의 ``httpd.conf``\ 에 ``mod_rewrite`` 확장이 주석 처리되었을 수 있습니다.

기본 페이지만 로드됨
---------------------------

URL에 입력 한 내용에 관계없이 기본 페이지만 로드되는 경우 서버가 검색 엔진 친화적인 URL을 제공하는데 필요한 REQUEST_URI 변수를 지원하지 않을 수 있습니다.
첫 번째 단계로 **app/Config/App.php** 파일을 열고 URI 프로토콜 정보를 찾으십시오.
몇 가지 대체 설정을 시도하는 것이 좋습니다. 
시도한 후에도 여전히 작동하지 않으면 CodeIgniter가 URL에 물음표(?)를 추가하도록 해야 합니다.
이렇게 하려면 **app/Config/App.php** 파일을 열고 아래 항목을 변경하십시오

이전 

.. literalinclude:: troubleshooting/001.php

이후

.. literalinclude:: troubleshooting/002.php

이 자습서는 모든 곳에서 404 오류를 제공합니다. :(
---------------------------------------------------

PHP의 내장 웹 서버를 사용하여 튜토리얼을 따라 할 수 없습니다.
PHP의 내장 웹 서버는 요청(request)을 올바르게 라우팅하는데 필요한 `.htaccess` 파일을 처리하지 않기 때문입니다.

해결책 : Apache를 사용하여 사이트를 작성하거나 내장된 CodeIgniter의 ``php spark serve`` 명령을 프로젝트 루트에서 실행하십시오.

.. |CodeIgniter4 Welcome| image:: ../images/welcome.png

도움이되지 않는 "Whoops!" 페이지는 무엇인가요?
----------------------------------------------

앱에서 "Whoops!"페이지가 표시되는 것을 발견했습니다. 그런 다음 "We seem to have hit a snag. Please try again later..."라는 텍스트 줄이 나타납니다.

이는 보안 모드를 향상시키기 위해 프로덕션 모드에 있으며 복구할 수 없는 오류에 도달했다는 표시입니다.

로그 파일에서 오류를 볼 수 있습니다. 아래의 `CodeIgniter 오류 로그`_\ 를 참조하세요.

개발 중에 이 페이지를 보지 않으려면 **.env**\ 의 환경(environment)을 "development"로 변경해야 합니다. 자세한 내용은 :ref:`setting-development-mode`\ 를 참조하세요.
그런 다음 페이지를 새로고침합니다. 오류와 역 추적(back trace)이 표시됩니다.

CodeIgniter 오류 로그
-------------------------------------------------------

CodeIgniter는 `app/Config/Logger.php`\ 의 설정에 따라 오류 메시지를 기록합니다.

오류 임계 값을 조정하여 더 많거나 적은 메시지를 볼 수 있습니다.

기본 설정에는 로그 파일이 'writable/logs'\ 로 저정되어 있습니다.
오류가 발생한다면 이 파일을 확인하는 것이 좋습니다.