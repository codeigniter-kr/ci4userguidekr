################
폼(Form) 헬퍼
################

The Form Helper file contains functions that assist in working with forms.

.. contents::
    :local:
    :depth: 2

.. raw:: html

  <div class="custom-index container"></div>

헬퍼 로드
===================

이 헬퍼는 다음 코드를 사용하여 로드됩니다.

::

    helper('form');

이스케이프 필드 값
=====================

폼 요소내의 HTML과 따옴표와 같은 문자를 사용해야 할 때가 있습니다.
안전하게 이를 처리하려면 :doc:`공통 함수 <../general/common_functions>`\ 의 :php:func:`esc()` 함수를 사용해야 합니다.

다음 예를 살펴보십시오.

::

    $string = 'Here is a string containing "quoted" text.';

    <input type="text" name="myfield" value="<?= $string ?>" />

위의 문자열에는 따옴표 세트가 포함되어 있으므로 폼이 중단됩니다.
:php:func:`esc ()` 함수는 HTML 특수 문자를 변환하여 안전하게 폼을 사용할 수 있도록 합니다.

::

    <input type="text" name="myfield" value="<?= esc($string) ?>" />

.. note:: 이 페이지에 나열된 폼 헬퍼 함수를 사용하고 값을 연관 배열로 전달하면 폼의 값이 자동으로 이스케이프되므로 :php:func:`esc()` 함수를 호출할 필요가 없습니다.
    문자열로 전달할 양식 요소를 직접 만드는 경우에만 사용하십시오.

사용 가능한 함수
===================

사용 가능한 함수는 다음과 같습니다.

.. php:function:: form_open([$action = ''[, $attributes = ''[, $hidden = []]]])

    :param	string	$action: 폼 액션/타겟 URI 문자열
    :param	mixed	$attributes: HTML 속성, 배열 또는 이스케이프된 문자열
    :param	array	$hidden: 숨겨진(hidden) 필드 정의의 배열
    :returns:	HTML 폼 태그
    :rtype:	string

    **환경 설정에서 빌드한 기본 URL**\ 을 사용하여 여는 폼 태그를 만듭니다.
    선택적으로 폼 속성과 숨겨진 입력 필드를 추가할 수 있으며, 구성 파일의 문자 세트 값을 기반으로 `accept-charset` 속성을 추가합니다.

    HTML을 직접 하드 코딩하는 대신 이 태그를 사용하면, 사이트의 URL이 변경될 때 별도의 URL변경이 필요하지 않습니다.

    Here's a simple example::

        echo form_open('email/send');

    위의 예는 기본 URL과 "email/send" URI 세그먼트를 가리키는 폼을 작성합니다.

    ::

        <form method="post" accept-charset="utf-8" action="http://example.com/index.php/email/send">

    다음과 같이 {locale}\ 을 추가할 수 있습니다
    
    ::

        echo form_open('{locale}/email/send');

    위의 예에서는 기본 URL과 "email/send" URI 세그먼트가 있는 현재 요청 로케일(locale)을 가리키는 양식(form)을 만듭니다.

    ::

        <form method="post" accept-charset="utf-8" action="http://example.com/index.php/en/email/send">

    **Adding Attributes**

        아래와 같이 두 번째 매개 변수에 연관 배열을 전달하여 속성을 추가할 수 있습니다.

        ::

            $attributes = ['class' => 'email', 'id' => 'myform'];
            echo form_open('email/send', $attributes);

        또는 두 번째 매개 변수를 문자열로 지정할 수 있습니다.
        
        ::

            echo form_open('email/send', 'class="email" id="myform"');

        위의 예제는 이와 비슷한 형식을 만듭니다.

        ::

            <form method="post" accept-charset="utf-8" action="http://example.com/index.php/email/send" class="email" id="myform">

        CSRF 필터가 켜져 있으면 `form_open()` 은 폼의 시작 부분에 CSRF 필드를 생성합니다.
        csrf_id를 $attribute 배열중 하나로 전달하여 이 필드의 ID를 지정할 수 있습니다.

        ::

            form_open('/u/sign-up', ['csrf_id' => 'my-id']);

        다음과 같이 표시됩니다.

        ::

            <form action="/u/sign-up" method="post" accept-charset="utf-8">
            <input type="hidden" id="my-id" name="csrf_field" value="964ede6e0ae8a680f7b8eab69136717d" />

        .. note:: CSRF 필드의 자동 생성을 사용하려면 CSRF 필터를 폼 페이지로 설정해야 합니다. 대부분 ``GET``\ 을  사용하여 요청됩니다.

    **Adding Hidden Input Fields**

        다음과 같이 연관 배열을 세 번째 매개 변수에 전달하여 숨겨진 필드를 추가할 수 있습니다.
        
        ::

            $hidden = ['username' => 'Joe', 'member_id' => '234'];
            echo form_open('email/send', '', $hidden);

        잘못된 값을 전달하여 두 번째 매개 변수를 건너뛸 수 있습니다.

        위의 예는 이와 비슷한 폼을 만듭니다.
        
        ::

            <form method="post" accept-charset="utf-8" action="http://example.com/index.php/email/send">
            <input type="hidden" name="username" value="Joe" />
            <input type="hidden" name="member_id" value="234" />

.. php:function:: form_open_multipart([$action = ''[, $attributes = ''[, $hidden = []]]])

    :param	string	$action: 폼 액션/타겟 URI 문자열
    :param	mixed	$attributes: HTML 속성, 배열 또는 이스케이프된 문자열
    :param	array	$hidden: 숨겨진(hidden) 필드 정의의 배열
    :returns:	HTML multipart 폼 시작 태그
    :rtype:	string

    이 함수는 위의 :php:func:`form_open()`\ 과 동일하지만, *multipart* 속성을 추가하여 파일을 업로드할 수 있습니다.

.. php:function:: form_hidden($name[, $value = ''])

    :param	string	$name: 필드 이름
    :param	string	$value: 필드 값
    :returns:	HTML 숨겨진 입력 필드 태그
    :rtype:	string

    숨겨진 입력 필드를 생성합니다. 하나의 필드를 만들기 위해 이름/값 문자열을 사용할 수 있습니다

    ::

        form_hidden('username', 'johndoe');
        // Would produce: <input type="hidden" name="username" value="johndoe" />

    ... 또는 연관 배열을 사용하여 여러개 필드를 만들 수 있습니다
    
    ::

        $data = [
            'name'	=> 'John Doe',
            'email'	=> 'john@example.com',
            'url'	=> 'http://example.com',
        ];

        echo form_hidden($data);

        /*
            Would produce:
            <input type="hidden" name="name" value="John Doe" />
            <input type="hidden" name="email" value="john@example.com" />
            <input type="hidden" name="url" value="http://example.com" />
        */

    값 배열에 연관 배열을 전달할 수도 있습니다.
    
    ::

        $data = [
            'name'	=> 'John Doe',
            'email'	=> 'john@example.com',
            'url'	=> 'http://example.com',
        ];

        echo form_hidden('my_array', $data);

        /*
            Would produce:

            <input type="hidden" name="my_array[name]" value="John Doe" />
            <input type="hidden" name="my_array[email]" value="john@example.com" />
            <input type="hidden" name="my_array[url]" value="http://example.com" />
        */

    추가 속성으로 숨겨진 입력 필드를 만들려면
    
    ::

        $data = [
            'type'	=> 'hidden',
            'name'	=> 'email',
            'id'	=> 'hiddenemail',
            'value'	=> 'john@example.com',
            'class'	=> 'hiddenemail',
        ];

        echo form_input($data);

        /*
            Would produce:

            <input type="hidden" name="email" value="john@example.com" id="hiddenemail" class="hiddenemail" />
        */

.. php:function:: form_input([$data = ''[, $value = ''[, $extra = ''[, $type = 'text']]]])

    :param	array	$data: 필드 속성 데이터
    :param	string	$value: 필드 값
    :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 특성
    :param  string  $type: 입력 필드 유형 : 'text', 'email', 'number', etc.
    :returns:	HTML 텍스트 입력 필드 태그
    :rtype:	string

    표준 텍스트 입력 필드를 생성합니다. 첫 번째, 두 번째 매개 변수에 필드 이름과 값을 전달합니다.

    ::

        echo form_input('username', 'johndoe');

    또는 양식에 포함할 데이터가 들어 있는 연관 배열을 전달할 수 있습니다.
    
    ::

        $data = [
            'name'      => 'username',
            'id'        => 'username',
            'value'     => 'johndoe',
            'maxlength' => '100',
            'size'      => '50',
            'style'     => 'width:50%',
        ];

        echo form_input($data);

        /*
            Would produce:

            <input type="text" name="username" value="johndoe" id="username" maxlength="100" size="50" style="width:50%" />
        */

    JavaScript와 같은 일부 데이터를 폼에 추가하려면 문자열로 세 번째 매개 변수에 전달합니다.
    
    ::

        $js = 'onClick="some_function ()"';
        echo form_input('username', 'johndoe', $js);

    또는 배열로 전달합니다.
    
    ::

        $js = ['onClick' => 'some_function ();'];
        echo form_input('username', 'johndoe', $js);

    HTML5 입력 필드의 확장된 입력 유형은 네 번째 매개 변수로 전달합니다.

    ::

        echo form_input('email', 'joe@example.com', ['placeholder' => 'Email Address...'], 'email');

        /*
            Would produce:

            <input type="email" name="email" value="joe@example.com" placeholder="Email Address..." />
        */

.. php:function:: form_password([$data = ''[, $value = ''[, $extra = '']]])

    :param	array	$data: 필드 속성 데이터
    :param	string	$value: 필드 값
    :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 속성
    :returns:	HTML 비밀번호 입력 필드 태그
    :rtype:	string

    이 함수는 "password" 입력 타입을 사용한다는 점을 제외하면 위의 :php:func:`form_input()` 함수와 동일합니다.

.. php:function:: form_upload([$data = ''[, $value = ''[, $extra = '']]])

    :param	array	$data: 필드 속성 데이터
        :param	string	$value: 필드 값
        :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 속성
        :returns:	HTML 파일 업로드 입력 필드 태그
        :rtype:	string

        이 함수는 "file" 입력 유형을 사용하여 파일을 업로드하는 데 사용될 수 있다는 점을 제외하고 위의 :php:func:`form_input ()` 함수와 동일합니다.

.. php:function:: form_textarea([$data = ''[, $value = ''[, $extra = '']]])

    :param	array	$data: 필드 속성 데이터
        :param	string	$value: 필드 값
        :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 속성
        :returns:	HTML textarea 태그
        :rtype:	string

        이 함수는 "textarea" 유형을 생성한다는 점을 제외하고 위의 :php:func:`form_input()` 함수와 동일합니다.

    .. note:: Instead of the *maxlength* and *size* attributes in the above example, you will instead specify *rows* and *cols*.

.. php:function:: form_dropdown([$name = ''[, $options = [][, $selected = [][, $extra = '']]]])

    :param	string	$name: 필드 이름
    :param	array	$options: 나열할 옵션의 연관 배열
    :param	array	$selected: *selected* 속성으로 표시할 필드 목록
    :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 속성
    :returns:	HTML 드롭 다운 선택(select) 필드 태그
    :rtype:	string

    표준 드롭 다운 필드를 만들 수 있습니다. 
    필드 이름을 첫 번째 매개 변수로 연관 옵션 배열을 두 번째 매개 변수로 선택하려는 값은 세 번째 매개 변수로 전달합니다.
    세 번째 매개 변수를 통해 여러 항목의 배열을 전달할 수 있으며, 헬퍼가 여러(multiple) 항목을 선택(select)합니다.

    Example::

        $options = [
            'small'  => 'Small Shirt',
            'med'    => 'Medium Shirt',
            'large'  => 'Large Shirt',
            'xlarge' => 'Extra Large Shirt',
        ];

        $shirts_on_sale = ['small', 'large'];
        echo form_dropdown('shirts', $options, 'large');

        /*
            Would produce:

            <select name="shirts">
                <option value="small">Small Shirt</option>
                <option value="med">Medium Shirt</option>
                <option value="large" selected="selected">Large Shirt</option>
                <option value="xlarge">Extra Large Shirt</option>
            </select>
        */

        echo form_dropdown('shirts', $options, $shirts_on_sale);

        /*
            Would produce:

            <select name="shirts" multiple="multiple">
                <option value="small" selected="selected">Small Shirt</option>
                <option value="med">Medium Shirt</option>
                <option value="large" selected="selected">Large Shirt</option>
                <option value="xlarge">Extra Large Shirt</option>
            </select>
        */

    <select> 태그의 id 속성 또는 JavaScript와 같은 추가 데이터를 포함하도록 하려면 네 번째 매개 변수에서 문자열로 전달합니다.

    ::

        $js = 'id="shirts" onChange="some_function ();"';
        echo form_dropdown('shirts', $options, 'large', $js);

    또는 배열로 전달할 수 있습니다.
    
    ::

        $js = [
            'id'       => 'shirts',
            'onChange' => 'some_function ();'
        ];
        echo form_dropdown('shirts', $options, 'large', $js);

    ``$options``\ 로 전달된 배열이 다차원 배열이면 ``form_dropdown()``\ 은 배열 키를 레이블로 하여 <optgroup>을 생성합니다.

.. php:function:: form_multiselect([$name = ''[, $options = [][, $selected = [][, $extra = '']]]])

    :param	string	$name: 필드 이름
    :param	array	$options: 나열할 옵션의 연관 배열
    :param	array	$selected: *selected* 속성으로 표시할 필드 목록
    :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 속성
    :returns:	HTML 드롭 다운 다중 선택 필드 태그
    :rtype:	string

    표준 다중 선택 필드를 만들 수 있습니다.
    필드 이름은 첫 번째 매개 변수에, 연관 옵션 배열은 두 번째 매개 변수에 선택하려는 값은 세 번째 매개 변수로 전달합니다.

    매개 변수 사용법은 위의 :php:func:`form_dropdown()`\ 을 사용하는 것과 동일하지만 필드 이름은 ``foo[]``\ 와 같은 POST 배열 구문을 사용해야 합니다.

.. php:function:: form_fieldset([$legend_text = ''[, $attributes = []]])

    :param	string	$legend_text: <legend> 태그에 넣을 텍스트
    :param	array	$attributes: <fieldset> 태그에서 설정할 속성
    :returns:	HTML 필드 셋 여는 태그
    :rtype:	string

    fieldset/legend 필드를 생성합니다.

    ::

        echo form_fieldset('Address Information');
        echo "<p>fieldset content here</p>\n";
        echo form_fieldset_close();

        /*
            Produces:

                <fieldset>
                    <legend>Address Information</legend>
                                    <p>form content here</p>
                </fieldset>
        */

    다른 기능과 마찬가지로 추가 속성을 설정하려는 경우 두 번째 매개 변수에 연관 배열을 전달합니다.
    
    ::

        $attributes = [
            'id'	=> 'address_info',
            'class'	=> 'address_info'
        ];

        echo form_fieldset('Address Information', $attributes);
        echo "<p>fieldset content here</p>\n";
        echo form_fieldset_close();

        /*
            Produces:

            <fieldset id="address_info" class="address_info">
                <legend>Address Information</legend>
                <p>form content here</p>
            </fieldset>
        */

.. php:function:: form_fieldset_close([$extra = ''])

    :param	string	$extra: 닫는 태그 뒤에 추가할 내용 *있는 그대로*
    :returns:	HTML 필드 셋 닫기 태그
    :rtype:	string

    닫는 </fieldset> 태그를 생성합니다. 
    이 기능을 사용하는 유일한 장점은 태그 아래에 추가될 데이터를 전달할 수 있다는 것입니다.

    ::

        $string = '</div></div>';
        echo form_fieldset_close($string);
        // Would produce: </fieldset></div></div>

.. php:function:: form_checkbox([$data = ''[, $value = ''[, $checked = false[, $extra = '']]]])

    :param	array	$data: 필드 속성 데이터
    :param	string	$value: 필드 값
    :param	bool	$checked: 체크박스(checkbox)의 *checked* 표시 여부
    :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 속성
    :returns:	HTML 체크박스 입력 태그
    :rtype:	string

    checkbox 필드를 생성합니다.
    
    ::

        echo form_checkbox('newsletter', 'accept', true);
        // Would produce:  <input type="checkbox" name="newsletter" value="accept" checked="checked" />

    세 번째 매개 변수에는 checkbox를 선택해야 하는지 여부를 결정하는 부울 true/false가 포함됩니다.

    이 헬퍼의 다른 폼 함수와 마찬가지로 속성 배열을 함수에 전달할 수 있습니다.
    
    ::

        $data = [
            'name'    => 'newsletter',
            'id'      => 'newsletter',
            'value'   => 'accept',
            'checked' => true,
            'style'   => 'margin:10px'
        ];

        echo form_checkbox($data);
        // Would produce: <input type="checkbox" name="newsletter" id="newsletter" value="accept" checked="checked" style="margin:10px" />

    또한 다른 함수와 마찬가지로 태그에 JavaScript와 같은 추가 데이터를 포함 시키려면 네 번째 매개 변수에서 문자열로 전달합니다

    ::

        $js = 'onClick="some_function ()"';
        echo form_checkbox('newsletter', 'accept', true, $js);

    또는 배열로 전달할 수 있습니다

    ::

        $js = ['onClick' => 'some_function ();'];
        echo form_checkbox('newsletter', 'accept', true, $js);

.. php:function:: form_radio([$data = ''[, $value = ''[, $checked = false[, $extra = '']]]])

    :param	array	$data: 필드 속성 데이터
    :param	string	$value: 필드 값
    :param	bool	$checked: Whether to mark the radio button as being *checked*
    :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 속성
    :returns:	An HTML radio input tag
    :rtype:	string

    이 함수는 "radio" 입력 유형을 사용한다는 점을 제외하고 위의 :php:func:`form_checkbox()` 함수와 모든면에서 동일합니다.

.. php:function:: form_label([$label_text = ''[, $id = ''[, $attributes = []]]])

    :param	string	$label_text: <label> 태그에 넣을 텍스트
    :param	string	$id: 라벨을 만들 양식 요소의 ID
    :param	string	$attributes: HTML 속성
    :returns:	HTML 필드 레이블 태그
    :rtype:	string

    <label>을 생성합니다. 
    
    ::

        echo form_label('What is your Name', 'username');
        // Would produce:  <label for="username">What is your Name</label>

    다른 함수와 마찬가지로 추가 속성을 설정하려면 세 번째 매개 변수에 연관 배열을 제출합니다.

    ::

        $attributes = [
            'class' => 'mycustomclass',
            'style' => 'color: #000;'
        ];

        echo form_label('What is your Name', 'username', $attributes);
        // Would produce:  <label for="username" class="mycustomclass" style="color: #000;">What is your Name</label>

.. php:function:: form_submit([$data = ''[, $value = ''[, $extra = '']]])

    :param	string	$data: Button name
    :param	string	$value: Button value
    :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 속성
    :returns:	HTML submit 태그
    :rtype:	string

    표준 submit 버튼을 생성합니다.
    
    ::

        echo form_submit('mysubmit', 'Submit Post!');
        // Would produce:  <input type="submit" name="mysubmit" value="Submit Post!" />

    다른 함수와 마찬가지로 고유한 속성은 첫 번째 매개 변수에 연관 배열로 제출합니다.
    세 번째 매개 변수를 사용하면 JavaScript와 같은 추가 데이터를 양식에 추가할 수 있습니다.

.. php:function:: form_reset([$data = ''[, $value = ''[, $extra = '']]])

    :param	string	$data: Button name
    :param	string	$value: 버튼 값
    :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 속성
    :returns:	HTML 입력 reset 버튼 태그
    :rtype:	string
    
    표준 reset 버튼을 생성합니다.
    사용 방법은 :func:`form_submit ()`\ 와 동일합니다.

.. php:function:: form_button([$data = ''[, $content = ''[, $extra = '']]])

    :param	string	$data: 버튼 이름
    :param	string	$content: 버튼 라벨
    :param	mixed	$extra: 배열 또는 리터럴 문자열로 태그에 추가할 추가 속성
    :returns:	HTML button 태그
    :rtype:	string

    표준 버튼 엘리먼트를 생성합니다. 
    첫 번째와 두 번째 매개 변수에 버튼 이름과 내용만 최소한으로 전달할 수 있습니다.

    ::

        echo form_button('name','content');
        // Would produce: <button name="name" type="button">Content</button>

    또는 폼에 포함하려는 데이터가 포함된 연관 배열을 전달할 수 있습니다.
    
    ::

        $data = [
            'name'    => 'button',
            'id'      => 'button',
            'value'   => 'true',
            'type'    => 'reset',
            'content' => 'Reset'
        ];

        echo form_button($data);
        // Would produce: <button name="button" id="button" value="true" type="reset">Reset</button>

    폼에 JavaScript와 같은 일부 추가 데이터를 포함 시키려면 세 번째 매개 변수에서 문자열로 전달합니다.

    ::

        $js = 'onClick="some_function ()"';
        echo form_button('mybutton', 'Click Me', $js);

.. php:function:: form_close([$extra = ''])

    :param	string	$extra: 닫는 태그 뒤에 추가할 사항
    :returns:	HTML form 닫는 태그
    :rtype:	string

    닫는 </form> 태그를 생성합니다.
    이 기능을 사용하는 유일한 장점은 태그 아래에 추가될 데이터를 전달할 수 있다는 것입니다.

    ::

        $string = '</div></div>';
        echo form_close($string);
        // Would produce:  </form> </div></div>

.. php:function:: set_value($field[, $default = ''[, $html_escape = true]])

    :param	string	$field: 필드 이름
    :param	string	$default: 기본 값
    :param  bool	$html_escape: 값의 HTML 이스케이프 기능 해제 여부
    :returns:	필드 값
    :rtype:	string

    입력 양식 또는 텍스트 영역의 값을 설정할 수 있습니다.
    함수의 첫 번째 매개 변수를 통해 필드 이름을 제공해야 합니다.
    두 번째 (옵션) 매개 변수를 사용하면 양식의 기본값을 설정할 수 있습니다.
    세 번째 (옵션) 매개 변수를 사용하면 이 함수를 :php:func:`form_input()`\ 과 함께 사용해야 하고 이중 이스케이프를 피해야 하는 경우 값의 HTML 이스케이프를 해제할 수 있습니다.

    ::

        <input type="text" name="quantity" value="<?= set_value('quantity', '0'); ?>" size="50" />

    처음 로드할 때 위의 폼에 "0"\ 이 표시됩니다.

.. php:function:: set_select($field[, $value = ''[, $default = false]])

    :param	string	$field: 필드 이름
    :param	string	$value: 확인할 값
    :param	string	$default: 값이 기본 값인지 여부
    :returns:	'selected' 속성 또는 빈 문자열
    :rtype:	string

    <select> 메뉴를 사용하는 경우이 기능을 사용하면 선택한 메뉴 항목을 표시 할 수 있습니다.

    첫 번째 매개 변수는 선택 메뉴의 이름을 포함해야하고 두 번째 매개 변수는 각 항목의 값을 포함해야하며 세 번째 (선택적) 매개 변수를 사용하면 항목을 기본값으로 설정할 수 있습니다 (부울 true / false 사용).

    ::

        <select name="myselect">
            <option value="one" <?= set_select('myselect', 'one', true); ?> >One</option>
            <option value="two" <?= set_select('myselect', 'two'); ?> >Two</option>
            <option value="three" <?= set_select('myselect', 'three'); ?> >Three</option>
        </select>

.. php:function:: set_checkbox($field[, $value = ''[, $default = false]])

    :param	string	$field: 필드 이름
        :param	string	$value: 확인할 값
        :param	string	$default: 값이 기본 값인지 여부
        :returns:	'checked' 속성 or 빈 문자열
        :rtype:	string

        제출된 상태의 checkbox를 표시합니다.

        첫 번째 매개 변수에는 확인란의 이름이 있어야 하고 두 번째 매개 변수에는 값이 있어야 하며 세 번째 (선택적) 매개 변수를 사용하면 항목을 기본값으로 설정할 수 있습니다 (부울 true / false 사용).

        Example::

        <input type="checkbox" name="mycheck" value="1" <?= set_checkbox('mycheck', '1'); ?> />
        <input type="checkbox" name="mycheck" value="2" <?= set_checkbox('mycheck', '2'); ?> />

.. php:function:: set_radio($field[, $value = ''[, $default = false]])

    :param	string	$field: 필드 이름
        :param	string	$value: 확인할 값
        :param	string	$default: 값이 기본 값인지 여부
        :returns:	'checked' 속성 or 빈 문자열
        :rtype:	string

        제출된 상태의 radio 버튼을 표시합니다.
        이 함수는 위의 :php:func:`set_checkbox()` 함수와 동일합니다.

    Example::

        <input type="radio" name="myradio" value="1" <?= set_radio('myradio', '1', true); ?> />
        <input type="radio" name="myradio" value="2" <?= set_radio('myradio', '2'); ?> />

    .. note:: 폼 유효성 검사 클래스를 사용하는 경우 ``set_*()`` 함수가 작동하려면 항상 비어있는 경우에도 필드에 대한 규칙을 지정해야합니다.
        폼 유효성 검사 개체를 정의하면 ``set _*()``\ 에 대한 컨트롤이 일반 헬퍼 함수 대신 클래스의 메소드로 전달되기 때문입니다.