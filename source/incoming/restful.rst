RESTful 리소스 처리
#######################################################

.. contents::
    :local:
    :depth: 2

REST(Representational State Transfer)는 2000년 박사학위 논문, `Architectural Styles and the Design of Network-based Software Architectures <https://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm>`_\ 에서 Roy Fielding에 의해 처음 설명된 분산 어플리케이션을위한 아키텍쳐 스타일입니다.
이 논문은 약간의 읽기 어려울 수 있으며, Martin Fowler의 `Richardson Maturity Model <https://martinfowler.com/articles/richardsonMaturityModel.html>`_\ 이 더 부드럽게 이를 소개합니다.

REST는 대부분의 소프트웨어 아키텍처보다 더 많은 방식으로 해석되고 잘못 해석되었으며, 여러분이 아키텍처에서 채택하는 Roy Fielding의 원칙 중 가장 "RESTful"이 고려된다고 말하는 것이 더 쉬울 수도 있습니다.

CodeIgniter를 사용하면 리소스 경로(Resource route)와 `ResourceController`\ 를 사용하여 리소스에 대한 RESTful API를 쉽게 만들 수 있습니다.

리소스 경로(Resource route)
============================================================

``resource()`` 메소드를 사용하여 단일 리소스에 대한 RESTful 경로를 빠르게 만들 수 있습니다.
이렇게하면 리소스의 전체 CRUD에 필요한 5가지 가장 일반적인 경로가 만들어집니다. 
새 리소스를 만들고, 기존 리소스를 업데이트하고, 해당 리소스를 모두 나열하고, 단일 리소스를 표시하고, 단일 리소스를 삭제합니다.
첫 번째 매개 변수는 리소스명입니다

:.. literalinclude:: restful/001.php

.. important:: 위의 순서는 명확성을 위한 것이며, RouteCollection에서 경로가 생성되는 실제 순서는 적절한 경로 확인을 보장합니다.

두 번째 매개 변수는 생성된 경로를 수정하는데 사용할 수 있는 옵션 배열입니다. 
이 경로는 더 많은 메소드가 허용되는 API 사용을 목표로하고 있지만 ``websafe`` 옵션을 전달하여 HTML 폼에서 작동하는 업데이트 및 삭제 메소드를 생성할 수 있습니다.

.. literalinclude:: restful/002.php

사용된 컨트롤러 변경
--------------------------

컨트롤러 이름과 함께 ``controller`` 옵션을 전달하여 사용해야 하는 컨트롤러를 지정할 수 있습니다.

.. literalinclude:: restful/003.php

사용된 자리 표시자(Placeholder) 변경
----------------------------------------

기본적으로 ``(:segment)`` 자리 표시자는 리소스 ID가 필요할 때 사용됩니다.
``placeholder`` 옵션과 함께 문자열을 전달하여 이를 변경할 수 있습니다.

.. literalinclude:: restful/004.php

생성 경로 제한
---------------------

``only`` 옵션으로 생성된 경로를 제한할 수 있습니다.
이것은 메소드 이름 **배열** 또는 **쉼표로 구분된 목록**\ 이어야 합니다.
이 메소드들 중 하나와 일치하는 경로만 생성되고 나머지는 무시됩니다.

.. literalinclude:: restful/005.php

``except`` 옵션을 사용하여 사용하지 않는 경로를 제거할 수 있습니다. 이는 메소드 이름 **배열** 또는 **쉼표로 구분된 목록**\ 이어야 합니다. 이 옵션은 ``only`` 다음에 실행됩니다.

.. literalinclude:: restful/006.php

유효한 메소드: ``index``, ``show``, ``create``, ``update``, ``new``, ``edit``, ``delete``.

ResourceController
============================================================

``ResourceController``\ 는 위의 리소스 경로에 해당하는 RESTful API에 편리한 시작점을 제공합니다.

``modelName``\ 과 ``format`` 속성(propertie)을 재정의하여 확장한 다음 처리하려는 메소드를 구현하십시오.

.. literalinclude:: restful/007.php

이것에 대한 라우팅은

.. literalinclude:: restful/008.php

프리젠터(presenter) 경로
============================================================

``presenter()`` 메소드를 사용하여 리소스 컨트롤러에 맞는 프리젠테이션 컨트롤러를 빠르게 만들 수 있습니다.
이렇게하면 리소스에 대한 뷰를 반환하거나 해당 뷰에서 제출된 프로세스 양식을 반환하는 컨트롤러 메소드에 대한 경로가 생성됩니다.

프레젠테이션은 기존 컨트롤러로 처리할 수 있으므로 필요하지 않습니다.
사용법은 resosurce 라우팅과 유사합니다.

.. literalinclude:: restful/009.php

.. note:: 위의 순서는 명확성을 위한 것이며, RouteCollection에서 경로가 생성되는 실제 순서는 적절한 경로 확인을 보장합니다.

리소스와 프리젠터 컨트롤러 대해 'photos'\ 에 대한 경로는 없습니다.
사례를 들어 구별해야합니다.

.. literalinclude:: restful/010.php


두 번째 매개 변수는 생성된 경로를 수정하는데 사용할 수 있는 옵션 배열입니다.

사용된 컨트롤러 변경
--------------------------

사용할 컨트롤러 이름과 함께 ``controller`` 옵션을 전달하여 사용할 컨트롤러를 지정할 수 있습니다.

.. literalinclude:: restful/011.php

사용된 자리 표시자 변경
---------------------------

기본적으로 ``(:segment)`` 자리 표시자는 리소스 ID가 필요할 때 사용됩니다. 사용할 새 문자열과 함께 ``placeholder`` 옵션을 전달하면 이 항목을 변경할 수 있습니다.

.. literalinclude:: restful/012.php

경로(Route) 제한
--------------------------

``only`` 옵션에 메소드 이름으로 된 **배열** 또는 **쉼표로 구분된 목록**\ 을 전달하여 생성된 경로를 제한할 수 있습니다.
메소드 중 일치하는 경로만 접근할 수 있으며, 나머지는 무시됩니다.

.. literalinclude:: restful/013.php

``except`` 옵션에  메소드 이름으로 된 **배열** 또는 **쉼표로 구분된 목록**\ 을 전달하여 사용하지 않는 경로를 제거할 수 있습니다.
이 옵션은 ``only`` 이 후에 실행됩니다.

.. literalinclude:: restful/014.php

유효한 메소드: ``index``, ``show``, ``new``, ``create``, ``edit``, ``update``, ``remove``, ``delete``.

ResourcePresenter
============================================================

``ResourcePresenter``\ 는 리소스의 뷰를 제공하고 위의 리소스 경로에 맞는 방법으로 해당 뷰의 폼에서 데이터를 처리하기 위한 편리한 시작점을 제공합니다.

``modelName`` 속성을 재정의하여 확장한 다음 처리하려는 메소드를 구현하십시오.

.. literalinclude:: restful/015.php

이것에 대한 경로는

.. literalinclude:: restful/016.php

리센터(resenter)/컨트롤러 비교
==================================

이 테이블은 `resource()`\ 와 `presenter()`\ 에 의해 생성된 기본 라우트를 해당 컨트롤러 함수와 비교합니다.

================ ========= ====================== ======================== ====================== ======================
Operation        Method    Controller Route       Presenter Route          Controller Function    Presenter Function
================ ========= ====================== ======================== ====================== ======================
**New**          GET       photos/new             photos/new               ``new()``              ``new()``
**Create**       POST      photos                 photos                   ``create()``           ``create()``
Create (alias)   POST                             photos/create                                   ``create()``
**List**         GET       photos                 photos                   ``index()``            ``index()``
**Show**         GET       photos/(:segment)      photos/(:segment)        ``show($id = null)``   ``show($id = null)``
Show (alias)     GET                              photos/show/(:segment)                          ``show($id = null)``
**Edit**         GET       photos/(:segment)/edit photos/edit/(:segment)   ``edit($id = null)``   ``edit($id = null)``
**Update**       PUT/PATCH photos/(:segment)                               ``update($id = null)`` 
Update (websafe) POST      photos/(:segment)      photos/update/(:segment) ``update($id = null)`` ``update($id = null)``
**Remove**       GET                              photos/remove/(:segment)                        ``remove($id = null)``
**Delete**       DELETE    photos/(:segment)                               ``delete($id = null)`` 
Delete (websafe) POST                             photos/delete/(:segment) ``delete($id = null)`` ``delete($id = null)``
================ ========= ====================== ======================== ====================== ======================
