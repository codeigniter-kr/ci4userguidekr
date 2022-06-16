#################
Filesystem 헬퍼
#################

디렉토리 헬퍼 파일에는 디렉토리 작업을 지원하는 기능이 있습니다.

.. contents::
    :local:
    :depth: 2


헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

.. literalinclude:: filesystem_helper/001.php

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: directory_map($sourceDir[, $directoryDepth = 0[, $hidden = false]])

    :param	string  $sourceDir: 소스 디렉토리의 경로
    :param	int	    $directoryDepth: 탐색할 디렉토리의 깊이 (0 = 완전 재귀, 1 = 현재 디렉토리 등)
    :param	bool	$hidden: 숨겨진 경로 포함 여부
    :returns:	파일의 배열
    :rtype:	array

    .. literalinclude:: filesystem_helper/002.php

    .. note:: 경로는 index.php 파일을 기준으로 합니다.

    디렉토리에 포함된 하위 폴더도 매핑됩니다. 
    재귀 깊이를 제어하려면 두 번째 매개 변수 (정수)를 사용하면됩니다. 
    깊이 1은 최상위 디렉토리만 매핑합니다.

    .. literalinclude:: filesystem_helper/003.php

    기본적으로 숨김 파일은 반환된 배열에 포함되지 않으며 숨김 디렉토리는 건너뜁니다. 
    이 동작을 재정의하려면 세 번째 매개 변수를 true(부울)로 설정할 수 있습니다.

    .. literalinclude:: filesystem_helper/004.php

    각 폴더 이름은 배열 색인이며 포함된 파일은 숫자로 색인됩니다.
    다음은 일반적인 배열의 예입니다.
    
    ::

        Array (
            [libraries] => Array
                (
                    [0] => benchmark.html
                    [1] => config.html
                    ["database/"] => Array
                        (
                            [0] => query_builder.html
                            [1] => binds.html
                            [2] => configuration.html
                            [3] => connecting.html
                            [4] => examples.html
                            [5] => fields.html
                            [6] => index.html
                            [7] => queries.html
                        )
                    [2] => email.html
                    [3] => file_uploading.html
                    [4] => image_lib.html
                    [5] => input.html
                    [6] => language.html
                    [7] => loader.html
                    [8] => pagination.html
                    [9] => uri.html
                )
        )

    결과가 없으면 빈 배열을 반환합니다.

.. php:function:: directory_mirror($original, $target[, $overwrite = true])

    :param	string	$original: 원본 디렉터리
    :param	string	$target: 대상 디렉토리
    :param	bool	$overwrite: 충돌 시 개별 파일을 덮어쓸지 여부

    원본 디렉터리의 파일 및 디렉터리를 대상 디렉터리로 재귀적으로 복사합니다. 즉, 내용을 "미러링" 합니다.

    .. literalinclude:: filesystem_helper/005.php

    선택적으로 세 번째 매개 변수를 통해 덮어쓰기 동작을 변경할 수 있습니다.

.. php:function:: write_file($path, $data[, $mode = 'wb'])

    :param	string	$path: 파일 경로
    :param	string	$data: 파일에 쓸 데이터
    :param	string	$mode: ``fopen()`` 모드
    :returns:	쓰기에 성공하면 true, 오류가 발생하면 false
    :rtype:	bool

    경로에 지정된 파일에 데이터를 씁니다. 파일이 존재하지 않으면 함수가 파일을 작성합니다.

    .. literalinclude:: filesystem_helper/006.php

    세번째 파라미터를 통해 쓰기 모드를 선택적으로 설정할 수 있습니다
    
    .. literalinclude:: filesystem_helper/007.php

    기본 모드는 'wb'입니다. 모드 옵션에 대해서는 `PHP 사용자 안내서 <https://www.php.net/manual/en/function.fopen.php>`_\ 를 참조하십시오.

    .. note:: 이 함수가 파일에 데이터를 쓰려면 쓰기 가능하도록 권한을 설정해야합니다. 파일이 존재하지 않으면 파일을 포함하는 디렉토리는 쓰기 가능해야합니다.

    .. note:: 경로는 컨트롤러나 뷰 파일이 아닌 사이트의 index.php 파일을 기준으로합니다. CodeIgniter는 프론트(front) 컨트롤러를 사용하므로 경로는 항상 사이트 index를 기준으로 합니다.

    .. note:: 이 기능은 파일에 쓰는 동안 파일에 대한 잠금(exclusive lock)을 획득합니다.

.. php:function:: delete_files($path[, $delDir = false[, $htdocs = false[, $hidden = false]]]])

    :param	string	$path: 디렉토리 경로
    :param	bool	$delDir: 디렉토리 삭제 여부
    :param	bool	$htdocs: .htaccess 및 색인 페이지 파일 삭제를 건너 뛸지 여부
    :param  bool    $hidden: 숨김 파일 삭제 여부 (마침표(.)로 시작하는 파일)
    :returns:	성공시 true, 오류 발생시 false
    :rtype:	bool

    제공된 경로에 포함된 모든 파일을 삭제합니다.

    .. literalinclude:: filesystem_helper/008.php

    두 번째 매개 변수가 true로 설정되면 제공된 루트 경로에 포함된 모든 디렉토리도 삭제됩니다.

    .. literalinclude:: filesystem_helper/009.php

    .. note:: 파일을 삭제하려면 시스템에서 파일을 쓸 수 있거나 소유해야합니다.

.. php:function:: get_filenames($sourceDir[, $includePath = false[, $hidden = false[, $includeDir = true]]])

    :param	string	$sourceDir: 디렉토리 경로
    :param	bool|null	$includePath: 파일 이름의 일부로 경로를 포함할지 여부; 경로가 없을때 ``false``, ``$sourceDir``\ 인 경우 ``null``, 전체 경로일때 ``true``
    :param	bool	$hidden: 숨겨진 파일 포함 여부 (마침표(.)로 시작하는 파일)
    :param  bool    $includeDir: 배열 출력에 디렉토리를 포함할지 여부
    :returns:	파일 이름의 배열
    :rtype:	array

    서버 경로를 입력으로 사용하고 여기에 포함된 모든 파일의 이름이 포함된 배열을 반환합니다.
    상대 경로의 경우 두 번째 매개 변수를 'relative'\ 로 설정하거나, 전체 파일 경로를 비어 있지 않은 다른 값으로 설정하여 파일 이름에 선택적으로 파일 경로를 추가할 수 있습니다.

    .. literalinclude:: filesystem_helper/010.php

.. php:function:: get_dir_file_info($sourceDir[, $topLevelOnly = true])

    :param	string	$sourceDir: 디렉토리 경로
    :param	bool	$topLevelOnly: 지정된 디렉토리의 하위 디렉토리 제외 여부 
    :returns:	제공된 디렉토리의 내용에 대한 정보를 포함하는 배열
    :rtype:	array

    지정된 디렉토리를 읽고 파일 이름, 파일 크기, 날짜 및 권한을 포함하는 배열을 만듭니다.
    지정된 경로에 포함된 하위 폴더는 두 번째 매개 변수를 false로 전달한 경우에만 읽힙니다. 
    이는 많은 주의를 기울여 하는 작업이 될 수 있기 때문입니다.

    .. literalinclude:: filesystem_helper/011.php

.. php:function:: get_file_info($file[, $returnedValues = ['name', 'server_path', 'size', 'date']])

    :param	string	        $file: 파일 경로
    :param	array|string    $returnedValues: 배열 또는 쉼표로 구분된 문자열로 전달하기 위해 반환할 정보 유형
    :returns:	지정된 파일에 대한 정보가 포함된 배열, 실패시 false
    :rtype:	array

    파일 및 경로가 제공되면 파일의 *name*, *path*, *size*, *date modified* 정보 속성을 (선택적으로) 반환합니다.
    두 번째 매개 변수를 사용하면 반환할 정보를 명시적으로 선언할 수 있습니다.

    유효한 ``$returnedValues`` 옵션: ``name``, ``size``, ``date``, ``readable``, ``writeable``, ``executable``, ``fileperms``.

.. php:function:: symbolic_permissions($perms)

    :param	int	$perms: 권한(Permission)
    :returns:	심볼릭(Symbolic) 권한 문자열
    :rtype:	string

    숫자 사용 권한(예: ``fileperms()``\ 에 의해 반환된)을 사용하여 파일 사용 권한의 표준 기호를 반환합니다.

    .. literalinclude:: filesystem_helper/012.php

.. php:function:: octal_permissions($perms)

    :param	int	$perms: 권한
    :returns:	8진수 권한 문자열
    :rtype:	string

    숫자 사용 권한(예: ``fileperms()``\ 에 의해 반환된)을 사용하여 파일 권한의 8진수 표기법를 반환합니다.

    .. literalinclude:: filesystem_helper/013.php

.. php:function:: same_file($file1, $file2)

    :param	string	$file1: 첫 번째 파일의 경로
    :param	string	$file2: 두 번째 파일의 경로
    :returns:	두 파일의 해시가 동일한지 여부
    :rtype:	boolean

    두 파일을 비교하여 동일한지 확인합니다.(MD5 해시 기준)

    .. literalinclude:: filesystem_helper/014.php

.. php:function:: set_realpath($path[, $checkExistence = false])

    :param	string	$path: 경로
    :param	bool	$checkExistence: 경로가 실제로 존재하는지 확인
    :returns:	절대 경로
    :rtype:	string

    이 기능은 심볼릭 링크나 상대 디렉터리 구조가 없는 서버 경로를 반환합니다. 경로를 확인할 수 없는 경우 선택적 두 번째 인수로 인해 오류가 트리거됩니다.

    .. literalinclude:: filesystem_helper/015.php
