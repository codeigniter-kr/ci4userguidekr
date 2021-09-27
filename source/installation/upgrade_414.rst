#############################
Upgrading from 4.1.3 to 4.1.4
#############################

이번 릴리스는 코드 스타일에 집중하였습니다.
모든 변경 사항(아래에 명시된 변경 사항 제외)은 새로운 `CodeIgniter Coding Standard <https://github.com/CodeIgniter/coding-standard>`_ (based on PSR-12)\ 에 코드를 맞추기 위한 것 입니다..

**Method Scope**

다음 메소드는 상위 클래스 메서드와 일치하고 용도에 더 잘 맞도로 ``public``\ 에서 ``protected``\ 로 변경되었습니다.
이러한 메소드 중 하나라도 public으로 설정된 경우 (매우 가능성이 적음) 코드를 조정합니다.

::

* ``CodeIgniter\Database\MySQLi\Connection::execute()``
* ``CodeIgniter\Database\MySQLi\Connection::_fieldData()``
* ``CodeIgniter\Database\MySQLi\Connection::_indexData()``
* ``CodeIgniter\Database\MySQLi\Connection::_foreignKeyData()``
* ``CodeIgniter\Database\Postgre\Builder::_like_statement()``
* ``CodeIgniter\Database\Postgre\Connection::execute()``
* ``CodeIgniter\Database\Postgre\Connection::_fieldData()``
* ``CodeIgniter\Database\Postgre\Connection::_indexData()``
* ``CodeIgniter\Database\Postgre\Connection::_foreignKeyData()``
* ``CodeIgniter\Database\SQLSRV\Connection::execute()``
* ``CodeIgniter\Database\SQLSRV\Connection::_fieldData()``
* ``CodeIgniter\Database\SQLSRV\Connection::_indexData()``
* ``CodeIgniter\Database\SQLSRV\Connection::_foreignKeyData()``
* ``CodeIgniter\Database\SQLite3\Connection::execute()``
* ``CodeIgniter\Database\SQLite3\Connection::_fieldData()``
* ``CodeIgniter\Database\SQLite3\Connection::_indexData()``
* ``CodeIgniter\Database\SQLite3\Connection::_foreignKeyData()``
* ``CodeIgniter\Images\Handlers\GDHandler::_flatten()``
* ``CodeIgniter\Images\Handlers\GDHandler::_flip()``
* ``CodeIgniter\Images\Handlers\ImageMagickHandler::_flatten()``
* ``CodeIgniter\Images\Handlers\ImageMagickHandler::_flip()``
* ``CodeIgniter\Test\Mock\MockIncomingRequest::detectURI()``
* ``CodeIgniter\Test\Mock\MockSecurity.php::sendCookie()``


Project Files
=============

프로젝트에 포함된 수많은 파일(root, app, public, writable)이 업데이트 되었습니다.
이러한 파일들은 시스템 범위를 벗어나므로 사용자의 개입 없이 변경되지 않습니다.
프로젝트에 대한 변경 사항을 병합하는데 도움이 되는 타사 CodeIgniter 모듈 `Explore on Packagist <https://packagist.org/explore/?query=codeigniter4%20updates>`_\ 이 있습니다.

.. note:: 매우 드문 버그 수정의 경우를 제외하고, 프로젝트의 파일을 변경해도 어플리케이션은 중단되지 않습니다.
    여기에 명시된 모든 변경 사항은 다음 주요 버전까지 선택 사항이며, 모든 필수 변경 사항은 위의 섹션에서 다룹니다.

Content Changes
---------------

다음 파일에 중요한 변경 사항(사용 중단 또는 시각적 개선 등)이 적용되었으며, 업데이트된 버전을 어플리케이션과 병합하는 것이 좋습니다.

* ``app/Config/App.php``
* ``app/Config/Autoload.php``
* ``app/Config/Cookie.php``
* ``app/Config/Events.php``
* ``app/Config/Exceptions.php``
* ``app/Config/Security.php``
* ``app/Views/errors/html/*``
* ``env``
* ``spark``

All Changes
-----------

프로젝트의 변경된 모든 파일 목록입니다.
대부분은 런타임에 영향을 미치지 않는 간단한 주석 또는 서식입니다.

* ``app/Config/App.php``
* ``app/Config/Autoload.php``
* ``app/Config/ContentSecurityPolicy.php``
* ``app/Config/Cookie.php``
* ``app/Config/Events.php``
* ``app/Config/Exceptions.php``
* ``app/Config/Logger.php``
* ``app/Config/Mimes.php``
* ``app/Config/Modules.php``
* ``app/Config/Security.php``
* ``app/Controllers/BaseController.php``
* ``app/Views/errors/html/debug.css``
* ``app/Views/errors/html/error_404.php``
* ``app/Views/errors/html/error_exception.php``
* ``app/Views/welcome_message.php``
* ``composer.json``
* ``contributing/guidelines.rst``
* ``env``
* ``phpstan.neon.dist``
* ``phpunit.xml.dist``
* ``public/.htaccess``
* ``public/index.php``
* ``rector.php``
* ``spark``
