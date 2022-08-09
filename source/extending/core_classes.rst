****************************
코어 시스템 클래스 작성
****************************

CodeIgniter가 실행될 때마다 프레임워크의 일부로 자동 초기화되는 몇 가지 기본 클래스가 있습니다.
이 코어 시스템 클래스는 상황에 따라 자신의 버전으로 바꾸거나 확장할 수 있습니다.

**대부분의 사용자는 이 작업을 수행할 필요가 없지만, 용도에 따라 CodeIgniter 코어를 크게 변경하려는 경우 이를 대체하거나 확장할 수 있습니다.**

.. note:: 코어 시스템 클래스를 변경하는 것은 프레임워크에 많은 변화를 가져올 수 있음으로, 시도하기 전에 자신이 무엇을 하고 있는지 알아야 합니다.

.. contents::
    :local:
    :depth: 2

System Class 목록
=====================

다음은 CodeIgniter가 실행될 때마다 호출되는 코어 시스템 클래스 목록입니다:

*  ``CodeIgniter\Autoloader\Autoloader``
*  ``CodeIgniter\CodeIgniter``
*  ``CodeIgniter\Config\DotEnv``
*  ``CodeIgniter\Config\Services``
*  ``CodeIgniter\Controller``
*  ``CodeIgniter\Debug\Exceptions``
*  ``CodeIgniter\Debug\Timer``
*  ``CodeIgniter\Events\Events``
*  ``CodeIgniter\Filters\Filters``
*  ``CodeIgniter\HTTP\ContentSecurityPolicy``
*  ``CodeIgniter\HTTP\CLIRequest`` (명령줄 실행 전용)
*  ``CodeIgniter\HTTP\IncomingRequest`` (HTTP 실행 전용)
*  ``CodeIgniter\HTTP\Request``
*  ``CodeIgniter\HTTP\Response``
*  ``CodeIgniter\HTTP\Message``
*  ``CodeIgniter\HTTP\URI``
*  ``CodeIgniter\Log\Logger``
*  ``CodeIgniter\Log\Handlers\BaseHandler``
*  ``CodeIgniter\Log\Handlers\FileHandler``
*  ``CodeIgniter\Router\RouteCollection``
*  ``CodeIgniter\Router\Router``
*  ``CodeIgniter\View\View``

코어 클래스 교체
======================

기본 시스템 클래스 대신 고유한 시스템 클래스 중 하나를 사용하려면 다음을 확인하십시오.

    1. :doc:`Autoloader <../concepts/autoloader>`\ 는 새 클래스를 찾을 수 있습니다.
    2. 새 클래스는 적절한 인터페이스를 구현합니다.
    3. 적절한 :doc:`Service <../concepts/services>`\ 를 수정하여 코어 클래스 대신 새 클래스를 로드합니다.

클래스 만들기
-------------------

다음 예는 코어 시스템 클래스 대신 사용할 새 ``App\Libraries\RouteCollection`` 클래스를 작성합니다.

.. literalinclude:: core_classes/001.php

그런 다음 **app/Config/Services.php**\ 에 ``routes``\ 를 추가하여 클래스를 로드 하도록 수정합니다.

.. literalinclude:: core_classes/002.php

코어 클래스 확장
======================

기존 라이브러리에 몇 가지 기능을 추가하기 위해(한 두 가지의 메소드를 추가) 전체 라이브러리를 다시 작성하는 것은 너무 과합니다.
이 경우 클래스를 확장하는 것이 좋습니다.
클래스 확장은 클래스를 하나의 예외를 제외하고 `코어 클래스 교체`_\ 와 거의 동일합니다.

* 클래스 선언은 부모 클래스를 확장해야합니다.

다음 예는 기본 ``RouteCollection`` 클래스를 확장하여 사용자 클래스를 선언합니다.

.. literalinclude:: core_classes/003.php

클래스에서 생성자를 사용해야 하는 경우 부모 생성자를 호출해야 합니다.

.. literalinclude:: core_classes/004.php

**Tip:**  부모 클래스의 메소드와 동일한 이름을 가진 클래스의 모든 메소드가 기본 메소드 대신 사용됩니다("메소드 재정의(method overriding)"\ 라고 함). 이를 통해 CodeIgniter 코어를 실질적으로 변경할 수 있습니다.
