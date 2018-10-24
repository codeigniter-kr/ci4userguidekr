############
설치하기
############

CodeIgniter4는 Composer를 이용하거나 수동으로 설치할 수 있습니다.

.. note:: Before using CodeIgniter, make sure that your server meets the
          :doc:`requirements </intro/requirements>`.

수동 설치
===================

CodeIgniter 수동 다운로드 후 압축을 풀어줍니다.

Composer Installation
=====================

required를 사용하지 않고 `composer <https://getcomposer.org>`_ create-project 커맨드를 사용합니다.

::

    composer create-project codeigniter4/framework

Running
=======

#. CodeIgniter 폴더와 파일을 서버에 업로드합니다. **index.php** 파일은
   프로젝트 루트 아래 **public** 폴더 안에 있습니다.
#. 에디터를 사용하여 **application/Config/App.php** 파일을 열고 base URL을
   설정합니다. 암호화(Encryption) 또는 세션(Session)을 사용하려면 
   encryption key를 설정합니다. 좀 더 유연하게 설정하고싶다면 .env 파일의
   baseURL(**app.baseURL="http://example.com"**)에 설정할 수 있습니다.
#. 데이터베이스를 사용하려면 에디터로
   **application/Config/Database.php** 파일을 열고 데이터베이스 정보를 설정하세요.

최고의 보안을 위해 system과 application 디렉터리를 모두 Web root가 아닌 곳에
두어 웹브라우저를 통해 직접 액세스할 수 없도록 하세요. 기본적으로 **.htaccess**
파일을 각 디렉터리에 두어 직접 액세스하지 못하게 되어 있지만, 웹 서버 구성이 
변경되거나 **.htaccess** 를 지원하지 않을 경우에 접근할 수 있게 됩니다.

view를 공개하고 싶다면 **view** 디렉터리를 **application** 디렉터리에서
**public** 디렉터리로 이동할 수 있습니다. 이렇게 할 경우 **public** 디렉터리의
index.php 파일을 열어 ``$system_path``, ``$application_folder`` 그리고 
``$view_folder`` 의 값을 전체 경로를 사용하여 설정하세요.
ex> ``/www/MyUser/system``.


프로덕션 환경에서 취할 수있는 또 하나의 조치는 PHP 오류보고 및 기타 개발 전용
기능을 비활성화하는 것입니다. CodeIgniter에서는 ``ENVIRONMENT`` 상수 를 설정하여
이를 수행 할 수 있습니다. 자세한 내용은 환경 페이지 에서 자세히 설명 합니다.
기본적으로 응용 프로그램은 "production"환경을 사용하여 실행됩니다. 제공된 
디버깅 도구를 이용하려면 "develop"환경을 설정해야합니다.

.. caution:: Using PHP's built-in web server is likely to cause problems,
	as it does not process the ``.htaccess`` file used to properly handle requests.

That's it!

CodeIgniter를 처음 사용한다면 , 사용자 가이드의 :doc:`시작하기 <../intro/index>`
섹션을 읽고 동적 PHP 애플리케이션을 작성하는 방법을 배우십시오. Enjoy!

.. toctree::
    :hidden:
    :titlesonly:

    downloads
    self
    upgrading
    troubleshooting
    local_server
