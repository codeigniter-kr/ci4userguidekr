##########
XML 헬퍼
##########

XML 헬퍼에는 XML 데이터 작업을 지원하는 기능이 포함되어 있습니다.

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

::

    helper('xml');

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: xml_convert($str[, $protect_all = FALSE])

    :param string $str: 변환할 텍스트 문자열
    :param bool $protect_all: 번호가 매겨진 엔티티 대신 잠재적 엔티티처럼 보이는 모든 콘텐츠를 보호할지 여부(예: &foo).
    :returns: XML-converted 문자열
    :rtype:	string

    문자열을 입력으로 사용하고 다음 예약된 XML 문자를 엔티티로 변환합니다.

      - 앰퍼샌드: &
      - 부등호: < >
      - 작은 따옴표와 큰 따옴표: ' "
      - 대시: -

    이 함수는 기존 번호 문자 엔티티의 일부인 경우 앰퍼샌드를 무시합니다.(예: &#123;)

    ::

        $string = '<p>Here is a paragraph & an entity (&#123;).</p>';
        $string = xml_convert($string);
        echo $string;

    outputs:

    .. code-block:: html

        &lt;p&gt;Here is a paragraph &amp; an entity (&#123;).&lt;/p&gt;
