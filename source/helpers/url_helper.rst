##########
URL 헬퍼
##########

URL 헬퍼에는 URL 작업을 지원하는 기능이 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

헬퍼 로드
===================

이 헬퍼는 프레임워크에 의해 자동으로 로드됩니다.

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: site_url([$uri = ''[, $protocol = null[, $altConfig = null]]])

    :param    mixed            $uri: URI 문자열 또는 URI 세그먼트 배열
    :param    string           $protocol: 프로토콜, 'http' or 'https'
    :param    \\Config\\App    $altConfig: 대체 구성
    :returns: Site URL
    :rtype:   string

    구성 파일에 지정된 사이트 URL을 반환합니다.
    index.php 파일 (또는 설정 파일에서 사이트 **indexPage**\ 로 설정 한 것)이 함수에 전달하는 URI 세그먼트와 마찬가지로 URL에 추가됩니다.

    URL이 변경될 때 페이지의 이식성이 향상되도록 로컬 URL을 생성해야 할 때 이 기능을 사용하는 것이 좋습니다.

    세그먼트는 선택적으로 문자열 또는 배열로 함수에 전달됩니다.

    .. literalinclude:: url_helper/001.php

    위의 예는 다음과 같은 것을 반환합니다.
    
    ::

        http://example.com/index.php/news/local/123

    다음은 배열로 전달된 세그먼트의 예입니다.
    
    .. literalinclude:: url_helper/002.php

    다른 구성 환경 설정을 포함하는 다른 사이트에 대한 URL을 생성하는 경우 대체 구성이 유용합니다.
    이 함수는 프레임워크 자체 단위 테스트에 사용됩니다.

.. php:function:: base_url([$uri = ''[, $protocol = null]])

    :param    mixed     $uri: URI 문자열 또는 URI 세그먼트 배열
    :param    string    $protocol: 프로토콜, 'http' or 'https'
    :returns: Base URL
    :rtype:   string

    구성 파일에 지정된 사이트 base URL을 반환합니다.
    
    .. literalinclude:: url_helper/003.php

    이 함수는 *indexPage*\ 를 추가하지 않고 :php:func:`site_url()`\ 과 같은 것을 반환합니다.

    또한 :php:func:`site_url()`\ 과 같이 세그먼트를 문자열 또는 배열로 제공할 수 있습니다.
    
    .. literalinclude:: url_helper/004.php

    위의 예는 다음과 같은 것을 반환합니다.

    ::
        http://example.com/blog/post/123

    이것은 :php:func:`site_url()`\ 과 달리 이미지나 스타일 시트와 같은 파일에 문자열을 제공할 때 유용합니다.
    
    .. literalinclude:: url_helper/005.php

    위의 예는 다음과 같은 것을 반환합니다.

    ::

        http://example.com/images/icons/edit.png

.. php:function:: current_url([$returnObject = false[, $request = null]])

    :param    boolean    $returnObject: 문자열 대신 URI 인스턴스를 반환하려면 True.
    :param	IncomingRequest|null	$request: 경로 탐지에 사용할 대체 요청이며 테스트에 유용합니다.
    :returns: 현재 URL
    :rtype:   string|URI

    현재 보고있는 페이지의 전체 URL(세그먼트 포함)을 반환합니다.
    그러나 보안상의 이유로 ``Config\App`` 설정을 기반으로 생성되며 브라우저 URL과 일치하지 않습니다.

    .. note:: 이 함수를 호출하는 것은 ``site_url(uri_string());``\ 을 수행하는 것과 같습니다

        .. literalinclude:: url_helper/006.php

.. php:function:: previous_url([$returnObject = false])

    :param boolean $returnObject: 문자열 대신 URI 인스턴스를 반환하려면 True.
    :returns: 사용자가 이전에 사용했던 URL
    :rtype: string|URI

    사용자가 이전에 방문한 페이지의 전체 URL (세그먼트 포함)을 반환합니다.

    .. note:: HTTP_REFERER 시스템 변수를 맹목적으로 신뢰하는 보안 문제로 인해 CodeIgniter는 사용 가능한 경우 이전에 방문한 페이지를 세션에 저장합니다.
        이를 통해 우리는 항상 알려진 신뢰할 수 있는 출처를 사용합니다.
        세션이 로드되지 않았거나 사용할 수 없는 경우 안전한 HTTP_REFERER 버전이 사용됩니다.

.. php:function:: uri_string([$relative = false])

    :param	boolean	$relative: baseURL에 대한 상대적인 문자열를 원한다면 `true`
    :returns: URI 문자열
    :rtype:   string

    현재 URL의 경로 부분을 반환합니다.
        
    ::

        http://some-site.com/blog/comments/123

    함수 실행 결과
    
    ::

        /blog/comments/123

    또는 상대 파라미터(선택 사항)를 사용
    
    ::
    
        app.baseURL = http://some-site.com/subfolder/

        uri_string(); // "/subfolder/blog/comments/123"
        uri_string(true); // "blog/comments/123"

.. php:function:: index_page([$altConfig = null])

    :param    \Config\App    $altConfig: 사용할 대체 구성
    :returns: 'index_page' 값
    :rtype:   mixed

    구성 파일에 지정된 사이트 **indexPage**\ 를 반환합니다.

    .. literalinclude:: url_helper/007.php

    :php:func:`site_url()`\ 과 마찬가지로 대체 구성을 지정할 수 있습니다.
    다른 구성 환경 설정을 포함하는 다른 사이트에 대한 URL을 생성하는 경우 대체 구성이 유용합니다.
    이 함수는 프레임워크 자체 단위 테스트에 사용됩니다.

.. php:function:: anchor([$uri = ''[, $title = ''[, $attributes = ''[, $altConfig = null]]]])

    :param    mixed          $uri: URI 문자열 또는 URI 세그먼트 배열
    :param    string         $title: Anchor 제목
    :param    mixed          $attributes: HTML 속성
    :param    \Config\App    $altConfig: 사용할 대체 구성
    :returns: HTML hyperlink (anchor tag)
    :rtype:   string

    로컬 사이트 URL을 기반으로 표준 HTML 앵커 링크를 만듭니다.

    첫 번째 매개 변수는 URL에 추가할 세그먼트입니다.
    위의 :php:func:`site_url()` 함수와 마찬가지로 세그먼트는 문자열 또는 배열일 수 있습니다.

    .. note:: 어플리케이션 내부에 링크를 작성하는 경우 base URL (`http://...`)을 포함하지 마십시오.
        base URL은 구성 파일에 지정된 정보에서 자동으로 추가됩니다.
        URL에 추가하려는 URI 세그먼트만 포함하십시오.

    두 번째 세그먼트는 링크를 말하려는 텍스트입니다.
    비워두면 URL이 사용됩니다.

    세 번째 매개 변수에는 링크에 추가하려는 속성 목록이 포함될 수 있습니다.
    속성은 간단한 문자열 또는 연관 배열일 수 있습니다.

    .. literalinclude:: url_helper/008.php

    :php:func:`site_url()`\ 과 마찬가지로 대체 구성을 지정할 수 있습니다.
    다른 구성 환경 설정을 포함하는 다른 사이트에 대한 URL을 생성하는 경우 대체 구성이 유용합니다.
    이 함수는 프레임워크 자체 단위 테스트에 사용됩니다.

    .. note:: 앵커 기능으로 전달된 속성은 XSS 공격으로부터 보호하기 위해 자동으로 이스케이프됩니다.

.. php:function:: anchor_popup([$uri = ''[, $title = ''[, $attributes = false[, $altConfig = null]]]])

    :param    string         $uri: URI 문자열
    :param    string         $title: Anchor 제목
    :param    mixed          $attributes: HTML 속성
    :param    \Config\App    $altConfig: 사용할 대체 구성
    :returns: Pop-up hyperlink
    :rtype:   string

    :php:func:`anchor()` 함수와 거의 동일합니다. 단, 새 창에서 URL을 엽니다.
    세 번째 매개 변수에서 JavaScript 창 속성을 지정하여 창을 여는 방법을 제어할 수 있습니다.
    세 번째 매개 변수가 설정되어 있지 않으면 브라우저 설정으로 새 창을 엽니다.

    .. literalinclude:: url_helper/009.php

    .. note:: 위의 속성은 기능 기본값이므로 필요한 것과 다른 속성만 설정하면 됩니다.
        함수가 모든 기본값을 사용하도록 하려면 세 번째 매개 변수에 빈 배열을 전달하십시오.
        
        .. literalinclude:: url_helper/010.php

    .. note:: **window_name**\ 은 실제로 속성이 아니라 자바 스크립트 `window.open() <https://www.w3schools.com/jsref/met_win_open.asp>`_ 메소드에 대한 인수입니다. 이름 또는 창 타겟.

    .. note:: 위에 나열된 이외의 속성은 앵커 태그에 HTML 속성으로 구문 분석됩니다.

    :php:func:`site_url()`\ 과 마찬가지로 대체 구성을 지정할 수 있습니다.
    다른 구성 환경 설정을 포함하는 다른 사이트에 대한 URL을 생성하는 경우 대체 구성이 유용합니다.
    이 함수는 프레임워크 자체 단위 테스트에 사용됩니다.

    .. note:: anchor_popup 함수에 전달된 속성은 자동으로 이스케이프되어 XSS 공격으로 부터 보호됩니다.

.. php:function:: mailto($email[, $title = ''[, $attributes = '']])

    :param    string    $email: E-mail 주소
    :param    string    $title: Anchor 제목
    :param    mixed     $attributes: HTML 속성
    :returns: "mail to" hyperlink
    :rtype:   string

    표준 HTML E-mail 링크를 만듭니다.
    
    .. literalinclude:: url_helper/011.php

    위의 :php:func:`anchor()`\ 탭과 마찬가지로 세 번째 매개 변수를 사용하여 속성을 설정할 수 있습니다.
    
    .. literalinclude:: url_helper/012.php

    .. note:: mailto 함수로 전달된 속성은 XSS 공격으로부터 보호하기 위해 자동으로 이스케이프됩니다.

.. php:function:: safe_mailto($email[, $title = ''[, $attributes = '']])

    :param    string    $email: E-mail 주소
    :param    string    $title: Anchor 제목
    :param    mixed     $attributes: HTML 속성
    :returns: spam-safe "mail to" hyperlink
    :rtype:   string

    :php:func:`mailto()` 함수와 동일하지만, 이메일 주소가 스팸봇에 의해 수집되는 것을 방지하기 위해 JavaScript로 작성된 서수를 사용하여 *mailto* 태그의 난독화된 버전을 작성합니다.

.. php:function:: auto_link($str[, $type = 'both'[, $popup = false]])

    :param    string    $str: 입력 문자열
    :param    string    $type: Link type ('email', 'url' or 'both')
    :param    bool      $popup: 팝업 링크 생성 여부
    :returns: Linkified 문자열
    :rtype:   string

    문자열에 포함된 URL 및 전자 메일 주소를 링크로 자동 전환합니다.
    
    .. literalinclude:: url_helper/013.php

    두 번째 매개 변수는 URL과 전자 메일 모두 또는 하나만 변환할 지 결정합니다.
    매개 변수가 지정되지 않은 경우 기본 작동은 둘 다입니다.
    이메일 링크는 :php:func:`safe_mailto()`\ 로 인코딩됩니다.

    URL만 변환
    
    .. literalinclude:: url_helper/014.php

    이메일 주소만 변환

    .. literalinclude:: url_helper/015.php

    세 번째 파라미터는 링크가 새 창에 표시되는지 여부를 결정한다.
    값은 true 또는 false(부울).

    .. literalinclude:: url_helper/016.php

    .. note:: 인식되는 URL은 'www' 또는 '://'로 시작하는 URL입니다.

.. php:function:: url_title($str[, $separator = '-'[, $lowercase = false]])

    :param    string    $str: 입력 문자열
    :param    string    $separator: 단어 구분 기호
    :param    bool      $lowercase: 출력 문자열을 소문자로 변환할지 여부
    :returns: URL-formatted 문자열
    :rtype:   string

    문자열을 입력으로 받아서 사람에게 친숙한 URL 문자열을 만듭니다.
    URL에 항목 제목을 사용하려는 블로그가 있는 경우 유용합니다.
    
    .. literalinclude:: url_helper/017.php

    두 번째 매개 변수는 단어 분리 문자를 결정합니다.
    기본적으로 대시가 사용됩니다.
    기본 옵션은 **-** (대시) 또는 **_** (밑줄)입니다.

    .. literalinclude:: url_helper/018.php

    세 번째 파라미터는 소문자 강제 변환 여부를 결정합니다.
    기본적으로 변환하지 않습니다. 옵션은 부울 true/false.

    .. literalinclude:: url_helper/019.php

php:function:: mb_url_title($str[, $separator = '-'[, $lowercase = false]])

    :param  string  $str: 입력 문자열
    :param  string  $separator: 단어 구분 기호 (일반적으로 '-' or '_')
    :param  bool    $lowercase: 출력 문자열을 소문자로 변환할지 여부를 지정
    :returns: URL-formatted 문자열
    :rtype: string

    이 함수는 :php:func:`url_title()`\ 과 동일하게 작동하지만 모든 강조된 문자를 자동으로 변환합니다.


.. php:function:: prep_url([$str = ''[, $secure = false]])

    :param    string   $str: URL 문자열
    :param    boolean  $secure: true for https://
    :returns: 프로토콜 접두사 URL 문자열
    :rtype:   string

    이 함수는 프로토콜 접두사가 URL에서 누락된 경우 *http://* 또는 *https://*\ 를 추가합니다.

    URL 문자열을 이렇게 함수에 전달합니다.
    
    .. literalinclude:: url_helper/020.php


.. php:function:: url_to($controller[, ...$args])

    :param  string  $controller: 명명된 경로 또는 Controller::method
    :param  mixed   ...$args: 라우트에 전달할 하나 이상의 매개변수
    :returns: 절대 URL
    :rtype: string

    .. note:: 이 함수를 사용하려면 **app/Config/routes.php**\ 에 controller/method로 정의된 경로가 필요합니다.

    앱의 컨트롤러 메소드에 대한 절대 URL을 빌드합니다.
    
    .. literalinclude:: url_helper/021.php

    라우트에 인수를 추가할 수 있습니다.
    
    .. literalinclude:: url_helper/022.php

    뷰에 링크를 넣은 후 경로를 변경할 때 유용합니다.
    
    자세한 내용은 :ref:`reverse-routing` 또는 :ref:`using-named-routes`\ 를 참조하세요.

.. php:function:: url_is($path)

    :param string $path: 현재 URI 경로인지 확인할 경로
    :rtype: boolean

    현재 URL의 경로를 지정된 경로와 비교하여 일치하는지 확인합니다.
    
    .. literalinclude:: url_helper/023.php

    위의 예는 ``http://example.com/admin``\ 과 일치합니다. 
    "*" 와일드카드를 사용하여 URL의 다른 문자와 일치시킬 수 있습니다.
    
    .. literalinclude:: url_helper/024.php

    이는 다음 중 하나와 일치합니다.

    - /admin
    - /admin/
    - /admin/users
    - /admin/users/schools/classmates/...