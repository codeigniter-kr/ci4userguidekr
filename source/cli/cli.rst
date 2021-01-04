############################
커맨드 라인을 통한 실행
############################

브라우저의 URL을 통해 어플리케이션의 :doc:`컨트롤러 </incoming/controllers>`\ 를 호출할 뿐만 아니라 CLI (커맨드 라인 인터페이스)를 통해 로드할 수 있습니다.

.. contents::
    :local:
    :depth: 2

CLI란 무엇입니까?
======================

커맨드 라인 인터페이스는 컴퓨터와 상호 작용하는 텍스트 기반 방법입니다.
자세한 내용은 `Wikipedia article <https://en.wikipedia.org/wiki/Command-line_interface>`_\ 을 확인하십시오.

왜? 커맨드 라인을 통해 실행됩니까?
========================================

커맨드 라인에서 CodeIgniter를 실행하는 데는 여러 가지 이유가 있지만, 항상 명확한 것은 아닙니다.

- *wget* 또는 *curl*\ 을 사용할 필요없이 크론(cron) 작업을 실행합니다.
- :php:func:`is_cli()`\ 의 반환 값을 확인하여 크론 작업을 URL에 로드할 수 없도록합니다.
- 권한 설정, 캐시 폴더 정리, 백업 실행등과 같은 작업을 수행할 수 있는 대화형 "작업"을 만듭니다.
- 다른 언어로 된 어플리케이션과 통합됩니다. 예를 들어, 임의의 C++ 스크립트가 모델에서 하나의 명령을 호출하고 코드를 실행할 수 있습니다!

해봅시다! : Hello World!
============================

간단한 컨트롤러를 만들어 실제로 볼 수 있도록 하겠습니다.
텍스트 편집기를 사용하여 Tools.php라는 파일을 만들고 다음 코드를 넣습니다.

::

    <?php 
    
    namespace App\Controllers;

    use CodeIgniter\Controller;

    class Tools extends Controller
    {
        public function message($to = 'World')
        {
            echo "Hello {$to}!" . PHP_EOL;
        }
    }

그런 다음 파일을 **app/Controllers/** 디렉토리에 저장합니다.

보통 이 코드는 아래와 비슷한 URL을 사용하여 사이트를 방문합니다.

::

    example.com/index.php/tools/message/to

대신, Mac/Linux에서 터미널을 열거나 Windows에서 실행>"cmd"로 이동하여 CodeIgniter 프로젝트의 웹 루트로 이동합니다.

.. code-block:: bash

    $ cd /path/to/project/public
    $ php index.php tools message

제대로했다면 *Hello World!*\ 가 인쇄됩니다.

.. code-block:: bash

    $ php index.php tools message "John Smith"

여기서는 URL 매개 변수가 작동하는 것과 동일한 방식으로 인수를 전달합니다.
"John Smith"가 인수로 전달되고 출력은

::

    Hello John Smith!

이것이 기본입니다!
======================

간단히 말해, 이것이 커맨드 라인에서 컨트롤러에 대해 알아야할 모든 것입니다.
커맨드 라인도 일반적인 컨트롤러이므로 라우팅 및 ``_remap()``\ 도 잘 작동합니다.

CodeIgniter는 CLI 전용 스크립트 작성, CLI 전용 도구,  CLI 전용 도구를 지원하는 라이브러리를 포함하여 CLI 액세스 가능한 스크립트 작성을 더욱 즐겁게하기 위한 추가 도구를 제공합니다.

CLI 전용 라우팅
---------------------

**Routes.php** 파일에서 다른 경로를 만드는 것처럼 CLI에서만 쉽게 액세스할 수있는 경로를 만들 수 있습니다.
``get()``, ``post()``\ 와 유사한 메소드를 사용하는 대신 ``cli()`` 메소드를 사용합니다.
다른 모든 것은 일반 경로 정의와 똑같이 작동합니다

::

    $routes->cli('tools/message/(:segment)', 'Tools::message/$1');

자세한 내용은 :doc:`라우트 </incoming/routing>` 페이지를 참조하십시오.

CLI 라이브러리
-------------------

CLI 라이브러리를 사용하면 CLI 인터페이스 작업이 간단해지며, 터미널 창에 여러 색상으로 텍스트를 출력하는 쉬운 방법을 제공합니다.
또한 사용자에게 정보를 묻는 메시지를 표시하여 유연하고 스마트한 도구를 쉽게 만들 수 있습니다.

자세한 내용은 :doc:`CLI 라이브러리 </cli/cli_library>` 페이지를 참조하십시오.