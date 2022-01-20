########
Tutorial
########

이 튜토리얼은 CodeIgniter4 프레임워크와 MVC 아키텍처의 기본 원칙을 소개하고,
기본적인 CodeIgniter 어플리케이션이 단계별로 구성되는 방법을 보여줍니다.


PHP에 익숙하지 않다면 계속하기 전에 `W3Schools PHP Tutorial <https://www.w3schools.com/php/default.asp>`_\ 을 확인하는 것이 좋습니다.

이 튜토리얼에서는 **basic news application**\ 을 만듭니다.
정적 페이지를 로드할 수 있는 코드를 작성을 시작하여 데이터베이스에서 뉴스 항목을
읽는 뉴스 섹션을 만들고, 마지막으로, 데이터베이스에 뉴스 항목을 만들기 위해 폼(form)을 추가합니다.

본 튜토리얼은 주로 다음을 학습하는데 초점을 맞춥니다.:

-  Model-View-Controller 기본
-  기본 Routing
-  폼 검증(form validation)
-  CodeIgniter의 "Query Builder"를 사용하여 기본 데이터베이스 쿼리 수행

전체 튜토리얼은 몇 페이지에 걸쳐 분할되며, CodeIgniter 프레임워크의 기능중 작은 부분을 설명합니다.
다음 페이지를 살펴보십시오.:

-  Introduction, 이 페이지에서는 예상한 사항에 대한 개요를 제공하고, 기본 어플리케이션을 다운로드하여 실행합니다.
-  :doc:`Static pages <static_pages>`, 컨트롤러, 뷰, 라우팅의 기본 사항을 학습합니다.
-  :doc:`News section <news_section>`, 모델을 사용하고 몇 가지 기본 데이터베이스 작업을 수행합니다.
-  :doc:`Create news items <create_news_items>`, 보다 고급적인 데이터베이스 작업과 폼 검증(form validation)을 도입합니다.
-  :doc:`Conclusion <conclusion>`, 더 많은 자료와 다른 자원(resource)에 대한 힌트를 제공합니다.

CodeIgniter 프레임워크의 탐색을 즐기세요.

.. toctree::
	:hidden:
	:titlesonly:

	static_pages
	news_section
	create_news_items
	conclusion

시작 및 실행
**********************

사이트에서 수동으로 릴리스를 다운로드할 수 있지만, 이 튜토리얼은 Composer를 통해 AppStarter 패키지를 설치하는 방법을 사용합니다.
명령줄에서 다음을 입력합니다.

::

    > composer create-project codeigniter4/appstarter ci-news

``vendor`` 폴더에 CodeIgniter가 설치되고 어플리케이션 코드가 포함된 ``ci-news`` 라는 새 폴더가 생성됩니다.

기본적으로 CodeIgniter는 ``production`` 모드에서 시작됩니다.
이 모드는 라이브 설정이 잘못되었을 때 사이트를 좀 더 안전하게 유지하기 위한 안전 모드입니다.
먼저 그것을 수정해봅시다. "env" 파일을 ".env"로 복사한 후 에디터로 여세요.

이 파일에는 서버별 설정이 포함되어 있습니다. git과 같은 버전 관리 시스템에 이 중요한 정보를 커밋(commit)하지 마세요.
여기에는 일반적으로 가장 많이 사용되는 항목중 일부가 포함되어 있지만, 모두 주석 처리되어 있습니다.
``production`` 모드 변경을 위해 ``CI_ENVIRONMENT``\ 가 있는 라인의 주석 처리를 제거하고 ``development``\ 로 변경합니다.

::

    CI_ENVIRONMENT = development

이제 브라우저에서 어플리케이션을 볼 차례입니다.
Apache, Nginx 등과 같은 웹 서버를 통해 서비스를 제공할 수 있지만, CodeIgniter에는 PHP의 내장 서버를 활용하여 개발 컴퓨터에서 빠르게 실행되도록 하는 간단한 명령이 포함되어 있습니다.
프로젝트 루트의 명령줄에 다음을 입력합니다.

::

    > php spark serve


시작 페이지
****************

이제 브라우저에 다음 URL을 입력하여 시작 화면이 표시되도록 하십시오.

::

    http://localhost:8080

다음 페이지가 여러분을 반길겁니다.

.. image:: ../images/welcome.png

이제 어플리케이션을 변경하고 작동할 수 있습니다.

디버깅
*********

개발(development) 모드로 수정하였으므로 어플리케이션 하단에 툴바가 표시됩니다.
이 도구 모음에는 개발 중에 참조할 수 있는 여러 가지 유용한 항목이 포함되어 있습니다.
운영(production) 환경에서는 표시되지 않습니다.
아래쪽에 있는 탭을 클릭하면 추가 정보가 표시됩니다.
툴바의 오른쪽에있는 X를 클릭하면 CodeIgniter 불꽃이 있는 작은 사각형으로 최소화됩니다.
불꽃을 클릭하면 툴바가 다시 표시됩니다.

이 외에도 CodeIgniter에는 프로그램에서 예외 또는 기타 오류가 발생할 때 유용한 오류 페이지가 있습니다.
``app/Controllers/Home.php``\ 를 열어 일부 라인을 변경하여 오류를 생성하십시오.(세미콜론이나 중괄호를 제거하면 효과가 있습니다!).

다음과 같은 화면이 나타납니다.

.. image:: ../images/error.png

여기에 주목해야 할 몇 가지가 있습니다.

1. 맨 위에 있는 빨간 머리글 위로 마우스를 가져 가면 DuckDuckGo.com에서 예외를 검색하여 새 탭에 보여주는 ``search`` 링크가 나타납니다.
2. Backtrace의 임의의 행에서 ``arguments`` 링크를 클릭하면 해당 함수 호출에 전달된 인수 목록을 볼 수 있습니다.

당신이 그것을 본다면 다른 모든 것이 명확해질 겁니다.


이제 여러분은 시작하는 방법을 알았습니다.
