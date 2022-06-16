#############################
Upgrading from 4.1.9 to 4.2.0
#############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer 설치 - App Starter 업그레이드 <app-starter-upgrading>`
- :ref:`Composer 설치 - 기존 프로젝트의 CodeIgniter4 업그레이드 <adding-codeigniter4-upgrading>`
- :ref:`수동 설치 업그레이드 <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

Mandatory File Changes
**********************

index.php와 spark
===================

다음 파일은 중요한 변경 사항을 받았으며 **업데이트된 버전을 어플리케이션과 병합해야 합니다.**

* ``public/index.php``
* ``spark``

.. important:: 위의 두 파일을 업데이트하지 않으면 ``composer update`` 실행 후 CodeIgniter가 작동하지 않습니다.

    업그레이드 절차의 예를 들면 다음과 같습니다.

    ::

        > composer update
        > cp vendor/codeigniter4/framework/public/index.php public/index.php
        > cp vendor/codeigniter4/framework/spark .

Config/Constants.php
====================

상수 ``EVENT_PRIORITY_LOW``, ``EVENT_PRIORITY_NORMAL``, ``EVENT_PRIORITY_HIGH``\ 는 더 이상 사용되지 않으며 정의는 ``app/Config/Constants.php``\ 로 이동합니다.
이러한 상수를 사용하는 경우 ``app/Config/Constants.php``\ 에서 정의하거나 새로운 클래스 상수인 ``CodeIgniter\Events\Events::PRIORITY_LOW``, ``CodeIgniter\Events\Events::PRIORITY_NORMAL``, ``CodeIgniter\Events\Events::PRIORITY_HIGH``\ 를 사용하십시오.

Breaking Changes
****************

- ``system/bootstrap.php`` 파일은 더 이상 ``CodeIgniter`` 인스턴스를 반환하지 않으며 ``.env`` 파일을 로드하지 않습니다. (``index.php`` 및 ``spark에서 처리됨``) 이러한 동작을 예상하는 코드가 있으면 더 이상 작동하지 않으므로 수정해야 합니다. 이는 `Preloading <https://www.php.net/manual/en/opcache.preloading.php>`_\ 을 구현하기 쉽도록 변경되었습니다.

Breaking Enhancements
*********************

- ``Validation::setRule()``\ 의 메소드 서명이 변경되었습니다. ``$rules`` 매개변수에 대한 ``string`` 유형 힌트가 제거되었습니다. 클래스를 확장할 때도 LSP가 깨지지 않도록 매개변수를 제거해야 합니다.
- ``CodeIgniter\Database\BaseBuilder::join()``\ 와 ``CodeIgniter\Database\*\Builder::join()``\ 의 메소드 서명이 변경되었습니다. ``$cond`` 매개변수에 대한 ``string`` 유형 힌트가 제거되었습니다. 클래스를 확장할 때도 LSP가 깨지지 않도록 매개변수를 제거해야 합니다.

Project Files
*************

**프로젝트 공간**\ 에 있는 수많은 파일(root, app, public, writable)이 업데이트를 받았습니다.
이러한 파일은 **system** 범위를 벗어났기 때문에 사용자의 개입 없이는 변경되지 않습니다.
프로젝트 공간의 변경 사항을 병합하는 데 도움이 되는 타사 CodeIgniter 모듈은 `Explore on Packagist <https://packagist.org/explore/?query=codeigniter4%20updates>`_\ 에서 찾을 수 있습니다.

.. note:: 버그 수정에 대한 매우 드문 경우를 제외하고 프로젝트 공간의 파일을 변경해도 응용 프로그램이 손상되지 않습니다.
    여기에 명시된 모든 변경 사항은 다음 주요 버전까지 선택 사항이며, 필수 변경 사항은 위의 섹션에서 다룹니다.

Content Changes
===============

다음 파일에는 중요한 변경 사항(더 이상 사용되지 않음 또는 시각적 조정 포함)이 있으므로 업데이트된 버전을 응용 프로그램과 병합하는 것이 좋습니다.

* ``app/Config/Routes.php``
    * 기본 구성을 보다 안전하게 만들기 위해 자동 라우팅이 기본적으로 비활성화로 변경되었습니다.

All Changes
===========

다음은 **프로젝트 공간**\ 에서 변경사항이 있는 모든 파일의 목록입니다. 대부분은 런타임에 영향을 미치지 않는 간단한 주석 또는 형식입니다.

* app/Config/App.php
* app/Config/Constants.php
* app/Config/ContentSecurityPolicy.php
* app/Config/Database.php
* app/Config/Events.php
* app/Config/Feature.php
* app/Config/Filters.php
* app/Config/Format.php
* app/Config/Logger.php
* app/Config/Mimes.php
* app/Config/Publisher.php
* app/Config/Routes.php
* app/Config/Security.php
* app/Config/Validation.php
* app/Config/View.php
* app/Controllers/BaseController.php
* app/Views/errors/html/debug.css
* app/Views/errors/html/debug.js
* app/Views/errors/html/error_404.php
* app/Views/errors/html/error_exception.php
* app/Views/errors/html/production.php
* app/Views/welcome_message.php
* app/index.html
* preload.php
* public/index.php
* spark
