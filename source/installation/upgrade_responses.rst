Upgrade HTTP Responses
######################

.. contents::
    :local:
    :depth: 2

Documentations
==============
- `CodeIgniter 3.X Output Class 문서 <http://codeigniter.com/userguide3/libraries/output.html>`_
- :doc:`CodeIgniter 4.X HTTP Responses 문서 </outgoing/response>`

변경된 사항
=====================
- 메소드 이름이 변경되었습니다.

Upgrade Guide
=============
1. HTTP Responses 클래스의 메소드 이름의 가장 중요한 변경 사항은 밑줄이 있는 메소드 이름에서 camelCase로의 전환입니다. 버전 3의 ``set_content_type()`` 메소드는 ``setContentType()`` 등으로 이름이 지정됩니다.
2. 대부분의 경우 ``$this->output``\ 을 ``$this->response``\ 로 변경한 다음 메소드를 변경해야 합니다. :doc:`여기 </outgoing/response>`\ 에서 모든 메소드를 찾을 수 있습니다 .

Code Example
============

CodeIgniter Version 3.x
------------------------

.. literalinclude:: upgrade_responses/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

.. literalinclude:: upgrade_responses/001.php
