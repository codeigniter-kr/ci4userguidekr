#############################
Upgrading from 4.1.7 to 4.1.8
#############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer 설치 - App Starter 업그레이드 <app-starter-upgrading>`
- :ref:`Composer 설치 - 기존 프로젝트의 CodeIgniter4 업그레이드 <adding-codeigniter4-upgrading>`
- :ref:`수동 설치 업그레이드 <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

Breaking Changes
****************

- 보안 문제로 ``API\ResponseTrait``\ 의 트레이트(trait) 메소드의 범위가 ``protected``\ 로 지정됩니다. 자세한 내용은 `보안 권고 <https://github.com/codeigniter4/CodeIgniter4/security/advisories/GHSA-7528-7jg5-6g62>`_\ 를 참조하세요.