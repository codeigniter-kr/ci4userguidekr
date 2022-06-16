컨트롤러 업그레이드
###################

.. contents::
    :local:
    :depth: 2

관련 문서
==============

- `CodeIgniter 3.X 컨트롤러 설명서 <http://codeigniter.com/userguide3/general/controllers.html>`_
- `CodeIgniter 4.X 컨트롤러 설명서 </incoming/controllers.html>`_

무엇이 바뀌었습니까?
=====================

- CodeIgniter4에 네임스페이스가 추가되었으므로 컨트롤러를 지원 네임스페이스로 변경해야 합니다.
- 사용자가 만든 기본 컨트롤러의 일부가 아니라면 (CI `magic`\ 을 호출하기 위해) 컨트롤러는 더 이상 생성자를 사용하지 않습니다.
- CI는 사용자가 작업할 수 있도록 요청 및 응답 개체를 제공하며, CI3 방식보다 더 강력합니다.
- 사용자 정의 컨트롤러 (CI3의 ``MY_Controller``)를 원한다면, 원하는 위치에 컨트롤러를 만든 다음 BaseController를 상속받아 확장하도록 합니다.

업그레이드 가이드
=================

1. 먼저 모든 컨트롤러 파일을 **app/Controllers** 폴더로 이동합니다.
2. <?php 태그 바로 뒤에 ``namespace App\Controllers;``\ 를 추가합니다.
3. ``extends CI_Controller``\ 를 ``extends BaseController``\ 로 바꿉니다.

| 컨트롤러 구조에 하위 디렉터리를 사용한다면 네임스페이스를 변경해야 합니다.
| 예를 들어 **application/controllers/users/auth/Register.php**\ 에 버전 3의 컨트롤러가 있다면 네임스페이스는 ``namespace App\Controllers\Users\Auth;``\ 이고 버전 4의 컨트롤러 경로는 **app/Controllers/Users/Auth/Register.php**\ 와 같이 변경됩니다. 하위 디렉토리의 첫 글자가 대문자로 되어 있는지 확인하십시오.
| ``BaseController``\ 를 확장하려면 네임스페이스 정의 아래에 ``use``\ 문을 삽입해야 합니다 : ``use App\Controllers\BaseController;``

코드 예
============

CodeIgniter Version 3.x
------------------------

Path: **application/controllers**

.. literalinclude:: upgrade_controllers/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

Path: **app/Controllers**

.. literalinclude:: upgrade_controllers/001.php
