##################
API Response Trait
##################

현대 PHP 개발의 대부분은 자바스크립트로 작성된 단일 페이지 어플리케이션(single page application)에 데이터를 제공하거나 독립형 제품으로 API를 구축하는 것입니다.
CodeIgniter는 어떤 응답 유형에 대해 어떤 HTTP 상태 코드를 반환해야 하는지 기억할 필요없이 일반적인 응답 유형을 단순하게 만들기 위해 모든 컨트롤러와 함께 사용할 수 있는 API 응답 특성(trait)을 제공합니다.

.. contents::
    :local:
    :depth: 2

*************
사용샘플
*************

다음 예는 컨트롤러내에서 일반적인 사용 패턴을 보여줍니다.

.. literalinclude:: api_responses/001.php

이 예에서는 일반 상태 메시지 'Created'와 함께 HTTP 상태 코드 201이 반환됩니다.
가장 일반적인 사용 사례에 대한 메소드입니다.

.. literalinclude:: api_responses/002.php

***********************
응답 유형 처리
***********************

이러한 메소드중 하나로 데이터를 전달하면 다음 기준에 따라 결과 형식의 지정된 데이터 유형이 결정됩니다:

* 데이타가 문자열이면 클라이언트로 다시 보내기 위해 HTML로 처리됩니다.
* 데이타가가 배열이면 컨트롤러의 ``$this-format`` 값에 따라 형식이 지정됩니다. 이 항목이 비어 있으면 클라이언트가 요청한 내용과 내용 유형을 협상하려고 시도합니다. **Config/Format.php**\ 의 속성 ``$supportedResponseFormats``\ 에 다른 내용이 지정되지 않은 경우 기본적으로 JSON으로 설정됩니다.

사용되는 포맷터를 정의하려면 **Config/Format.php**\ 를 수정하십시오.
``$supportedResponseFormats``\ 에는 어플리케이션이 자동으로 응답 형식을 지정할 수 있는 MIME 유형 목록이 포함되어 있습니다.
XML과 JSON 응답의 형식이 기본적으로 지정되어 있습니다.

.. literalinclude:: api_responses/003.php

이 배열은 :doc:`컨텐츠 협상 </incoming/content_negotiation>`\ 후 반환할 응답 유형을 결정하는데 사용됩니다.
지원하는 것중 클라이언트가 요청한 것과 일치하는 것이 없으면 이 배열의 첫 번째 형식이 반환됩니다.

다음으로, 데이터 배열을 형식화하는데 사용되는 클래스를 정의해야 합니다.
정규화된 클래스 이름이어야 하며 클래스는 ``CodeIgniter\Format\FormatterInterface``\ 를 구현해야 합니다.
JSON과 XML을 모두 지원하는 포맷터가 기본으로 제공됩니다.

.. literalinclude:: api_responses/004.php

따라서 요청이 **Accept** 헤더에서 JSON 형식의 데이터를 요청하면 ``respond*`` 또는 ``fail*`` 메소드는 데이터 배열을 ``CodeIgniter\Format\JSONFormatter`` 클래스로 형식화합니다.
결과인 JSON 데이터는 클라이언트로 다시 전송됩니다.

***************
Class Reference
***************

.. php:method:: setResponseFormat($format)

    :param string $format 반환할 응답 유형, ``json``, ``xml``\ 중 하나

    응답에서 배열을 포맷할 때 사용할 형식을 정의합니다. 
    ``$format``\ 에 대해 ``null`` 값을 제공하면 콘텐츠 협상을 통해 자동으로 결정됩니다.

.. literalinclude:: api_responses/005.php

.. php:method:: respond($data[, $statusCode = 200[, $message = '']])

    :param mixed  $data: 클라이언트에게 반환 할 데이터, 문자열 또는 배열
    :param int    $statusCode: HTTP 상태 코드, 기본값은 200
    :param string $message: 사용자 정의 "이유" 메시지

    이 특성의 다른 모든 메소드가 클라이언트에 응답을 리턴하기 위해 사용하는 메소드입니다.

    The ``$data`` element can be either a string or an array. 
    :doc:`컨텐츠 협상 </incoming/content_negotiation>`\ 에서 다른 형식으로 반환해야한다고 결정하지 않는 한, 기본적으로 문자열은 HTML로, 배열은 json_encode를 통해 JSON으로 반환됩니다.

    If a ``$message`` string is passed, it will be used in place of the standard IANA reason codes for the response status. 
    ``$message`` 문자열이 전달되면 응답 상태에 대한 표준 IANA 이유 코드 대신 사용됩니다.

    .. note:: 활성 Response 인스턴스에서 상태 코드 및 본문을 설정하므로 항상 스크립트의 마지막에 이 메소드가 실행 되어야합니다.

.. php:method:: fail($messages[, int $status = 400[, string $code = null[, string $message='']]])

    :param mixed $messages: 오류 메시지가 포함 된 문자열 또는 문자열 배열
    :param int   $status: HTTP 상태 코드, 기본값은 400
    :param string $code: 사용자 정의 API별 오류 코드
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: 클라이언트 선호 형식 응답.

    이 메소드는 실패한 응답을 나타내는데 사용되는 일반적인 메소드이며, 다른 모든 "실패" 메소드에서 사용됩니다.

    ``$messages`` 요소는 문자열 또는 문자열 배열일 수 있습니다.

    ``$status`` 매개 변수는 HTTP 상태 코드입니다.

    많은 API가 사용자 정의 오류 코드를 제공하므로, 사용자 정의 오류 코드를 세 번째 매개 변수에 전달할 수 있습니다.
    값이 없으면 ``$status``\ 와 같습니다.

    ``$message`` 문자열이 전달되면 응답 상태에 대한 표준 IANA 이유 코드 대신 사용됩니다.
    일부 클라이언트는 사용자 정의 문자열대신 상태 코드와 일치하는 IANA 표준을 사용합니다.

    응답은 ``error``\ 와 ``messages``\ 라는 두 가지 요소로 구성된 배열입니다.
    The ``error`` element contains the status code of the error. 
    ``error`` 요소는 오류의 상태 코드를 포함합니다.
    ``messages`` 요소에는 오류 메시지 배열이 포함되어 있습니다.
    그것은 다음과 같이 보일 것입니다
    
    .. literalinclude:: api_responses/006.php

.. php:method:: respondCreated($data = null[, string $message = ''])

    :param mixed  $data: 클라이언트에게 반환할 데이터, 문자열 또는 배열
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    자원(resource)을 작성할 때 사용할 적절한 상태 코드를 설정합니다. (일반적으로 201)
    
    .. literalinclude:: api_responses/007.php

.. php:method:: respondDeleted($data = null[, string $message = ''])

    :param mixed  $data: 클라이언트에게 반환할 데이터, 문자열 또는 배열
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    API 호출의 결과로 자원이 삭제될 때 사용할 적절한 상태 코드를 설정합니다. (일반적으로 200)

    .. literalinclude:: api_responses/008.php

.. php:method:: respondNoContent(string $message = 'No Content')

    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    클라이언트로 다시 보낼 의미있는 응답은 없지만, 서버가 명령을 성공적으로 실행한 후 사용할 적절한 상태 코드를 설정합니다. (일반적으로 204)

    .. literalinclude:: api_responses/009.php

.. php:method:: failUnauthorized(string $description = 'Unauthorized'[, string $code = null[, string $message = '']])

    :param string  $description: 사용자에게 표시할 오류 메시지
    :param string $code: 사용자 정의 API별 오류 코드
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    사용자에게 권한이 없거나 권한이 올바르지 않은 경우 사용할 적절한 상태 코드를 설정합니다. (상태 코드 401)

    .. literalinclude:: api_responses/010.php

.. php:method:: failForbidden(string $description = 'Forbidden'[, string $code = null[, string $message = '']])

    :param string  $description: 사용자에게 표시할 오류 메시지
    :param string $code: 사용자 정의 API별 오류 코드
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    ``failUnauthorized()``\ 와 달리 이 메소드는 요청된 API 엔드 포인트가 허용되지 않을 때 사용합니다.
    Unauthorized는 클라이언트가 다른 자격 증명으로 다시 시도하도록 권장합니다.
    Forbidden은 클라이언트가 도움이 되지 않기 때문에 다시 시도해서는 안 됨을 의미합니다. (상태 코드 403)

    .. literalinclude:: api_responses/011.php

.. php:method:: failNotFound(string $description = 'Not Found'[, string $code = null[, string $message = '']])

    :param string  $description: 사용자에게 표시할 오류 메시지
    :param string $code: 사용자 정의 API별 오류 코드
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    요청된 리소스를 찾을 수 없을 때 사용할 적절한 상태 코드를 설정합니다. (상태 코드 404)

    .. literalinclude:: api_responses/012.php

.. php:method:: failValidationErrors($errors[, string $code = null[, string $message = '']])

    :param mixed  $errors: 사용자에게 표시할 오류 메시지 또는 메시지 배열
    :param string $code: 사용자 정의 API별 오류 코드
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    클라이언트가 보낸 데이터가 유효성 검사 규칙을 통과하지 못한 경우 사용할 적절한 상태 코드를 설정합니다. (일반적으로 400)

    .. literalinclude:: api_responses/013.php

.. php:method:: failResourceExists(string $description = 'Conflict'[, string $code=null[, string $message = '']])

    :param string  $description: 사용자에게 표시할 오류 메시지
    :param string $code: 사용자 정의 API별 오류 코드
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    클라이언트가 작성하려고하는 자원이 이미 존재하는 경우 사용할 적절한 상태 코드를 설정합니다. (일반적으로 409)

    .. literalinclude:: api_responses/014.php

.. php:method:: failResourceGone(string $description = 'Gone'[, string $code=null[, string $message = '']])

    :param string  $description: 사용자에게 표시할 오류 메시지
    :param string $code: 사용자 정의 API별 오류 코드
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    요청된 리소스가 이전에 삭제되어 더 이상 사용할 수 없을 때 사용할 적절한 상태 코드를 설정합니다. (일반적으로 410)

    .. literalinclude:: api_responses/015.php

.. php:method:: failTooManyRequests(string $description = 'Too Many Requests'[, string $code=null[, string $message = '']])

    :param string  $description: 사용자에게 표시할 오류 메시지
    :param string $code: 사용자 정의 API별 오류 코드
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    클라이언트가 API 엔드(end) 포인트를 너무 많이 호출했을 때, 사용할 적절한 상태 코드를 설정합니다.
    일부 형태의 제한 또는 속도 제한 때문일 수 있습니다. (일반적으로 400)

    .. literalinclude:: api_responses/016.php

.. php:method:: failServerError(string $description = 'Internal Server Error'[, string $code = null[, string $message = '']])

    :param string $description: 사용자에게 표시할 오류 메시지
    :param string $code: 사용자 정의 API별 오류 코드
    :param string $message: 사용자 정의 "이유" 메시지
    :returns: Response 객체 send() 메소드의 값

    서버 오류가있을 때 사용할 적절한 상태 코드를 설정합니다.

    .. literalinclude:: api_responses/017.php
