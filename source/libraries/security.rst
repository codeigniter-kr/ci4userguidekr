##############
보안
##############

보안 클래스에는 사이트 간 요청 위조 공격(Cross-Site Request Forgery attacks)으로부터 사이트를 보호하는 데 도움이 되는 방법이 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

*******************
라이브러리 로드
*******************

라이브러리 로드를 하려는 이유가 CSRF 보호를 위한것이라면, 입력이 필터로 실행되고 수동으로 상호 작용을 하지 않으므로 로드할 필요는 없습니다.

경우에 따라 직접 액세스가 필요하다면 서비스를 통해 로드합니다.

::

	$security = \Config\Services::security();

*********************************
사이트 간 요청 위조 (CSRF)
*********************************

**app/Config/Filters.php**\ 파일의 `csrf` 필터를 활성화하여 사이트 전체적으로 CSRF 보호(protection)를 활성화할 수 있습니다

::

	public $globals = [
		'before' => [
			//'honeypot'
			'csrf'
		]
	];

URI를 화이트리스트에 추가하여 CSRF 보호에서 제외할 수 있습니다. (예 : 외부 POST 컨텐츠를 예상하는 API 엔드 포인트)
사전 필터에 예외로 URI를 추가하여 제외시킵니다.

::

	public $globals = [
		'before' => [
			'csrf' => ['except' => ['api/record/save']]
		]
	];

정규식도 지원합니다. (대/소문자 구분)

::

    public $globals = [
		'before' => [
			'csrf' => ['except' => ['api/record/[0-9]+']]
		]
	];

:doc:`form helper <../helpers/form_helper>`\ 의 :func:`form_open()`\ 를 사용하면 자동으로 폼(form)에 숨겨진  추가합니다.
직접 폼에 csrf 필드를 추가하고 싶다면 ``csrf_token()`` 와 ``csrf_hash()`` 함수를 사용합니다

::

	<input type="hidden" name="<?= csrf_token() ?>" value="<?= csrf_hash() ?>" />

또한, ``csrf_field ()`` 메소드를 사용하면 숨겨진 입력 필드를 생성할 수 있습니다

::

	// Generates: <input type="hidden" name="{csrf_token}" value="{csrf_hash}" />
	<?= csrf_field() ?>

JSON 요청을 보낼 때 CSRF 토큰을 매개 변수중 하나로 전달할 수 있습니다.
CSRF 토큰을 전달하는 방법은 특수한 Http 헤더이며, ``csrf_header()`` 함수를 사용합니다.

``csrf_meta()`` 메소드를 사용 하면 메타 태그를 편리하게 생성 할 수 있습니다

::

	// Generates: <meta name="{csrf_header}" content="{csrf_hash}" />
	<?= csrf_meta() ?>

CSRF 토큰을 확인하는 순서는 다음과 같습니다.

1. ``$_POST`` array
2. Http header
3. ``php://input`` (JSON 요청) - JSON을 디코딩한 다음 다시 인코딩해야 하기 때문에 이 방법이 가장 느립니다.

토큰은 제출할 때마다 재생성되거나(기본값), CSRF 쿠키 존재하는 동안 동일하게 유지됩니다.
토큰의 기본 재생성은 강력한 보안을 제공하지만, 다른 토큰이 뒤로/앞으로 탐색, 여러 탭/창, 비동기 작업 등으로 무효화됨에 따라 사용성 문제가 발생할 수 있습니다.
다음과 같이 **app/Config/Security.php**\ 파일의 매개 변수를 편집하여 이 동작을 변경할 수 있습니다.

::

	public $regenerate  = true;

요청이 CSRF 유효성 검사에 실패하면 기본적으로 이전 페이지로 리디렉션되어 최종 사용자에게 표시 할 수있는 ``error`` 플래시 메시지를 설정합니다. 
이것은 단순히 충돌하는 것보다 더 좋은 경험을 제공합니다. 
다음과 같이 **app/Config/Security.php**\ 매개 변수를 편집하여 끌 수 있습니다.

::

	public $redirect = false;

리디렉션 값이 **true**\ 인 경우 AJAX 호출은 리디렉션되지 않지만 오류가 발생합니다.

*********************
다른 유용한 메소드
*********************

Security 클래스의 대부분의 메소드를 직접 사용할 필요는 없습니다.
다음은 CSRF 보호와 관련이 없는 유용한 메소드입니다.

**sanitizeFilename()**

디렉토리 탐색 시도 및 기타 보안 위협을 방지하기 위해 파일 이름을 삭제하려고 시도합니다. 
이는 사용자 입력을 통해 제공된 파일에 특히 유용합니다. 
첫 번째 매개 변수는 처리(sanitize) 경로입니다.

사용자 입력이 상대 경로를 포함하는 것이 허용되는 경우(예 : file/in/some/approved/folder.txt), 두 번째 선택적 매개 변수 ``$relative_path``\ 를 ``true``\ 로 설정합니다.

::

	$path = $security->sanitizeFilename($request->getVar('filepath'));
