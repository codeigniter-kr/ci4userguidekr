################
Helper Functions
################

.. contents::
    :local:
    :depth: 2

Helpers, as the name suggests, help you with tasks. Each helper file is
simply a collection of functions in a particular category. There are **URL
Helpers**, that assist in creating links, there are **Form Helpers** that help
you create form elements, **Text Helpers** perform various text formatting
routines, **Cookie Helpers** set and read cookies, **File Helpers** help you
deal with files, etc.
이름에서 알 수 있듯이 도우미는 작업에 도움을줍니다. 각 헬퍼 파일은 단순히 특정 범주의 함수 모음입니다. 거기 URL 헬퍼 , 그 링크를 만드는 데 도움이, 거기에 양식 도우미 는 폼 요소를 만들 수 있도록, 텍스트 헬퍼는 다양한 텍스트 서식 루틴을 수행, 쿠키 도우미가 설정 한 쿠키를 읽고, 파일 헬퍼 는 등의 파일을 처리하는 데 도움

Unlike most other systems in CodeIgniter, Helpers are not written in an
Object Oriented format. They are simple, procedural functions. Each
helper function performs one specific task, with no dependence on other
functions.
CodeIgniter의 다른 대부분의 시스템과 달리 도우미는 객체 지향 형식으로 작성되지 않습니다. 그것들은 간단하고 절차적인 기능을합니다. 각 도우미 함수는 다른 함수에 의존하지 않고 하나의 특정 작업을 수행합니다.

CodeIgniter does not load Helper Files by default, so the first step in
using a Helper is to load it. Once loaded, it becomes globally available
in your :doc:`controller </incoming/controllers>` and
:doc:`views </outgoing/views>`.
CodeIgniter는 기본적으로 도우미 파일을로드하지 않으므로 도우미를 사용하기위한 첫 번째 단계는 코드를로드하는 것입니다. 로드되면 컨트롤러 및 뷰 에서 전역 적으로 사용할 수있게됩니다 .

Helpers are typically stored in your **system/Helpers**, or
**application/Helpers directory**. CodeIgniter will look first in your
**application/Helpers directory**. If the directory does not exist or the
specified helper is not located there CI will instead look in your
global *system/Helpers/* directory.
도우미는 일반적으로 시스템 / 도우미 또는 응용 프로그램 / 도우미 디렉토리에 저장 됩니다. CodeIgniter는 응용 프로그램 / 헬퍼 디렉토리를 먼저 찾습니다 . 디렉토리가 존재하지 않거나 지정된 도우미가없는 경우 CI는 대신 전역 시스템 / Helpers / 디렉토리를 조사합니다.

Loading a Helper
================

Loading a helper file is quite simple using the following method
헬퍼 파일을로드하는 것은 다음과 같은 방법을 사용하면 아주 간단합니다

::

	helper('name');

Where **name** is the file name of the helper, without the .php file
extension or the "helper" part.
여기서 name 은 .php 파일 확장자 또는 "도우미"부분없이 도우미의 파일 이름입니다.

For example, to load the **Cookie Helper** file, which is named
**cookie_helper.php**, you would do this
예를 들어, cookie_helper.php 라는 쿠키 도우미 파일 을로드하려면 다음을 수행하십시오.

::

	helper('cookie');

If you need to load more than one helper at a time, you can pass
an array of file names in and all of them will be loaded
한 번에 둘 이상의 도우미를로드해야하는 경우 파일 이름 배열을 전달하면 모든 파일 이름이로드됩니다.

::

	helper(['cookie', 'date']);

A helper can be loaded anywhere within your controller methods (or
even within your View files, although that's not a good practice), as
long as you load it before you use it. You can load your helpers in your
controller constructor so that they become available automatically in
any function, or you can load a helper in a specific function that needs
it.
헬퍼는 컨트롤러 메소드 내 어디에서나로드 할 수 있습니다 (보기 파일 내에서조차도 좋지만 권장하지는 않습니다). 사용하기 전에로드하면됩니다. 컨트롤러 생성자에서 헬퍼를로드하여 함수에서 자동으로 사용할 수있게하거나 헬퍼를 필요로하는 특정 함수에로드 할 수 있습니다.

.. note:: The Helper loading method above does not return a value, so
	don't try to assign it to a variable. Just use it as shown.
	위의 Helper 로딩 방법은 값을 반환하지 않으므로 변수에 할당하지 마십시오. 표시된대로 사용하십시오.

.. note:: The URL helper is always loaded so you do not need to load it yourself.
	URL 도우미는 항상로드되므로 직접로드 할 필요가 없습니다.

Loading from Non-standard Locations
-----------------------------------

Helpers can be loaded from directories outside of **application/Helpers** and
**system/Helpers**, as long as that path can be found through a namespace that
has been setup within the PSR-4 section of the :doc:`Autoloader config file <../concepts/autoloader>`.
You would prefix the name of the Helper with the namespace that it can be located
in. Within that namespaced directory, the loader expects it to live within a
sub-directory named ``Helpers``. An example will help understand this.
도우미는 Autoloader 구성 파일 의 PSR-4 섹션 내에 설정된 네임 스페이스를 통해 찾을 수있는 한 응용 프로그램 / 헬퍼 및 시스템 / 도우미 외부의 디렉토리에서로드 할 수 있습니다 . 도우미의 이름 앞에 접할 수있는 네임 스페이스를 붙이면됩니다. 네임 스페이스가 지정된 디렉토리 내에서 로더는 이름이 지정된 하위 디렉토리 내에 살 것을 기대합니다 . 예를 들어 이해할 수 있습니다.Helpers

For this example, assume that we have grouped together all of our Blog-related
code into its own namespace, ``Example\Blog``. The files exist on our server at
**/Modules/Blog/**. So, we would put our Helper files for the blog module in
**/Modules/Blog/Helpers/**. A **blog_helper** file would be at
**/Modules/Blog/Helpers/blog_helper.php**. Within our controller we could
use the following command to load the helper for us
이 예제에서는 모든 Blog 관련 코드를 고유 한 네임 스페이스로 그룹화했다고 가정합니다 Example\Blog. 파일은 / Modules / Blog / 에있는 우리 서버에 있습니다. 그래서 우리는 블로그 모듈을위한 Helper 파일을 / Modules / Blog / Helpers /에 넣을 것 입니다. blog_helper의 파일에있을 것 /Modules/Blog/Helpers/blog_helper.php . 컨트롤러 내에서 다음 명령을 사용하여 도우미를로드 할 수 있습니다.

::

	helper('Modules\Blog\blog');

.. note:: The functions within files loaded this way are not truly namespaced.
		The namespace is simply used as a convenient way to locate the files.
		이 방법으로 로드된 파일내의 함수는 실제로 네임 스페이스가 아닙니다. 네임 스페이스는 파일 찾기에 편리한 방법으로 사용됩니다.

Using a Helper
==============

Once you've loaded the Helper File containing the function you intend to
use, you'll call it the way you would a standard PHP function.
사용할 함수가 포함 된 도우미 파일을로드하면 표준 PHP 함수와 같은 방식으로 호출합니다.

For example, to create a link using the ``anchor()`` function in one of
your view files you would do this
예를 들어 anchor()뷰 파일 중 하나 에서 함수를 사용하여 링크를 만들려면 다음과 같이하면됩니다.

::

	<?php echo anchor('blog/comments', 'Click Here');?>

Where "Click Here" is the name of the link, and "blog/comments" is the
URI to the controller/method you wish to link to.
여기서 "Click Here"는 링크의 이름이고, "blog/comments"은 링크하려는 controller/method의 URI입니다.

"Extending" Helpers
===================

To "extend" Helpers, create a file in your **application/Helpers/** folder
with an identical name to the existing Helper.

To "extend" Helpers, create a file in your **application/helpers/** folder
with an identical name to the existing Helper, but prefixed with **MY\_**
(this item is configurable. See below.).
헬퍼를 "확장"하려면 **application/helpers/** 폴더에 기존 헬퍼와 동일한 이름으로 파일을 만들고 **MY\_** 가 접두사로 붙습니다 (이 항목은 구성 가능합니다. 아래 참조).

If all you need to do is add some functionality to an existing helper -
perhaps add a function or two, or change how a particular helper
function operates - then it's overkill to replace the entire helper with
your version. In this case it's better to simply "extend" the Helper.
기존 도우미에 몇 가지 기능을 추가하는 것만으로도 충분합니다. 아마도 한 두 가지 기능을 추가하거나 특정 도우미 기능이 작동하는 방식을 변경해야합니다. 그러면 전체 도우미를 버전으로 바꾸는 것이 과잉입니다. 이 경우 단순히 도우미를 확장하는 것이 좋습니다.

.. note:: The term "extend" is used loosely since Helper functions are
	procedural and discrete and cannot be extended in the traditional
	programmatic sense. Under the hood, this gives you the ability to
	add to or or to replace the functions a Helper provides.
	도우미 기능은 절차적이고 이산 적이며 전통적인 프로그래밍 방식으로 확장 될 수 없으므로 "확장"이라는 용어는 느슨하게 사용됩니다. 이 기능은 헬퍼가 제공하는 기능을 추가하거나 대체 할 수있는 기능을 제공합니다.

For example, to extend the native **Array Helper** you'll create a file
named **application/Helpers/array_helper.php**, and add or override
functions
예를 들어 기본 **Array Helper** 를 확장하려면 **application/Helpers/array_helper.php** 라는 파일을 만들고 함수를 추가하거나 재정의합니다.

::

	// any_in_array() is not in the Array Helper, so it defines a new function
	function any_in_array($needle, $haystack)
	{
		$needle = is_array($needle) ? $needle : array($needle);

		foreach ($needle as $item)
		{
			if (in_array($item, $haystack))
			{
				return TRUE;
			}
	        }

		return FALSE;
	}

	// random_element() is included in Array Helper, so it overrides the native function
	function random_element($array)
	{
		shuffle($array);
		return array_pop($array);
	}

The **helper()** method will scan through all PSR-4 namespaces defined in **application/Config/Autoload.php**
and load in ALL matching helpers of the same name. This allows any module's helpers
to be loaded, as well as any helpers you've created specifically for this application. The load order
is as follows:

1. application/Helpers - Files loaded here are always loaded first.
2. {namespace}/Helpers - All namespaces are looped through in the order they are defined.
3. system/Helpers - The base file is loaded last

Now What?
=========

In the Table of Contents you'll find a list of all the available Helper
Files. Browse each one to see what they do.
목차에는 사용 가능한 모든 도우미 파일 목록이 있습니다. 각 항목을 찾아서 그들이하는 일을 확인하십시오.