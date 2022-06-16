Composer로 설치
###############################################################################

.. contents::
    :local:
    :depth: 2

Composer는 CodeIgniter4를 시스템에 여러 가지 방법으로 설치하여 사용할 수 있게해 줍니다.

처음 두 가지는 CodeIgniter4를 사용하여 새로운 웹앱을 작성할 수 있는 골격(skeleton) 프로젝트를 만드는 방법을 설명합니다.

세 번째 방법은 기존 웹 앱에 CodeIgniter4를 추가합니다.

.. note:: 만약 당신이 코드를 저장하거나 다른 사람들과 협업하기 위해 Git 저장소를 사용한다면, ``vendor`` 폴더는 일반적으로 "git ignored"\ 에 추가됩니다. 
          이 경우 레파지토리(repository)에 있는 새 시스템으로 업그레이드 하고 싶다면 ``composer update``\ 를 실행하십시오.

앱 스타터
=============

`CodeIgniter 4 app starter <https://github.com/codeigniter4/appstarter>`_ 레파지토리는 
프레임워크의 최신 버전에 대한 composer 의존성과 함께 골격(skeleton) 어플리케이션을 보유하고 있습니다.

이 설치 방법은 새로운 CodeIgniter4 기반 프로젝트를 시작하고자 하는 개발자에게 적합합니다.

설치 및 설정(setup)
------------------------

프로젝트 루트(root) 폴더에서 다음과 같이 입력합니다.

::

    > composer create-project codeigniter4/appstarter project-root

위와 같이하면 "project-root" 폴더가 생성됩니다.

"project-root"\ 를 생략하면 "appstarter" 폴더가 생성되며, 이 폴더의 이름은 바꿀 수 있습니다.

phpunit과 관련된 composer 종속성이 필요하지 않다면 위 명령에 ``---no-dev`` 옵션을 추가합니다.

``---no-dev`` 옵션이 추가된 경우 composer는 프레임워크에 필요한 세 가지 신뢰할 수 있는 의존성 패키지만 설치합니다.

기본 프로젝트 폴더를 "appstarter"로 지정 하는 설치 

::

    composer create-project codeigniter4/appstarter --no-dev

설치 후에는 "업그레이드" 섹션의 단계를 따르십시오.

.. _app-starter-upgrading:

업그레이드
--------------

새 릴리즈가 있을 때마다 프로젝트 루트에서 다음 입력합니다.

::

    > composer update 

시스템에 속하지 않는 디렉토리(app, public 등)를 최신 프레임워크 소스 구조와 비교하려면 ``--prefer-source`` 옵션으로 업데이트합니다.

::

    > composer update codeigniter4/framework --prefer-source

``--prefer-source`` 옵션으로 최신 프레임워크 소스 구조를 가져올때 자동 업데이트가 되지 않으면 이전 코드를 다음과 같이 제거할 수 있습니다.

::

    rm -rf vendor/codeigniter4/framework && composer update codeigniter4/framework --prefer-source


프로젝트를 만들 때 ``--no-dev`` 옵션을 사용했다면 ``composer update --no-dev``\ 를 입력합니다.

:doc:`업그레이드 지침 <upgrading>`\ 을 읽고 변경 사항 및 개선 사항을 확인하십시오.

장점
----------

간단한 설치; 쉬운 업데이트

단점
----------

업데이트후 ``app/Config`` 변경 사항을 확인해야 함


구조
---------

설정 후 프로젝트의 폴더:

- app, public, tests, writable 
- vendor/codeigniter4/framework/system
- vendor/codeigniter4/framework/app & public (``--prefer-source`` 옵션 사용 시 업데이트 후 확인이 필요합니다.)

Latest Dev
=================

App Starter 저장소에는 현재 안정 릴리스와 프레임워크의 최신 개발 지점간에 Composer 소스를 전환하는 ``builds`` 스크립트가 제공됩니다.
불안정할 수 있지만 출시되지 않은 최신 변경 사항을 적용해보고 싶은 개발자는 이 스크립트를 사용하십시오.

`개발 사용자 가이드 <https://codeigniter4.github.io/CodeIgniter4/>`_\ 는 온라인으로 액세스 할 수 있습니다.
이는 릴리스된 사용자 가이드와 다르며 개발 브랜치와 관련이 있다는 점을 유의하십시오.

프로젝트 루트(root) 폴더에서 다음 명령을 입력하십시오.

::

    php builds developmen

위의 명령은 **composer.json**\ 을 업데이트하여 작업 저장소의 ``develop`` 브렌치(branch)를 가리키고 구성 및 XML 파일의 해당 경로를 업데이트합니다.

이러한 변경 사항을 되돌리려면 다음 명령을 입력하십시오.

::

    php builds release


``builds`` 명령을 사용한 후에는 반드시 ``composer update``\ 를 실행하여 vendor 폴더를 최신 빌드와 동기화해야 합니다.

기존 프로젝트에 CodeIgniter4 추가
===================================

"수동 설치"\ 에 설명된 것과 동일한 CodeIgniter4 프레임워크를 Composer를 사용하여 기존 프로젝트에 추가할 수도 있습니다.

앱은 ``app`` 폴더 안에서 개발하고, 웹 루트(root)는 ``public`` 폴더를 지정하십시오.

프로젝트 루트(root)에서 다음 명령어를 입력하십시오.

::

    > composer require codeigniter4/framework --prefer-sourc

앞서 설명한 두 가지 composer 설치 방법과 마찬가지로, phpunit 관련 패키지가 필요 없다면 ``composer require`` 명령에 ``---no-dev`` 옵션을 추가하십시오.

설정(Setup)
----------------

``app``, ``public``, ``writable`` 폴더를 ``vendor/codeigniter4/framework``\ 에서 프로젝트 루트(root)로 복사

``env``, ``phpunit.xml.dist`` 및 ``spark`` 파일을 ``vendor/codeigniter4/framework``\ 에서 프로젝트 루트로 복사

``vendor/codeigniter/framework``\ 를 참조하기 위해 ``app/Config/Paths.php``\ 의 $systemDirectory 변수의 경로를 수정하십시오.
``app/Config/Paths.php`` 파일의 ``$systemDirectory`` 변수를 컴포저의 vendor 경로로 조정합니다.

::

    // app/Config/Paths.php
    $systemDirectory = ROOTPATH . '/vendor/codeigniter4/framework/system';

.. _adding-codeigniter4-upgrading:

업그레이드
---------------

새 릴리즈가 있을 때마다 프로젝트 루트의 커맨드 라인에서 다음 명령을 입력하십시오.::

    > composer update --prefer-source

:doc:`업그레이드 지침 <upgrading>`\ 을 읽고 변경 사항 및 개선 사항을 확인하십시오.

장점
-------------

비교적 간단한 설치, 쉬운 업데이트

단점
-------------

업데이트 후 ``app/Config`` 변경 사항을 확인해야 함

구조
-------------

설정 후 프로젝트의 폴더:

- app, public, writable (``--prefer-source`` 옵션 사용 시)
- vendor/codeigniter4/framework/system

번역된 시스템 메시지 설치
============================

번역된 시스템 메시지를 이용하려면 프레임워크 설치와 비슷한 방식으로 프로젝트에 추가할 수 있습니다.

프로젝트 루트(root)에서 다음 명령을 입력하십시오.

::

    > composer require codeigniter4/translations

업데이트된 내용은 ``composer update``\ 를 실행할 때마다 프레임워크와 함께 업데이트됩니다.
