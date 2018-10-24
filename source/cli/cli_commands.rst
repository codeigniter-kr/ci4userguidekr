###################
사용자 정의 CLI 명령
###################

While the ability to use cli commands like any other route is convenient, you might find times where you
need a little something different. That's where CLI Commands come in. They are simple classes that do not
need to have routes defined for, making them perfect for building tools that developers can use to make
their jobs simpler, whether by handling migrations or database seeding, checking cronjob status, or even
building out custom code generators for your company.
다른 경로와 마찬가지로 cli 명령을 사용할 수있는 기능이 편리하지만 조금 다른 것이 필요할 때가 있습니다. 바로 여기에 CLI 명령이 들어 있습니다. 경로를 정의 할 필요가없는 간단한 클래스로, 개발자가 마이그레이션 또는 데이터베이스 시드 처리, cronjob 상태 확인 또는 작업 수행을 단순화하여 작업을 간단하게 만들 수있는 도구를 빌드하는 데 완벽합니다. 귀사에 맞춤형 코드 생성기를 구축 할 수도 있습니다.

.. contents::
    :local:
    :depth: 2

****************
Running Commands
****************

Commands are run from the command line, in the root directory. The same one that holds the **/application**
and **/system** directories. A custom script, **spark** has been provided that is used to run any of the
cli commands
명령은 명령 행의 루트 디렉토리에서 실행됩니다. **/application** 및 **/system** 디렉토리 를 보유하는 동일한 파일 . cli 명령을 실행하는 데 사용되는 사용자 정의 스크립트 인 **spark** 가 제공되었습니다.

::

    > php spark

When called without specifying a command, a simple help page is displayed that also provides a list of
available commands. You should pass the name of the command as the first argument to run that command
명령을 지정하지 않고 호출하면 사용 가능한 명령 목록을 제공하는 간단한 도움말 페이지가 표시됩니다. 해당 명령을 실행하려면 첫 번째 인수로 명령 이름을 전달해야합니다.

::

    > php spark migrate

Some commands take additional arguments, which should be provided directly after the command, separated by spaces
일부 명령은 추가 인수를 사용합니다.이 인수는 공백으로 구분 된 명령 다음에 직접 제공해야합니다.

::

    > php spark db:seed DevUserSeeder

For all of the commands CodeIgniter provides, if you do not provide the required arguments, you will be prompted
for the information it needs to run correctly
CodeIgniter에서 제공하는 모든 명령에 대해 필요한 인수를 제공하지 않으면 올바르게 실행하는 데 필요한 정보를 입력하라는 메시지가 나타납니다.

::

    > php spark migrate:version
    > Version?

******************
도움말 명령 사용
******************

다음과 같이 help 명령을 사용하면 모든 CLI 명령에 대한 도움말을 얻을 수 있습니다.

::

    > php spark help db:seed

*********************
새 명령 만들기
*********************

You can very easily create new commands to use in your own development. Each class must be in its own file,
and must extend ``CodeIgniter\CLI\BaseCommand``, and implement the ``run()`` method.
당신은 매우 쉽게 자신의 개발에 사용할 새로운 명령을 만들 수 있습니다. 각 클래스는 자체 파일에 있어야하며 확장해야 ``CodeIgniter\CLI\BaseCommand`` 하며  ``run()`` 메서드를 구현 해야합니다 .

The following properties should be used in order to get listed in CLI commands and to add help functionality to your command:
CLI 명령에 나열되고 명령에 도움말 기능을 추가하려면 다음 등록 정보를 사용해야합니다.

* ($group): a string to describe the group the command is lumped under when listing commands. For example (Database)
* ($name): a string to describe the command's name. For example (migrate:create)
* ($description): a string to describe the command. For example (Creates a new migration file.)
* ($usage): a string to describe the command usage. For example (migrate:create [migration_name] [Options])
* ($arguments): an array of strings to describe each command argument. For example ('migration_name' => 'The migration file name')
* ($options): an array of strings to describe each command option. For example ('-n' => 'Set migration namespace')

**Help description will be automatically generated according to the above parameters.**
**위의 매개 변수에 따라 도움말 설명이 자동으로 생성됩니다.**

파일 위치
=============

Commands must be stored within a directory named **Commands**. However, that directory can be located anywhere
that the :doc:`Autoloader </concepts/autoloader>` can locate it. This could be in **/application/Commands**, or
a directory that you keep commands in to use in all of your project development, like **Acme/Commands**.
명령은  **Commands** 라는 이름의 디렉토리에 저장해야합니다. 그러나 해당 디렉토리는 :doc:`Autoloader </concepts/autoloader>` 가 위치 할 수있는 곳이면 어디든 위치 할 수 있습니다 . 이것은 **/application/Commands** 또는 **Acme/Commands** 와 같은 모든 프로젝트 개발에 사용하기 위해 명령을 보관하는 디렉토리에있을 수 있습니다 .

.. note:: When the commands are executed, the full CodeIgniter cli environment has been loaded, making it
 possible to get environment information, path information, and to use any of the tools you would use when making a Controller.
 명령이 실행되면 전체 CodeIgniter CLI 환경이로드되어 환경 정보 및 경로 정보를 얻고 컨트롤러를 만들 때 사용할 도구를 사용할 수 있습니다.

예제 명령
==================

Let's step through an example command whose only function is to report basic information about the application
itself, for demonstration purposes. Start by creating a new file at **/application/Commands/AppInfo.php**. It
should contain the following code
데모 용으로 응용 프로그램 자체에 대한 기본 정보를보고하는 것이 유일한 예제 명령을 단계별로 살펴 보겠습니다. 먼저 **/application/Commands/AppInfo.php** 에 새 파일을 만듭니다 . 다음 코드를 포함해야합니다.

::

    <?php namespace App\Commands;

    use CodeIgniter\CLI\BaseCommand;

    class AppInfo extends BaseCommand
    {
        protected $group       = 'demo';
        protected $name        = 'app:info';
        protected $description = 'Displays basic application information.';

        public function run(array $params)
        {

        }
    }

If you run the **list** command, you will see the new command listed under its own ``demo`` group. If you take
a close look, you should see how this works fairly easily. The ``$group`` property simply tells it how to organize
this command with all of the other commands that exist, telling it what heading to list it under.
list 명령 을 실행하면 새 명령이 자체 demo그룹 아래에 나열됩니다 . 면밀히 살펴보면, 이것이 얼마나 쉽게 작동하는지보아야합니다. 이 $group속성은 존재하는 다른 모든 명령을 사용하여이 명령을 구성하는 방법을 알려주고 어떤 명령을 내려야 할지를 알려줍니다.

The ``$name`` property is the name this command can be called by. The only requirement is that it must not contain
a space, and all characters must be valid on the command line itself. By convention, though, commands are lowercase,
with further grouping of commands being done by using a colon with the command name itself. This helps keep
multiple commands from having naming collisions.
``$name`` 속성은이 명령에 의해 호출 될 수있는 이름입니다. 유일한 요구 사항은 공백을 포함해서는 안되며 모든 문자가 명령 행 자체에서 유효해야합니다. 관례에 따라 명령은 소문자이며 명령 이름을 가진 콜론을 사용하여 명령 그룹을 추가로 그룹화합니다. 이렇게하면 여러 명령의 이름 충돌을 방지 할 수 있습니다.

The final property, ``$description`` is a short string that is displayed in the **list** command and should describe
what the command does.
마지막 속성 ``$description`` 은 **list** 명령에 표시되는 짧은 문자열이며 명령이 수행하는 작업을 설명해야합니다.

run()
-----

The ``run()`` method is the method that is called when the command is being run. The ``$params`` array is a list of
any cli arguments after the command name for your use. If the cli string was
``run()`` 메서드는 실행될때 호출되는 메서드입니다. ``$params`` 배열 사용에 대한 명령 이름 뒤에 어떤 CLI 인수의 목록입니다. cli 문자열이 다음과 같으면 

::

    > php spark foo bar baz

Then **foo** is the command name, and the ``$params`` array would be
그러면 **foo** 가 명령 이름이고 ``$params`` 배열은 다음과 같습니다.

::

    $params = ['bar', 'baz'];

This can also be accessed through the :doc:`CLI </libraries/cli>` library, but this already has your command removed
from the string. These parameters can be used to customize how your scripts behave.
:doc:`CLI </libraries/cli>` 라이브러리를 통해 액세스 할 수도 있지만이 명령은 이미 문자열에서 제거됩니다. 이 매개 변수를 사용하여 스크립트의 작동 방식을 사용자 정의 할 수 있습니다.

Our demo command might have a ``run`` method something like
데모 명령에는 ``run`` 다음과 같은 메소드 가있을 수 있습니다 .

::

    public function run(array $params)
    {
        CLI::write('PHP Version: '. CLI::color(phpversion(), 'yellow'));
        CLI::write('CI Version: '. CLI::color(CodeIgniter::CI_VERSION, 'yellow'));
        CLI::write('APPPATH: '. CLI::color(APPPATH, 'yellow'));
        CLI::write('BASEPATH: '. CLI::color(BASEPATH, 'yellow'));
        CLI::write('ROOTPATH: '. CLI::color(ROOTPATH, 'yellow'));
        CLI::write('Included files: '. CLI::color(count(get_included_files()), 'yellow'));
    }

***********
BaseCommand
***********

The ``BaseCommand`` class that all commands must extend have a couple of helpful utility methods that you should
be familiar with when creating your own commands. It also has a :doc:`Logger </general/logging>` available at
**$this->logger**.
``BaseCommand`` 모든 명령을 확장해야 클래스는 자신의 명령을 만들 때 잘 알고 있어야 도움이 유틸리티 메소드의 몇 가지있다. 또한 **$this->logger** 에서 :doc:`Logger </general/logging>` 를 사용할 수 있습니다.

.. php:class:: CodeIgniter\CLI\BaseCommand

    .. php:method:: call(string $command[, array $params=[] ])

        :param string $command: The name of another command to call.
        :param array $params: Additional cli arguments to make available to that command.

        This method allows you to run other commands during the execution of your current command
        이 방법을 사용하면 현재 명령을 실행하는 동안 다른 명령을 실행할 수 있습니다.
        
        ::

        $this->call('command_one');
        $this->call('command_two', $params);

    .. php:method:: showError(\Exception $e)

        :param Exception $e: The exception to use for error reporting.

        A convenience method to maintain a consistent and clear error output to the cli
        cli에 일관되고 명확한 오류 출력을 유지하는 편리한 방법은 다음과 같습니다.
        
        ::

            try
            {
                . . .
            }
            catch (\Exception $e)
            {
                $this->showError($e);
            }

    .. php:method:: showHelp()

        A method to show command help: (usage,arguments,description,options)
        명령 도움말을 표시하는 방법 : (사용법, 인수, 설명, 옵션)

    .. php:method:: getPad($array, $pad)

        :param Exception $array: The  $key => $value array.
        :param Exception $pad: The pad spaces.

        A method to calculate padding for $key => $value array output. The padding can be used to output a will formatted table in CLI
        $key => $value 배열 출력을 위해 패딩을 계산하는 방법. 패딩은 CLI에서 포맷 된 테이블을 출력하는 데 사용할 수 있습니다.
        
        ::

            $pad = $this->getPad($this->options, 6);
            foreach ($this->options as $option => $description)
            {
                    CLI::write($tab . CLI::color(str_pad($option, $pad), 'green') . $description, 'yellow');
            }

            // Output will be
            -n                  Set migration namespace
            -r                  override file
