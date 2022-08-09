##############################
여러 환경 처리(Handling)
##############################

개발자는 종종 어플리케이션이 개발 환경과 프로덕션 환경에 따라 다른 방식으로 시스템이 동작하길 원합니다.
자세한 오류 출력이 좋은 예인데, 어플리케이션을 개발하는 동안 유용하지만 "서비스"중일 때는 이로 인해 보안 문제가 발생할 수 있습니다.
개발 환경에서는 프로덕션 환경에서 사용하지 않는 추가 도구를 로드 할 수도 있습니다.

.. contents::
    :local:
    :depth: 2

.. _environment-constant:

ENVIRONMENT 상수
========================

기본적으로 CodeIgniter에는 ``ENVIRONMENT`` 상수가 ``$_SERVER['CI_ENVIRONMENT']``\ 에 제공된 값을 사용하도록 설정되어 있으며, 그렇지 않은 경우 ``production`` 값을 기본 값으로 설정합니다.
서버 설정에 따라 여러 가지 방법으로 설정할 수 있습니다.

.. note:: PHPUit 테스트에는 환경 ``testing``\ 이 특별합니다.
    이를 지원하기 위해 여러 곳의 프레임워크에 특수 조건이 내장되어 있습니다.
    개발에는 사용할 수 없습니다.

.. note:: ``spark env`` 명령으로 현재 환경을 확인할 수 있습니다.
    
    ::

    > php spark env

.env
----

변수를 설정하는 가장 간단한 방법은 :doc:`.env 파일 </general/configuration>`\ 입니다.

.. code-block:: ini

    CI_ENVIRONMENT = development

.. note:: ``spark env`` 명령으로 **.env** 파일의 ``CI_ENVIRONMENT`` 값을 변경할 수 있습니다.
    
    ::

    > php spark env production

.. _environment-apache:

Apache
------

``.htaccess`` 파일 또는 `SetEnv <https://httpd.apache.org/docs/2.2/mod/mod_env.html#setenv>`_\ 를 사용하여 Apache 변수를 설정할 수 있습니다.

.. code-block:: apache

    SetEnv CI_ENVIRONMENT development

.. _environment-nginx:

nginx
-----

nginx에서는 ``fastcgi_params``\ 를 통해 환경 변수를 전달해야 `$_SERVER` 변수 아래 표시됩니다.
이와 같은 방법을 사용하면 `env`\ 를 사용하여 전체 서버에 대해 설정하는 대신, 가상 호스트 수준에서만 작동하도록 할 수 있습니다.
서버 구성을 다음과 같이 수정합니다:

.. code-block:: nginx

    server {
        server_name localhost;
        include     conf/defaults.conf;
        root        /var/www;

        location    ~* \.php$ {
            fastcgi_param CI_ENVIRONMENT "production";
            include conf/fastcgi-php.conf;
        }
    }

nginx 및 기타 서버에서 이 대체 방법을 사용할 수 있으며, 이를 사용하지 않고 서버의 IP 주소를 기반으로 상수를 설정할 수 있습니다.

이 상수를 이용하면 프레임워크 기본 동작에 영향을 주고, 개발할 때 실행중인 환경을 구별할 수 있습니다.

부팅 파일
------------

CodeIgniter를 실행하려면 사용중인 환경 이름과 일치하는 PHP 파일이 **APPPATH/Config/Boot** 아래에 있어야 합니다.
이 파일에는 오류 표시 설정, 추가 개발자 도구 로드등 사용중인 환경에 맞는 모든 사용자 정의가 포함될 수 있습니다.
다음 파일은 CodeIgniter 설치시 자동으로 생성되며, 실행시 시스템에 의해 자동으로 로드됩니다:

* development.php
* production.php
* testing.php

프레임워크 동작에 미치는 영향
=====================================

이 섹션에서는 ENVIRONMENT 상수가 CodeIgniter 시스템에는 사용되는 곳과 동작에 어떻게 영향을 미치는지 설명합니다.

오류보고
---------------

ENVIRONMENT 상수를 ``development`` 값으로 설정하면 모든 PHP 오류에 대해 웹브라우저에 렌더링됩니다.
반대로, ENVIRONMENT 상수를 ``production``\ 으로 설정하면 모든 오류 출력이 비활성화됩니다.
프로덕션에서 오류보고를 비활성화하는 것이 :doc:`좋은 보안 관행 </concepts/security>`\ 입니다.
