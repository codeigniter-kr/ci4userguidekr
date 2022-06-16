Upgrade Routing
##################

.. contents::
    :local:
    :depth: 2

Documentations
==============

- `CodeIgniter 3.X URI Routing 문서 <http://codeigniter.com/userguide3/general/routing.html>`_
- :doc:`CodeIgniter 4.X URI Routing 문서 </incoming/routing>`

변경된 사항
=====================
- CI4에서는 배열로 경로를 설정하여 라우팅을 구성하지 않습니다.

Upgrade Guide
=============
1. 각 라우팅 라인의 구문을 CI4 형식으로 변경하여 **app/Config/Routes.php**\ 에 추가합니다.

    - ``$route['journals'] = 'blogs';``\ 는 ``$routes->add('journals', 'Blogs::index');``\ 로 변경. 이는 ``Blogs`` 클래스의 ``index()`` 메소드로 매핑(mapping) 합니다.
    - ``$route['product/(:any)'] = 'catalog/product_lookup';``\ 는 ``$routes->add('product/(:any)', 'Catalog::productLookup');``\ 로 변경
    - ``$route['login/(.+)'] = 'auth/login/$1';``\ 는 ``$routes->add('login/(.+)', 'Auth::login/$1');`` \ 로 변경

Code Example
============

CodeIgniter Version 3.x
------------------------
Path: **application/config/routes.php**


.. literalinclude:: upgrade_routing/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------
Path: **app/Config/Routes.php**

.. literalinclude:: upgrade_routing/001.php
