#######################################
4.0.5에서 4.1.0 또는 4.1.1로 업그레이드
#######################################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer Installation App Starter Upgrading <app-starter-upgrading>`
- :ref:`Composer Installation Adding CodeIgniter4 to an Existing Project Upgrading <adding-codeigniter4-upgrading>`
- :ref:`Manual Installation Upgrading <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

Breaking Changes
****************

**Legacy Autoloading**

``Autoloader::loadLegacy()`` 메소드는 원래 CodeIgniter v4로 전환하기 위한 것이었습니다. 4.1.0부터 이 지원이 제거되었습니다. 모든 클래스는 네임스페이스여야 합니다.
