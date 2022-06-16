Upgrade Validations
###################

.. contents::
    :local:
    :depth: 2

Documentations of Library
=========================

- `CodeIgniter 3.X Form Validation 문서 <http://codeigniter.com/userguide3/libraries/form_validation.html>`_
- :doc:`CodeIgniter 4.X Validation 문서 </libraries/validation>`


변경된 사항
=====================
- 유효성 검사 오류 표시를 변경하려면 CI4 유효성 검사 뷰(view) 템플릿을 설정해야 합니다.
- CI4 유효성 검사에는 CI3의 콜백이나 호출 가능이 없습니다.
- CI4 유효성 검사 형식 규칙은 빈 문자열을 허용하지 않습니다.
- CI4 유효성 검사는 데이터를 변경하지 않습니다.

Upgrade Guide
=============
1. 폼을 포함된 뷰의 다음 항목을 변경합니다.

    - ``<?php echo validation_errors(); ?>`` 대신 ``<?= $validation->listErrors() ?>``

2. 컨트롤러의 다음 항목을 변경합니다.

    - ``$this->load->helper(array('form', 'url'));`` 대신 ``helper(['form', 'url']);``
    - ``$this->load->library('form_validation');`` 삭제
    - ``if ($this->form_validation->run() == FALSE)`` 대신 ``if (! $this->validate([]))``
    - ``$this->load->view('myform');`` 대신 ``echo view('myform', ['validation' => $this->validator,]);``

3. 컨트롤러에서 유효성 검사 규칙을 배열로 설정하여 변경합니다.

   .. literalinclude:: upgrade_validations/001.php

Code Example
============

CodeIgniter Version 3.x
------------------------
Path: **application/views**

::

    <html>
    <head>
        <title>My Form</title>
    </head>
    <body>

        <?php echo validation_errors(); ?>

        <?php echo form_open('form'); ?>

        <h5>Username</h5>
        <input type="text" name="username" value="" size="50" />

        <h5>Password</h5>
        <input type="text" name="password" value="" size="50" />

        <h5>Password Confirm</h5>
        <input type="text" name="passconf" value="" size="50" />

        <h5>Email Address</h5>
        <input type="text" name="email" value="" size="50" />

        <div><input type="submit" value="Submit" /></div>

        </form>

    </body>
    </html>

Path: **application/controllers/**

.. literalinclude:: upgrade_validations/ci3sample/002.php

CodeIgniter Version 4.x
-----------------------
Path: **app/Views**

::

    <html>
    <head>
        <title>My Form</title>
    </head>
    <body>

        <?= $validation->listErrors() ?>

        <?= form_open('form') ?>

        <h5>Username</h5>
        <input type="text" name="username" value="" size="50" />

        <h5>Password</h5>
        <input type="text" name="password" value="" size="50" />

        <h5>Password Confirm</h5>
        <input type="text" name="passconf" value="" size="50" />

        <h5>Email Address</h5>
        <input type="text" name="email" value="" size="50" />

        <div><input type="submit" value="Submit" /></div>

        </form>

    </body>
    </html>

Path: **app/Controllers/**

.. literalinclude:: upgrade_validations/002.php
