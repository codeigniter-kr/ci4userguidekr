수동 설치
###############################################################################

`CodeIgniter 4 framework <https://github.com/codeigniter4/framework>`_  프레임워크 레파지토리에는 
릴리스된 버전의 프레임워크가 있으며, 이는 Composer를 사용하지 않으려는 개발자를 위한 것입니다.

``app`` 폴더안에서 앱을 개발하고, ``public`` 폴더는 웹 루트(root)가 됩니다. 
``system`` 폴더안에 있는 내용은 변경하지 마십시오!

.. note:: 이 방법은 `CodeIgniter 3 <https://www.codeigniter.com/user_guide/installation/index.html>`_\ 의 설치 방법과 비슷한 설치 방법입니다. 

설치 방법
=============

`최신 버전 <https://github.com/CodeIgniter4/framework/releases/latest>`_\ 을 다운로드하고 프로젝트 
루트(root)에 압축을 풀어주십시오.

설정
----------

없음

업그레이드
--------------

프레임워크의 새 사본을 다운로드한 다음, 릴리스 통지(notice) 또는 변경 로그(changelog)의 
업그레이드 지침에 따라 이를 프로젝트와 병합하십시오.

일반적으로 ``system`` 폴더를 교체하고 지정된 ``app/Config`` 폴더에서 영향을 받는 변경 
사항을 확인합니다.

장점
---------

Download and run

단점
---------

프레임워크 업데이트 시 병합 충돌이 있을수 있습니다.

구조
----------

설정 후 프로젝트의 폴더:

- app, public, system, writable 


번역 파일 설치
===================

번역된 시스템 메시지를 다운로드하여 프로젝트에 추가하여 이용할 수 있습니다.

`번역 파일 <https://github.com/codeigniter4/translations/releases/latest>`_ 다운로드.

다운로드한 zip 파일의 압축을 풀고 그 안에 있는 ``Language`` 폴더 내용을  ``app/Languages`` 폴더에 복사하십시오.
