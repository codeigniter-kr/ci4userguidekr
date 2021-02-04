#############################
4.0.4에서 4.0.5로 업그레이드
#############################

**Cookie SameSite 지원**

쿠키 SameSite 속성에 대한 설정이 CodeIgniter 4.0.5에 도입되었습니다.
이전 버전에서는 이 속성을 설정하지 않았습니다.
쿠키의 기본 설정은 "Lax" 입니다.
이 속성은 교차 도메인 컨텍스트(cross-domain contexts)에서 쿠키가 처리되는 방식에 영향을 미치며 프로젝트에 따라 이 설정을 조정해야 할 수도 있습니다.
Response 쿠키와 CSRF 쿠키에 대한 설정은 ``app/Config/App.php``\ 에서 할 수 있습니다.

자세한 내용은 `MDN Web Docs <https://developer.mozilla.org/pl/docs/Web/HTTP/Headers/Set-Cookie/SameSite>`_\ 를 참고하세요.
SameSite 대한 설명은 `RFC 6265 <https://tools.ietf.org/html/rfc6265>`_\ 과 
`RFC 6265bis revision <https://datatracker.ietf.org/doc/draft-ietf-httpbis-rfc6265bis/?include_text=1>`_\ 를 참고하세요.

**Message::getHeader(s)**

HTTP 계층은 `PSR-7 규정 준수 <https://www.php-fig.org/psr/psr-7/>`_\ 로 이동하고 있습니다.
이를 위해 ``Message::getHeader()``\ 와 ``Message::getHeaders()``\ 는 더 이상 사용되지 않으며 각각 ``Message::header()``\ 와 ``Message::headers()``\ 로 대체되어야 합니다.
이는 ``Message``\ 를 확장하는 모든 클래스(``Request``, ``Response``\ 와 그 하위 클래스)와 관련이 있습니다.

HTTP 계층의 추가적인 지원 중단(deprecate) 항목:

* ``Message::isJSON``: Check the "Content-Type" header directly
* ``Request[Interface]::isValidIP``: Use the Validation class with ``valid_ip``
* ``Request[Interface]::getMethod()``: The ``$upper`` parameter will be removed, use str_to_upper()
* ``Request[Trait]::$ipAddress``: This property will become private
* ``Request::$proxyIPs``: This property will be removed; access ``config('App')->proxyIPs`` directly
* ``Request::__construct()``: The constructor will no longer take ``Config\App`` and has been made nullable to aid transition
* ``Response[Interface]::getReason()``: Use ``getReasonPhrase()`` instead
* ``Response[Interface]::getStatusCode()``: The explicit ``int`` return type will be removed (no action required)

**ResponseInterface**

이 인터페이스는 프레임워크 호환 응답 클래스에 필요한 메소드를 포함합니다.
프레임워크에 예상되는 여러 메서드가 누락되었으며, 추가되지 않았습니다.
여러분이 ``ResponseInterface``\ 를 사용하여 클래스를 직접 구현한다면, 업데이트된 요구사항과 호환되도록 해야 합니다.
이러한 메소드는 다음과 같습니다.

* ``setLastModified($date);``
* ``setLink(PagerInterface $pager);``
* ``setJSON($body, bool $unencoded = false);``
* ``getJSON();``
* ``setXML($body);``
* ``getXML();``
* ``send();``
* ``sendHeaders();``
* ``sendBody();``
* ``setCookie($name, $value = '', $expire = '', $domain = '', $path = '/', $prefix = '', $secure = false, $httponly = false, $samesite = null);``
* ``hasCookie(string $name, string $value = null, string $prefix = ''): bool;``
* ``getCookie(string $name = null, string $prefix = '');``
* ``deleteCookie(string $name = '', string $domain = '', string $path = '/', string $prefix = '');``
* ``getCookies();``
* ``redirect(string $uri, string $method = 'auto', int $code = null);``
* ``download(string $filename = '', $data = '', bool $setMime = false);``

이 인터페이스를 쉽게 사용하도록 하기 위해 이러한 메소드들은 프레임워크의 ``Response``\ 에서 ``ResponseTrait``\ 으로 이동되었으며, ``DownloadResponse``\ 는 ``Response``\ 를 직접 확장하여 최대의 호환성을 보장합니다.

**Config\Services**

타사 서비스(모듈을 통해 활성화된 경우)가 핵심 서비스보다 우선하도록 서비스 검색이 업데이트되었습니다.
**app/Config/Services.php**\ 를 업데이트하여 클래스가 ``CodeIigniter\Config\BaseService``\ 를 확장하여 타사 서비스를 제대로 검색할 수 있도록 합니다.