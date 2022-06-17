#############################
Upgrading from 4.2.0 to 4.2.1
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

app/Config/Mimes.php
====================

- **app/Config/Mimes.php**\ 의 MIME 유형에 대한 파일 확장자의 매핑이 버그를 수정하기 위해 업데이트되었습니다. 또한 ``Mimes::getExtensionFromType()``\ 의 로직이 변경되었습니다.

Breaking Changes
****************

.. _upgrade-421-get_cookie:

get_cookie()
============

접두사 이름이 있는 쿠키와 접두사 없이 같은 이름의 쿠키가 있는 경우 이전 ``get_cookie()``\ 는 접두사 없이 쿠키를 반환하는 까다로운 동작을 했습니다.

예를 들어 ``Config\Cookie::$prefix``\ 가 ``prefix_``\ 인 경우 ``test``\ 와 ``prefix_test``\ 라는 두 개의 쿠키가 있습니다.

.. code-block:: php

    $_COOKIES = [
        'test'        => 'Non CI Cookie',
        'prefix_test' => 'CI Cookie',
    ];

이전에는 ``get_cookie()``\ 가 다음을 반환합니다.

.. code-block:: php

    get_cookie('test');        // returns "Non CI Cookie"
    get_cookie('prefix_test'); // returns "CI Cookie"

이제 해당 동작의 버그가 수정되어 다음과 같이 변경되었습니다.

.. code-block:: php

    get_cookie('test');              // returns "CI Cookie"
    get_cookie('prefix_test');       // returns null
    get_cookie('test', false, null); // returns "Non CI Cookie"

이전 동작에 의존하는 경우 코드를 변경해야 합니다.

.. note:: 위의 예에서 ``prefix_test`` 쿠키가 하나만 있는 경우 이전 ``get_cookie('test')``\ 도 ``"CI Cookie"``\ 를 반환합니다.

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


All Changes
===========

다음은 **프로젝트 공간**\ 에서 변경사항이 있는 모든 파일의 목록입니다. 대부분은 런타임에 영향을 미치지 않는 간단한 주석 또는 형식입니다.

* app/Config/Mimes.php
