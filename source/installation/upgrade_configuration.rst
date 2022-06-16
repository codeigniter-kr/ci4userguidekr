업그레이드 구성
#####################

.. contents::
    :local:
    :depth: 2

관련 문서
==============

- `CodeIgniter 3.X 구성 설명서 <http://codeigniter.com/userguide3/libraries/config.html>`_
- `CodeIgniter 4.X 구성 설명서 </general/configuration.html>`_


무엇이 바뀌었습니까?
=====================

- CI4의 구성(configuration)은 이제 ``CodeIgniter\Config\BaseConfig``\ 를 확장하는 클래스에 저장됩니다.
- 구성 클래스 내에서 구성 값은 공용 클래스 속성에 저장됩니다.
- 구성 값을 가져오는 방법이 변경되었습니다.

업그레이드 가이드
=================

1. 기본 CI4 구성 파일의 값은 CI3 파일의 변경에 따라 변경해야 합니다. 구성 이름은 CI3와 거의 동일합니다.
2. CI3 프로젝트에서 사용자 정의 구성 파일을 사용하는 경우 CI4 프로젝트에서 해당 파일을 **app/Config/**\ 에 PHP 클래스로 생성해야 합니다. 이 클래스는 네임스페이스 ``Config``\ 에 있어야 하며 ``CodeIgniter\Config\BaseConfig``\ 를 확장해야 합니다.
3. 모든 사용자 정의 구성 클래스를 만든 후에는 CI3 구성에서 새 CI4 구성 클래스로 변수를 공용 클래스 속성으로 복사해야 합니다.
4. 이제 구성 값을 가져오는 모든 곳의 구성 가져오기 구문을 변경해야 합니다. CI3 구문은 ``$this->config->item('item_name')``\ 과 같습니다. 이 구문을 ``config('MyConfigFile')->item_name;``\ 으로 변경해야 합니다.

코드 예
============

CodeIgniter Version 3.x
------------------------

Path: **application/models**

.. literalinclude:: upgrade_configuration/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

Path: **app/Config**

.. literalinclude:: upgrade_configuration/001.php
