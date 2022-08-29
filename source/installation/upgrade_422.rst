#############################
Upgrading from 4.2.1 to 4.2.2
#############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer 설치 - App Starter 업그레이드 <app-starter-upgrading>`
- :ref:`Composer 설치 - 기존 프로젝트의 CodeIgniter4 업그레이드 <adding-codeigniter4-upgrading>`
- :ref:`수동 설치 업그레이드 <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

Breaking Changes
****************

Web Page Caching Bug Fix
========================

- :doc:`../general/caching`\ 은 :ref:`after-filters`\ 가 실행된 후 응답 데이터를 캐시합니다.
- :ref:`secureheaders`\ 를 활성화하면 페이지가 캐시에서 올 때 응답 헤더가 전송됩니다.

.. important:: **이 버그를 기반으로 하여** "after" 필터의 응답에 대한 변경 사항이 캐시되지 않는다고 가정하고  코드를 작성하였다면 **민감한 정보가 캐시되어 손상될 수 있으므로** 페이지 캐싱을 비활성화하도록 코드를 변경하십시오.

Others
======

- ``Forge::createTable()`` 메소드는 더 이상 ``CREATE TABLE IF NOT EXISTS``\ 를 실행하지 않습니다. `$ifNotExists`\ 가 true일 때 ``$db->tableExists($table)``\ 에 테이블이 없으면 ``CREATE TABLE``\ 이 실행됩니다.
- ``Forge::_createTable()``\ 의 두 번째 매개변수 ``$ifNotExists``\ 는 더 이상 사용되지 않으며 향후 릴리스에서 제거됩니다.
- :php:func:`random_string()`을 첫 번째 매개변수 ``'crypto'``\ 와 함께 사용할 때 두 번째 매개변수 ``$len``\ 을 홀수로 설정하면 ``InvalidArgumentException``\ 이 발생합니다. 매개변수를 짝수로 변경합니다.

Breaking Enhancements
*********************


Project Files
*************

**프로젝트 공간**\ 에 있는 수많은 파일(root, app, public, writable)이 업데이트를 받았습니다.
이러한 파일은 **system** 범위를 벗어났기 때문에 사용자의 개입 없이는 변경되지 않습니다.
프로젝트 공간의 변경 사항을 병합하는 데 도움이 되는 타사 CodeIgniter 모듈은 `Explore on Packagist <https://packagist.org/explore/?query=codeigniter4%20updates>`_\ 에서 찾을 수 있습니다.

.. note:: 버그 수정에 대한 매우 드문 경우를 제외하고 프로젝트 공간의 파일을 변경해도 응용 프로그램이 손상되지 않습니다.
    여기에 명시된 모든 변경 사항은 다음 주요 버전까지 선택 사항이며, 필수 변경 사항은 위의 섹션에서 다룹니다.


Content Changes
===============

* app/Views/errors/html/error_404.php
* app/Views/welcome_message.php
* public/index.php
* spark

All Changes
===========

다음은 **프로젝트 공간**\ 에서 변경사항이 있는 모든 파일의 목록입니다. 대부분은 런타임에 영향을 미치지 않는 간단한 주석 또는 형식입니다.

* app/Config/App.php
* app/Config/Constants.php
* app/Config/Logger.php
* app/Config/Paths.php
* app/Views/errors/html/error_404.php
* app/Views/welcome_message.php
