##########################
스로틀러(Throttler)
##########################

.. contents::
    :local:
    :depth: 2

Throttler 클래스는 일정 기간 동안 특정 횟수의 시도로 수행할 활동을 제한하는 매우 간단한 방법을 제공합니다.
API에 대해 속도 제한을 수행하거나 무차별 대입 공격을 방지하기 위해 사용자가 양식에 대해 시도할 수있는 횟수를 제한하는데 가장 많이 사용됩니다.
클래스 자체는 설정된 시간 간격내 동작을 기반으로 조절해야 하는 모든 항목에 사용할 수 있습니다.

********
개요
********

Throttler는 `Token Bucket <https://en.wikipedia.org/wiki/Token_bucket>`_ 알고리즘의 단순화된 버전을 구현합니다.
기본적으로 원하는 각 작업을 버킷으로 처리합니다. 
``check()`` 메소드를 호출하면 버킷의 크기, 보유할 수 있는 토큰 수 및 시간 간격을 알려줍니다.
각 ``check()`` 호출은 기본적으로 사용 가능한 토큰중 하나를 사용합니다. 
이를 명확하게하기 위해 예제를 살펴 보겠습니다.

우리가 매 초마다 한 번씩 행동(action)을 원한다고 가정해 봅시다.
Throttler에 대한 첫 번째 호출은 다음과 같습니다.
첫 번째 매개 변수는 버킷 이름이고, 두 번째 매개 변수는 버킷이 보유하는 토큰 수이며, 세 번째 매개 변수는 버킷을 채우는 데 걸리는 시간입니다.

.. literalinclude:: throttler/001.php

여기서는 좀 더 읽기 쉽도록 :doc:`global constants </general/common_functions>`\ 중 하나를 사용하고 있습니다.
버킷은 1분에 60개의 동작 또는 1초에 1개의 동작을 허용합니다.

타사 스크립트가 URL을 반복해서 누르려고 한다고 가정해 보겠습니다. 처음에는 1초 안에 60개의 토큰을 모두 사용할 수 있습니다.
그러나 그 후 Throttler는 초당 하나의 작업만 허용하므로 공격이 더 이상 가치가 없을 정도로 요청 속도가 느려집니다.

.. note:: Throttler 클래스가 작동하려면 더미 이외의 핸들러를 사용하도록 캐시 라이브러리를 설정해야합니다.
    최상의 성능을 위해서는 Redis 또는 Memcached와 같은 인-메모리(in-memory) 캐시가 권장됩니다.

*************
속도 제한
*************

Throttler 클래스는 자체적으로 속도 제한이나 요청 제한을 수행하지 않지만 하나의 작업을 수행하는 열쇠입니다.
매우 간단한 속도 제한을 구현하는 IP 주소별 1초당 1요청 예제 :doc:`Filter </incoming/filters>`\ 가 제공됩니다.
여기서는 작동 방식과 어플리케이션에서 설정과 사용을 시작하는 방법을 설명합니다.

Code
========

**app/Filters/Throttle.php**\ 에 Throttler 필터를 직접 만들 수 있습니다.

.. literalinclude:: throttler/002.php

실행될 때 이 메소드는 먼저 스로틀러 인스턴스를 가져옵니다.
그런 다음 IP 주소를 버킷 이름으로 사용하여 초당 하나의 요청으로 제한하도록 설정합니다.
스로틀러가 검사를 거부하고 false를 반환하면 상태 코드가 ``429-Too Many Attempts``\ 로 설정된 응답을 반환하고, 스크립트 실행이 컨트롤러에 도달하기 전에 종료됩니다.
이 예는 페이지 당이 아니라 사이트의 모든 요청에 대해 단일 IP 주소를 기반으로 조절됩니다.

필터 적용
===================

사이트의 모든 페이지를 반드시 조절할 필요는 없습니다.
많은 웹 어플리케이션에서는 POST 요청에만 적용하는 것이 가장 적합하지만, API는 사용자의 모든 요청을 제한하고자 할 수 있습니다.
수신 요청에 이를 적용하려면 먼저 필터에 별명(alias)을 **/app/Config/Filters.php**\ 에 추가해야 합니다.

.. literalinclude:: throttler/003.php

그런 다음, 사이트의 모든 POST 요청에 대해 필터를 적용합니다.

.. literalinclude:: throttler/004.php

.. Warning:: :ref:`auto-routing-legacy`\ 가 컨트롤러에 접근할 수 있는 모든 HTTP 메소드를 허용하기 때문에 ``$methods`` 필터를 사용할 경우, :ref:`Auto Routing (Legacy) <use-defined-routes-only>`\ 을 사용하지 않도록 설정해야 합니다.
    활성화되어 있는 상태에서는 예상하지 못한 방법으로 컨트롤러에 액세스하여 필터를 우회할 수 있습니다.

이제 설정이 끝났습니다. 사이트의 모든 POST 요청은 속도가 제한됩니다.

***************
Class Reference
***************

.. php:method:: check(string $key, int $capacity, int $seconds[, int $cost = 1])

    :param string $key: 버킷(bucket) 이름
    :param int $capacity: 버킷이 보유한 토큰 수
    :param int $seconds: 버킷이 완전히 채워지는데 걸리는 시간 (초)
    :param int $cost: 이 작업에 사용되는 토큰 수
    :returns: 작업을 수행할 수 있으면 true, 그렇지 않으면 FALSE
    :rtype: bool

    버킷 내에 남아있는 토큰이 있는지 또는 할당된 시간 제한 내에 너무 많은 토큰이 사용되었는지 확인합니다.
    매번 확인할 때마다 사용 가능한 토큰은 성공하면 ``$cost``\ 를 차감합니다.

.. php:method:: getTokentime()

    :returns: 다른 토큰을 사용할 수 있을 때까지의 시간(초)
    :rtype: integer

    ``check ()``\ 가 실행되고 false가 반환된 후 이 메소드를 사용하여 새 토큰을 사용할 수 있고, 조치를 다시 시도할 수있는 시간을 판별할 수 있습니다. 
    이 경우 최소 대기 시간은 1 초입니다.

.. php:method:: remove(string $key) : self

    :param string $key: 버킷의 이름
    :returns: $this
    :rtype: self

    버킷을 제거하거나 재설정합니다.
    버킷이 존재하지 않아도 실패하지 않습니다.
