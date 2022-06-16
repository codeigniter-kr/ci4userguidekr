#####################
커스텀 함수 호출
#####################

.. contents::
    :local:
    :depth: 2

$db->callFunction();
============================

이 함수를 사용하면 플랫폼 독립적인 방식으로 CodeIgniter에 기본적으로 포함되지 않은 PHP 데이터베이스 함수를 호출할 수 있습니다.
예를 들어, ``mysql_get_client_info()`` 함수를 호출한다고 가정해 봅시다.
이 함수는 CodeIgniter에서 기본적으로 **지원하지 않습니다**.
다음과 같이 할 수 있습니다.

.. literalinclude:: call_function/001.php

첫 번째 매개 변수에 mysql\_ 접두사를 **붙이지 않고** 함수 이름을 제공해야합니다.
접두사는 현재 사용중인 데이터베이스 드라이버에 따라 자동으로 추가됩니다.
이를 통해 다른 데이터베이스 플랫폼에서 동일한 기능을 실행할 수 있습니다.
분명 모든 함수 호출이 플랫폼간에 동일하지는 않으므로 이식성 측면에서 이 함수가 얼마나 유용한 지에 대한 한계가 있습니다.

함수 호출에 필요한 매개 변수는 두 번째 매개 변수에 추가합니다.

.. literalinclude:: call_function/002.php

종종 데이터베이스 연결(connect) ID 또는 데이터베이스 결과 ID를 제공해야합니다. 
연결 ID는 다음과 같이 액세스할 수 있습니다.

.. literalinclude:: call_function/003.php

결과(result) 객체내에서 결과 ID에 액세스하려면 다음과 같이 하십시오.

.. literalinclude:: call_function/004.php