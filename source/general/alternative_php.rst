###################################
View를 위한 PHP 대체 구문
###################################

If you do not utilize a templating engine to simplify output,
you'll be using pure PHP in your
View files. To minimize the PHP code in these files, and to make it
easier to identify the code blocks it is recommended that you use PHPs
alternative syntax for control structures and short tag echo statements.
If you are not familiar with this syntax, it allows you to eliminate the
braces from your code, and eliminate "echo" statements.
출력을 단순화하기 위해 템플릿 엔진을 사용하지 않으면 뷰 파일에 순수 PHP가 사용됩니다. 이 파일에서 PHP 코드를 최소화하고 코드 블록을 쉽게 식별 할 수 있도록하려면 제어 구조 및 짧은 태그 에코 문에 PHP 대체 구문을 사용하는 것이 좋습니다. 이 구문에 익숙하지 않은 경우 코드에서 중괄호를 제거하고 "echo"문을 제거 할 수 있습니다.

Alternative Echos
=================

Normally to echo, or print out a variable you would do this
일반적으로 변수를 출력하려면 다음과 같이하면됩니다

::

	<?php echo $variable; ?>

With the alternative syntax you can instead do it this way
대체 구문을 사용하면 대신 다음과 같이 할 수 있습니다.

::

	<?= $variable ?>

Alternative Control Structures
==============================

Controls structures, like if, for, foreach, and while can be written in
a simplified format as well. Here is an example using ``foreach``
if, for, foreach 및 while과 같은 컨트롤 구조도 단순화 된 형식으로 작성할 수 있습니다. 다음은 ``foreach`` 사용 예입니다.

::

	<ul>

	<?php foreach ($todo as $item) : ?>

		<li><?= $item ?></li>

	<?php endforeach ?>

	</ul>

Notice that there are no braces. Instead, the end brace is replaced with
``endforeach``. Each of the control structures listed above has a similar
closing syntax: ``endif``, ``endfor``, ``endforeach``, and ``endwhile``
중괄호가 없습니다. 대신, ``endforeach`` 로 대체됩니다 . 위의 제어 구조들 각각은 유사한 폐쇄 구문 : ``endif``, ``endfor``, ``endforeach``, 및 ``endwhile``

Also notice that instead of using a semicolon after each structure
(except the last one), there is a colon. This is important!
마지막 구조체를 제외하고 각 구조 뒤에 세미콜론을 사용하는 대신 콜론 (:)이 있습니다. 이건 중요하다!

Here is another example, using ``if``/``elseif``/``else``. Notice the colons
``if``/``elseif``/``else`` 를 사용하는 또 다른 예제가 있습니다. 콜론에 주목하십시오.

::

	<?php if ($username === 'sally') : ?>

		<h3>Hi Sally</h3>

	<?php elseif ($username === 'joe') : ?>

		<h3>Hi Joe</h3>

	<?php else : ?>

		<h3>Hi unknown user</h3>

	<?php endif ?>
