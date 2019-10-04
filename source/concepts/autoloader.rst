########################
파일 오토로드(autoload)
########################

모든 어플리케이션은 다른 위치에 있는 많은 수의 클래스로 구성되어 있습니다.
프레임워크는 핵심 기능을 위한 클래스를 제공합니다.
응용 프로그램이 작동하도록 하기 위해 여러 라이브러리, 모델 및 기타 엔티티가 있을 것입니다.
프로젝트에서 사용하는 타사(third-party) 클래스가 있을 수도 있습니다.
모든 파일이 어디에 있는지 추적하는 것과 그 위치를 일련의 ``requires()``\ 로 하드코딩하는 것은 엄청난 골칫거리이며 오류가 발생하기 쉽습니다.
그래서 오토로더가 필요합니다.

CodeIgniter provides a very flexible autoloader that can be used with very little configuration.
It can locate individual non-namespaced classes, namespaced classes that adhere to
`PSR4 <http://www.php-fig.org/psr/psr-4/>`_ autoloading
directory structures, and will even attempt to locate classes in common directories (like Controllers,
Models, etc).

For performance improvement, the core CodeIgniter components have been added to the classmap.

The autoloader works great by itself, but can also work with other autoloaders, like
`Composer <https://getcomposer.org>`_, or even your own custom autoloaders, if needed.
Because they're all registered through
`spl_autoload_register <http://php.net/manual/en/function.spl-autoload-register.php>`_,
they work in sequence and don't get in each other's way.

The autoloader is always active, being registered with ``spl_autoload_register()`` at the
beginning of the framework's execution.

Configuration
=============

Initial configuration is done in **/app/Config/Autoload.php**. This file contains two primary
arrays: one for the classmap, and one for PSR4-compatible namespaces.

Namespaces
==========

The recommended method for organizing your classes is to create one or more namespaces for your
application's files. This is most important for any business-logic related classes, entity classes,
etc. The ``psr4`` array in the configuration file allows you to map the namespace to the directory
those classes can be found in::

	$psr4 = [
		'App'         => APPPATH,
		'CodeIgniter' => SYSTEMPATH,
	];

The key of each row is the namespace itself. This does not need a trailing slash. If you use double-quotes
to define the array, be sure to escape the backward slash. That means that it would be ``My\\App``,
not ``My\App``. The value is the location to the directory the classes can be found in. They should
have a trailing slash.

By default, the application folder is namespace to the ``App`` namespace. While you are not forced to namespace the controllers,
libraries, or models in the application directory, if you do, they will be found under the ``App`` namespace.
You may change this namespace by editing the **/app/Config/Constants.php** file and setting the
new namespace value under the ``APP_NAMESPACE`` setting::

	define('APP_NAMESPACE', 'App');

You will need to modify any existing files that are referencing the current namespace.

.. important:: Config files are namespaced in the ``Config`` namespace, not in ``App\Config`` as you might
	expect. This allows the core system files to always be able to locate them, even when the application
	namespace has changed.

Classmap
========

The classmap is used extensively by CodeIgniter to eke the last ounces of performance out of the system
by not hitting the file-system with extra ``is_file()`` calls. You can use the classmap to link to
third-party libraries that are not namespaced::

	$classmap = [
		'Markdown' => APPPATH .'third_party/markdown.php'
	];

The key of each row is the name of the class that you want to locate. The value is the path to locate it at.

Legacy Support
==============

If neither of the above methods finds the class, and the class is not namespaced, the autoloader will look in the
**/app/Libraries** and **/app/Models** directories to attempt to locate the files. This provides
a measure to help ease the transition from previous versions.

There are no configuration options for legacy support.

Composer Support
================

Composer support is automatically initialized by default. By default, it looks for Composer's autoload file at
ROOTPATH.'vendor/autoload.php'. If you need to change the location of that file for any reason, you can modify
the value defined in ``Config\Constants.php``.

.. note:: If the same namespace is defined in both CodeIgniter and Composer, CodeIgniter's autoloader will be
    the first one to get a chance to locate the file.
