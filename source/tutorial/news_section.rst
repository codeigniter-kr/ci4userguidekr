뉴스 섹션
############

이전 섹션에서는 정적 페이지(static page)를 참조하는 클래스를 작성하여 프레임워크의 몇 가지 기본 개념을 살펴 보고 사용자 정의 라우팅 규칙을 추가하여 URI를 정리했습니다.
이제 동적(dinamic) 컨텐츠를 소개하고 데이터베이스를 사용할 차례입니다.

작업할 데이터베이스 생성
**************************

먼저, CodeIgniter 설치시 :doc:`요구사항 </intro/requirements>`\ 에 요약 된대로 적절한 데이터베이스를 설정했다고 가정합니다.
이 튜토리얼에서는 MySQL 데이터베이스에 대한 SQL을 제공하며, 데이터베이스 명령을 실행하기에 적합한 클라이언트(mysql, MySQL Workbench 또는 phpMyAdmin)가 있다고 가정합니다.

이 섹션을 진행하기 위해서는 데이터베이스를 만든 다음 CodeIgniter를 구성하여 사용해야 합니다.

데이터베이스 클라이언트를 사용하여 데이터베이스에 연결하고 아래의 SQL(MySQL)을 실행하십시오.

::

    CREATE TABLE news (
        id int(11) NOT NULL AUTO_INCREMENT,
        title varchar(128) NOT NULL,
        slug varchar(128) NOT NULL,
        body text NOT NULL,
        PRIMARY KEY (id),
        KEY slug (slug)
    );

또한, 몇 개의 시드(seed) 레코드를 추가합니다.
지금은 테이블을 만드는데 필요한 SQL문을 보여 주지만 CodeIgniter에 익숙해지면 프로그래밍 방식으로이 작업을 수행할 수 있습니다. 
나중에 더 유용한 데이터베이스 설정을 작성하기 위해 :doc:`마이그레이션 <../dbmgmt/migration>` 및 :doc:`시드(Seeds) <../dbmgmt/seeds>`\ 에 대해 읽어보세요.

관심사항: 웹과 관련하여 슬러그(slug)는 URL을 사용하여 리소스를 식별하고 설명하는데 사용되는 SEO 친화적인 짧은 텍스트입니다.

시드(seed) 레코드는 다음과 같습니다.

::

    INSERT INTO news VALUES 
    (1,'Elvis sighted','elvis-sighted','Elvis was sighted at the Podunk internet cafe. It looked like he was writing a CodeIgniter app.'),
    (2,'Say it isn\'t so!','say-it-isnt-so','Scientists conclude that some programmers have a sense of humor.'),
    (3,'Caffeination, Yes!','caffeination-yes','World\'s largest coffee shop open onsite nested coffee shop for staff only.');

데이터베이스에 연결
*********************

CodeIgniter를 설치할 때 생성한 로컬 구성 파일 ``.env``\ 를 열어 데이터베이스 속성의 주석을 해제하고 사용하려는 데이터베이스에 맞게 설정하십시오.
:doc:`여기 <../database/configuration>`\ 에 설명된 대로 데이터베이스를 올바르게 구성했는지 확인합니다.

::

    database.default.hostname = localhost
    database.default.database = ci4tutorial
    database.default.username = root
    database.default.password = root
    database.default.DBDriver = MySQLi

모델(model) 설정
******************

컨트롤러에서 데이터베이스 작업을 바로 작성하는 대신 쿼리를 모델에 배치하면 나중에 쉽게 재사용 할 수 있습니다.
모델은 데이터베이스 또는 다른 데이터 저장소에서 정보를 검색, 삽입 및 업데이트하는 장소이자, 데이터에 대한 액세스를 제공합니다.
자세한 내용은 :doc:`여기 </models/model>`\ 를 참조하십시오.

**app/Models/** 디렉터리에 **NewsModel.php**\ 라는 새 파일을 만들고 다음 코드를 추가하십시오.
:doc:`여기 <../database/configuration>`\ 에 설명 된대로 데이터베이스를 올바르게 구성했는지 확인하십시오.

.. literalinclude:: news_section/001.php

이 코드는 앞서 사용한 컨트롤러 코드와 비슷합니다.
``CodeIgniter\Model``\ 을 확장하여 새 모델을 만들고 데이터베이스 라이브러리를 로드합니다.
이렇게 하면 ``$this->db`` 객체를 통해 데이터베이스 클래스를 사용할 수 있게 됩니다.

데이터베이스와 모델이 설정되었으므로 데이터베이스에서 모든 게시물을 가져올 방법이 필요합니다.
CodeIgniter 포함된 데이터베이스 추상화 계층 - :doc:`Query Builder <../database/query_builder>` - 는 ``CodeIgnite\Model``\ 에 사용됩니다.
이를 통해 한 번 작성된 쿼리는 :doc:`지원되는 모든 데이터베이스 시스템 <../intro/requirements>`\ 에서 작동할 수 있습니다.
Model 클래스를 사용하면 Query Builder로 쉽게 작업 할 수 있으며 데이터 작업을 보다 간단하게 수행할 수 있는 추가 도구도 제공됩니다.
다음 코드를 모델에 추가하십시오.

.. literalinclude:: news_section/002.php

이 코드를 사용하면 두 가지 다른 쿼리를 수행 할 수 있습니다.
모든 뉴스 레코드를 얻거나, `slug <#>`_\ 를 통해 뉴스 항목을 얻을 수 있습니다.
:doc:`Query Builder <../database/query_builder>`\ 를 실행하기 전 ``$slug`` 변수에 값이 제거되지 않았습니다.

여기서 사용되는 두 가지 메소드 ``findAll()``\ 과 ``first()``\ 는 ``CodeIgniter\Model`` 클래스에 의해 제공됩니다.
이 두 메소드는 이미 우리가 앞서 **NewsModel** 클래스에 설정한 ``$table`` 속성을 기준으로 사용할 테이블를 알고 있습니다.
이 메소드는 Query Builder를 사용하여 현재 테이블에서 명령을 실행하고 원하는 형식으로 결과 배열을 반환하는 도우미(helper) 메소드입니다.
이 예에서 ``findAll()``\ 은 일련의 객체(object)를 반환합니다.

뉴스 표시
***********

쿼리가 작성되었으므로 모델은 뉴스 항목을 사용자에게 표시할 뷰와 연결되어야 합니다.
이는 앞서 만든 ``Pages`` 컨트롤러에서 할 수 있지만, 명확한 연결을 위해 새로운 ``News`` 컨트롤러를 정의합니다. 
**app/Controllers/News.php**\ 로 새 컨트롤러를 생성하십시오.

.. literalinclude:: news_section/003.php

코드를 살펴보면 앞서 만든 파일과 비슷한 점이 있을 수 있습니다.
첫째, 핵심 CodeIgniter 클래스인 ``Controller``\ 를 확장하여 몇 가지 도우미 메소드를 제공하며, 
디스크에 정보를 저장하는 ``Logger`` 클래스와 ``Request`` 및 ``Response`` 객체를 사용할 수 있도록 합니다.
다음으로 두 가지 메소드가 있는데, 모든 뉴스 항목을 보는 메소드와 특정 뉴스 항목을 보는 메소드입니다.
두 번째 메소드에서는 ``$slug`` 변수가 모델의 메소드로 전달되는 것을 볼 수 있습니다.
모델은 이 slug를 사용하여 뉴스 항목을 식별합니다.

이제 데이터는 모델을 통해 컨트롤러에 검색되지만, 아직 아무것도 표시되지 않습니다.
다음으로 해야할 일은 이 데이터를 뷰에 전달하는 것입니다. 
``index()`` 메소드를 다음과 같이 수정하십시오.

.. literalinclude:: news_section/004.php

위의 코드는 모델로부터 모든 뉴스를 가져와 변수에 할당합니다.
title의 값은 ``$data['title']`` 요소에 할당되며 모든 데이터는 뷰로 전달됩니다.
뉴스 항목을 렌더링하려면 뷰를 작성해야합니다.
**app/Views/news/overview.php**\ 를 생성하고 다음 코드를 추가합니다.

.. literalinclude:: news_section/005.php

.. note:: XSS 공격을 방지하기 위해 다시 **esc()**\ 를 사용하고 있습니다.
    하지만 이번에는 "url"\ 을 두 번째 매개 변수로 전달했습니다. 
    출력이 사용되는 상황에 따라 공격 패턴이 다르기 때문입니다.
    자세한 내용은 :doc:`여기 </general/common_functions>`\ 를 참조하십시오.

여기서, 각 뉴스 항목은 루프를 이용하여 사용자에게 표시됩니다.
우리는 템플릿에 HTML과 PHP를 섞어 사용한 것을 볼 수 있습니다.
템플릿 언어를 사용하고 싶다면 CodeIgniter의 :doc:`View Parser </outgoing/view_parser>` 
또는 타사의 파서를 사용하십시오.

뉴스 개요(overview) 페이지는 현재 완료되었지만, 개별 뉴스 항목을 표시할 페이지는 여전히 없습니다.
앞서 만든 모델은 이 기능을 쉽게 사용할 수 있도록 만들어졌습니다.
컨트롤러에 일부 코드를 추가하고 새로운 뷰를 작성하면 됩니다.
``News`` 컨트롤러로 돌아가서 다음과 같이 ``view()`` 메소드를 업데이트하십시오.

.. literalinclude:: news_section/006.php

매개 변수없이 ``getNews()`` 메소드를 호출하는 대신 ``$slug`` 변수가 전달되므로 특정 뉴스 항목을 반환합니다.
이제 남은 것은 뷰를 만드는 일입니다. **app/Views/news/view.php** 파일에 다음 코드를 추가하세요.

.. literalinclude:: news_section/007.php

.. note:: XSS 공격을 방지하기 위해 다시 ``esc()``\ 를 사용하고 있습니다.
    하지만 이번에는 "url"\ 을 두 번째 매개 변수로 전달했습니다. 
    출력이 사용되는 상황에 따라 공격 패턴이 다르기 때문입니다.
    자세한 내용은 :doc:`여기 </general/common_functions>`\ 를 참조하십시오.

라우팅
*******

라우팅 파일(**app/Config/Routes.php**)을 다음과 같이 수정합니다.

이를 통해 요청이 ``Pages`` 컨트롤러로 직접 이동하지 않고 ``News`` 컨트롤러에 도달할 수 있습니다.
첫 번째 줄은 슬러그가 있는 URI를 ``News`` 컨트롤러의 ``view()`` 메서드로 라우팅합니다.

.. literalinclude:: news_section/008.php

브라우저를 "news" 페이지(예: ``localhost:8080/news``)로 지정하면 뉴스 항목 목록이 표시되며, 각 항목에는 기사 하나만 표시할 수 있는 링크가 제공됩니다.

.. image:: ../images/tutorial2.png
    :align: center
