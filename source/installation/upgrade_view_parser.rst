Upgrade View Parser
###################

.. contents::
    :local:
    :depth: 1


Documentations
==============

- `Codeigniter 3.X Template Parser 문서 <http://codeigniter.com/userguide3/libraries/parser.html>`_
- :doc:`Codeigniter 4.X View Parser 문서 </outgoing/view_parser>`


변경된 사항
=====================
- Parser Library의 구현 및 로딩을 변경해야 합니다.
- Views는 CI3에서 복사할 수 있습니다. 일반적으로 변경이 필요하지 않습니다.

Upgrade Guide
=============
1. View Parser Library 사용시 ``$this->load->library('parser');``\ 를 ``$parser = service('parser');``\ 로 바꿉니다.
2. 컨트롤러의 렌더 부분을 ``$this->parser->parse('blog_template', $data);``\ 에서 ``echo $parser->setData($data)->render('blog_template');``\ 로 변경해야 합니다.

Code Example
============

Codeigniter Version 3.11
------------------------
::

    $this->load->library('parser');

    $data = array(
        'blog_title' => 'My Blog Title',
        'blog_heading' => 'My Blog Heading'
    );

    $this->parser
        ->parse('blog_template', $data);

Codeigniter Version 4.x
-----------------------
::

    $parser = service('parser');

    $data = [
        'blog_title'   => 'My Blog Title',
        'blog_heading' => 'My Blog Heading'
    ];

    echo $parser->setData($data)
        ->render('blog_template');
