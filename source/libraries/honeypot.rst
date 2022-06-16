=====================
허니팟 클래스
=====================

``Application\Config\Filters.php`` 파일의 허니팟 클래스를 활성화하면 봇(Bot)이 CodeIgniter4 어플리케이션에 요청하는 시점을 결정할 수 있습니다.
이것은 모든 폼(form)에 허니팟 폼 필드를 첨부하여 수행되며, 사람에게 숨겨져 있는 이 필드를 봇이 액세스하여 데이터를 입력한 요청에 대해 봇(Bot)에서 온 것으로 가정하고 ``HoneypotException``\ 을 던집니다.

.. contents::
    :local:
    :depth: 2

허니팟 활성화
=====================

허니팟을 활성화하려면 ``app/Config/Filters.php``\ 를 변경해야 합니다. 다음과 같이 ``$globals`` 배열의 허니팟의 주석 처리를 제거하십시오.

.. literalinclude:: honeypot/001.php

샘플 Honeypot 필터는 번들로 제공되며, ``system/Filters/Honeypot.php``\ 입니다.
직접 만든 필터를 사용하려면 ``app/Filters/Honeypot.php``\ 에 만들고 구성(config)의 ``$aliases``\ 를 적절하게 수정하십시오.

허니팟 커스터마이징
========================

허니팟은 직접 만들수 있습니다. 
아래 필드는 ``app/Config/Honeypot.php`` 또는 ``.env``\ 에서 설정할 수 있습니다.

* ``hidden`` - true|false 허니팟 필드의 가시성(hidden) 제어; 기본값은 ``true``
* ``label`` - 허니팟 필드의 HTML 레이블, 기본값은 'Fill This Field'
* ``name`` - 템플릿에 사용된 HTML 양식 필드의 이름. 기본값은 'honeypot'
* ``template`` - 허니팟에 사용되는 양식 필드 템플릿; 기본값은 '<label>{label}</label><input type="text" name="{name}" value=""/>'
