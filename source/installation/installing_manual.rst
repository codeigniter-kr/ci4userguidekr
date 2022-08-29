수동 설치
#########

.. contents::
    :local:
    :depth: 2

`CodeIgniter 4 framework <https://github.com/codeigniter4/framework>`_  프레임워크 레파지토리에는 
릴리스된 버전의 프레임워크가 있으며, 이는 Composer를 사용하지 않으려는 개발자를 위한 것입니다.

``app`` 폴더안에서 앱을 개발하고, ``public`` 폴더는 웹 루트(root)가 됩니다. 
``system`` 폴더안에 있는 내용은 변경하지 마십시오!

.. note:: 이 방법은 `CodeIgniter 3 <https://codeigniter.com/userguide3/installation/index.html>`_\ 의 설치 방법과 비슷한 설치 방법입니다. 

설치 방법
=============

`최신 버전 <https://github.com/CodeIgniter4/framework/releases/latest>`_\ 을 다운로드하고 프로젝트 
루트(root)에 압축을 풀어주십시오.

.. note:: CodeIgniter 자동 로더(autoloader)는 특정 운영 체제의 파일 이름에 잘못된 특수 문자를 허용하지 않습니다.
    사용할 수 있는 기호는 ``/``, ``_``, ``.``, ``:``, ``\``\ 과 공백(space)입니다.
    따라서 ``(``, ``)`` 등과 같은 특수 문자가 포함된 폴더에 CodeIgniter를 설치하면 CodeIgniter가 작동하지 않습니다.


Initial Configuration
=====================

설치 후 몇 가지 초기 구성이 필요합니다.
자세한 내용은 :ref:`initial-configuration`\ 을 참조하세요.

.. _installing-manual-upgrading:

업그레이드
==========

프레임워크의 새 사본을 다운로드한 다음 ``sysstem`` 폴더를 교체합니다.

:doc:`업그레이드 지침 <upgrading>`\ 을 읽고 변경 사항 및 개선 사항을 확인하십시오.

장점
=====

Download and run

단점
=====

프레임워크 업데이트 시 병합 충돌이 있을수 있습니다.

구조
=====

설정 후 프로젝트의 폴더:

- app, public, tests, writable, system

번역 파일 설치
===================

번역된 시스템 메시지를 다운로드하여 프로젝트에 추가하여 이용할 수 있습니다.

`번역 파일 <https://github.com/codeigniter4/translations/releases/latest>`_ 다운로드.

다운로드한 zip 파일의 압축을 풀고 그 안에 있는 ``Language`` 폴더 내용을  ``app/Languages`` 폴더에 복사하십시오.
