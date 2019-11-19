########################
유틸리티
########################

데이터베이스 유틸리티 클래스에는 데이터베이스 관리를 돕는 메소드가 포함되어 있습니다.

.. contents::
    :local:
    :depth: 2

*******************
결과를 XML로 변환
*******************

**getXMLFromResult()**

이 메소드는 데이터베이스 결과를 xml로 리턴합니다. 
다음과 같이 하십시오.

::

    $model = new class extends \CodeIgniter\Model {
        protected $table      = 'foo';
        protected $primaryKey = 'id';
    };
    $db = \Closure::bind(function ($model) {
        return $model->db;
    }, null, $model)($model);

    $util = (new \CodeIgniter\Database\Database())->loadUtils($db);
    echo $util->getXMLFromResult($model->get());

다음과 같은 XML 결과를 얻을 수 있습니다.

::

    <root>
        <element>
            <id>1</id>
            <name>bar</name>
        </element>
    </root>
