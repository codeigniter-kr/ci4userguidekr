####################
테스트 데이터 생성
####################

어플리케이션에서 테스트를 실행하려면 샘플 데이터가 필요합니다.
``Fabricator`` 클래스는 fzaninotto의 `Faker <https://github.com/FakerPHP/Faker>`_\ 를 사용하여 모델을 임의의 데이터 생성기로 변환합니다.
시드 또는 테스트 케이스에서 조작자를 사용하여 단위 테스트를 위한 테스트 데이터를 준비할 수 있습니다.

.. contents::
    :local:
    :depth: 2

지원되는 모델
================

``Fabricator``\ 는 프레임워크의 핵심 모델인 ``CodeIgniter\Model``\ 를 확장하는 모든 모델을 지원합니다.
사용자 정의 모델은 ``CodeIgniter\Test\Interfaces\FabricatorModel``\ 을 구현하여 사용할 수 있습니다.

.. literalinclude:: fabricator/001.php

.. note:: 메소드외에도 인터페이스는 대상 모델에 필요한 몇 가지 속성을 간략히 설명합니다. 자세한 내용은 인터페이스 코드를 참조하시기 바랍니다.

패브리케이터(Fabricator) 로딩
==============================

기본적으로 패브리케이터(fabricator)는 모델을 사용하여 작업을 수행합니다.

.. literalinclude:: fabricator/002.php

매개 변수는 모델 이름을 지정하는 문자열 또는 모델 자체의 인스턴스일 수 있습니다.

.. literalinclude:: fabricator/003.php

포맷터(Formatter) 정의
========================

Faker는 포맷터에서 요청하여 데이터를 생성합니다. 포맷터가 정의되어 있지 않으면 ``Fabricator``\ 는 필드 이름과 모델이 나타내는 속성을 기반으로 ``$fabricator->defaultFormatter``\ 로 돌아 가면서 가장 적합한 맞춤을 시도합니다.
필드 이름이 일반적인 포맷터와 일치하거나 필드 내용에 큰 관심이 없는 경우 이렇게 해도 되지만, 대부분의 경우 생성자의 두 번째 매개 변수로 사용할 포맷터를 지정합니다.

.. literalinclude:: fabricator/004.php

패브리케이터가 초기화된 후 ``setFormatters()`` 메소드를 사용하여 포맷터를 변경할 수도 있습니다.

고급 포매팅
--------------

때때는 포맷터의 기본 반환 데이터만으로는 충분하지 않을 수 있습니다. Faker는 대부분의 포맷터에 대한 매개 변수를 사용하여 랜덤 데이터의 범위를 추가로 제한할 수 있습니다. 
패브리케이터는 대표 모델에서 ``fake()`` 메서드를 확인하여 가짜 데이터가 어떻게 생겼는지 정확히 정의할 수 있습니다.

.. literalinclude:: fabricator/005.php

이 예의 처음 세 값(first, email, phone)은 이전 포맷터와 같습니다. 
그러나 ``avatar``\ 의 경우 기본 크기 이외의 이미지 크기를 요청했고 ``login``\ 은 앱 구성에 따라 조건부로 사용되며, 이 두 가지 모두 ``$formatters`` 매개 변수를 사용할 수 없습니다.
테스트 데이터를 프로덕션 모델과 별도로 유지하려면 테스트 지원 폴더에 하위 클래스를 정의하는 것이 좋습니다.

.. literalinclude:: fabricator/006.php

Localization
============

Faker는 다양한 로케일을 지원합니다.
로케일을 지원하는 공급자는 해당 문서를 확인하십시오. 
패브리케이터를 시작할 때 세 번째 매개 변수에 로케일을 지정합니다.

.. literalinclude:: fabricator/007.php

지정된 로케일이 없으면 **app/Config/App.php**\ 에 정의된 로케일을 ``defaultLocale``\ 로 사용합니다.
기존 패브리케이터의 로케일은 ``getLocale()`` 메소드를 사용하여 확인할 수 있습니다.


테스트 데이터
===============

패브리케이터가 제대로 초기화되었다면 ``make()`` 명령으로 테스트 데이터를 쉽게 생성할 수 있습니다.

.. literalinclude:: fabricator/008.php

아래와 같은 것을 얻을 수 있습니다

.. literalinclude:: fabricator/009.php


또한 수량를 제공하여 원하는 만큼의 테스트 데이터를 얻을 수 있습니다

.. literalinclude:: fabricator/010.php

``make()``\ 의 반환 유형은 대표 모델에 정의된 것과 유사하지만 메소드를 사용하여 유형을 강제할 수 있습니다.

.. literalinclude:: fabricator/011.php

``make()``\ 로 반환된 데이터는 테스트에 사용되거나 데이터베이스에 삽입될 수 있습니다.
``Fabricator``\ 에는 데이터베이스에 데이터를 삽입하고 결과를 반환하는 ``create()`` 명령이 포함되어 있습니다. 
모델 콜백, 데이터베이스 형식, 기본 키와 같은 특수 키, 타임스탬프 등으로 인해 ``create()``의 반환 데이터는 ``make()``\ 와 다를 수 있으며, 아래와 같은 결과를 얻을 수 있습니다

.. literalinclude:: fabricator/012.php

``make()``\ 와 마찬가지로 일련의 객체를 삽입하고 반환할 수량을 제공할 수 있습니다.

.. literalinclude:: fabricator/013.php

마지막으로 데이터베이스 없이 전체 데이터베이스 개체로 테스트를 진행하는 경우가 있습니다. 
``create()``\ 는 두 번째 매개 변수를 사용하면 데이터베이스를 건드리지 않고 위의 추가 데이터베이스 필드로 객체를 반환하도록 객체를 속일수 있습니다.

.. literalinclude:: fabricator/014.php

테스트 데이터 지정
====================

생성된 데이터도 좋지만 포맷터 구성에 영향을 주지 않고 테스트에 사용할 특정 필드를 제공할 수도 있습니다. 
각 변형에 대해 새로운 패브리케이터를 만드는 대신 ``setOverrides()``\ 를 사용하여 모든 필드에 대한 값을 지정할 수 있습니다.

.. literalinclude:: fabricator/015.php

이제 ``make()``\ 나 ``create()``\ 로 생성되는 데이터는 항상 ``first`` 필드의 "Bobby"\ 를 사용할 것입니다.

.. literalinclude:: fabricator/016.php

``setOverrides()``\ 는 두 번째 매개 변수를 사용하여 영구적인 오버라이드여야 하는지 아니면 단일 작업에만 해당되어야 하는지 여부를 나타낼 수 있습니다.

.. literalinclude:: fabricator/017.php

첫 번째 반환 후 패브리케이터가 재정의를 사용하지 않습니다.

.. literalinclude:: fabricator/018.php

두 번째 매개 변수를 제공하지 않으면 전달된 값이 기본적으로 유지됩니다.

Test 헬퍼
===========

테스트에 일회용 가짜 객체(fake object)만 필요한 경우를 위해 테스트 헬퍼는 ``fake($model, $overrides, $persist = true)``\ 함수를 제공합니다.

.. literalinclude:: fabricator/019.php

위는 다음과 동일합니다.

.. literalinclude:: fabricator/020.php

데이터베이스에 저장하지 않고 가짜 개체만 필요한 경우 매개 변수 $persist에 false를 전달합니다.

테이블 카운트
================

가짜(fake) 데이터는 다른 가짜 데이터에 의존하는 경우가 많습니다. 
``Fabricator``\ 는 각 테이블에 대해 사용자가 만든 가짜 항목의 수를 정적으로 계산합니다. 
예를 들어 보겠습니다.

프로젝트에는 사용자와 그룹이 있습니다.
테스트 사례에서는 크기가 다른 그룹을 사용하여 다양한 시나리오를 만들려고 하므로 ``Fabricator``\ 를 사용하여 여러 그룹을 만듭니다.
가짜 사용자를 만들지만 존재하지 않는 그룹 ID를 할당하지 않습니다.
모델의 fake 메소드는 다음과 같습니다.

.. literalinclude:: fabricator/021.php

이제 ``$user = fake(UserModel::class);``\ 로 새 사용자를 생성하면 유효한 그룹의 속하게 됩니다.

Methods
-------

``Fabricator``\ 는 내부적으로 카운트를 처리하지만 이러한 정적 메소드에 액세스하여 카운트 사용을 지원할 수도 있습니다.

getCount(string $table): int
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

특정 테이블의 현재 값을 반환합니다. (기본값 : 0)

setCount(string $table, int $count): int
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

최종 카운트에 포함시킬 Fabricator를 사용하지 않고 ,일부 테스트 항목을 생성하는 경우처럼 특정 테이블의 값을 수동으로 설정합니다.

upCount(string $table): int
^^^^^^^^^^^^^^^^^^^^^^^^^^^

특정 테이블의 값을 하나씩 증가시키고 새 값을 반환합니다. (``Fabricator::create()``\ 와 함께 내부적으로 사용됩니다.)

downCount(string $table): int
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

특정 테이블의 값을 1씩 줄이고 새 값을 반환합니다.
가짜 항목을 삭제하지만 변경 내용을 추적하고자 하는 경우 사용합니다.

resetCounts()
^^^^^^^^^^^^^

모든 카운트를 재설정합니다. 테스트 케이스를 전환할 때 이를 호출하는 것이 좋습니다.
(``CIUnitTestCase::$refresh=true`` 로 설정하면 자동으로 수행)
