***********************
CLIRequest 클래스
***********************

요청이 커맨드 라인 호출에서 오는 경우 요청 객체는 ``CLIRequest``\ 입니다.
:doc:`기존 요청 </incoming/request>`\ 과 동일하게 작동하지만 편의를 위해 몇 가지 접근자 메소드를 추가합니다.

====================
추가 접근자
====================

getSegments()
----------------

경로의 일부로 간주되는 커맨드 라인 인수의 배열을 리턴합니다.

.. literalinclude:: cli_request/001.php

getPath()
---------

재구성된 경로를 문자열로 반환합니다

.. literalinclude:: cli_request/002.php

getOptions()
------------

옵션으로 간주되는 커맨드 라인 인수의 배열을 리턴합니다.

.. literalinclude:: cli_request/003.php

getOption($which)
-----------------

옵션으로 간주되는 특정 커맨드 라인 인수의 값을 리턴합니다.

.. literalinclude:: cli_request/004.php

etOptionString()
----------------

옵션에 대해 재구성된 커맨드 라인 문자열을 리턴합니다.

.. literalinclude:: cli_request/005.php

첫 번째 인수에 ``true``\ 를 전달하면 두 개의 대시(--)를 사용하여 긴 옵션을 작성합니다.

.. literalinclude:: cli_request/006.php