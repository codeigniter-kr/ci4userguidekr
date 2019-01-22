###################
Server Requirements
###################

`PHP <http://php.net/>`_ 버전 7.2 이상이 필요하며, 
`*intl* extension <http://php.net/manual/en/intl.requirements.php>`_\ 이 설치되어 있어야 합니다. 

서버에 다음 PHP 확장(ext)을 사용하도록 설정해야합니다.:
``php-json``, ``php-mbstring``, ``php-mysqlnd``, ``php-xml``

In order to use the :doc:`CURLRequest </libraries/curlrequest>`, you will need 
`libcurl <http://php.net/manual/en/curl.requirements.php>`_ installed.

대부분의 웹어플리케이션 프로그래밍에서 데이터베이스는 필수사항입니다.
현재 지원되는 데이터베이스는 다음과 같습니다:

  - MySQL (5.1+) via the *MySQLi* driver
  - PostgreSQL via the *Postgre* driver
  - SQLite3 via the *SQLite3* driver

CodeIgniter4는 이전 버전에서 지원하던 모든 드라이버가 아직 변환/재작성되지 않았습니다.
완료되지 않은 드라이버 목록은 아래와 같습니다.

  - MySQL (5.1+) via the *pdo* driver
  - Oracle via the *oci8* and *pdo* drivers
  - PostgreSQL via the *pdo* driver
  - MS SQL via the *mssql*, *sqlsrv* (version 2005 and above only) and *pdo* drivers
  - SQLite via the *sqlite* (version 2) and *pdo* drivers
  - CUBRID via the *cubrid* and *pdo* drivers
  - Interbase/Firebird via the *ibase* and *pdo* drivers
  - ODBC via the *odbc* and *pdo* drivers (you should know that ODBC is actually an abstraction layer)

