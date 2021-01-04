########################
지역화(Localization)
########################

.. contents::
    :local:
    :depth: 2

********************
지역화 작업
********************

CodeIgniter는 어플리케이션을 다른 언어로 지역화하는데 도움이 되는 몇 가지 도구를 제공합니다.
어플리케이션의 전체 지역화는 복잡한 주제이지만 어플리케이션에서 지원되는 언어로 문자열을 바꾸는 것은 간단합니다.

Language strings are stored in the **app/Language** directory, with a sub-directory for each supported language
언어 문자열은 지원되는 각 언어의 하위 디렉토리와 함께 **app/Language** 디렉토리에 저장됩니다.

::

    /app
        /Language
            /en
                app.php
            /fr
                app.php

.. important:: 로케일 감지는 ``IncomingRequest`` 클래스를 사용하는 웹 기반 요청에만 작동합니다. 커맨드 라인 요청에는 이러한 기능이 없습니다.

지역화 구성
======================

모든 사이트에는 기본 language/locale이 있으며, **Config/App.php**\ 에서 설정할 수 있습니다.

::

    public $defaultLocale = 'en';

값은 어플리케이션이 텍스트 문자열 및 기타 형식을 관리하는데 사용하는 모든 문자열입니다.
`BCP 47 <http://www.rfc-editor.org/rfc/bcp/bcp47.txt>`_ 언어 코드를 사용하는 것이 좋습니다.
이를 따르면 "미국 영어"의 경우는 ``en-US``, "French/France"의 경우는 ``fr-FR``\ 과 같은 언어 코드가 생성됩니다.
이에 대한 더 읽기 쉬운 소개는 `W3C 사이트  <https://www.w3.org/International/articles/language-tags/>`_\ 에서 찾을 수 있습니다.

시스템은 정확하게 일치하는 것을 찾을 수 없는 경우 더 일반적인 언어 코드로 대체될 만큼 똑똑합니다.
로케일 코드가 **en-US**\ 로 설정되어 있고 **en**\ 에 언어 파일만 설정되어 있으면, 더 구체적인 **en-US**\ 에 대해 아무것도 없기 때문에 이 파일이 사용됩니다.
그러나 **app/Language/en-US** 언어 디렉토리가 존재하면 먼저 사용됩니다.

로케일 감지
================

요청중에 올바른 로케일을 감지하기 위해 지원되는 두 가지 방법이 있습니다.
첫 번째는 :doc:`컨텐츠 협상 </incoming/content_negotiation>`\ 을 자동으로 수행하여 올바른 로케일을 결정하는 "set and forget" 방법입니다.
두 번째 방법을 사용하면 경로에서 로케일을 설정하는데 사용할 세그먼트를 지정할 수 있습니다.

컨텐츠 협상
-------------------

Config/App에서 두 개의 추가 설정을 설정하여 컨텐츠 협상이 자동으로 수행되도록 설정할 수 있습니다.
첫 번째 값은 Request 클래스에 로케일을 협상하고 싶다고 알려주므로 간단히 true로 설정하십시오.

::

    public $negotiateLocale = true;

이 기능이 활성화되면 시스템은 ``$supportLocales``\ 에 정의한 로케일 배열을 기반으로 올바른 언어를 자동으로 협상합니다.
지원하는 언어와 요청한 언어가 일치하지 않으면 ``$supportedLocales``\ 의 첫 번째 항목이 사용됩니다.
다음 예에서 일치하는 항목이 없으면 **en** 로케일이 사용됩니다.

::

    public $supportedLocales = ['en', 'es', 'fr-FR'];

경로(route)에 배치
-----------------------

두 번째 방법은 사용자 지정 자리 표시자를 사용하여 원하는 로케일을 감지하고 요청에 설정합니다.
자리 표시자 ``{locale}``\ 은 경로에 세그먼트로 배치할 수 있습니다.
존재하는 경우 일치하는 세그먼트의 내용이 로케일이 됩니다.

::

    $routes->get('{locale}/books', 'App\Books::index');

이 예에서 사용자가 ``http://example.com/fr/books``\ 를 방문할 때 유효한 로케일로 구성된 경우 로케일이 ``fr``\ 로 설정됩니다.

.. note:: 앱 구성 파일에 정의된 값이 유효한 로케일과 일치하지 않으면 기본 로케일이 대신 사용됩니다.

현재 로케일 검색
=============================

현재 로케일은 ``getLocale()`` 메소드를 통해 ``IncomingRequest`` 오브젝트에서 검색할 수 있습니다.
컨트롤러가 ``CodeIgniter\Controller``\ 를 확장하는 경우 ``$this->request``\ 를 통해 사용할 수 있습니다

::

    <?php 
    
    namespace App\Controllers;

    class UserController extends \CodeIgniter\Controller
    {
        public function index()
        {
            $locale = $this->request->getLocale();
        }
    }

또는 :doc:`서비스 클래스 </concepts/services>`\ 를 사용하여 현재 요청을 검색할 수 있습니다.

::

    $locale = service('request')->getLocale();

*********************
언어 지역화
*********************

언어 파일 만들기
=======================

언어에는 필요한 특정 명명 규칙이 없습니다.
파일의 내용 유형을 설명하기 위해 파일 이름을 논리적으로 지정해야 합니다.
For example, let's say you want to create a file containing error messages.
예를 들어, 오류 메시지가 포함된 파일을 작성하려고 한다고 가정합니다.
**Errors.php**\ 라는 이름으로 간단히 지정할 수 있습니다.

파일 내에서 배열을 반환합니다. 배열의 각 요소에는 언어 키와 반환 할 문자열이 있습니다.

::

    'language_key' => 'The actual message to be shown.'

또한 중첩된 정의(define)를 지원합니다.

::

    'language_key' => [
        'nested' => [
            'key' => 'The actual message to be shown.'
        ],
    ],

.. note:: 지정된 파일의 모든 메시지에 공통 접두사를 사용하여 다른 파일의 비슷한 이름의 항목과 충돌을 피하는 것이 좋습니다.
    예를 들어, 오류 메시지를 작성하는 경우 접두어에 ``error_``\ 를 붙일수 있습니다.

::

    return [
        'errorEmailMissing'    => 'You must submit an email address',
        'errorURLMissing'      => 'You must submit a URL',
        'errorUsernameMissing' => 'You must submit a username',
        'nested'               => [
            'error' => [
                'message'      => 'A specific error message',
            ],
        ],
    ];

기본 사용법
==============

``lang()`` 헬퍼 함수를 사용하면 파일 이름과 언어 키를 마침표(.)로 구분된 첫 번째 매개 변수로 전달하여 모든 언어 파일에서 텍스트를 검색할 수 있습니다.
예를 들어 ``Errors`` 언어 파일에서 ``errorEmailMissing`` 문자열을 로드하려면 다음과 같이합니다.

::

    echo lang('Errors.errorEmailMissing');

중첩하여 정의한 경우 다음과 같이합니다.

::

    echo lang('Errors.nested.error.message');

요청된 언어 키가 현재 로케일의 파일에 없으면 문자열이 변경되지 않고 키가 다시 전달됩니다.
이 예에서 정의된 키가 없으면 'Errors.errorEmailMissing'\ 이나 'Errors.nested.error.message'\ 을 반환합니다.

매개 변수 교체
--------------------

.. note:: 다음 함수들이 모두 작동하기 위해서는 시스템에 `intl <https://www.php.net/manual/en/book.intl.php>`_ 확장을 로드해야 합니다.
    확장이로드되지 않으면 교체가 시도되지 않습니다.
    `Sitepoint <https://www.sitepoint.com/localization-demystified-understanding-php-intl/>`_\ 에서 자세한 개요를 확인할 수 있습니다.

``lang()`` 함수의 두 번째 매개 변수로 언어 문자열의 자리 표시자를 바꾸는 값 배열을 전달할 수 있습니다.
이것은 매우 간단한 숫자 변환과 서식을 허용합니다.

::

    // The language file, Tests.php:
    return [
        "apples"      => "I have {0, number} apples.",
        "men"         => "The top {1, number} men out-performed the remaining {0, number}",
        "namedApples" => "I have {number_apples, number, integer} apples.",
    ];

    // Displays "I have 3 apples."
    echo lang('Tests.apples', [ 3 ]);

자리 표시자의 첫 번째 항목이 숫자인 경우 배열의 항목 색인에 해당합니다.

::

    // Displays "The top 23 men out-performed the remaining 20"
    echo lang('Tests.men', [20, 23]);

원하는 경우 이름이 지정된 키를 사용하여 작업을 쉽게할 수 있습니다.

::

    // Displays "I have 3 apples."
    echo lang("Tests.namedApples", ['number_apples' => 3]);

분명히, 당신은 단순히 숫자 교체 이상을 할 수 있습니다.
기본 라이브러리에 대한 `공식 ICU 문서 <https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classMessageFormat.html#details>`_\ 에 따르면 다음 유형의 데이터를 대체할 수 있습니다:

* numbers - integer, currency, percent
* dates - short, medium, long, full
* time - short, medium, long, full
* spellout - spells out numbers (예 : 34 becomes thirty-four)
* ordinal
* duration

다음은 몇 가지 예입니다

::

    // The language file, Tests.php
    return [
        'shortTime'  => 'The time is now {0, time, short}.',
        'mediumTime' => 'The time is now {0, time, medium}.',
        'longTime'   => 'The time is now {0, time, long}.',
        'fullTime'   => 'The time is now {0, time, full}.',
        'shortDate'  => 'The date is now {0, date, short}.',
        'mediumDate' => 'The date is now {0, date, medium}.',
        'longDate'   => 'The date is now {0, date, long}.',
        'fullDate'   => 'The date is now {0, date, full}.',
        'spelledOut' => '34 is {0, spellout}',
        'ordinal'    => 'The ordinal is {0, ordinal}',
        'duration'   => 'It has been {0, duration}',
    ];

    // Displays "The time is now 11:18 PM"
    echo lang('Tests.shortTime', [time()]);
    // Displays "The time is now 11:18:50 PM"
    echo lang('Tests.mediumTime', [time()]);
    // Displays "The time is now 11:19:09 PM CDT"
    echo lang('Tests.longTime', [time()]);
    // Displays "The time is now 11:19:26 PM Central Daylight Time"
    echo lang('Tests.fullTime', [time()]);

    // Displays "The date is now 8/14/16"
    echo lang('Tests.shortDate', [time()]);
    // Displays "The date is now Aug 14, 2016"
    echo lang('Tests.mediumDate', [time()]);
    // Displays "The date is now August 14, 2016"
    echo lang('Tests.longDate', [time()]);
    // Displays "The date is now Sunday, August 14, 2016"
    echo lang('Tests.fullDate', [time()]);

    // Displays "34 is thirty-four"
    echo lang('Tests.spelledOut', [34]);

    // Displays "It has been 408,676:24:35"
    echo lang('Tests.ordinal', [time()]);

조건부 교체, 복수화 등의 기능에 대한 더 나은 아이디어를 얻으려면 ``MessageFormatter`` 클래스와 기본 ICU 형식을 읽어야합니다.
이전에 제공된 두 링크 모두 사용 가능한 옵션에 대한 훌륭한 아이디어를 제공합니다.

로케일 지정
-----------------

To specify a different locale to be used when replacing parameters, you can pass the locale in as the third parameter to the ``lang()`` method.
매개 변수를 대체할 때 사용할 다른 로케일을 지정하기 위해 로케일을 ``lang()`` 메소드의 세 번째 매개 변수로 전달할 수 있습니다.

::

    // Displays "The time is now 23:21:28 GMT-5"
    echo lang('Test.longTime', [time()], 'ru-RU');

    // Displays "£7.41"
    echo lang('{price, number, currency}', ['price' => 7.41], 'en-GB');
    // Displays "$7.41"
    echo lang('{price, number, currency}', ['price' => 7.41], 'en-US');

중첩 배열
-------------

언어 파일에 중첩 배열을 사용하여 목록 등을 쉽게 사용할 수 있습니다.

::

    // Language/en/Fruit.php

    return [
        'list' => [
            'Apples',
            'Bananas',
            'Grapes',
            'Lemons',
            'Oranges',
            'Strawberries'
        ]
    ];

    // Displays "Apples, Bananas, Grapes, Lemons, Oranges, Strawberries"
    echo implode(', ', lang('Fruit.list'));

언어 대체
=================

특정 로케일에 대한 메시지 세트 (예 : ``Language/en/app.php``)가 있는 경우 해당 로케일의 언어 변형 (예 : ``Language/en-US/app.php``)을 각각 고유 폴더에 추가할 수 있습니다.

해당 로케일 변형에 대해 다르게 지역화된 메시지에만 값을 제공하면됩니다.
누락 된 메시지 정의는 기본 로케일 설정에서 자동으로 가져옵니다.

새 메시지가 프레임워크에 추가되어 아직 로케일에 맞게 번역할 기회가 없는 경우 지역화가 영어로 다시 떨어질 수 있습니다.

따라서 로케일 ``fr-CA``\ 를 사용하는 경우 지역화된 메시지는 먼저 ``Language/fr/CA``\ 에서 찾은 다음 ``Language/fr``\ 을 거쳐 ``Language/en``\ 에서 찾습니다.

메시지 번역
====================

`own repository <https://github.com/codeigniter4/translations>`_\ 에 "공식" 번역 세트가 있습니다.

해당 리포지토리를 다운로드하고 ``app``\ 의 ``Language`` 폴더에 복사합니다.
``App`` 네임스페이스가 ``app`` 폴더에 매핑되므로 통합된 번역이 자동으로 선택됩니다.

프로젝트 내에서 ``composer require codeigniter4/translations``\ 을 실행하면 번역 폴더가 적절하게 매핑되고 자동 선택되므로 composer를 통한 설치를 권장합니다.