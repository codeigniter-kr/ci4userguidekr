##############################
전역 함수와 상수
##############################

CodeIgniter는 전역적으로 정의되어 있으며, 언제든지 사용할 수 있는 몇 가지 함수와 상수를 제공합니다.
이를 사용하기 위해 추가 라이브러리나 헬퍼를 로드할 필요가 없습니다.

.. contents::
    :local:
    :depth: 2

================
전역 함수
================

서비스 Accessors
=================

.. php:function:: cache([$key])

    :param  string $key: 캐시에서 검색할 항목의 캐시 이름 (Optional)
    :returns: 캐시 오브젝트 또는 캐시에서 검색된 항목
    :rtype: mixed

    $key가 제공되지 않으면 캐시 엔진 인스턴스를 반환합니다.
    $key가 제공되면 현재 캐시에 저장된 $key의 값을 반환하거나 값이 없으면 null을 반환합니다.

    .. literalinclude:: common_functions/001.php

.. php:function:: cookie(string $name[, string $value = ''[, array $options = []]])

    :param string $name: Cookie 이름
    :param string $value: Cookie 값
    :param array $options: Cookie 옵션
    :rtype: ``Cookie``
    :returns: ``Cookie`` instance
    :throws: ``CookieException``

    새 쿠키 인스턴스를 만드는 간단한 함수입니다.

.. php:function:: cookies([array $cookies = [][, bool $getGlobal = true]])

    :param array $cookies: ``getGlobal``\ 이 ``false``\ 라면 ``CookieStore``\ 의 생성자에 전달됩니다.
    :param bool $getGlobal: ``false``\ 인 경우 ``CookieStore``\ 의 새 인스턴스를 만듭니다.
    :rtype: ``CookieStore``
    :returns: ``Response``\ 에 저장된 ``CookieStore``\ 인스턴스 또는 새로운 ``CookieStore`` 인스턴스.

    ``Response``\ 가 보유한 전역 ``CookieStore``\ 를 가져옵니다.

.. php:function:: env($key[, $default = null])

    :param string $key: 검색 할 환경 변수의 이름
    :param mixed  $default: 값을 찾지 못하면 반환할 기본값
    :returns: 환경 변수, 기본값 또는 null
    :rtype: mixed

    이전에 환경으로 설정된 값을 검색하거나 기본값을 찾을 수 없는 경우, 기본값을 반환하는 데 사용합니다.
    부울(bool) 값을 문자열 표현 대신 실제 부울로 형식화합니다.

    데이터베이스 설정, API 키 등과 같이 환경 자체에 특정한 값을 설정하기 위해 **.env** 파일과 함께 사용하면 특히 유용합니다.

.. php:function:: esc($data[, $context = 'html'[, $encoding]])

    :param   string|array   $data: 이스케이프할 정보(문자열)
    :param   string   $context: escaping context. 기본값은 'html'
    :param   string   $encoding: 문자열의 문자 인코딩.
    :returns: escaped data.
    :rtype: mixed

    XSS 공격을 방지하기 위해 웹 페이지에 포함할 데이터를 이스케이프(escape)합니다.
    데이터 필터링을 처리하기 위해 Laminas Escaper 라이브러리를 사용합니다.

    $data가 문자열(string)이면 단순히 이스케이프하여 반환합니다.
    $data가 배열이면 키/값 쌍중 '값'을 반복하여 이스케이프 처리합니다.

    지정 가능한 context 값: ``html``, ``js``, ``css``, ``url``, ``attr``, ``raw``

.. php:function:: helper($filename)

    :param   string|array  $filename: 로드할 헬퍼 파일의 이름 또는 이름의 배열.

    헬퍼 파일을 로드합니다.

    자세한 내용은 :doc:`helpers` 페이지를 참조하십시오.

.. php:function:: lang($line[, $args[, $locale]])

    :param string $line: 검색 할 텍스트
    :param array  $args: 자리표시자(placeholders)를 대체 할 데이터 배열
    :param string $locale: 기본 로케일(locale) 대신 사용할 다른 로케일

    문자열을 기반으로 로케일 특정 파일을 검색합니다.

    자세한 내용은 :doc:`Localization </outgoing/localization>` 페이지를 참조하십시오.

.. php:function:: model($name[, $getShared = true[, &$conn = null ]])

    :param string                   $name:
    :param boolean                  $getShared:
    :param ConnectionInterface|null $conn:
    :returns: Model instance
    :rtype: mixed

    모델 인스턴스를 얻는 간단한 방법

.. php:function:: old($key[, $default = null,[, $escape = 'html']])

    :param string $key: 확인할 이전 양식 데이터의 이름
    :param mixed  $default: $key가 존재하지 않으면 반환 할 기본값
    :param mixed  $escape: `이스케이프 <#esc>`_ 컨텍스트 또는 false
    :returns: 정의된 키의 값 또는 기본값
    :rtype: mixed

    제출된 양식(form)의 "이전 입력 데이터"에 액세스하는 간단한 방법을 제공합니다.

    .. literalinclude:: common_functions/002.php

.. note:: :doc:`폼(form) 헬퍼 </helpers/form_helper>`\ 를 사용하는 경우 이 기능이 내장되어 있습니다. 폼 헬퍼를 사용하지 않는 경우에만 이 기능을 사용하십시오.

.. php:function:: session([$key])

    :param string $key: 확인할 세션 항목의 이름
    :returns: $key가 없는 경우 Session 객체의 인스턴스, 세션에서 찾은 $key 값 또는 null
    :rtype: mixed

    세션 클래스에 액세스하고 저장된 값을 검색하는 편리한 방법을 제공합니다.
    자세한 내용은 :doc:`세션 </libraries/sessions>` 페이지를 참조하십시오.

.. php:function:: timer([$name])

    :param string $name: 벤치 마크 포인트의 이름.
    :returns: 타이머 인스턴스
    :rtype: CodeIgniter\Debug\Timer

    타이머(Timer) 클래스에 빠르게 액세스할 수있는 편리한 메소드입니다. 벤치 마크 지점의 이름을 매개 변수로 전달할 수 있습니다.
    이 시점부터 타이밍이 시작되거나 이 이름의 타이머가 이미 실행중인 경우 타이밍이 중지됩니다.

    .. literalinclude:: common_functions/003.php

.. php:function:: view($name [, $data[, $options ]])

    :param   string   $name: 로드할 파일 이름
    :param   array    $data: 뷰 내에서 사용할 수있는 키/값 쌍의 배열
    :param   array    $options: 렌더링 클래스로 전달 될 옵션 배열
    :returns: 뷰의 출력
    :rtype: string

    RendererInterface 호환 클래스에게 지정된 뷰를 렌더링하도록 지시합니다.
    컨트롤러, 라이브러리 및 라우팅 클로저에서 뷰를 사용할 수있는 편리한 방법을 제공합니다.

    옵션은 다음과 같고 ``$options`` 배열을 통하여 사용할 수 있습니다.

    - ``saveData`` 동일한 요청의 ``view()``\ 를 여러번 호출하여도 데이터를 유지합니다. 데이터를 유지하지 않으려면 ``false``\ 를 지정합니다.
    - ``cache`` view를 캐시할 시간(초)을 지정합니다. 자세한 내용은 :ref:`caching-views`\ 를 참조하세요.
    - ``debug`` ``false``\ 로 설정하여 :ref:`Debug Toolbar <the-debug-toolbar>`\ 에 대한 디버그 코드 추가를 비활성화합니다.

    ``$option`` 배열은 Twig 같은 타사(third-party) 라이브러리와 통합을 용이하게 하기 위해 제공됩니다.

    .. literalinclude:: common_functions/004.php

    자세한 내용은 :doc:`뷰 </outgoing/views>` 페이지를 참조하십시오.

.. php:function:: view_cell($library[, $params = null[, $ttl = 0[, $cacheName = null]]])

    :param string      $library:
    :param null        $params:
    :param integer     $ttl:
    :param string|null $cacheName:
    :returns: HTML chunks
    :rtype: string

    뷰 셀은 다른 클래스에서 관리하는 HTML 청크를 삽입하기 위해 뷰 내에서 사용됩니다.

    자세한 내용은 :doc:`뷰 셀 </outgoing/view_cells>` 페이지를 참조하십시오.

기타 기능
=======================

.. php:function:: app_timezone()

    :returns: 어플리케이션이 날짜를 표시하도록 설정된 시간대
    :rtype: string

    어플리케이션이 날짜를 표시하도록 설정된 시간대를 반환합니다.

.. php:function:: csp_script_nonce()

    :returns: 스크립트 태그에 대한 CSP nonce 속성입니다.
    :rtype: string

    스크립트 태그의 nonce 속성을 반환합니다. 예: ``nonce="Eskdikejidojdk978Ad8jf"``.
    See :ref:`content-security-policy`.

.. php:function:: csp_style_nonce()

    :returns: 스타일 태그에 대한 CSP nonce 속성입니다.
    :rtype: string

    스타일 태그의 nonce 속성을 반환합니다. 예: ``nonce="Eskdikejidojdk978Ad8jf"``.
    See :ref:`content-security-policy`.

.. php:function:: csrf_token()

    :returns: 현재 사용중인 CSRF 토큰의 이름
    :rtype: string

    현재 사용중인 CSRF 토큰의 이름을 반환합니다.

.. php:function:: csrf_header()

    :returns: 현재 사용중인 CSRF 토큰의 헤더 이름
    :rtype: string

    현재 사용중인 CSRF 토큰의 헤더 이름입니다.

.. php:function:: csrf_hash()

    :returns: CSRF 해시의 현재 값
    :rtype: string

    현재 사용중인 CSRF 해시 값을 반환합니다.

.. php:function:: csrf_field()

    :returns: CSRF 정보가 포함된 숨겨진 입력(hidden input) HTML 문자열
    :rtype: string

    CSRF 정보가 포함된 숨겨진 입력(hidden input) HTML 문자열을 반환합니다.
    
    ::

        <input type="hidden" name="{csrf_token}" value="{csrf_hash}">

.. php:function:: csrf_meta()

    :returns: CSRF 정보가 포함 된 메타 태그용 HTML 문자열
    :rtype: string

    CSRF 정보가 포함된 메타 태그를 반환합니다.
    
    ::

        <meta name="{csrf_header}" content="{csrf_hash}">

.. php:function:: force_https($duration = 31536000[, $request = null[, $response = null]])

    :param  int  $duration: 브라우저가 이 리소스에 대한 링크를 HTTPS로 변환해야 하는 시간(초)
    :param  RequestInterface $request: 요청(request) 개체의 인스턴스
    :param  ResponseInterface $response: 응답(response) 개체의 인스턴스

    페이지가 현재 HTTPS를 통해 액세스되고 있는지 확인합니다.
    HTTPS를 통해 액세스 되고 있다면 아무 일도 일어나지 않습니다. 
    그렇지 않은 경우 사용자는 HTTPS를 통해 현재 URI로 다시 리디렉션됩니다.
    HTTP Strict Transport Security 헤더를 설정하여 최신 브라우저가 HTTP 요청을 $duration에 대한 HTTPS 요청으로 자동 수정하도록 지시합니다.

.. php:function:: function_usable($function_name)

    :param string $function_name: 함수 확인
    :returns: 함수가 존재하여 호출해도 안전한 경우 true, 그렇지 않으면 false
    :rtype: bool

.. php:function:: is_really_writable ($file)

    :param string $file: 확인할 파일명
    :returns: 파일에 쓸 수 있으면 true, 그렇지 않으면 false
    :rtype: bool

.. php:function:: is_cli()

    :returns: true(커맨드 라인(command line)에서 스크립트를 실행중인 경우) 또는 false(아닌 경우)
    :rtype: bool

.. php:function:: log_message($level, $message[, $context])

    :param   string   $level: 심각도 수준
    :param   string   $message: 기록 될 메시지
    :param   array    $context: $message로 바꿔야할 태그와 값의 연관 배열
    :returns: true(성공적으로 기록 된 경우) 또는 false(기록하는 데 문제가있는 경우)
    :rtype: bool

    **app/Config/Logger.php**\ 에 정의된 로그 처리기를 사용하여 메시지를 기록합니다..

    레벨은 다음 값 중 하나일 수 있습니다: **emergency**, **alert**, **critical**, **error**, **warning**, **notice**, **info**, **debug**

    컨텍스트는 메시지 문자열에서 값을 대체하는데 사용될 수 있습니다. 자세한 내용은 :doc:`로깅 정보 <logging>` 페이지를 참조하십시오.

.. php:function:: redirect(string $route)

    :param  string  $route: 사용자를 리디렉션할 역방향 경로(reverse-route) 또는 명명된 경로입니다.
    :rtype: RedirectResponse

    .. important:: 이 함수를 사용할 때 ``RedirectResponse``\ 의 인스턴스는 :doc:`Controller <../incoming/controllers>`\ 나 :doc:`Controller Filter <../incoming/filters>` 메서드에서 반환되어야 합니다.
        반환하는 것을 잊은 경우 리디렉션이 발생하지 않습니다.

    쉽게 리디렉션을 만들수 있는 RedirectResponse 인스턴스를 반환합니다.
    
    .. literalinclude:: common_functions/005.php

    .. note:: ``redirect()->back()``\ 은 브라우저의 "back" 버튼과 다릅니다.
        세션을 사용할 수 있을 때 방문자는 "세션중 마지막으로 본 페이지"로 이동합니다.
        세션이 로드되지 않았거나 사용할 수 없는 경우 삭제된 HTTP_REFERER 버전이 사용됩니다.

    함수에 인수를 전달할 때 상대/전체 URI(relative/full URI)가 아닌 네임드/리버스 경로(named/reverse-routed)로 처리되며 ``redirect()->route()``\ 를 사용하는 것과 동일하게 처리됩니다.

    .. literalinclude:: common_functions/006.php

.. php:function:: remove_invisible_characters($str[, $urlEncoded = true])

    :param    string    $str: 입력 문자열
    :param    bool    $urlEncoded: URL 인코딩 문자도 제거할지 여부
    :returns: 안전한 문자열
    :rtype:    string

    이 함수는 "Java\\0script"와 같은 문자열에서 null 문자를 제거 합니다.

    .. literalinclude:: common_functions/007.php

.. php:function:: route_to($method [, ...$params])

    :param   string   $method: 명명된 라우트의 별명 또는 일치하는 컨트롤러/메소드의 이름입니다.
    :param   int|string   $params: 라우트와 일치시키기 위해 전달할 하나 이상의 매개변수입니다.

    .. note:: 이 함수를 사용하려면 **app/Config/routes.php**\ 에 컨트롤러/메서드로 정의된 경로가 필요합니다.

    명명된 라우트 별칭 또는 ``controller::method`` 조합을 기반으로 경로를 생성합니다. 매개변수를 적용합니다.

    .. literalinclude:: common_functions/009.php

    .. literalinclude:: common_functions/010.php

    .. note:: ``route_to()``\ 는 사이트의 전체 URI 경로가 아닌 경로를 반환합니다.
        **baseURL**\ 에 하위 폴더가 포함된 경우 반환 값은 연결할 URI와 동일하지 않습니다. 이런 경우에는 :php:func:`url_to()`\ 를 사용하세요.

.. php:function:: service($name[, ...$params])

    :param   string   $name: 로드 할 서비스의 이름
    :param   mixed    $params: 서비스 메소드에 전달할 하나 이상의 매개 변수
    :returns: 지정된 서비스 클래스의 인스턴스
    :rtype: mixed

    시스템에 정의 된 모든 :doc:`서비스 <../concepts/services>`\ 에 쉽게 액세스 할 수 있습니다.
    서비스 클래스의 공유 인스턴스가 반환되므로, 여러번 호출하더라도 인스턴스는 하나만 생성됩니다.

    .. literalinclude:: common_functions/008.php

.. php:function:: single_service($name[, ...$params])

    :param   string   $name: 로드 할 서비스의 이름
    :param   mixed    $params: 서비스 메소드에 전달할 하나 이상의 매개 변수
    :returns: An instance of the service class specified.
    :rtype: mixed

    이 함수에 대한 모든 호출이 클래스의 새 인스턴스를 반화한다는 점을 제외하고 위에서 설명한 **service()** 함수와 동일합니다. 
    **service**\ 는 매번 동일한 인스턴스를 리턴합니다.

.. php:function:: slash_item ( $item )

    :param string $item: Config item명
    :returns: Config 항목(Item)이 없는 경우 null
    :rtype:  string|null

    슬래시가 추가된 구성(Config) 파일 항목을 가져옵니다. (값이 있는 경우)

.. php:function:: stringify_attributes( $attributes [, $js] )

    :param   mixed    $attributes: 문자열, 키/값 쌍의 배열, 객체
    :param   boolean  $js: true (값에 따옴표가 필요하지 않은 경우, Javascript-style)
    :returns: 쉼표로 구분된 속성의 키/값 쌍을 포함하는 문자열
    :rtype: string

    문자열, 배열 또는 속성 개체를 문자열로 변환하는 데 사용되는 도우미 함수입니다.

================
전역 상수
================

다음 상수는 어플리케이션내 어디에서나 항상 사용할 수 있습니다.

코어(Core) 상수
==================

.. php:const:: APPPATH

    **app** 디렉토리 경로

.. php:const:: ROOTPATH

    프로젝트 루트 디렉토리의 경로. 바로 위 ``APPPATH``

.. php:const:: SYSTEMPATH

    **system** 디렉토리 경로

.. php:const:: FCPATH

    프론트 컨트롤러의 디렉토리 경로

.. php:const:: WRITEPATH

    **writable** 디렉토리 경로

시간 상수
==============

.. php:const:: SECOND

    1 초

.. php:const:: MINUTE

    60 초

.. php:const:: HOUR

    3600 초

.. php:const:: DAY

    86400 초

.. php:const:: WEEK

    604800 초

.. php:const:: MONTH

    2592000 초

.. php:const:: YEAR

    31536000 초

.. php:const:: DECADE

    315360000 초
