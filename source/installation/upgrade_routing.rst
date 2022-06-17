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

- CI4에서 자동 라우팅은 기본적으로 비활성화되어 있습니다.
- CI4에서 더 안전한 새로운 :ref:`auto-routing-improved`\ 가 도입되었습니다.
- CI4에서는 배열로 경로를 설정하여 라우팅을 구성하지 않습니다.

Upgrade Guide
=============

1. CI3와 같은 방식으로 Auto Routing을 사용하는 경우 :ref:`auto-routing`\ 을 활성화해야 합니다.
2. 각 라우팅 라인의 CI4 형식으로 구문을 변경하고 **app/Config/Routes.php**\ 에 추가해야 합니다.

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
