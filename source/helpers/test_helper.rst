###########
Test 헬퍼
###########

테스트 헬퍼 파일에는 프로젝트 테스트를 지원하는 기능이 포함되어 있습니다.

.. contents::
  :local:
  :depth: 2

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

.. literalinclude:: test_helper/001.php

사용 가능한 함수
===================

다음 함수를 사용할 수 있습니다.

.. php:function:: fake($model, array $overrides = null)

    :param	Model|object|string	$model: Fabricator와 함께 사용할 모델의 인스턴스(instance) 또는 이름
    :param	array|null $overrides: Fabricator::setOverrides()에 전달할 데이터 재정의
    :returns:	Fabricator가 DB에 작성하여 추가한 임의의 항목
    :rtype:	object|array

    ``CodeIgniter\Test\Fabricator``\ 를 사용하여 만들어진 임의의 항목을 데이터베이스에 추가합니다.

    .. literalinclude:: test_helper/002.php
