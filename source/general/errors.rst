##############
오류 처리
##############

CodeIgniter는 프레임워크에서 제공하는 몇 가지 사용자 정의 예외뿐만 아니라 `SPL collection <https://php.net/manual/en/spl.exceptions.php>`_\ 과 예외(exception)를 통해 시스템에 오류 보고를 빌드합니다.
어플리케이션이 ``production`` 환경에서 실행되고 있지 않다면, 환경 설정에 따라 오류 또는 예외가 발생하면 자세한 오류 보고서를 표시합니다.
이 경우 사용자에게 최상의 사용자 환경을 유지하기 위해 보다 일반적인 메시지가 표시됩니다.

.. contents::
    :local:
    :depth: 2

예외 사용
================

이 섹션은 새로운 프로그래머 또는 예외 사용 경험이 없는 개발자를 위한 것입니다.

예외(exception)는 단순히 예외가 "발생(thrown)"\ 할 때 발생하는 이벤트입니다.
아래와 같이하면 스크립트의 현재 흐름은 중단되고, 해당 오류 페이지를 표시하는 오류 처리기로 실행이 전송됩니다.

.. literalinclude:: errors/001.php

예외를 던질 수 있는 메소드를 호출하는 경우 ``try/catch`` 블록을 사용하여 해당 예외를 포착할 수 있습니다.

.. literalinclude:: errors/002.php

``$userModel``\ 에서 예외가 발생하면 예외가 포착되고 catch 블록 내의 코드가 실행됩니다.
이 예제에서 스크립트는 실행을 중단하고 ``UserModel``\ 이 정의한 오류 메시지를 반영합니다.

이 예는 모든 유형(Exception)의 예외를 포착(catch)합니다.
``UnknownFileException``\ 과 같은 특정 유형의 예외만 감시하려는 경우 catch 매개 변수에서 예외를 지정할 수 있습니다.
발생된 예외의 하위 클래스가 아닌 다른 예외는 오류 처리기로 전달됩니다.

.. literalinclude:: errors/003.php

이는 오류를 직접 처리하거나 스크립트가 끝나기 전에 필요한 뭔가를 정리하는데 유용할 수 있습니다.

.. literalinclude:: errors/004.php

구성
=============

기본적으로 CodeIgniter는 ``development`` 및 ``testing`` 환경에서는 모든 오류를 표시하고 ``production`` 환경에서는 오류를 표시하지 않습니다.
이 값을 변경하려면 ``.env`` 파일의 ``CI_ENVIRONMENT`` 상수에 값을 설정하면 됩니다.

.. important:: 오류 보고를 비활성화해도 오류가 있는 경우 로그 쓰기가 중지되지 않습니다.

로깅 예외
------------------

기본적으로 404 - Page Not Found 예외 이외의 모든 예외가 기록됩니다.
``Config\Exceptions``\ 의 **$log** 값을 설정하여 켜거나 끌 수 있습니다.

.. literalinclude:: errors/005.php

다른 상태 코드에 대한 로깅을 무시하려면 동일한 파일에서 상태 코드를 무시하도록 설정할 수 있습니다.

.. literalinclude:: errors/006.php

.. note:: 현재 로그 설정이 모든 예외가 기록되는 **critical**\ 로 설정되지 않은 경우에도 예외에 대해 로깅이 발생하지 않을 수 있습니다.

사용자 정의 예외
==================

다음과 같은 사용자 정의 예외를 사용할 수 있습니다.

PageNotFoundException
---------------------

404, Page Not Found 오류를 알리는 데 사용됩니다.
예외가 발생하면 시스템은 ``app/views/errors/html/error_404.php``\ 에 있는 뷰를 보여줍니다.
``app/Config/Routes.php``\ 에서 404 오류를 재정의하여 지정하면 표준 404 페이지 대신 호출됩니다.

.. literalinclude:: errors/007.php

404 페이지의 기본 메시지 대신 표시될 예외로 메시지를 전달할 수 있습니다.

ConfigException
---------------

이 예외는 구성 클래스의 값이 유효하지 않거나, 구성 클래스가 올바른 유형이 아닌 경우에 사용해야 합니다.

.. literalinclude:: errors/008.php

HTTP 상태 코드는 500이고 종료 코드는 3입니다.

DatabaseException
-----------------

이 예외는 데이터베이스 연결을 작성할 수 없거나 일시적으로 유실 된 경우와 같은 데이터베이스 오류에 대해 발생합니다.

.. literalinclude:: errors/009.php

HTTP 상태 코드는 500이고 종료 코드는 8입니다.

RedirectException
-----------------

This exception is a special case allowing for overriding of all other response routing and forcing a redirect to a specific route or URL.
이 예외는 다른 모든 응답 라우팅을 재정의하고 특정 경로 또는 URL로 리디렉션을 강제 적용할 수 있는 특수한 경우입니다.

.. literalinclude:: errors/010.php

``$route``\ 는 이름이 지정된 경로, 상대 URI 또는 전체 URL일 수 있습니다. 기본값("302", "임시 리디렉션") 대신 사용할 리디렉션 코드를 제공할 수도 있습니다.

.. literalinclude:: errors/011.php
