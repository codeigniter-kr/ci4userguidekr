인증(Authentication )
#####################################

CodeIgniter는 CodeIgniter 4용 공식 인증 및 권한 부여 프레임워크인 ref:`CodeIgniter Shield <shield>`\ 를 제공하며, 다양한 유형의 웹사이트의 요구 사항을 충족할 수 있도록 안전하고 유연하며 쉽게 확장할 수 있도록 설계되었습니다.

다음은 모듈, 프로젝트 및 프레임워크 자체 개발자 간의 일관성을 장려하기 위해 권장되는 지침입니다.

권장 지침
===============

* 로그인 및 로그아웃 작업을 처리하는 모듈은 성공시 ``login``\ 과 ``logout`` 이벤트를 트리거(trigger)합니다.
* "현재 사용자"\ 를 정의하는 모듈에 ``user_id()`` 함수를 정의하여 사용자의 고유 식별자를 반환하거나, "현재 사용자 없음"\ 에 대해 ``null``\ 을 반환해야 합니다.

이러한 권장 사항을 충족하는 모듈은 **composer.json**\ 에 다음 항목을 추가하여 호환성을 나타낼 수 있습니다.

::

    "provide": {
        "codeigniter4/authentication-implementation": "1.0"
    },

이 구현을 제공하는 모듈 목록을 `Packagist <https://packagist.org/providers/codeigniter4/authentication-implementation>`_\ 에서 검색할 수 있습니다.