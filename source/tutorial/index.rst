########
Tutorial
########

이 튜토리얼은 CodeIgniter4 프레임 워크와 MVC 아키텍처의 기본 원칙을 소개하고,
기본적인 CodeIgniter 애플리케이션이 단계별로 구성되는 방법을 보여줍니다.


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

-  Introduction, 이 페이지에서는 예상되는 사항에 대한 개요를 제공합니다.
-  :doc:`Static pages <static_pages>`, 컨트롤러, 뷰 및 라우팅의 기본 사항을 학습합니다.
-  :doc:`News section <news_section>`, 모델을 사용하고 몇 가지 기본 데이터베이스 작업을 수행합니다.
-  :doc:`Create news items <create_news_items>`, 보다 고급적인 데이터베이스 작업 및 폼 검증(form validation)을 도입합니다.
-  :doc:`Conclusion <conclusion>`, 더 많은 자료와 다른 자원(resource)에 대한 힌트를 제공합니다.

CodeIgniter 프레임워크의 탐색을 즐기세요.

.. toctree::
	:hidden:
	:titlesonly:

	static_pages
	news_section
	create_news_items
	conclusion