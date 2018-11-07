##################
API Response Trait
##################

Much of modern PHP development requires building API's, whether simply to provide data for a javascript-heavy
single page application, or as a standalone product. CodeIgniter provides an API Response trait that can be
used with any controller to make common response types simple, with no need to remember which HTTP status code
should be returned for which response types.
현대 PHP 개발의 대부분은 단순히 자바 스크립트가 많은 단일 페이지 응용 프로그램 용 데이터를 제공하는지 또는 독립 실행 형 제품으로 제공하는지에 관계없이 API를 작성해야합니다. CodeIgniter는 모든 응답 유형에 대해 반환되어야하는 HTTP 상태 코드를 기억할 필요없이 공통 응답 유형을 간단하게 만들기 위해 모든 컨트롤러와 함께 사용할 수있는 API 응답 특성을 제공합니다.

.. contents::
    :local:
    :depth: 2

*************
Example Usage
*************

The following example shows a common usage pattern within your controllers.
다음 예제는 컨트롤러 내의 일반적인 사용 패턴을 보여줍니다.

::

    <?php namespace App\Controllers;

    class Users extends \CodeIgniter\Controller
    {
        use \CodeIgniter\API\ResponseTrait;

        public function createUser()
        {
            $model = new UserModel();
            $user  = $model->save($this->request->getPost());

            // Respond with 201 status code
            return $this->respondCreated();
        }
    }

In this example, an HTTP status code of 201 is returned, with the generic status message, 'Created'. Methods
exist for the most common use cases
이 예제에서는 일반 상태 메시지 인 'Created'와 함께 201이라는 HTTP 상태 코드가 반환됩니다. 가장 일반적인 사용 사례에 대한 메소드가 있습니다.

::

    // Generic response method
    respond($data, 200);
    // Generic failure response
    fail($errors, 400);
    // Item created response
    respondCreated($data);
    // Item successfully deleted
    respondDeleted($data);
    // Client isn't authorized
    failUnauthorized($description);
    // Forbidden action
    failForbidden($description);
    // Resource Not Found
    failNotFound($description);
    // Data did not validate
    failValidationError($description);
    // Resource already exists
    failResourceExists($description);
    // Resource previously deleted
    failResourceGone($description);
    // Client made too many requests
    failTooManyRequests($description);

***********************
Handling Response Types
***********************

When you pass your data in any of these methods, they will determine the data type to format the results as based on
the following criteria:
이러한 메소드 중 하나에서 데이터를 전달하면 데이터 유형을 결정하여 다음 기준에 따라 결과의 형식을 지정합니다.

* If $data is a string, it will be treated as HTML to send back to the client.
  $data가 문자열이면 HTML로 처리되어 클라이언트로 다시 전송됩니다.
* If $data is an array, it will try to negotiate the content type with what the client asked for, defaulting to JSON
    if nothing else has been specified within Config/API.php, the ``$supportedResponseFormats`` property.
    $data가 배열 인 경우 클라이언트가 요청한 내용과 콘텐츠 형식을 협상하려고 시도하며 기본값은 JSON입니다. 아무것도 지정되지 않았다면 Config/API.php 내에 ``$supportedResponseFormats`` 속성을 사용합니다.

To define the formatter that is used, edit **Config/Format.php**. The ``$supportedResponseFormats`` contains a list of
mime types that your application can automatically format the response for. By default, the system knows how to
format both XML and JSON responses
사용 된 포맷터를 정의하려면 **Config/Format.php** 를 편집하십시오 . ``$supportedResponseFormats`` 응용 프로그램이 자동으로에 대한 응답을 포맷 할 수 있습니다 마임 유형의 목록이 포함되어 있습니다. 기본적으로 시스템은 XML 및 JSON 응답의 형식을 지정하는 방법을 알고 있습니다.

::

        public $supportedResponseFormats = [
            'application/json',
            'application/xml'
        ];

This is the array that is used during :doc:`Content Negotiation </incoming/content_negotiation>` to determine which
type of response to return. If no matches are found between what the client requested and what you support, the first
format in this array is what will be returned.
반환 할 응답 유형을 결정하기 위해 :doc:`Content Negotiation </incoming/content_negotiation>` 중에 사용되는 배열입니다 . 클라이언트가 요청한 것과 일치하는 것이없는 경우이 배열의 첫 번째 형식이 반환됩니다.

Next, you need to define the class that is used to format the array of data. This must be a fully qualified class
name, and the class must implement **CodeIgniter\\Format\\FormatterInterface**. Formatters come out of the box that
support both JSON and XML
그런 다음 데이터 배열의 형식을 지정하는 데 사용되는 클래스를 정의해야합니다. 이 클래스는 정규화 된 클래스 이름이어야하며 클래스는 **CodeIgniter\\Format\\FormatterInterface** 를 구현해야합니다 . JSON과 XML을 모두 지원하는 포맷터가 즉시 제공됩니다.

::

    public $formatters = [
        'application/json' => \CodeIgniter\Format\JSONFormatter::class,
        'application/xml'  => \CodeIgniter\Format\XMLFormatter::class
    ];

So, if your request asks for JSON formatted data in an **Accept** header, the data array you pass any of the
``respond*`` or ``fail*`` methods will be formatted by the **CodeIgniter\\API\\JSONFormatter** class. The resulting
JSON data will be sent back to the client.
귀하의 요청이에서 JSON 형식의 데이터를 요청한다면, **Accept** 헤더, 데이터 배열은 당신이의 통과 ``respond*`` 또는 ``fail*`` 메서드에 의해 포맷됩니다 **CodeIgniter\\API\\JSONFormatter** 의 클래스를. 결과 JSON 데이터가 클라이언트로 다시 전송됩니다.

클래스 참조
***************

.. php:method:: respond($data[, $statusCode=200[, $message='']])

    :param mixed  $data: The data to return to the client. Either string or array.
    :param int    $statusCode: The HTTP status code to return. Defaults to 200
    :param string $message: A custom "reason" message to return.

    This is the method used by all other methods in this trait to return a response to the client. 
    이 특성에서 클라이언트에 응답을 반환하는 다른 모든 메서드에서 사용하는 메서드입니다.

    The ``$data`` element can be either a string or an array. By default, a string will be returned as HTML,
    while an array will be run through json_encode and returned as JSON, unless :doc:`Content Negotiation </incoming/content_negotiation>`
    determines it should be returned in a different format.
    ``$data`` 요소는 문자열 또는 배열 일 수있다. 기본적으로 문자열은 HTML로 반환되지만 배열은 json_encode를 통해 실행되고 JSON으로 반환됩니다. :doc:`Content Negotiation </incoming/content_negotiation>` 이 다른 형식으로 반환되어야한다고 판단 하지 않는 한이 배열은 JSON 으로 반환됩니다.

    If a ``$message`` string is passed, it will be used in place of the standard IANA reason codes for the
    response status. Not every client will respect the custom codes, though, and will use the IANA standards
    that match the status code.
    경우 ``$message`` 문자열이 전달됩니다, 그것은 응답 상태에 대한 표준 IANA 이유 코드 대신에 사용됩니다. 모든 클라이언트가 맞춤 코드를 존중하지는 않으며 상태 코드와 일치하는 IANA 표준을 사용합니다.

    .. note:: Since it sets the status code and body on the active Response instance, this should always
        be the final method in the script execution.
        활성 상태의 Response 인스턴스에 상태 코드와 본문을 설정하므로 항상 스크립트 실행의 마지막 메서드 여야합니다.

.. php:method:: fail($messages[, int $status=400[, string $code=null[, string $message='']]])

    :param mixed $messages: A string or array of strings that contain error messages encountered.
    :param int   $status: The HTTP status code to return. Defaults to 400.
    :param string $code: A custom, API-specific, error code.
    :param string $message: A custom "reason" message to return.
    :returns: A multi-part response in the client's preferred format.

    The is the generic method used to represent a failed response, and is used by all of the other "fail" methods.
    실패한 응답을 나타내는 데 사용되는 일반 메소드이며 다른 모든 "fail"메소드에서 사용됩니다.

    The ``$messages`` element can be either a string or an array of strings.
    ``$messages`` 요소는 문자열 또는 문자열의 배열 일 수있다.

    The ``$status`` parameter is the HTTP status code that should be returned.
    ``$status`` 매개 변수는 반환되는 HTTP 상태 코드입니다.

    Since many APIs are better served using custom error codes, a custom error code can be passed in the third
    parameter. If no value is present, it will be the same as ``$status``.
    많은 API가 사용자 정의 오류 코드를 사용하여 더 잘 제공되기 때문에 사용자 정의 오류 코드가 세 번째 매개 변수로 전달 될 수 있습니다. 값이없는 경우와 같습니다 ``$status``.

    If a ``$message`` string is passed, it will be used in place of the standard IANA reason codes for the
    response status. Not every client will respect the custom codes, though, and will use the IANA standards
    that match the status code.
    경우 ``$message`` 문자열이 전달됩니다, 그것은 응답 상태에 대한 표준 IANA 이유 코드 대신에 사용됩니다. 모든 클라이언트가 맞춤 코드를 존중하지는 않으며 상태 코드와 일치하는 IANA 표준을 사용합니다.

    The response is an array with two elements: ``error`` and ``messages``. The ``error`` element contains the status
    code of the error. The ``messages`` element contains an array of error messages. It would look something like
    반응은 두 요소 배열이다 : error및 messages. error요소는 오류의 상태 코드가 포함되어 있습니다. messages요소는 에러 메시지의 배열을 포함한다. 그것은 다음과 같이 보일 것입니다 
    
    ::

	    $response = [
	        'status'   => 400,
	        'code'     => '321a',
	        'messages' => [
	            'Error message 1',
	            'Error message 2'
	        ]
	    ];

.. php:method:: respondCreated($data = null[, string $message = ''])

    :param mixed  $data: The data to return to the client. Either string or array.
    :param string $message: A custom "reason" message to return.
    :returns: The value of the Response object's send() method.

    Sets the appropriate status code to use when a new resource was created, typically 201.
    새 자원을 만들 때 사용할 적절한 상태 코드를 설정합니다 (일반적으로 201).
    
    ::

	    $user = $userModel->insert($data);
	    return $this->respondCreated($user);

.. php:method:: respondDeleted($data = null[, string $message = ''])

    :param mixed  $data: The data to return to the client. Either string or array.
    :param string $message: A custom "reason" message to return.
    :returns: The value of the Response object's send() method.

    Sets the appropriate status code to use when a new resource was deleted as the result of this API call, typically 200.
    이 API 호출의 결과로 새 리소스가 삭제 된 경우 (일반적으로 200) 사용할 적절한 상태 코드를 설정합니다.

    ::

	    $user = $userModel->delete($id);
	    return $this->respondDeleted(['id' => $id]);

.. php:method:: failUnauthorized(string $description = 'Unauthorized'[, string $code=null[, string $message = '']])

    :param mixed  $description: The error message to show the user.
    :param string $code: A custom, API-specific, error code.
    :param string $message: A custom "reason" message to return.
    :returns: The value of the Response object's send() method.

    Sets the appropriate status code to use when the user either has not been authorized,
    or has incorrect authorization. Status code is 401.
    사용자가 권한이 없거나 권한이 올바르지 않은 경우 사용할 적절한 상태 코드를 설정합니다. 상태 코드는 401입니다.

    ::

	    return $this->failUnauthorized('Invalid Auth token');

.. php:method:: failForbidden(string $description = 'Forbidden'[, string $code=null[, string $message = '']])

    :param mixed  $description: The error message to show the user.
    :param string $code: A custom, API-specific, error code.
    :param string $message: A custom "reason" message to return.
    :returns: The value of the Response object's send() method.

    Unlike ``failUnauthorized``, this method should be used when the requested API endpoint is never allowed.
    Unauthorized implies the client is encouraged to try again with different credentials. Forbidden means
    the client should not try again because it won't help. Status code is 403.
    달리 failUnauthorized요청 된 API 끝점이 허용되지 않을 때이 메서드를 사용해야합니다. 인증되지 않은 것은 클라이언트가 다른 자격 증명으로 다시 시도하도록 권장 함을 의미합니다. 금지 된 것은 클라이언트가 도움이되지 않기 때문에 다시 시도해서는 안된다는 것을 의미합니다. 상태 코드는 403입니다.

    ::

    	return $this->failForbidden('Invalid API endpoint.');

.. php:method:: failNotFound(string $description = 'Not Found'[, string $code=null[, string $message = '']])

    :param mixed  $description: The error message to show the user.
    :param string $code: A custom, API-specific, error code.
    :param string $message: A custom "reason" message to return.
    :returns: The value of the Response object's send() method.

    Sets the appropriate status code to use when the requested resource cannot be found. Status code is 404.
    요청한 리소스를 찾을 수 없을 때 사용할 적절한 상태 코드를 설정합니다. 상태 코드는 404입니다.

    ::

    	return $this->failNotFound('User 13 cannot be found.');

.. php:method:: failValidationError(string $description = 'Bad Request'[, string $code=null[, string $message = '']])

    :param mixed  $description: The error message to show the user.
    :param string $code: A custom, API-specific, error code.
    :param string $message: A custom "reason" message to return.
    :returns: The value of the Response object's send() method.

    Sets the appropriate status code to use when data the client sent did not pass validation rules.
    Status code is typically 400.
    클라이언트가 보낸 데이터가 유효성 검사 규칙을 통과하지 못한 경우 사용할 적절한 상태 코드를 설정합니다. 상태 코드는 일반적으로 400입니다.

    ::

    	return $this->failValidationError($validation->getErrors());

.. php:method:: failResourceExists(string $description = 'Conflict'[, string $code=null[, string $message = '']])

    :param mixed  $description: The error message to show the user.
    :param string $code: A custom, API-specific, error code.
    :param string $message: A custom "reason" message to return.
    :returns: The value of the Response object's send() method.

    Sets the appropriate status code to use when the resource the client is trying to create already exists.
    Status code is typically 409.
    클라이언트가 생성하려고하는 리소스가 이미 존재할 때 사용할 적절한 상태 코드를 설정합니다. 상태 코드는 일반적으로 409입니다.

    ::

    	return $this->failResourceExists('A user already exists with that email.');

.. php:method:: failResourceGone(string $description = 'Gone'[, string $code=null[, string $message = '']])

    :param mixed  $description: The error message to show the user.
    :param string $code: A custom, API-specific, error code.
    :param string $message: A custom "reason" message to return.
    :returns: The value of the Response object's send() method.

    Sets the appropriate status code to use when the requested resource was previously deleted and
    is no longer available. Status code is typically 410.
    요청한 리소스가 이전에 삭제되어 더 이상 사용할 수 없을 때 사용할 적절한 상태 코드를 설정합니다. 상태 코드는 일반적으로 410입니다.

    ::

    	return $this->failResourceGone('That user has been previously deleted.');

.. php:method:: failTooManyRequests(string $description = 'Too Many Requests'[, string $code=null[, string $message = '']])

    :param mixed  $description: The error message to show the user.
    :param string $code: A custom, API-specific, error code.
    :param string $message: A custom "reason" message to return.
    :returns: The value of the Response object's send() method.

    Sets the appropriate status code to use when the client has called an API endpoint too many times.
    This might be due to some form of throttling or rate limiting. Status code is typically 400.
    클라이언트가 API 끝점을 너무 많이 호출했을 때 사용할 적절한 상태 코드를 설정합니다. 이는 스로틀 링 또는 속도 제한의 일부 형태 때문일 수 있습니다. 상태 코드는 일반적으로 400입니다.

    ::

    	return $this->failTooManyRequests('You must wait 15 seconds before making another request.');

.. php:method:: failServerError(string $description = 'Internal Server Error'[, string $code = null[, string $message = '']])

    :param string $description: The error message to show the user.
    :param string $code: A custom, API-specific, error code.
    :param string $message: A custom "reason" message to return.
    :returns: The value of the Response object's send() method.

    Sets the appropriate status code to use when there is a server error.
    서버 오류가있을 때 사용할 적절한 상태 코드를 설정합니다.

    ::

    	return $this->failServerError('Server error.');
