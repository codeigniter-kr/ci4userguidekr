######################################
Upgrading from 4.1.1 to 4.1.2
######################################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer Installation App Starter Upgrading <app-starter-upgrading>`
- :ref:`Composer Installation Adding CodeIgniter4 to an Existing Project Upgrading <adding-codeigniter4-upgrading>`
- :ref:`Manual Installation Upgrading <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

**current_url() and indexPage**

``current_url()``\ 의 `버그 <https://github.com/codeigniter4/CodeIgniter4/issues/4116>`_\ 로 인해 결과 URI가 프로젝트 구성과 맞지 않을 수 있습니다.
가장 중요한 버그는 ``indexPage``\ 가 포함되지 *않는 것이라는 점*\ 입니다. 
``App::$indexPage``\ 를 사용하는 프로젝트에서는 ``current_url()`` 및 모든 종속성(Response Testing, Pager, Form Helper, Pager, View Parser) 에서 변경된 값을 예상해야 합니다.
그에 따라 프로젝트를 업데이트합니다.

**Cache Keys**

캐시 핸들러(handler)는 키에 대한 호환성이 크게 다릅니다.
업데이트된 캐시 드라이버는 이제 PSR-6의 권장 사항과 거의 일치하는 모든 키를 검증을 통해 전달합니다.

    키(kdy)는 캐시된 항목을 고유하게 식별하는 하나 이상의 문자열입니다.
    라이브러리 구현은 A-Z, a-z, 0-9, _, . 문자로 구성되며 UTF-8 인코딩 순서에 관계없이 길이는 최대 64자까지 가능합니다.
    라이브러리 구현은 추가 문자 및 인코딩 또는 더 긴 길이를 지원할 수 있지만 최소한 그 이상을 지원해야 합니다.
    라이브러리는 키 문자열을 적절하게 이스케이프(escap)해야 하지만 수정되지 않은 원래 키 문자열을 반환할 수 있어야 합니다.
    다음 문자 ``{}()/\@:``\ 는 이후 확장을 위해 예약되어 있으므로 라이브러리를 구현할 때 지원되지 않아야 합니다.

프로젝트를 업데이트하여 잘못된 캐시 키를 제거하십시오.

**BaseConnection::query() 반환 값**

이전 버전의 `BaseConnection::query()` 메소드는 쿼리가 실패하더라도 BaseResult 개체를 잘못 반환했습니다.
이 메서드는 이제 실패한 쿼리에 대해` `false``\ 를 반환하고(``DBDebug==true`` 인 경우 예외를 발생), 쓰기 유형 쿼리에 대해 부울(boolean)을 반환합니다.
``query()`` 메소드의 사용을 검토하고 값이 Result 개체 대신 부울인지 여부를 평가합니다.
어떤 쿼리가 쓰기 유형 쿼리인지에 대한 자세한 내용은 Connection 클래스의 ``BaseConnection :: isWriteType()`` 또는 DBMS 관련 재정의 ``isWriteType()``\ 을 확인하십시오.

**ConnectionInterface::isWriteType() 선언 추가**

ConnectionInterface를 구현하는 클래스를 작성한 경우 ``public function isWriteType($sql):bool``\ 로 선언 된 ``isWriteType()`` 메소드를 구현해야 합니다.
클래스가 BaseConnection을 확장하면 해당 클래스는 재정의할 수 있는 기본 ``isWriteType()`` 메소드를 제공합니다.


**Test Traits**

``CodeIgniter\Test`` 네임스페이스는 개발자들이 자체 테스트 사례를 활용할 수 있도록 크게 개선되었습니다.
특히 테스트 확장(extension)은 다양한 테스트 케이스 요구사항에 대해 쉽게 선택하고 선택할 수 있도록 특성(Trait)으로 이동했습니다.
``CIDatabaseTestCase``\ 와 ``FeatureTestCase`` 클래스는 더 이상 사용되지 않으며, 해당 메소드는 각각 ``DatabaseTestTrait``\ 과 ``FeatureTestTrait``\ 로 이동했습니다.
주요 테스트 케이스를 확장하고 필요한 특성(Trait)을 사용하도록 테스트 케이스를 업데이트하십시오.

.. literalinclude:: upgrade_412/001.php

... becomes

.. literalinclude:: upgrade_412/002.php

마지막으로, ``ControllerTester``\ 는 접근 방식을 표준화하고 업데이트된 응답 테스트를 활용하기 위해 ``ControllerTestTrait``\ 로 대체되었다.

**Test Responses**

Response 테스트 도구가 통합되고 개선되었습니다.
새로운 ``TestResponse``\ 는 ``ControllerResponse``\ 와 ``FeatureResponse`` 두 클래스 모두에서 예상되는 완전한 메소드와 속성 집합으로 대체합니다.
대부분의 경우 이러한 변경 사항은 ``ControllerTestTrait``\ 과 ``FeatureTestCase``\ 에 의해 "뒷단에서" 수행 되지만 두 가지 변경 사항은 알고 있어야 합니다.

* ``TestResponse``\ 의 ``$request``\ 와 ``$response`` 속성은 보호되며 ``request()``\ 와 ``response()`` 메소드를 통해서 액세스해야 합니다.
* ``TestResponse``\ 에  ``getBody()``\ 와 ``setBody()`` 메소드가 없지만 ``$body = $result->response()->getBody();``\ 와 같은 Response 메소드를 직접 사용합니다.


Project Files
=============

프로젝트에 포함된 수많은 파일(root, app, public, writable)이 업데이트 되었습니다.
이러한 파일들은 시스템 범위를 벗어나므로 사용자의 개입 없이 변경되지 않습니다.
프로젝트에 대한 변경 사항을 병합하는데 도움이 되는 타사 CodeIgniter 모듈 `Explore on Packagist <https://packagist.org/explore/?query=codeigniter4%20updates>`_\ 이 있습니다. 

.. note:: 매우 드문 버그 수정의 경우를 제외하고, 프로젝트의 파일을 변경해도 어플리케이션은 중단되지 않습니다.
    여기에 명시된 모든 변경 사항은 다음 주요 버전까지 선택 사항이며, 모든 필수 변경 사항은 위의 섹션에서 다룹니다.


Content Changes
---------------

다음 파일에 중요한 변경 사항(사용 중단 또는 시각적 개선 등)이 적용되었으며, 업데이트된 버전을 어플리케이션과 병합하는 것이 좋습니다.

* ``app/Config/App.php``
* ``app/Config/Autoload.php``
* ``app/Config/Cookie.php``
* ``app/Config/Events.php``
* ``app/Config/Exceptions.php``
* ``app/Config/Security.php``
* ``app/Views/errors/html/*``
* ``env``
* ``spark``

All Changes
-----------

프로젝트의 변경된 모든 파일 목록입니다.
대부분은 런타임에 영향을 미치지 않는 간단한 주석 또는 서식입니다.

* ``app/Config/App.php``
* ``app/Config/Autoload.php``
* ``app/Config/ContentSecurityPolicy.php``
* ``app/Config/Cookie.php``
* ``app/Config/Events.php``
* ``app/Config/Exceptions.php``
* ``app/Config/Logger.php``
* ``app/Config/Mimes.php``
* ``app/Config/Modules.php``
* ``app/Config/Security.php``
* ``app/Controllers/BaseController.php``
* ``app/Views/errors/html/debug.css``
* ``app/Views/errors/html/error_404.php``
* ``app/Views/errors/html/error_exception.php``
* ``app/Views/welcome_message.php``
* ``composer.json``
* ``contributing/guidelines.rst``
* ``env``
* ``phpstan.neon.dist``
* ``phpunit.xml.dist``
* ``public/.htaccess``
* ``public/index.php``
* ``rector.php``
* ``spark``
