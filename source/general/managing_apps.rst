##########################
어플리케이션 관리
##########################

기본적으로 CodeIgniter를 사용하여 하나의 어플리케이션만 관리한다면 **application** 디렉토리에 빌드됩니다.
그러나 단일 CodeIgniter를 공유하는 여러 어플리케이션 세트를 보유하거나, 어플리케이션 디렉토리의 이름을 바꾸거나 재배치할 수도 있습니다.

어플리케이션 디렉토리 이름 바꾸기 또는 재배치
================================================

어플리케이션 디렉토리의 이름을 바꾸거나 프로젝트 루트를 서버의 다른 위치로 옮기려면 **app/Config/Paths.php** 
파일의 ``$appDirectory`` 변수에 *전체 서버 경로*\ 를 설정하십시오.(45번째 행)

::

    public $appDirectory = '/path/to/your/application';

``Paths`` 구성 파일을 찾을 수 있도록 프로젝트 루트에서 두 개의 파일을 수정해야합니다: 

- ``/spark`` 파일의 44번째 행, 커맨드 라인(command line) 앱 실행에 사용됩니다.

::

    $pathsConfig = 'app/Config/Paths.php';
    // ^^^ Change this line if you move your application folder


- ``/public/index.php`` 파일의 16번째 행, webapp의 프론트 컨트롤러입니다.

::

    $pathsConfig = FCPATH . '../app/Config/Paths.php';
    // ^^^ Change this if you move your application folder


하나의 설치된 CodeIgniter로 여러 어플리케이션 실행하기
===============================================================

이미 설치된 CodeIgniter 프레임워크를 공유하여 여러 다른 어플리케이션을 사용하려면 어플리케이션 디렉토리 내부에 있는 모든 디렉토리를 자체(또는 서브) 디렉토리에 두십시오.

예를 들어 "foo"와 "bar"\ 라는 두 개의 어플리케이션을 만들고 싶다고 가정해 봅시다.
다음과 같이 어플리케이션 프로젝트 디렉토리를 구성할 수 있습니다.

.. code-block:: text

    /foo
        /app
        /public
        /tests
        /writable
    /bar
        /app
        /public
        /tests
        /writable
    /codeigniter
        /system
        /docs

여기에는 표준 어플리케이션 디렉토리와 ``public`` 폴더가 있고 이미 설치된 codeigniter 프레임워크를 공유하는 "foo"와 "bar"\ 라는 두개의 어플리케이션이 있습니다.

각 어플리케이션 내부의 ``index.php``\ 는 자체 구성인 ``../app/Config/Paths.php``\ 를 참조하고 각 내부의 ``$systemDirectory`` 변수는 공유된 공통 시스템 폴더를 참조하도록 설정됩니다.

어플리케이션 중 하나가 커맨드 라인 구성요소를 사용한다면 위에 설명한대로 각 어플리케이션 프로젝트 폴더의 ``spark``\ 를 수정해야 합니다.
