Upgrade Sessions
################

.. contents::
    :local:
    :depth: 2

Documentations
==============

- `CodeIgniter 3.X Session Library 문서 <http://codeigniter.com/userguide3/libraries/sessions.html>`_
- :doc:`CodeIgniter 4.X Session Library 문서 </libraries/sessions>`

변경된 사항
=====================
- 메소드명, 라이브러리 로드와 같은 작은 부분만 변경되었습니다.

Upgrade Guide
=============
1. 세션 라이브러리를 사용할 때마다 ``$this->load->library('session');``\ 를 ``$session = session();``\ 으로 바꿉니다.
2. ``$this->session``\ 으로 시작하는 모든 부분을 다음과 같이 ``$session``\ 의 새 메소드 이름으로 바꿉니다.

    - 세션 데이터에 액세스하는 CI3 구문 ``$this->session->name`` 대신 ``$session->item`` 또는 ``$session->get('item')`` 구문을 사용합니다.
    - 데이터를 설정하려면 ``$this->session->set_userdata($array);`` 대신 ``$session->set($array);``\ 를 사용합니다.
    - 데이터를 제거하려면 ``$session->remove('some_name');`` 대신 ``unset($_SESSION['some_name']);`` 또는 ``$session->remove('some_name');``\ 를 사용합니다.
    - 세션 데이터를 다음 요청에만 사용할 수 있는 flasdata로 표시하려면 ``$this->session->mark_as_flash('item');`` 대신 ``$session->markAsFlashdata('item');``\ 를 사용합니다.

Code Example
============

CodeIgniter Version 3.11
------------------------

.. literalinclude:: upgrade_sessions/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

.. literalinclude:: upgrade_sessions/001.php
