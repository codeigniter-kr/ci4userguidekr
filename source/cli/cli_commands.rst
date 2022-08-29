#################################
사용자 정의 CLI 명령(command)
#################################

다른 경로처럼 CLI 명령을 사용하는 것이 편리하지만 조금 다른 것이 필요할 수도 있습니다.
이때 CLI 명령이 제공됩니다.
이 클래스는 경로를 정의할 필요가 없는 간단한 클래스로, 마이그레이션 또는 데이터베이스 시드 처리, cronjob 상태 확인 또는 회사에서 사용할 맞춤형 코드 생성기 등 개발자가 작업을 단순화하는 데 사용할 도구를 구축할 수 있습니다.

.. contents::
    :local:
    :depth: 2

*********************
새로운 명령 만들기
*********************

개발에 사용할 새 명령을 매우 쉽게 작성할 수 있습니다.
각 명령에 대한 클래스 파일이 있어야 하며 ``CodeIgniter\CLI\BaseCommand``\ 를 확장하고 ``run()`` 메소드를 구현해야 합니다.

CLI 명령에 나열되고 명령 도움말 기능을 추가하려면 다음 특성을 사용합니다.

* ``$group`` : 명령을 나열 할 때 명령이 집중된 그룹을 설명하는 문자열, ex> ``Database``
* ``$name`` : 명령 이름을 나타내는 문자열, ex> ``migrate : create``
* ``$description`` : 명령을 설명하는 문자열, ex> ``새 마이그레이션 파일을 만듭니다.``
* ``$usage`` : 명령 사용법을 설명하는 문자열, ex> ``migrate : create [migration_name] [Options]``
* ``$arguments`` : 각 명령 인수를 설명하는 문자열 배열, ex> ``'migration_name'=> '마이그레이션 파일 이름'``
* ``$options`` : 각 명령 옵션을 설명하는 문자열 배열, ex> ``'-n'=> '마이그레이션 네임스페이스 설정'``

** 도움말 설명은 위의 매개 변수에 따라 자동으로 생성됩니다. **

파일 위치
=============

명령은 **Commands** 디렉토리에 저장해야 합니다.
그러나 해당 디렉토리는 :doc:`오토로더 </concepts/autoloader>`\ 가 있는 위치에 있을 수 있으며,
**app/Comms** 또는 **Acme/andss**\ 와 같이 특정 프로젝트 개발에 사용 가능하도록 명령을 보관하는 디렉토리에 있을 수 있습니다.

.. note:: 명령이 실행될 때 전체 CodeIgniter cli 환경이 로드되어 환경 정보, 경로 정보를 가져오며 Controller 작성시 사용할 도구를 사용할 수 있습니다.

예제 명령
==================

데모 목적으로 어플리케이션 자체에 대한 기본 정보를 보고하는 예제 명령을 살펴 보겠습니다.
**app/Commands/AppInfo.php**\ 에 다음 코드를 작성하여 새 파일을 생성하십시오.

.. literalinclude:: cli_commands/002.php

**list** 명령을 실행하면 새 명령이 ``demo`` 그룹 아래에 표시됩니다.
이를 살펴보면 이 명령이 어떻게 작동하는지 알 수 있을 것입니다.
``$group`` 속성은 단순히 존재하는 다른 모든 명령으로 이 명령을 구성하는 방법을 알려주며, 그 아래에 나열할 제목을 알려줍니다.

``$name`` 속성은 이 명령을 호출할 수 있는 이름입니다.
유일한 요구 사항은 공백을 포함하지 않아야하며 모든 문자는 커맨드 라인 자체에서 유효해야합니다.
그러나 일반적으로 명령은 소문자이며 명령 이름 자체와 함께 콜론을 사용하여 명령 그룹을 추가로 그룹화합니다.
그룹화는 여러 명령의 이름 충돌을 방지하는데 도움이됩니다.

최종 속성 ``$description``\ 은 **list** 명령에 표시되는 짧은 문자열이며 명령의 기능을 설명해야합니다.

run()
-----

``run()`` 메소드는 명령이 실행될 때 호출되는 메소드입니다. 
``$params`` 배열은 사용할 명령 이름 뒤의 CLI 인수의 목록입니다. 
CLI 문자열이 아래와 같다면

::

    > php spark foo bar baz

**foo**\ 는 명령이고 ``$params`` 배열은

.. literalinclude:: cli_commands/003.php

이것도 :doc:`CLI </cli/cli_library>` 라이브러리를 통해 액세스할 수 있지만 문자열에서 이미 명령이 제거되었습니다.
이 매개 변수는 스크립트 동작 방식을 사용자 정의할 때 사용할 수 있습니다.

데모 명령의 ``run()`` 메소드는 다음과 같습니다.

.. literalinclude:: cli_commands/004.php

:doc:`CLI Library </cli/cli_library>` 페이지에서 더 자세한 정보를 확인하세요.

***********
기본 명령
***********

모든 명령이 확장해야 하는 ``BaseCommand`` 클래스에는 고유한 명령을 작성할 때 유용한 유틸리티 메소드가 있습니다.
또한 **$this->logger**\ 를 통해 사용 가능한 :doc:`Logger </general/logging>`\ 도 있습니다.

.. php:namespace:: CodeIgniter\CLI

.. php:class:: BaseCommand

    .. php:method:: call(string $command[, array $params = []])

        :param string $command: 호출 할 다른 명령의 이름
        :param array $params: 해당 명령에 사용 가능한 추가 CLI 인수

        이 메소드를 사용하면 현재 명령을 실행하는 동안 다른 명령을 실행할 수 있습니다
        
        .. literalinclude:: cli_commands/005.php

    .. php:method:: showError(Throwable $e)

        :param Throwable $e: 오류보고에 사용할 예외

        CLI에 일관성 있고 명확한 오류 출력을 유지하는 편리한 메소드
        
        .. literalinclude:: cli_commands/006.php

    .. php:method:: showHelp()

        명령 도움말을 표시하는 메소드: (usage,arguments,description,options)

    .. php:method:: getPad($array, $pad)

        :param array    $array: $key => $value 배열
        :param integer  $pad: pad spaces.


        $key => $value 배열 출력에 대한 패딩을 계산하는 메소드.
        패딩은 CLI에서 테이블을 출력할 때 사용할 수 있습니다
        
        .. literalinclude:: cli_commands/007.php
