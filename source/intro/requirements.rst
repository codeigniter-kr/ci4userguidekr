###################
서버 요구 사항
###################

`PHP <https://www.php.net/>`_ 버전 7.3 이상이 필요하며, `*intl* 확장(Extension) <https://www.php.net/manual/en/intl.requirements.php>`_\ 과 `*mbstring* 확장 <https://www.php.net/manual/en/mbstring.requirements.php>`_\ 이 설치되어 있어야 합니다.

서버에 다음 PHP 확장 기능을 사용하도록 설정해야 합니다.

  - ``php-json``
  - ``php-mysqlnd`` (MySQL을 사용하는 경우)
  - ``php-xml``

:doc:`CURLRequest </libraries/curlrequest>`\ 를 사용하려면 `libcurl <https://www.php.net/manual/en/curl.requirements.php>`_\ 이 설치되어 있어야 합니다.

대부분의 웹 어플리케이션은 데이터베이스가 필요합니다.
현재 지원되는 데이터베이스는 다음과 같습니다.

  - MySQL via the *MySQLi* driver (version 5.1 and above only)
  - PostgreSQL via the *Postgre* driver
  - SQLite3 via the *SQLite3* driver
  - MSSQL via the *SQLSRV* driver (version 2005 and above only)
  - Oracle via the *OCI8* driver (version 12.1 and above only)

CodeIgniter4용으로 일부 드라이버가 변환/재작성되지 않았습니다.
아래는 아직 완결되지 않은 항목입니다.

  - MySQL (5.1+) via the *pdo* driver
  - Oracle via the *pdo* drivers
  - PostgreSQL via the *pdo* driver
  - MSSQL via the *pdo* drivers
  - SQLite via the *sqlite* (version 2) and *pdo* drivers
  - CUBRID via the *cubrid* and *pdo* drivers
  - Interbase/Firebird via the *ibase* and *pdo* drivers
  - ODBC via the *odbc* and *pdo* drivers (you should know that ODBC is actually an abstraction layer)

