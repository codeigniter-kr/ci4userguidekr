#######################################
데이터베이스 빠른 시작 : 예제 코드
#######################################

.. contents::
    :local:
    :depth: 2

다음 페이지에는 데이터베이스 클래스 사용 방법을 보여주는 예제 코드가 포함되어 있습니다.
자세한 내용은 각 기능을 설명하는 개별 페이지를 참조하십시오.

데이터베이스 클래스 초기화
===============================

다음 코드는 :doc:`configuration <configuration>` 설정에 따라 데이터베이스 클래스를 로드하고 초기화합니다.

.. literalinclude:: examples/001.php

로드된 클래스는 아래 설명된 대로 사용할 수 있습니다.

.. note:: 모든 페이지에 데이터베이스 액세스가 필요한 경우 자동으로 연결할 수 있습니다. 자세한 내용은 :doc:`연결 <connecting>` 페이지를 참조하십시오.

여러 결과가 포함된 표준 쿼리 (객체 Version)
=====================================================

.. literalinclude:: examples/002.php

| 위의 ``getResult()`` 함수는 **객체(object)**\ 의 배열을 반환합니다.
| 샘플: ``$row->title``

여러 결과가 포함된 표준 쿼리 (배열 Version)
====================================================

.. literalinclude:: examples/003.php

| 위의 ``getResultArray()`` 함수는 표준 배열 인덱스의 배열을 반환합니다.
| 샘플: ``$row['title']``

단일 결과가 포함된 표준 쿼리
=================================

.. literalinclude:: examples/004.php

``getRow()`` 함수는 **객체(object)**\ 를 반환합니다.
샘플: ``$row->name``

단일 결과가 포함 된 표준 쿼리 (Array version)
=================================================

.. literalinclude:: examples/005.php


``getRowArray()`` 함수는 **배열**\ 을 반환합니다.
샘플: ``$row['name']``

표준 Insert
==================

.. literalinclude:: examples/006.php

쿼리 빌더
===================

:doc:`쿼리 빌더(Query Builder) 패턴 <query_builder>`\ 은 데이터를 검색하는 간단한 방법을 제공합니다.

.. literalinclude:: examples/007.php

``get()`` 함수는 제공된 테이블에서 모든 결과를 검색합니다.
:doc:`쿼리 빌더 <query_builder>` 클래스에는 데이터 작업을 위한 완전한 기능이 포함되어 있습니다.

쿼리 빌더 Insert
====================

.. literalinclude:: examples/008.php
