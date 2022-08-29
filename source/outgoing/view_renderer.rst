########################
뷰 랜더러(View Renderer)
########################

.. contents::
    :local:
    :depth: 2

뷰 랜더러 사용하기
***************************
``view()`` 함수는 ``renderer`` 서비스의 인스턴스를 가져와 데이터를 설정하고 뷰를 랜더링하는 편리한 함수입니다.
이것은 잘 동작하지만, 이것을 직접해야 할 경우가 있다면 View 서비스에 직접 액세스할 수 있습니다.

.. literalinclude:: view_renderer/001.php

또는 ``View`` 클래스를 기본 렌더러로 사용하지 않는다면 직접 인스턴스화할 수 있습니다

.. literalinclude:: view_renderer/002.php

.. important:: 컨트롤러 내에서만 서비스를 작성해야합니다. 라이브러리에서 View 클래스에 액세스해야 한다면, 라이브러리 생성자에서 종속성(dependency)으로 설정해야합니다.

그런 다음 제공하는 세 가지 표준 방법중 하나를 사용할 수 있습니다.:
**render(viewpath, options, save)**, **setVar(name, value, context)**, **setData(data, context)**.

랜더러가 하는 일
===================

``View`` 클래스는 스크립트내에서 액세스 할 수있는 PHP 변수로 뷰 매개 변수를 추출한 후 어플리케이션의 뷰 경로에 저장된 기존 HTML/PHP 스크립트를 처리합니다.
이것은 뷰 파라미터 이름이 유효한 PHP 변수명이어야 함을 의미합니다.

View 클래스는 연관 배열을 사용하여 ``render()``\ 를 호출할 때까지 뷰 매개 변수를 누적합니다.
이는 매개 변수(또는 변수) 이름이 고유해야 하거나, 나중에 설정된 변수가 같은 이름의 이전 변수보다 우선함을 의미합니다.

또한 스크립트 내부의 다른 컨텍스트에 대한 이스케이프 매개 변수값에 영향을 줍니다.
이스케이프된 각 값에 고유한 매개 변수 이름을 지정해야 합니다.

값이 배열인 매개 변수에 특별한 의미는 없습니다.
PHP 코드에서 배열을 적절하게 처리하는 것은 사용자의 책임입니다.

메소드 체이닝(Chaining)
===========================

``setVar()``\ 와 ``setData()`` 메소드는 체이닝이 가능하므로 여러 다른 호출을 결합할 수 있습니다

.. literalinclude:: view_renderer/003.php

이스케이핑(Escaping) 데이타
=============================

``setVar()``\ 와 ``setData()`` 함수에 데이터를 전달할 때 교차 사이트 스크립팅 공격(cross-site scripting attacks)으로 부터 보호하기 위해 데이터를 이스케이프 처리하는 옵션이 있습니다.
두 함수의 마지막 매개 변수로 원하는 컨텍스트를 전달하여 데이터를 이스케이프할 수 있습니다.
컨텍스트 이스케이핑에 대한 설명은 아래를 참조하십시오.

데이터를 이스케이프하지 않으려면 각 함수에 ``'null'`` 또는 ``'raw'``\ 를 전달하면 됩니다.

.. literalinclude:: view_renderer/004.php

데이터를 이스케이프하지 않기로 선택하거나 객체 인스턴스를 전달하는 경우 ``esc()`` 함수를 사용하여 뷰의 데이터를 수동으로 이스케이프할 수 있습니다.
첫 번째 매개 변수는 이스케이프할 문자열입니다. 두 번째 매개 변수는 데이터를 이스케이프하기 위한 컨텍스트입니다 (아래 참조).

::

    <?= esc($object->getStat()) ?>

이스케이핑 컨텍스트
------------------------

기본적으로 ``esc()``\ 와 ``setVar()``, ``setData()`` 함수는 이스케이프하려는 데이터가 표준 HTML을 사용한다고 가정합니다.
그러나 데이터가 Javascript, CSS 또는 href 속성에서 사용된다면 다른 이스케이프 규칙이 더 효과적입니다.
두 번째 매개 변수로 컨텍스트 종류를 전달할 수 있습니다.
유효한 컨텍스트 종류는 ``'html'``, ``'js'``, ``'css'``, ``'url'``, ``'attr'``\ 입니다.

::

    <a href="<?= esc($url, 'url') ?>" data-foo="<?= esc($bar, 'attr') ?>">Some Link</a>

    <script>
        var siteName = '<?= esc($siteName, 'js') ?>';
    </script>

    <style>
        body {
            background-color: <?= esc('bgColor', 'css') ?>
        }
    </style>

뷰 랜더러 옵션
=====================

``render()`` 또는 ``renderString()`` 메소드에 여러 옵션을 전달할 수 있습니다.

-   ``cache`` - 뷰 결과를 저장하는 시간(초); renderString()은 무시
-   ``cache_name`` - 캐시된 뷰 결과를 저장/검색하는데 사용되는 ID; 기본적으로 viewpath; ``renderString()``\ 은 무시
-   ``saveData`` - 후속 호출에 대해 뷰 데이터 매개 변수를 유지해야 하는 경우 true

.. note:: 인터페이스에 의해 정의된 ``saveData``\ 는 부울(boolean)이어야 하지만 클래스(아래의 ``View``\ 와 같은)를 구현하면, 이 값이 ``null`` 값으로 확장될 수 있습니다.

Class Reference
***************

.. php:namespace:: CodeIgniter\View

.. php:class:: View

    .. php:method:: render($view[, $options[, $saveData = false]])
        :noindex:

        :param  string       $view: 뷰 소스의 파일 이름
        :param  array        $options: 옵션 배열, 키/값 쌍
        :param  boolean|null $saveData: true 인 경우 다른 호출에 사용할 데이터를 저장, false인 경우 뷰를 렌더링 한 후 데이터를 정리
        :returns: 선택된 뷰의 렌더링 된 텍스트
        :rtype: string

        파일 이름과 이미 설정된 데이터를 기반으로 출력을 빌드합니다.
        
        .. literalinclude:: view_renderer/005.php

    .. php:method:: renderString($view[, $options[, $saveData = false]])
        :noindex:

        :param  string       $view: 렌더링 할 뷰의 내용 (예 : 데이터베이스에서 검색된 내용)
        :param  array        $options: 옵션 배열, 키/값 쌍
        :param  boolean|null $saveData: true 인 경우 다른 호출에 사용할 데이터를 저장, false인 경우 뷰를 렌더링 한 후 데이터를 정리
        :returns: 선택된 뷰의 렌더링 된 텍스트
        :rtype: string

        뷰 프래그먼트와 이미 설정된 데이터를 기반으로 출력을 빌드합니다.
        
        .. literalinclude:: view_renderer/006.php

        데이터베이스에 저장된 컨텐츠를 표시하는데 사용될 수 있지만, 이러한 데이터의 유효성을 검사하고 적절하게 이스케이프 하지 않으면 잠재적인 보안 취약점이 됩니다.

    .. php:method:: setData([$data[, $context = null]])
        :noindex:

        :param  array   $data: 뷰 데이터 문자열의 배열, 키/값 쌍
        :param  string  $context: 데이터 이스케이프에 사용할 컨텍스트
        :returns: 메소드 체이닝을 위한 Renderer 객체
        :rtype: CodeIgniter\\View\\RendererInterface.

        한 번에 여러 개의 뷰 데이터를 설정합니다
        
        .. literalinclude:: view_renderer/007.php

        지원되는 이스케이프 컨텍스트: ``html``, ``css``, ``js``, ``url``, ``attr``, ``raw``.
        ``raw``\ 면 이스케이프가 발생하지 않습니다.

        각 호출은 뷰가 렌더링될 때까지 객체가 누적하는 데이터 배열에 추가합니다.

    .. php:method:: setVar($name[, $value = null[, $context = null]])
        :noindex:

        :param  string  $name: 뷰 데이터 변수명
        :param  mixed   $value: 뷰 데이터의 값
        :param  string  $context: 데이터 이스케이프에 사용할 컨텍스트
        :returns: 메소드 체이닝을 위한 Renderer 객체
        :rtype: CodeIgniter\\View\\RendererInterface.

        한 개의 뷰 데이터를 설정합니다
        
        .. literalinclude:: view_renderer/008.php

        지원되는 이스케이프 컨텍스트: ``html``, ``css``, ``js``, ``url``, ``attr``, ``raw``.
        ``raw``\ 면 이스케이프가 발생하지 않습니다.

        이 객체에 이전에 사용한 뷰 데이터 변수를 사용하면 새 값이 기존 값을 대체합니다.
