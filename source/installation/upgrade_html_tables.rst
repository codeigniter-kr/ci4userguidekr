Upgrade HTML Tables
###################

.. contents::
    :local:
    :depth: 2

Documentations
==============

- `CodeIgniter 3.X HTML Table 문서 <http://codeigniter.com/userguide3/libraries/table.html>`_
- :doc:`CodeIgniter 4.X  HTML Table 문서 </outgoing/table>`

변경된 사항
=====================
- 메소드 이름, 라이브러리 로딩 등 작은 부분만 변경되었습니다.

Upgrade Guide
=============
1. ``$this->load->library('table');``\ 를 ``$table = new \CodeIgniter\View\Table();``\ 로 변경합니다.
2. ``$this->table``로 시작하는 모든 라인을 ``$table``\ 로 바꿉니다. 예: ``echo $this->table->generate($query);``\ 는 ``echo $table->generate($query);``\ 가 됩니다.
3. HTML Table 클래스의 메소드 이름은 약간 다를 수 있습니다. 이름 지정에서 가장 중요한 변경 사항은 밑줄이 있는 메서드 이름에서 camelCase로의 전환입니다. 버전 3의 ``set_heading()`` 메서드는 이제 ``setHeading()``\ 로 이름이 바뀝니다.

Code Example
============

CodeIgniter Version 3.x
------------------------

.. literalinclude:: upgrade_html_tables/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

.. literalinclude:: upgrade_html_tables/001.php
