Composer로 설치
###############################################################################

.. contents::
    :local:
    :depth: 2

Composer는 CodeIgniter4를 시스템에 여러 가지 방법으로 설치하여 사용할 수 있게해 줍니다.

첫 번째 기술은 CodeIgniter4를 사용하여 새 웹앱의 기반으로 사용할 수 있는 스켈레톤(skeleton) 프로젝트를 만드는 방법을 설명합니다.
두 번째 기술을 사용하면 CodeIgniter4를 기존 웹앱에 추가할 수 있습니다.

.. note:: 만약 당신이 코드를 저장하거나 다른 사람들과 협업하기 위해 Git 저장소를 사용한다면, ``vendor`` 폴더는 일반적으로 "git ignored"\ 에 추가됩니다. 
          이 경우 레파지토리(repository)에 있는 새 시스템으로 업그레이드 하고 싶다면 ``composer update``\ 를 실행하십시오.

앱 스타터
=============

`CodeIgniter 4 app starter <https://github.com/codeigniter4/appstarter>`_ 레파지토리는 
프레임워크의 최신 버전에 대한 composer 의존성과 함께 골격(skeleton) 어플리케이션을 보유하고 있습니다.

이 설치 방법은 새로운 CodeIgniter4 기반 프로젝트를 시작하고자 하는 개발자에게 적합합니다.

설치
----

프로젝트 루트(root) 폴더에서 다음과 같이 입력합니다.

::

    > composer create-project codeigniter4/appstarter project-root

위와 같이하면 "project-root" 폴더가 생성됩니다.

"project-root"\ 를 생략하면 "appstarter" 폴더가 생성되며, 이 폴더의 이름은 바꿀 수 있습니다.

.. note:: CodeIgniter 자동 로더(autoloader)는 특정 운영 체제의 파일 이름에 잘못된 특수 문자를 허용하지 않습니다.
    사용할 수 있는 기호는 ``/``, ``_``, ``.``, ``:``, ``\``\ 과 공백(space)입니다.
    따라서 ``(``, ``)`` 등과 같은 특수 문자가 포함된 폴더에 CodeIgniter를 설치하면 CodeIgniter가 작동하지 않습니다.

phpunit과 관련된 composer 종속성이 필요하지 않다면 위 명령에 ``---no-dev`` 옵션을 추가합니다.

``---no-dev`` 옵션이 추가된 경우 composer는 프레임워크에 필요한 세 가지 신뢰할 수 있는 의존성 패키지만 설치합니다.

기본 프로젝트 폴더를 "appstarter"로 지정 하는 설치 

::

    composer create-project codeigniter4/appstarter --no-dev

Initial Configuration
---------------------

설치 후 몇 가지 초기 구성이 필요합니다.
자세한 내용은 :ref:`initial-configuration`\ 을 참조하세요.

.. _app-starter-upgrading:

업그레이드
--------------

새 릴리즈가 있을 때마다 프로젝트 루트에서 다음 입력합니다.

::

    > composer update 

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

Latest Dev
=================

App Starter 저장소에는 현재 안정 릴리스와 프레임워크의 최신 개발 지점간에 Composer 소스를 전환하는 ``builds`` 스크립트가 제공됩니다.
불안정할 수 있지만 출시되지 않은 최신 변경 사항을 적용해보고 싶은 개발자는 이 스크립트를 사용하십시오.

`개발 사용자 가이드 <https://codeigniter4.github.io/CodeIgniter4/>`_\ 는 온라인으로 액세스 할 수 있습니다.
이는 릴리스된 사용자 가이드와 다르며 개발 브랜치와 관련이 있다는 점을 유의하십시오.

프로젝트 루트(root) 폴더에서 다음 명령을 입력하십시오.

::

    > php builds developmen

위의 명령은 **composer.json**\ 을 업데이트하여 작업 저장소의 ``develop`` 브렌치(branch)를 가리키고 구성 및 XML 파일의 해당 경로를 업데이트합니다.

이러한 변경 사항을 되돌리려면 다음 명령을 입력하십시오.

::

    > php builds release


``builds`` 명령을 사용한 후에는 반드시 ``composer update``\ 를 실행하여 vendor 폴더를 최신 빌드와 동기화해야 합니다.

기존 프로젝트에 CodeIgniter4 추가
===================================

"수동 설치"\ 에 설명된 것과 동일한 CodeIgniter4 프레임워크를 Composer를 사용하여 기존 프로젝트에 추가할 수도 있습니다.

Installation
------------

앱은 ``app`` 폴더 안에서 개발하고, 웹 루트(root)는 ``public`` 폴더를 지정하십시오.

프로젝트 루트(root)에서 다음 명령어를 입력하십시오.

::

    > composer require codeigniter4/framework

앞서 설명한 composer 설치 방법과 마찬가지로, ``composer require`` 명령에 ``---no-dev`` 옵션을 추가하여 phpunit 관련 패키지 설치를 생략할 수 있습니다.

설정(Setup)
----------------

    1. ``app``, ``public``, ``tests``, ``writable`` 폴더를 ``vendor/codeigniter4/framework``\ 에서 프로젝트 루트(root)로 복사
    2. ``env``, ``phpunit.xml.dist``, ``spark`` 파일을 ``vendor/codeigniter4/framework``\ 에서 프로젝트 루트로 복사
    3. **app/Config/Paths.php**\ 의 ``$systemDirectory`` 속성을 조정하여 공급업체를 참조(예: ``ROOTPATH . '/vendor/codeigniter4/framework/system'``)합니다.

Initial Configuration
---------------------

몇 가지 초기 구성이 필요합니다.
자세한 내용은 :ref:`initial-configuration`\ 을 참조하세요.

.. _adding-codeigniter4-upgrading:

업그레이드
---------------

새 릴리즈가 있을 때마다 프로젝트 루트의 커맨드 라인에서 다음 명령을 입력하십시오.::

    > composer update

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

- app, public, tests, writable
- vendor/codeigniter4/framework/system

번역된 시스템 메시지 설치
============================

번역된 시스템 메시지를 이용하려면 프레임워크 설치와 비슷한 방식으로 프로젝트에 추가할 수 있습니다.

프로젝트 루트(root)에서 다음 명령을 입력하십시오.

::

    > composer require codeigniter4/translations

업데이트된 내용은 ``composer update``\ 를 실행할 때마다 프레임워크와 함께 업데이트됩니다.
