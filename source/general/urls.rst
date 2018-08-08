################
CodeIgniter URLs
################

By default, URLs in CodeIgniter are designed to be search-engine and human-friendly. Rather than using the standard
"query-string" approach to URLs that is synonymous with dynamic systems, CodeIgniter uses a **segment-based** approach
기본적으로 CodeIgniter의 URL은 검색 엔진이며 사용자에게 친숙하도록 설계되었습니다. CodeIgniter는 동적 시스템과 동의어 인 URL에 표준 "쿼리 문자열"방식을 사용하는 대신 세그먼트 기반 방식을 사용합니다.

::

	example.com/news/article/my_article

URI Segments
============

The segments in the URL, in following with the Model-View-Controller approach, usually represent
URL의 세그먼트는 Model-View-Controller 방식을 사용하여 다음과 같이 나타납니다.

::

	example.com/class/method/ID

1. The first segment represents the controller **class** that should be invoked.
   첫 번째 세그먼트는 호출해야하는 컨트롤러 클래스 를 나타냅니다 .
2. The second segment represents the class **method** that should be called.
   두 번째 부분은 호출해야하는 클래스 메소드 를 나타냅니다.
3. The third, and any additional segments, represent the ID and any variables that will be passed to the controller.
   세 번째 세그먼트와 추가 세그먼트는 컨트롤러에 전달 될 ID와 변수를 나타냅니다.

The :doc:`URI Library <../libraries/uri>` and the :doc:`URL Helper <../helpers/url_helper>` contain functions that make it easy
to work with your URI data. In addition, your URLs can be remapped using the :doc:`URI Routing <routing>`
feature for more flexibility.
URI 도서관 과 URL 도우미는 쉽게 당신의 URI의 데이터로 작업 할 수 있도록 기능이 포함되어 있습니다. 또한 URL 라우팅 기능을 사용하여 보다 유연하게 URL을 다시 매핑 할 수 있습니다 .

index.php 파일 제거하기
===========================

By default, the **index.php** file will be included in your URLs
기본적으로 index.php 파일은 URL에 포함됩니다.

::

	example.com/index.php/news/article/my_article

If your server supports rewriting URLs you can easily remove this file with URL rewriting. This is handled differently
by different servers, but we will show examples for the two most common web servers here.
서버가 URL 재 작성을 지원하면 URL 재 작성으로이 파일을 쉽게 제거 할 수 있습니다. 이것은 다른 서버에 의해 다르게 처리되지만 여기서는 가장 일반적인 두 개의 웹 서버에 대한 예제를 보여줍니다.

Apache Web Server
-----------------

Apache must have the *mod_rewrite* extension enabled. If it does, you can use a ``.htaccess`` file with some simple rules.
Here is an example of such a file, using the "negative" method in which everything is redirected except the specified
items:
Apache는 mod_rewrite 확장을 활성화 해야합니다 . 그렇다면 .htaccess간단한 규칙 으로 파일을 사용할 수 있습니다 . 다음은 "negative"메소드를 사용하여 지정된 항목을 제외한 모든 경로가 리디렉션되는 이러한 파일의 예입니다.

.. code-block:: apache

	RewriteEngine On
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteCond %{REQUEST_FILENAME} !-d
	RewriteRule ^(.*)$ index.php/$1 [L]

In this example, any HTTP request other than those for existsing directories and existing files is treated as a
request for your index.php file.
이 예제에서 존재하는 디렉토리 및 기존 파일에 대한 것 이외의 HTTP 요청은 index.php 파일에 대한 요청으로 처리됩니다.

.. note:: These specific rules might not work for all server configurations.
		  이러한 특정 규칙은 모든 서버 구성에서 작동하지 않을 수 있습니다.

.. note:: Make sure to also exclude from the above rules any assets that you might need to be accessible from the outside world.
		  외부 세계에서 접근 할 필요가있는 자산도 위의 규칙에서 제외하십시오.

NGINX
-----

Under NGINX, you can define a location block and use the ``try_files`` directive to get the same effect as we did with
the above Apache configuration:
NGINX에서는 위치 블록을 정의하고 try_files지시문을 사용 하여 위의 Apache 구성에서와 같은 결과를 얻을 수 있습니다.

.. code-block:: nginx

	location / {
		try_files $uri $uri/ /index.php/$args;
	}

This will first look for a file or directory matching the URI (constructing the full path to each file from the
settings of the root and alias directives), and then sends the request to the index.php file along with any arguments.
그러면 URI (루트 및 별칭 지시어의 설정에서 각 파일의 전체 경로를 구성하는)와 일치하는 파일 또는 디렉토리를 먼저 찾은 다음 인수를 사용하여 index.php 파일에 요청을 전송합니다.
