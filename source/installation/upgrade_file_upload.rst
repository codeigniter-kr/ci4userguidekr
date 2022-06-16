파일 업로드 업그레이드
###################################

.. contents::
    :local:
    :depth: 2


Documentations
==============
- `CodeIgniter 3.X Output Class 문서  <http://codeigniter.com/userguide3/libraries/file_uploading.html>`_
- :doc:`CodeIgniter 4.X Uploaded Files 문서  </libraries/uploaded_files>`

변경된 사항
=====================
- 파일 업로드 기능은 파일이 오류 없이 업로드되었는지 확인할 수 있고, 파일을 더 쉽게 이동/저장할 수 있도록 많이 변경되었습니다.

Upgrade Guide
=============
CI4에서는 ``$file = $this->request->getFile('userfile')``\ 로 업로드된 파일에 액세스합니다. 업로드된 파일은 ``$file->isValid()``\ 를 사용하여 파일이 성공적으로 업로드되었는지 확인할 수 있습니다.
업로드된 파일을 저장하려면 ``$path = $this->request->getFile('userfile')->store('head_img/', 'user_name.jpg');``\ 를 사용합니다. 파일은 **writable/uploads/head_img/user_name.jpg**\ 로 저장됩니다.

새로운 메소드와 일치하도록 파일 업로드 코드를 변경해야 합니다.

Code Example
============

CodeIgniter Version 3.x
------------------------

.. literalinclude:: upgrade_file_upload/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

.. literalinclude:: upgrade_file_upload/001.php
