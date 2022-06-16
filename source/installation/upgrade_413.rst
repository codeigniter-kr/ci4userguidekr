#############################
Upgrading from 4.1.2 to 4.1.3
#############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer Installation App Starter Upgrading <app-starter-upgrading>`
- :ref:`Composer Installation Adding CodeIgniter4 to an Existing Project Upgrading <adding-codeigniter4-upgrading>`
- :ref:`Manual Installation Upgrading <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

**Cache TTL**

**app/Config/Cache.php**: ``$ttl``.
60초로 하드 코딩되어 있는 프레임워크 핸들러에서는 사용되지 않지만, 이후 릴리스에서 핸들러의 하드 코딩된 값을 ``$ttl`` 값으로 대체할 수 있으므로 프로젝트와 모듈에 유용합니다.

Project Files
=============

프로젝트의 일부 파일(root, app, public, writable)이 업데이트 되었습니다.
이러한 파일들은 시스템 범위를 벗어나므로 사용자의 개입 없이 변경되지 않습니다.
다음 파일의 업데이트된 변경 사항을 응용 프로그램과 병합하는 것을 권장합니다.

* ``app/Config/Cache.php``
* ``spark``
