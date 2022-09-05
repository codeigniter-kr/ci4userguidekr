#############################
Upgrading from 4.2.5 to 4.2.6
#############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer 설치 - App Starter 업그레이드 <app-starter-upgrading>`
- :ref:`Composer 설치 - 기존 프로젝트의 CodeIgniter4 업그레이드 <adding-codeigniter4-upgrading>`
- :ref:`수동 설치 업그레이드 <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2


Project Files
*************

**프로젝트 공간**\ (루트, 앱, 공개, 쓰기 가능)의 일부 파일이 외관(cosmetic) 업데이트를 받았습니다.
이러한 파일은 전혀 건드릴 필요가 없습니다.
프로젝트 공간의 변경 사항을 병합하는 데 도움이 되는 타사 CodeIgniter 모듈은 `Explore on Packagist <https://packagist.org/explore/?query=codeigniter4%20updates>`_\ 에서 찾을 수 있습니다.

All Changes
===========

다음은 **프로젝트 공간**\ 에서 변경사항이 있는 모든 파일의 목록입니다. 대부분은 런타임에 영향을 미치지 않는 간단한 주석 또는 형식입니다.

* app/Config/App.php
* app/Config/ContentSecurityPolicy.php
* app/Config/Routes.php
* app/Config/Validation.php
