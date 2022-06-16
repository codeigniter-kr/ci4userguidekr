########################
뷰 레이아웃(View Layout)
########################

.. contents::
    :local:
    :depth: 2

CodeIgniter는 간단하지만 매우 유연한 레이아웃 시스템을 지원하므로 어플리케이션에서 하나 이상의 기본 페이지 레이아웃을 간단하게 사용할 수 있습니다.
레이아웃은 랜더링되는 모든 뷰에 삽입할 수있는 컨텐츠 섹션을 지원합니다.
1열, 2열, 블로그 아카이브 페이지 등을 지원하기 위해 다른 레이아웃을 만들 수 있습니다.
레이아웃은 절대 직접 랜더링되지 않으며, 레이아웃 지정하여 확장하려는 뷰를 랜더링합니다.

*****************
레이아웃 만들기
*****************

레이아웃은 뷰와 같습니다. 뷰와 유일한 차이점은 ``renderSection()`` 메소드를 사용한다는 것입니다.
이 메소드는 컨텐츠의 자리 표시자 역할을 합니다.

E.g. **app/Views/default.php**::

    <!doctype html>
    <html>
    <head>
        <title>My Layout</title>
    </head>
    <body>
        <?= $this->renderSection('content') ?>
    </body>
    </html>

``renderSection()`` 메소드에는 섹션 이름이라는 하나의 인수만 있습니다.
이렇게 하면 모든 자식 뷰에서 내용 섹션의 이름을 알 수 있습니다.

**********************
뷰에서 레이아웃 사용
**********************

뷰를 레이아웃에 삽입하려면 맨 위에 ``extend()`` 메소드를 사용해야 합니다.

::

    <?= $this->extend('default') ?>

``extend`` 메소드는 사용하려는 뷰 파일의 이름을 사용합니다. 표준 뷰이므로 뷰와 같은 위치에 배치됩니다.
기본적으로 어플리케이션의 View 디렉토리를 확인하지만 PSR-4 정의 네임스페이스도 검색합니다.
네임스페이스를 지정하여 특정 뷰 디렉토리에서 뷰를 찾을 수 있습니다.

::

    <?= $this->extend('Blog\Views\default') ?>

레이아웃을 확장하는 뷰는 ``section($name)``\ 과 ``endSection()`` 메소드 호출이 포함되어야 합니다.
이러한 호출 사이의 모든 내용은 섹션 이름과 일치하는 ``renderSection($name)`` 호출이 있을 경우 레이아웃에 삽입됩니다.

E.g. **app/Views/some_view.php**::

    <?= $this->extend('default') ?>

    <?= $this->section('content') ?>
        <h1>Hello World!</h1>
    <?= $this->endSection() ?>

``endSection()``\ 은 섹션 이름이 필요하지 않으며, 어느 것을 닫아야하는지 자동으로 인식합니다.

Sections can contain nested sections

::

    <?= $this->extend('default') ?>

    <?= $this->section('content') ?>
        <h1>Hello World!</h1>
        <?= $this->section('javascript') ?>
           let a = 'a';
        <?= $this->endSection() ?>
    <?= $this->endSection() ?>

******************
뷰 랜더링
******************

레이아웃 랜더링은 다른 뷰가 컨트롤러 내에 하는것처럼 동일하게 수행됩니다.

.. literalinclude:: view_layouts/001.php

뷰 **app/Views/some_view.php**\ 를 렌더링하고 ``default``\ 를 확장하면 **app/Views/default.php** 레이아웃도 자동으로 사용됩니다.
렌더러는 매우 똑똑하여 뷰를 자체적으로 랜더링해야 할지,  레이아웃과 함께 랜더링해야 할지 감지할 수 있습니다.

***********************
부분(Partial) 뷰 포함
***********************

부분 뷰는 레이아웃을 확장하지 않는 뷰 파일입니다.
여기에는 일반적으로 재사용할 수있는 컨텐츠가 포함됩니다.
``$this->include()``\ 를 사용하여 뷰 레이아웃dp 부분 뷰를 포함시킬수 있습니다.

::

    <?= $this->extend('default') ?>

    <?= $this->section('content') ?>
        <h1>Hello World!</h1>

        <?= $this->include('sidebar') ?>
    <?= $this->endSection() ?>

``include()`` 메소드를 호출할 때 캐시 지시문 등을 포함하여 랜더링에 사용되는 옵션을 일반 뷰에 전달할 수 있습니다.
