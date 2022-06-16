#############################
Upgrading from 4.1.4 to 4.1.5
#############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer Installation App Starter Upgrading <app-starter-upgrading>`
- :ref:`Composer Installation Adding CodeIgniter4 to an Existing Project Upgrading <adding-codeigniter4-upgrading>`
- :ref:`Manual Installation Upgrading <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

Breaking Changes
================

BaseBuilder 및 Model 클래스의 set() 메소드 변경
-------------------------------------------------------

매개 변수 ``$value``\ 에 대한 캐스팅은 ``set()`` 메소드에 배열과 문자열 전달 방식이 다르게 처리되는 버그를 수정하기 위해 제거되었습니다.
``BaseBuilder`` 클래스나 ``Model`` 클래스를 직접 확장하고 ``set()`` 메소드를 수정했다면, ``public function set($key, ?string $ value = '', ?bool $escape = null)``\ 을 ``public function set($key, $value = '', ?bool $escape = null)``\ 로 변경합니다.

세션 DatabaseHandler의 데이터베이스 테이블 변경
------------------------------------------------

최적화를 위해 세션 테이블의 다음 열(column) 유형이 변경되었습니다.


- MySQL
    - ``timestamp``
- PostgreSQL
    - ``ip_address``
    - ``timestamp``
    - ``data``

세션 테이블의 정의를 업데이트합니다. :doc:`/libraries/sessions`\ 을 참조하십시오.

이 변경사항은 v4.1.2에서 소개되었습니다. 그러나 `버그 <https://github.com/codeigniter4/CodeIgniter4/issues/4807>`_\ 로 인해 데이터베이스 핸들러 드라이버가 제대로 작동하지 않았습니다.

CSRF 보호
---------------

CSRF 필터를 적용하면 버그 수정으로 인해 CSRF 보호는 **POST**\ 뿐만 아니라 **PUT/PATCH/DELETE** 요청에도 작동합니다.

**PUT/PATCH/DELETE** 요청을 사용하는 경우 CSRF 토큰을 전송해야 합니다. 요청에 대해 CSRF 보호가 필요하지 않은 경우 해당 요청에 대한 CSRF 필터를 제거하십시오.

이전 버전과 동일한 동작을 원한다면 **app/Config/Filters.php**\ 에서 CSRF 필터를 다음과 같이 설정합니다.

.. literalinclude:: upgrade_415/001.php

**GET** 메소드 보호는 ``form_open()``\ 에 의한 CSRF 필드 자동 생성을 사용하는 경우에만 필요합니다.

.. Warning:: 일반적으로 ``$methods`` 필터를 사용하는 경우  :ref:`disable auto-routing <use-defined-routes-only>`\ 을 수행해야 합니다.
    자동 라우팅은 모든 HTTP 메서드가 컨트롤러에 액세스할 수 있도록 허용하기 때문입니다.
    예상하지 못한 방법으로 컨트롤러에 액세스하면 필터를 우회할 수 있습니다.

CURLRequest 헤더 변경
-------------------------

이전 버전에서는 헤더를 제공하지 않은 경우 ``CURLRquest``\ 가 브라우저의 요청 헤더를  보냅니다.
그 버그는 수정되었습니다. 요청이 헤더에 종속된 경우 업그레이드 후 요청이 실패할 수 있습니다.
이 경우 필요한 헤더를 수동으로 추가합니다.
추가하는 방법에 대해서는 :ref:`CURLRequest Class <curlrequest-request-options-headers>`\ 를 참조하십시오.

쿼리 빌더 변경
---------------------

최적화 및 버그 수정을 위해 테스트에 주로 사용되는 동작이 다음과 같이 변경되었습니다.

- ``insertBatch()``\ 와 ``updateBatch()``\ 를 사용할 때 ``$query->getOriginalQuery()``\ 의 반환 값이 변경되었습니다. 더 이상 바인딩된 매개 변수로 쿼리를 반환하지 않고 실행된 실제 쿼리를 반환합니다.
- ``testMode``\ 가 ``true``\ 이면 ``insertBatch()``\ 는 영향을 받는 행 수 대신 SQL 문자열 배열을 반환합니다. 반환된 데이터 유형이 ``updateBatch()`` 메소드와 동일하도록 변경되었습니다.

Breaking Enhancements
=====================

.. _upgrade-415-multiple-filters-for-a-route:

경로에 대한 다중 필터
----------------------------

경로에 대해 다중 필터를 설정하는 새로운 기능입니다.

.. important:: 이 기능은 기본적으로 비활성화되어 있습니다. 역호환성을 깨기 때문입니다.

If you want to use this, you need to set the property ``$multipleFilters`` ``true`` in ``app/Config/Feature.php``.
If you enable it
이 기능을 사용하려면 ``app/Config/Feature.php``\ 파일에서 ``$multipleFilters`` 속성을 ``true``\ 로 설정해야 합니다.
활성화되면

- ``CodeIgniter\CodeIgniter::handleRequest()`` 사용
    - ``enableFilter()`` 대신 ``CodeIgniter\Filters\Filters::enableFilters()``\ 를 사용합니다.
- ``CodeIgniter\CodeIgniter::tryToRouteIt()`` 사용
    - ``getFilter()`` 대신 ``CodeIgniter\Router\Router::getFilters()``\ 를 사용합니다.
- ``CodeIgniter\Router\Router::handle()``\ 사용
    - 속성 ``$filterInfo`` 대신 ``$filtersInfo``\ 를 사용합니다.
    - ``getFilterForRoute()`` 대신 ``CodeIgniter\Router\RouteCollection::getFiltersForRoute()``\ 를 사용합니다.

위의 클래스를 확장했다면 변경해야 합니다.

다음 메서드와 속성은 더 이상 사용되지 않습니다.

- ``CodeIgniter\Filters\Filters::enableFilter()``
- ``CodeIgniter\Router\Router::getFilter()``
- ``CodeIgniter\Router\RouteCollection::getFilterForRoute()``
- ``CodeIgniter\Router\RouteCollection``'s property ``$filterInfo``

각 기능에 대해서는 :ref:`applying-filters`\ 를 참조하십시오.

Project Files
=============

프로젝트 공간에 있는 수많은 파일(루트, 앱, 공용, 쓰기 가능)이 업데이트를 받았습니다.
이러한 파일은 **시스템** 범위를 벗어났기 때문에 사용자의 개입 없이는 변경되지 않습니다.
프로젝트 공간의 변경 사항을 병합하는 데 도움이 되는 타사 CodeIgniter 모듈은 `Packagist <https://packagist.org/explore/?query=codeigniter4%20updates>`_\ 에서 찾을 수 있습니다.

.. note:: 버그 수정에 대한 매우 드문 경우를 제외하고 프로젝트 공간의 파일을 변경해도 응용 프로그램이 손상되지 않습니다.
    여기에 명시된 모든 변경 사항은 다음 주요 버전까지 선택 사항이며, 필수 변경 사항은 위의 섹션에서 다룹니다.

Content Changes
---------------

다음 파일에는 중요한 변경 사항(더 이상 사용되지 않음 또는 시각적 조정 포함)이 있으므로 업데이트된 버전을 응용 프로그램과 병합하는 것이 좋습니다.

* ``app/Config/CURLRequest.php``
* ``app/Config/Cache.php``
* ``app/Config/Feature.php``
* ``app/Config/Generators.php``
* ``app/Config/Publisher.php``
* ``app/Config/Security.php``
* ``app/Views/welcome_message.php``

All Changes
-----------

다음은 프로젝트 공간에서 변경사항이 있는 모든 파일의 목록입니다. 대부분은 런타임에 영향을 미치지 않는 간단한 주석 또는 형식입니다.

* ``app/Config/CURLRequest.php``
* ``app/Config/Cache.php``
* ``app/Config/Feature.php``
* ``app/Config/Generators.php``
* ``app/Config/Kint.php``
* ``app/Config/Publisher.php``
* ``app/Config/Security.php``
* ``app/Views/welcome_message.php``
