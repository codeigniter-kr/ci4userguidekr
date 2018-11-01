###########
Email Class
###########

CodeIgniter's robust Email Class supports the following features:
CodeIgniter의 강력한 이메일 클래스는 다음 기능을 지원합니다.

-  Multiple Protocols: Mail, Sendmail, and SMTP
-  SMTP 용 TLS 및 SSL 암호화
-  Multiple recipients
-  참조 및 숨은 참조
-  HTML 또는 일반 텍스트
-  첨부 파일
-  Word wrapping
-  Priorities
-  BCC Batch Mode, enabling large email lists to be broken into small
   BCC batches. 대량 메일 목록을 작은 숨은 참조 일괄 처리로 분할 할 수있는 BCC 일괄 처리 모드.
-  Email Debugging tools

.. contents::
    :local:
    :depth: 2

.. raw:: html

  <div class="custom-index container"></div>

***********************
Email Library 사용
***********************

이메일 보내기
=============

Sending email is not only simple, but you can configure it on the fly or
set your preferences in the **application/Config/Email.php** file.
전자 메일을 보내는 것은 단순하지 않을뿐만 아니라 즉시 구성하거나 **application/Config/Email.php** 파일 에서 기본 설정을 구성 할 수 있습니다 .

Here is a basic example demonstrating how you might send email
다음은 이메일을 보내는 방법을 보여주는 기본 예입니다.

::

	$email = \Config\Services::email();

	$email->setFrom('your@example.com', 'Your Name');
	$email->setTo('someone@example.com');
	$email->setCC('another@another-example.com');
	$email->setBCC('them@their-example.com');

	$email->setSubject('Email Test');
	$email->setMessage('Testing the email class.');

	$email->send();

Email 기본 설정
===============

There are 21 different preferences available to tailor how your email
messages are sent. You can either set them manually as described here,
or automatically via preferences stored in your config file, described
below:
이메일 메시지를 보내는 방법을 조정할 수있는 21 가지 기본 설정이 있습니다. 여기에 설명 된대로 수동으로 설정하거나 아래에 설명 된 구성 파일에 저장된 환경 설정을 통해 자동으로 설정할 수 있습니다.

Preferences are set by passing an array of preference values to the
email initialize method. Here is an example of how you might set some
preferences
기본 설정은 기본 설정 값 배열을 전자 메일 초기화 메서드에 전달하여 설정합니다. 다음은 몇 가지 기본 설정을 지정하는 방법의 예입니다.

::

	$config['protocol'] = 'sendmail';
	$config['mailPath'] = '/usr/sbin/sendmail';
	$config['charset']  = 'iso-8859-1';
	$config['wordWrap'] = true;

	$email->initialize($config);

.. note:: Most of the preferences have default values that will be used
	if you do not set them.
	대부분의 기본 설정에는 사용자가 설정하지 않을 경우 사용되는 기본값이 있습니다.

Config 파일을 통한 Email 기본 설정
----------------------------------

If you prefer not to set preferences using the above method, you can
instead put them into the config file. Simply open the
**application/Config/Email.php** file, and set your configs in the
Email properties. Then save the file and it will be used automatically.
You will NOT need to use the ``$email->initialize()`` method if
you set your preferences in the config file.
위의 방법을 사용하여 환경 설정을하지 않으려면 환경 설정 파일에 넣을 수 있습니다. 간단하게 **application/Config/Email.php** 파일을 열어서 Email 속성에서 config를 설정하십시오. 그런 다음 파일을 저장하면 자동으로 사용됩니다. ``$email->initialize()`` 설정 파일에서 환경 설정 을하면이 방법 을 사용할 필요가 없습니다 .

Email 설정
==========

The following is a list of all the preferences that can be set when
sending email.
다음은 이메일을 보낼 때 설정할 수있는 모든 환경 설정 목록입니다.

=================== ====================== ============================ =======================================================================
Preference          Default Value          Options                      Description
=================== ====================== ============================ =======================================================================
**userAgent**       CodeIgniter            None                         "user agent".
**protocol**        mail                   mail, sendmail, or smtp      메일 전송 프로토콜.
**mailpath**        /usr/sbin/sendmail     None                         Sendmail에 대한 서버 경로.
**SMTPHost**        No Default             None                         SMTP 서버 주소.
**SMTPUser**        No Default             None                         SMTP Username.
**SMTPPass**        No Default             None                         SMTP Password.
**SMTPPort**        25                     None                         SMTP Port.
**SMTPTimeout**     5                      None                         SMTP Timeout (in seconds).
**SMTPKeepAlive**   FALSE                  TRUE or FALSE (boolean)      ESMTP 영구연결.
**SMTPCrypto**      No Default             tls or ssl                   SMTP Encryption
**wordWrap**        TRUE                   TRUE or FALSE (boolean)      Enable word-wrap.
**wrapChars**       76                                                  Character count to wrap at.
**mailType**        text                   text or html                 Type of mail. If you send HTML email you must send it as a complete web
                                                                        page. Make sure you don't have any relative links or relative image
                                                                        paths otherwise they will not work.
                                                                        메일 유형. HTML 이메일을 보내려면 완전한 웹 페이지로 보내야합니다. 상대 링크 나 상대 이미지 경로가 없는지 확인하십시오. 그렇지 않으면 작동하지 않습니다.
**charset**         utf-8                                               Character set (utf-8, iso-8859-1, etc.).
**validate**        TRUE                   TRUE or FALSE (boolean)      전자 메일 주소의 유효성 검사 여부.
**priority**        3                      1, 2, 3, 4, 5                이메일 우선 순위. 1 = highest. 5 = lowest. 3 = normal.
**CRLF**            \\n                    "\\r\\n" or "\\n" or "\\r"   Newline character. (Use "\\r\\n" to comply with RFC 822).
**newline**         \\n                    "\\r\\n" or "\\n" or "\\r"   Newline character. (Use "\\r\\n" to comply with RFC 822).
**BCCBatchMode**    FALSE                  TRUE or FALSE (boolean)      BCC 배치모드 사용 여부.
**BCCBatchSize**    200                    None                         Number of emails in each BCC batch. BCC 배치 처리시 이메일 수
**DSN**             FALSE                  TRUE or FALSE (boolean)      서버 알림 메시지 사용 여부.
=================== ====================== ============================ =======================================================================

Overriding Word Wrapping
========================

If you have word wrapping enabled (recommended to comply with RFC 822)
and you have a very long link in your email it can get wrapped too,
causing it to become un-clickable by the person receiving it.
CodeIgniter lets you manually override word wrapping within part of your
message like this
자동 줄 바꿈을 사용하도록 설정 한 경우 (RFC 822 준수를 권장 함) 이메일에 매우 긴 링크가 있으면 포장을해도받을 수 있으므로 수신자가 클릭 할 수 없게됩니다. CodeIgniter를 사용하면 다음과 같이 메시지의 일부분에서 수동으로 자동 줄 바꿈을 무시할 수 있습니다.

::

	The text of your email that
	gets wrapped normally.

	{unwrap}http://example.com/a_long_link_that_should_not_be_wrapped.html{/unwrap}

	More text that will be
	wrapped normally.


Place the item you do not want word-wrapped between: {unwrap} {/unwrap}
{unwrap} {/unwrap} 사이에 자동 줄 바꿈하지 않을 항목을 배치하십시오. 

***************
Class Reference
***************

.. php:class:: CodeIgniter\\Email\\Email

	.. php:method:: setFrom($from[, $name = ''[, $returnPath = null]])

		:param	string	$from: "From" e-mail address
		:param	string	$name: "From" display name
		:param	string	$returnPath: Optional email address to redirect undelivered e-mail to
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		Sets the email address and name of the person sending the email
		이메일을 보내는 사람의 전자 메일 주소 및 이름을 설정합니다.
		
		::

			$email->setFrom('you@example.com', 'Your Name');

		You can also set a Return-Path, to help redirect undelivered mail
		배달되지 않은 메일을 리디렉션하는 데 도움이되도록 Return-Path를 설정할 수도 있습니다.
		
		::

			$email->setFrom('you@example.com', 'Your Name', 'returned_emails@example.com');

		.. note:: Return-Path can't be used if you've configured 'smtp' as
			your protocol.
			'smtp' 프로토콜로 구성한 경우 Return-Path를 사용할 수 없습니다.

	.. php:method:: setReplyTo($replyto[, $name = ''])

		:param	string	$replyto: E-mail address for replies
		:param	string	$name: Display name for the reply-to e-mail address
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		Sets the reply-to address. If the information is not provided the
		information in the `setFrom <#setFrom>`_ method is used. Example
		회신 주소를 설정합니다. 설정되지 않으면 `setFrom <#setFrom>`_ 메소드로 설정한 정보를 사용합니다.
		::

			$email->setReplyTo('you@example.com', 'Your Name');

	.. php:method:: setTo($to)

		:param	mixed	$to: Comma-delimited string or an array of e-mail addresses
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		Sets the email address(s) of the recipient(s). Can be a single e-mail,
		a comma-delimited list or an array
		수신자의 전자 메일 주소를 설정합니다. 단일 전자 메일, 쉼표로 구분 된 목록 또는 배열 일 수 있습니다.
		
		::

			$email->setTo('someone@example.com');

		::

			$email->setTo('one@example.com, two@example.com, three@example.com');

		::

			$email->setTo(['one@example.com', 'two@example.com', 'three@example.com']);

	.. php:method:: setCC($cc)

		:param	mixed	$cc: Comma-delimited string or an array of e-mail addresses
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		Sets the CC email address(s). Just like the "to", can be a single e-mail,
		a comma-delimited list or an array.
		참조 전자 메일 주소를 설정합니다. "to"와 마찬가지로 하나의 전자 메일, 쉼표로 구분 된 목록 또는 배열 일 수 있습니다.

	.. php:method:: setBCC($bcc[, $limit = ''])

		:param	mixed	$bcc: Comma-delimited string or an array of e-mail addresses
		:param	int	$limit: Maximum number of e-mails to send per batch
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		Sets the BCC email address(s). Just like the ``setTo()`` method, can be a single
		e-mail, a comma-delimited list or an array.
		BCC 전자 메일 주소를 설정합니다. ``setTo()`` 메서드 와 마찬가지로 하나의 전자 메일, 쉼표로 구분 된 목록 또는 배열 일 수 있습니다.

		If ``$limit`` is set, "batch mode" will be enabled, which will send
		the emails to batches, with each batch not exceeding the specified
		``$limit``.
		``$limit`` 옵션이 설정되면 "일괄처리 모드" 가 활성화되며 지정된 ``$limit`` 수를 초과하지 않는 상태로 전자 메일을 일괄로 보냅니다.

	.. php:method:: setSubject($subject)

		:param	string	$subject: E-mail subject line
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		Sets the email subject
		이메일 제목을 설정합니다.
		::

			$email->setSubject('This is my subject');

	.. php:method:: setMessage($body)

		:param	string	$body: E-mail message body
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		Sets the e-mail message body
		전자 메일 메시지 본문을 설정합니다.
		::

			$email->setMessage('This is my message');

	.. php:method:: setAltMessage($str)

		:param	string	$str: Alternative e-mail message body
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		Sets the alternative e-mail message body
		대체 전자 메일 메시지 본문을 설정합니다.
		::

			$email->setAltMessage('This is the alternative message');

		This is an optional message string which can be used if you send
		HTML formatted email. It lets you specify an alternative message
		with no HTML formatting which is added to the header string for
		people who do not accept HTML email. If you do not set your own
		message CodeIgniter will extract the message from your HTML email
		and strip the tags.
		이것은 HTML 형식의 전자 메일을 보내는 경우 사용할 수있는 선택적 메시지 문자열입니다. HTML 메일을 수락하지 않는 사람들을 위해 헤더 문자열에 추가되는 HTML 형식이없는 대체 메시지를 지정할 수 있습니다. 자신의 메시지를 설정하지 않으면 CodeIgniter는 HTML 전자 메일에서 메시지를 추출하고 태그를 제거합니다.

	.. php:method:: setHeader($header, $value)

		:param	string	$header: Header name
		:param	string	$value: Header value
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype: CodeIgniter\\Email\\Email

		Appends additional headers to the e-mail
		추가 헤더를 전자 메일에 추가합니다.
		::

			$email->setHeader('Header1', 'Value1');
			$email->setHeader('Header2', 'Value2');

	.. php:method:: clear($clearAttachments = false)

		:param	bool	$clearAttachments: Whether or not to clear attachments
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype: CodeIgniter\\Email\\Email

		Initializes all the email variables to an empty state. This method
		is intended for use if you run the email sending method in a loop,
		permitting the data to be reset between cycles.
		모든 전자 메일 변수를 빈 상태로 초기화합니다. 이 방법은 루프에서 전자 메일 전송 방법을 실행하여주기간에 데이터를 다시 설정할 수 있도록하는 용도로 사용됩니다.

		::

			foreach ($list as $name => $address)
			{
				$email->clear();

				$email->setTo($address);
				$email->setFrom('your@example.com');
				$email->setSubject('Here is your info '.$name);
				$email->setMessage('Hi ' . $name . ' Here is the info you requested.');
				$email->send();
			}

		If you set the parameter to TRUE any attachments will be cleared as
		well
		매개 변수를 TRUE로 설정하면 첨부 파일도 지워집니다.
		
		::

			$email->clear(true);

	.. php:method:: send($autoClear = true)

		:param	bool	$autoClear: Whether to clear message data automatically
		:returns:	TRUE on success, FALSE on failure
		:rtype:	bool

		The e-mail sending method. Returns boolean TRUE or FALSE based on
		success or failure, enabling it to be used conditionally
		전자 메일 전송 방법입니다. 성공 또는 실패를 기준으로 부울 TRUE 또는 FALSE를 반환하여 조건부로 사용할 수있게합니다.
		::

			if (! $email->send())
			{
				// Generate error
			}

		This method will automatically clear all parameters if the request was
		successful. To stop this behaviour pass FALSE
		이 메소드는 요청이 성공한 경우 모든 매개 변수를 자동으로 지 웁니다. 이 동작을 중지하려면 FALSE를 전달하십시오.
		::

			if ($email->send(false))
			{
				// Parameters won't be cleared
			}

		.. note:: In order to use the ``printDebugger()`` method, you need
			to avoid clearing the email parameters.
			``printDebugger()`` 메소드를 사용 하려면 이메일 매개 변수를 지우지 않아야합니다.

		.. note:: If ``BCCBatchMode`` is enabled, and there are more than
			``BCCBatchSize`` recipients, this method will always return
			boolean ``TRUE``.
			``BCCBatchMode`` 를 사용할 경우, ``BCCBatchSize`` 이상의 수신자가 있다면, 이 메소드는 항상 ``TRUE`` 를 반환합니다.
			
	.. php:method:: attach($filename[, $disposition = ''[, $newname = null[, $mime = '']]])

		:param	string	$filename: File name
		:param	string	$disposition: 'disposition' of the attachment. Most
			email clients make their own decision regardless of the MIME
			specification used here. https://www.iana.org/assignments/cont-disp/cont-disp.xhtml
		:param	string	$newname: Custom file name to use in the e-mail
		:param	string	$mime: MIME type to use (useful for buffered data)
		:returns:	CodeIgniter\\Email\\Email instance (method chaining)
		:rtype:	CodeIgniter\\Email\\Email

		Enables you to send an attachment. Put the file path/name in the first
		parameter. For multiple attachments use the method multiple times.
		For example
		첨부 파일을 보낼 수 있습니다. 첫 번째 매개 변수에 파일 경로/이름을 입력하십시오. 여러 첨부 파일의 경우이 메소드를 여러 번 사용하십시오.
		
		::

			$email->attach('/path/to/photo1.jpg');
			$email->attach('/path/to/photo2.jpg');
			$email->attach('/path/to/photo3.jpg');

		To use the default disposition (attachment), leave the second parameter blank,
		otherwise use a custom disposition
		기본 처분 (첨부)을 사용하려면 두 번째 매개 변수를 비워 두거나 그렇지 않으면 맞춤 처분을 사용하십시오. 
		
		::

			$email->attach('image.jpg', 'inline');

		You can also use a URL
		URL을 사용할 수도 있습니다.
		
		::

			$email->attach('http://example.com/filename.pdf');

		If you'd like to use a custom file name, you can use the third parameter
		사용자 정의 파일 이름을 사용하려면 세 번째 매개 변수를 사용할 수 있습니다.
		
		::

			$email->attach('filename.pdf', 'attachment', 'report.pdf');

		If you need to use a buffer string instead of a real - physical - file you can
		use the first parameter as buffer, the third parameter as file name and the fourth
		parameter as mime-type
		실제 물리 파일 대신 버퍼 문자열을 사용해야하는 경우 첫 번째 매개 변수를 버퍼로 사용할 수 있으며 세 번째 매개 변수는 파일 이름으로 네 번째 매개 변수는 mime-type으로 사용할 수 있습니다.
		
		::

			$email->attach($buffer, 'attachment', 'report.pdf', 'application/pdf');

	.. php:method:: setAttachmentCID($filename)

		:param	string	$filename: Existing attachment filename
		:returns:	Attachment Content-ID or FALSE if not found
		:rtype:	string

		Sets and returns an attachment's Content-ID, which enables your to embed an inline
		(picture) attachment into HTML. First parameter must be the already attached file name.
		HTML에 인라인 (그림) 첨부 파일을 포함시킬 수있는 첨부 파일의 Content-ID를 설정하고 반환합니다. 첫 번째 매개 변수는 이미 첨부 된 파일 이름이어야합니다.
		
		::

			$filename = '/img/photo1.jpg';
			$email->attach($filename);
			foreach ($list as $address)
			{
				$email->setTo($address);
				$cid = $email->setAttachmentCID($filename);
				$email->setMessage('<img src="cid:'. $cid .'" alt="photo1" />');
				$email->send();
			}

		.. note:: Content-ID for each e-mail must be re-created for it to be unique.
		각 전자 메일의 Content-ID는 고유하게하기 위해 다시 만들어야합니다.

	.. php:method:: printDebugger($include = ['headers', 'subject', 'body'])

		:param	array	$include: Which parts of the message to print out
		:returns:	Formatted debug data
		:rtype:	string

		Returns a string containing any server messages, the email headers, and
		the email message. Useful for debugging.
		서버 메시지, 전자 메일 헤더 및 전자 메일 메시지가 포함 된 문자열을 반환합니다. 디버깅에 유용합니다.

		You can optionally specify which parts of the message should be printed.
		Valid options are: **headers**, **subject**, **body**.
		인쇄 할 메시지의 부분을 선택적으로 지정할 수 있습니다. 유효한 옵션은 **헤더**, **제목**, **본문** 입니다.

		Example::

			// You need to pass FALSE while sending in order for the email data
			// to not be cleared - if that happens, printDebugger() would have
			// nothing to output.
			$email->send(false);

			// Will only print the email headers, excluding the message subject and body
			$email->printDebugger(['headers']);

		.. note:: By default, all of the raw data will be printed.
		기본적으로 모든 원시 데이터가 인쇄됩니다.
