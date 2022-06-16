#############################
4.0.x에서 4.0.4로 업그레이드
#############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer Installation App Starter Upgrading <app-starter-upgrading>`
- :ref:`Composer Installation Adding CodeIgniter4 to an Existing Project Upgrading <adding-codeigniter4-upgrading>`
- :ref:`Manual Installation Upgrading <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

CodeIgniter 4.0.4는 :doc:`컨트롤러 필터 </incoming/filters>`\ 의 구현(implementation) 버그를 수정하여 ``FilterInterface``\ 를 구현하는 코드를 수정합니다.

**Update FilterInterface declarations**

``after()``\ 와 ``before()``\ 의 메소드는 ``$arguments``\ 를 포함하도록 업데이트합니다.

아래처럼 정의된 함수는

::

    public function before(RequestInterface $request)
    public function after(RequestInterface $request, ResponseInterface $response)

다음과 같이 변경합니다.

::

    public function before(RequestInterface $request, $arguments = null)
    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)

