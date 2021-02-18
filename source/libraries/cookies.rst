#######
쿠키
#######

HTTP 쿠키 (웹 쿠키, 브라우저 쿠키가) 서버가 사용자의 웹 브라우저에 보내는 데이터의 작은 조각이다.
브라우저는이를 저장하고 나중에 동일한 서버에 대한 요청과 함께 다시 보낼 수 있습니다.
일반적으로 두 개의 요청이 동일한 브라우저에서 왔는지 알려주는 데 사용됩니다 (예 : 사용자 로그인 유지). 상태 비 저장 HTTP 프로토콜에 대한 상태 저장 정보를 기억합니다.

쿠키는 주로 세 가지 목적으로 사용됩니다.

- **세션관리**: 로그인, 쇼핑 카트, 게임 점수 또는 서버가 기억해야하는 기타 사항
- **개인화**: 사용자 환경 설정, 테마 및 기타 설정
- **추적**: 사용자 행동 기록 및 분석

요청 및 응답을 통해 브라우저에서 쿠키를 효율적으로 사용하도록 돕기 위해 CodeIgniter는 ``CodeIgniter\HTTP\Cookie\Cookie`` 쿠키 상호 작용을 추상화하는 클래스를 제공합니다 .

.. contents::
    :local:
    :depth: 2

****************
쿠키 생성
****************

현재 새 ``Cookie`` 값 개체를 만드는 방법은 5가지가 있습니다 .

::

    use CodeIgniter\HTTP\Cookie\Cookie;
    use DateTime;

    // 생성자에 모든 인수 제공
    $cookie = new Cookie(
        'remember_token', // name
        'f699c7fd18a8e082d0228932f3acd40e1ef5ef92efcedda32842a211d62f0aa6', // value
        new DateTime('+2 hours'), // expires
        '__Secure-', // prefix
        '/', // path
        '', // domain
        true, // secure
        true, // httponly
        false, // raw
        Cookie::SAMESITE_LAX // samesite
    );

    // 정적 생성자 사용
    $cookie = Cookie::create(
        'remember_token',
        'f699c7fd18a8e082d0228932f3acd40e1ef5ef92efcedda32842a211d62f0aa6',
        [
            'expires'  => new DateTime('+2 hours'),
            'prefix'   => '__Secure-',
            'path'     => '/',
            'domain'   => '',
            'secure'   => true,
            'httponly' => true,
            'raw'      => false,
            'samesite' => Cookie::SAMESITE_LAX,
        ]
    );

    // Set-Cookie 헤더 문자열 제공
    $cookie = Cookie::fromHeaderString(
        'remember_token=f699c7fd18a8e082d0228932f3acd40e1ef5ef92efcedda32842a211d62f0aa6; Path=/; Secure; HttpOnly; SameSite=Lax',
        false, // raw
    );

    // 빌더 인터페이스 사용
    $cookie = (new Cookie('remember_token'))
        ->withValue('f699c7fd18a8e082d0228932f3acd40e1ef5ef92efcedda32842a211d62f0aa6')
        ->withPrefix('__Secure-')
        ->withExpires(new DateTime('+2 hours'))
        ->withPath('/')
        ->withDomain('')
        ->withSecure(true)
        ->withHttpOnly(true)
        ->withSameSite(Cookie::SAMESITE_LAX);

    // 암시적으로 `Cookie::create()`를 호출하는 전역 함수 `cookie` 사용
    $cookie = cookie('remember_token', 'f699c7fd18a8e082d0228932f3acd40e1ef5ef92efcedda32842a211d62f0aa6');

``Cookie`` 객체를 구성 할 때 ``name`` 속성 만 필요합니다. 다른 모든 것은 선택 사항입니다.
선택적 속성이 수정되지 않은 경우 해당 값은 ``Cookie`` 클래스에 저장된 기본값으로 채워집니다.
현재 클래스에 저장된 기본값을 재정의하려면 ``Config\App`` 인스턴스 또는 기본값 배열을 정적 ``Cookie::setDefaults()`` 메서드에 전달할 수 있습니다.

::

    use CodeIgniter\HTTP\Cookie\Cookie;
    use Config\App;

    // Cookie 클래스를 생성하기 전에 App 인스턴스를 전달합니다.
    Cookie::setDefaults(new App());
    $cookie = new Cookie('login_token');

    // 기본값 배열 전달
    $myDefaults = [
        'expires'  => 0,
        'samesite' => Cookie::SAMESITE_STRICT,
    ];
    Cookie::setDefaults($myDefaults);
    $cookie = Cookie::create('login_token');

``Config\App`` 인스턴스 또는 배열을에 전달하면 ``Cookie::setDefaults()`` 기본값을 효과적으로 덮어 쓰고 새 기본값이 전달 될 때까지 유지됩니다.
이 동작을 원하지 않고 제한된 시간 동안 만 기본값을 변경하려는 ``Cookie::setDefaults()`` 경우 이전 기본값 배열을 반환하는 return을 활용할 수 있습니다 .

::

    use CodeIgniter\HTTP\Cookie\Cookie;
    use Config\App;

    $oldDefaults = Cookie::setDefaults(new App());
    $cookie = Cookie::create('my_token', 'muffins');

    // 이전 기본값을 반환합니다.
    Cookie::setDefaults($oldDefaults);

*****************************
쿠키의 속성에 액세스
*****************************

인스턴스화되면 getter 메소드 중 하나를 사용하여 ``Cookie``의 속성에 쉽게 액세스 할 수 있습니다. 

::

    use CodeIgniter\HTTP\Cookie\Cookie;
    use DateTime;
    use DateTimeZone;

    $cookie = Cookie::create(
        'remember_token',
        'f699c7fd18a8e082d0228932f3acd40e1ef5ef92efcedda32842a211d62f0aa6',
        [
            'expires'  => new DateTime('2025-02-14 00:00:00', new DateTimeZone('UTC')),
            'prefix'   => '__Secure-',
            'path'     => '/',
            'domain'   => '',
            'secure'   => true,
            'httponly' => true,
            'raw'      => false,
            'samesite' => Cookie::SAMESITE_LAX,
        ]
    );

    $cookie->getName(); // 'remember_token'
    $cookie->getPrefix(); // '__Secure-'
    $cookie->getPrefixedName(); // '__Secure-remember_token'
    $cookie->getExpiresTimestamp(); // Unix timestamp
    $cookie->getExpiresString(); // 'Fri, 14-Feb-2025 00:00:00 GMT'
    $cookie->isExpired(); // false
    $cookie->getMaxAge(); // the difference from time() to expires
    $cookie->isRaw(); // false
    $cookie->isSecure(); // true
    $cookie->getPath(); // '/'
    $cookie->getDomain(); // ''
    $cookie->isHttpOnly(); // true
    $cookie->getSameSite(); // 'Lax'

    // 추가 getter
    $cookie->getId(); // '__Secure-remember_token;;/'

    // PHP 7.3+ 에서 `setcookie()`의 대체 서명을 사용할 때
    // `getOptions()` 메소드를 사용하여
    // $options 매개 변수를 쉽게 제공 할 수 있습니다.
    $cookie->getOptions();

*****************
불변 쿠키
*****************

새로운 ``Cookie`` 인스턴스는 HTTP 쿠키의 변경 불가능한 값 객체 표현입니다.
**불변**이므로 인스턴스의 속성을 수정해도 원래 인스턴스에는 영향을주지 않습니다.
수정은 항상 새 인스턴스를 반환합니다. 이 새 인스턴스를 사용하려면 유지해야합니다.

::

    use CodeIgniter\HTTP\Cookie\Cookie;

    $cookie = Cookie::create('login_token', 'admin');
    $cookie->getName(); // 'login_token'

    $cookie->withName('remember_token');
    $cookie->getName(); // 'login_token'

    $new = $cookie->withName('remember_token');
    $new->getName(); // 'remember_token'

********************************
쿠키의 속성 검증
********************************

HTTP 쿠키는 브라우저에서 허용하기 위해 따라야하는 몇 가지 사양에 의해 규제됩니다.
따라서 ``Cookie``의 특정 속성을 생성하거나 수정할 때 이러한 속성이 사양을 따르는 지 확인하기 위해 유효성을 검사합니다.

위반이보고되면 ``CookieException``이 발생합니다.

이름 속성 검증
=============================

쿠키 이름은 다음을 제외한 모든 US-ASCII 문자가 될 수 있습니다.

- 제어문자;
- 공백 또는 탭;
- 다음과 같은 구분 문자 ``( ) < > @ , ; : \ " / [ ] ? = { }``

``$raw`` 매개 변수를 ``true``로 설정하면이 유효성 검사가 엄격하게 수행됩니다. 이는 PHP의 ``setcookie`` 및 ``setrawcookie``가 잘못된 이름을 가진 쿠키를 거부하기 때문입니다. 또한 쿠키 이름은 빈 문자열을 사용할 수 없습니다.

접두사 속성 유효성 검사
===============================

``__Secure-`` 접두사를 사용하는 경우 ``$secure`` 플래그를 ``true``로 설정하여 쿠키를 설정해야합니다.
만약 ``__Host-`` 접두사를 사용하면 쿠키는 다음을 표시해야합니다.

- ``$secure`` 플래그를 ``true``로 설정
- ``$domain`` 을 empty로 설정
- ``$path`` 반드시 ``/``로 설정

SameSite 속성 유효성 검사
=================================

SameSite 속성은 3가지 값만 허용합니다.

- **Lax**: 쿠키는 일반적인 교차 사이트 하위 요청 (예 : 이미지 또는 프레임을 제 3 자 사이트로로드)에서 전송되지 않지만 사용자가 원본 사이트로 이동할 때 전송됩니다 (*즉,* 링크를 따라갈 때).
- **Strict**: 쿠키는 자사 컨텍스트로만 전송되며 타사 웹 사이트에서 시작된 요청과 함께 전송되지 않습니다.
- **None**: 쿠키는``first-party``` 및 ``cross-origin`` 요청에 대한 응답으로 *즉* 모든 컨텍스트에서 전송됩니다.

그러나 CodeIgniter를 사용하면 SameSite 속성을 빈 문자열로 설정할 수 있습니다. 빈 문자열이
단, ``Cookie`` 클래스에 저장된 기본 SameSite 설정이 사용됩니다. 기본 SameSite를 변경할 수 있습니다.
위에서 설명한대로 ``Cookie::setDefaults()``를 사용합니다.

최신 쿠키 사양이 변경되어 기본 SameSite를 제공하기 위해 최신 브라우저가 필요합니다.
아무것도 제공되지 않았다면. 이 기본값은 ``Lax``입니다. SameSite를 빈 문자열로 설정하고
기본 SameSite도 빈 문자열이며 쿠키에 ``Lax`` 값이 제공됩니다.

SameSite가 ``None``으로 설정된 경우 ``Secure``도 ``true``로 설정되어 있는지 확인해야합니다.

SameSite 속성을 작성할 때``Cookie`` 클래스는 대소 문자를 구분하지 않는 값을 허용합니다. 당신은 할 수 있습니다
또한 클래스의 상수를 활용하여 번거롭지 않게 만드십시오.

::

    use CodeIgniter\HTTP\Cookie\Cookie;

    Cookie::SAMESITE_LAX; // 'lax'
    Cookie::SAMESITE_STRICT; // 'strict'
    Cookie::SAMESITE_NONE; // 'none'

**********************
쿠키 저장소 사용
**********************

``CookieStore`` 클래스는 ``Cookie`` 개체의 변경 불가능한 컬렉션을 나타냅니다.
``CookieStore`` 인스턴스는 현재 ``Response`` 개체에서 액세스 할 수 있습니다.

::

    use Config\Services;

    $cookieStore = Services::response()->getCookieStore();

CodeIgniter는 ``CookieStore``의 새 인스턴스를 생성하는 3 가지 다른 방법을 제공합니다.

::

    use CodeIgniter\HTTP\Cookie\Cookie;
    use CodeIgniter\HTTP\Cookie\CookieStore;

    // 생성자에서 `Cookie` 객체의 배열 전달
    $store = new CookieStore([
        Cookie::create('login_token'),
        Cookie::create('remember_token'),
    ]);

    // `Set-Cookie` 헤더 문자열 배열 전달
    $store = CookieStore::fromCookieHeaders([
        'remember_token=me; Path=/; SameSite=Lax',
        'login_token=admin; Path=/; SameSite=Lax',
    ]);

    // 전역 '쿠키' 기능 사용
    $store = cookies([Cookie::create('login_token')], false);

    // 현재 `Response` 객체에 저장된 `CookieStore` 인스턴스 검색
    $store = cookies();

.. note:: 전역 ``cookies ()`` 함수를 사용할 때 전달 된 ``Cookie``배열 만 고려됩니다.
    두 번째 인수 ``$getGlobal``가 ``false``로 설정된 경우

스토어에서 쿠키 확인
=========================

``Cookie`` 객체가 ``CookieStore`` 인스턴스에 존재하는지 확인하려면 다음과 같은 여러 방법을 사용할 수 있습니다.

::

    use CodeIgniter\HTTP\Cookie\Cookie;
    use CodeIgniter\HTTP\Cookie\CookieStore;
    use Config\Services;

    // 쿠키가 현재 쿠키 컬렉션에 있는지 확인
    $store = new CookieStore([
        Cookie::create('login_token'),
        Cookie::create('remember_token'),
    ]);
    $store->has('login_token');

    // 쿠키가 현재 응답의 쿠키 컬렉션에 있는지 확인
    cookies()->has('login_token');
    Services::response()->hasCookie('remember_token');

    // 쿠키 도우미를 사용하여 v4.1.1 이하에서
    // 사용할 수없는 현재 응답 확인
    helper('cookie');
    has_cookie('login_token');

스토어에서 쿠키 받기
========================

쿠키 컬렉션에서 ``Cookie`` 인스턴스를 검색하는 것은 매우 쉽습니다.

::

    use CodeIgniter\HTTP\Cookie\Cookie;
    use CodeIgniter\HTTP\Cookie\CookieStore;
    use Config\Services;

    // 현재 쿠키 컬렉션에서 쿠키 가져오기
    $store = new CookieStore([
        Cookie::create('login_token'),
        Cookie::create('remember_token'),
    ]);
    $store->get('login_token');

    // 현재 응답의 쿠키 컬렉션에서 쿠키 가져오기
    cookies()->get('login_token');
    Services::response()->getCookie('remember_token');

    // 쿠키 헬퍼를 사용하여 응답의 쿠키 컬렉션에서 쿠키 가져오기
    helper('cookie');
    get_cookie('remember_token');

``CookieStore``에서 직접 ``Cookie`` 인스턴스를 가져올 때
잘못된 이름은 ``CookieException``을 발생시킵니다.

::

    // CookieException 발생
    $store->get('unknown_cookie');

현재``Response``의 쿠키 컬렉션에서 ``Cookie`` 인스턴스를 가져올 때,
잘못된 이름은 ``null``을 반환합니다.

::

    cookies()->get('unknown_cookie'); // null

``Response``에서 쿠키를 가져올 때 인수가 제공되지 않으면 상점에있는 모든 ``Cookie`` 개체가 표시됩니다.

::

    cookies()->get(); // Cookie 객체의 배열

    // 또는 표시 방법을 사용할 수 있습니다.
    cookies()->display();

    // 또는 이벤트에 따른 응답
    Services::response()->getCookies();

.. note:: 헬퍼 함수 ``get_cookie()``는 ``Response``가 아닌 현재 ``Request`` 객체에서 쿠키를 가져옵니다.
    이 함수는 쿠키가 설정되어 있으면 `$_COOKIE` 배열을 확인하고 즉시 가져옵니다.

스토어에서 쿠키 추가/제거
================================

앞서 언급했듯이``CookieStore`` 객체는 변경 불가능합니다.
작업하려면 수정 된 인스턴스를 저장해야합니다. 원래 인스턴스는 변경되지 않습니다.

::

    use CodeIgniter\HTTP\Cookie\Cookie;
    use CodeIgniter\HTTP\Cookie\CookieStore;
    use Config\Services;

    $store = new CookieStore([
        Cookie::create('login_token'),
        Cookie::create('remember_token'),
    ]);

    // 새로운 Cookie 인스턴스 추가
    $new = $store->put(Cookie::create('admin_token', 'yes'));

    // 쿠키 인스턴스 제거
    $new = $store->remove('login_token');

.. note:: 스토어에서 쿠키를 제거하면 브라우저에서 쿠키가 삭제되지 * 않습니다**.
    *브라우저에서* 쿠키를 삭제하려면 빈 값을 입력해야합니다.
    동일한 이름의 쿠키를 상점에 등록합니다

현재 ``Response`` 개체에 저장된 쿠키와 상호 작용할 때 쿠키 컬렉션의 불변성에 대해 걱정하지 않고 안전하게 쿠키를 추가하거나 삭제할 수 있습니다.
``Response`` 객체는 인스턴스를 수정 된 인스턴스로 대체합니다.

::

    use Config\Services;

    Services::response()->setCookie('admin_token', 'yes');
    Services::response()->deleteCookie('login_token');

    // cookie helper 사용
    helper('cookie');
    set_cookie('admin_token', 'yes');
    delete_cookie('login_token');

스토어의 쿠키 Dispatching
============================

대개는 수동으로 쿠키를 보내는 데 신경 쓸 필요가 없습니다. CodeIgniter가이 작업을 수행합니다.
그러나 수동으로 쿠키를 보내야하는 경우 ``dispatch`` 방법을 사용할 수 있습니다.
다른 헤더를 보낼 때와 마찬가지로 ``headers_sent()`` 값을 확인하여 헤더가 아직 전송되지 않았는지 확인해야합니다.

::

    use CodeIgniter\HTTP\Cookie\Cookie;
    use CodeIgniter\HTTP\Cookie\CookieStore;

    $store = new CookieStore([
        Cookie::create('login_token'),
        Cookie::create('remember_token'),
    ]);

    $store->dispatch(); // dispatch 후 컬렉션은 이제 비어 있습니다.

**********************
쿠키 개인화
**********************

쿠키 객체의 원활한 생성을 보장하기 위해 Sane 기본값은 이미 ``Cookie`` 클래스 내에 있습니다. 그러나 ``app/Config/App.php`` 파일의 ``Config\App`` 클래스에서 다음 설정을 변경하여 자신의 설정을 정의 할 수 있습니다.

==================== ===================================== ========= =====================================================
설정              옵션/타입                        기본겂   설명
==================== ===================================== ========= =====================================================
**$cookiePrefix**    ``string``                            ``''``    쿠키 이름 앞에 붙일 접두사입니다.
**$cookieDomain**    ``string``                            ``''``    쿠키의 도메인 속성입니다.
**$cookiePath**      ``string``                            ``/``     후행 슬래시가있는 쿠키의 경로 속성입니다.
**$cookieSecure**    ``true/false``                        ``false`` 보안 HTTPS를 통해 전송되는 경우
**$cookieHTTPOnly**  ``true/false``                        ``true``  JavaScript에 액세스 할 수없는 경우
**$cookieSameSite**  ``Lax|None|Strict|lax|none|strict''`` ``Lax``   SameSite 속성입니다.
**$cookieRaw**       ``true/false``                        ``false`` ``setrawcookie()``를 사용하여 발송되는 경우
**$cookieExpires**   ``DateTimeInterface|string|int``      ``0``     만료 타임 스탬프
==================== ===================================== ========= =====================================================

런타임에서 ``Cookie::setDefaults()`` 메서드를 사용하여 수동으로 새 기본값을 제공 할 수 있습니다.

***************
클래스 참조
***************

.. php:class:: CodeIgniter\\HTTP\\Cookie\\Cookie

    .. php:staticmethod:: setDefaults([$config = []])

        :param App|array $config: The configuration array or instance
        :rtype: array<string, mixed>
        :returns: The old defaults

        Set the default attributes to a Cookie instance by injecting the values from the ``App`` config or an array.

    .. php:staticmethod:: fromHeaderString(string $header[, bool $raw = false])

        :param string $header: The ``Set-Cookie`` header string
        :param bool $raw: Whether this cookie is not to be URL encoded and sent via ``setrawcookie()``
        :rtype: ``Cookie``
        :returns: ``Cookie`` instance
        :throws: ``CookieException``

        Create a new Cookie instance from a ``Set-Cookie`` header.

    .. php:staticmethod:: create(string $name[, string $value = ''[, array $options = []]])

        :param string $name: The cookie name
        :param string $value: The cookie value
        :param aray $options: The cookie options
        :rtype: ``Cookie``
        :returns: ``Cookie`` instance
        :throws: ``CookieException``

        Create Cookie objects on the fly.

    .. php:method:: __construct(string $name[, string $value = ''[, $expires = 0[, ?string $prefix = null[, ?string $path = null[, ?string $domain = null[, bool $secure = false[, bool $httpOnly = true[, bool $raw = false[, string $sameSite = self::SAMESITE_LAX]]]]]]]]])

        :param string $name:
        :param string $value:
        :param DateTimeInterface|string|int $expires:
        :param string|null $prefix:
        :param string|null $path:
        :param string|null $domain:
        :param bool $secure:
        :param bool $httpOnly:
        :param bool $raw:
        :param string $sameSite:
        :rtype: ``Cookie``
        :returns: ``Cookie`` instance
        :throws: ``CookieException``

        Construct a new Cookie instance.

    .. php:method:: getId()

        :rtype: string
        :returns: The ID used in indexing in the cookie collection.

    .. php:method:: isRaw(): bool
    .. php:method:: getPrefix(): string
    .. php:method:: getName(): string
    .. php:method:: getPrefixedName(): string
    .. php:method:: getValue(): string
    .. php:method:: getExpiresTimestamp(): int
    .. php:method:: getExpiresString(): string
    .. php:method:: isExpired(): bool
    .. php:method:: getMaxAge(): int
    .. php:method:: getDomain(): string
    .. php:method:: getPath(): string
    .. php:method:: isSecure(): bool
    .. php:method:: isHttpOnly(): bool
    .. php:method:: getSameSite(): string
    .. php:method:: getOptions(): array

    .. php:method:: withRaw([bool $raw = true])

        :param bool $raw:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie with URL encoding option updated.

    .. php:method:: withPrefix([string $prefix = ''])

        :param string $prefix:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie with new prefix.

    .. php:method:: withName(string $name)

        :param string $name:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie with new name.

    .. php:method:: withValue(string $value)

        :param string $value:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie with new value.

    .. php:method:: withExpiresAt($expires)

        :param DateTimeInterface|string|int $expires:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie with new cookie expires time.

    .. php:method:: withExpired()

        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie that will expire from the browser.

    .. php:method:: withNeverExpiring()

        :param string $name:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie that will virtually never expire.

    .. php:method:: withDomain(?string $domain)

        :param string|null $domain:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie with new domain.

    .. php:method:: withPath(?string $path)

        :param string|null $path:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie with new path.

    .. php:method:: withSecure([bool $secure = true])

        :param bool $secure:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie with new "Secure" attribute.

    .. php:method:: withHttpOnly([bool $httpOnly = true])

        :param bool $httpOnly:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie with new "HttpOnly" attribute.

    .. php:method:: withSameSite(string $sameSite)

        :param string $sameSite:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        Creates a new Cookie with new "SameSite" attribute.

    .. php:method:: toHeaderString()

        :rtype: string
        :returns: Returns the string representation that can be passed as a header string.

    .. php:method:: toArray()

        :rtype: array
        :returns: Returns the array representation of the Cookie instance.

.. php:class:: CodeIgniter\\HTTP\\Cookie\\CookieStore

    .. php:staticmethod:: fromCookieHeaders(array $headers[, bool $raw = false])

        :param array $header: Array of ``Set-Cookie`` headers
        :param bool $raw: Whether not to use URL encoding
        :rtype: ``CookieStore``
        :returns: ``CookieStore`` instance
        :throws: ``CookieException``

        Creates a CookieStore from an array of ``Set-Cookie`` headers.

    .. php:method:: __construct(array $cookies)

        :param array $cookies: Array of ``Cookie`` objects
        :rtype: ``CookieStore``
        :returns: ``CookieStore`` instance
        :throws: ``CookieException``

    .. php:method:: has(string $name[, string $prefix = ''[, ?string $value = null]]): bool

        :param string $name: Cookie name
        :param string $prefix: Cookie prefix
        :param string|null $value: Cookie value
        :rtype: bool
        :returns: Checks if a ``Cookie`` object identified by name and prefix is present in the collection.

    .. php:method:: get(string $name[, string $prefix = '']): Cookie

        :param string $name: Cookie name
        :param string $prefix: Cookie prefix
        :rtype: ``Cookie``
        :returns: Retrieves an instance of Cookie identified by a name and prefix.
        :throws: ``CookieException``

    .. php:method:: put(Cookie $cookie): CookieStore

        :param Cookie $cookie: A Cookie object
        :rtype: ``CookieStore``
        :returns: new ``CookieStore`` instance

        Store a new cookie and return a new collection. The original collection is left unchanged.

    .. php:method:: remove(string $name[, string $prefix = '']): CookieStore

        :param string $name: Cookie name
        :param string $prefix: Cookie prefix
        :rtype: ``CookieStore``
        :returns: new ``CookieStore`` instance

        Removes a cookie from a collection and returns an updated collection.
        The original collection is left unchanged.

    .. php:method:: dispatch(): void

        :rtype: void

        Dispatches all cookies in store.

    .. php:method:: display(): array

        :rtype: array
        :returns: Returns all cookie instances in store.

    .. php:method:: clear(): void

        :rtype: void

        Clears the cookie collection.
