###########################
CLI를 통해 컨트롤러 실행
###########################

애플리케이션의 :doc:`Controllers </incoming/controllers>`\ 는 브라우저의 URL을 통해 호출할 수 있으며, 명령줄 인터페이스(CLI)를 통해 로드할 수도 있습니다.

.. contents::
    :local:
    :depth: 2

**************************
Let's try it: Hello World!
**************************

컨트롤러 생성
===================

작동하는 모습을 볼 수 있도록 간단한 컨트롤러를 만들어 보겠습니다. 텍스트 편집기를 사용하여 Tools.php라는 파일을 만들고 다음 코드를 그 안에 넣습니다.

.. literalinclude:: cli_controllers/001.php

.. note:: :ref:`auto-routing-improved`\ 를 사용한다면 메소드 이름을 ``cliMessage()``\ 로 변경하십시오.

파일을 **app/Controllers/** 디렉터리에 저장합니다.

경로 정의
==============

자동 라우팅(Auto Routing)을 사용하는 경우 이 단계를 건너뜁니다.

**app/Config/Routes.php** 파일에 ``cli()`` 메소드를 사용하여 CLI에서만 액세스할 수 있는 경로(route)를 생성할 수 있습니다. 
그 외 다른 것은 일반 경로 정의와 동일하게 작동합니다.

.. literalinclude:: cli_controllers/002.php

자세한 내용은 :ref:`경로 <command-line-only-routes>` 페이지를 참조하세요.

.. warning:: :ref:`auto-routing`\ 을 활성화하고 명령(command) 파일을 **app/Controllers**\ 에 배치하면 HTTP를 통하여 누구나 명령에 액세스할 수 있습니다.

CLI를 통해 실행
===============

일반적으로 다음과 유사한 URL을 사용하여 사이트를 방문합니다.

::

    example.com/index.php/tools/message/to

이를 대신하여 Mac/Linux(Windows : 실행 > "cmd")의 터미널로 이동하여 CodeIgniter 프로젝트의 웹 루트로 이동합니다.

.. code-block:: bash

    $ cd /path/to/project/public
    $ php index.php tools message

제대로 했다면 "Hello World!"가 표시됩니다.

.. code-block:: bash

    $ php index.php tools message "John Smith"

위 예는 URL 매개변수가 작동하는 것과 같은 방식으로 인수를 전달합니다.
인수로 "John Smith"가 전달되고 출력은 다음과 같습니다.

::

    Hello John Smith!

******************
That's the Basics!
******************

명령줄 컨트롤러에 대해 알아야 할 사항은 이것뿐입니다.
명령줄도 일반 컨트롤러이므로 라우팅과 ``_remap()``\ 이 잘 작동한다는 것을 기억하십시오.

.. note:: ``_remap()``\ 은 :ref:`auto-routing-improved`\ 와 함께 작동하지 않습니다.

CLI를 통해 실행되고 있는지 확인하려면 :php:func:`is_cli()`\ 의 반환 값을 확인하세요.

CodeIgniter는 CLI 전용 라우팅와 CLI 전용 도구를 지원하는 라이브러리를 포함하여 CLI 액세스 가능한 스크립트를 훨씬 더 즐겁게 만들 수 있는 추가 도구를 제공합니다.
