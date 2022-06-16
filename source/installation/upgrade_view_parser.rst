Upgrade View Parser
###################

.. contents::
    :local:
    :depth: 2

Documentations
==============

- `CodeIgniter 3.X Template Parser 문서 <http://codeigniter.com/userguide3/libraries/parser.html>`_
- :doc:`CodeIgniter 4.X View Parser 문서 </outgoing/view_parser>`


변경된 사항
=====================
- Parser Library의 구현 및 로딩을 변경해야 합니다.
- Views는 CI3에서 복사할 수 있습니다. 일반적으로 변경이 필요하지 않습니다.

Upgrade Guide
=============
1. View Parser Library 사용시 ``$this->load->library('parser');``\ 를 ``$parser = service('parser');``\ 로 바꿉니다.
2. 컨트롤러의 렌더 부분을 ``$this->parser->parse('blog_template', $data);``\ 에서 ``return $parser->setData($data)->render('blog_template');``\ 로 변경해야 합니다.

Code Example
============

CodeIgniter Version 3.11
------------------------

.. literalinclude:: upgrade_view_parser/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

.. literalinclude:: upgrade_view_parser/001.php
