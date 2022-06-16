##################
CLI 라이브러리
##################

CodeIgniter의 CLI 라이브러리를 사용하면 다음을 포함하여 대화식 커맨드 라인 스크립트를 간단하게 만들 수 있습니다.

* 사용자에게 더 많은 정보를 요구
* 터미널에 멀티 컬러 텍스트 쓰기
* 경고음 (좋아요!)
* 긴 작업 중에 진행률 표시 줄 표시
* 긴 텍스트 줄을 창에 맞게 줄 바꿈하십시오.

.. contents::
    :local:
    :depth: 2

클래스 초기화
**********************

모든 메소드가 정적이므로 CLI 라이브러리의 인스턴스를 작성할 필요가 없습니다.
대신, 컨트롤러는 클래스 위의 ``use``\ 문을 통해 컨트롤러를 찾을 수 있어야 합니다.

.. literalinclude:: cli_library/001.php

파일이 처음 로드될 때 클래스가 자동으로 초기화됩니다.

사용자로부터 입력 받기
***************************

사용자에게 추가 정보를 요청해야 하는 경우가 있습니다.
선택적 커맨드 라인 인수를 입력 받거나, 기존 파일을 덮어 쓰기 전에 확인이 필요한 경우등등..
이런 경우 ``prompt()`` 또는 ``promptByKey()`` 메소드를 사용하여 처리합니다.

질문을 첫 번째 매개 변수로 전달하여 질문을 제공 할 수 있습니다.

.. literalinclude:: cli_library/002.php

두 번째 매개 변수에서 기본값을 전달하여 사용자가 Enter 키를 누르는 경우 사용할 기본(default) 답변을 제공할 수 있습니다

.. literalinclude:: cli_library/003.php

두 번째 매개 변수로 허용된 답변 배열을 전달하여 허용되는 답변을 제한할 수 있습니다.

.. literalinclude:: cli_library/004.php

마지막으로, :ref:`검증 규칙 <validation>`\ 을 세 번째 매개 변수로 답변 입력에 전달할 수 있습니다.

.. literalinclude:: cli_library/005.php

검증 규칙은 어레이 구문으로도 작성할 수 있습니다.

.. literalinclude:: cli_library/006.php

**promptByKey()**

프롬프트에 대한 미리 정의된 답변(옵션)을 설명해야 하거나 너무 복잡하여 값을 통해 선택할 수 없는 경우
 ``promptByKey()``\ 를 사용하면 값이 아닌 키로 옵션을 선택할 수 있습니다.

.. literalinclude:: cli_library/007.php

명명된 키도 가능합니다.

.. literalinclude:: cli_library/008.php

마지막으로 :ref:`validation <validation>` 규칙을 세 번째 매개 변수로 전달하면, 허용되는 답변은 전달된 옵션에 의해 검증됩니다.


피드백 제공
******************

write()
========

사용자에게 피드백을 제공하기 위해 몇 가지 방법이 제공됩니다.
이는 단일 상태 업데이트나 사용자의 터미널 창으로 래핑되는 복잡한 정보 테이블처럼 간단할 수 있습니다.
이것의 핵심에는 문자열을 첫 번째 매개 변수로 출력하는 ``write()`` 메소드입니다

.. literalinclude:: cli_library/009.php

두 번째 매개 변수로 색상 이름을 전달하여 텍스트 색상을 변경할 수 있습니다

.. literalinclude:: cli_library/010.php

상태별로 메시지를 구분하거나 다른 색상을 사용하여 '헤더'를 만드는 데 사용할 수 있습니다.
세 번째 매개 변수로 색 이름을 전달하여 배경색을 설정할 수 있습니다

.. literalinclude:: cli_library/011.php

다음과 같은 전경색(foreground color)을 사용할 수 있습니다:

* black
* dark_gray
* blue
* dark_blue
* light_blue
* green
* light_green
* cyan
* light_cyan
* red
* light_red
* purple
* light_purple
* light_yellow
* yellow
* light_gray
* white

배경색(background color)으로 다음 색상을 사용할 수 있습니다:

* black
* blue
* green
* cyan
* red
* yellow
* light_gray
* magenta

print()
========

전후에 개행을 강요하지 않는다는 점을 제외하면 ``write()`` 메소드와 동일합니다.
대신 커서가 현재 어디에 있든지 화면에 인쇄합니다.
이를 통해 다른 호출에서 동일한 라인에 여러 항목을 인쇄할 수 있습니다.
이것은 상태를 보여주고 무언가를 한 다음 같은 줄에 "완료"를 인쇄할 때 특히 유용합니다.

.. literalinclude:: cli_library/012.php

.. _cli-library-color:

color()
========

``write()`` 명령은 터미널에 한 줄을 쓰고 EOL 문자로 끝나는 반면, 인쇄 후 EOL을 강제하지 않는다는 점을 제외하고 ``color()``메소드를 사용하여 동일한 문자열을 만들 수 있습니다 . 
이를 통해 동일한 행에 여러 출력을 만들 수 있습니다. 
또는 더 일반적으로 ``write()`` 메소드 내부에서 다른 색상의 문자열을 만들 수 있습니다

.. literalinclude:: cli_library/013.php

이 예제는 창에 ``fileA``\ 가 노란색으로 표시되고 탭(tab) 다음에 흰색 텍스트로 ``/path/to/file``\ 이 표시됩니다.

error()
========

오류를 출력할 때는 ``error()`` 메소드를 사용합니다.
``write()``, ``color()``\ 와 같이 STDOUT 아닌 STDERR에 밝은 빨간색 텍스트를 출력합니다.
스크립트가 오류를 감시하고, 모든 정보를 조사할 필요 없이 실제 오류 메시지만 조사할 때 유용합니다.
사용 방법은 ``write()`` 메소드와 같습니다.

.. literalinclude:: cli_library/014.php

wrap()
========

이 명령은 문자열을 가져 와서 현재 줄에 인쇄를 시작한 다음 줄을 설정한 길이로 줄 바꿈합니다.
이것은 현재 창에서 줄 바꿈하고 화면을 벗어나지 않을 설명이 있는 옵션 목록을 표시할 때 유용합니다.

.. literalinclude:: cli_library/015.php

기본적으로 문자열은 터미널 너비로 줄 바꿈됩니다.
Windows는 현재 창 크기를 결정하는 방법을 제공하지 않으므로 기본값은 80 자입니다.
폭을 더 짧은 것으로 제한하려면 창에 꼭 맞는 최대 길이를 두 번째 매개 변수로 전달하십시오.
이렇게 하면 최대 길이에 가장 가까운 단어에서 문자열이 끊어 지므로 단어가 깨지지 않습니다.

.. literalinclude:: cli_library/016.php

제목, 파일 또는 작업의 왼쪽에 열이 있고 오른쪽에 설명이 있는 텍스트 열이 필요하다는 것을 알 수 있습니다.
기본적으로 이것은 창의 왼쪽 가장자리로 다시 줄 바꿈되어 열에 정렬할 수 없습니다.
이 경우 첫 줄 다음에 모든 줄을 채우도록 여러 공간을 전달하여 왼쪽에 선명한 열 가장자리를 갖도록 할 수 있습니다

.. literalinclude:: cli_library/017.php

이런 식으로 만들어집니다:

.. code-block:: none

    task1a     Lorem Ipsum is simply dummy
               text of the printing and
               typesetting industry.
    task1abc   Lorem Ipsum has been the
               industry's standard dummy
               text ever since the

newLine()
==========

``newLine()`` 메소드는 빈 줄을 표시합니다. 매개 변수를 사용하지 않습니다

.. literalinclude:: cli_library/018.php

clearScreen()
=============

``clearScreen()`` 메소드를 사용하여 현재 터미널 창을 지울 수 있습니다.
대부분의 Windows 버전에서는 Windows에서 이 기능을 지원하지 않으므로 40 개의 빈 줄만 삽입합니다.
Windows 10 bash 통합은 이것을 변경해야 합니다

.. literalinclude:: cli_library/019.php

showProgress()
===============

진행 상황에 따라 상태를 계속 업데이트하는 작업 시간이 긴 실행 작업이있는 경우 다음과 같은 ``showProgress()`` 메소드를 사용할 수 있습니다:

.. code-block:: none

    [####......] 40% Complete

이 블록은 매우 멋진 효과를 위해 애니메이션 처리됩니다.

이를 사용하려면 현재 단계에서 첫 번째 매개 변수로, 총 단계 수를 두 번째 매개 변수로 전달하십시오.
완료율과 디스플레이 길이는 해당 숫자를 기준으로 결정됩니다. 
완료되면 ``false``\ 를 첫 번째 매개 변수로 전달하면 진행률 표시 줄이 제거됩니다.

.. literalinclude:: cli_library/020.php

table()
========

.. literalinclude:: cli_library/021.php

.. code-block:: none

    +----+--------------------------+---------------------+--------+
    | ID | Title                    | Updated At          | Active |
    +----+--------------------------+---------------------+--------+
    | 7  | A great item title       | 2017-11-16 10:35:02 | 1      |
    | 8  | Another great item title | 2017-11-16 13:46:54 | 0      |
    +----+--------------------------+---------------------+--------+

wait()
=======

선택적으로 대기 메시지를 표시하고 특정 시간(초)동안 키 누름을 기다립니다.

.. literalinclude:: cli_library/022.php
