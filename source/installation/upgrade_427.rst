#############################
Upgrading from 4.2.6 to 4.2.7
#############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer 설치 - App Starter 업그레이드 <app-starter-upgrading>`
- :ref:`Composer 설치 - 기존 프로젝트의 CodeIgniter4 업그레이드 <adding-codeigniter4-upgrading>`
- :ref:`수동 설치 업그레이드 <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

Breaking Changes
****************

set_cookie()
============

버그로 인해 이전 버전의 :php:func:`set_cookie()`\ 와 :php:meth:`CodeIgniter\\HTTP\\Response::setCookie()`\ 는 ``Config\Cookie``\ 의 ``$secure``\ 와 ``$httponly`` 값를 사용하지 않았습니다.
다음 코드는 ``Config\Cookie``\ 에서 ``$secure = true``\ 를 설정하더라도 secure 플래그가 있는 쿠키를 발행하지 않았습니다.

::

    helper('cookie');

    $cookie = [
        'name'  => $name,
        'value' => $value,
    ];
    set_cookie($cookie);
    // or
    $this->response->setCookie($cookie);

하지만 이제 ``Config\Cookie``\ 의 값은 지정되지 않은 옵션에 사용됩니다.
위의 코드는 ``Config\Cookie``\ 에서 ``$secure = true``\ 를 설정하면 secure 플래그가 있는 쿠키를 발행합니다.

코드가 이 버그에 의존하는 경우 필요한 옵션을 명시적으로 지정하도록 변경하십시오.

::

    $cookie = [
        'name'     => $name,
        'value'    => $value,
        'secure'   => false, // Set explicitly
        'httponly' => false, // Set explicitly
    ];
    set_cookie($cookie);
    // or
    $this->response->setCookie($cookie);

Others
======

- ``Time::__toString()``\ 은 이제 로케일에 독립적입니다. 모든 로케일에서 '2022-09-07 12:00:00'\ 과 같은 데이터베이스 호환 문자열을 반환합니다. 대부분의 로케일은 이 변경의 영향을 받지 않습니다. 그러나 `ar`, `fa`, ``Time::__toString()``\ (또는 ``(string) $time`` 또는 문자열로 암시적 캐스팅)\ 과 같은 일부 로케일에서는 더 이상 현지화된 날짜/시간 문자열을 반환하지 않습니다. 현지화된 날짜/시간 문자열을 얻으려면 :ref:`Time::toDateTimeString() <time-todatetimestring>`\ 을 사용하세요.
- 검증 규칙 ``required_without``\ 은 별표(``*``)가 있는 필드를 검증할 때 각 배열 항목을 개별적으로 검증하도록 변경되었으며, 규칙 메소드의 메소드 서명도 변경되었습니다. 확장 클래스는 마찬가지로 LSP를 손상시키지 않도록 매개변수를 업데이트해야 합니다.

Project Files
*************

버전 ``4.2.7``\ 은 프로젝트 파일의 실행 코드를 변경하지 않았습니다.

All Changes
===========

다음은 **프로젝트 공간**\ 에서 변경사항이 있는 모든 파일의 목록입니다. 대부분은 런타임에 영향을 미치지 않는 간단한 주석 또는 형식입니다.

* app/Common.php
