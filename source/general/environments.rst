##############################
여러 환경 처리
##############################

Developers often desire different system behavior depending on whether
an application is running in a development or production environment.
For example, verbose error output is something that would be useful
while developing an application, but it may also pose a security issue
when "live". In development environments, you might want additional
tools loaded that you don't in production environments, etc.
개발자는 응용 프로그램이 개발 환경 또는 프로덕션 환경에서 실행되는지 여부에 따라 다른 시스템 동작을 원할 때가 있습니다. 예를 들어, 자세한 오류 출력은 응용 프로그램을 개발하는 동안 유용 할 수 있지만 "라이브"일 때 보안 문제가 될 수 있습니다. 개발 환경에서는 프로덕션 환경 등에서 추가 도구를로드해야 할 수 있습니다.

The ENVIRONMENT Constant
========================

By default, CodeIgniter comes with the environment constant set to use
the value provided in ``$_SERVER['CI_ENVIRONMENT']``, otherwise defaulting to
'production'. This can be set in several ways depending on your server setup.
기본적으로 CodeIgniter는 환경 상수가 제공된 ``$_SERVER['CI_ENVIRONMENT']`` 값을 사용하도록 설정되어 있으며, 그렇지 않은 경우 기본값은 'production'입니다. 이 설정은 서버 설정에 따라 여러 가지 방법으로 설정할 수 있습니다.

.env
----

The simplest method to set the variable is in your :doc:`.env file </general/configuration>`.
변수를 설정하는 가장 간단한 방법은 :doc:`.env file </general/configuration>` 파일에 있습니다.

.. code-block:: ini

    CI_ENVIRONMENT = development

Apache
------

This server variable can be set in your ``.htaccess`` file, or Apache
config using `SetEnv <https://httpd.apache.org/docs/2.2/mod/mod_env.html#setenv>`_.
이 서버 변수는 ``.htaccess`` 파일에서 설정하거나 `SetEnv <https://httpd.apache.org/docs/2.2/mod/mod_env.html#setenv>`_ 를 사용하여 Apache 구성 에서 설정할 수 있습니다 .

.. code-block:: apache

    SetEnv CI_ENVIRONMENT development

nginx
-----

Under nginx, you must pass the environment variable through the ``fastcgi_params``
in order for it to show up under the ``$_SERVER`` variable. This allows it to work on the
virtual-host level, instead of using ``env`` to set it for the entire server, though that
would work fine on a dedicated server. You would then modify your server config to something
like
nginx에서는 ``$_SERVER`` 변수 ``fastcgi_params`` 아래에 환경 변수 가 표시되도록 환경 변수를 전달해야합니다. 이것은 ``env`` 를 사용 하여 전체 서버에 대해 설정하는 대신에 virtual-host 레벨에서 작동 할 수있게 하지만 전용 서버에서 제대로 작동합니다. 그런 다음 서버 구성을 다음과 같이 수정합니다.
:

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

Alternative methods are available for nginx and other servers, or you can
remove this logic entirely and set the constant based on the server's IP address
(for instance).
대체 방법은 nginx 및 다른 서버에서 사용할 수 있습니다. 또는이 논리를 완전히 제거하고 서버의 IP 주소 (예를 들어)를 기반으로 상수를 설정할 수 있습니다.

In addition to affecting some basic framework behavior (see the next
section), you may use this constant in your own development to
differentiate between which environment you are running in.
기본적인 프레임 워크 동작 (다음 절 참조)에 영향을주는 것 외에도, 자신이 개발 한이 상수를 사용하여 실행중인 환경을 구별 할 수 있습니다.

부팅 파일
----------

CodeIgniter requires that a PHP script matching the environment's name is located
under **APPPATH/Config/Boot**. These files can contain any customizations that
you would like to make for your environment, whether it's updating the error display
settings, loading additional developer tools, or anything else. These are
automatically loaded by the system. The following files are already created in
a fresh install:
CodeIgniter는 환경 이름과 일치하는 PHP 스크립트가 **APPPATH/Config/Boot** 아래에 있어야 합니다. 이 파일에는 오류 표시 설정 업데이트, 추가 개발자 도구로드 또는 다른 작업 등 환경에 맞게 사용자 정의하려는 모든 사용자 정의가 포함될 수 있습니다. 이들은 시스템에 의해 자동으로로드됩니다. 새로 설치하면 다음 파일이 이미 만들어집니다.

* development.php
* production.php
* testing.php

Effects On Default Framework Behavior
기본 프레임 워크 동작에 미치는 영향
=====================================

There are some places in the CodeIgniter system where the ENVIRONMENT
constant is used. This section describes how default framework behavior
is affected.
CodeIgniter 시스템에는 ENVIRONMENT 상수가 사용되는 곳이 있습니다. 이 절에서는 기본 프레임 워크 동작이 어떻게 영향을 받는지 설명합니다.

오류보고
---------------

Setting the ENVIRONMENT constant to a value of 'development' will cause
all PHP errors to be rendered to the browser when they occur.
Conversely, setting the constant to 'production' will disable all error
output. Disabling error reporting in production is a
:doc:`good security practice </concepts/security>`.
ENVIRONMENT 상수를 'development'값으로 설정하면 모든 PHP 오류가 발생할 때 브라우저에 렌더링됩니다. 반대로 상수를 '생산'으로 설정하면 모든 오류 출력이 비활성화됩니다. 프로덕션 환경에서 오류보고를 사용하지 않도록 설정하는 것이 :doc:`good security practice </concepts/security>` 입니다.

구성 파일
-------------------

Optionally, you can have CodeIgniter load environment-specific
configuration files. This may be useful for managing things like
differing API keys across multiple environments. This is described in
more detail in the Handling Different Environments section of the
:doc:`Working with Configuration Files </general/configuration>` documentation.
선택적으로 CodeIgniter가 환경 별 설정 파일을 불러올 수 있습니다. 여러 환경에서 서로 다른 API 키를 관리하는 데 유용 할 수 있습니다. 자세한 내용은 :doc:`Working with Configuration Files </general/configuration>` 설명서 의 다른 환경 처리 섹션을 참조하십시오 .
