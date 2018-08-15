#################
Filesystem Helper
#################

The Directory Helper file contains functions that assist in working with
directories. 디렉토리 helper 파일에는 디렉토리 작업에 도움이되는 기능이 있습니다.

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

Loading this Helper
===================

This helper is loaded using the following code:
이 helper는 다음 코드를 사용하여로드됩니다.

::

	helper('filesystem');

Available Functions
===================

The following functions are available:
다음 기능을 사용할 수 있습니다.

.. php:function:: directory_map($source_dir[, $directory_depth = 0[, $hidden = FALSE]])

	:param	string	$source_dir: Path to the source directory
	:param	int	$directory_depth: Depth of directories to traverse (0 = fully recursive, 1 = current dir, etc)
	:param	bool	$hidden: Whether to include hidden directories
	:returns:	An array of files
	:rtype:	array

	Examples::

		$map = directory_map('./mydirectory/');

	.. note:: Paths are almost always relative to your main index.php file. 경로는 거의 항상 주요 index.php 파일에 상대적입니다.

	Sub-folders contained within the directory will be mapped as well. If
	you wish to control the recursion depth, you can do so using the second
	parameter (integer). A depth of 1 will only map the top level directory
	디렉토리에 포함 된 하위 폴더도 매핑됩니다.
	재귀 깊이를 제어하려면 두 번째 매개 변수 (정수)를 사용하면됩니다.
	깊이 1은 최상위 디렉토리 만 매핑합니다.
	
	::

		$map = directory_map('./mydirectory/', 1);

	By default, hidden files will not be included in the returned array. To
	override this behavior, you may set a third parameter to true (boolean)
	기본적으로 숨겨진 파일은 반환 된 배열에 포함되지 않습니다.
	이 동작을 무시하려면 세 번째 매개 변수를 true (부울 값)로 설정할 수 있습니다.
	
	::

		$map = directory_map('./mydirectory/', FALSE, TRUE);

	Each folder name will be an array index, while its contained files will
	be numerically indexed. Here is an example of a typical array
	각 폴더 이름은 배열 색인이되며 포함 된 파일은 숫자로 색인화됩니다.
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

	If no results are found, this will return an empty array.

.. php:function:: write_file($path, $data[, $mode = 'wb'])

	:param	string	$path: File path
	:param	string	$data: Data to write to file
	:param	string	$mode: ``fopen()`` mode
	:returns:	TRUE if the write was successful, FALSE in case of an error
	:rtype:	bool

	Writes data to the file specified in the path. If the file does not exist then the
	function will create it.
	경로에 지정된 파일에 데이터를 씁니다. 
	파일이 존재하지 않으면 함수가 파일을 작성합니다.

	Example::

		$data = 'Some file data';
		if ( ! write_file('./path/to/file.php', $data))
		{     
			echo 'Unable to write the file';
		}
		else
		{     
			echo 'File written!';
		}

	You can optionally set the write mode via the third parameter:
	선택적으로 세 번째 매개 변수를 통해 쓰기 모드를 설정할 수 있습니다.
	
	:

		write_file('./path/to/file.php', $data, 'r+');

	The default mode is 'wb'. Please see the `PHP user guide <http://php.net/manual/en/function.fopen.php>`_
	for mode options.
	기본 모드는 'wb'입니다. 
	모드 옵션에 대해서는 `PHP user guide <http://php.net/manual/en/function.fopen.php>`_ 를 참조하세요

	.. note:: In order for this function to write data to a file, its permissions must
		be set such that it is writable. If the file does not already exist,
		then the directory containing it must be writable.
		이 함수가 파일에 데이터를 쓰려면 쓰기 권한이 있어야합니다.
		파일이 아직 존재하지 않으면 파일이있는 디렉토리가 쓰기 가능해야합니다.

	.. note:: The path is relative to your main site index.php file, NOT your
		controller or view files. CodeIgniter uses a front controller so paths
		are always relative to the main site index.
		경로는 메인 사이트의 index.php 파일과 관련이 있으며 컨트롤러 또는 뷰 파일은 아닙니다.
		CodeIgniter는 프런트 컨트롤러를 사용하므로 경로는 항상 기본 사이트 색인과 관련됩니다.

	.. note:: This function acquires an exclusive lock on the file while writing to it. 이 함수는 파일에 쓰는 동안 배타적 잠금을 획득합니다.

.. php:function:: delete_files($path[, $del_dir = FALSE[, $htdocs = FALSE]])

	:param	string	$path: Directory path
	:param	bool	$del_dir: Whether to also delete directories
	:param	bool	$htdocs: Whether to skip deleting .htaccess and index page files
	:returns:	TRUE on success, FALSE in case of an error
	:rtype:	bool

	Deletes ALL files contained in the supplied path.
	제공된 경로에 포함 된 모든 파일을 삭제합니다.

	Example::

		delete_files('./path/to/directory/');

	If the second parameter is set to TRUE, any directories contained within the supplied
	root path will be deleted as well.
	두 번째 매개 변수가 TRUE로 설정된 경우 제공된 루트 경로에 포함 된 모든 디렉토리도 삭제됩니다.

	Example::

		delete_files('./path/to/directory/', TRUE);

	.. note:: The files must be writable or owned by the system in order to be deleted. 파일을 삭제하려면 해당 파일을 시스템에서 쓸 수 있거나 소유해야합니다.

.. php:function:: get_filenames($source_dir[, $include_path = FALSE])

	:param	string	$source_dir: Directory path
	:param	bool	$include_path: Whether to include the path as part of the filenames
	:returns:	An array of file names
	:rtype:	array

	Takes a server path as input and returns an array containing the names of all files
	contained within it. The file path can optionally be added to the file names by setting
	the second parameter to TRUE.
	서버 경로를 입력 받아 그 안에 포함 된 모든 파일의 이름을 포함하는 배열을 반환합니다.
	두 번째 매개 변수를 TRUE로 설정하여 파일 경로를 선택적으로 파일 이름에 추가 할 수 있습니다.

	Example::

		$controllers = get_filenames(APPPATH.'controllers/');

.. php:function:: get_dir_file_info($source_dir, $top_level_only)

	:param	string	$source_dir: Directory path
	:param	bool	$top_level_only: Whether to look only at the specified directory (excluding sub-directories)
	:returns:	An array containing info on the supplied directory's contents
	:rtype:	array

	Reads the specified directory and builds an array containing the filenames, filesize,
	dates, and permissions. Sub-folders contained within the specified path are only read
	if forced by sending the second parameter to FALSE, as this can be an intensive
	operation.
	지정된 디렉터리를 읽고 파일 이름, 파일 크기, 날짜 및 사용 권한을 포함하는 배열을 작성합니다.
	지정된 경로 내에 포함 된 하위 폴더는 집중적 인 작업 일 수 있으므로 FALSE로 두 번째 매개 변수를 보내면 읽기만됩니다.

	Example::

		$models_info = get_dir_file_info(APPPATH.'models/');

.. php:function:: get_file_info($file[, $returned_values = array('name', 'server_path', 'size', 'date')])

	:param	string	$file: File path
	:param	array	$returned_values: What type of info to return
	:returns:	An array containing info on the specified file or FALSE on failure
	:rtype:	array

	Given a file and path, returns (optionally) the *name*, *path*, *size* and *date modified*
	information attributes for a file. Second parameter allows you to explicitly declare what
	information you want returned.
	주어진 파일 및 경로는 파일의 *이름* , *경로* , *크기* 및 날짜 정보 속성을 선택적으로 반환 합니다. 
	두 번째 매개 변수를 사용하면 반환 할 정보를 명시 적으로 선언 할 수 있습니다.

	Valid ``$returned_values`` options are: `name`, `size`, `date`, `readable`, `writeable`,
	`executable` and `fileperms`.
	유효한 ``$returned_values`` 옵션은 다음과 같습니다 : '이름' , '크기' , '날짜' , '읽기' , '쓰기' , '실행 및 fileperms' .

.. php:function:: symbolic_permissions($perms)

	:param	int	$perms: Permissions
	:returns:	Symbolic permissions string
	:rtype:	string

	Takes numeric permissions (such as is returned by ``fileperms()``) and returns
	standard symbolic notation of file permissions.
	숫자 권한 (예 :에 의해 반환 됨``fileperms()``)을 취하여 파일 사용 권한의 표준 기호 표기법을 반환합니다.

	::

		echo symbolic_permissions(fileperms('./index.php'));  // -rw-r--r--

.. php:function:: octal_permissions($perms)

	:param	int	$perms: Permissions
	:returns:	Octal permissions string
	:rtype:	string

	Takes numeric permissions (such as is returned by ``fileperms()``) and returns
	a three character octal notation of file permissions.
	숫자 권한 (예 :에 의해 반환 됨 ``fileperms()``)을 취하여 파일 권한의 3 자리 8 진수 표기법을 반환합니다.

	::

		echo octal_permissions(fileperms('./index.php')); // 644

.. php:function:: set_realpath($path[, $check_existance = FALSE])

	:param	string	$path: Path
	:param	bool	$check_existance: Whether to check if the path actually exists
	:returns:	An absolute path
	:rtype:	string

	This function will return a server path without symbolic links or
	relative directory structures. An optional second argument will
	cause an error to be triggered if the path cannot be resolved.

	Examples::

		$file = '/etc/php5/apache2/php.ini';
		echo set_realpath($file); // Prints '/etc/php5/apache2/php.ini'

		$non_existent_file = '/path/to/non-exist-file.txt';
		echo set_realpath($non_existent_file, TRUE);	// Shows an error, as the path cannot be resolved
		echo set_realpath($non_existent_file, FALSE);	// Prints '/path/to/non-exist-file.txt'

		$directory = '/etc/php5';
		echo set_realpath($directory);	// Prints '/etc/php5/'

		$non_existent_directory = '/path/to/nowhere';
		echo set_realpath($non_existent_directory, TRUE);	// Shows an error, as the path cannot be resolved
		echo set_realpath($non_existent_directory, FALSE);	// Prints '/path/to/nowhere'
