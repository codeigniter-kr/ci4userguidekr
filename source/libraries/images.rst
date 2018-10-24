########################
이미지 조작 클래스
########################

CodeIgniter's Image Manipulation class lets you perform the following
actions
CodeIgniter의 이미지 조작 클래스를 사용하면 다음 작업을 수행 할 수 있습니다.
:

- 이미지 크기 조정
- 썸네일 생성
- 이미지 자르기
- 이미지 회전
- 이미지 워터 마킹

The following image libraries are supported: GD/GD2, and ImageMagick.
다음 이미지 라이브러리를 지원해야합니다. : GD/GD2 및 ImageMagick.

.. contents::
    :local:
    :depth: 2

**********************
클래스 초기화하기
**********************

Like most other classes in CodeIgniter, the image class is initialized
in your controller by calling the Services class

CodeIgniter의 다른 대부분의 클래스와 마찬가지로 이미지 클래스는 Controller에서 Services 클래스를 호출하여 초기화됩니다.
::

	$image = Config\Services::image();

You can pass the alias for the image library you wish to use into the
Service function

사용할 이미지 라이브러리의 별칭을 Service 함수에 전달할 수 있습니다.
::

    $image = Config\Services::image('imagick');

The available Handlers are as follows:
사용 가능한 핸들러는 다음과 같습니다.

- gd        GD/GD2 image library
- imagick   ImageMagick library.

If using the ImageMagick library, you must set the path to the library on your
server in **application/Config/Images.php**.
ImageMagick 라이브러리를 사용하는 경우 서버의 라이브러리 경로를 **application/Config/Images.php** 에 설정해야 합니다.

.. note:: The ImageMagick handler does NOT require the imagick extension to be
        loaded on the server. As long as your script can access the library
        and can run ``exec()`` on the server, it should work.

		ImageMagick 핸들러는 imagick extension 을 서버에 로드 할 필요가 없습니다. 
		스크립트가 라이브러리에 액세스 할 수 있고 서버에서 ``exec()`` 실행할 수
		있는 한 제대로 작동해야합니다.

이미지 처리
===================

Regardless of the type of processing you would like to perform
(resizing, cropping, rotation, or watermarking), the general process is
identical. You will set some preferences corresponding to the action you
intend to perform, then call one of the available processing functions.
For example, to create an image thumbnail you'll do this

수행하려는 처리 유형 (크기 조정, 자르기, 회전 또는 워터 마킹)에 관계없이
일반 프로세스는 동일합니다. 수행하려는 동작에 해당하는 일부 기본 설정을
지정한 다음 사용 가능한 처리 기능 중 하나를 호출합니다. 예를 들어 미리보기 이미지
를 만들려면 다음을 수행하십시오.
::

	$image = Config\Services::image()
		->withFile('/path/to/image/mypic.jpg')
		->fit(100, 100, 'center')
		->save('/path/to/image/mypic_thumb.jpg');

The above code tells the library  to look for an image
called *mypic.jpg* located in the source_image folder, then create a
new image from it that is 100 x 100pixels using the GD2 image_library,
and save it to a new file (the thumb). Since it is using the fit() method,
it will attempt to find the best portion of the image to crop based on the
desired aspect ratio, and then crop and resize the result.
위의 코드는 이미지라는를 찾기 위해 라이브러리를 알려줍니다 *mypic.jpg* 다음의는 source_image 폴더에있는 GD2의 image_library를 사용하여 100 × 100pixels입니다 그것에서 새로운 이미지를 만들고, 새 파일(미리보기)에 저장합니다. fit() 메서드를 사용하기 때문에 원하는 가로 세로 비율에 따라 자르기 할 이미지의 가장 좋은 부분을 찾은 다음 결과를 자르고 크기를 조정하려고 시도합니다.

An image can be processed through as many of the available methods as
needed before saving. The original image is left untouched, and a new image
is used and passed through each method, applying the results on top of the
previous results
저장하기 전에 필요에 따라 가능한 많은 방법을 통해 이미지를 처리할 수 있습니다. 원본 이미지는 그대로두고 새 이미지가 사용되어 각 방법을 통과하여 이전 결과 상단에 결과가 적용됩니다
::

	$image = Config\Services::image()
		->withFile('/path/to/image/mypic.jpg')
		->reorient()
		->rotate(90)
		->crop(100, 100, 0, 0)
		->save('/path/to/image/mypic_thumb.jpg');

This example would take the same image and first fix any mobile phone orientation issues,
rotate the image by 90 degress, and then crop the result into a 100x100 pixel image,
starting at the top left corner. The result would be saved as the thumbnail.
이 예제에서는 동일한 이미지를 사용하여 먼저 휴대 전화 방향 문제를 해결하고 이미지를 90도 회전 한 다음 결과를 100x100 픽셀 이미지로 자르며 왼쪽 상단에서 시작합니다. 결과는 미리보기 이미지로 저장됩니다.

.. note:: In order for the image class to be allowed to do any
	processing, the folder containing the image files must have write
	permissions.
	이미지 클래스가 모든 처리를 수행 할 수있게하려면 이미지 파일이 들어있는 폴더에 쓰기 권한이 있어야합니다.

.. note:: Image processing can require a considerable amount of server
	memory for some operations. If you are experiencing out of memory errors
	while processing images you may need to limit their maximum size, and/or
	adjust PHP memory limits.
	이미지 처리에는 일부 작업에 상당한 양의 서버 메모리가 필요할 수 있습니다. 이미지 처리 중에 메모리 부족 문제가 발생하면 이미지의 최대 크기를 제한하거나 PHP 메모리 제한을 조정해야 할 수도 있습니다.

Processing Methods
==================

There are six available processing methods:
6 가지 processing method 가 있습니다.

-  $image->crop()
-  $image->fit()
-  $image->flatten()
-  $image->flip()
-  $image->resize()
-  $image->rotate()
-  $image->text()

These methods return the class instance so they can be chained together, as shown above.
If they fail they will throw a ``CodeIgniter\Images\ImageException`` that contains
the error message. A good practice is to catch the exceptions, showing an
error upon failure, like this
이러한 메소드는 클래스 인스턴스를 반환하므로 위에 표시된 것처럼 서로 연결할 수 있습니다. 
그들이 실패 하면 오류 메시지가 포함 된 ``CodeIgniter\Images\ImageException`` 오류 메시지를 
던집니다 . 좋은 예는 다음과 같이 예외를 잡아 실패시 오류를 표시하는 것입니다.
::

	try {
        $image = Config\Services::image()
            ->withFile('/path/to/image/mypic.jpg')
            ->fit(100, 100, 'center')
            ->save('/path/to/image/mypic_thumb.jpg');
	}
	catch (CodeIgniter\Images\ImageException $e)
	{
		echo $e->getMessage();
	}

.. note:: You can optionally specify the HTML formatting to be applied to
	the errors, by submitting the opening/closing tags in the function,
	like this
	함수에 여는 태그 나 닫는 태그를 다음과 같이 제출하여 오류에 적용 할 HTML 서식을 선택적으로 지정할 수 있습니다.
	::

	$this->image_lib->display_errors('<p>', '</p>');

이미지 자르기
---------------

Images can be cropped so that only a portion of the original image remains. This is often used when creating
thumbnail images that should match a certain size/aspect ratio. This is handled with the ``crop()`` method
본 이미지의 일부만 남아 있도록 이미지를 잘라낼 수 있습니다. 이는 특정 크기 / 종횡비와 일치해야하는 축소판 이미지를 작성할 때 자주 사용됩니다. 이 ``crop()`` 메소드 는 다음 메소드 로 처리됩니다 .
::

    crop(int $width = null, int $height = null, int $x = null, int $y = null, bool $maintainRatio = false, string $masterDim = 'auto')

- **$width** is the desired width of the resulting image, in pixels. 이미지의 원하는 너비 (픽셀 단위)
- **$height** is the desired height of the resulting image, in pixels. 이미지의 원하는 높이 (픽셀 단위)
- **$x** is the number of pixels from the left side of the image to start cropping. 자르기를 시작할 이미지 왼쪽의 픽셀 수
- **$y** is the number of pixels from the top of the image to start cropping. 자르기를 시작할 이미지의 상단으로부터의 픽셀 수
- **$maintainRatio** will, if true, adjust the final dimensions as needed to maintain the image's original aspect ratio. true 면 이미지의 원래 종횡비를 유지하는 데 필요한 최종 치수를 조정합니다.
- **$masterDim** specifies which dimension should be left untouched when $maintainRatio is true. Values can be: 'width', 'height', or 'auto'. true 일 때 $maintainRatio 손대지 않아야하는 차원을 지정합니다. 값은 'width', 'height'또는 'auto'일 수 있습니다.

To take a 50x50 pixel square out of the center of an image, you would need to first calculate the appropriate x and y
offset values
이미지 중심에서 50x50 픽셀 사각형을 가져 오려면 먼저 적절한 x 및 y 오프셋 값을 계산해야합니다.
::

    $info = Services::image('imagick')
		->withFile('/path/to/image/mypic.jpg')
		->getFile()
		->getProperties(true);

    $xOffset = ($info['width'] / 2) - 25;
    $yOffset = ($info['height'] / 2) - 25;

    Services::image('imagick')
		->withFile('/path/to/image/mypic.jpg')
		->crop(50, 50, $xOffset, $yOffset)
		->save('path/to/new/image.jpg');

피팅 이미지
--------------

The ``fit()`` method aims to help simplify cropping a portion of an image in a "smart" way, by doing the following steps:
fit() 메소드는 다음 단계를 수행하여 이미지의 일부를 "스마트"하게 자르는 작업을 단순화합니다.

- Determine the correct portion of the original image to crop in order to maintain the desired aspect ratio.
  원하는 가로 세로 비율을 유지하기 위해 잘라낼 원본 이미지의 정확한 부분을 결정합니다.
- Crop the original image.
  원본 이미지 자르기.
- Resize to the final dimensions.
  최종 치수로 크기 조정.

::

    fit(int $width, int $height = null, string $position = 'center')

- **$width** is the desired final width of the image. 원하는 최종 너비
- **$height** is the desired final height of the image. 원하는 최종 높이
- **$position** determines the portion of the image to crop out. 자르기 할 이미지 부분, 허용 위치: 'top-left', 'top', 'top-right', 'left', 'center', 'right', 'bottom-left', 'bottom', 'bottom-right'.

This provides a much simpler way to crop that will always maintain the aspect ratio
이것은 종횡비를 항상 유지할 수있는 훨씬 간단한 방법을 제공합니다.
::

	Services::image('imagick')
		->withFile('/path/to/image/mypic.jpg')
		->fit(100, 150, 'left')
		->save('path/to/new/image.jpg');

이미지 병합
-----------------

The ``flatten()`` method aims to add a background color behind transparent images (PNG) and convert RGBA pixels to RGB pixels
flatten() 메소드는 투명 이미지 (PNG) 뒤에 배경색을 추가하고 RGBA 픽셀을 RGB 픽셀로 변환하는 것을 목표로합니다.

- Specify a background color when converting from transparent images to jpgs.
투명 이미지에서 jpg로 변환 할 때 사용할 배경색을 지정.

::

    flatten(int $red = 255, int $green = 255, int $blue = 255)

- **$red** is the red value of the background. 배경의 red 값
- **$green** is the green value of the background. 배경의 green 값
- **$blue** is the blue value of the background. 배경의 blue 값

::

	Services::image('imagick')
		->withFile('/path/to/image/mypic.png')
		->flatten()
		->save('path/to/new/image.jpg');

	Services::image('imagick')
		->withFile('/path/to/image/mypic.png')
		->flatten(25,25,112)
		->save('path/to/new/image.jpg');

이미지 뒤집기
---------------

Images can be flipped along either their horizontal or vertical axis
이미지를 수평 또는 수직 축으로 뒤집어 줍니다.
::

    flip(string $dir)

- **$dir** specifies the axis to flip along. Can be either 'vertical' or 'horizontal'.
  **$dir** 은 뒤집을 축을 지정합니다. 'vertical' 또는 'horizontal'중 하나.

::

	Services::image('imagick')
		->withFile('/path/to/image/mypic.jpg')
		->flip('horizontal')
		->save('path/to/new/image.jpg');

이미지 크기 조정
---------------

Images can be resized to fit any dimension you require with the resize() method
이미지는 resize() 메서드를 사용하여 필요한 모든 치수에 맞게 크기가 조정할 수 있습니다.
::

	resize(int $width, int $height, bool $maintainRatio = false, string $masterDim = 'auto')

- **$width** is the desired width of the new image in pixels 조정할 너비(픽셀 단위)
- **$height** is the desired height of the new image in pixels 조정할 높이(픽셀 단위)
- **$maintainRatio** determines whether the image is stretched to fit the new dimensions, or the original aspect ratio is maintained. 새로운 크기에 맞게 늘려 지거나 원래의 종횡비가 유지 되는지 여부를 결정
- **$masterDim** specifies which axis should have its dimension honored when maintaining ratio. Either 'width', 'height'. 비율을 유지할 때 차원을 유지할 축을 지정, 'width' 또는 'height'

When resizing images you can choose whether to maintain the ratio of the original image, or stretch/squash the new
image to fit the desired dimensions. If $maintainRatio is true, the dimension specified by $masterDim will stay the same,
while the other dimension will be altered to match the original image's aspect ratio.
이미지의 크기를 조정할 때 원본 이미지의 비율을 유지할지 또는 원하는 크기에 맞게 새 이미지를 늘리거나 스쿼시 할지를 선택할 수 있습니다. $ maintainRatio가 true이면 $ masterDim에 의해 지정된 차원은 그대로 유지되지만 다른 차원은 원본 이미지의 종횡비와 일치하도록 변경됩니다.

::

	Services::image('imagick')
		->withFile('/path/to/image/mypic.jpg')
		->resize(200, 100, true, 'height')
		->save('path/to/new/image.jpg');

이미지 회전
---------------

The rotate() method allows you to rotate an image in 90 degree increments
rotate () 메서드를 사용하면 이미지를 90도 단위로 회전 할 수 있습니다.
::

	rotate(float $angle)

- **$angle** is the number of degrees to rotate. One of '90', '180', '270'. **$angle** 은 회전 할 각도 입니다. '90', '180', '270'중 하나입니다.

.. note:: While the $angle parameter accepts a float, it will convert it to an integer during the process.
		If the value is any other than the three values listed above, it will throw a CodeIgniter\Images\ImageException.
		$angle 매개 변수는 부동 소수점을 허용하지만 처리 중에 정수로 변환합니다. 값이 위에 나열된 세 값 이외의 값이면 CodeIgniter\Images\ImageException 이 발생합니다.

텍스트 워터 마크 추가
-----------------------

You can overlay a text watermark onto the image very simply with the text() method. This is useful for placing copyright
notices, photogropher names, or simply marking the images as a preview so they won't be used in other people's final
products.
text() 메서드를 사용하면 이미지에 텍스트 워터마크를 매우 간단하게 오버레이 할 수 있습니다. 이 기능은 저작권 표시나 사진 작가의 이름을 붙이거나 이미지를 미리보기로 표시하여 다른 사람의 최종 제품에 사용되지 않도록하는데 유용합니다.
::

	text(string $text, array $options = [])

The first parameter is the string of text that you wish to display. The second parameter is an array of options
that allow you to specify how the text should be displayed
첫 번째 매개 변수는 표시 할 문자열입니다. 두 번째 매개 변수는 텍스트를 표시하는 방법을 지정할 수있는 옵션 배열입니다.
::

	Services::image('imagick')
		->withFile('/path/to/image/mypic.jpg')
		->text('Copyright 2017 My Photo Co', [
		    'color'      => '#fff',
		    'opacity'    => 0.5,
		    'withShadow' => true,
		    'hAlign'     => 'center',
		    'vAlign'     => 'bottom',
		    'fontSize'   => 20
		])
		->save('path/to/new/image.jpg');

The possible options that are recognized are as follows:
가능한 옵션은 다음과 같습니다.

- color         Text Color (hex number), i.e. #ff0000
- opacity		A number between 0 and 1 that represents the opacity of the text.
- withShadow	Boolean value whether to display a shadow or not.
- shadowColor   Color of the shadow (hex number)
- shadowOffset	How many pixels to offset the shadow. Applies to both the vertical and horizontal values.
- hAlign        Horizontal alignment: left, center, right
- vAlign        Vertical alignment: top, middle, bottom
- hOffset		Additional offset on the x axis, in pixels
- vOffset		Additional offset on the y axis, in pixels
- fontPath		The full server path to the TTF font you wish to use. System font will be used if none is given.
- fontSize		The font size to use. When using the GD handler with the system font, valid values are between 1-5.

.. note:: The ImageMagick driver does not recognize full server path for fontPath. Instead, simply provide the
		name of one of the installed system fonts that you wish to use, i.e. Calibri.
		ImageMagick 드라이버는 fontPath의 전체 서버 경로를 인식하지 못합니다. 대신, 사용하고자하는 설치된 시스템 글꼴 중 하나, 즉 Calibri의 이름을 제공하십시오.

