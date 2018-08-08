###################
Security Guidelines
###################

We take security seriously.
CodeIgniter incorporates a number of features and techniques to either enforce
good security practices, or to enable you to do so easily.
우리는 보안을 진지하게 생각합니다. CodeIgniter는 여러 가지 기능과 기술을 통합하여 훌륭한 보안 관행을 시행하거나 그렇게 쉽게 수행 할 수 있도록합니다.

We respect the `Open Web Application Security Project (OWASP) <https://www.owasp.org>`_
and follow their recommendations as much as possible.
우리는 OWASP (Open Web Application Security Project)를 존중 하고 권장 사항을 최대한 준수합니다.

The following comes from
`OWASP Top Ten Cheat Sheet <https://www.owasp.org/index.php/OWASP_Top_Ten_Cheat_Sheet>`_,
identifying the top vulnerabilities for web applications.
For each, we provide a brief description, the OWASP recommendations, and then
the CodeIgniter provisions to address the problem.
다음은 OWASP Top Ten Cheat Sheet 에서 발췌 한 것으로, 웹 애플리케이션의 가장 큰 취약점을 확인합니다. 각각에 대해 간략한 설명, OWASP 권장 사항 및 문제 해결을위한 CodeIgniter 조항을 제공합니다.

************
A1 Injection
************

An injection is the inappropriate insertion of partial or complete data via
the input data from the client to the application. Attack vectors include SQL,
XML, ORM, code & buffer overflows.
주입은 클라이언트에서 응용 프로그램으로의 입력 데이터를 통해 부분 또는 전체 데이터의 부적절한 삽입입니다. 공격 벡터에는 SQL, XML, ORM, 코드 및 버퍼 오버플로가 포함됩니다.

OWASP recommendations
---------------------

- Presentation: set correct content type, character set & locale
                올바른 컨텐츠 유형, 문자 세트 및 로켈 설정
- Submission: validate fields and provide feedback
              필드의 유효성을 검증하고 의견을 제공하십시오.
- Controller: sanitize input; positive input validation using correct character set
              입력을 살균합니다. 올바른 문자 세트를 사용한 양수 입력 검증
- Model: parameterized queries
         매개 변수가있는 쿼리

CodeIgniter provisions
----------------------

- `HTTP library <../libraries/message.html>`_ provides for input field filtering & content metadata
  입력란 필터링 및 콘텐츠 메타 데이터를 제공하는 HTTP 라이브러리
- Form validation library
  양식 유효성 검사 라이브러리

*********************************************
A2 Weak authentication and session management
*********************************************

Inadequate authentication or improper session management can lead to a user
getting more privileges than they are entitled to.
부적절한 인증 또는 부적절한 세션 관리로 인해 사용자는 권한보다 많은 권한을 얻을 수 있습니다.

OWASP recommendations
---------------------

- Presentation: validate authentication & role; send CSRF token with forms
                인증 및 역할 확인; 폼과 함께 CSRF 토큰 보내기
- Design: only use built-in session management
          기본 제공되는 세션 관리 만 사용하십시오
- Controller: validate user, role, CSRF token
              사용자, 역할, CSRF 토큰 유효성 검사
- Model: validate role
         역할 확인
- Tip: consider the use of a request governor
       요청 거버너 사용 고려

CodeIgniter provisions
----------------------

- `Session <../libraries/sessions.html>`_ library
  세션 라이브러리
- `HTTP library <../libraries/message.html>`_ provides for CSRF validation
  CSRF 검증을위한 HTTP 라이브러리 제공
- Easy to add third party authentication
  타사 인증을 쉽게 추가 할 수 있습니다.

*****************************
A3 Cross Site Scripting (XSS)
*****************************

Insufficient input validation where one user can add content to a web site
that can be malicious when viewed by other users to the web site.
한 사용자가 다른 사용자가 웹 사이트를 볼 때 악의적 인 콘텐츠를 웹 사이트에 추가 할 수있는 입력 검증이 충분하지 않습니다.

OWASP recommendations
---------------------

- Presentation: output encode all user data as per output context; set input constraints
                출력 컨텍스트에 따라 모든 사용자 데이터를 출력 인코딩합니다. 입력 제한을 설정하십시오.
- Controller: positive input validation
              긍정적인 입력 유효성 검사
- Tips: only process trustworthy data; do not store data HTML encoded in DB
        신뢰할 수있는 데이터 만 처리하십시오. DB에 인코딩 된 HTML 데이터를 저장하지 않습니다.

CodeIgniter provisions
----------------------

- esc function
- Form validation library

***********************************
A4 Insecure Direct Object Reference
***********************************

Insecure Direct Object References occur when an application provides direct
access to objects based on user-supplied input. As a result of this vulnerability
attackers can bypass authorization and access resources in the system directly,
for example database records or files.
안전하지 않은 직접 객체 참조는 응용 프로그램이 사용자가 입력 한 내용을 기반으로 객체에 대한 직접 액세스를 제공 할 때 발생합니다. 이 취약점으로 인해 공격자는 시스템의 권한 (예 : 데이터베이스 레코드 또는 파일)을 직접 무시할 수 있습니다.

OWASP recommendations
---------------------

- Presentation: don't expose internal data; use random reference maps
                내부 데이터를 공개하지 마십시오. 무작위 참조지도 사용
- Controller: obtain data from trusted sources or random reference maps
              신뢰할 수있는 소스 또는 임의의 참조 맵에서 데이터를 가져옵니다.
- Model: validate user roles before updating data
         데이터를 업데이트하기 전에 사용자 역할 유효성 검사

CodeIgniter provisions
----------------------

- Form validation library
- Easy to add third party authentication

****************************
A5 Security Misconfiguration
****************************

Improper configuration of an application architecture can lead to mistakes
that might compromise the security of the whole architecture.
응용 프로그램 아키텍처의 부적절한 구성으로 인해 실수가 발생하여 전체 아키텍처의 보안이 손상 될 수 있습니다.

OWASP recommendations
---------------------

- Presentation: harden web and application servers; use HTTP strict transport security
                웹 및 응용 프로그램 서버 강화; HTTP 엄격한 전송 보안 사용
- Controller: harden web and application servers; protect your XML stack
              웹 및 응용 프로그램 서버 강화; XML 스택 보호
- Model: harden database servers
         데이터베이스 서버 강화

CodeIgniter provisions
----------------------

- Sanity checks during bootstrap

**************************
A6 Sensitive Data Exposure
**************************

Sensitive data must be protected when it is transmitted through the network.
Such data can include user credentials and credit cards. As a rule of thumb,
if data must be protected when it is stored, it must be protected also during
transmission.
민감한 데이터는 네트워크를 통해 전송 될 때 보호되어야합니다. 이러한 데이터에는 사용자 자격 증명 및 신용 카드가 포함될 수 있습니다. 일반적으로 데이터를 저장할 때 보호해야하는 경우 데이터를 전송 중에 보호해야합니다.

OWASP recommendations
---------------------

- Presentation: use TLS1.2; use strong ciphers and hashes; do not send keys or hashes to browser
                TLS1.2 사용; 강력한 암호와 해시를 사용하십시오. 브라우저에 키나 해시를 보내지 마라.
- Controller: use strong ciphers and hashes
              강력한 암호 및 해시 사용
- Model: mandate strong encrypted communications with servers
         서버와의 강력한 암호화된 통신을 위임합니다.

CodeIgniter provisions
----------------------

- Session keys stored encrypted
  암호화 된 세션 키 저장

****************************************
A7 Missing Function Level Access Control
****************************************

Sensitive data must be protected when it is transmitted through the network.
Such data can include user credentials and credit cards. As a rule of thumb,
if data must be protected when it is stored, it must be protected also during
transmission.
민감한 데이터는 네트워크를 통해 전송 될 때 보호되어야합니다. 이러한 데이터에는 사용자 자격 증명 및 신용 카드가 포함될 수 있습니다. 일반적으로 데이터를 저장할 때 보호해야하는 경우 데이터를 전송 중에 보호해야합니다.

OWASP recommendations
---------------------

- Presentation: ensure that non-web data is outside the web root; validate users and roles; send CSRF tokens
                웹 이외의 데이터가 웹 루트 외부에 있는지 확인합니다. 사용자와 역할의 유효성을 검사한다. CSRF 토큰을 보내라.
- Controller: validate users and roles; validate CSRF tokens
              사용자 및 역할의 유효성을 검사합니다. CSRF 토큰 검증
- Model: validate roles
         역할 검증

CodeIgniter provisions
----------------------

- Public folder, with application and system outside
  응용 프로그램 및 시스템이있는 공용 폴더
- `HTTP library <../libraries/message.html>`_ provides for CSRF validation
  CSRF 검증을위한 HTTP 라이브러리 제공

************************************
A8 Cross Site Request Forgery (CSRF)
************************************

CSRF is an attack that forces an end user to execute unwanted actions on a web
application in which he/she is currently authenticated.
CSRF는 최종 사용자가 현재 인증 된 웹 응용 프로그램에서 원치 않는 작업을 강제로 수행하는 공격입니다.

OWASP recommendations
---------------------

- Presentation: validate users and roles; send CSRF tokens
                사용자와 역할의 유효성을 검사합니다. CSRF 토큰 전송.
- Controller: validate users and roles; validate CSRF tokens
              사용자 및 역할의 유효성을 검사합니다. CSRF 토큰 검증
- Model: validate roles
         역할 검증

CodeIgniter provisions
----------------------

- `HTTP library <../libraries/message.html>`_ provides for CSRF validation
  CSRF 검증을위한 HTTP 라이브러리 제공

**********************************************
A9 Using Components with Known Vulnerabilities
**********************************************

Many applications have known vulnerabilities and known attack strategies that
can be exploited in order to gain remote control or to exploit data.
많은 응용 프로그램은 원격 제어를 얻거나 데이터를 악용하기 위해 악용 될 수있는 알려진 취약성 및 알려진 공격 방법을 알고 있습니다.

OWASP recommendations
---------------------

- Don't use any of these
  이 중 하나를 사용하지 마십시오.

CodeIgniter provisions
----------------------

- 통합된 서드파티 라이브러리는 반드시 심사를 통과해야 합니다.

**************************************
A10 Unvalidated Redirects and Forwards
**************************************

Faulty business logic or injected actionable code could redirect the user
inappropriately.
잘못된 비즈니스 로직이나 삽입 된 실행 가능한 코드로 인해 사용자가 부적절하게 리디렉션 될 수 있습니다.

OWASP recommendations
---------------------

- Presentation: don't use URL redirection; use random indirect references
                URL 리디렉션을 사용하지 않습니다. 무작위 간접 참조 사용
- Controller: don't use URL redirection; use random indirect references
              URL 리디렉션을 사용하지 않습니다. 무작위 간접 참조 사용
- Model: validate roles
         역할 검증

CodeIgniter provisions
----------------------

- `HTTP library <../libraries/message.html>`_ provides for ...
- `Session <../libraries/sessions.html>`_ library provides flashdata
  세션 라이브러리는 플래시 데이터를 제공합니다

