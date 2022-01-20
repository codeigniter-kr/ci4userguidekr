앱 실행
###############################################################################

.. contents::
    :local:
    :depth: 2

CodeIgniter 4 앱은 웹 서버에서 호스팅하거나 가상화, CodeIgniter의 커맨드 라인(command line) 도구를 사용하여 테스트할 수 있습니다.
이 절에서는 각 기법을 사용하는 방법을 다루며, 이들의 장단점을 설명합니다.

CodeIgniter를 처음 사용하는 경우 사용자 가이드의 :doc:`Getting Started </intro/index>`\ 을 
참조하여 동적 PHP 어플리케이션을 구축하는 방법에 대해 알아보십시오. 해피 코딩!

초기 구성 및 설정
=================================================

#. 텍스트 편집기로 **app/Config/App.php** 파일을 열고 기본(base) URL을 설정하십시오.
   좀 더 유연하게 작성하고 싶다면 ``.env`` 파일의 **app.baseURL="http://example.com/"** 
   항목에 설정해도 됩니다.
   (항상 기본 URL에 슬래시를 추가합니다!)
#. 데이터베이스를 사용하려면 **app/Config/Database.php** 파일에  데이터베이스 정보를 설정하십시오.
   ``.env`` 파일에 설정해도 됩니다.

production 환경(environment)에서 취해야 할 한 가지 추가 조치는 PHP 오류 보고 및 기타 개발 전용 기능을 비활성화하는 것입니다.
이것은 CodeIgniter의 :doc:`environments page </general/environments>`\ 에 자세히 설명된 ``ENVIRONMENT`` 상수로 설정할 수 있습니다.
기본적으로 어플리케이션은 "production" 환경을 사용하여 실행됩니다.
제공된 디버깅 도구를 사용하려면 환경을 "development"\ 로 설정해야 합니다.

.. note:: 웹 서버(예: Apache 또는 Nginx)를 사용하여 사이트를 실행할때는 
    프로젝트 내의 ``writable`` 폴더에 대한 사용 권한을 수정하여 웹 서버에서 쓰기 가능하도록 해야 합니다.

로컬 개발 서버
=================================================

CodeIgniter4는 PHP의 내장 웹 서버를 활용하여 CodeIgniter 라우팅이 동작하는 로컬 개발 서버와 함께 제공합니다.
프로젝트 기본 디렉터리에서 제공되는 다음 명령과 ``serve`` 를 사용하여 실행할 수 있습니다.::

    > php spark serve

이렇게 하면 서버가 실행되고, 이제 브라우저에서 http://localhost:8080를 통하여 실행된 앱을 볼 수 있습니다.

.. note:: 내장된 개발 서버는 개발 환경에서만 사용해야 합니다. 
    프로덕션(production) 서버에서 절대 사용하지 마세요.

도메인을 localhost가 아닌 다른 도메인으로 실행해야 한다면 ``hosts`` 파일에 추가해야 합니다.
대부분의 Unix 유형 시스템(OS X/Linux 포함)은 일반적으로 파일을 **/etc/hosts**\ 에 보관하지만, 파일의 정확한 위치는 운영 체제에 따라 다를수 있습니다.

로컬 개발 서버는 사용자 정의 가능한 세 가지 커맨드 라인 옵션을 제공 합니다.:

- 앱 실행시 ``--host`` 옵션을 사용하여 localhost가 아닌 다른 도메인을 지정할 수 있습니다.::

    > php spark serve --host example.dev

- 기본적으로 서버는 포트 8080에서 실행되지만 둘 이상의 사이트가 실행 중이거나 이미 해당 포트를 사용하는 다른 어플리케이션이 있을 수 있습니다. 
  ``--port`` 옵션을 사용하여 바꿀 수 있습니다.
  
  ::

    > php spark serve --port 8081

- 사용할 PHP의 특정 버전을 ``--php`` 옵션과 함께 PHP 실행 파일의 경로를 지정할 수 있습니다

    > php spark serve --php /usr/bin/php7.6.5.4

Apache를 사용한 호스팅
=================================================

CodeIgniter4 웹앱 (webapp)은 일반적으로 웹 서버에서 호스트됩니다.

아파치의 ``httpd``\ 는 "표준" 플랫폼이며, 사용자 가이드는 이를 가정하고 작성되었습니다.

Apache는 여러 플랫폼과 함께 번들로 제공되지만, `Bitnami (https://bitnami.com/stacks/infrastructure)`\ 에서 
데이터베이스 엔진과 함께 PHP를 번들로 다운로드할 수 있습니다.

.htaccess
-------------------------------------------------------

“mod_rewrite” 모듈은 “index.php”가 없는 URL을 활성화합니다. 사용자 가이드는 이를 가정하여 작성되었습니다.

기본 구성 파일에서 rewrite 모듈을 활성화(주석삭제)했는지 확인하십시오. eg. ``apache2/conf/httpd.conf``::

    LoadModule rewrite_module modules/mod_rewrite.so

기본 문서 루트(default document root)의 <Directory> 요소중 "AllowOverride" 기능을 사용하도록 설정했는지 확인하십시오.::

    <Directory "/opt/lamp/apache2/htdocs">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

가상 호스팅(Virtual Hosting)
-------------------------------------------------------

“virtual hosting”을 사용하여 어플리케이션 실행 권장합니다.
작업하는 각 앱에 대해 서로 다른 별칭을 설정할 수 있습니다.

가상 호스팅 모듈이 기본 구성 파일에서 활성화(주석삭제)되었는지 확인하십시오. eg. ``apache2/conf/httpd.conf``::

    LoadModule vhost_alias_module modules/mod_vhost_alias.so

호스트 별칭을 “hosts”  파일에 추가하십시오.
유닉스 유형 플랫폼의 경우 ``/etc/hosts``, 윈도우즈의 경우 ``c:/Windows/System32/drivers/etc/hosts``\ 에 위치합니다.
다음 줄을 추가 하십시오. 예를 들어 "myproject.local" 또는 "myproject.test"::

    127.0.0.1 myproject.local

가상 호스팅 구성 내에 웹 앱의 <VirtualHost> 요소 추가. eg. ``apache2/conf/extra/httpd-vhost.conf``::

    <VirtualHost *:80>
        DocumentRoot "/opt/lamp/apache2/htdocs/myproject/public"
        ServerName myproject.local
        ErrorLog "logs/myproject-error_log"
        CustomLog "logs/myproject-access_log" common
    </VirtualHost>

프로젝트 폴더가 Apache 문서 루트의 하위 폴더가 아닌 경우, 파일에 대한 웹서버 액세스 권한을 부여하기 위해 
<VirtualHost>에 중첩된 <Directory> 요소(element)가 필요할 수 있습니다.

테스트
-------------------------------------------------------

위의 구성을 따른다면 브라우저에서 ``http://myproject.local``\ 로 웹앱에 액세스하게 됩니다.

구성을 변경할 때마다 Apache를 다시 시작해야 합니다.

Nginx를 사용한 호스트
=================================================
Nginx는 웹 호스팅에 두 번째로 널리 사용되는 HTTP 서버입니다.
아래의 구성은 Ubuntu Server에서 PHP 7.3 FPM (unix sockets)을 사용한 예제입니다.

이 구성을 사용하면 "index.php"\ 가 없는 URL을 활성화하고 ".php"\ 로 끝나는 URL에 CodeIgniter의 "404-File Not Found"\ 를 보여줍니다.


.. code-block:: nginx

    server {
        listen 80;
        listen [::]:80;

        server_name example.com;

        root  /var/www/example.com/public;
        index index.php index.html index.htm;

        location / {
            try_files $uri $uri/ /index.php$is_args$args;
        }

        location ~ \.php$ {
            include snippets/fastcgi-php.conf;

            # With php-fpm:
            fastcgi_pass unix:/run/php/php7.3-fpm.sock;
            # With php-cgi:
            # fastcgi_pass 127.0.0.1:9000;
        }

        error_page 404 /index.php;

        # deny access to hidden files such as .htaccess
        location ~ /\. {
            deny all;
        }
    }


Vagrant를 사용한 호스트
=================================================

가상화는 개발환경이 실제 동작하는 환경과 다를 경우 웹 어플리케이션을 실제와 가깝게 테스트할 수 있는 좋은 방법입니다.
두 가지(개발과 실제) 모두 동일한 플랫폼을 사용한다 하더라도 가상화는 테스트를 위한 격리된 환경을 제공합니다.

제공되는 코드베이스에는 ``VagrantFile.dist``\ 가 포함되어 있습니다.
이 파일을 ``VagrantFile``\ 로 복사하여 사용자 시스템(특정 데이터베이스, 캐싱 엔진)에 맞게 조정합니다.

구성
-------------------------------------------------------

`VirtualBox <https://www.virtualbox.org/wiki/Downloads>`_ 및 `Vagrant <https://www.vagrantup.com/downloads.html>`_\ 를 설치했다고 가정합니다.

Vagrant 구성 파일(config file)은 시스템에 `ubuntu/bionic64 Vagrant box <https://app.vagrantup.com/ubuntu/boxes/bionic64>`_ 설정이 있다고 가정함

::

    vagrant box add ubuntu/bionic64

테스트
-------------------------------------------------------

설정이 완료되면 다음 명령을 사용하여 VM 내부에서 웹앱을 시작할 수 있습니다.

::

    vagrant up

웹앱은 ``http://localhost:8080``\ 에 액세스 할 수 있으며, 빌드에 대한 코드 커버리지 보고서는 ``http://localhost:8081``\ 에 있고 사용자 안내서는 ``http://localhost:8082``.


앱 부트스트랩
=================================================

일부 시나리오에서는 전체 애플리케이션을 실제로 실행하지 않고 프레임워크를 로드할 필요가 있습니다.
이렇게 하면 프로젝트 단위 테스트나 타사 도구를 사용하여 코드를 분석하고 수정할 때 특히 유용합니다.
코드이그나이터 프레임워크는 이 시나리오를 위한 별도의 부트스트랩 스크립트인 ``system/Test/bootstrap.php``\ 가 제공됩니다.

프로젝트에 대한 대부분의 경로는 부트스트랩 프로세스 중에 정의됩니다.
미리 정의된 상수를 재정의할 수 있지만 코드이그나이터의 기본값을 재정의하여 사용할 때는 경로가 설치 방법에 필요한 디렉터리 구조와 일치하는지 확인하십시오.
