#############################
Upgrading from 4.1.3 to 4.1.4
#############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer Installation App Starter Upgrading <app-starter-upgrading>`
- :ref:`Composer Installation Adding CodeIgniter4 to an Existing Project Upgrading <adding-codeigniter4-upgrading>`
- :ref:`Manual Installation Upgrading <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

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

프로젝트 공간의 모든 파일이 새 코딩 스타일로 다시 포맷되었습니다.
기존 코드에는 영향을 미치지 않지만 프레임워크의 파일 버전과 일치하도록 사용자 자신의 프로젝트에 업데이트된 코딩 스타일을 적용할 수 있습니다.