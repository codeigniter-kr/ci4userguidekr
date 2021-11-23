Upgrade Routing
##################

.. contents::
    :local:
    :depth: 1


Documentations
==============

- `Codeigniter 3.X URI Routing 문서 <http://codeigniter.com/userguide3/general/routing.html>`_
- :doc:`Codeigniter 4.X URI Routing 문서 </incoming/routing>`


변경된 사항
=====================
- CI4에서는 배열로 경로를 설정하여 라우팅을 구성하지 않습니다.

Upgrade Guide
=============
1. 각 라우팅 라인의 구문을 CI4 형식으로 변경하여 ``app/Config/Routes.php``\ 에 추가합니다.

- ``$route['journals'] = 'blogs';``\ 를 ``$routes->add('journals', 'App\Blogs');``\ 로 : ``Blogs`` 클래스의 ``index()`` 메소드로 매핑(mapping)
- ``$route['product/(:any)'] = 'catalog/product_lookup';``\ 를 ``$routes->add('product/(:any)', 'Catalog::productLookup');``\ 로
- ``$route['login/(.+)'] = 'auth/login/$1';``\ 를 ``$routes->add('login/(.+)', 'Auth::login/$1');`` \ 로

Code Example
============

Codeigniter Version 3.11
------------------------
Path: ``application/config/routes.php``::

    <?php
    defined('BASEPATH') OR exit('No direct script access allowed');

    $route['posts/index'] = 'posts/index';
    $route['teams/create'] = 'teams/create';
    $route['teams/update'] = 'teams/update';

    $route['posts/create'] = 'posts/create';
    $route['posts/update'] = 'posts/update';
    $route['drivers/create'] = 'drivers/create';
    $route['drivers/update'] = 'drivers/update';
    $route['posts/(:any)'] = 'posts/view/$1';

Codeigniter Version 4.x
-----------------------
Path: ``app/Config/Routes.php``::

    <?php

    namespace Config;

    // Create a new instance of our RouteCollection class.
    $routes = Services::routes();

    // Load the system's routing file first, so that the app and ENVIRONMENT
    // can override as needed.
    if (file_exists(SYSTEMPATH . 'Config/Routes.php')) {
        require SYSTEMPATH . 'Config/Routes.php';
    }

    ...

    $routes->add('posts', 'Posts::index');
    $routes->add('teams/create', 'Teams::create');
    $routes->add('teams/edit/(:any)', 'Teams::edit/$1');

    $routes->add('posts/create', 'Posts::create');
    $routes->add('posts/edit/(:any)', 'Posts::edit/$1');
    $routes->add('drivers/create', 'Drivers::create');
    $routes->add('drivers/edit/(:any)', 'Drivers::edit/$1');
    $routes->add('posts/(:any)', 'Posts::view/$1');
