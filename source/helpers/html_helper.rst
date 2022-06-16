###########
HTML 헬퍼
###########

HTML 헬퍼 파일에는 HTML 작업을 지원하는 함수가 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

.. literalinclude:: html_helper/001.php

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: img([$src = ''[, $indexPage = false[, $attributes = '']]])

    :param  string|array  $src:  이미지 소스 URI 또는 속성 및 값의 배열
    :param  bool    $indexPage:  ``$src``\ 를 라우팅된 URI 문자열로 취급할 지 여부
    :param  mixed   $attributes: 추가 HTML 속성
    :returns:   HTML image 태그
    :rtype: string

    HTML ``<img />`` 태그를 만들 수 있습니다. 첫 번째 매개 변수는 이미지 소스를 포함합니다.

    .. literalinclude:: html_helper/002.php

    *src*\ 에 생성된 주소에 ``$config['indexPage']``\ 로 지정된 페이지가 추가되어야 하는 경우에 해당하는 선택적 두 번째 매개 변수(true/false 값)가 있습니다.
    미디어 컨트롤러를 사용하는 경우 유용합니다.

    .. literalinclude:: html_helper/003.php

    또한 모든 속성과 값을 완벽하게 제어하기 위한 연관 배열을 첫 번째 매개 변수로 전달할 수 있습니다.
    *alt* 속성이 제공되지 않으면 CodeIgniter는 빈 문자열을 생성합니다.

    .. literalinclude:: html_helper/004.php

.. php:function:: img_data([$src = ''[, $indexPage = false[, $attributes = '']]])

    :param string $path: 이미지 파일의 경로
    :param string|null $mime: 사용할 MIME 유형 또는 null
    :returns: base64로 인코딩된 이진 이미지 문자열
    :rtype: string

    "data:" 프로토콜을 사용하여 이미지에서 src-ready 문자열을 생성합니다.

    .. literalinclude:: html_helper/005.php

    두 번째 매개 변수 MIME 유형을 지정할 수 있습니다. 지정하지 않으면 MIME 구성을 사용하여 추측합니다.

    .. literalinclude:: html_helper/006.php

    ``$path``\ 가 존재해야하며 ``data:`` 프로토콜에서 지원하는 읽을 수 있는 이미지 형식이어야 합니다.
    이 기능은 매우 큰 파일에는 권장되지 않지만 웹 액세스가 (예: **public/**) 불가능한 앱에서 이미지를 편리하게 제공할 수 있습니다.

.. php:function:: link_tag([$href = ''[, $rel = 'stylesheet'[, $type = 'text/css'[, $title = ''[, $media = ''[, $indexPage = false[, $hreflang = '']]]]]]])

    :param  string  $href:      링크 파일의 소스
    :param  string  $rel:       관계 유형
    :param  string  $type:      관련 문서의 종류
    :param  string  $title:     링크 제목
    :param  string  $media:     미디어 타입
    :param  bool    $indexPage: ``$src``\ 를 라우팅된 URI 문자열로 취급할 지 여부
    :param  string  $hreflang:  Hreflang 타입
    :returns:   HTML link 태그
    :rtype: string

    HTML ``<link />`` 태그를 만들 수 있습니다.    
    스타일 시트 링크 및 기타 링크에 유용합니다.

    필수 매개 변수는 *href* 이며 선택적 매개 변수는 *rel*, *type*, *title*, *media*, *indexPage* 입니다.

    *indexPage*\ 는 *href*\ 가 생성한 주소에 ``$config['indexPage']``\ 로 지정된 페이지를 추가해야 하는지 여부를 지정하는 부울 값입니다.

    .. literalinclude:: html_helper/007.php

    .. literalinclude:: html_helper/008.php

    또한 ``link_tag()`` 함수에 모든 속성과 값을 연관 배열로 전달할 수 있습니다
    
    .. literalinclude:: html_helper/009.php

.. php:function:: script_tag([$src = ''[, $indexPage = false]])

    :param  mixed   $src: JavaScript 파일의 소스 URL 또는 속성을 지정하는 연관 배열
    :param  bool    $indexPage: ``$src``\ 를 라우팅된 URI 문자열로 취급할 지 여부
    :returns:   HTML script 태그
    :rtype: string

    HTML ``<script></script>`` 태그를 만듭니다. 
    필수 매개 변수는 *src* 이며 선택적 매개 변수는 * indexPage * 입니다.

    *indexPage*\ 는 *src*\ 가 생성한 주소에 ``$config['indexPage']``\ 로 지정된 페이지를 추가해야 하는지 여부를 지정하는 부울 값입니다.

    .. literalinclude:: html_helper/010.php

    또한 ``script_tag()`` 함수에 모든 속성과 값을 연관 배열로 전달할 수 있습니다
    
    .. literalinclude:: html_helper/011.php

.. php:function:: ul($list[, $attributes = ''])

    :param  array   $list: 목록 항목
    :param  array   $attributes: HTML 속성
    :returns:   HTML 형식의 비 순차 목록
    :rtype: string

    단순 또는 다차원 배열에서 정렬되지 않은 HTML 목록을 생성합니다.
    
    .. literalinclude:: html_helper/012.php

    위의 코드는 아래 HTML을 생성합니다.

    .. code-block:: html

        <ul class="boldlist" id="mylist">
            <li>red</li>
            <li>blue</li>
            <li>green</li>
            <li>yellow</li>
        </ul>

    다음은 다차원 배열을 사용하는 더 복잡한 예입니다.
    
    .. literalinclude:: html_helper/013.php

    위의 코드는 아래의 HTML을 생성합니다.

    .. code-block:: html

        <ul class="boldlist" id="mylist">
            <li>colors
                <ul>
                    <li>red</li>
                    <li>blue</li>
                    <li>green</li>
                </ul>
            </li>
            <li>shapes
                <ul>
                    <li>round</li>
                    <li>suare</li>
                    <li>circles
                        <ul>
                            <li>elipse</li>
                            <li>oval</li>
                            <li>sphere</li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li>moods
                <ul>
                    <li>happy</li>
                    <li>upset
                        <ul>
                            <li>defeated
                                <ul>
                                    <li>dejected</li>
                                    <li>disheartened</li>
                                    <li>depressed</li>
                                </ul>
                            </li>
                            <li>annoyed</li>
                            <li>cross</li>
                            <li>angry</li>
                        </ul>
                    </li>
                </ul>
            </li>
        </ul>

.. php:function:: ol($list, $attributes = '')

    :param  array   $list: 목록 항목
    :param  array   $attributes: HTML 속성
    :returns:   HTML 형식의 정렬 된 목록
    :rtype: string

    :php:func:`ul()`\ 과 동일하지만 ``<ul>`` 대신 ``<ol>`` 태그를 사용하여 정렬된 목록을 생성합니다.

.. php:function:: video($src[, $unsupportedMessage = ''[, $attributes = ''[, $tracks = [][, $indexPage = false]]]])

    :param  mixed   $src:                소스 문자열 또는 source 함수의 배열. :php:func:`source()`\ 함수 참조
    :param  string  $unsupportedMessage: 미디어 태그를 지원하지 않는 브라우저에 표시되는 메시지
    :param  string  $attributes:         HTML 속성
    :param  array   $tracks:             track 함수의 배열. :php:func:`track()`\ 함수 참조
    :param  bool    $indexPage:          $src를 라우팅된 URI 문자열로 취급할 지 여부
    :returns:                            HTML 형식의 비디오 요소
    :rtype: string

    단순 또는 소스 배열에서 HTML 비디오 요소를 생성합니다.
    
    .. literalinclude:: html_helper/014.php

    위의 코드는 아래의 HTML을 생성합니다.

    .. code-block:: html

        <video src="test.mp4" controls>
          Your browser does not support the video tag.
        </video>

        <video src="http://www.codeigniter.com/test.mp4" controls>
          <track src="subtitles_no.vtt" kind="subtitles" srclang="no" label="Norwegian No" />
          <track src="subtitles_yes.vtt" kind="subtitles" srclang="yes" label="Norwegian Yes" />
          Your browser does not support the video tag.
        </video>

        <video class="test" controls>
          <source src="movie.mp4" type="video/mp4" class="test" />
          <source src="movie.ogg" type="video/ogg" />
          <source src="movie.mov" type="video/quicktime" />
          <source src="movie.ogv" type="video/ogv; codecs=dirac, speex" />
          <track src="subtitles_no.vtt" kind="subtitles" srclang="no" label="Norwegian No" />
          <track src="subtitles_yes.vtt" kind="subtitles" srclang="yes" label="Norwegian Yes" />
          Your browser does not support the video tag.
        </video>

.. php:function:: audio($src[, $unsupportedMessage = ''[, $attributes = ''[, $tracks = [][, $indexPage = false]]]])

    :param  mixed   $src:                소스 문자열 또는 source 함수의 배열. :php:func:`source()`\ 함수 참조
    :param  string  $unsupportedMessage: 미디어 태그를 지원하지 않는 브라우저에 표시되는 메시지
    :param  string  $attributes:
    :param  array   $tracks:             track 함수의 배열. :php:func:`track()`\ 함수 참조
    :param  bool    $indexPage:          $src를 라우팅된 URI 문자열로 취급할 지 여부
    :returns:                            HTML 형식의 오디오 요소
    :rtype: string

    :php:func:`video()`\ 와 동일하지만 ``<video>`` 대신 ``<audio>`` 태그를 생성합니다.

.. php:function:: source($src = ''[, $type = false[, $attributes = '']])

    :param  string  $src:        미디어 리소스의 경로
    :param  bool    $type:       선택적 코덱 매개 변수가있는 리소스의 MIME 유형
    :param  array   $attributes: HTML 속성
    :returns:   HTML source 태그
    :rtype: string

    HTML ``<source />`` 태그를 만듭니다.

    첫 번째 매개 변수는 소스를 포함합니다.
    
    .. literalinclude:: html_helper/015.php

.. php:function:: embed($src = ''[, $type = false[, $attributes = ''[, $indexPage = false]]])

    :param  string  $src:        embed할 리소스의 경로
    :param  bool    $type:       MIME-type
    :param  array   $attributes: HTML 속성
    :param  bool    $indexPage:  $src를 라우팅된 URI 문자열로 취급할 지 여부
    :returns:   HTML embed 태그
    :rtype: string

    HTML ``<embed />`` 태그를 만듭니다.
    첫 번째 매개 변수에는 소스를 포함합니다.
    
    . literalinclude:: html_helper/016.php

.. php:function:: object($data = ''[, $type = false[, $attributes = '']])

    :param  string  $data:       리소스 URL
    :param  bool    $type:       리소스의 Content-type
    :param  array   $attributes: HTML 속성
    :param  array   $params:     param 함수의 배열. :php:func:`param()`\ 함수 참조
    :returns:   HTML object tag
    :rtype: string

    HTML ``<object />`` 태그를 만듭니다. 
    첫 번째 파라미터는 object 데이터를 포함합니다.

    .. literalinclude:: html_helper/017.php

    위의 코드는 아래의 HTML을 생성합니다.

    .. code-block:: html

        <object data="movie.swf" class="test"></object>

        <object data="movie.swf" class="test">
          <param name="foo" type="ref" value="bar" class="test" />
          <param name="hello" type="ref" value="world" class="test" />
        </object>

.. php:function:: param($name = ''[, $type = false[, $attributes = '']])

    :param  string  $name:       매개 변수의 이름
    :param  string  $value:      매개 변수의 값
    :param  array   $attributes: HTML 속성
    :returns:   HTML param 태그
    :rtype: string

    HTML ``<param />`` 태그를 만듭니다. 첫 번째 매개 변수는 param 소스를 포함합니다.
    
    .. literalinclude:: html_helper/018.php

.. php:function:: track($name = ''[, $type = false[, $attributes = '']])

    :param  string  $name:       매개 변수의 이름
    :param  string  $value:      매개 변수의 값
    :param  array   $attributes: HTML 속성
    :returns:   HTML track 태그
    :rtype: string

    시간이 지정된 트랙을 지정하기 위해 트랙 요소를 생성합니다.
    트랙은 WebVTT 형식으로 포맷됩니다. 
    
    .. literalinclude:: html_helper/019.php

.. php:function:: doctype([$type = 'html5'])

    :param  string  $type: Doctype 이름
    :returns:   HTML DocType 태그
    :rtype: string

    문서 유형(DocType) 선언 또는 DTD를 생성하는데 도움을 줍니다.
    HTML 5가 기본적으로 사용되지만 많은 문서 유형을 사용할 수 있습니다.

    .. literalinclude:: html_helper/020.php

    다음은 사전 정의된 doctype 선택 목록입니다.
    이 정보는 `application/Config/DocTypes.php`\ 에 있으며, ``.env`` 설정을 통하여 오버라이드될 수 있습니다.

    =============================== =================== ==================================================================================================================================================
    Document type                   Option              Result
    =============================== =================== ==================================================================================================================================================
    XHTML 1.1                       xhtml11             <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
    XHTML 1.0 Strict                xhtml1-strict       <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    XHTML 1.0 Transitional          xhtml1-trans        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    XHTML 1.0 Frameset              xhtml1-frame        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
    XHTML Basic 1.1                 xhtml-basic11       <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">
    HTML 5                          html5               <!DOCTYPE html>
    HTML 4 Strict                   html4-strict        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
    HTML 4 Transitional             html4-trans         <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    HTML 4 Frameset                 html4-frame         <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
    MathML 1.01                     mathml1             <!DOCTYPE math SYSTEM "http://www.w3.org/Math/DTD/mathml1/mathml.dtd">
    MathML 2.0                      mathml2             <!DOCTYPE math PUBLIC "-//W3C//DTD MathML 2.0//EN" "http://www.w3.org/Math/DTD/mathml2/mathml2.dtd">
    SVG 1.0                         svg10               <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
    SVG 1.1 Full                    svg11               <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
    SVG 1.1 Basic                   svg11-basic         <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1 Basic//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11-basic.dtd">
    SVG 1.1 Tiny                    svg11-tiny          <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1 Tiny//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11-tiny.dtd">
    XHTML+MathML+SVG (XHTML host)   xhtml-math-svg-xh   <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN" "http://www.w3.org/2002/04/xhtml-math-svg/xhtml-math-svg.dtd">
    XHTML+MathML+SVG (SVG host)     xhtml-math-svg-sh   <!DOCTYPE svg:svg PUBLIC "-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN" "http://www.w3.org/2002/04/xhtml-math-svg/xhtml-math-svg.dtd">
    XHTML+RDFa 1.0                  xhtml-rdfa-1        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd">
    XHTML+RDFa 1.1                  xhtml-rdfa-2        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.1//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-2.dtd">
    =============================== =================== ==================================================================================================================================================
