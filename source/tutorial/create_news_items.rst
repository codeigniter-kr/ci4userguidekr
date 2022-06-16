뉴스 아이템 만들기
##################

CodeIgniter를 사용하여 데이터베이스에서 데이터를 읽는 방법을 알았지만 아직 데이터베이스에 정보를 쓰지는 않았습니다.
이 섹션에서는 이 기능을 포함하기 위해 이전에 작성한 뉴스 컨트롤러 및 모델을 확장합니다.

CSRF 필터 활성화
******************

폼을 만들기 전에 CSRF 보호를 사용하도록 설정합니다.

**app/Config/Filters.php** 파일을 열고 다음과 같이 ``$methods`` 속성을 업데이트합니다.

.. literalinclude:: create_news_items/001.php

모든 **POST** 요청에 대해 CSRF 필터를 사용하도록 구성합니다.
CSRF 보호에 대한 자세한 내용은 :doc:`보안 </libraries/security>`\ 라이브러리에서 확인할 수 있습니다.

.. Warning:: 일반적으로 ``$methods`` 필터를 사용하는 경우 자동 라우팅을 사용하면 모든 HTTP 메서드가 컨트롤러에 액세스할 수 있으며, 예상하지 못한 방법으로 컨트롤러에 액세스하면 필터를 우회할 수 있습니다. `자동 라우팅 비활성화 <use-defined-routes-only>`\ 를 참조하십시오.

Create a form
*************

데이터베이스에 데이터를 입력하려면 저장할 정보를 입력 할 수 있는 양식(form)을 작성해야 합니다.
제목과 텍스트 입력을 위해 두 개의 필드가 있는 양식이 필요합니다.
모델에서는 타이틀을 이용하여 슬러그를 만듭니다.
**app/Views/news/create.php**\ 에 새로운 뷰를 만듭니다.

::

    <h2><?= esc($title); ?></h2>

    <?= session()->getFlashdata('error') ?>
    <?= service('validation')->listErrors() ?>

    <form action="/news/create" method="post">
        <?= csrf_field() ?>

        <label for="title">Title</label>
        <input type="input" name="title" /><br />

        <label for="body">Text</label>
        <textarea name="body" cols="45" rows="4"></textarea><br />

        <input type="submit" name="submit" value="Create news item" />
    </form>

여기에 낯설게 보이는 것 세 가지가 있습니다.

``session()->getFlashdata('error')`` 함수는 CSRF 보호와 관련된 오류를 보고하는 데 사용됩니다.

``service('validation')->listErrors()`` 함수는 양식 유효성 검사와 관련된 오류를 보고하는 데 사용됩니다.

``csrf_field()`` 함수는 몇 가지 일반적인 공격으로부터 보호하는 데 도움이 되는 CSRF 토큰으로 숨겨진 입력을 생성합니다.

``News`` 컨트롤러로 돌아갑니다.
여기서 우리는 두 가지 작업, 양식이 제출되었는지와 제출된 데이터가 검증 규칙을 통과했는지 여부를 확인할 겁니다
이를 위해 :ref:`컨트롤러의 검증 메소드 <controller-validate>`\ 를 사용합니다.

.. literalinclude:: create_news_items/002.php

위의 코드는 많은 기능을 추가합니다.
먼저 ``NewsModel``\ 을 로드합니다.
그리고 ``POST`` 요청을 처리하는지 확인한 다음 컨트롤러 제공 헬퍼 기능을 사용하여 유효성을 검증합니다
위의 경우 POST 데이터 제목(title)과 텍스트(body) 필드는 필수입니다.

CodeIgniter에는 위에서 설명한 강력한 유효성 검사 라이브러리가 있습니다.
이 라이브러리에 대한 자세한 내용은 :doc:`여기 <../libraries/validation>`\ 를 참조하십시오.

계속해서 폼(form) 유효성 검사가 성공적으로 실행되었는지 확인하는 조건을 볼 수 있습니다.
그렇지 않은 경우 폼이 표시됩니다. 
제출된 데이터가 모든 규칙을 통과했을때 모델이 호출됩니다.
모델로 뉴스 아이템을 전달하여 처리합니다.
여기에는 새로운 함수인 ``url_title()``\ 이 포함되어 있습니다.
이 함수 - :doc:`URL helper <../helpers/url_helper>`\ 에서 제공 - 는 전달받은 문자열에서 
모든 공백을 대시 (``-``)로 바꾸고 모든 문자가 소문자인지 확인합니다. 
이 함수는 URI로 사용 가능한 완벽한 slug를 만듭니다.


그런 다음 성공 메시지를 표시하기 위해 뷰가 로드됩니다.
**app/Views/news/success.php**\ 로 뷰를 작성하고 성공 메시지를 추가하십시오.

간단하게

::

    News item created successfully. 

모델 업데이트
**************

이제 데이터를 저장할 수 있도록 모델을 업데이트하겠습니다.
``save()`` 메소드는 기본 키의 존재 여부에 따라 정보를 삽입할지, 업데이트할지를 결정합니다.
``id`` 필드가 전달되지 않을 경우 **news** 테이블에 새 행이 삽입됩니다.

그러나 모델의 insert 및 update 메소드는 기본적으로 업데이트할 안전한 필드를 모르기 때문에 실제로 데이터를 저장하지 않습니다.
업데이트 가능한 필드 목록을 **NewsModel**\ 의 ``$allowedFields`` 속성에 작성합니다.

.. literalinclude:: create_news_items/003.php

이 새 속성에는 이제 데이터베이스에 저장할 수 있는 필드가 포함됩니다.

.. note:: 
    ``id``\ 는 데이터베이스의 자동 증가(auto-incrementing) 필드이기 때문에 $allowdFields에서 생략되었습니다.
    이렇게하면 대량 할당 취약점으로부터 보호할 수 있습니다.
    모델이 타임 스탬프를 처리하는 경우 해당 타임 스탬프도 제외합니다.

라우팅
*******

CodeIgniter 어플리케이션에 뉴스 항목을 추가하기 전에 **app/Config/Routes.php** 파일에 추가 규칙을 추가해야 합니다.
파일에 다음 규칙이 포함되어 있는지 확인하십시오. 
이를 통해 CodeIgniter는 뉴스 항목의 슬러그 대신 ``create()``\ 를 메소드로 인식합니다.
여러분은 :doc:`여기 </incoming/routing>`\ 에서 다른 것에 대한 자세한 내용을 읽을 수 있습니다.

.. literalinclude:: create_news_items/004.php

이제 웹 브라우저의 URL에 ``http://localhost:8080/news/create``\ 를 입력하십시오.
몇 가지 뉴스를 추가하고 페이지를 확인해 보세요.

.. image:: ../images/tutorial3.png
    :align: center
    :height: 415px
    :width: 45%

.. image:: ../images/tutorial4.png
    :align: center
    :height: 415px
    :width: 45%

축하합니다!
***************

당신은 첫 번째 CodeIgniter4 어플리케이션을 방금 완료하셨습니다!

아래에 있는 이미지는 프로젝트의 **app** 폴더를 표시하며, 녹색으로 생성한 모든 파일을 표시합니다.
수정된 두 구성 파일(**Config/Routes.php**, **Config/Filters.php**)은 표시되지 않았습니다.

.. image:: ../images/tutorial9.png
    :align: left