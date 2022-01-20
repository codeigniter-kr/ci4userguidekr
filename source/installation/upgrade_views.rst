뷰 업그레이드
#############

.. contents::
    :local:
    :depth: 2

관련 문서
==============

- `CodeIgniter 3.X 뷰 설명서 <http://codeigniter.com/userguide3/general/views.html>`_
- :doc:`CodeIgniter 4.X 뷰 설명서 </outgoing/views>`

무엇이 바뀌었습니까?
=====================

- CI4의 뷰는 이전과 매우 유사하지만 다르게 해석됩니다.
  CI3의 ``$this->load->view(x);`` 대신 ``echo view(x);``\ 를 사용합니다.
- CI4는 뷰 “셀(cell)”\ 을 지원하여 응답을 여러 조각으로 구성합니다.
- 템플리트 파서는 그대로 있으며, 상당히 개선되었습니다.

업그레이드 가이드
=================

1. 먼저 모든 뷰를 **app/Views** 폴더로 옮깁니다.
2. 뷰를 로드하는 모든 스크립트의 뷰 로드 구문을 ``$this->load->view('directory_name/file_name')`` 대신
   ``echo view('directory_name/file_name');``\ 로 변경합니다.
3. (선택사항) 뷰의 에코 구문 ``<?php echo $title; ?>``\ 을 ``<?= $title ?>``\ 로 변경할 수 있습니다.

Code Example
============

CodeIgniter Version 3.11
------------------------

Path: **application/views**::

    <html>
    <head>
        <title><?php echo $title; ?></title>
    </head>
    <body>
        <h1><?php echo $heading; ?></h1>

        <h3>My Todo List</h3>

        <ul>
        <?php foreach ($todo_list as $item): ?>
            <li><?php echo $item; ?></li>
        <?php endforeach; ?>
        </ul>

    </body>
    </html>

CodeIgniter Version 4.x
-----------------------

Path: **app/Views**::

    <html>
    <head>
        <title><?= esc($title) ?></title>
    </head>
    <body>
        <h1><?= esc($heading) ?></h1>

        <h3>My Todo List</h3>

        <ul>
        <?php foreach ($todo_list as $item): ?>
            <li><?= esc($item) ?></li>
        <?php endforeach ?>
        </ul>

    </body>
    </html>
