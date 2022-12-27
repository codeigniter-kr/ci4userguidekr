###############################
Upgrading from 4.2.10 to 4.2.11
###############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer 설치 - App Starter 업그레이드 <app-starter-upgrading>`
- :ref:`Composer 설치 - 기존 프로젝트의 CodeIgniter4 업그레이드 <adding-codeigniter4-upgrading>`
- :ref:`수동 설치 업그레이드 <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

Breaking Changes
****************

.. _upgrade-4211-proxyips:

Config\\App::$proxyIPs
======================

프록시 IP 주소와 클라이언트 IP 주소에 대해 HTTP 헤더를 설정하여 배열을 구성하도록 형식이 변경되었습니다..

::

    public $proxyIPs = [
            '10.0.1.200'     => 'X-Forwarded-For',
            '192.168.5.0/24' => 'X-Forwarded-For',
    ];

이전 형식 구성 값에 대해 ``ConfigException`` 예외가 발생합니다.

.. _upgrade-4211-session-key:

세션 핸들러 키 변경 사항
=========================

:ref:`sessions-databasehandler-driver`, :ref:`sessions-memcachedhandler-driver`, :ref:`sessions-redishandler-driver`\ 에 대한 세션 데이터 레코드 키가 변경되었습니다.
세션 드라이버를 사용하고 있다면 업그레이드 후 기존 세션 데이터가 무효화됩니다.

- ``DatabaseHandler``\ 를 사용할 때 세션 테이블의 ``id``\ 에 세션 쿠키 이름(``Config\App::$sessionCookieName``)이 포함됩니다.
- ``MemcachedHandler``\ 나 ``RedisHandler``\ 를 사용하는 경우 키 값에 세션 쿠키 이름(``Config\App::$sessionCookieName``)이 포함됩니다.

``id``\ 의 최대 길이는 Memcached 키의 최대 길이(250바이트)입니다.
다음 값이 최대 길이를 초과하면 세션이 제대로 작동하지 않습니다.

- ``DatabaseHandler`` 사용 시 세션 쿠키 이름, 구분 기호 및 세션 ID(기본적으로 32자)
- ``MemcachedHandler`` 사용 시 접두사(``ci_session``), 세션 쿠키 이름, 구분 기호 및 세션 ID

Project Files
*************

``4.2.11`` 버전은 프로젝트 파일의 실행 코드를 변경하지 않았습니다.

All Changes
===========

다음은 **프로젝트 공간**\ 에서 변경사항이 있는 모든 파일의 목록입니다. 대부분은 런타임에 영향을 미치지 않는 간단한 주석 또는 형식입니다.

* app/Config/App.php
* app/Config/Autoload.php
* app/Config/Logger.php
* app/Config/Toolbar.php
* app/Views/welcome_message.php
* composer.json
* phpunit.xml.dist
