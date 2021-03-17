######################################
Upgrading from 4.1.1 to 4.1.2
######################################

**BaseConnection::query() 반환 값**

이전 버전의 `BaseConnection::query()` 메소드는 쿼리가 실패하더라도 BaseResult 개체를 잘못 반환했습니다.
이 메서드는 이제 실패한 쿼리에 대해` `false``\ 를 반환하고(``DBDebug==true`` 인 경우 예외를 발생), 쓰기 유형 쿼리에 대해 부울(boolean)을 반환합니다.
``query()`` 메소드의 사용을 검토하고 값이 Result 개체 대신 부울인지 여부를 평가합니다.
어떤 쿼리가 쓰기 유형 쿼리인지에 대한 자세한 내용은 Connection 클래스의 ``BaseConnection :: isWriteType()`` 또는 DBMS 관련 재정의 ``isWriteType()``\ 을 확인하십시오.

**ConnectionInterface::isWriteType() 선언 추가**

If you have written any classes that implement ConnectionInterface, these must now implement the ``isWriteType()`` method, declared as ``public function isWriteType($sql): bool``.
If your class extends BaseConnection, then that class will provide a basic ``isWriteType()`` method which you might want to override.

ConnectionInterface를 구현하는 클래스를 작성한 경우 ``public function isWriteType($sql):bool``\ 로 선언 된 ``isWriteType()`` 메소드를 구현해야 합니다.
클래스가 BaseConnection을 확장하면 해당 클래스는 재정의할 수 있는 기본 ``isWriteType()`` 메소드를 제공합니다.
