######################################
Upgrading from 4.1.1 to 4.1.2
######################################

**BaseConnection::query() 반환 값**

이전 버전의 `BaseConnection::query()` 메소드는 쿼리가 실패하더라도 BaseResult 개체를 잘못 반환했습니다.
이 메서드는 이제 실패한 쿼리에 대해` `false``\ 를 반환하고(``DBDebug==true`` 인 경우 예외를 발생), 쓰기 유형 쿼리에 대해 부울(boolean)을 반환합니다.
``query()`` 메소드의 사용을 검토하고 값이 Result 개체 대신 부울인지 여부를 평가합니다.
어떤 쿼리가 쓰기 유형 쿼리인지에 대한 자세한 내용은 Connection 클래스의 ``BaseConnection :: isWriteType()`` 또는 DBMS 관련 재정의 ``isWriteType()``\ 을 확인하십시오.

**ConnectionInterface::isWriteType() 선언 추가**

ConnectionInterface를 구현하는 클래스를 작성한 경우 ``public function isWriteType($sql):bool``\ 로 선언 된 ``isWriteType()`` 메소드를 구현해야 합니다.
클래스가 BaseConnection을 확장하면 해당 클래스는 재정의할 수 있는 기본 ``isWriteType()`` 메소드를 제공합니다.


**Test Traits**

The ``CodeIgniter\Test`` namespace has had significant improvements to help developers with their
own test cases. Most notably test extensions have moved to Traits to make them easier to
pick-and-choose across various test case needs. The ``DatabaseTestCase`` and ``FeatureTestCase``
classes have been deprecated and their methods moved to ``DatabaseTestTrait`` and
``FeatureTestTrait`` respectively. Update your test cases to extend the main test case
and use any traits you need. For example::

    use CodeIgniter\Test\DatabaseTestCase;

    class MyDatabaseTest extends DatabaseTestCase
    {
        public function testBadRow()
        {

... becomes::

    use CodeIgniter\Test\CIUnitTestCase;
    use CodeIgniter\Test\DatabaseTestTrait;

    class MyDatabaseTest extends CIUnitTestCase
    {
        use DatabaseTestTrait;

        public function testBadRow()
        {

Finally, ``ControllerTester`` has been superseded by ``ControllerTestTrait`` to standardize
approach and take advantage of the updated response testing (below).

**Test Responses**

The tools for testing responses have been consolidated and improved. A new
``TestResponse`` replaces ``ControllerResponse`` and ``FeatureResponse`` with a complete
set of methods and properties expected from both those classes. In most cases these changes
will be "behind the scenes" by ``ControllerTestTrait`` and ``FeatureTestCase``, but two
changes to be aware of:

* ``TestResponse``'s ``$request`` and ``$response`` properties are protected and should only be access through their getter methods, ``request()`` and ``response()``
* ``TestResponse`` does not have ``getBody()`` and ``setBody()`` methods, but rather uses the Response methods directly, e.g.: ``$body = $result->response()->getBody();``
