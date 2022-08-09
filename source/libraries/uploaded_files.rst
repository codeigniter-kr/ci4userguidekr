###########################
업로드(upload)된 파일 작업
###########################

CodeIgniter는 PHP의 ``$_FILES`` 배열을 직접 사용하는 것보다 훨씬 간단하고 안전한 형식으로 업로드된 파일로 작업합니다.
이것은 :doc:`파일 클래스 </libraries/files>`\ 를 확장하며, 해당 클래스의 모든 기능을 사용할 수 있습니다.

.. note:: 이 클래스는 CodeIgniter v3.x의 파일 업로드 클래스와 동일하지 않으며, 몇 가지 작은 기능으로 업로드된 파일에 대한 원시 인터페이스를 제공합니다.

.. contents::
    :local:
    :depth: 2

*****************
일반적인 프로세스
*****************

파일 업로드에는 다음과 같은 일반적인 프로세스가 포함됩니다.

- 사용자가 파일을 선택하여 업로드할 수 있는 업로드 양식(form)이 표시됩니다.
- 양식(form)이 제출(submit)되면 지정한 대상에 파일이 업로드됩니다.
- 그 과정에서 파일의 유효성이 검사되어 설정한 기본 설정에 따라 업로드가 허용되는지 확인합니다.
- 업로드가 완료되면 사용자에게 성공 메시지가 표시됩니다.

이 프로세스를 보여주기 위해 간단한 자습서를 제공합니다.

업로드 양식(form) 만들기
=========================

텍스트 편집기를 사용하여 **upload_form.php** 파일을 만듭니다. 여기에 아래의 코드를 넣고 **app/Views/** 디렉터리에 저장합니다.

.. literalinclude:: uploaded_files/001.php

파일 업로드에는 멀티파트(multipart) 형식이 필요하므로 폼(form) 헬퍼의 ``form_open_multipart()`` 함수를 사용합니다.
오류 메시지를 표시할 수 있도록 하기 위해 ``$errors`` 변수를 사용합니다.

성공 페이지
================

텍스트 편집기를 사용하여 **upload_success.php** 파일을 만듭니다. 여기에 아래의 코드를 넣고 **app/Views/** 디렉터리에 저장합니다.

::

    <!DOCTYPE html>
    <html lang="en">
    <head>
        <title>Upload Form</title>
    </head>
    <body>

    <h3>Your file was successfully uploaded!</h3>

    <ul>
        <li>name: <?= esc($uploaded_flleinfo->getBasename()) ?></li>
        <li>size: <?= esc($uploaded_flleinfo->getSizeByUnit('kb')) ?> KB</li>
        <li>extension: <?= esc($uploaded_flleinfo->guessExtension()) ?></li>
    </ul>

    <p><?= anchor('upload', 'Upload Another File!') ?></p>

    </body>
    </html>

컨트롤러
==============

텍스트 편집기를 사용하여 **Upload.php** 파일을 만듭니다. 여기에 아래의 코드를 넣고 **app/Controllers/** 디렉터리에 저장합니다.

.. literalinclude:: uploaded_files/002.php

.. note:: 파일 업로드 HTML 필드의 값이 존재하지 않고 전역 변수 ``$_FILES``\ 에 저장되기 때문에 :ref:`rules-for-file-uploads`\ 만 업로드 파일의 유효성을 검사(:doc:`validation`)하는 데 사용할 수 있습니다.
    ``required`` 규칙도 사용할 수 없으므로 ``uploaded``\ 을 대신 사용하십시오.

라우트
==========

텍스트 편집기를 사용하여 **app/Config/Routes.php**\ 를 엽니다. 거기에 다음 두 경로를 추가하십시오.

.. literalinclude:: uploaded_files/021.php

업로드 디렉토리
====================

업로드된 파일은 **writable/uploads/** 디렉토리에 저장됩니다.

업로드!!
=========

업로드하려면 다음과 유사한 URL을 사용하여 사이트를 방문합니다.

::

    example.com/index.php/upload/

업로드 양식(form)이 표시되어야 합니다. 이미지 파일(**jpg**, **gif**, **png** 또는 **webp**)을 업로드해 보세요. 컨트롤러의 경로가 정확하면 작동해야 합니다.

.. _uploaded-files-accessing-files:

***************
파일 접근
***************

All Files
=========

파일을 업로드하면 슈퍼 글로벌 ``$_FILES``\ 을 통해 PHP에서 업로드된 파일에 액세스할 수 있습니다.
이 배열은 한 번에 업로드된 여러 파일을 작업할 때 몇 가지 중요한 단점이 있으며, 많은 개발자가 알지 못하는 잠재적인 보안 결함이 있습니다.
CodeIgniter는 공통 인터페이스뒤에서 파일 사용을 표준화하여 이러한 상황을 모두 지원합니다.

업로드된 파일은 ``IncomingRequest`` 인스턴스를 통해 액세스됩니다.
이 요청을 통해 업로드된 모든 파일을 검색하려면 ``getFiles()``\ 를 사용하십시오.
``CodeIgniter\HTTP\Files\UploadedFile``\ 의 인스턴스로 표시되는 파일 배열을 반환합니다.

.. literalinclude:: uploaded_files/003.php

물론, 파일 입력의 이름을 지정하는 방법은 여러 가지가 있으며 가장 간단한 것 이외의 것은 이상한 결과를 만들 수 있습니다.
사용자가 원하는 방식으로 배열이 반환됩니다. 가장 간단한 사용법으로 단일 파일은 다음과 같이 제출됩니다.

::

	<input type="file" name="avatar" />

다음과 같은 간단한 배열을 반환합니다.

::

	[
		'avatar' => // UploadedFile instance,
	];

.. note:: 여기의 파일은 ``$_FILES``\ 에 해당합니다. 사용자가 양식(form)에 파일을 업로드하지 않고 제출(submit) 버튼을 클릭하여도 파일($_FILES)은 계속 존재합니다. userfile의 ``isValid()`` 메소드로 파일이 실제로 업로드 되었는지 확인할 수 있습니다. 자세한 내용은 :ref:`verify-a-file`\ 을 참조하세요.

이름에 배열 표기법을 사용한 경우 입력은 다음과 같습니다.

::

	<input type="file" name="my-form[details][avatar]" />

``getFiles()``\ 에 의해 반환된 배열은 다음과 같습니다.

::

	[
		'my-form' => [
			'details' => [
				'avatar' => // UploadedFile instance
			],
		],
	]

경우에 따라 업로드할 파일 배열을 지정할 수 있습니다.

::

	Upload an avatar: <input type="file" name="my-form[details][avatars][]" />
	Upload an avatar: <input type="file" name="my-form[details][avatars][]" />

이 경우 반환 된 파일 배열은

::

	[
		'my-form' => [
			'details' => [
				'avatar' => [
					0 => /* UploadedFile instance */,
					1 => /* UploadedFile instance */
                ],
			],
		],
	]

단일 파일
===========

단일 파일에 액세스해야 하는 경우 ``getFile()``\ 을 사용하여 파일 인스턴스를 직접 검색 할 수 있습니다. 
``CodeIgniter\HTTP\Files\UploadedFile``\ 의 인스턴스를 반환합니다.

가장 간단한 사용법
-------------------

가장 간단한 사용법으로 단일 파일은 다음과 같이 제출(submit)될 수 있습니다.

::

	<input type="file" name="userfile" />

다음과 같은 간단한 파일 인스턴스를 반환합니다.

.. literalinclude:: uploaded_files/004.php

배열 표기법
--------------

이름에 배열 표기법을 사용한 경우 입력은 다음과 같습니다.

::

	<input type="file" name="my-form[details][avatar]" />

파일 인스턴스를 얻으려면

.. literalinclude:: uploaded_files/005.php

다중 파일
==============

HTML에서

::

    <input type="file" name="images[]" multiple />

컨트롤러에서

.. literalinclude:: uploaded_files/006.php

여기서 ``images``\ 는 다중 폼(form) 필드의 이름입니다.

이름이 같은 파일이 여러 개 있으면 ``getFile()``\ 을 사용하여 모든 파일을 개별적으로 검색할 수 있습니다.

컨트롤러에서

.. literalinclude:: uploaded_files/007.php

``getFileMultiple()``\ 을 사용하여 같은 이름으로  업로드된 파일의 배열을 얻는 것이 더 쉬울 수 있습니다.

.. literalinclude:: uploaded_files/008.php


다른 예제

::

	Upload an avatar: <input type="file" name="my-form[details][avatars][]" />
	Upload an avatar: <input type="file" name="my-form[details][avatars][]" />

컨트롤러에서

.. literalinclude:: uploaded_files/009.php

.. note:: ``getFiles()``\ 를 사용하는 것이 더 적절합니다.

*********************
파일 작업
*********************

UploadedFile 인스턴스를 검색한 후에는 파일에 대한 정보를 안전한 방법으로 검색하고 파일을 새 위치로 옮길 수 있습니다.

.. _verify-a-file:

파일 확인
=============

``isValid()`` 메소드를 호출하여 파일이 실제로 HTTP를 통해 오류없이 업로드되었는지 확인할 수 있습니다.

.. literalinclude:: uploaded_files/010.php

이 예제에서 볼 수 있듯이 파일에 업로드 오류가 있는 경우 ``getError()``\ 와 ``getErrorString()`` 메소드를 사용하여 오류 코드(정수)와 오류 메시지를 검색할 수 있습니다.
이 방법을 통해 다음과 같은 오류를 발견할 수 있습니다.

* 파일이 ini 지시문의 upload_max_filesize를 초과합니다.
* 파일이 폼에 정의된 업로드 한도를 초과합니다.
* 파일이 부분적으로 업로드되었습니다.
* 파일이 업로드되지 않았습니다.
* 파일을 디스크에 쓸 수 없습니다.
* 파일을 업로드할 수 없습니다 : 임시 디렉토리가 없습니다.
* PHP 확장자가 포함되어 파일 업로드가 중지되었습니다.

파일 이름
==========

getName()
---------

``getName()`` 메소드를 사용하여 클라이언트가 제공한 원래 파일 이름을 검색 할 수 있습니다. 
이것은 일반적으로 클라이언트가 전송한 파일 이름이므로 신뢰할 수 없습니다. 
파일이 이동된 경우 이동된 파일의 최종 이름을 반환합니다.

.. literalinclude:: uploaded_files/011.php

getClientName()
---------------

파일이 이동된 경우에도 클라이언트가 전송한대로 업로드된 파일의 원래 이름을 반환합니다.

.. literalinclude:: uploaded_files/012.php

getTempName()
-------------

업로드중에 생성된 임시 파일의 전체 경로를 얻으려면 ``getTempName()`` 메소드를 사용합니다.

.. literalinclude:: uploaded_files/013.php

파일의 다른 정보
================

getClientExtension()
--------------------

업로드된 파일 이름을 기준으로 원본 파일 확장자를 반환합니다.
신뢰할 수 없습니다.
신뢰할 수 있는 확장자를 원한다면 ``guessExtension()``\ 을 사용하십시오.

.. literalinclude:: uploaded_files/014.php

getClientMimeType()
-------------------

클라이언트가 제공한 파일의 MIME 유형 (MIM 유형)을 리턴합니다.
신뢰할 수 없습니다.
신뢰할 수 있는 MIME 유형을 원한다면 ``getMimeType()``\ 을 사용하십시오.

::

	$type = $file->getClientMimeType();

	echo $type; // image/png

파일 이동
=========

각 파일은 적절하게 이름이 지정된 ``move()`` 메소드를 사용하여 새 위치로 이동할 수 있습니다.
첫 번째 매개 변수로 디렉토리와 함께 사용하여 파일명을 전달하여 이동시킵니다.

.. literalinclude:: uploaded_files/016.php

기본적으로 원래 파일 이름이 사용됩니다. 
두 번째 매개 변수로 새 파일 이름을 전달하여 수정할 수 있습니다

.. literalinclude:: uploaded_files/017.php

파일이 제거되면 임시 파일이 삭제됩니다.
부울을 반환하는 ``hasMoved()`` 메소드로 파일이 이동했는지 확인할 수 있습니다.

.. literalinclude:: uploaded_files/018.php

다음과 같은 경우 업로드된 파일을 ``HTTP/Exception``\ 이 발생하며 이동하지 못할 수 있습니다.

- 파일이 이미 이동되었습니다
- 파일이 성공적으로 업로드되지 않았습니다
- 파일 이동 작업이 실패합니다 (예 : 부적절한 권한)

파일 저장
===========

각 파일은 ``store()`` 메소드를 사용하여 새 위치로 이동할 수 있습니다.

가장 간단한 사용법으로 단일 파일이 다음과 같이 제출(submit)될 수 있습니다.

::

	<input type="file" name="userfile" />

기본적으로 업로드 파일은 쓰기 가능한 업로드 디렉토리에 저장됩니다.
YYYYMMDD 폴더와 같은 임의의 파일 이름이 생성되고 파일 경로를 반환합니다.

.. literalinclude:: uploaded_files/019.php

첫 번째 매개 변수로 파일이 이동할 디렉토리를 지정할 수 있습니다. 
새 파일 이름은 두 번째 매개 변수로 전달합니다.

.. literalinclude:: uploaded_files/020.php

다음과 같은 경우 업로드된 파일을 ``HTTP/Exception``\ 이 발생하며 이동하지 못할 수 있습니다.

- 파일이 이미 이동되었습니다
- 파일이 성공적으로 업로드되지 않았습니다
- 파일 이동 작업이 실패합니다 (예 : 부적절한 권한)
