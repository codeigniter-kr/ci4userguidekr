Upgrade Emails
##############

.. contents::
    :local:
    :depth: 2


Documentations
==============

- `CodeIgniter 3.X Email 문서 <http://codeigniter.com/userguide3/libraries/email.html>`_
- :doc:`CodeIgniter 4.X Email 문서 </libraries/email>`


변경된 사항
=====================
- 메소드 이름과 라이브러리 로딩같은 작은 부분만 변경되었습니다.

Upgrade Guide
=============
1. 클래스의 ``$this->load->library('email');``\ 을 ``$email = service('email');``\ 로 변경합니다.
2. 이제 ``$this->email``\ 로 시작하는 모든 부분은 ``$email``\ 로 바꿔야 합니다.
3. Email 클래스의 메소드 이름이 약간 다릅니다. ``send()``, ``attach()``, ``printDebugger()``, ``clear()``를 제외한 모든 메소드에는 접두사로 ``set``\ 이 있고 그 뒤에 이전 메소드가 옵니다. ``bcc()`` 메소드는 ``setBcc()``\ 입니다.
4. **app/Config/Email.php**\ 의 설정 속성이 변경되었습니다. 새 속성 목록을 보려면 :ref:`setting-email-preferences`\ 를 살펴봐야 합니다.

Code Example
============

CodeIgniter Version 3.x
------------------------

.. literalinclude:: upgrade_emails/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

.. literalinclude:: upgrade_emails/001.php
