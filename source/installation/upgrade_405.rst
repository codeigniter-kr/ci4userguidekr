#############################
4.0.4에서 4.0.5로 업그레이드
#############################

**Cookie SameSite 지원**

쿠키 SameSite 속성에 대한 설정이 CodeIgniter 4.0.5에 도입되었습니다.
이전 버전에서는 이 속성을 설정하지 않았습니다.
쿠키의 기본 설정은 "Lax" 입니다.
이 속성은 교차 도메인 컨텍스트(cross-domain contexts)에서 쿠키가 처리되는 방식에 영향을 미치며 프로젝트에 따라 이 설정을 조정해야 할 수도 있습니다.
Response 쿠키와 CSRF 쿠키에 대한 설정은 "config/App.php"\ 에서 할 수 있습니다.

자세한 내용은 `MDN Web Docs <https://developer.mozilla.org/pl/docs/Web/HTTP/Headers/Set-Cookie/SameSite>`_\ 를 참고하세요.
SameSite 대한 설명은 `RFC 6265 <https://tools.ietf.org/html/rfc6265>`_\ 과 
`RFC 6265bis revision <https://datatracker.ietf.org/doc/draft-ietf-httpbis-rfc6265bis/?include_text=1>`_\ 를 참고하세요.

**Message::getHeader(s)**

HTTP 계층은 `PSR-7 규정 준수 <https://www.php-fig.org/psr/psr-7/>`_\ 로 이동하고 있습니다.
이를 위해 ``Message::getHeader()``\ 와 ``Message::getHeaders()``\ 는 더 이상 사용되지 않으며 각각 ``Message::header()``\ 와 ``Message::headers()``\ 로 대체되어야 합니다.
이는 ``Message``\ 를 확장하는 모든 클래스(``Request``, ``Response``\ 와 그 하위 클래스)와 관련이 있습니다.