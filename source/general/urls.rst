#####################
CodeIgniter URL
#####################

.. contents::
    :local:
    :depth: 2

기본적으로 CodeIgniter의 URL은 검색 엔진 및 인간 친화적으로 설계되었습니다.
CodeIgniter는 URL 표준 접근 방식인 "query-string" 사용하지 않고 **segment-based** 접근 방식을 사용합니다.
::

    https://example.com/news/article/my_article

URL은 :doc:`URI 라우팅 </incoming/routing>` 기능을 사용하여 유연하게 정의할 수 있습니다.

:doc:`URI 라이브러리 <../libraries/uri>` \ 와 :doc:`URL 도우미 <../helpers/url_helper>`\ 에는 URI 데이터로 쉽게 작업할 수 있는 함수가 포함되어 있습니다.

URL 구조
=============

Base URL에 호스트 이름만 포함됨
-----------------------------------

Base URL이 **https://www.example.com/**\ 일 때 다음 URL을 살펴 봅시다.

::

    https://www.example.com/blog/news/2022/10?page=2

우리는 다음과 같이 사용합니다.

======== ============================
Base URL **https://www.example.com/**
URI path /blog/news/2022/10
Route    /blog/news/2022/10
Query    page=2
======== ============================

Base URL에 하위 폴더가 포함됨
-----------------------------

Base URL **https://www.example.com/ci-blog/**\ 일 때 다음 URL을 살펴 봅시다.

::

    https://www.example.com/ci-blog/blog/news/2022/10?page=2

우리는 다음과 같이 사용합니다.

======== ====================================
Base URL **https://www.example.com/ci-blog/**
URI path /ci-blog/blog/news/2022/10
Route    /blog/news/2022/10
Query    page=2
======== ====================================

index.php 제거
==============

기본적으로 URL은 **index.php**\를  포함합니다.::

    example.com/index.php/news/article/my_article

서버가 URL 다시 쓰기(rewriting)를 지원하는 경우 URL 다시 쓰기로이 파일을 쉽게 제거 할 수 있습니다.
이것은 서버마다 다르게 처리되지만 여기서는 가장 일반적인 두 웹 서버의 예를 들도록 하겠습니다.

.. _urls-remove-index-php-apache:

Apache Web Server
-----------------

Apache의 *mod_rewrite* 확장(extension)이 활성화 되어 있다면 ``.htaccess`` 파일에 간단한 규칙을 작성하여 사용합니다.
다음은 지정된 항목을 제외한 모든 항목이 리디렉션되는 "negative" 룰을 적용 예입니다.

.. code-block:: apache

    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^(.*)$ index.php/$1 [L]

이 예제에서 기존 디렉토리 및 기존 파일에 대한 요청 이외의 모든 HTTP 요청은 index.php 파일에 대한 요청으로 처리됩니다.

.. note:: 이러한 특정 규칙은 서버 구성에 따라 작동하지 않을 수 있습니다.

.. note:: 액세스가 허용된 자원(image, js, css 등)에 대해서도 위 규칙을 제외해야 합니다.

.. _urls-remove-index-php-nginx:

NGINX
-----

NGINX에서 ``location`` 블록을 정의하고 ``try_files`` 지시문을 사용하면 위의 Apache 구성과 동일한 효과를 얻을 수 있습니다.

.. code-block:: nginx

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }


먼저 URI와 일치하는 파일 또는 디렉토리(루트 및 별칭 지시문 설정에서 각 파일의 전체 경로 구성)를 찾은 후, 인수와 함께 요청을 index.php 파일로 보냅니다.
