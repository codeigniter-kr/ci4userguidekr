######################
데이터베이스 구성
######################

.. contents::
    :local:
    :depth: 2

***********
구성 파일
***********

CodeIgniter에는 데이터베이스 연결 값(username, password, database name, etc.)을 저장할 수 있는 구성(config) 파일이 있습니다.
구성 파일은 ``app/Config/Database.php``\ 에 있습니다.
``.env`` 파일에서 데이터베이스 연결 구성을 설정할 수 있습니다.
자세한 내용은 아래를 참조하십시오.

구성 설정은 이 프로토타입이 포함된 배열인 클래스 속성에 저장됩니다.

.. literalinclude:: configuration/001.php

클래스 속성의 이름은 연결 이름이며, 연결 중에 그룹 이름을 지정할 수 있습니다.

.. note:: SQLite3 데이터베이스의 기본 위치는 ``writable`` 폴더입니다. 위치를 변경하려면 새로운 위치의 전체 경로를 설정해야 합니다.

DSN
===

일부 데이터베이스 드라이버(예 : PDO, PostgreSQL, Oracle, ODBC)는 전체 DSN 문자열을 제공해야 합니다.
이 경우 드라이버의 기본 PHP 확장을 사용하는 것처럼 'DSN'구성 설정을 사용해야 합니다.

.. literalinclude:: configuration/002.php

.. note:: 필요한 드라이버에 대해 DSN 문자열을 지정하지 않으면 CodeIgniter는 제공된 나머지 설정으로 DSN 문자열을 빌드하려고 시도합니다.

데이터 원본 이름을 범용(URL like) 방식으로 설정할 수도 있습니다. 
이 경우 DSN에 프로토타입이 있어야 합니다.

.. literalinclude:: configuration/003.php

범용 버전 DSN 문자열로 연결할 때 기본 구성 값을 재정의하려면 구성 변수를 쿼리 문자열로 추가합니다.

.. literalinclude:: configuration/004.php

.. note:: DSN 문자열을 제공하고 나머지 구성 필드에 있는 유효한 설정(예 : 데이터베이스 문자 세트)이 누락된 경우 CodeIgniter가 추가합니다.

Failovers
=========

메인 연결이 어떤 이유로 연결될 수 없는 상황에 대해 ``failover``\ 를 설정하여 장애 조치를 지정할 수 있습니다.

.. literalinclude:: configuration/005.php

원하는 수만큼 장애 조치를 지정할 수 있습니다.

선택적으로 여러 연결 값 세트를 저장할 수 있습니다.
예를 들어 단일 설치에서 여러 환경(개발, 프로덕션, 테스트 등)을 실행하는 경우 각각에 대해 연결 그룹을 설정한 다음 필요에 따라 그룹간에 전환할 수 있습니다.
"test" 환경을 설정하는 다음 예를 살펴보세요.

.. literalinclude:: configuration/006.php

해당 그룹을 사용하도록 시스템에 전역적으로 알리려면 구성 파일에 이 변수를 설정합니다.

.. literalinclude:: configuration/007.php

.. note:: 'test'\ 라는 이름은 임의적이며, 원한다면 어떤 이름이든 상관없습니다.
    기본적으로 기본 연결에는 "default"라는 단어가 사용되었지만 프로젝트와 관련이 있는 다른 이름으로 바꿀 수도 있습니다.

defaultGroup
============

구성 파일을 수정하여 환경을 감지하고 클래스의 생성자내에 필요한 로직를 추가하여 'defaultGroup' 값을 올바른 값으로 자동 업데이트할 수 있습니다.

.. literalinclude:: configuration/008.php

********************
.env 파일로 구성
********************

현재 서버의 데이터베이스 설정으로 ``.env`` 파일내에 구성 값을 저장할 수 있습니다.
기본 그룹의 구성 설정에서 변경된 값만 입력하면 됩니다.
값은 이 형식을 따르는 이름이어야 합니다. 여기서 ``default``\ 는 그룹 이름입니다.

::

    database.default.username = 'root';
    database.default.password = '';
    database.default.database = 'ci4';

다른 모든 것도 마찬가지로

**********
값 설명
**********

======================  ===========================================================================================================
 Name Config             설명
======================  ===========================================================================================================
**dsn**                 DSN 연결 문자열 (일체형 구성)
**hostname**            데이터베이스 서버의 호스트 이름, 대부분 'localhost'
**username**            데이터베이스에 연결하는데 사용되는 사용자 이름
**password**            데이터베이스에 연결하는데 사용되는 비밀번호
**database**            연결하려는 데이터베이스의 이름
**DBDriver**            데이터베이스 유형(``MySQLi``, ``Postgres`` 등), 드라이버 이름과 일치해야 합니다.
**DBPrefix**            :doc:`쿼리 빌더 <query_builder>` 쿼리를 실행할 때 테이블 이름에 추가될 선택적 테이블 접두사, 이를 통해 설치된 여러개의 CodeIgniter가 하나의 데이터베이스를 공유할 수 있습니다.
**pConnect**            true/false (boolean) - 지속적 연결 사용 여부
**DBDebug**             true/false (boolean) - 데이터베이스 오류를 표시해야 하는지 여부
**charset**             데이터베이스와 통신하는 데 사용되는 문자 세트(character set)
**DBCollat**            데이터베이스와의 통신에 사용되는 문자 조합(``MySQLi`` 전용)
**swapPre**             ``DBPrefix``\ 와 교체(swap)되는 기본 테이블 접두사. 수동으로 작성된 쿼리를 실행할 수 있고, 최종 사용자가 여전히 접두사를 사용자 정의할 수 있어야 하는 분산 어플리케이션에 유용합니다.
**schema**              데이터베이스 스키마, 기본값은 드라이버에 따라 다릅니다. ``Postgres`` 및 ``SQLSRV`` 드라이버에서 사용합니다.
**encrypt**             암호화 된 연결을 사용할지 여부.

                        ``SQLSVR`` 드라이버는 true/false
                        ``MySQLi`` 드라이버는 다음 옵션 배열로 설정:

                            * ``ssl_key``    - 개인키 파일의 경로
                            * ``ssl_cert``   - 공개키 인증서 파일의 경로
                            * ``ssl_ca``     - 인증 기관 파일의 경로
                            * ``ssl_capath`` - PEM 형식의 신뢰할 수 있는 CA 인증서가 포함된 디렉토리 경로
                            * ``ssl_cipher`` - 암호화에 사용될 *허용* 암호 목록, 콜론(``:``)으로 구분
                            * ``ssl_verify`` - true/false; 서버 인증서를 확인할지 여부 (``MySQLi`` 전용)

**compress**            클라이언트 압축 사용 여부 (``MySQLi`` 전용).
**strictOn**            true/false (boolean) - "Strict Mode" 연결을 강제 적용할지 여부, 어플리케이션을 개발하는 동안 엄격한 SQL을 보장하는데 좋습니다.
**port**                데이터베이스 포트 번호, 이 값을 사용하려면 데이터베이스 구성 배열에 아래 행을 추가해야합니다.

                        .. literalinclude:: configuration/009.php
**foreignKeys**         true/false (boolean) - 외래 키 제약 조건을 활성화할지 여부t (``SQLite3`` 전용).

                        .. important:: SQLite3 외래 키 제약 조건은 기본적으로 비활성화되어 있습니다. `SQLite 문서 <https://www.sqlite.org/pragma.html#pragma_foreign_keys>`_\ 를 참조하세요. 외래 키 제약 조건을 적용하려면 이 구성 항목을 true로 설정하십시오.
======================  ===========================================================================================================

.. note:: 사용중인 데이터베이스 플랫폼(MySQL, PostgreSQL 등)에 따라 모든 값이 필요한 것은 아닙니다.
    예를 들어, SQLite를 사용하는 경우 사용자 이름 또는 비밀번호를 제공할 필요가 없으며 데이터베이스 이름은 데이터베이스 파일의 경로가됩니다.
    위의 정보는 사용자가 MySQL을 사용하고 있다고 가정합니다.
