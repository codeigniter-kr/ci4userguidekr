#######
테스트
#######

CodeIgniter는 프레임워크와 어플리케이션을 최대한 간단하게 테스트할 수 있도록 개발되었습니다.
`PHPUnit <https://phpunit.de/>`__\ 에 대한 지원이 내장되어 있으며 프레임워크는 어플리케이션의 모든 측면을 가능한 한 쉽게 테스트할 수 있는 편리한 헬퍼 메소드를 제공합니다.


.. contents::
    :local:
    :depth: 3

***************
시스템 설정
***************

PHPUnit 설치
==================

CodeIgniter는 `PHPUnit <https://phpunit.de/>`__\ 을 모든 테스트의 기준으로 사용합니다.
시스템에서 PHPUnit을 사용하기 위해 설치하는 두 가지 방법이 있습니다.

Composer
--------

권장되는 방법은 `Composer <https://getcomposer.org/>`__\ 를 사용하여 프로젝트에 설치하는 것입니다.
전역(global)으로 설치할 수는 있지만 시간이 지남에 따라 시스템의 다른 프로젝트와 호환성 문제가 발생할 수 있으므로 권장하지 않습니다.

시스템에 Composer가 설치되어 있는지 확인 후 프로젝트 루트(어플리케이션 및 시스템 디렉토리를 포함하는 디렉토리)의 커맨드 라인에 다음을 입력하십시오.

::

    > composer require --dev phpunit/phpunit

현재 PHP 버전에 맞는 버전이 설치됩니다. 
완료되면 다음을 입력하여 이 프로젝트에 대한 모든 테스트를 실행할 수 있습니다

::

    > ./vendor/bin/phpunit

Windows를 사용한다면 다음 명령을 사용하십시오.

::

    > vendor\bin\phpunit

Phar
----

다른 방법은 `PHPUnit <https://phpunit.de/getting-started/phpunit-9.html>`__ 사이트에서 .phar 파일을 다운로드하는 것입니다.
이것은 프로젝트 루트 내에 배치해야 하는 독립형 파일입니다.


************************
어플리케이션 테스트
************************

PHPUnit 구성
=====================

프레임워크에는 프로젝트 루트에 ``phpunit.xml.dist`` 파일이 있습니다.
이는 프레임워크 자체의 단위 테스트를 제어합니다. 
만약 당신이 자신만의 ``phpunit.xml``\ 을 제공하면 이를 무시합니다.

어플리케이션을 단위로 테스트하는 경우 ``phpunit.xml``\ 에서 ``system`` 폴더와 ``vendor`` 또는 ``ThirdParty`` 폴더를 제외해야합니다.


Test 클래스
==============

제공된 추가 도구를 이용하려면 테스트가 ``CIUnitTestCase``\ 를 확장해야 합니다.
모든 테스트는 기본적으로 **tests/app** 디렉토리에 있어야 합니다.

새 라이브러리 **Foo**\ 를 테스트하려면 **tests/app/Libraries/FooTest.php**\ 에 새 파일을 만듭니다.

.. literalinclude:: overview/001.php

모델 중 하나를 테스트하기 위해 **tests/app/Models/OneOfMyModelsTest.php**\ 에 다음과 같이 할 수 있습니다.

.. literalinclude:: overview/002.php

테스트 스타일/요건에 맞는 디렉토리 구조를 만들 수 있습니다. 
테스트 클래스의 이름을 지정할 때 **app** 디렉토리는 ``App`` 네임스페이스의 루트이므로 사용하는 모든 클래스는``App``\ 에 대해 올바른 네임스페이스를 가져야합니다.

.. note:: 네임스페이스는 테스트 클래스에 반드시 필요한 것은 아니지만 클래스 이름이 충돌하지 않도록 하는 데 도움이 됩니다.

데이터베이스 결과를 테스트할 때는 :doc:`DatabaseTestTrait <database>` 클래스를 사용해야 합니다.

Staging
-------

대부분의 테스트는 올바르게 실행하기 위해 약간의 준비가 필요합니다. 
PHPUnit의 ``TestCase``\ 는 준비 및 정리를 돕는 4가지 방법을 제공합니다

::

    public static function setUpBeforeClass(): void
    public static function tearDownAfterClass(): void

    protected function setUp(): void
    protected function tearDown(): void

정적 메소드 ``setUpBeforeClass()``\ 와 ``tearDownAfterClass()``\ 는 전체 테스트 케이스 전후에 실행되는 반면, 보호된 메소드 ``setUp()``\ 와 ``tearDown()``\ 은 각 테스트 사이에 실행됩니다. .
이러한 특수 기능을 구현하는 경우 확장된 테스트 케이스가 스테이징을 방해하지 않도록 상위 기능도 함께 실행해야 합니다.

.. literalinclude:: overview/003.php

Traits
------

테스트를 강화하는 일반적인 방법은 특성(trait)을 사용하여 여러 테스트 사례에서 스테이징을 통합하는 것입니다.
``CIUnitTestCase``\ 는 어떤 등급의 특성(trait)도 감지하고 특성(trait) 자체의 이름을 따서 실행할 스테이징 방법을 찾을 것입니다. (i.e. `setUp{NameOfTrait}()`\ 와 `tearDown{NameOfTrait}()`)
예를 들어 일부 테스트 케이스에 인증을 추가해야 하는 경우 로그인된 사용자를 위조하는 설정 방법을 사용하여 인증 특성(trait)을 생성할 수 있습니다.

.. literalinclude:: overview/006.php

추가 어설션(Assertion)
--------------------------

``CIUnitTestCase``\ 는 유용한 추가 단위 테스트 어설션을 제공합니다.

assertLogged($level, $expectedMessage)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

실제로 기록될 것으로 예상되는 것

.. literalinclude:: overview/007.php

assertEventTriggered($eventName)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

실제로 트리거될 것으로 예상되는 이벤트

.. literalinclude:: overview/008.php

assertHeaderEmitted($header, $ignoreCase = false)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

헤더 또는 쿠키가 실제로 방출되었는지 확인

.. literalinclude:: overview/009.php

.. note: 테스트 케이스는 `PHPunit에서 별도의 프로세스로 실행 <https://phpunit.readthedocs.io/en/9.5/annotations.html#runinseparateprocess>`_\ 되어야 합니다.

assertHeaderNotEmitted($header, $ignoreCase = false)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

헤더 또는 쿠키가 방출되지 않았는지 확인

.. literalinclude:: overview/010.php

.. note: 테스트 케이스는 `PHPunit에서 별도의 프로세스로 실행 <https://phpunit.readthedocs.io/en/9.5/annotations.html#runinseparateprocess>`_\ 되어야 합니다.

assertCloseEnough($expected, $actual, $message = '', $tolerance = 1)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

확장된 실행 시간 테스트의 경우 예상 시간과 실제 시간의 절대 차이가 규정된 허용 오차 내에 있는지 테스트합니다.

.. literalinclude:: overview/011.php

위의 테스트를 통해 실제 시간은 660 초 또는 661 초가 될 수 있습니다.

assertCloseEnoughString($expected, $actual, $message = '', $tolerance = 1)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

확장된 실행 시간 테스트의 경우 문자열 형식의 예상 시간과 실제 시간의 절대 차이가 규정된 허용 오차내에 있는지 테스트합니다.

.. literalinclude:: overview/012.php

위의 테스트를 통해 실제 시간은 660 초 또는 661 초가 될 수 있습니다.


Protected/Private 속성에 액세스
--------------------------------------

테스트할 때 다음 setter 및 getter 메소드를 사용하여 테스트중인 클래스의 Protected/Private 메소드 및 특성에 액세스할 수 있습니다.

getPrivateMethodInvoker($instance, $method)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

클래스 외부에서 private 메소드를 호출할 수 있습니다. 
이렇게 하면 호출할 수있는 함수를 반환합니다.
첫 번째 매개 변수는 테스트할 클래스의 인스턴스입니다. 
두 번째 매개 변수는 호출하려는 메소드의 이름입니다.

.. literalinclude:: overview/013.php

getPrivateProperty($instance, $property)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

클래스의 인스턴스에서 private/protected 클래스 속성 값을 검색합니다.
첫 번째 매개 변수는 테스트할 클래스의 인스턴스입니다.
두 번째 매개 변수는 속성 이름입니다.

.. literalinclude:: overview/014.php

setPrivateProperty($instance, $property, $value)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

클래스 인스턴스 내에서 private/protected 속성에 값을 설정합니다.
첫 번째 매개 변수는 테스트할 클래스의 인스턴스입니다.
두 번째 매개 변수는 값을 설정할 속성의 이름입니다.
세 번째 매개 변수는 설정할 값입니다.

.. literalinclude:: overview/015.php

모의(Moking) 서비스
=======================

**app/Config/Services.php**에 정의된 서비스 중 하나를 모의 실행하여 테스트를 문제의 코드로만 제한하고 서비스의 다양한 응답을 시뮬레이션해야 하는 경우가 종종 있습니다.
이는 컨트롤러와 기타 통합 테스트를 테스트할 때 특히 그렇습니다.
**Services** 클래스는 이를 단순화하는 다음 메소드를 제공합니다.

Services::injectMock()
----------------------

이 메소드를 사용하면 Services 클래스에서 리턴할 정확한 인스턴스를 정의할 수 있습니다.
이를 사용하여 특정 방식으로 동작하도록 서비스의 속성을 설정하거나 서비스를 모의 클래스로 바꿀 수 있습니다.

.. literalinclude:: overview/016.php

첫 번째 매개 변수는 교체할 서비스입니다. 
이름은 Services 클래스의 함수 이름과 정확히 일치해야합니다.
두 번째 매개 변수는 이를 대체할 인스턴스입니다.

Services::reset()
-----------------

서비스 클래스에서 모든 모의(mock) 클래스를 제거하여 원래 상태로 되돌립니다.

``CIUnitTestCase``\ 가 제공하는 ``$this->resetServices()`` 메소드를 사용할 수도 있습니다.

Services::resetSingle(string $name)
-----------------------------------

이름별로 단일 서비스에 대한 모의 및 공유 인스턴스를 제거합니다.

.. note:: ``Cache``, ``Email``, ``Session`` 서비스는 침입 테스트 동작을 방지하기 위해 기본적으로 모의 처리됩니다. 이 모의 처리를 방지하려면 클래스 속성 ``$setUpMethods = ['mockEmail', 'mockSession'];``\ 에서 메소드 콜백을 제거합니다;``

모의(Moking) Factory 인스턴스
==============================

서비스와 마찬가지로 테스트 중에 ``Factory``\ 와 함께 사용될 미리 구성된 클래스 인스턴스를 제공해야 할 수도 있습니다.
**Services**\ 와 같은 ``Factories::injectMock()`` 과 ``Factories::reset()`` 정적 메소드를 사용하지만 구성 요소 이름에 대해 선행 매개 변수를 추가로 사용합니다.

.. literalinclude:: overview/017.php
        
.. note:: 모든 구성 요소 팩토리는 각 테스트 사이에 기본적으로 재설정됩니다. 인스턴스를 유지해야하는 경우 테스트 케이스의 ``$setUpMethods``\ 를 수정합니다.

스트림(Stream) 필터
=========================

테스트하기 어려운 것을 테스트해야 할 수도 있습니다.
때로는 PHP 자체 STDOUT 또는 STDERR과 같은 스트림 캡처가 도움이 될 수 있습니다.
``CITestStreamFilter``\ 는 선택한 스트림의 출력을 캡처하는 데 도움이됩니다.

**CITestStreamFilter**\ 는 이러한 헬퍼 메소드의 대안을 제공합니다.


테스트 사례중 하나에서 이것을 보여주는 예제

.. literalinclude:: overview/018.php
