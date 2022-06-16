Upgrade Localization
####################

.. contents::
    :local:
    :depth: 2

Documentations
==============

- `CodeIgniter 3.X Language 문서 <http://codeigniter.com/userguide3/libraries/language.html>`_
- :doc:`CodeIgniter 4.X Localization 문서 </outgoing/localization>`

변경된 사항
=====================
- CI4에서 언어 파일은 언어 라인을 배열로 반환합니다.

Upgrade Guide
=============
1.**Config/App.php**\ 에서 기본 언어를 지정합니다.

   .. literalinclude:: upgrade_localization/001.php

2. 언어 파일을 **app/Language/<locale>/**\ 로 옮깁니다.
3. 그런 다음 언어 파일의 구문을 변경해야 합니다. 아래 코드 예제에서 언어 배열 구조를 확인할 수 있습니다.
4. 모든 파일의 ``$this->lang->load($file, $lang);``\ 를 제거합니다.
5. ``$this->lang->line('error_email_missing')`` 라인을  ``echo lang('Errors.errorEmailMissing');``\ 로 교체합니다.

Code Example
============

CodeignIter Version 3.x
------------------------

.. literalinclude:: upgrade_localization/ci3sample/002.php

CodeIgniter Version 4.x
-----------------------

.. literalinclude:: upgrade_localization/002.php
