##########################
응용 프로그램 관리
##########################

By default it is assumed that you only intend to use CodeIgniter to
manage one application, which you will build in your **application**
directory. It is possible, however, to have multiple sets of
applications that share a single CodeIgniter installation, or even to
rename or relocate your application directory.
기본적으로 CodeIgniter를 사용하여 **application** 디렉토리 에서 빌드 할 하나의 응용 프로그램 만 관리하려고한다고 가정합니다 . 그러나 단일 CodeIgniter 설치를 공유하거나 심지어는 응용 프로그램 디렉토리의 이름을 변경하거나 위치를 변경하는 여러 개의 응용 프로그램 세트를 가질 수도 있습니다.

Renaming the Application Directory
==================================

If you would like to rename your application directory you may do so
as long as you open **app/Config/Paths.php** file and set its name using
the ``$applicationDirectory`` variable
application 디렉토리의 이름을 바꾸고 싶다면 **app/Config/Paths.php** 파일의 ``$applicationDirectory`` 변수의 값을 원하는 위치로 설정하십시오.

::

	$applicationDirectory = 'application';

Application Directory 재배치
=====================================

It is possible to move your application directory to a different
location on your server than your web root. To do so open
your main **index.php** and set a *full server path* in the
``$applicationDirectory`` variable
application 디렉토리를 웹 루트가 아닌 서버의 다른 위치로 이동할 수 있습니다. 이렇게하려면 기본 **index.php** 를 열고 ``$application_directory`` 변수에 서버의 전체경로를 설정하십시오.

::

	$applicationDirectory = '/path/to/your/application';

하나의 CodeIgniter 설치로 여러 어플리케이션 실행하기
===============================================================

If you would like to share a common CodeIgniter installation to manage
several different applications simply put all of the directories located
inside your application directory into their own sub-directory.
일반적인 CodeIgniter 설치를 공유하여 여러 응용 프로그램을 관리하려는 경우 응용 프로그램 디렉토리 내에있는 모든 디렉토리를 하위 디렉토리에두기 만하면됩니다.

For example, let's say you want to create two applications, named "foo"
and "bar". You could structure your application directories like this
예를 들어 "foo"및 "bar"라는 두 개의 응용 프로그램을 만들고 싶다고 가정 해 봅시다. 다음과 같이 애플리케이션 디렉토리를 구조화 할 수 있습니다.

::

	applications/foo/
	applications/foo/config/
	applications/foo/controllers/
	applications/foo/libraries/
	applications/foo/models/
	applications/foo/views/
	applications/bar/
	applications/bar/config/
	applications/bar/controllers/
	applications/bar/libraries/
	applications/bar/models/
	applications/bar/views/

To select a particular application for use requires that you open your
main index.php file and set the ``$application_directory`` variable. For
example, to select the "foo" application for use you would do this
특정 응용 프로그램을 사용하려면 기본 index.php 파일을 열고 ``$application_directory`` 변수를 설정해야 합니다. 예를 들어 "foo" 응용 프로그램을 사용하려면 다음을 수행하십시오.

::

	$application_directory = 'applications/foo';

.. note:: Each of your applications will need its own **index.php** file
	which calls the desired application. The **index.php** file can be named
	anything you want.
	각 응용 프로그램 에는 원하는 응용 프로그램을 호출하는 자체 **index.php** 파일이 필요합니다. **index.php** 파일은 당신이 원하는 무엇이든 이름을 지정할 수 있습니다.