****
파일
****

CodeIgniter provides a File class that wraps the `SplFileInfo <http://php.net/manual/en/class.splfileinfo.php>`_ class
and provides some additional convenience methods. This class is the base class for :doc:`uploaded files </libraries/uploaded_files>`
and :doc:`images </libraries/images>`.
CodeIgniter는 `SplFileInfo <http://php.net/manual/en/class.splfileinfo.php>`_ 클래스를 래핑하는 File 클래스를 제공하며 몇 가지 추가적인 편리한 메소드를 제공합니다. 이 클래스는 :doc:`uploaded files </libraries/uploaded_files>` 및 :doc:`images </libraries/images>` 의 기본 클래스입니다 .

.. contents:: Page Contents
    :local:

파일 인스턴스 가져 오기
=======================

You create a new File instance by passing in the path to the file in the constructor. 
By default the file does not need to exist. However, you can pass an additional argument of "true" 
to check that the file exist and throw ``FileNotFoundException()`` if it does not.
생성자의 파일 경로를 전달하여 새 File 인스턴스를 만듭니다. 기본적으로 파일은 존재하지 않아도됩니다. 그러나 "true"라는 추가 인수를 전달하여 파일이 존재하는지 확인하고 그렇지 않은 경우 ``FileNotFoundException()`` 를 throw 합니다.

::

    $file = new \CodeIgniter\Files\File($path);

Spl의 장점
==========

Once you have an instance, you have the full power of the SplFileInfo class at the ready, including
인스턴스가 있으면 SplFileInfo 클래스의 모든 기능을 사용할 수 있습니다.

::

    // Get the file's basename
    echo $file->getBasename();
    // Get last modified time
    echo $file->getMTime();
    // Get the true realpath
    echo $file->getRealpath();
    // Get the file permissions
    echo $file->getPerms();

    // Write CSV rows to it.
    if ($file->isWritable())
    {
        $csv = $file->openFile('w');

        foreach ($rows as $row)
        {
            $csv->fputcsv($row);
        }
    }

새로운 기능
===========

In addition to all of the methods in the SplFileInfo class, you get some new tools.
SplFileInfo 클래스의 모든 메서드 외에도 새로운 도구가 추가되었습니다.

**getRandomName()**

You can generate a cryptographically secure random filename, with the current timestamp prepended, with the ``getRandomName()``
method. This is especially useful to rename files when moving it so that the filename is unguessable

``getRandomName()`` 메소드 와 함께 현재 타임스탬프를 앞에두고 암호로 안전한 임의의 파일 이름을 생성 할 수 있습니다. 이것은 파일을 옮길 때 파일의 이름을 변경하여 파일명을 추측 할 수없는 경우 특히 유용합니다.

::

	// Generates something like: 1465965676_385e33f741.jpg
	$newName = $file->getRandomName();

**getSize()**

Returns the size of the uploaded file in bytes. You can pass in either 'kb' or 'mb' as the first parameter to get
the results in kilobytes or megabytes, respectively
업로드 된 파일의 크기를 바이트 단위로 반환합니다. 'kb'또는 'mb'를 첫 번째 매개 변수로 전달하여 결과를 각각 킬로바이트 또는 메가 바이트 단위로 얻을 수 있습니다.

::

	$bytes     = $file->getSize();      // 256901
	$kilobytes = $file->getSize('kb');  // 250.880
	$megabytes = $file->getSize('mb');  // 0.245

**getMimeType()**

Retrieve the media type (mime type) of the file. Uses methods that are considered as secure as possible when determining
the type of file
파일의 미디어 타입 (MIME 타입)을 얻어 온다. 파일 유형을 결정할 때 가능한 안전하다고 간주되는 메소드를 사용합니다.

::

	$type = $file->getMimeType();

	echo $type; // image/png

**guessExtension()**

Attempts to determine the file extension based on the trusted ``getMimeType()`` method. If the mime type is unknown,
will return null. This is often a more trusted source than simply using the extension provided by the filename. Uses
the values in **application/Config/Mimes.php** to determine extension
신뢰할 수있는 ``getMimeType()`` 메서드를 기반으로 파일 확장명을 결정하려고 시도합니다 . MIME 타입이 불명의 경우는 null를 돌려줍니다. 이것은 종종 파일 이름이 제공하는 확장자를 사용하는 것보다 더 신뢰할 수있는 소스입니다. **application/Config/Mimes.php** 의 값을 사용하여 확장을 결정합니다.

::

	// Returns 'jpg' (WITHOUT the period)
	$ext = $file->guessExtension();

파일 이동
---------

Each file can be moved to its new location with the aptly named ``move()`` method. This takes the directory to move
the file to as the first parameter
각 파일은 적절한 이름의 ``move()`` 메소드로 새 위치로 이동할 수 있습니다. 이 디렉토리를 사용하여 파일을 첫 번째 매개 변수로 이동합니다.

::

	$file->move(WRITEPATH.'uploads');

By default, the original filename was used. You can specify a new filename by passing it as the second parameter
기본적으로 원래 파일 이름이 사용되었습니다. 두 번째 매개 변수로 전달하여 새 파일 이름을 지정할 수 있습니다.

::

	$newName = $file->getRandomName();
	$file->move(WRITEPATH.'uploads', $newName);
