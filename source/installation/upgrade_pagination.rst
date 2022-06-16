Upgrade Pagination
##################

.. contents::
    :local:
    :depth: 2

Documentations
==============

- `CodeIgniter 3.X Pagination Class 문서 <http://codeigniter.com/userguide3/libraries/pagination.html>`_
- :doc:`CodeIgniter 4.X Pagination 문서 </libraries/pagination>`

변경된 사항
=====================
- 새로운 페이징 라이브러리를 사용하려면 뷰와 컨트롤러를 변경해야 합니다.
- 페이징 링크를 사용자 지정하려면 뷰(view) 템플릿을 만들어야 합니다.
- CI4에서 페이징은 실제 페이지 번호만 사용합니다. CI3의 기본값인 항목에는 시작 인덱스(오프셋)를 사용할 수 없습니다.
- :doc:`CodeIgnite\\Model </models/model>`\ 을 사용하면 Model 클래스에 내장된 페이징 메소드를 사용할 수 있습니다.

Upgrade Guide
=============
1. 뷰에서 다음과 같이 변경합니다.

    - ``<?php echo $this->pagination->create_links(); ?>``\ 을 ``<?= $pager->links() ?>``\ 로

2. 컨트롤러에서 다음과 같이 변경합니다.

    - 모든 모델에서 내장된 ``paginate()`` 메소드를 사용할 수 있습니다. 특정 모델에 페이징을 설정하려면 아래 예제를 살펴보십시오.


Code Example
============

CodeIgniter Version 3.x
------------------------

.. literalinclude:: upgrade_pagination/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

.. literalinclude:: upgrade_pagination/001.php
