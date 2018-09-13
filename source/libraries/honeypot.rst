=====================
허니팟 클래스
=====================

The Honeypot Class makes it possible to determine when a Bot makes a request to a CodeIgniter4 application,
If it's enabled in ``Application\Config\Filters.php`` file. This is done by attaching form fields to any form,
and this form field is hidden from human but accessible to Bot. When data is entered into the field it's 
assumed the request is coming from a Bot, then an execption is thrown.
허니팟 클래스는 CodeIgniter4 응용 프로그램에 Bot이 요청할 때 이를 결정할 수있게 해줍니다 ``Application\Config\Filters.php``. 이것은 양식 필드를 모든 양식에 첨부하여 이루어지며이 양식 필드는 사람에게는 보이지 않지만 Bot에게는 액세스 할 수 있습니다. 필드에 데이터가 입력되면 요청이 Bot에서 왔다고 가정하고 실행이 발생합니다.

.. contents:: Page Contents

허니팟 사용 설정
=====================

To enable Honeypot changes has to be made to the ``Application\Config\Filters.php``. Just uncomment honeypot
from the ``$globals`` Array.
허니팟을 변경하려면를 ``Application\Config\Filters.php`` 을 변경해야합니다. ``$globals`` 배열 에서 허니팟의 주석을 제거하십시오 .

::

    public $globals = [
            'before' => [
                //'honeypot'
                // 'csrf',
            ],
            'after'  => [
                'toolbar',
                //'honeypot'
            ]
        ];

허니팟 커스터마이징
=====================

Honeypot can be customized. It allows the following customization. Customization file can found in 
``Application\Config\Honeypot.php`` and ``.env``.
허니팟은 사용자 정의 할 수 있습니다. 다음과 같은 사용자 정의가 가능합니다. 사용자 정의 파일은 ``Application\Config\Honeypot.php`` 또는 ``.env`` 입니다.

* ``Display``
* ``Label``
* ``Field Name``
* ``Template``

**Display**

Display can contain values of ``True`` or ``False``, meaning display the template and hide the template
respectively. The value for display is called ``hidden``.
Dispaly 는 ``True`` 또는 ``False`` 의 값이 포함될 수 있으며, 템플리트를 표시하거나 숨기는 것을 의미합니다. display 값은 ``hidden`` 입니다.

::

    public $hidden = true;

The above is for ``Application\Config\Honeypot.php``.::

    honeypot.hidden = 'true'

The above is for ``.env``

**Label**

This the label for the input field. The value for label is called ``label``.
입력 필드의 레이블입니다. label의 값을 ``label`` 이라고 부릅니다.

::

    public $label = 'Fill This Field';

The above is for ``Application\Config\Honeypot.php``.::

    honeypot.label = 'Fill This Field'

The above is for ``.env``

**Field Name**

This the field name for the input field. The value for the field name is called ``name``.
입력 필드의 필드 이름입니다. 필드 이름의 값이 호출 ``name`` 됩니다.
::

    public $name = 'honeypot';

The above is for ``Application\Config\Honeypot.php``.::

    honeypot.name = 'honeypot'

The above is for ``.env``

**Template**

This is the template of the honeypot. The value for the template is called ``template``.
이것은 허니팟의 템플릿입니다. 템플릿의 값이 호출 ``template`` 됩니다.
::

    public $template = '<label>{label}</label><input type="text" name="{name}" value=""/>';

The above is for ``Application\Config\Honeypot.php``.::

    honeypot.template = '<label>{label}</label><input type="text" name="{name}" value=""/>'

The above is for ``.env``