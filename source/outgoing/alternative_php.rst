###################################
뷰(View)를 위한 대체 PHP 구문
###################################

템플릿 엔진을 사용하여 출력을 단순화하지 않으면 View 파일에서 순수한 PHP를 사용하게 됩니다.
이러한 파일에서 PHP 코드를 최소화하고 코드 블록을 보다 쉽게 식별하려면 제어 구조와 짧은 태그 에코(echo) 명령문에 대해 PHP의 대체 구문을 사용하는 것이 좋습니다.
이 구문에 익숙해지면 뷰의 PHP 코드에서 중괄호를 제거하고 "echo"\ 문을 제거 할 수 있습니다.

대체 echo
=================

일반적으로 변수를 출력하려면 다음과 같이합니다.

::

	<?php echo $variable; ?>

대체 구문을 사용하면 이렇게 할 수 있습니다

::

	<?= $variable ?>

대체 제어 구조
==============================

``if``, ``for``, ``foreach``, ``while``\ 과 같은 제어 구조를 단순화된 형식으로도 작성할 수 있습니다.
다음은 ``foreach``\ 를 사용하는 예입니다.

.. literalinclude:: alternative_php/001.php

중괄호가 없습니다. 대신 종료 중괄호가 ``endforeach``\ 로 바뀝니다.
Each of the control structures listed above has a similar closing syntax: ``endif``, ``endfor``, ``endforeach``, and ``endwhile``
위에 나열된 각 제어 구조에도 비슷한 ``endif``, ``endfor``, ``endforeach``, ``endwhile`` 구문이 있습니다.

또한 시작되는 각 제어 구조문 뒤에 세미콜론(;)을 사용하는 대신 (마지막 구조 제외) 콜론(:)이 있습니다. 이것은 중요합니다!

다음은 ``if``/``elseif``/``else``\ 를 사용하는 다른 예입니다. 콜론(:)에 주목

.. literalinclude:: alternative_php/002.php
