#################
캐싱 드라이버
#################

CodeIgniter는 가장 널리 사용되는 빠르고 동적인 캐싱 형태에 대한 래퍼를 제공합니다.
파일 기반 캐싱을 제외한 다른 드라이버는 특정 요구 사항이 필요하며, 요구 사항이 충족되지 않으면 치명적인 예외가 발생합니다.

.. contents::
    :local:
    :depth: 2

*************
사용 샘플
*************

다음 예는 컨트롤러내의 일반적인 사용 패턴을 보여줍니다.

::

    if ( ! $foo = cache('foo'))
    {
        echo 'Saving to the cache!<br />';
        $foo = 'foobarbaz!';

        // Save into the cache for 5 minutes
        cache()->save('foo', $foo, 300);
    }

    echo $foo;

Services 클래스를 통해 캐시 엔진 인스턴스를 직접 가져올 수 있습니다.

::

    $cache = \Config\Services::cache();

    $foo = $cache->get('foo');

=====================
캐시 구성
=====================

캐시 엔진의 모든 구성은 **app/Config/Cache.php**\ 에서 수행됩니다.
해당 파일에서 다음 항목을 사용할 수 있습니다.

**$handler**

엔진을 시작할 때 기본 핸들러로 사용해야 하는 핸들러의 이름입니다.
사용 가능한 이름은: ``dummy``, ``file``, ``memcached``, ``redis``, ``predis``, ``wincache``.

**$backupHandler**

첫 번째 선택 $hanlder를 사용할 수 없는 경우 다음으로 로드할 캐시 핸들러입니다.
다른 핸들러는 더 복잡한 다중 서버 설정에 맞지 않을 수 있으므로, 일반적으로 항상 사용 가능한 **file** 핸들러를 지정합니다.

**$prefix**

동일한 캐시 스토리지를 사용하는 둘 이상의 어플리케이션이 있는 경우 여기에 모든 키 이름 앞에 추가되는 사용자 정의 접두부(prefix)를 추가할 수 있습니다.

**$path**

``file`` 핸들러의 캐시 파일을 저장할 위치를 지정할 때 사용.

**$memcached**

"Memcache(d)" 핸들러의 서버 설정에 사용.

**$redis**

``Redis``\ 와 ``Predis`` 핸들러로 사용하고자 하는 Redis 서버 설정.

***************
Class Reference
***************

.. php:method::  isSupported()

    :returns:    지원되는 경우 TRUE, 지원하지 않는 경우 FALSE
    :rtype:    bool

.. php:method::  get($key)
    :noindex:

    :param    string    $key: 캐시 아이템 이름
    :returns:    항목 값 또는 찾지 못한 경우 NULL
    :rtype:    mixed

    이 메소드는 캐시 저장소에서 항목을 가져 오려고 시도합니다.
    항목이 존재하지 않으면 NULL을 리턴합니다.

    Example::

        $foo = $cache->get('my_cached_item');

.. php:method::  save($key, $data[, $ttl = 60[, $raw = FALSE]])

    :param    string    $key: 캐시 아이템 이름
    :param    mixed    $data: 저장할 데이터
    :param    int    $ttl: 유효시간, 초 (기본값 60)
    :param    bool    $raw: 원시(raw) 값을 저장할지 여부
    :returns:    지원되는 경우 TRUE, 지원하지 않는 경우 FALSE
    :rtype:    string

    항목을 캐시 저장소에 저장합니다.
    저장에 실패하면 FALSE를 리턴합니다.

    Example::

        $cache->save('cache_item_id', 'data_to_cache');

.. note:: ``$raw`` 매개 변수는 Memcache의 ``increment()``\ 와 ``decrement()`` 사용시만 사용됩니다.

.. php:method::  delete($key)
    :noindex:

    :param    string    $key: 캐시된 항목의 이름
    :returns:    지원되는 경우 TRUE, 지원하지 않는 경우 FALSE
    :rtype:    bool

    캐시 저장소에서 특정 항목을 삭제합니다.항
    목 삭제에 실패하면 FALSE를 리턴합니다.

    Example::

        $cache->delete('cache_item_id');

.. php:method::  increment($key[, $offset = 1])
    :noindex:

    :param    string    $key: Cache ID
    :param    int    $offset: 추가할 단계/값
    :returns:    성공시 새로운 값, 실패시 false
       :rtype:    mixed

    저장된 값의 증분을 수행합니다.

    Example::

        // 'iterator' has a value of 2

        $cache->increment('iterator'); // 'iterator' is now 3

        $cache->increment('iterator', 3); // 'iterator' is now 6

.. php:method::  decrement($key[, $offset = 1])
    :noindex:

    :param    string    $key: Cache ID
    :param    int    $offset: 줄일 단계/값
    :returns:    성공시 새로운 값, 실패시 false
    :rtype:    mixed

    저장된 값의 감소를 수행합니다.

    Example::

        // 'iterator' has a value of 6

        $cache->decrement('iterator'); // 'iterator' is now 5

        $cache->decrement('iterator', 2); // 'iterator' is now 3

.. php:method::  clean()

    :returns:    지원되는 경우 TRUE, 지원하지 않는 경우 FALSE
    :rtype:    bool

    전체 캐시를 '삭제' 합니다. 
    캐시 파일 삭제에 실패하면 FALSE를 리턴합니다.

    Example::

            $cache->clean();

.. php:method::  ⠀getCacheInfo()

    :returns:    전체 캐시 데이터베이스에 대한 정보
    :rtype:    mixed

    전체 캐시에 대한 정보를 리턴합니다.

    Example::

        var_dump($cache->⠀getCacheInfo());

.. note:: 리턴된 정보 및 데이터 구조는 사용중인 어댑터에 따라 다릅니다.

.. php:method::  getMetadata($key)

    :param    string    $key: 캐시 아이템 이름
    :returns:    캐시된 항목의 메타 데이터
    :rtype:    mixed

    캐시의 특정 항목에 대한 자세한 정보를 리턴합니다.

    Example::

        var_dump($cache->getMetadata('my_cached_item'));

.. note:: 리턴된 정보 및 데이터 구조는 사용중인 어댑터에 따라 다릅니다.

*******
Drivers
*******

==================
파일 기반 캐싱
==================

출력 클래스의 캐싱과 달리 드라이버 파일 기반 캐싱을 사용하면 뷰 파일을 캐시할 수 있습니다.
디스크 I/O가 캐슁을 통해 얻는 긍정적인 이점을 없앨 수 있으므로 이를 주의하여 사용하고, 어플리케이션을 벤치마킹해야 합니다.
캐시 디렉토리는 실제로 쓰기 가능해야 합니다(0777).

=================
Memcached 캐싱
=================

캐시 구성 파일에 Memcached 서버를 지정할 수 있습니다. 

::

    public $memcached = [
        'host'   => '127.0.0.1',
        'port'   => 11211,
        'weight' => 1,
        'raw'    => false,
    ];

Memcached에 대한 자세한 내용은 다음을 참조하십시오.
`https://www.php.net/memcached <https://www.php.net/memcached>`_.

================
WinCache 캐싱
================

Windows에서는 WinCache 드라이버를 사용할 수 있습니다.

WinCache에 대한 자세한 내용은 다음을 참조하십시오.
`https://www.php.net/wincache <https://www.php.net/wincache>`_.

=============
Redis 캐싱
=============

Redis는 LRU 캐시 모드에서 작동할 수 있는 메모리 key-value 저장소입니다.
이를 사용하려면 `Redis 서버 및 phpredis PHP 확장 <https://github.com/phpredis/phpredis>`_\ 이 필요합니다.

캐시 구성 파일에 저장된 redis 서버 연결 구성 옵션입니다.

::

    public $redis = [
        'host'     => '127.0.0.1',
        'password' => null,
        'port'     => 6379,
        'timeout'  => 0,
        'database' => 0,
    ];

Redis에 대한 자세한 내용은 다음을 참조하십시오.
`https://redis.io <https://redis.io>`_.

==============
Predis 캐싱
==============

Predis는 Redis 키-값 저장소를 위한 유연하고 기능이 완전한 PHP 클라이언트 라이브러리입니다.
이를 사용하려면 프로젝트 루트 내의 명령줄에서 다음을 수행합니다.

::

    composer require predis/predis

Redis에 대한 자세한 내용은 `https://github.com/nrk/predis <https://github.com/nrk/predis>`_\ 을 참조하시기 바랍니다.

==============
Dummy 캐시
==============

이것은 항상 'miss'\ 되는 캐싱 백엔드입니다. 
데이터를 저장하지 않지만 캐시를 지원하지 않는 환경에서 캐싱 코드를 유지할 수 있습니다.