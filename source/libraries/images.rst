########################
이미지 조작 클래스
########################


CodeIgniter의 이미지 조작 클래스를 사용하면 다음 작업을 수행할 수 있습니다.

-이미지 크기 조정
-섬네일 생성
-이미지 자르기
-이미지 회전
-이미지 워터 마킹

지원하는 이미지 라이브러리 : GD/GD2, ImageMagick

.. contents::
    :local:
    :depth: 2

**********************
클래스 초기화
**********************

CodeIgniter의 다른 클래스와 마찬가지로 이미지 클래스는 Services 클래스를 호출하여 컨트롤러에서 초기화됩니다.

.. literalinclude:: images/001.php

사용하려는 이미지 라이브러리의 별명을 서비스 기능으로 전달할 수 있습니다.

.. literalinclude:: images/002.php

사용 가능한 핸들러는 다음과 같습니다:

- ``gd``      The GD/GD2 image library
- ``imagick`` The ImageMagick library.

ImageMagick 라이브러리를 사용하는 경우 **app/Config/Images.php**\ 에서 서버의 라이브러리 경로를 설정해야 합니다.

.. note:: ImageMagick 핸들러에는 imagick 확장(extension)이 필요합니다.

*******************
이미지 처리
*******************

수행하려는 처리 유형(크기 조정, 자르기, 회전 또는 워터 마킹)에 관계없이 일반적인 프로세스는 동일합니다.
수행하려는 작업에 해당하는 일부 환경 설정을 설정한 후 사용 가능한 처리 기능중 하나를 호출하십시오.
예를 들어 이미지 썸네일을 만들려면 다음을 수행하십시오.

.. literalinclude:: images/003.php

위의 코드는 라이브러리의 source_image 폴더에 있는 *mypic.jpg*\ 라는 이미지를 찾은 다음 GD2 image_library를 사용하여 100x100 픽셀인 새 이미지를 작성하여 새 파일(썸네일)로 저장하도록 지시합니다.
``fit()`` 메소드를 사용하므로 원하는 종횡비를 기준으로 자르기 위해 이미지에서 가장 좋은 부분을 찾은 다음 이미지를 자르고 크기를 조정합니다.

저장하기 전에 필요한만큼 사용 가능한 메소드를 통해 이미지를 처리할 수 있습니다.
원본 이미지는 그대로 유지되며, 새로 작성된 이미지는 각 메소드를 통과하여 이전 결과 위에 새로운 결과가 적용됩니다

.. literalinclude:: images/004.php

이 예에서는 동일한 이미지를 가져와 먼저 휴대폰 방향 문제를 해결하기 위해 이미지를 90도 회전한 다음, 결과를 왼쪽 상단에서 100x100픽셀 이미지로 자릅니다. 
결과는 썸네일로 저장됩니다.

.. note:: 이미지 클래스에서 작업를 수행하려면 이미지 파일이 포함된 폴더에 쓰기 권한이 있어야합니다.

.. note:: 이미지 처리에는 일부 작업에 상당한 양의 서버 메모리가 필요할 수 있습니다. 이미지를 처리하는 동안 메모리 부족 오류가 발생하면 최대 크기를 제한하거나 PHP 메모리 제한을 조정해야합니다.

이미지 품질
===============

``save()``\ 는 두 번째 매개 변수 ``$quality``\ 를 사용하여 결과 이미지 품질을 변경할 수 있습니다.
값의 범위는 0-100이며 프레임 워크 기본값은 90입니다. 이 매개 변수는 JPEG 이미지에만 적용됩니다.

.. literalinclude:: images/005.php

.. note:: 품질이 높을수록 파일 크기가 커집니다. https://www.php.net/manual/en/function.imagejpeg.php 참조

이미지 리소스를 포함하지 않고 이미지 품질을 변경하면 원본과 같은 사본이 생성됩니다.

.. literalinclude:: images/006.php

처리 메소드
==================

사용 가능한 7 가지 메소드가 있습니다:

-  ``$image->crop()``
-  ``$image->convert()``
-  ``$image->fit()``
-  ``$image->flatten()``
-  ``$image->flip()``
-  ``$image->resize()``
-  ``$image->rotate()``
-  ``$image->text()``

이러한 메소드는 클래스 인스턴스를 리턴하여 위에 표시된대로 서로 체인화될 수 있습니다.
실패하면 오류 메시지가 포함된 ``CodeIgniter\Images\ImageException``\ 이 발생합니다.
다음과 같이 실패시 오류를 표시하여 예외를 포착하는 것이 좋습니다.

.. literalinclude:: images/007.php

이미지 자르기
===============

원본 이미지의 일부만 남아 있도록 이미지를 자를 수 있습니다. 특정 크기/종횡비와 일치하는 축소판 이미지를 만들 때 자주 사용됩니다. 
이것은 ``crop()`` 메소드로 처리됩니다.

::

    crop(int $width = null, int $height = null, int $x = null, int $y = null, bool $maintainRatio = false, string $masterDim = 'auto')

- ``$width`` 결과 이미지의 원하는 너비(픽셀)
- ``$height`` 결과 이미지의 원하는 높이(픽셀)
- ``$x`` 이미지의 왼쪽부터 자르기를 시작할 픽셀 수
- ``$y`` 이미지 상단부터 자르기 시작 픽셀 수
- ``$maintainRatio`` true인 경우 이미지의 원래 종횡비를 유지하기 위해 필요에 따라 최종 크기를 조정
- ``$masterDim`` ``$maintainRatio``\ 가 true일 때 어떤 치수를 그대로 두어야 하는지 지정. 사용 가능 값: ``width``, ``height``, or ``auto``.

이미지 중심에서 50x50 픽셀 정사각형을 가져 오려면 먼저 적절한 x와 y오프셋 값을 계산해야합니다

.. literalinclude:: images/008.php

이미지 변환
=================

``convert()`` 메소드는 원하는 파일 형식에 대한 라이브러리의 내부 표시기를 변경합니다. 
이것은 실제 이미지 리소스를 건드리지 않지만 사용할 형식을 ``save()``\ 로 나타냅니다.

::

	convert(int $imageType)

- ``$imageType`` PHP의 이미지 유형 상수중 하나 (https://www.php.net/manual/en/function.image-type-to-mime-type.php\ 을 살펴보세요.)

  .. literalinclude:: images/009.php

.. note:: ImageMagick은 ``$imageType``\ 을 무시하고 확장자로 표시된 형식으로 파일을 저장합니다.

이미지 피팅
==============

``fit()`` 메소드는 다음 단계를 수행하여 이미지의 일부를 "똑똑한" 방식으로 자르는 것을 단순화 하는데 도움을 줍니다.

- 원하는 종횡비를 유지하기 위해 원본 이미지의 잘라낼 부분 결정
- 원본 이미지 자름
- 최종 치수로 크기 조정

::

    fit(int $width, int $height = null, string $position = 'center')

- ``$width`` 이미지의 원하는 최종 너비
- ``$height`` 이미지의 원하는 최종 높이
- ``$position`` 잘라낼 이미지 부분 결정, 사용가능 위치: ``top-left``, ``top``, ``top-right``, ``left``, ``center``, ``right``, ``bottom-left``, ``bottom``, ``bottom-right``.

종횡비를 항상 유지하는 간단한 자르기 방법을 제공합니다.

.. literalinclude:: images/010.php

이미지 병합
=================

``flatten()`` 메소드는 투명한 이미지(PNG) 뒤에 배경색을 추가하고 RGBA 픽셀을 RGB 픽셀로 변환하는 것을 목표로합니다.

- 투명 이미지에서 jpg로 변환할 때 배경색을 지정하십시오.

::

    flatten(int $red = 255, int $green = 255, int $blue = 255)

- ``$red`` 배경의 빨간색 값
- ``$green`` 배경의 녹색 값
- ``$blue`` 배경의 파란색 값

.. literalinclude:: images/011.php

이미지 뒤집기
===============

수평 또는 수직 축을 따라 이미지를 뒤집을 수 있습니다

::

    flip(string $dir)

- ``$dir`` 뒤집을 축을 지정, 사용 가능 값 : ``vertical``, ``horizontal``

.. literalinclude:: images/012.php

이미지 크기 조정
=================

``resize()`` 메소드는 필요한 모든 크기에 맞게 이미지 크기를 조정할 수 있습니다

::

	resize(int $width, int $height, bool $maintainRatio = false, string $masterDim = 'auto')

- ``$width`` 새 이미지의 원하는 너비 (픽셀)
- ``$height`` 새 이미지의 원하는 높이 (픽셀)
- ``$maintainRatio`` 이미지를 새로운 크기에 맞게 늘릴지, 원래 종횡비를 유지할지 결정
- ``$masterDim`` 비율을 유지할 때 어떤 축의 치수를 준수해야 하는지 지정, 사용 가능 값 : ``width``, ``height``.

이미지 크기를 조정할 때 원본 이미지의 비율을 유지하거나, 원하는 크기에 맞게 새 이미지를 늘리거나 여부를 선택할 수 있습니다.
``$maintainRatio``\ 가 true면 ``$masterDim``\ 에 의해 지정된 치수는 그대로 유지되고 다른 치수는 원래 이미지의 종횡비와 일치하도록 변경됩니다.

.. literalinclude:: images/013.php

이미지 회전
===============

``rotate()`` 메소드를 사용하면 이미지를 90 도씩 회전할 수 있습니다

::

	rotate(float $angle)

- ``$angle`` 회전 각도. 사용 가능 값 : ``90``, ``180``, ``270``.

.. note:: ``$angle`` 매개 변수는 부동 소수점(float)을 허용하지만 프로세스 중에 정수로 변환합니다. 값이 위에 나열된 세 값 이외의 값이면 ``CodeIgniter\Images\ImageException``\ 이 발생합니다.

텍스트 워터 마크 추가
=======================

``text()`` 메소드를 사용하여 텍스트 워터 마크를 이미지에 오버레이할 수 있습니다.
이 기능은 저작권, 작가 이름을 표시하여 다른 사람의 제품에 사용되지 않도록 하는데 유용합니다.

::

	text(string $text, array $options = [])

첫 번째 매개 변수는 표시하려는 텍스트 문자열입니다.
두 번째 매개 변수는 텍스트 표시 방법을 지정하는 옵션 배열입니다.

.. literalinclude:: images/014.php

사용 가능한 옵션은 다음과 같습니다:

- ``color``         텍스트 색상 (16 진수), 예 : #ff0000
- ``opacity``		텍스트의 불투명도를 나타내는 0과 1 사이의 숫자
- ``withShadow``	그림자를 표시할지 여부(bool)
- ``shadowColor``   그림자의 색 (16 진수)
- ``shadowOffset``	그림자를 오프셋 할 픽셀 수, 수직 및 수평 값 모두에 적용
- ``hAlign``        수평 정렬: left, center, right
- ``vAlign``        수직 정렬: top, middle, bottom
- ``hOffset``		x 축에 대한 추가 오프셋 (픽셀)
- ``vOffset``		y 축에 대한 추가 오프셋 (픽셀)
- ``fontPath``		사용하려는 TTF 글꼴의 전체 서버 경로, 지정된 글꼴이 없으면 시스템 글꼴이 사용됩니다.
- ``fontSize``		사용할 글꼴 크기, 시스템 글꼴과 함께 GD 핸들러를 사용할 때 유효한 값은 1-5입니다.

.. note:: ImageMagick 드라이버는 fontPath의 전체 서버 경로를 인식하지 못합니다. 설치된 시스템 글꼴 중 하나 (예:Calibri)의 이름을 제공하십시오.
