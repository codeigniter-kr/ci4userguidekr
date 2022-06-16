Upgrade Database
################

.. contents::
    :local:
    :depth: 2

Documentations
==============

- `CodeIgniter 3.X 데이터베이스 문서 <http://codeigniter.com/userguide3/database/index.html>`_
- :doc:`CodeIgniter 4.X 데이터베이스 문서 </database/index>`

변경된 사항
=====================
- CI3의 기능은 기본적으로 CI4와 동일합니다.
- 메서드 이름이 camelCase로 변경되었으며 쿼리를 실행하려면 쿼리 빌더를 초기화해야 합니다.

Upgrade Guide
=============
1. 데이터베이스 자격 증명을 ``app/Config/Database.php``\ 에 추가합니다. 옵션은 CI3와 거의 동일하며 일부 이름이 약간 바뀌었습니다.
2. 데이터베이스를 사용하는 모든 곳에서 ``$this->load->database();``\ 를 ``$db = db_connect();``\ 로 대체해야 합니다.
3. 여러 데이터베이스를 사용하는 경우 ``$db = db_connect('group_name');``\ 를 사용하여 추가 데이터베이스를 로드합니다.
4. 이제 모든 데이터베이스 쿼리를 변경해야 합니다. 여기서 가장 중요한 변화는 ``$this->db``\ 를 ``$db``\ 로 대체하고 메소드명과 ``$db``\ 를 조정하는 것입니다. 다음은 몇 가지 예입니다.

    - ``$this->db->query('YOUR QUERY HERE');``\ 를 ``$db->query('YOUR QUERY HERE');``\ 로
    - ``$this->db->simple_query('YOUR QUERY')``\ 를 ``$db->simpleQuery('YOUR QUERY')``\ 로
    - ``$this->db->escape("something")``\ 를 ``$db->escape("something");``\ 로
    - ``$this->db->affected_rows();``\ 를 ``$db->affectedRows();``\ 로
    - ``$query->result();``\ 를 ``$query->getResult();``\ 로
    - ``$query->result_array();``\ 를 ``$query->getResultArray();``\ 로
    - ``echo $this->db->count_all('my_table');``\ 를 ``echo $db->table('my_table')->countAll();``\ 로

5. 새로운 쿼리 빌더 클래스를 사용하려면 빌더 ``$builder = $db->table('mytable');``\ 로 초기화해야 ``$builder``\ 에서 쿼리를 실행할 수 있습니다. 다음은 몇 가지 예입니다.

    - ``$this->db->get()``\ 를 ``$builder->get();``\ 로
    - ``$this->db->get_where('mytable', array('id' => $id), $limit, $offset);``\ 를 ``$builder->getWhere(['id' => $id], $limit, $offset);``\ 로
    - ``$this->db->select('title, content, date');``\ 를 ``$builder->select('title, content, date');``\ 로
    - ``$this->db->select_max('age');``\ 를 ``$builder->selectMax('age');``\ 로
    - ``$this->db->join('comments', 'comments.id = blogs.id');``\ 를 ``$builder->join('comments', 'comments.id = blogs.id');``\ 로
    - ``$this->db->having('user_id',  45);``\ 를 ``$builder->having('user_id',  45);``\ 로


Code Example
============

CodeIgniter Version 3.x
------------------------

.. literalinclude:: upgrade_database/ci3sample/001.php

CodeIgniter Version 4.x
-----------------------

.. literalinclude:: upgrade_database/001.php
