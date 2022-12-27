###################
서버 요구 사항
###################

.. contents::
    :local:
    :depth: 2

***************************
PHP 버전 및 필수 확장
***************************

`PHP <https://www.php.net/>`_ 버전 7.4 이상이 필요하며, 다음 PHP 확장이 활성화되어 있습니다.

  - `intl <https://www.php.net/manual/en/intl.requirements.php>`_
  - `mbstring <https://www.php.net/manual/en/mbstring.requirements.php>`_
  - `json <https://www.php.net/manual/en/json.requirements.php>`_

***********************
선택적 PHP 확장
***********************

서버에서 다음 PHP 확장을 활성화해야 합니다.

  - `mysqlnd <https://www.php.net/manual/en/mysqlnd.install.php>`_ (MySQL을 사용하는 경우)
  - `curl <https://www.php.net/manual/en/curl.requirements.php>`_ (:doc:`CURLRequest </libraries/curlrequest>`\ 을 사용하는 경우)
  - `imagick <https://www.php.net/manual/en/imagick.requirements.php>`_ (:doc:`Image </libraries/images>` ImageMagickHandler 클래스를 사용하는 경우)
  - `gd <https://www.php.net/manual/en/image.requirements.php>`_ (:doc:`Image </libraries/images>` GDHandler 클래스를 사용하는 경우)
  - `simplexml <https://www.php.net/manual/en/simplexml.requirements.php>`_ (XML을 사용하는 경우)

캐시 서버를 사용할 때 다음 PHP 확장이 필요합니다.

  - `memcache <https://www.php.net/manual/en/memcache.requirements.php>`_ (Memcache와 함께 :doc:`Cache </libraries/caching>` MemcachedHandler 클래스를 사용하는 경우)
  - `memcached <https://www.php.net/manual/en/memcached.requirements.php>`_ (Memcached와 함께 :doc:`Cache </libraries/caching>` MemcachedHandler 클래스를 사용하는 경우)
  - `redis <https://github.com/phpredis/phpredis>`_ (:doc:`Cache </libraries/caching>` RedisHandler 클래스를 사용하는 경우)

PHPUnit을 사용할 때 다음 PHP 확장이 필요합니다.

   - `dom <https://www.php.net/manual/en/dom.requirements.php>`_ (:doc:`TestResponse </testing/response>` 클래스를 사용하는 경우)
   - `libxml <https://www.php.net/manual/en/libxml.requirements.php>`_ (:doc:`TestResponse </testing/response>` 클래스를 사용하는 경우)
   - `xdebug <https://xdebug.org/docs/install>`_ (``CIUnitTestCase::assertHeaderEmitted()``\ 을 사용하는 경우)

.. _requirements-supported-databases:

**********************
지원되는 데이터베이스
**********************

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

