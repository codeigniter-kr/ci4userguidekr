###############
시간과 날짜
###############

CodeIgniter는 PHP의 DateTime 객체를 기반으로 하는 완전히 현지화된 변하지 않는 날짜/시간 클래스를 제공하지만, 
Intl 확장 기능을 사용하여 시간을 시간대별로 변환하고 다른 로케일에 대한 출력을 올바르게 표시합니다.
이 클래스는 **Time** 클래스이며 **CodeIgniter\\I18n** 네임스페이스에 있습니다.

.. note:: Time 클래스는 DateTime을 확장하므로 이 클래스에서 제공하지 않는 기능이 있으면 DateTime 클래스 자체에서 찾을수 있습니다.

.. contents::
    :local:
    :depth: 1

=============
인스턴스화
=============

새로운 Time 인스턴스를 만들 수 있는 방법에는 여러 가지가 있습니다.
첫 번째는 다른 클래스와 마찬가지로 새 인스턴스를 만드는 것입니다.
이렇게하면 원하는 시간을 나타내는 문자열을 전달할 수 있으며, 문자열은 PHP의 strtotime 함수가 구문 분석할 수 있는 모든 문자열입니다.

::

    use CodeIgniter\I18n\Time;

    $myTime = new Time('+3 week');
    $myTime = new Time('now');

시간대와 로케일을 나타내는 문자열을 각각 두 번째와 세 번째 매개 변수로 전달할 수 있습니다.
시간대는 PHP의 `DateTimeZone <https://www.php.net/manual/en/timezones.php>`__ 클래스를 지원합니다.
로케일은 PHP의 `Locale <https://www.php.net/manual/en/class.locale.php>`__ 클래스를 지원합니다.
로케일이나 시간대가 제공되지 않으면 어플리케이션의 기본값이 사용됩니다.

::

    $myTime = new Time('now', 'America/Chicago', 'en_US');

now()
-----

Time 클래스에는 클래스를 인스턴스화하는 몇 가지 도우미 메소드가 있습니다.
이 중 첫 번째는 현재 시간으로 설정된 새 인스턴스를 반환하는 **now()** 메소드입니다.
시간대와 로케일을 나타내는 문자열을 각각 두 번째 및 세번째 매개 변수로 전달할 수 있습니다.
로케일이나 시간대가 제공되지 않으면 어플리케이션의 기본값이 사용됩니다.

::

    $myTime = Time::now('America/Chicago', 'en_US');

parse()
-------

이 헬퍼 메소드는 기본 생성자의 정적 버전입니다.
첫 번째 매개 변수로 DateTime의 생성자로 허용되는 문자열, 두 번째 매개 변수로 시간대 및 세 번째 매개 변수로 로케일을 사용합니다.

::

    $myTime = Time::parse('next Tuesday', 'America/Chicago', 'en_US');

today()
-------

날짜가 현재 날짜로 설정되고 시간이 자정(00:00)으로 설정된 새 인스턴스를 반환합니다.
첫 번째와 두 번째 매개 변수에서 시간대 및 로케일 문자열을 허용합니다.

::

    $myTime = Time::today('America/Chicago', 'en_US');

yesterday()
-----------

날짜가 어제 날짜로 설정되고 시간이 자정으로 설정된 새 인스턴스를 반환합니다.
첫 번째와 두 번째 매개 변수에서 시간대 및 로케일 문자열을 허용합니다.

::

    $myTime = Time::yesterday('America/Chicago', 'en_US');

tomorrow()
-----------

날짜가 내일 날짜로 설정되고 시간이 자정으로 설정된 새 인스턴스를 반환합니다.
첫 번째와 두 번째 매개 변수에서 시간대 및 로케일 문자열을 허용합니다.

::

    $myTime = Time::tomorrow('America/Chicago', 'en_US');

createFromDate()
----------------

**year**, **month**, **day**\ 에 대해 별도의 입력이 주어지면 새 인스턴스가 반환됩니다.
이러한 매개 변수 중 하나가 제공되지 않으면 현재 값을 사용하여 입력합니다.
네 번째와 다섯 번째 매개 변수에서 시간대 및 로케일 문자열을 허용합니다.

::

    $today       = Time::createFromDate();            // Uses current year, month, and day
    $anniversary = Time::createFromDate(2018);  // Uses current month and day
    $date        = Time::createFromDate(2018, 3, 15, 'America/Chicago', 'en_US');

createFromTime()
----------------

**createFromDate**\ 와 같으며, **hours**, **minutes**, **seconds**\ 에만 관련됩니다.
Time 인스턴스의 날짜 부분에 현재 날짜를 사용합니다.
네 번째와 다섯 번째 매개 변수에서 시간대 및 로케일 문자열을 허용합니다.

::

    $lunch  = Time::createFromTime(11, 30)       // 11:30 am today
    $dinner = Time::createFromTime(18, 00, 00)  // 6:00 pm today
    $time   = Time::createFromTime($hour, $minutes, $seconds, $timezone, $locale);

create()
--------

이전 두 방법의 조합으로 **year**, **month**, **day**, **hour**, **minutes**, **seconds**\ 를 별도의 매개 변수로 사용합니다.
제공되지 않은 값은 현재 날짜와 시간을 사용하여 결정합니다.
네 번째와 다섯 번째 매개 변수에서 시간대 및 로케일 문자열을 허용합니다.

::

    $time = Time::create($year, $month, $day, $hour, $minutes, $seconds, $timezone, $locale);

createFromFormat()
------------------

이것은 같은 이름의 DateTime 메소드를 대체합니다. 
이렇게하면 시간대를 동시에 설정할 수 있으며 DateTime 대신 **Time** 인스턴스를 반환합니다.

::

    $time = Time::createFromFormat('j-M-Y', '15-Feb-2009', 'America/Chicago');

createFromTimestamp()
---------------------

이 메소드는 새로운 Time 인스턴스를 생성하기 위해 UNIX 타임스탬프를 사용하며, 옵션으로 시간대, 로케일을 사용합니다.

::

    $time = Time::createFromTimestamp(1501821586, 'America/Chicago', 'en_US');

instance()
----------

DateTime 인스턴스를 제공하는 다른 라이브러리로 작업할 때 이 메소드를 사용하여 선택적으로 로케일을 설정하여 Time 인스턴스로 변환 할 수 있습니다. 
시간대는 전달된 DateTime 인스턴스를 통하여 자동으로 결정됩니다.

::

    $dt   = new DateTime('now');
    $time = Time::instance($dt, 'en_US');

toDateTime()
------------

인스턴스 생성기는 아니지만 이 메소드는 **instance** 메소드와 반대이므로 Time 인스턴스를 DateTime 인스턴스로 변환할 수 있습니다.
DateTime에서 로케일을 인식하지 못하므로 시간대 설정은 유지되지만 로케일은 손실됩니다.

::

    $datetime = Time::toDateTime();

====================
값 표시
====================

Time 클래스는 DateTime을 확장하므로 format() 메소드를 포함한 DateTime 클래스가 제공하는 모든 출력 메소드를 사용할 수 있습니다.
그러나 DateTime 메소드는 지역화된 결과를 제공하지 않습니다. 
Time 클래스는 현지화된 버전의 값을 표시하기 위한 여러 가지 헬퍼 메소드를 제공합니다.

toLocalizedString()
-------------------

현지화된 DateTime() 형식 메소드 버전입니다. 
하지만 익숙한 값을 사용하는 대신 `IntlDateFormatter <https://www.php.net/manual/en/class.intldateformatter.php>`__ 클래스에 허용되는 값을 사용해야 합니다.
전체 값은 `목록 <https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details>`__\ 에서 찾을 수 있습니다.

::

    $time = Time::parse('March 9, 2016 12:00:00', 'America/Chicago');
    echo $time->toLocalizedString('MMM d, yyyy');   // March 9, 2016

toDateTimeString()
------------------

이 메소드는 값을 기억하지 않고 ``IntlDateFormatter``\ 와 함께 작동하는 세 가지 도우미 메소드 중 첫 번째입니다.
데이터베이스에서 datetime 열에 일반적으로 사용되는 형식의 문자열(Y-m-d H:i:s)을 반환합니다. 

::

    $time = Time::parse('March 9, 2016 12:00:00', 'America/Chicago');
    echo $time->toDateTimeString();     // 2016-03-09 12:00:00

toDateString()
--------------

시간의 날짜 부분만 표시합니다.

::

    $time = Time::parse('March 9, 2016 12:00:00', 'America/Chicago');
    echo $time->toDateTimeString();     // 2016-03-09

toTimeString()
--------------

값의 시간 부분만 표시합니다.

::

    $time = Time::parse('March 9, 2016 12:00:00', 'America/Chicago');
    echo $time->toTimeString();     // 12:00:00

humanize()
----------

이 메소드는 현재 날짜/시간과 인스턴스간의 차이를 사람이 읽을 수있는 형식으로 쉽게 이해할 수 있도록 표시하는 문자열을 반환합니다. 
'3 hours ago', 'in 1 month'\ 등과 같은 문자열을 만들 수 있습니다.

::

    // Assume current time is: March 10, 2017 (America/Chicago)
    $time = Time::parse('March 9, 2016 12:00:00', 'America/Chicago');

    echo $time->humanize();     // 1 year ago

표시되는 정확한 시간은 다음과 같은 방식으로 결정됩니다.

=============================== =================================
Time difference                  Result
=============================== =================================
$time > 1 year && < 2 years      in 1 year / 1 year ago
$time > 1 month && < 1 year      in 6 months / 6 months ago
$time > 7 days && < 1 month      in 3 weeks / 3 weeks ago
$time > today && < 7 days        in 4 days / 4 days ago
$time == tomorrow / yesterday    Tomorrow / Yesterday
$time > 59 minutes && < 1 day    in 2 hours / 2 hours ago
$time > now && < 1 hour          in 35 minutes / 35 minutes ago
$time == now                     Now
=============================== =================================

사용되는 언어는 언어 파일 ``Time.php``\ 를 통해 제어됩니다.

==============================
개별 값으로 작업
==============================

Time 객체는 기존 인스턴스의 연도, 월, 시간등과 같은 개별 항목을 가져오고 설정할 수있는 여러 가지 방법을 제공합니다.
다음 방법을 통해 검색된 모든 값은 완전히 지역화되며 Time 인스턴스가 만들어진 로캐일을 따릅니다.

다음의 `getX`\ 와 `setX` 메소드는 모두 클래스 속성인 것처럼 사용할 수 있습니다.
따라서 `getYear`\ 와 같은 메소드에 대한 모든 호출은 `$time->year`\ 등을 통해 액세스할 수 있습니다.

Getters
-------

다음과 같은 기본 게터(getter)를 제공합니다.

::

    $time = Time::parse('August 12, 2016 4:15:23pm');

    echo $time->getYear();      // 2016
    echo $time->getMonth();     // 8
    echo $time->getDay();       // 12
    echo $time->getHour();      // 16
    echo $time->getMinute();    // 15
    echo $time->getSecond();    // 23

    echo $time->year;           // 2016
    echo $time->month;          // 8
    echo $time->day;            // 12
    echo $time->hour;           // 16
    echo $time->minute;         // 15
    echo $time->second;         // 23

이 외에도 날짜에 대한 추가 정보를 제공하는 여러 가지 방법이 있습니다.

::

    $time = Time::parse('August 12, 2016 4:15:23pm');

    echo $time->getDayOfWeek();     // 6 - but may vary based on locale's starting day of the week
    echo $time->getDayOfYear();     // 225
    echo $time->getWeekOfMonth();   // 2
    echo $time->getWeekOfYear();    // 33
    echo $time->getTimestamp();     // 1471018523 - UNIX timestamp
    echo $time->getQuarter();       // 3

    echo $time->dayOfWeek;          // 6
    echo $time->dayOfYear;          // 225
    echo $time->weekOfMonth;        // 2
    echo $time->weekOfYear;         // 33
    echo $time->timestamp;          // 1471018523
    echo $time->quarter;            // 3

getAge()
--------

Time 인스턴스와 현재 시간 사이의 나이를 년 단위로 반환합니다. 
생일을 기준으로 누군가의 나이를 확인하는데 적합합니다.

::

    $time = Time::parse('5 years ago');

    echo $time->getAge();   // 5
    echo $time->age;        // 5

getDST()
--------

Time 인스턴스가 현재 일광 절약 시간(Daylight Savings Time)을 준수하는지 여부에 따라 부울 true / false를 반환합니다.

::

    echo Time::createFromDate(2012, 1, 1)->getDst();     // false
    echo Time::createFromDate(2012, 9, 1)->dst;     // true

getLocal()
----------

Time 인스턴스가 현재 어플리케이션이 실행되는 시간대와 동일한 시간대에 있으면 부울 true를 반환합니다.

::

    echo Time::now()->getLocal();       // true
    echo Time::now('Europe/London');    // false

getUtc()
--------

Time 인스턴스가 UTC 시간인 경우 부울 true를 리턴합니다.

::

    echo Time::now('America/Chicago')->getUtc();    // false
    echo Time::now('UTC')->utc;                     // true

getTimezone()
-------------

Time 인스턴스의 시간대를 설정하는 새로운 `DateTimeZone <https://www.php.net/manual/en/class.datetimezone.php>`__ 객체를 반환합니다.

::

    $tz = Time::now()->getTimezone();
    $tz = Time::now()->timezone;

    echo $tz->getName();
    echo $tz->getOffset();

getTimezoneName()
-----------------

Time 인스턴스의 전체 `시간대 문자열 <https://www.php.net/manual/en/timezones.php>`__\ 을 반환합니다.

::

    echo Time::now('America/Chicago')->getTimezoneName();   // America/Chicago
    echo Time::now('Europe/London')->timezoneName;          // Europe/London

Setters
=======

다음과 같은 기본 세터(setter)가 존재합니다. 
설정된 값 중 하나가 범위를 벗어나면 ``InvalidArgumentExeption``\ 이 발생합니다.

.. note:: 모든 세터는 새 인스턴스를 반환하고 원본 인스턴스는 그대로 유지합니다.

.. note:: 값이 범위를 벗어나면 모든 세터가 ``InvalidArgumentException``\ 을 발생시킵니다.

::

    $time = $time->setYear(2017);
    $time = $time->setMonthNumber(4);           // April
    $time = $time->setMonthLongName('April');
    $time = $time->setMonthShortName('Feb');    // February
    $time = $time->setDay(25);
    $time = $time->setHour(14);                 // 2:00 pm
    $time = $time->setMinute(30);
    $time = $time->setSecond(54);

setTimezone()
-------------

현재 시간대의 시간을 새로운 시간대로 변환합니다.

::

    $time  = Time::parse('13 May 2020 10:00', 'America/Chicago');
    $time2 = $time->setTimezone('Europe/London');           // Returns new instance converted to new timezone

    echo $time->getTimezoneName();   // American/Chicago
    echo $time2->getTimezoneName();  // Europe/London

    echo $time->toDateTimeString();   // 2020-05-13 10:00:00
    echo $time2->toDateTimeString();   // 2020-05-13 18:00:00

setTimestamp()
--------------

날짜가 새 타임 스탬프로 설정된 새 인스턴스를 반환합니다.

::

    $time = Time::parse('May 10, 2017', 'America/Chicago');
    $time2 = $time->setTimestamp(strtotime('April 1, 2017'));

    echo $time->toDateTimeString();     // 2017-05-10 00:00:00
    echo $time2->toDateTimeString();     // 2017-04-01 00:00:00

값 수정
===================

다음 방법을 사용하면 현재 시간에 값을 더하거나 빼서 날짜를 수정할 수 있습니다.
기존 Time 인스턴스는 수정하지 않지만 새 인스턴스를 반환합니다.

::

    $time = $time->addSeconds(23);
    $time = $time->addMinutes(15);
    $time = $time->addHours(12);
    $time = $time->addDays(21);
    $time = $time->addMonths(14);
    $time = $time->addYears(5);

    $time = $time->subSeconds(23);
    $time = $time->subMinutes(15);
    $time = $time->subHours(12);
    $time = $time->subDays(21);
    $time = $time->subMonths(14);
    $time = $time->subYears(5);

두개의 시간 비교
===================

다음 메소드를 사용하면 한 Time 인스턴스를 다른 Time 인스턴스와 비교할 수 있습니다.
다른 시간대가 올바르게 응답할 수 있도록 비교전 모든 비교 데이타는 먼저 UTC로 변환됩니다.

equals()
--------

전달된 날짜/시간이 현재 인스턴스와 같은지 확인합니다.
이 경우 동일하다는 것은 동일한 시간을 나타내며, 두 시간대 모두 UTC로 변환되어 비교되므로 동일한 시간대에 있지 않아도 됩니다.

::

    $time1 = Time::parse('January 10, 2017 21:50:00', 'America/Chicago');
    $time2 = Time::parse('January 11, 2017 03:50:00', 'Europe/London');

    $time1->equals($time2);    // true

테스트중인 값은 Time 인스턴스, DateTime 인스턴스, 새 DateTime 인스턴스가 이해할 수있는 방식으로 전체 날짜 시간이 포함 된 문자열 일 수 있습니다.
문자열을 첫 번째 매개 변수로 전달할 때 시간대 문자열을 두 번째 매개 변수로 전달할 수 있습니다.
시간대를 지정하지 않으면 시스템 기본값이 사용됩니다.

::

    $time1->equals('January 11, 2017 03:50:00', 'Europe/London');  // true

sameAs()
--------

날짜, 시간 및 시간대가 모두 동일한 경우에만 true를 리턴한다는 점을 제외하면 **equals** 메소드와 동일합니다.

::

    $time1 = Time::parse('January 10, 2017 21:50:00', 'America/Chicago');
    $time2 = Time::parse('January 11, 2017 03:50:00', 'Europe/London');

    $time1->sameAs($time2);    // false
    $time2->sameAs('January 10, 2017 21:50:00', 'America/Chicago');    // true

isBefore()
----------

전달된 시간이 현재 인스턴스 이전인지 확인합니다. 두 시간은 UTC로 변환후 비교가 이루어집니다.

::

    $time1 = Time::parse('January 10, 2017 21:50:00', 'America/Chicago');
    $time2 = Time::parse('January 11, 2017 03:50:00', 'America/Chicago');

    $time1->isBefore($time2);  // true
    $time2->isBefore($time1);  // false

테스트중인 값은 Time 인스턴스, DateTime 인스턴스, 새 DateTime 인스턴스가 이해할 수있는 방식으로 전체 날짜 시간이 포함 된 문자열 일 수 있습니다.
문자열을 첫 번째 매개 변수로 전달할 때 시간대 문자열을 두 번째 매개 변수로 전달할 수 있습니다.
시간대를 지정하지 않으면 시스템 기본값이 사용됩니다

::

    $time1->isBefore('March 15, 2013', 'America/Chicago');  // false

isAfter()
---------

**isBefore()**\ 와 동일하게 작동합니다. 시간이 지났는지 확인합니다.

::

    $time1 = Time::parse('January 10, 2017 21:50:00', 'America/Chicago');
    $time2 = Time::parse('January 11, 2017 03:50:00', 'America/Chicago');

    $time1->isAfter($time2);  // false
    $time2->isAfter($time1);  // true

차이점 보기
===================

두개의 시간을 직접 비교할 때 **difference()** 메소드를 사용하면 **CodeIgniter\\I18n\\TimeDifference** 인스턴스를 반환합니다.
첫 번째 매개 변수는 Time 인스턴스, DateTime 인스턴스 또는 날짜/시간이 포함된 문자열입니다.
문자열이 첫 번째 매개 변수에 전달되면 두 번째 매개 변수는 시간대 문자열일 수 있습니다.

::

    $time = Time::parse('March 10, 2017', 'America/Chicago');

    $diff = $time->difference(Time::now());
    $diff = $time->difference(new DateTime('July 4, 1975', 'America/Chicago');
    $diff = $time->difference('July 4, 1975 13:32:05', 'America/Chicago');

``TimeDifference`` 인스턴스가 있으면 두 시간의 차이에 대한 정보를 찾는데 사용할 수 있는 몇 가지 메소드가 있습니다.
과거인 경우 반환된 값은 음수이고 원래 시간보다 미래인 경우 양수입니다.

::

    $current = Time::parse('March 10, 2017', 'America/Chicago');
    $test    = Time::parse('March 10, 2010', 'America/Chicago');

    $diff = $current->difference($test);

    echo $diff->getYears();     // -7
    echo $diff->getMonths();    // -84
    echo $diff->getWeeks();     // -365
    echo $diff->getDays();      // -2557
    echo $diff->getHours();     // -61368
    echo $diff->getMinutes();   // -3682080
    echo $diff->getSeconds();   // -220924800

**getX()** 메소드를 사용하거나, 속성처럼 계산 값에 액세스할 수 있습니다.

::

    echo $diff->years;     // -7
    echo $diff->months;    // -84
    echo $diff->weeks;     // -365
    echo $diff->days;      // -2557
    echo $diff->hours;     // -61368
    echo $diff->minutes;   // -3682080
    echo $diff->seconds;   // -220924800

humanize()
----------

Time의 humanize() 메소드와 마찬가지로, 쉽게 이해할 수 있도록 사람이 읽을 수 있는 형식으로 두개의 시간 차이를 표시하는 문자열을 반환합니다.
'3 hours ago', 'in 1 month'\ 등과 같은 문자열을 만들 수 있습니다.
가장 큰 차이점은 최근 날짜를 처리하는 방법에 있습니다

::

    $current = Time::parse('March 10, 2017', 'America/Chicago')
    $test    = Time::parse('March 9, 2016 12:00:00', 'America/Chicago');

    $diff = $current->difference($test)

    echo $diff->humanize();     // 1 year ago

표시되는 정확한 시간은 다음과 같은 방식으로 결정됩니다.

=============================== =================================
Time difference                  Result
=============================== =================================
$time > 1 year && < 2 years      in 1 year / 1 year ago
$time > 1 month && < 1 year      in 6 months / 6 months ago
$time > 7 days && < 1 month      in 3 weeks / 3 weeks ago
$time > today && < 7 days        in 4 days / 4 days ago
$time > 1 hour && < 1 day        in 8 hours / 8 hours ago
$time > 1 minute && < 1 hour     in 35 minutes / 35 minutes ago
$time < 1 minute                 Now
=============================== =================================

사용되는 언어는 언어 파일 ``Time.php``\ 를 통해 제어됩니다.