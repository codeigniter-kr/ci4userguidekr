#######
Cookies
#######

**HTTP 쿠키** (웹 쿠키, 브라우저 쿠키)는 서버가 사용자의 웹 브라우저로 보내는 작은 데이터 조각입니다.
브라우저는 이 파일을 저장하고 나중에 요청하여 동일한 서버로 다시 보낼 수 있습니다.
일반적으로 두 개의 요청이 동일한 브라우저에서 발생했는지 여부(예: 사용자 로그인 유지)를 확인하는 데 사용됩니다.
상태 비저장 HTTP 프로토콜에 대한 상태 정보를 기억합니다.

쿠키는 주로 세 가지 목적으로 사용됩니다:

- **Session management**: 로그인, 쇼핑 카트, 게임 점수 또는 서버가 기억해야 하는 기타 사항
- **Personalization**: 사용자 선호도, 주제가 다른 설정
- **Tracking**: 사용자 동작을 기록하고 분석

To help you efficiently use cookies across browsers with your request and response, CodeIgniter provides the ``CodeIgniter\Cookie\Cookie`` class to abstract the cookie interaction.
요청과 응답으로 브라우저에서 쿠키를 효율적으로 사용할 수 있도록 CodeIgniter는 쿠키 상호 작용을 추상화하는 ``CodeIgniter\Cookie\Cookie`` 클래스를 제공합니다.

.. contents::
    :local:
    :depth: 2

****************
쿠키 생성
****************

새로운 ``Cookie`` 개체를 만드는 네 가지 방법을 제공합니다.

.. literalinclude:: cookies/001.php

``Cookie`` 개체를 구성할 때는 ``name`` 속성만 입력하면 됩니다. 다른 모든 항목은 선택 사항입니다.
선택적 속성을 수정하지 않으면 해당 값은 ``Cookie`` 클래스에 저장된 기본값으로 채워집니다.
현재 클래스에 저장된 기본값을 재정의하려면 ``Config\Cookie`` 인스턴스나 정적 메소드 ``Cookie::setDefaults()``\ 에  기본값 배열을 전달합니다.

.. literalinclude:: cookies/002.php

``Config\Cookie`` 인스턴스 또는 ``Cookie::setDefaults()``\ 로 배열을 전달하면 기본값을 덮어쓰고 새 기본값이 전달될 때까지 유지됩니다.
이 동작을 원하지 않고 제한된 시간 동안만 기본값을 변경하려는 경우 이전 기본값 배열을 반환하는 ``Cookie::setDefaults()`` 반환을 이용할 수 있습니다.

.. literalinclude:: cookies/003.php

*****************************
쿠키의 속성에 액세스
*****************************

일단 인스턴스화되면, 당신은 ``Cookie``\ 의 속성 중 하나를 사용하여 쉽게 접근할 수 있습니다.

.. literalinclude:: cookies/004.php

*****************
불변 쿠키
*****************

새 ``Cookie`` 인스턴스는 HTTP 쿠키의 불변 값 객체 표현입니다.
불변성이므로 인스턴스의 속성을 수정해도 원래 인스턴스는 영향을 받지 않습니다.
수정 내용은 **항상** 새 인스턴스를 반환합니다.
이 새 인스턴스를 사용하려면 해당 인스턴스를 유지해야 합니다.

.. literalinclude:: cookies/005.php

***************
쿠키 속성 검증
***************

HTTP 쿠키는 브라우저에서 허용되기 위해 따라야 하는 몇 가지 사양에 의해 규제됩니다.
따라서, ``Cookie``\ 의 특정 속성을 만들거나 수정할 때, 이러한 특성이 규격에 부합하는지 확인하기 위해 유효성을 검사합니다.

위반이 발견되면 ``CookieException``\ 가 발생합니다.

이름 속성 검증
===============

쿠키 이름은 다음을 제외한 모든 US-ASCII 문자일 수 있습니다:

- control characters;
- spaces or tabs;
- separator characters, such as ``( ) < > @ , ; : \ " / [ ] ? = { }``

``$raw`` 매개변수를 ``true``\ 로 설정하면 이 검증은 엄격하게 수행됩니다.
이는 PHP의 ``setcookie``\ 와 ``setrawcookie``\ 가 잘못된 이름의 쿠키를 거부하기 때문입니다.
또한 쿠키 이름은 빈 문자열일 수 없습니다.

접두사 속성 유효성 검사
========================

``__Secure-`` 접두사를 사용할 경우 ``$secure`` 플래그가 ``true``\ 로 설정된 상태로 쿠키를 설정해야 합니다.
``__Host-`` 접두사를 사용하는 경우 쿠키에 다음을 표시해야 합니다.

- ``$secure`` flag set to ``true``
- ``$domain`` is empty
- ``$path`` must be ``/``

SameSite 속성 검증
=================================

SameSite 속성은 세 개의 값만 허용합니다:

- **Lax**: 쿠키는 일반적인 교차 사이트 하위 요청(예: 이미지 또는 프레임을 타사 사이트에 로드하는 경우)에는 전송되지 않지만, 사용자가 원본 사이트(*즉, 링크를 따라갈 때*)로 이동할 때는 전송됩니다.
- **Strict**: 쿠키는 제1자 컨텍스트로만 전송되며, 타사 웹 사이트에서 시작한 요청과 함께 전송되지 않습니다.
- **None**: 쿠키는 모든 컨텍스트(예: *자사 및 교차 출처 요청에 대한 응답*) 대해 전송됩니다.

그러나 CodeIgniter를 사용하면 SameSite 속성을 빈 문자열로 설정할 수 있습니다.
빈 문자열이 제공되면 ``Cookie`` 클래스에 저장된 기본 SameSite 설정이 사용됩니다.
위에서 설명한 대로 ``Cookie::setDefaults()``\ 를 사용하여 기본 SameSite를 변경할 수 있습니다.

최신 쿠키 사양이 변경되어 최신 브라우저가 아무것도 제공되지 않은 경우 기본 SameSite를 제공해야 합니다.
이 기본값은 ``Lax``\ 입니다.
SameSite를 빈 문자열로 설정하고 기본 SameSite도 빈 문자열인 경우 쿠키에 ``Lax`` 값이 지정됩니다.

만일 SameSite가 ``None``\ 으로 설정되었다면 ``Secure``\ 도 ``true``\ 로 설정되었는지 확인해야 합니다.

SameSite 속성을 쓸 때 ``Cookie`` 클래스는 모든 값을 대소문자를 구분하지 않고 받아들입니다.
번거롭지 않게 클래스의 상수를 활용하는 방법도 있습니다.

.. literalinclude:: cookies/006.php

*************************
쿠키 저장소(Store) 사용
*************************

``CookieStore`` 클래스는 ``Cookie`` 개체의 불변의 컬렉션을 나타냅니다.
``CookieStore`` 인스턴스는 현재 `Response`` 개체에서 액세스할 수 있습니다.

.. literalinclude:: cookies/007.php

CodeIgniter는 새로운 ``CookieStore`` 인스턴스를 만드는 세 가지 다른 방법을 제공합니다.

.. literalinclude:: cookies/008.php

.. note:: 전역 ``cookies()`` 함수를 사용할 때, 전달된 ``Cookie`` 배열은 두 번째 인수인 ``$getGlobal`\ 이 ``false``\ 로 설정된 경우에만 고려됩니다.

저장소에서 쿠키 확인
=========================

``CookieStore`` 인스턴스에 ``Cookie`` 개체가 있는지 확인하려면 여러 가지 방법을 사용할 수 있습니다.

.. literalinclude:: cookies/009.php

저장소에서 쿠키 받기
========================

쿠키 컬렉션에서 ``Cookie`` 인스턴스를 검색하는 것은 매우 쉽습니다.

.. literalinclude:: cookies/010.php

``CookieStore``\ 에서 잘못된 이름으로 직접 ``Cookie`` 인스턴스를 받으면 ``CookieException`` 예외를 발생시킵니다.

.. literalinclude:: cookies/011.php

``Response``\ 의 쿠키 컬렉션에서 잘못된 이름으로 ``Cookie`` 인스턴스를 가져오면 ``null``\ 로 반환됩니다.

.. literalinclude:: cookies/012.php

``Response``\ 에서 쿠키를 가져올 때 인수가 제공되지 않으면 저장 중인 ``Cookie`` 개체가 모두 표시됩니다.

.. literalinclude:: cookies/013.php

.. note:: ``get_cookie()`` 헬퍼 함수는 ``Response``\ 가 아닌 ``Request`` 개체에서 쿠키를 가져옵니다.
    이 함수는 쿠키가 설정되어 있으면 `$_COOKIE` 배열을 확인한 후 바로 가져옵니다.

저장소에 쿠키 추가/제거
================================

앞서 언급했듯이, ``CookieStore`` 객체는 변경 불가능합니다.
수정 작업을 하려면 수정된 인스턴스를 저장해야 합니다.
원래 인스턴스는 변경되지 않은 상태로 유지됩니다.

.. literalinclude:: cookies/014.php

.. note:: 스토어에서 쿠키를 제거하면 브라우저에서 쿠키가 삭제되지 **않습니다**.
        *브라우저에서 쿠키를 삭제*\ 하려면 동일한 이름의 빈 값 쿠키를 저장소에 넣어야합니다.

``Response`` 개체에 저장 중인 쿠키와 상호 작용할 때 쿠키 컬렉션의 불변성을 걱정하지 않고 안전하게 쿠키를 추가하거나 삭제할 수 있습니다.
``Response`` 개체는 인스턴스를 수정된 인스턴스로 바꿉니다.

.. literalinclude:: cookies/015.php

스토어 내 쿠키 발송
============================

쿠키를 수동으로 보낼 때 CodeIgniter가 이 작업을 수행하므로 신경 쓸 필요가 없습니다.
그러나 쿠키를 수동으로 보내야 하는 경우에는 ``dispatch`` 메소드를 사용해야 합니다.
다른 헤더를 보낼 때와 마찬가지로 ``headers_sent()`` 값을 확인하여 헤더를 아직 전송되지 않았는지 확인해야 합니다.

.. literalinclude:: cookies/016.php

**********************
쿠키 개인화
**********************

쿠키 개체의 원활한 생성을 위해 ``Cookie`` 클래스 내에 올바른 기본값이 이미 있습니다.
그러나 ``app/Config/Cookie.php`` 파일의 ``Config\Cookie`` 클래스에서 다음 설정을 변경하여 사용자 자신의 설정을 정의할 수 있습니다.

==================== ===================================== ========= =====================================================
Setting              Options/ Types                        Default   Description
==================== ===================================== ========= =====================================================
**$prefix**          ``string``                            ``''``    쿠키 이름 앞에 붙일 접두사.
**$expires**         ``DateTimeInterface|string|int``      ``0``     만료 타임스탬프.
**$path**            ``string``                            ``/``     쿠키의 경로 속성.
**$domain**          ``string``                            ``''``    쿠키의 도메인 속성, 슬래시를 사용합니다.
**$secure**          ``true/false``                        ``false`` 보안 HTTPS를 통해 전송하는지 여부.
**$httponly**        ``true/false``                        ``true``  JavaScript 액세스할 수 있는지 여부.
**$samesite**        ``Lax|None|Strict|lax|none|strict''`` ``Lax``   SameSite 속성.
**$raw**             ``true/false``                        ``false`` ``setrawcookie()``\ 를 사용하여 발송하는 경우.
==================== ===================================== ========= =====================================================

런타임에 ``Cookie::setDefaults()`` 메소드를 사용하여 수동으로 새 기본값을 제공할 수 있습니다.

***************
Class Reference
***************

.. php:namespace:: CodeIgniter\HTTP\Cookie

.. php:class:: Cookie

    .. php:staticmethod:: setDefaults([$config = []])

        :param \Config\Cookie|array $config: 구성 배열 또는 인스턴스
        :rtype: array<string, mixed>
        :returns: 이전 기본값

        ``\Config\Cookie`` 구성 또는 배열의 값을 주입하여 기본 속성을 Cookie 인스턴스에 설정합니다.

    .. php:staticmethod:: fromHeaderString(string $header[, bool $raw = false])

        :param string $header: ``Set-Cookie`` 헤더 문자열
        :param bool $raw: 쿠키가 URL로 인코딩되어 ``setrawcookie()``\ 를 통해 전송되지 않는지 여부
        :rtype: ``Cookie``
        :returns: ``Cookie`` instance
        :throws: ``CookieException``

        ``Set-Cookie`` 헤더에 새 쿠키 인스턴스를 만듭니다.

    .. php:method:: __construct(string $name[, string $value = ''[, array $options = []]])

        :param string $name: 쿠키 이름
        :param string $value: 쿠키 값
        :param array $options: 쿠키 옵션
        :rtype: ``Cookie``
        :returns: ``Cookie`` instance
        :throws: ``CookieException``

        Construct a new Cookie instance.

    .. php:method:: getId()

        :rtype: string
        :returns: 쿠키 컬렉션에서 인덱싱하는 데 사용되는 ID

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
    .. php:method:: isHTTPOnly(): bool
    .. php:method:: getSameSite(): string
    .. php:method:: isRaw(): bool
    .. php:method:: getOptions(): array

    .. php:method:: withRaw([bool $raw = true])

        :param bool $raw:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        URL 인코딩 옵션으로 업데이트된 새 쿠키를 만듭니다.

    .. php:method:: withPrefix([string $prefix = ''])

        :param string $prefix:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        새 접두사를 사용하여 새 쿠키를 만듭니다.

    .. php:method:: withName(string $name)

        :param string $name:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        새 이름으로 새 쿠키를 만듭니다.

    .. php:method:: withValue(string $value)

        :param string $value:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        새 값으로 새 쿠키를 만듭니다.

    .. php:method:: withExpires($expires)

        :param DateTimeInterface|string|int $expires:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        새 쿠키 만료 시간을 사용하여 새 쿠키를 만듭니다.

    .. php:method:: withExpired()

        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        브라우저에서 만료되는 새 쿠키를 만듭니다.

    .. php:method:: withNeverExpiring()

        :param string $name:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        사실상 만료되지 않는 새 쿠키를 만듭니다.

    .. php:method:: withDomain(?string $domain)

        :param string|null $domain:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        새 도메인을 사용하여 새 쿠키를 만듭니다.

    .. php:method:: withPath(?string $path)

        :param string|null $path:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        새 경로로 새 쿠키를 만듭니다.

    .. php:method:: withSecure([bool $secure = true])

        :param bool $secure:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        새 "Secure" 특성을 가진 새 쿠키를 만듭니다.

    .. php:method:: withHTTPOnly([bool $httponly = true])

        :param bool $httponly:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        새 "HttpOnly" 특성을 사용하여 새 쿠키를 만듭니다.

    .. php:method:: withSameSite(string $samesite)

        :param string $samesite:
        :rtype: ``Cookie``
        :returns: new ``Cookie`` instance

        새 "SameSite" 특성을 가진 새 쿠키를 만듭니다.

    .. php:method:: toHeaderString()

        :rtype: string
        :returns: 헤더 문자열로 전달할 수 있는 문자열 표현을 반환합니다.

    .. php:method:: toArray()

        :rtype: array
        :returns: 쿠키 인스턴스의 배열 표현을 반환합니다.

.. php:class:: CookieStore

    .. php:staticmethod:: fromCookieHeaders(array $headers[, bool $raw = false])

        :param array $header: Array of ``Set-Cookie`` headers
        :param bool $raw: URL 인코딩 사용 여부
        :rtype: ``CookieStore``
        :returns: ``CookieStore`` instance
        :throws: ``CookieException``

        ``Set-Cookie`` 헤더 배열을 이용하여 쿠키 저장소를 만듭니다.

    .. php:method:: __construct(array $cookies)

        :param array $cookies: Array of ``Cookie`` objects
        :rtype: ``CookieStore``
        :returns: ``CookieStore`` instance
        :throws: ``CookieException``

    .. php:method:: has(string $name[, string $prefix = ''[, ?string $value = null]]): bool

        :param string $name: 쿠키 이름
        :param string $prefix: 쿠키 접두사
        :param string|null $value: 쿠키 값
        :rtype: bool
        :returns: 이름 및 접두사로 식별된 ``Cookie`` 개체가 컬렉션에 있는지 확인합니다.

    .. php:method:: get(string $name[, string $prefix = '']): Cookie

        :param string $name: 쿠키 이름
        :param string $prefix: 쿠키 접두사
        :rtype: ``Cookie``
        :returns: 이름 및 접두사로 식별된 쿠키 인스턴스를 검색합니다.
        :throws: ``CookieException``

    .. php:method:: put(Cookie $cookie): CookieStore

        :param Cookie $cookie: 쿠키 객체
        :rtype: ``CookieStore``
        :returns: new ``CookieStore`` instance

        Store a new cookie and return a new collection. The original collection is left unchanged.

    .. php:method:: remove(string $name[, string $prefix = '']): CookieStore

        :param string $name: 쿠키 이름
        :param string $prefix: 쿠키 접두사
        :rtype: ``CookieStore``
        :returns: new ``CookieStore`` instance

        컬렉션에서 쿠키를 제거하고 업데이트된 컬렉션을 반환합니다.
        원본 컬렉션은 변경되지 않은 상태로 유지됩니다.

    .. php:method:: dispatch(): void

        :rtype: void

        저장 중인 모든 쿠키를 보냅니다.

    .. php:method:: display(): array

        :rtype: array
        :returns: 저장 중인 모든 쿠키 인스턴스를 반환합니다.

    .. php:method:: clear(): void

        :rtype: void

        쿠키 컬렉션을 지웁니다.
