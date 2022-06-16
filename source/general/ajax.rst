##############
AJAX Requests
##############

``IncomingRequest::isAJAX()`` 메소드는 ``X-Requested-With`` 헤더를 사용하여 요청이 XHR인지 정상인지를 정의합니다. 
그러나 가장 최근의 JavaScript 구현 (예 : fetch)은 더 이상 요청과 함께 이 헤더를 보내지 않으므로 ``IncomingRequest::isAJAX()``\ 의 결과값 안정성이 떨어집니다.
이 헤더가 없으면 요청(Request)은 XHR 여부를 정의할 수 없기 때문입니다.

이 문제를 해결하는 지금까지의 가장 효율적인 방법은 요청 헤더를 수동으로 정의하여 정보를 서버로 전송하도록 하여 요청(Request)이 XHR 임을 식별할 수 있게 하는 것입니다.

Fetch API 및 기타 JavaScript 라이브러리에서 ``X-Requested-With`` 헤더를 전송하는 방법은 다음과 같습니다.

.. contents::
    :local:
    :depth: 2

Fetch API
=========

.. code-block:: javascript

    fetch(url, {
        method: "get",
        headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest"
        }
    });

jQuery
======

`jQuery 공식 문서 <https://api.jquery.com/jquery.ajax/>`_\ 에 따르면 ``X-Requested-With`` 헤더는 모든 ``$.ajax()`` 요청의 표준 헤더이기 때문에 
이 헤더를 명시적으로 보내지 않아도 됩니다. 
명시적으로 헤더를 보내야 할 경우가 있다면 다음과 같이 하십시오.

.. code-block:: javascript

    $.ajax({
        url: "your url",
        headers: {'X-Requested-With': 'XMLHttpRequest'}
    });  

VueJS
=====

VueJS에서 Axios를 사용한다면 다음 코드를 ``created`` 함수에 추가하면 됩니다.

.. code-block:: javascript

    axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

React
=====

.. code-block:: javascript

    axios.get("your url", {headers: {'Content-Type': 'application/json'}});