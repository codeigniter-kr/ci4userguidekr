#####################
Application Structure
#####################

To get the most out of CodeIgniter, you need to understand how the application is structured, by default, and what you
can change to meet the needs of your application.
CodeIgniter를 최대한 활용하려면 기본적으로 응용 프로그램의 구조가 어떻게 구성되어 있고 응용 프로그램의 요구 사항에 맞게 변경할 수 있는지 이해해야합니다.

Default Directories
===================

A fresh install has six directories: ``/app``, ``/system``, ``/public``,
``/writable``, ``/tests`` and possibly ``/docs``.
Each of these directories has a very specific part to play.
새로 설치하면 ``/app``, ``/system``, ``/public``, ``/writable``, ``/tests``, ``/docs`` 
등 6 개의 디렉토리가 있습니다. 이 디렉토리들 각각은 매우 특정한 부분을 가지고 있습니다.

application
-----------
The ``application`` directory is where all of your application code lives. This comes with a default directory
structure that works well for many applications. The following folders make up the basic contents:
application응용 프로그램 코드의 모두가 사는 곳 디렉토리입니다. 이것은 많은 응용 프로그램에서 잘 작동하는 기본 디렉토리 구조와 함께 제공됩니다. 다음 폴더는 기본 내용을 구성합니다.

.. code-block:: none

	/app
		/Config         Stores the configuration files 구성 파일을 저장합니다.
		/Controllers    Controllers determine the program flow 컨트롤러가 프로그램 흐름을 결정합니다.
		/Database       Stores the database migrations and seeds files
		/Filters        Stores filter classes that can run before and after controller
		/Helpers        Helpers store collections of standalone functions 독립 실행형 함수 모음을 저장합니다.
		/Language       Multiple language support reads the language strings from here 다중 언어 지원은 여기에서 언어 문자열을 읽습니다.
		/Libraries      Useful classes that don't fit in another category 다른 카테고리에 들어 가지 않는 유용한 클래스들
		/Models         Models work with the database to represent the business entities. 비즈니스 엔티티를 나타 내기 위해 데이터베이스와 작동합니다.
		/ThirdParty     ThirdParty libraries that can be used in application
		/Views          Views make up the HTML that is displayed to the client. 클라이언트에 표시되는 HTML을 구성합니다.

Because the ``app`` directory is already namespaced, you should feel free to modify the structure
of this directory to suit your application's needs. For example, you might decide to start using the Repository
pattern and Entity Models to work with your data. In this case, you could rename the ``Models`` directory to
``Repositories``, and add a new ``Entities`` directory.
application디렉토리가 이미 네임 스페이스로되어 있기 때문에 응용 프로그램의 필요에 맞게이 디렉토리의 구조를 자유롭게 수정할 수 있습니다. 예를 들어 리포지토리 패턴과 엔티티 모델을 사용하여 데이터 작업을 시작할 수 있습니다. 이 경우, Models디렉토리의 이름을로 변경하고 Repositories새 Entities디렉토리를 추가 할 수 있습니다 .

.. note:: If you rename the ``Controllers`` directory, though, you will not be able to use the automatic method of
		routing to controllers, and will need to define all of your routes in the routes file.
		Controllers하지만 디렉토리의 이름을 바꾸면 컨트롤러에 자동 라우팅 방법을 사용할 수 없으며 routes 파일에 모든 경로를 정의해야합니다.

All files in this directory live under the ``App`` namespace, though you are free to change that in
**app/Config/Constants.php**.
이 디렉토리의 모든 파일은 App네임 스페이스 아래 에 있지만, **app/Config/Constants.php** 에서 자유롭게 변경할 수 있습니다 .

system
------
This directory stores the files that make up the framework, itself. While you have a lot of flexibility in how you
use the application directory, the files in the system directory should never be modified. Instead, you should
extend the classes, or create new classes, to provide the desired functionality.
이 디렉토리는 프레임 워크 자체를 구성하는 파일을 저장합니다. 응용 프로그램 디렉토리를 사용하는 방법에 많은 융통성이 있지만 시스템 디렉토리의 파일은 절대로 변경해서는 안됩니다. 대신 원하는 기능을 제공하기 위해 클래스를 확장하거나 새 클래스를 만들어야합니다.

All files in this directory live under the ``CodeIgniter`` namespace.
이 디렉토리의 모든 파일은 CodeIgniter네임 스페이스 아래에 있습니다.

public
------

The **public** folder holds the browser-accessible portion of your web application,
preventing direct access to your source code.
It contains the main **.htaccess** file, **index.php**, and any application
assets that you add, like CSS, javascript, or
images.
공용 폴더는 소스 코드에 직접 액세스를 방지, 웹 애플리케이션의 브라우저에 액세스 할 수있는 부분을 보유하고 있습니다. 기본 .htaccess 파일, index.php 및 CSS, 자바 스크립트 또는 이미지와 같이 추가 한 모든 응용 프로그램 자산을 포함합니다.

This folder is meant to be the "web root" of your site, and your web server
would be configured to point to it.
이 폴더는 사이트의 "웹 루트"로 사용되며 웹 서버를 가리 키도록 구성됩니다.

writable
--------
This directory holds any directories that might need to be written to in the course of an application's life.
This includes directories for storing cache files, logs, and any uploads a user might send. You should add any other
directories that your application will need to write to here. This allows you to keep your other primary directories
non-writable as an added security measure.
이 디렉토리에는 응용 프로그램의 수명 동안 기록해야 할 수도있는 디렉토리가 들어 있습니다. 여기에는 캐시 파일, 로그 및 사용자가 올릴 수있는 모든 업로드를 저장하기위한 디렉토리가 포함됩니다. 응용 프로그램에서 여기에 쓸 다른 디렉토리를 추가해야합니다. 이렇게하면 추가 보안 수단으로 다른 기본 디렉토리를 쓸 수 없게 유지할 수 있습니다.

tests
-----
This directory is setup to hold your test files. The ``_support`` directory holds various mock classes and other
utilities that you can use while writing your tests. This directory does not need to be transferred to your
production servers.
이 디렉토리는 테스트 파일을 저장하도록 설정됩니다. _support디렉토리는 다양한 모의 수업과 테스트를 작성할 때 사용할 수있는 다른 유틸리티를 보유하고 있습니다. 이 디렉토리는 프로덕션 서버로 전송할 필요가 없습니다.

docs
----
If this directory is part of your project, it holds a local copy of the CodeIgniter4
User Guide.
이 디렉토리가 프로젝트의 일부라면, CodeIgniter4 사용자 가이드의 로컬 복사본이 있습니다.

디렉토리 위치 수정
-----------------------------

메인 디렉토리를 재배치했다면 ``app/Config/Paths`` 의 설정을 바꿀 수 있습니다.

`응용 프로그램 관리 <../general/managing.html>`_\ 를 읽어보세요.