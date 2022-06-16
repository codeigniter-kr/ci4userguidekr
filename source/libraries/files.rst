******************
파일 작업
******************

CodeIgniter는 `SplFileInfo <https://www.php.net/manual/en/class.splfileinfo.php>`_ 클래스를 감싸는 File 클래스를 제공하고 추가적으로 편리한 메소드를 제공합니다.
이 클래스는 :doc:`업로드 파일 </libraries/uploaded_files>`\ 과 :doc:`images </libraries/images>`\ 의 기본(base) 클래스입니다.

.. contents::
    :local:
    :depth: 2

파일 인스턴스 얻기
***********************

생성자의 파일 경로를 전달하여 새 File 인스턴스를 만듭니다.
기본적으로 파일은 존재하지 않아도 됩니다.
그러나 추가 인수로 "true"를 전달하여 파일이 존재하는지 확인하고, 파일이 없으면 ``FileNotFoundException()``\ 을 던질 수 있습니다.

.. literalinclude:: files/001.php

Spl의 장점 활용
***********************

인스턴스가 있으면 다음을 포함하여 SplFileInfo 클래스의 모든 기능을 사용할 수 있습니다.

.. literalinclude:: files/002.php

새로운 기능
************

SplFileInfo 클래스의 모든 메소드 외에도 몇 가지 새로운 도구가 제공됩니다.

getRandomName()
===============

``getRandomName()`` 메소드를 사용하여 현재 타임 스탬프와 미리 지정된 암호로 안전한 임의의 파일 이름을 생성할 수 있습니다.
파일을 이동할 때 파일 이름을 알아볼 수 없도록 이름을 바꾸는 데 특히 유용합니다.

.. literalinclude:: files/003.php

getSize()
=========

업로드된 파일의 크기를 바이트 단위로 반환합니다. 

.. literalinclude:: files/004.php

getSizeByUnit()
===============

업로드된 파일의 기본 크기를 바이트 단위로 반환합니다. 
첫 번째 매개 변수로 'kb' 또는 'mb'\ 를 전달하여 킬로바이트 또는 메가 바이트로 변환할 수 있습니다.

.. literalinclude:: files/005.php

getMimeType()
=============

파일의 미디어 타입 (mime type)을 얻어 옵니다. 
파일 유형을 결정할 때 가능한 한 안전한 것으로 간주되는 메소드를 사용합니다

.. literalinclude:: files/006.php

guessExtension()
================

신뢰할 수 있는 ``getMimeType()`` 메소드를 기반으로 파일 확장자를 판별합니다.
MIME 형식을 알 수 없으면 null을 반환합니다.
이 방법은 파일 이름으로 제공되는 확장자를 사용하는 것보다 더 신뢰할 수 있습니다.
확장을 결정하기 위해 **app/Config/Mimes.php**\ 의 값을 사용합니다

.. literalinclude:: files/007.php

파일 이동
============

각 파일은 적절하게 이름이 지정된 ``move()`` 메소드를 사용하여 새 위치로 이동할 수 있습니다.
이것은 디렉토리를 사용하여 파일을 첫 번째 매개 변수로 이동시킵니다

.. literalinclude:: files/008.php

기본적으로 원래 파일 이름이 사용됩니다. 두 번째 매개 변수에 새 파일 이름을 지정할 수 있습니다

.. literalinclude:: files/009.php

move() 메소드는 재배치된 파일에 대한 새 File 인스턴스를 리턴하므로 이동된 위치가 필요한 경우 결과를 캡처해야 합니다.

.. literalinclude:: files/010.php


################
파일 Collections
################

파일 그룹을 사용하는 작업은 번거로울 수 있으므로 파일 시스템 전체에서 파일 그룹을 쉽게 찾고 작업할 수 있는 ``FileCollection`` 클래스를 제공합니다.
가장 기본적인 ``FileCollection``\ 은 사용자가 설정하거나 빌드하는 파일의 색인(index)입니다.

.. literalinclude:: files/011.php

작업할 파일을 입력한 후 파일을 제거하거나 필터링 명령을 사용하여 특정 정규식 또는 글로벌 스타일 패턴과 일치하는 파일을 제거하거나 유지할 수 있습니다.

.. literalinclude:: files/012.php

수집이 완료되면 ``get()``\ 을 사용하여 최종 파일 경로 목록을 검색하거나 ``FileCollection``\ 을 통해 파일의 수를 알 수 있고, 각 ``파일``\ 에 직접 작업할 수 있습니다.

.. literalinclude:: files/013.php

다음은 ``FileCollection``\ 을 사용하는 구체적인 방법입니다.

Collection
=====================

__construct(string[] $files = [])
=================================

생성자에 collection으로 사용할 파일 경로를 옵션 배열로 지정 할 수 있습니다. 
지정된 파일은 ``add()`` 메소드에 전달되며 ``$files``\ 의 자식 클래스에서 제공한 파일은 그대로 유지됩니다.

define()
========

자식 클래스가 자신의 초기 파일을 정의할 수 있습니다. 
이 메서드는 생성자에 의해 호출되며 메소드를 사용할 필요 없이 미리 정의된 컬렉션을 허용합니다.

.. literalinclude:: files/014.php

이제 ``ConfigCollection``\ 을 사용하여 매번 collection 메소드를 다시 호출할 필요 없이 앱의 모든 구성(config) 파일에 액세스할 수 있습니다.

set(array $files)
=================

입력 파일 목록을 제공된 파일 경로 문자열 배열로 설정합니다.
빈 배열을 전달하면 컬렉션에서 기존 파일이 모두 제거되므로 ``$collection->set([])`` 은 기본적으로 하드 리셋입니다.

Inputting Files
***************

add(string[]|string $paths, bool $recursive = true)
===================================================

경로 또는 경로 배열로 표시된 모든 파일을 추가합니다. 
경로가 디렉터리로 확인되면 ``$recursive``\ 에 하위 디렉터리가 포함됩니다.

addFile(string $file) / addFiles(array $files)
==============================================

현재 입력 파일 목록에 파일을 추가합니다. 파일은 실제 파일의 절대 경로입니다.

removeFile(string $file) / removeFiles(array $files)
====================================================

현재 입력 파일 목록에서 파일을 제거합니다.

addDirectory(string $directory, bool $recursive = false)
========================================================
addDirectories(array $directories, bool $recursive = false)
===========================================================

디렉터리의 모든 파일을 추가합니다. 재귀 옵션에 따라 하위 디렉터리로 재귀합니다. 
디렉토리는 실제 디렉터리에 대한 절대적인 경로입니다.

파일 필터링
***************

removePattern(string $pattern, string $scope = null)
====================================================
retainPattern(string $pattern, string $scope = null)
====================================================

패턴(또는 선택적 범위)을 통해 현재 파일 목록을 필터링하여 일치하는 파일을 제거하거나 유지합니다.
``$pattern``\ 은 완전한 정규식(예: ``'#[A-Za-z]+\.php#'``)이거나 ``glob()``(예: ``*.css``)과 유사한 유사 정규식일 수 있다.
``$scope``\ 가 제공되면 해당 디렉토리 또는 아래에 있는 파일만 고려됩니다(``$scope`` 밖의 파일은 항상 유지됩니다).
범위가 제공되지 않으면 대상은 모든 파일이 됩니다.

.. literalinclude:: files/015.php

파일 검색
****************

get(): string[]
===============

로드된 모든 입력 파일의 배열을 반환합니다.

.. note:: ``FileCollection``\ 은 ``IteratorAggregate`` 이므로 직접 사용할 수 있습니다 (예: ``foreach ($collection as $file)``).
