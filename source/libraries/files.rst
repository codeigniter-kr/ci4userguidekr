******************
파일 작업
******************

CodeIgniter는 `SplFileInfo <https://www.php.net/manual/en/class.splfileinfo.php>`_ 클래스를 감싸는 File 클래스를 제공하고 추가적으로 편리한 메소드를 제공합니다.
이 클래스는 :doc:`업로드 파일 </libraries/uploaded_files>`\ 과 :doc:`images </libraries/images>`\ 의 기본(base) 클래스입니다.

.. contents::
    :local:
    :depth: 2

파일 인스턴스 얻기
=======================

생성자의 파일 경로를 전달하여 새 File 인스턴스를 만듭니다.
기본적으로 파일은 존재하지 않아도 됩니다.
그러나 추가 인수로 "true"를 전달하여 파일이 존재하는지 확인하고, 파일이 없으면 ``FileNotFoundException()``\ 을 던질 수 있습니다.

::

    $file = new \CodeIgniter\Files\File($path);

Spl의 장점 활용
=======================

인스턴스가 있으면 다음을 포함하여 SplFileInfo 클래스의 모든 기능을 사용할 수 있습니다.

::

    // Get the file's basename
    echo $file->getBasename();
    // Get last modified time
    echo $file->getMTime();
    // Get the true real path
    echo $file->getRealPath();
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
===============

SplFileInfo 클래스의 모든 메소드 외에도 몇 가지 새로운 도구가 제공됩니다.

**getRandomName()**

``getRandomName()`` 메소드를 사용하여 현재 타임 스탬프와 미리 지정된 암호로 안전한 임의의 파일 이름을 생성할 수 있습니다.
파일을 이동할 때 파일 이름을 알아볼 수 없도록 이름을 바꾸는 데 특히 유용합니다.

::

	// Generates something like: 1465965676_385e33f741.jpg
	$newName = $file->getRandomName();

**getSize()**

업로드된 파일의 크기를 바이트 단위로 반환합니다. 

::

	$bytes     = $file->getSize();      // 256901

**getSizeByUnit()**

업로드된 파일의 기본 크기를 바이트 단위로 반환합니다. 
첫 번째 매개 변수로 'kb' 또는 'mb'\ 를 전달하여 킬로바이트 또는 메가 바이트로 변환할 수 있습니다.

::

	$bytes     = $file->getSizeByUnit();      // 256901
	$kilobytes = $file->getSizeByUnit('kb');  // 250.880
	$megabytes = $file->getSizeByUnit('mb');  // 0.245

**getMimeType()**

파일의 미디어 타입 (mime type)을 얻어 옵니다. 
파일 유형을 결정할 때 가능한 한 안전한 것으로 간주되는 메소드를 사용합니다

::

	$type = $file->getMimeType();

	echo $type; // image/png

**guessExtension()**

신뢰할 수 있는 ``getMimeType()`` 메소드를 기반으로 파일 확장자를 판별합니다.
MIME 형식을 알 수 없으면 null을 반환합니다.
이 방법은 파일 이름으로 제공되는 확장자를 사용하는 것보다 더 신뢰할 수 있습니다.
확장을 결정하기 위해 **app/Config/Mimes.php**\ 의 값을 사용합니다

::

	// Returns 'jpg' (WITHOUT the period)
	$ext = $file->guessExtension();

파일 이동
------------

각 파일은 적절하게 이름이 지정된 ``move()`` 메소드를 사용하여 새 위치로 이동할 수 있습니다.
이것은 디렉토리를 사용하여 파일을 첫 번째 매개 변수로 이동시킵니다

::

	$file->move(WRITEPATH.'uploads');

기본적으로 원래 파일 이름이 사용됩니다. 두 번째 매개 변수에 새 파일 이름을 지정할 수 있습니다

::

	$newName = $file->getRandomName();
	$file->move(WRITEPATH.'uploads', $newName);

move() 메소드는 재배치된 파일에 대한 새 File 인스턴스를 리턴하므로 이동된 위치가 필요한 경우 결과를 캡처해야 합니다.

::

    $file = $file->move(WRITEPATH.'uploads');
