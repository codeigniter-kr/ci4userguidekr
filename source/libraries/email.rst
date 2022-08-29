#################
Email 클래스
#################

CodeIgniter의 강력한 이메일(email) 클래스는 다음 기능을 지원합니다.

- 여러 프로토콜 : 메일, Sendmail 및 SMTP
- SMTP 용 TLS 및 SSL 암호화
- 여러 수신자
- CC 및 BCC
- HTML 또는 일반 텍스트 이메일
- 첨부
- 단어 줄 바꿈
- 우선 순위
- 큰 이메일 목록을 작은 크기의 BCC 배치로 나눌 수있는 BCC 배치 모드
- 이메일 디버깅 도구

.. contents::
    :local:
    :depth: 2

***********************
이메일 라이브러리 사용
***********************

이메일 보내기
=============

이메일 전송은 간단하며 관련 구성을 즉시하거나 **app/Config/Email.php** 파일을 통하여 환경 설정을 구성할 수 있습니다.

다음은 이메일을 보내는 방법을 보여주는 기본 예입니다.

.. literalinclude:: email/001.php

.. _setting-email-preferences:

이메일 환경 설정
=========================

이메일 메시지 전송 방식을 조정하기 위해 21가지 기본 설정을 사용할 수 있습니다.
여기에 설명 된대로 수동으로 설정하거나, 아래 설명된 구성 파일에 저장된 환경 설정을 통해 자동으로 설정할 수 있습니다.

기본 설정 값을 이메일 초기화 방법으로 전달하면 기본 설정이 설정됩니다. 
다음은 일부 환경 설정을 설정하는 방법에 대한 예입니다.

.. literalinclude:: email/002.php

.. note:: 기본 설정에는 설정하지 않은 경우, 대부분 사용되는 기본값이 있습니다.

구성 파일에서 이메일 환경 설정
------------------------------------------

위의 방법을 사용하여 환경 설정을 설정하지 않으려면 구성 파일에 환경 설정을 넣을 수 있습니다.
**app/Config/Email.php** 파일을 열고 각 이메일 속성에 구성을 설정하십시오.
그런 다음 파일을 저장하면 자동으로 사용됩니다.
구성 파일에서 환경 설정을 설정한 경우 ``$email->initialize()`` 메소드를 사용할 필요가 없습니다.

환경 설정 검토
---------------------

마지막으로 성공한 전송에 사용된 설정은 ``$archive`` 인스턴스(instance) 속성을 통하여 사용할 수 있습니다. 
이는 ``send()`` 호출시 실제 값을 확인하기 위한 테스트 및 디버깅에 유용합니다.

SMTP 프로토콜용 SSL/TLS
================================

SMTP 서버와 통신하는 동안 사용자 이름, 암호 및 이메일 콘텐츠를 보호하려면 채널의 암호화를 사용해야 합니다. 
두 가지의 다른 표준이 광범위하게 배포되어 있으므로, 이메일 전송 문제를 해결할 때 차이점을 이해하는 것이 중요합니다.

대부분의 SMTP 서버는 이메일을 제출할 때 465 또는 587번 포트 연결을 허용합니다.
(원래 사용되던 25번 포트는 많은 ISP가 차단 규칙을 적용하고 있고 일반 텍스트로 통신이 이루어지기 때문에 거의 사용되지 않습니다.)

주요 차이점은 465번 포트가 `RFC 8314 <https://tools.ietf.org/html/rfc8314>`_\ 규약에 따라 처음부터 TLS를 이용하여 통신 채널이 보호될 것으로 예상한다는 점입니다.
587번 포트는 일반 텍스트로 연결후 암호화를 사용하도록 ``STARTTLS`` SMTP 명령을 사용하여 채널을 업그레이드합니다.

465번 포트에 연결했을때 암호화 업그레이드를 서버에서 허용하지 않을 경우 ``STARTTLS`` SMTP 명령이 실패할 수 있습니다.
포트를 465번으로 설정했다면 처음부터 TLS를 사용하여 통신을 보호하기 때문에 ``STARTLS`` SMTP 명령이 실행하지 않도록 ``SMTPCrypto`` 설정을 비워 두어야 합니다.

구성에서 587번 포트에 연결할 경우 일반 텍스트에서 암호화된 채널로 전환하기 위해 SMTP 서버와 통신하는 동안 ``STARTTLS`` 명령을 실행하므로 ``SMTPCrypto``\ 를 ``tls``\ 로 설정해야 합니다.
초기 통신은 일반 텍스트로 이루어지며 채널은 ``STARTLS`` 명령을 사용하여 TLS로 업그레이드됩니다.

이메일 환경 설정
====================

다음은 이메일을 보낼 때 설정할 수있는 모든 환경 설정 목록입니다.

=================== ====================== ============================ =======================================================================
Preference          Default Value          Options                      Description
=================== ====================== ============================ =======================================================================
**userAgent**       CodeIgniter            None                         user agent
**protocol**        mail                   mail, sendmail, or smtp      메일 전송 프로토콜
**mailPath**        /usr/sbin/sendmail     None                         Sendmail의 서버 경로
**SMTPHost**        No Default             None                         SMTP Server Address
**SMTPUser**        No Default             None                         SMTP Username
**SMTPPass**        No Default             None                         SMTP Password
**SMTPPort**        25                     None                         SMTP Port
**SMTPTimeout**     5                      None                         SMTP Timeout (초)
**SMTPKeepAlive**   false                  true or false (boolean)      지속적인 SMTP 연결을 활성화 여부
**SMTPCrypto**      No Default             tls or ssl                   SMTP 암호화. 이 값을 "ssl"\ 로 설정하면 SSL을 사용하여 보안 채널이 생성
                                                                        되고 "tls"\ 로 설정하면 서버에 "STARTTLS" 명령을 실행합니다.
                                                                        465번 포트 연결은 이 값을 빈 값으로 설정해야 합니다.
**wordWrap**        true                   true or false (boolean)      Enable word-wrap.
**wordWrap**        true                   true or false (boolean)      자동 줄 바꿈을 활성화 여부
**wrapChars**       76                                                  랩핑할 문자 수
**mailType**        text                   text or html                 메일 유형. HTML 이메일을 보내려면 완전한 웹 페이지로 보내야합니다. 상대 링크
                                                                        또는 상대 이미지 경로가 없는지 확인하십시오. 그렇지 않으면 작동하지 않습니다.
**charset**         utf-8                                               Character set (utf-8, iso-8859-1, etc.).
**validate**        true                   true or false (boolean)      이메일 주소의 유효성 검사 여부
**priority**        3                      1, 2, 3, 4, 5                이메일 우선 순위: 1 = highest. 5 = lowest. 3 = normal.
**CRLF**            \\n                    "\\r\\n" or "\\n" or "\\r"   Newline character. (Use "\\r\\n" to comply with RFC 822).
**newline**         \\n                    "\\r\\n" or "\\n" or "\\r"   Newline character. (Use "\\r\\n" to comply with RFC 822).
**BCCBatchMode**    false                  true or false (boolean)      BCC 배치 모드 활성화 여부
**BCCBatchSize**    200                    None                         각 BCC 배치의 이메일 수
**DSN**             false                  true or false (boolean)      서버 알림 메시지 사용 여부
=================== ====================== ============================ =======================================================================

단어 줄 바꿈 무시
========================

단어 줄 바꿈을 사용하도록 설정하고 (RFC 822를 준수하도록 권장), 전자 메일의 링크가 너무 길면, 줄 바꿈이 되어 받은 사람이 링크를 클릭할 수 없게 됩니다.
CodeIgniter는 다음과 같이 메시지의 일부에서 단어 줄 바꿈을 수동으로 무시할 수 있습니다

::

	The text of your email that
	gets wrapped normally.

	{unwrap}http://example.com/a_long_link_that_should_not_be_wrapped.html{/unwrap}

	More text that will be
	wrapped normally.

줄 바꿈하지 않으려는 항목을 배치하십시오: {unwrap} {/unwrap}

***************
Class Reference
***************

.. php:namespace:: CodeIgniter\Email

.. php:class:: Email

	.. php:method:: setFrom($from[, $name = ''[, $returnPath = null]])

		:param	string	$from: "From" e-mail 주소
		:param	string	$name: "From" 표시할 이름
		:param	string	$returnPath: 배달되지 않은 이메일을 리디렉션할 이메일 주소 (선택 사항)
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		이메일을 보내는 사람의 이메일 주소와 이름을 설정합니다.
		
		.. literalinclude:: email/003.php

		배달되지 않은 메일을 리디렉션하는 데 도움이 되도록 Return-Path를 설정할 수 있습니다.

		.. literalinclude:: email/004.php

		.. note:: 프로토콜로 'smtp'\ 를 구성한 경우 Return-Path를 사용할 수 없습니다.

	.. php:method:: setReplyTo($replyto[, $name = ''])

		:param	string	$replyto: E-mail 답장 주소
		:param	string	$name: 회신 이메일 주소의 표시 이름
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		회신 주소를 설정합니다. 정보가 제공되지 않으면 `setFrom <#setFrom>`_ 메소드의 정보가 사용됩니다.
		
		Example

		.. literalinclude:: email/005.php

	.. php:method:: setTo($to)

		:param	mixed	$to: 쉼표로 구분된 문자열 또는 이메일 주소 배열
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		수신자의 이메일 주소를 설정합니다.
		이메일 주소 또는 쉼표로 구분된 이메일 목록, 이메일 배열일 수 있습니다.
		
		.. literalinclude:: email/006.php

        .. literalinclude:: email/007.php

        .. literalinclude:: email/008.php

	.. php:method:: setCC($cc)

		:param	mixed	$cc: 쉼표로 구분된 문자열 또는 이메일 주소 배열
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		CC 이메일 주소를 설정합니다. "to"\ 와 마찬가지로 이메일 주소 또는 쉼표로 구분된 이메일 목록, 이메일 배열일 수 있습니다.

	.. php:method:: setBCC($bcc[, $limit = ''])

		:param	mixed	$bcc: 쉼표로 구분된 문자열 또는 이메일 주소 배열
		:param	int	$limit: 배치당 보낼 최대 전자 메일 수
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		숨은 참조 이메일 주소를 설정합니다. ``setTo()`` 메소드와 마찬가지로 이메일 주소 또는 쉼표로 구분된 이메일 목록, 이메일 배열일 수 있습니다.

		``$limit``\ 가 설정되면 "batch mode"\ 가 활성화되어 각 배치가 지정된 ``$limit``\ 를 초과하지 않는 이메일을 배치로 보냅니다.

	.. php:method:: setSubject($subject)

		:param	string	$subject: E-mail 제목
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		이메일 제목을 설정합니다.
		
		.. literalinclude:: email/009.php

	.. php:method:: setMessage($body)

		:param	string	$body: E-mail 메시지 본문
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		이메일 메시지 본문을 설정합니다.
		
		.. literalinclude:: email/010.php

	.. php:method:: setAltMessage($str)

		:param	string	$str: 대체 이메일 메시지 본문
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		대체 이메일 메시지 본문을 설정합니다.
		
		.. literalinclude:: email/011.php

		이것은 HTML 형식의 전자 메일을 보내는 경우 사용할 수 있는 선택적 메시지 문자열입니다.
		HTML 전자 메일을 수락하지 않는 사람들을 위해 헤더 문자열에 추가되는 HTML 형식이 없는 대체 메시지를 지정할 수 있습니다.
		메시지를 설정하지 않으면 CodeIgniter는 HTML 이메일에서 메시지를 추출하고 태그를 제거합니다.

	.. php:method:: setHeader($header, $value)
		:noindex:

		:param	string	$header: Header 이름
		:param	string	$value: Header 값
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype: CodeIgniter\\Email\\Email

		이메일에 추가 헤더를 추가합니다.
		
		.. literalinclude:: email/012.php

	.. php:method:: clear($clearAttachments = false)

		:param	bool	$clearAttachments: 첨부 파일 삭제 여부
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype: CodeIgniter\\Email\\Email

		모든 이메일 변수를 빈 상태로 초기화합니다.
		이 메소드는 전자 메일 전송 방법을 루프로 실행할 때 데이터를 재설정할 수 있도록 하기 위한 것입니다.

		.. literalinclude:: email/013.php

		매개 변수를 ``true``\ 로 설정하면 첨부 파일도 지워집니다.
		
		.. literalinclude:: email/014.php

	.. php:method:: send($autoClear = true)

		:param	bool	$autoClear: 메시지 데이터 자동 삭제 여부
		:returns:	성공하면 true, 실패하면 false
		:rtype:	bool

		이메일 전송 방법. 성공 또는 실패에 따라 부울 ``true`` 또는 ``false``\ 를 반환하여 조건부로 사용할 수 있습니다.
		
		.. literalinclude:: email/015.php

		요청이 성공하면 이 메소드는 모든 매개 변수를 자동으로 삭제합니다. 이 동작을 중지하려면 false를 전달하십시오.

		.. literalinclude:: email/016.php

		.. note:: ``printDebugger()`` 메소드를 사용하려면 이메일 매개 변수를 삭제하지 않아야 합니다.

		.. note:: ``BCCBatchMode``\ 가 활성화되어 있고 ``BCCBatchSize`` 수신자가 여러 명인 경우 이 메소드는 항상 부울 ``true``\ 를 반환합니다.

	.. php:method:: attach($filename[, $disposition = ''[, $newname = null[, $mime = '']]])

		:param	string	$filename: 파일 명
		:param	string	$disposition: 첨부 파일의 '분할'. 대부분의 전자 메일 클라이언트는 여기에서 사용되는 MIME 규격에 관계없이 자체적으로 결정합니다.  https://www.iana.org/assignments/cont-disp/cont-disp.xhtml
		:param	string	$newname: 이메일에 사용할 사용자 정의 파일 이름
		:param	string	$mime: 사용할 MIME 유형(버퍼링된 데이터에 사용 가능).
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		첨부 파일을 보낼 수 있습니다. 첫 번째 매개 변수에 파일 경로 / 이름을 입력하십시오. 
		여러 파일을 첨부하려면 메소드를 여러 번 사용합니다.

		.. literalinclude:: email/017.php

		기본 분할(첨부 파일)를 사용하려면, 두 번째 매개 변수를 비워 두십시오. 
		그렇지 않으면 사용자 지정 처리를 사용하십시오.

		.. literalinclude:: email/018.php

		URL을 사용할 수도 있습니다.
		
		.. literalinclude:: email/019.php

		사용자 정의 파일 이름을 사용하려는 경우 세 번째 매개 변수를 사용합니다.
		
		.. literalinclude:: email/020.php

		실제 파일 대신 버퍼 문자열을 사용해야 하는 경우 첫 번째 매개 변수를 버퍼로, 세 번째 매개 변수를 파일 이름으로, 네 번째 매개 변수를 mime-type으로 사용할 수 있습니다.

		.. literalinclude:: email/021.php

	.. php:method:: setAttachmentCID($filename)

		:param	string	$filename: 기존 첨부 파일 이름
		:returns:	첨부 파일 Content-ID, 발견되지 않은 경우 false
		:rtype:	string

		첨부 파일의 Content-ID를 설정하고 반환하여, HTML에 인라인(이미지) 첨부 파일을 포함할 수 있습니다.
		첫 번째 매개 변수는 이미 첨부된 파일 이름이어야 합니다.

		.. literalinclude:: email/022.php

		.. note:: 고유한 이메일을 만들려면 각 이메일의 Content-ID를 다시 작성해야 합니다.

	.. php:method:: printDebugger($include = ['headers', 'subject', 'body'])

		:param	array	$include: 인쇄 할 메시지 부분
		:returns:	형식화된 디버그 데이터
		:rtype:	string

		서버 메시지, 이메일 헤더, 메시지가 포함된 문자열을 반환합니다. 
		디버깅에 유용합니다.
		
		메시지의 인쇄 할 부분을 선택적으로 지정할 수 있습니다.
		유효한 옵션 : **headers**, **subject**, **body**.

		.. literalinclude:: email/023.php

		.. note:: 기본적으로 모든 데이터가 출력됩니다.
