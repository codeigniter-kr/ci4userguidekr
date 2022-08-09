.. _validation:

검증(Validation)
####################

CodeIgniter는 작성하는 코드의 양을 최소화하는데 도움이되는 포괄적인 데이터 검증 클래스를 제공합니다.

.. contents::
    :local:
    :depth: 2

개요
**********

CodeIgniter의 데이터 검증 접근 방식을 설명하기 전에 이상적인 시나리오를 설명하겠습니다.

#. 폼(form)이 표시됩니다.
#. 작성하여 제출합니다.
#. 잘못된 것을 제출했거나 필요한 항목이 빠진 경우 문제를 설명하는 오류 메시지와 함께 데이터가 포함된 폼이 다시 표시됩니다.
#. 이 과정은 유효한 양식을 제출할 때까지 계속됩니다.

수신 측에서 스크립트는 다음을 수행해야 합니다.

#. 필요한 데이터를 확인합니다.
#. 데이터가 올바른 유형이고 올바른 기준을 충족하는지 확인합니다.
   예를 들어, 사용자 이름이 제출되면 허용된 문자만 포함하도록 사용자 이름을 검증해야 합니다. 
   최소 길이 여야하며 최대 길이를 초과하지 않아야 합니다. 
   사용자 이름은 다른 사람의 기존 사용자 이름이거나 예약어일 수 없습니다. 
   기타.
#. 보안을 위해 데이터를 삭제합니다.
#. 필요한 경우 데이터를 사전 형식화합니다.
#. 데이터베이스에 추가할 데이터를 준비하십시오.

위의 프로세스는 매우 복잡한 것은 없지만 일반적으로 상당한 양의 코드가 필요하며, 오류 메시지를 표시하기 위해 다양한 제어 구조가 HTML 형식으로 배치됩니다. 
폼 검증은 작성하기는 쉽지만 구현하기가 매우 지저분하고 지루합니다.

폼 검증 튜토리얼
*****************

다음은 CodeIgniter의 폼 검증을 구현하기 위한 "실습" 자습서입니다.

양식 검증을 구현하려면 다음 세 가지가 필요합니다.

#. 폼이 포함된 :doc:`뷰 </outgoing/views>` 파일.
#. 제출(submit) 성공시 표시될 "성공" 메시지가 포함된 뷰 파일.
#. 제출된 데이터를 수신하고 처리하는 :doc:`컨트롤러 </incoming/controllers>` 메소드

회원 가입 폼을 예로 사용하여 이 세 가지를 만들어 봅시다.

폼(Form)
=========

에디터를 사용하여 **signup.php**\ 라는 폼을 만듭니다.
여기에 이 코드를 넣고 **app/Views/** 폴더에 저장합니다.

::

    <html>
    <head>
        <title>My Form</title>
    </head>
    <body>

        <?= $validation->listErrors() ?>

        <?= form_open('form') ?>

            <h5>Username</h5>
            <input type="text" name="username" value="<?= set_value('username') ?>" size="50">

            <h5>Password</h5>
            <input type="text" name="password" value="<?= set_value('password') ?>" size="50">

            <h5>Password Confirm</h5>
            <input type="text" name="passconf" value="<?= set_value('passconf') ?>" size="50">

            <h5>Email Address</h5>
            <input type="text" name="email" value="<?= set_value('email') ?>" size="50">

            <div><input type="submit" value="Submit"></div>

        <?= form_close() ?>

    </body>
    </html>

성공 페이지
============


에디터를 사용하여 **success.php**\ 라는 폼을 작성합니다.
여기에 이 코드를 넣고 **app/Views/** 폴더에 저장합니다.

::

    <html>
    <head>
        <title>My Form</title>
    </head>
    <body>

        <h3>Your form was successfully submitted!</h3>

        <p><?= anchor('form', 'Try it again!') ?></p>

    </body>
    </html>

컨트롤러
=========

에디터를 사용하여 **Form.php**\ 라는 컨트롤러를 만듭니다.
여기에 이 코드를 넣고 **app/Controllers/** 폴더에 저장합니다.

.. literalinclude:: validation/001.php

라우트
==========

**app/Config/Routes.php**\ 에 컨트롤러에 대한 경로를 추가합니다.

.. literalinclude:: validation/039.php
   :lines: 2-

Try it!
=======

폼을 사용하려면 아래와 비슷한 URL을 사용하여 사이트를 방문합니다.

::

    example.com/index.php/form/

폼을 제출하면 폼이 새로 고침됩니다.
아직 검증 규칙을 ``$this->validate()``\ 로 설정하지 않았기 때문입니다.

``validate()`` 메소드는 컨트롤러에 있는 메소드입니다.
내부에는 **Validation class**\ 가 사용됩니다. :ref:`controllers-validating-data`\ 를 참조하십시오.

.. note:: **Validation 클래스**\ 에 아직 유효성을 검사하도록 지시하지 않았기 때문에 **기본적으로 false(bool false)를 반환**\ 합니다.
    ``validate()`` 메소드는 규칙이 실패하지 않고 규칙을 성공적으로 적용한 경우에만 true를 반환합니다.

설명
=====

위 페이지에 대해 몇 가지 사항을 알 수 있습니다.

signup.php
----------

폼(**signup.php**)은 몇 가지 예외가 있는 표준 웹폼입니다.

#. :doc:`폼 헬퍼 </helpers/form_helper>`\ 를 사용하여 폼 열기와 닫기를 만듭니다. 기술적으로는 필요하지 않습니다. 
   표준 HTML을 사용하여 양식을 작성할 수 있습니다. 
   그러나 헬퍼를 사용하면 구성 파일의 URL을 기반으로 action URL이 생성된다는 이점이 있습니다. 
   이렇게 하면 URL이 변경될 때 어플리케이션의 이식성이 향상됩니다.
#. 폼 상단에 다음 함수 호출이 있습니다.

    ::

    <?= $validation->listErrors() ?>

    이 함수는 검증에서 보낸 모든 오류 메시지를 반환합니다.
    메시지가 없으면 빈 문자열을 반환합니다.

Form.php
--------

컨트롤러(**Form.php**)에는 ``$helpers``\ 라는 속성이 하나 있습니다.
view 파일에서 사용하는 form 헬퍼를 로드합니다.

컨트롤러에는 ``index()``\ 라는 메소드가 있습니다.
이 메소드는 POST가 아닌 요청이 올 때 폼을 표시하기 위해 **signup** 뷰(view)를 반환합니다.
POST 요청에 대해 컨트롤러에서 제공하는 ``validate()`` 메소드를 사용하여 유효성 검사 루틴을 실행합니다.
유효성 검사가 성공했는지 여부에 따라 폼 또는 성공(success) 페이지가 표시됩니다.

검증 룰 추가
=============

컨트롤러(**Form.php**)에 유효성 검사 규칙을 추가합니다. 

.. literalinclude:: validation/002.php
   :lines: 2-

폼을 제출할 경우 성공 또는 오류 메시지가 있는 폼을 볼 수 있습니다.

검증을 위한 구성
*********************

.. _validation-traditional-and-strict-rules:

전통적이고 엄격한 규칙
============================

CI4에는 두 가지 종류의 유효성 검사 규칙 클래스가 있습니다.
기본 규칙 클래스(**Traditional Rules**)에는 ``CodeIgniter\Validation``\ 이라는 네임스페이스가 있고 새 클래스(**Strict Rules**)에는 엄격한 유효성 검사를 제공하는 ``CodeIgniter\Validation\StrictRules``\ 가 있습니다. .

**기본 규칙(Traditional Rules)**\ 은 암시적으로 문자열 값이 검증되고 입력 값이 암시적으로 문자열 값으로 변환될 수 있다고 가정합니다.
POST 데이터 유효성 검사와 같은 가장 기본적인 경우에 작동합니다.

그러나 JSON 입력 데이터를 사용하는 경우 데이터의 유형은 **bool/null/array**\ 일 수 있습니다.
부울 ``true``\ 의 유효성을 검사하면 전통적인 규칙 클래스를 사용하여 문자열 ``'1'``\ 로 변환됩니다.
``integer`` 규칙으로 유효성을 검사하면 ``'1'``\ 이 유효성 검사를 통과합니다.

**엄격한 규칙(Strict Rules)**\ 은 암시적 유형 변환을 사용하지 않습니다.

.. warning:: JSON 데이터와 같이 문자열이 아닌 값을 포함하는 데이터의 유효성을 검사할 때 **엄격한 규칙**\ 을 사용하는 것이 좋습니다.

엄격한 규칙 사용
------------------

엄격한 규칙을 사용하려면 **app/Config/Validation.php**\ 에서 규칙 클래스를 변경해야 합니다.

.. literalinclude:: validation/003.php

라이브러리 로드
****************

라이브러리는 **validation** 서비스로 로드됩니다.

.. literalinclude:: validation/004.php

그러면 여러 규칙 세트를 포함하기 위한 설정과 쉽게 재사용할 수있는 규칙 모음이 포함된 ``Config\Validation`` 파일이 자동으로 로드됩니다.

.. note:: :doc:`컨트롤러 </incoming/controllers>`\ 와 :doc:`모델 </models/model>` 모두 검증을 보다 쉽게 수행할 수 있는 메소드를 제공하므로 이 메소드를 사용할 필요가 없습니다.

검증 규칙 설정
************************

CodeIgniter를 사용하면 주어진 필드에 필요한 만큼의 검증 규칙을 순서대로 설정할 수 있습니다.
검증 규칙을 설정하려면 ``setRule()``, ``setRules()``, ``withRequest()`` 메소드를 사용합니다.

setRule()
=========

이 메소드는 단일 규칙을 설정합니다. 메소드 시그니처입니다.

::

    setRule(string $field, ?string $label, array|string $rules[, array $errors = []])

``$rules``\ 는 파이프(|)로 구분된 규칙 목록이나 규칙의 배열 컬렉션을 사용합니다.

.. literalinclude:: validation/005.php

``$field``\ 에 전달하는 값은 전송되는 모든 데이터 배열의 키와 일치해야 합니다.
``$_POST``\ 에서 데이터를 직접 가져온 경우 폼(form) 입력 이름과 정확히 일치해야 합니다.

.. warning:: v4.2.0 이전에는 이 메소드의 세 번째 매개변수인 ``$rules``\ 가 ``string``\ 을 허용하도록 타입힌팅(typehint)되었습니다.
    v4.2.0 이상에서는 배열도 허용하기 위해 타입힌팅(typehint)이 제거되었습니다.
    이 메서드를 재정의하는 확장 클래스에서 LSP가 손상되지 않도록 하려면 자식 클래스의 메소드도 수정하여 타입힌팅(typehint)을 제거해야 합니다.

setRules()
==========

``setRule()``\ 과 비슷하지만 필드 이름 배열과 규칙을 허용합니다.

.. literalinclude:: validation/006.php

지정된 오류 메시지를 레이블을 제공하려면 다음과 같이 설정합니다.

.. literalinclude:: validation/007.php

withRequest()
=============

검증 라이브러리는 HTTP 요청에서 입력된 데이터를 검증할 때 가장 일반적으로 사용됩니다.
Request 객체의 인스턴스를 전달하면, 모든 입력 데이터를 가져 와서 유효성을 검사할 데이터로 설정합니다.

.. literalinclude:: validation/008.php

검증 작업
***********

배열 키 검증
==============

데이터가 중첩된 연관 배열dms "dot array syntax"\ 를 사용하여 데이터의 유효성을 쉽게 검증할 수 있습니다.

.. literalinclude:: validation/009.php

'*' 와일드 카드 기호를 사용하여 단일 수준(one level)의 배열과 일치시킬 수 있습니다.

.. literalinclude:: validation/010.php

"dot array syntax"은 단일 차원 배열 데이터의 경우에도 유용할 수 있습니다.
다중 선택 드롭 다운 예시

.. literalinclude:: validation/011.php

하나의 값 확인
=======================

규칙에 대해 하나의 값을 확인합니다.

.. literalinclude:: validation/012.php

구성 파일에 검증 규칙 저장
============================

Validation 클래스의 좋은 기능은 어플리케이션 전체에 대한 모든 검증 규칙을 구성 파일에 저장할 수 있다는 것입니다.
규칙을 "그룹"\ 으로 구성합니다.
검증를 실행할 때마다 다른 그룹을 지정할 수 있습니다.

.. _validation-array:

규칙을 저장하는 방법
----------------------

검증 규칙을 저장하려면 ``Config\Validation`` 클래스에 그룹 이름으로 새로운 공용 속성을 만들면 됩니다.
이 요소는 검증 규칙이 있는 배열을 보유합니다. 
다음은 검증 배열에 대한 프로토 타입입니다.

.. literalinclude:: validation/013.php

``run()`` 메소드를 호출할 때 사용할 그룹을 지정합니다.

.. literalinclude:: validation/014.php

속성을 그룹과 동일하게 지정하고 ``_errors``\ 를 추가하여 이 구성 파일에 사용자 정의 오류 메시지를 저장할 수 있습니다.
이 그룹을 사용할 때 오류는 자동으로 사용됩니다.

.. literalinclude:: validation/015.php

또는 배열에 모든 설정을 전달합니다.

.. literalinclude:: validation/016.php

배열 형식(format)에 대한 자세한 내용은 아래를 참조하십시오.

규칙 그룹 가져 오기 및 설정
-----------------------------

**Get Rule Group**

유효성 검증 구성에서 규칙 그룹을 가져옵니다.

.. literalinclude:: validation/017.php

**Set Rule Group**

유효성 검증 규칙 구성 그룹을 검증 서비스에 설정합니다.

.. literalinclude:: validation/018.php

다중 검증 실행
===============

.. note:: ``run()`` 메소드는 오류 상태를 재설정하지 않습니다.
   이전 실행이 실패하면 ``run()`` 메소드는 false를 반환하고, ``getErrors()`` 메소드는 명시적으로 재설정될 때까지 이전 오류를 반환합니다.

서로 다른 데이터 집합 또는 서로 다른 규칙에 대해 여러 유효성 검사를 실행하려면 각 실행 전에 ``$validation->reset()``\ 을 호출하여 이전 실행 오류를 제거해야 합니다.
``reset()`` 메소드는 이전에 설정한 데이터, 규칙 또는 사용자 지정 오류를 무효화하므로 ``setRules()``, ``setRuleGroup()`` 등을 반복하여 호출해야 합니다.

.. literalinclude:: validation/019.php

검증 자리 표시자(Placeholders)
===============================

검증 클래스는 전달되는 데이터를 기반으로 규칙의 일부를 교체하는 간단한 방법을 제공합니다. 
이것은 상당히 모호하게 들리지만 ``is_unique`` 검증 규칙에 특히 유용할 수 있습니다. 
자리 표시자는 단순히 중괄호로 묶인 ``$data``\ 로 전달된 필드(또는 배열 키)의 이름입니다. 
일치하는 수신 필드의 **값(value)**\ 으로 대체됩니다.
예를 들면 다음과 같습니다.

.. literalinclude:: validation/020.php

이 규칙 집합에서는 자리 표시자 값과 일치하는 ID가 있는 행을 제외하고 전자 메일 주소가 데이터베이스에서 고유해야 한다고 명시되어 있습니다. 
POST 데이터에 다음이 있다고 가정합니다.

.. literalinclude:: validation/021.php

그러면 ``{id}`` 자리 표시자가 숫자 **4**\ 로 대체되고 이 수정된 규칙이 적용됩니다.

.. literalinclude:: validation/022.php

따라서 고유한 이메일인지 확인할 때 ``id=4``\ 인 데이터베이스의 행을 무시하게 됩니다.

또한 전달된 동적 키가 양식 데이터와 충돌하지 않도록 주의한다면 런타임에 더 많은 동적 규칙을 만드는 데 사용할 수 있습니다.

오류에 대한 작업
******************

검증 라이브러리는 오류 메시지를 설정하고, 사용자 지정 오류 메시지를 제공하며 표시할 하나 이상의 오류를 검색하는 데 도움이 되는 몇 가지 방법을 제공합니다.

기본적으로 오류 메시지는 ``system/Language/en/Validation.php``\ 의 언어 문자열에서 파생되며, 각 규칙에는 항목이 있습니다.

.. _validation-custom-errors:

사용자 정의 오류 메시지 설정
==============================

``setRule()``\ 과 ``setRules()`` 메소드는 각 필드마다 고유한 오류로 사용되는 사용자 정의 메시지 배열을 마지막 매개 변수로 승인할 수 있습니다.
오류는 각 인스턴스에 맞게 조정되므로 사용자에게 매우 쾌적한 환경을 제공합니다.
사용자 지정 오류 메시지가 제공되지 않으면 기본값이 사용됩니다.

다음은 사용자 정의 오류 메시지를 제공하는 두 가지 방법입니다.

마지막 매개 변수로

.. literalinclude:: validation/023.php

또는 레이블이있는 스타일로

.. literalinclude:: validation/024.php

검증된 필드의 사용자의 이름 또는 일부 규칙에서 허용하는 선택적 매개 변수의 (예 : max_length) 값을 메시지에 
포함하고 싶다면 ``{field}``, ``{param}``, ``{value}`` 태그를 필요에 따라 추가합니다.

::

    'min_length' => 'Supplied value ({value}) for {field} must have at least {param} characters.'

사용자의 이름이 ``Username``\ 이고 값이 "Pizza"\, 규칙이 ``min_length[6]``\ 인 필드에서 오류가 발생하면 "Supplied value (Pizza) for Username must have at least 6 characters."\ 로 표시됩니다.

.. warning:: ``getErrors()`` 또는 ``getError()``\ 로 오류 메시지가 HTML 표시되면 이스케이프 처리rk되지 않은 것입니다. ``({value})``\ 와 같은 사용자 입력 데이터를 사용하여 오류 메시지를 만드는 경우 HTML 태그가 포함될 수 있습니다. 메시지를 배포하기 전에 이스케이프하지 않으면 XSS 공격이 가능합니다.

.. note:: 레이블 스타일 오류 메시지를 사용할 때 두 번째 매개변수를 ``setRules()``\ 에 전달하면 첫 번째 매개변수 값으로 덮어씁니다.

메시지 및 검증 레이블 변환
============================

언어 파일에서 변환된 문자열을 사용하려면 점 구문을 사용하면 됩니다. 
``app/Language/en/Rules.php``\ 에 번역본이 있는 파일이 있다고 가정해 보겠습니다. 
이 파일에 정의된 언어 라인을 다음과 같이 간단히 사용할 수 있습니다.

.. literalinclude:: validation/025.php

.. _validation-getting-all-errors:

모든 오류 얻기
==================

실패한 필드에 대한 모든 오류 메시지를 검색해야 하는 경우 ``getErrors()`` 메소드를 사용합니다

.. literalinclude:: validation/026.php

오류가 없으면 빈 배열이 반환됩니다.

와일드카드를 사용할 때 오류는 특정 필드를 가리키고 별표(*)를 적절한 키로 대체합니다.

::

    // for data
    'contacts' => [
        'friends' => [
            [
                'name' => 'Fred Flinstone',
            ],
            [
                'name' => '',
            ],
        ]
    ]

    // rule
    'contacts.*.name' => 'required'

    // error will be
    'contacts.friends.1.name' => 'The contacts.*.name field is required.'

단일 오류 얻기
================

``getError()`` 메소드를 사용하여 단일 필드의 오류를 검색할 수 있습니다.
필드 이름을 단일 매개 변수로 사용합니다.

.. literalinclude:: validation/027.php

오류가 없으면 빈 문자열이 반환됩니다.

오류가 있는지 확인
=====================

``hasError()`` 메소드에 오류가 있는지 확인할 수 있습니다.
필드 이름을 단일 매개 변수로 사용합니다.

.. literalinclude:: validation/028.php

와일드카드로 필드를 지정할 때 마스크와 일치하는 모든 오류가 검사됩니다.

.. literalinclude:: validation/029.php

오류 표시 사용자 정의
**********************

``$validation->listErrors()`` 또는 ``$validation->showError()``\ 를 호출하면 백그라운드에서 오류가 표시되는 방법을 결정하고 뷰 파일을 로드합니다.
기본적으로 래핑 div에 ``errors`` 클래스와 함께 표시됩니다.
어플리케이션에서 새로운 뷰를 쉽게 작성하고 사용할 수 있습니다.

뷰 생성
=========

첫 번째 단계는 사용자 정의 뷰를 작성하는 것입니다.
이들은 ``view()`` 메소드가 찾을 수 있는 곳이면 어디든지 배치할 수 있습니다. 
즉 표준 View 디렉토리나 네임스페이스가 있는 View 폴더에 작성합니다.
예를 들면 **/app/Views/_errors_list.php**\ 에 새로운 뷸를 만들 수 있습니다.

.. literalinclude:: validation/030.php

``$errors``\ 라는 배열은 오류 목록이 포함된 뷰안에서 사용 가능합니다. 
키는 오류가 있는 필드의 이름이고 값은 오류 메시지입니다.

.. literalinclude:: validation/031.php

실제로 작성할 수 있는 두 가지 유형의 뷰가 있습니다.
첫 번째는 모든 오류 배열을 가지고 있으며 방금 살펴본 것입니다.
다른 유형은 더 단순하며 오류 메시지가 포함된 단일 변수 ``$error``\ 만 포함합니다.
필드를 지정해야 하는 ``showError()`` 메소드와 함께 사용됩니다.

::

    <span class="help-block"><?= esc($error) ?></span>

구성
======

뷰를 만든 후에는 검증 라이브러리에 해당 뷰를 알려야 합니다.
``Config/Validation.php``\ 에는 사용자 정의 뷰를 나열하고 참조 할 수 있는 짧은 별명(alias)을 제공하는 ``$templates``\ 속성이 있습니다.
위의 예제 파일을 추가하면 다음과 같습니다.

.. literalinclude:: validation/032.php

템플릿 지정
=============

``listErrors()``\ 의 첫 번째 매개 변수로 별칭을 전달하여 사용할 템플릿을 지정할 수 있습니다

::

    <?= $validation->listErrors('my_list') ?>

``showError()`` 메소드를 사용하여 필드별 오류를 표시할 때, 첫 번째 매개 변수로 오류가 속하는 필드 이름과 두 번째 매개 변수로 별명을 전달할 수 있습니다.

::

    <?= $validation->showError('username', 'my_single') ?>

사용자 정의 규칙 생성
***********************

규칙은 단순한 네임스페이스 클래스내에 저장됩니다.
오토로더가 찾을 수 있다면 원하는 어느 위치든 저장할 수 있습니다. 
이러한 파일을 규칙 세트(RuleSet)라고합니다.
새 규칙 세트를 추가하려면 **Config/Validation.php**\ 의 ``$ruleSets`` 배열에 추가하십시오.

.. literalinclude:: validation/033.php

정규화된 클래스 이름을 가진 간단한 문자열 또는 위와 같은 ``::class`` 접미사를 사용하여 추가할 수 있습니다.
여기서 가장 큰 장점은 고급 IDE에서 몇 가지 추가 탐색 기능을 제공한다는 것입니다.

파일 자체에서 각 메소드는 규칙이며, 문자열을 첫 번째 매개 변수로 승인해야 합니다.
테스트를 통과한 경우 부울 true 값을 그렇지 않은 경우 false를 리턴해야 합니다.

.. literalinclude:: validation/034.php

기본적으로 시스템은 ``CodeIgniter\Language\en\Validation.php``\ 에서 오류에 사용되는 언어 문자열을 찾습니다.
사용자 지정 규칙에서 두 번째 매개 변수에서 ``$error`` 변수를 참조하여 오류 메시지를 제공할 수 있습니다.

.. literalinclude:: validation/035.php

새로운 규칙은 다른 규칙처럼 사용합니다.

.. literalinclude:: validation/036.php

허용되는 매개 변수
=====================

분석법이 매개 변수와 함께 작동해야 하는 경우 함수에는 최소 세 개의 매개 변수가 필요합니다.
유효성 검증할 문자열, 매개 변수 문자열, 폼에서 제출한 모든 데이터가 있는 배열.
``$data`` 배열은 결과를 기반으로 제출된 다른 필드의 값을 확인해야 하는 ``require_with``\ 와 같은 규칙에 특히 유용합니다.

.. literalinclude:: validation/037.php

위에서 설명한 것처럼 사용자 지정 오류는 네 번째 매개 변수로 반환될 수 있습니다.

사용 가능한 규칙
********************

다음은 사용 가능한 모든 기본 규칙의 목록입니다.

.. note:: 규칙은 문자열입니다. 매개 변수 사이에 공백은 없어야합니다 (특히 "is_unique"규칙).
    "ignore_value"\ 전후에는 공백이 있을 수 없습니다.

.. literalinclude:: validation/038.php

======================= =========== =============================================================================================== ===================================================
Rule                    Parameter   Description                                                                                     Example
======================= =========== =============================================================================================== ===================================================
alpha                   No          필드에 알파벳 이외의 문자가 있으면 실패합니다.
alpha_space             No          필드에 알파벳 문자나 공백 이외의 것이 포함되어 있으면 실패합니다.
alpha_dash              No          필드에 영숫자, 밑줄, 대시(-) 이외의 문자가 포함되어 있으면 실패합니다.
alpha_numeric           No          필드에 영숫자, 숫자 이외의 문자가 포함되어 있으면 실패합니다.
alpha_numeric_space     No          필드에 영숫자, 숫자, 공백 이외의 것이 포함되어 있으면 실패합니다.
alpha_numeric_punct     No          필드에 영숫자, 공백, 문장 부호 문자 이외의 문자가 포함되어 있으면 실패합니다.
                                    사용 가능 부호 : ``~ (물결표)`` , ``! (느낌표)`` , ``# (샾)`` , ``$ (달러)`` , ``% (퍼센트)`` ,
                                    ``& (앰퍼샌드)`` , ``* (별표)`` , ``- (대시)`` , ``_ (밑줄)`` , ``+ (플러스)`` , ``= (같음)`` , 
                                    ``| (세로 막대)`` , ``: (콜론)`` , ``. (마침표)``
decimal                 No          필드에 10진수 이외의 것이 있으면 실패합니다.
                                    숫자에 + 또는-부호도 사용할 수 있습니다.
differs                 Yes         필드가 매개 변수의 필드와 다르지 않으면 실패합니다.                                             differs[field_name]
exact_length            Yes         필드가 정확히 매개 변수 값이 아닌 경우 실패합니다. 하나 이상의 값은 쉼표로 구분                 exact_length[5] or exact_length[5,8,12]
greater_than            Yes         필드가 매개 변수 값보다 작거나, 같거나, 숫자가 아닌 경우 실패합니다.                            greater_than[8]
greater_than_equal_to   Yes         필드가 매개 변수 값보다 작거나, 숫자가 아닌 경우 실패합니다.                                    greater_than_equal_to[5]
hex                     No          필드에 16진수 문자가 아닌 다른 문자가 포함된 경우 실패합니다.
if_exist                No          이 규칙이 있으면 검증 라이브러리는 필드 키가 존재하는 경우 값에
                                    관계없이 가능한 오류만 반환합니다.
in_list                 Yes         필드가 미리 정해진 목록에 없으면 실패합니다.                                                    in_list[red,blue,green]
integer                 No          필드에 정수 이외의 것이 포함되어 있으면 실패합니다.
is_natural              No          필드에 0, 1, 2, 3 등의 자연수 이외의 것이 포함되어 있으면 실패합니다.
is_natural_no_zero      No          필드에 0, 1, 2, 3 등을 제외하고 자연수 이외의 것이 있으면 실패합니다.
is_not_unique           Yes         주어진 값이 존재하는지 데이터베이스를 확인합니다. 필드/값 별로 레코드를 무시하여 필터링         is_not_unique[table.field,where_field,where_value]
                                    할 수 있습니다 (현재 하나의 필터 만 허용).
is_unique               Yes         이 필드 값이 데이터베이스에 존재하는지 확인합니다. 선택적으로 무시할 열과 값을 설정하면         is_unique[table.field,ignore_field,ignore_value]
                                    레코드 자체를 무시하여 업데이트할 때 유용합니다.
less_than               Yes         필드가 매개 변수 값보다 크거나 같거나 숫자가 아닌 경우 실패합니다.                              less_than[8]
less_than_equal_to      Yes         필드가 매개 변수 값보다 크거나 숫자가 아닌 경우 실패합니다.                                     less_than_equal_to[8]
matches                 Yes         값은 매개 변수의 필드 값과 일치해야합니다.                                                      matches[field]
max_length              Yes         필드가 매개 변수 값보다 길면 실패합니다.                                                        max_length[8]
min_length              Yes         필드가 매개 변수 값보다 짧은 경우 실패합니다.                                                   min_length[3]
not_in_list             Yes         필드가 정해진 목록 내에 있으면 실패합니다.                                                      not_in_list[red,blue,green]
numeric                 No          필드에 숫자 이외의 문자가 포함되어 있으면 실패합니다.
regex_match             Yes         필드가 정규식과 일치하지 않으면 실패합니다.                                                     regex_match[/regex/]
permit_empty            No          필드가 빈 배열, 빈 문자열, null, false를 받을 수 있도록 합니다.
required                No          필드가 빈 배열, 빈 문자열, null, false이면 실패합니다.
required_with           Yes         다른 필수 필드중 하나라도 데이터에 있으면 이 필드가 필요합니다.                                 required_with[field1,field2]
required_without        Yes         이 필드는 다른 모든 필드가 데이터에 있지만 필수는 아닌 경우 필수입니다.                         required_without[field1,field2]
string                  No          요소가 문자열임을 확인하는 alpha* 규칙에 대한 일반적인 대안
timezone                No          필드가 ``timezone_identifiers_list`` 시간대와 일치하지 않으면 실패
valid_base64            No          필드에 유효한 Base64 문자 이외의 것이 포함되어 있으면 실패합니다.
valid_json              No          필드에 유효한 JSON 문자열이 없으면 실패합니다.
valid_email             No          필드에 유효한 이메일 주소가 없으면 실패합니다.
valid_emails            No          쉼표로 구분된 목록에 제공된 값이 유효한 이메일이 아닌 경우 실패합니다.
valid_ip                No          제공된 IP가 유효하지 않으면 실패합니다. IP 형식을 지정하기 위해 'ipv4' 또는 'ipv6'의            valid_ip[ipv6]
                                    선택적 매개 변수를 승인합니다.
valid_url               No          필드에 URL이 포함되지 않은 경우(느슨하게) 실패합니다.
                                    "codeigniter"와 같은 호스트 이름일 수 있는 문자열을 포함합니다.
valid_url_strict        Yes         필드에 올바른 URL이 없는 경우 실패합니다.
                                    valid_url_strict[https] 유효한 스키마 목록을 선택적으로 지정할 수 있습니다.
                                    지정하지 않으면 ''http,https''가 유효합니다.
                                    이 규칙은 PHP의 ''FILTER_VALIDATE_URL''을 사용합니다.
valid_date              No          필드에 유효한 날짜가 없으면 실패합니다. 날짜 형식과 일치하도록 선택적 매개 변수를 승인합니다.   valid_date[d/m/Y]
valid_cc_number         Yes         신용 카드 번호가 지정된 공급자가 사용하는 형식과 일치하는지 확인합니다.                         valid_cc_number[amex]
                                    현재 지원되는 공급자: American Express (amex), China Unionpay (unionpay),
                                    Diners Club CarteBlance (carteblanche), Diners Club (dinersclub), Discover Card (discover),
                                    Interpayment (interpayment), JCB (jcb), Maestro (maestro), Dankort (dankort), NSPK MIR (mir),
                                    Troy (troy), MasterCard (mastercard), Visa (visa), UATP (uatp), Verve (verve),
                                    CIBC Convenience Card (cibc), Royal Bank of Canada Client Card (rbc),
                                    TD Canada Trust Access Card (tdtrust), Scotiabank Scotia Card (scotia), BMO ABM Card (bmoabm),
                                    HSBC Canada Card (hsbc)
======================= =========== =============================================================================================== ===================================================

.. _rules-for-file-uploads:

파일 업로드 규칙
======================

업로드된 파일이 비즈니스 요구 사항을 충족하는지 확인하는데 검증 규칙을 사용하면 필요한 기본 검사를 수행할 수 있습니다.
파일 업로드는 HTML 필드에 존재하지 않고 전역 변수 ``$_FILES``\ 에 저장되므로, 입력 필드의 이름을 두 번 사용해야 합니다.
다른 규칙에서와 마찬가지로 필드 이름을 지정하지만, 파일 업로드 관련 규칙의 첫 번째 매개 변수로 다시 한 번 지정합니다.

::

    // In the HTML
    <input type="file" name="avatar">

    // In the controller
    $this->validate([
        'avatar' => 'uploaded[avatar]|max_size[avatar,1024]',
    ]);

======================= =========== =============================================================================================== ========================================
Rule                    Parameter   Description                                                                                     Example
======================= =========== =============================================================================================== ========================================
uploaded                Yes         매개 변수 이름이 업로드된 파일 이름과 일치하지 않으면 실패합니다.                               uploaded[field_name]
max_size                Yes         업로드된 파일이 max_size[field_name, 2048] 두 번째 매개 변수에 지정된 킬로바이트(KB) 보다       max_size[field_name,2048]
                                    크거나 php.ini 구성 파일에 ``upload_max_filesize``\ 로 선언된 최대 허용 크기보다 큰 경우
                                    실패합니다.
max_dims                Yes         업로드된 이미지의 최대 너비와 높이가 값을 초과하면 실패합니다.  첫 번째 매개 변수는             max_dims[field_name,300,150]
                                    필드 이름입니다. 두 번째는 너비이고 세 번째는 높이입니다.
                                    파일을 이미지로 결정할 수없는 경우에도 실패합니다.
mime_in                 Yes         파일의 MIME 유형이 매개 변수에 나열된 유형이 아닌 경우 실패합니다.                              mime_in[field_name,image/png,image/jpg]
ext_in                  Yes         파일 확장자가 매개 변수에 나열된 확장자가 아니면 실패합니다.                                    ext_in[field_name,png,jpg,gif]
is_image                Yes         파일이 MIME 유형에 따라 이미지라고 판단할 수 없으면 실패합니다.                                 is_image[field_name]
======================= =========== =============================================================================================== ========================================

파일 검증 규칙은 단일/다중 파일 업로드 모두에 적용됩니다.

.. note:: 유효성 검사에 부울을 반환하고 하나 이상의 매개 변수인 필드 데이터를 허용하는 기본 PHP 함수를 사용할 수 있습니다.
    유효성 검사 라이브러리는 ** 검증할 데이터를 변경하지 않습니다.**