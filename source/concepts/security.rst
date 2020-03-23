###################
보안 지침
###################

We take security seriously.
CodeIgniter incorporates a number of features and techniques to either enforce good security practices, or to enable you to do so easily.

We respect the `Open Web Application Security Project (OWASP) <https://owasp.org>`_ and follow their recommendations as much as possible.

The following comes from `OWASP Top Ten Cheat Sheet <https://www.owasp.org/www-project-top-ten/>`_, identifying the top vulnerabilities for web applications.
For each, we provide a brief description, the OWASP recommendations, and then the CodeIgniter provisions to address the problem.

우리는 보안을 중요하게 생각합니다.
CodeIgniter에는 올바른 보안 관행을 적용하거나 사용자가 쉽게 수행할 수 있도록 다양한 기능과 기술이 통합되어 있습니다.

우리는 `Open Web Application Security Project (OWASP) <https://owasp.org>`_\ 를 존중하며, 가능한 한 그들의 권고를 따릅니다.

다음은 `OWASP Top Ten Cheat Sheet <https://www.owasp.org/www-project-top-ten/>`_\ 에서 발췌한 것으로 웹 어플리케이션의 주요 취약점입니다.
각 항목에 대해 간략한 설명, OWASP 권장 사항과 문제를 해결하기 위한 CodeIgniter 규정을 제공합니다.

*******************
A1 주입(Injection)
*******************

주입(Injection)은 클라이언트에서 애플리케이션으로 입력 데이터를 통해 부분 또는 전체 데이터를 부적절하게 삽입하는 것입니다. 
공격 벡터에는 SQL, XML, ORM, code와 버퍼 오버플로우가 포함됩니다.

OWASP 추천 사항
---------------------

- 프레젠테이션: 올바른 콘텐츠 유형, 문자 집합과 로케일을 설정합니다.
- 제출: 필드를 확인하고 피드백을 제공합니다.
- 컨트롤러: 입력을 정리합니다. 올바른 문자 집합을 사용하여 입력 유효성을 검사합니다.
- 모델: 매개 변수화된 쿼리사용

CodeIgniter 규약
----------------------

- `HTTP 라이브러리 <../ incoming / incomingrequest.html>`_\ 는 입력 필드 필터링 및 컨텐츠 메타데이터를 제공합니다.
- 폼 검증 라이브러리 제공

*********************************************
A2 약한(Weak) 인증과 세션 관리
*********************************************

인증이 잘못되거나 세션 관리가 잘못되면 사용자에게 부여된 권한보다 더 많은 권한을 부여될 수 있습니다.

OWASP 추천 사항
---------------------

- Presentation: validate authentication & role; send CSRF token with forms
- Design: only use built-in session management
- Controller: validate user, role, CSRF token
- Model: validate role
- Tip: consider the use of a request governor

CodeIgniter 규약
----------------------

- `Session <../libraries/sessions.html>`_ library
- `HTTP library <../incoming/incomingrequest.html>`_ provides for CSRF validation
- Easy to add third party authentication

*****************************
A3 Cross Site Scripting (XSS)
*****************************

Insufficient input validation where one user can add content to a web site
that can be malicious when viewed by other users to the web site.

OWASP recommendations
---------------------

- Presentation: output encode all user data as per output context; set input constraints
- Controller: positive input validation
- Tips: only process trustworthy data; do not store data HTML encoded in DB

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

OWASP recommendations
---------------------

- Presentation: don't expose internal data; use random reference maps
- Controller: obtain data from trusted sources or random reference maps
- Model: validate user roles before updating data

CodeIgniter provisions
----------------------

- Form validation library
- Easy to add third party authentication

****************************
A5 Security Misconfiguration
****************************

Improper configuration of an application architecture can lead to mistakes
that might compromise the security of the whole architecture.

OWASP recommendations
---------------------

- Presentation: harden web and application servers; use HTTP strict transport security
- Controller: harden web and application servers; protect your XML stack
- Model: harden database servers

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

OWASP recommendations
---------------------

- Presentation: use TLS1.2; use strong ciphers and hashes; do not send keys or hashes to browser
- Controller: use strong ciphers and hashes
- Model: mandate strong encrypted communications with servers

CodeIgniter provisions
----------------------

- Session keys stored encrypted

****************************************
A7 Missing Function Level Access Control
****************************************

Sensitive data must be protected when it is transmitted through the network.
Such data can include user credentials and credit cards. As a rule of thumb,
if data must be protected when it is stored, it must be protected also during
transmission.

OWASP recommendations
---------------------

- Presentation: ensure that non-web data is outside the web root; validate users and roles; send CSRF tokens
- Controller: validate users and roles; validate CSRF tokens
- Model: validate roles

CodeIgniter provisions
----------------------

- Public folder, with application and system outside
- `HTTP library <../incoming/incomingrequest.html>`_ provides for CSRF validation

************************************
A8 Cross Site Request Forgery (CSRF)
************************************

CSRF is an attack that forces an end user to execute unwanted actions on a web
application in which he/she is currently authenticated.

OWASP recommendations
---------------------

- Presentation: validate users and roles; send CSRF tokens
- Controller: validate users and roles; validate CSRF tokens
- Model: validate roles

CodeIgniter provisions
----------------------

- `HTTP library <../incoming/incomingrequest.html>`_ provides for CSRF validation

**********************************************
A9 Using Components with Known Vulnerabilities
**********************************************

Many applications have known vulnerabilities and known attack strategies that
can be exploited in order to gain remote control or to exploit data.

OWASP recommendations
---------------------

- Don't use any of these

CodeIgniter provisions
----------------------

- Third party libraries incorporated must be vetted

**************************************
A10 Unvalidated Redirects and Forwards
**************************************

Faulty business logic or injected actionable code could redirect the user
inappropriately.

OWASP recommendations
---------------------

- Presentation: don't use URL redirection; use random indirect references
- Controller: don't use URL redirection; use random indirect references
- Model: validate roles

CodeIgniter provisions
----------------------

- `HTTP library <../incoming/incomingrequest.html>`_ provides for ...
- `Session <../libraries/sessions.html>`_ library provides flashdata
