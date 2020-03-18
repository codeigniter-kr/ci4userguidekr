인증(Authentication )
#####################################

CodeIgniter intentionally does not provide an internal authentication or authorization class. 
There are a number of great third-party modules that provide these services, as well as resources in the community for writing your own. 
The following are recommended guidelines to encourage consistency among developers of modules, projects, and the framework itself.

CodeIgniter는 의도적으로 내부 인증 또는 권한 부여 클래스를 제공하지 않습니다. 
커뮤니티에는 이러한 서비스를 제공하는 우수한 타사 모듈(third-party module) 및 사용자 자신의 서비스를 작성하는 데 필요한 리소스가 많이 있습니다. 
다음은 모듈, 프로젝트, 프레임워크 자체 간의 일관성을 높이기 위한 개발자 권장 지침입니다.

권장 지침
===============

* Modules that handle login and logout operations should trigger the ``login`` and ``logout`` Events when successful
* Modules that define a "current user" should define the function ``user_id()`` to return the user's unique identifier, or ``null`` for "no current user"

* 로그인 및 로그아웃 작업을 처리하는 모듈은 성공 시 ``login``\ 과 ``logout`` 이벤트를 트리거(trigger)해야 합니다.
* "current user"\ 를 정의하는 모듈은 ``user_id()`` 기능을 정의하여 사용자의 고유 식별자를 반환하거나 "no current user"\ 에 대해 ``null``\ 을 반환해야 합니다.