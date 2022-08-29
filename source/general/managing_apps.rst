##########################
어플리케이션 관리
##########################

기본적으로 CodeIgniter를 사용하여 하나의 어플리케이션만 관리한다면 **app** 디렉토리에 빌드됩니다.
그러나 단일 CodeIgniter를 공유하는 여러 어플리케이션 세트를 보유하거나, 어플리케이션 디렉토리의 이름을 바꾸거나 재배치할 수도 있습니다.

.. important:: CodeIgniter v4.1.9 또는 이전 버전을 설치했다면 ``/composer.json``\ 파일의 ``autoload.psr-4``\ 에 ``App\\``\ 과 ``Config\\`` 네임스페이스가 있는 경우 다음과 같이 이 줄을 제거하고 ``composer dump-autoload``\ 를 실행해야 합니다.

    .. code-block:: text

        {
            ...
            "autoload": {
                "psr-4": {
                    "App\\": "app",             <-- Remove this line
                    "Config\\": "app/Config"    <-- Remove this line
                }
            },
            ...
        }

.. contents::
    :local:
    :depth: 2

.. _renaming-app-directory:

어플리케이션 디렉토리 이름 바꾸기 또는 재배치
================================================

어플리케이션 디렉토리의 이름을 바꾸거나 프로젝트 루트를 서버의 다른 위치로 옮기려면 **app/Config/Paths.php** 
파일의 ``$appDirectory`` 변수에 *전체 서버 경로*\ 를 설정하십시오.(44번째 행)

.. literalinclude:: managing_apps/001.php

**Paths** 구성 파일을 찾을 수 있도록 프로젝트 루트의 두 개의 파일을 수정해야 합니다.

- **/spark** 커맨드 라인(command line) 앱 실행에 사용됩니다.

  .. literalinclude:: managing_apps/002.php


- **/public/index.php** webapp의 프론트 컨트롤러입니다.

  .. literalinclude:: managing_apps/003.php


하나의 설치된 CodeIgniter로 여러 어플리케이션 실행하기
===============================================================

이미 설치된 CodeIgniter 프레임워크를 공유하여 여러 다른 어플리케이션을 사용하려면 어플리케이션 디렉토리 내부에 있는 모든 디렉토리를 자체(또는 서브) 디렉토리에 두십시오.

예를 들어 **foo**\ 와 **bar**\ 라는 두 개의 어플리케이션을 만들고 싶다고 가정해 봅시다.
다음과 같이 어플리케이션 프로젝트 디렉토리를 구성할 수 있습니다.

.. code-block:: text

    foo/
        app/
        public/
        tests/
        writable/
        env
        phpunit.xml.dist
        spark
    bar/
        app/
        public/
        tests/
        writable/
        env
        phpunit.xml.dist
        spark
    vendor/
        autoload.php
        codeigniter4/framework/
    composer.json
    composer.lock

.. note:: Zip 파일에서 CodeIgniter를 설치하는 경우 디렉터리 구조는 다음과 같습니다.

    .. code-block:: text

        foo/
        bar/
        codeigniter4/system/

여기에는 **foo** 및 **bar**라는 두 개의 앱이 있으며 둘 다 표준 애플리케이션 디렉토리와 **public** 폴더가 있고 공통 **codeigniter4/framework**\ 를 공유합니다.

각각의 **app/Config/Paths.php**\ 에 있는 ``$systemDirectory`` 변수는 공유된 공통 **codeigniter4/framework** 폴더를 참조하도록 설정됩니다.

.. literalinclude:: managing_apps/005.php

그리고 각각의 **app/Config/Constants.php**\ 에서 ``COMPOSER_PATH`` 상수를 수정합니다.

.. literalinclude:: managing_apps/004.php

애플리케이션 디렉토리를 변경할 때만 :ref:`renaming-app-directory`\ 를 참조하고 **index.php**\ 와 **spark**\ 의 경로를 수정합니다.
