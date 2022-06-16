Upgrade Security
################

.. contents::
    :local:
    :depth: 2

Documentations
==============

- `CodeIgniter 3.X Security Class 문서 <http://codeigniter.com/userguide3/libraries/security.html>`_
- :doc:`CodeIgniter 4.X Security 문서 </libraries/security>`

.. note::
    :doc:`폼(form) 헬퍼 </helpers/form_helper>`\ 를 사용하고 CSRF 필터를 전역적으로 활성화하면 ``form_open()`` 함수는 자동으로 폼에 숨겨진 CSRF 필드를 삽입합니다. 따라서 직접 업그레이드할 필요가 없습니다.

변경된 사항
=====================
- CSRF 토큰을 HTML 형식으로 구현하는 방법이 변경되었습니다.

Upgrade Guide
=============
1. CI4에서 CSRF 보호를 활성화하려면 **app/Config/Filters.php**\ 에서 활성화해야 합니다.

::

    public $globals = [
        'before' => [
            //'honeypot',
            'csrf',
        ]
    ];

2. HTML 폼에서 ``<input type="hidden" name="<?= $csrf['name'] ?>" value="<?= $csrf['hash'] ?>" />``\ 와 유사한 CSRF 입력 필드를 제거해야 합니다.
3. ``form_open()``\ 을 사용하지 않는다면 HTML 폼(form)에 ``<?= csrf_field() ?>``\ 를 추가해야 합니다.

Code Example
============

CodeIgniter Version 3.x
------------------------

.. literalinclude:: upgrade_security/ci3sample/002.php

CodeIgniter Version 4.x
-----------------------

.. literalinclude:: upgrade_security/002.php
