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

.. literalinclude:: caching/001.php

Services 클래스를 통해 캐시 엔진 인스턴스를 직접 가져올 수 있습니다.

.. literalinclude:: caching/002.php

캐시 구성
=========

캐시 엔진의 모든 구성은 **app/Config/Cache.php**\ 에서 수행됩니다.
해당 파일에서 다음 항목을 사용할 수 있습니다.

$handler
--------

엔진을 시작할 때 기본 핸들러로 사용해야 하는 핸들러의 이름입니다.
사용 가능한 이름은: ``dummy``, ``file``, ``memcached``, ``redis``, ``predis``, ``wincache``.

$backupHandler
--------------

첫 번째 선택 $handler를 사용할 수 없는 경우 다음으로 로드할 캐시 핸들러입니다.
다른 핸들러는 더 복잡한 다중 서버 설정에 맞지 않을 수 있으므로, 일반적으로 항상 사용 가능한 **file** 핸들러를 지정합니다.

$prefix
-------

동일한 캐시 스토리지를 사용하는 둘 이상의 어플리케이션이 있는 경우 여기에 모든 키 이름 앞에 추가되는 사용자 정의 접두부(prefix) 문자열을 추가할 수 있습니다.

$ttl
----

항목이 지정되지 않은 경우 항목을 저장하는 기본 시간(초)입니다.
WARNING: 60초가 하드 코딩된 프레임워크 핸들러에서는 사용되지 않지만, 프로젝트와 모듈에 유용할 수 있으며, 이렇게 하면 이후 릴리스에서 하드코딩된 값이 대체됩니다.

$file
-----

캐시 파일을 저장 방법을 결정하기 위한 ``file`` 핸들러 전용 설정 배열

$memcached
----------

"Memcache(d)" 핸들러의 서버 설정에 사용.

$redis
------

``Redis``\ 와 ``Predis`` 핸들러로 사용하고자 하는 Redis 서버 설정.

******************
Command-Line Tools
******************

CodeIgniter는 Cache 작업을 돕기 위해 명령줄에서 사용할 수 있는 몇 가지 :doc:`명령 </cli/spark_commands>`\ 을 제공됩니다.
이러한 도구는 캐시 드라이버를 사용하는 데 필요하지 않지만 도움이 될 수 있습니다.

cache:clear
===========

시스템 캐시를 지웁니다.

::

    > php spark cache:clear

cache:info
==========

시스템의 파일 캐시 정보 표시

::

    > php spark cache:info

.. note:: 이 명령은 파일 캐시 처리기(handler)만 지원합니다.

***************
Class Reference
***************

.. php:namespace:: CodeIgniter\Cache

.. php:class:: CacheInterface

    .. php:method:: isSupported()

        :returns: 지원되는 경우 ``true``, 지원하지 않는 경우 ``false``
        :rtype: bool

    .. php:method::  get($key): mixed
        :noindex:

        :param string $key: 캐시 아이템 이름
        :returns: 항목 값 또는 찾지 못한 경우 ``null``
        :rtype: mixed

        이 메소드는 캐시 저장소에서 항목을 가져 오려고 시도합니다.
        항목이 존재하지 않으면 null을 리턴합니다.

        Example
        
        .. literalinclude:: caching/003.php

    .. php:method:: remember(string $key, int $ttl, Closure $callback)

        :param string $key: 캐시 아이템 이름
        :param int $ttl: 유효시간, 초
        :param Closure $callback: 캐시 항목이 null을 반환할 때 호출할 콜백
        :returns: 캐시 항목의 값
        :rtype: mixed
        
        캐시에서 항목을 가져옵니다.
        ``null``\ 이 반환된 경우 콜백을 호출하고 결과를 저장합니다.
        어느 쪽이든 값을 반환합니다.

    .. php:method:: save(string $key, $data[, int $ttl = 60[, $raw = false]])

        :param string $key: 캐시 아이템 이름
        :param mixed $data: 저장할 데이터
        :param int $ttl: 유효시간, 초 (기본값 60)
        :param bool $raw: 원시(raw) 값을 저장할지 여부
        :returns: 성공하면 ``true``, 실패하면 ``false``
        :rtype: bool

        항목을 캐시 저장소에 저장합니다.
        저장에 실패하면 false를 리턴합니다.

        Example

        .. literalinclude:: caching/004.php

        .. note:: ``$raw`` 매개 변수는 Memcache의 ``increment()``\ 와 ``decrement()`` 사용시만 사용됩니다.

    .. php:method:: delete($key): bool
        :noindex:

        :param string $key: 캐시된 항목의 이름
        :returns: 성공하면 ``true``, 실패하면 ``false``
        :rtype: bool

        캐시 저장소에서 특정 항목을 삭제합니다.
        항목 삭제에 실패하면 false를 리턴합니다.

        Example
        
        .. literalinclude:: caching/005.php

    .. php:method:: deleteMatching($pattern): integer

        :param string $pattern: 캐시된 항목 키와 일치하는 glob-style 패턴
        :returns: 삭제된 항목 수
        :rtype: integer

        이 메서드는 glob-style 패턴과 키를 일치시켜 캐시 저장소에서 여러 항목을 한 번에 삭제합니다. 
        삭제된 총 항목 수가 반환됩니다.

        .. important:: 이 메소드는 file, Redis, Predis 핸들러에만 구현됩니다.
                제한으로 인해 Memcached와 Wincache 핸들러에 구현할 수 없습니다.

        Example

        .. literalinclude:: caching/006.php

        glob 스타일 구문에 대한 자세한 내용은  `Glob (programming) <https://en.wikipedia.org/wiki/Glob_(programming)#Syntax>`_\ 을 참조하십시오.

    .. php:method:: increment($key[, $offset = 1]): mixed
        :noindex:

        :param string $key: Cache ID
        :param int $offset: 추가할 단계/값
        :returns: 성공시 새로운 값, 실패시 ``false``
        :rtype: mixed

        저장된 값의 증분을 수행합니다.

        Example
        
        .. literalinclude:: caching/007.php

    .. php:method:: decrement($key[, $offset = 1]): mixed
        :noindex:

        :param string $key: Cache ID
        :param int $offset: 줄일 단계/값
        :returns: 성공시 새로운 값, 실패시 ``false``
        :rtype: mixed

        저장된 값의 감소를 수행합니다.

        Example
        
        .. literalinclude:: caching/008.php

    .. php:method:: clean()

        :returns: 성공하면 ``true``, 실패하면 ``false``
        :rtype: bool

        전체 캐시를 '삭제' 합니다. 
        캐시 파일 삭제에 실패하면 false를 리턴합니다.

        Example
        
        .. literalinclude:: caching/009.php

    .. php:method:: getCacheInfo()

        :returns: 전체 캐시 데이터베이스에 대한 정보
        :rtype: mixed

        전체 캐시에 대한 정보를 리턴합니다.

        Example
        
        .. literalinclude:: caching/010.php

        .. note:: 리턴된 정보 및 데이터 구조는 사용중인 어댑터에 따라 다릅니다.

    .. php:method:: getMetadata($key)

        :param string $key: 캐시 아이템 이름
        :returns: 캐시된 항목의 메타 데이터, 누락된 항목인 경우 ``null``, 기간 만료된 항목인 경우 ``expire`` 키가 있는 배열 (``null``\ 인 경우 기간 만료가 아님).
        :rtype: array|null

        캐시의 특정 항목에 대한 자세한 정보를 리턴합니다.

        Example
        
        .. literalinclude:: caching/011.php

        .. note:: 리턴된 정보 및 데이터 구조는 사용중인 어댑터에 따라 다릅며, 일부 어댑터(File, Memcached, Wincache)는 누락된 항목에 대해 여전히 ``false``\ 를 반환합니다.

    .. php:staticmethod:: validateKey(string $key, string $prefix)

        :param string $key: 잠재적 캐시 키
        :param string $prefix: 선택적 접두사
        :returns: 확인되고 접두사가 붙은 키입니다. 키가 캐시 드라이버의 최대 키 길이를 초과할 경우 해시(hash)가 됩니다.
        :rtype: string

        이 메소드는 핸들러 메소드에 유효한 키인지 확인하는 데 사용됩니다. 
        문자열이 아닌 문자, 잘못된 문자 및 빈 문자열에 대해 ``InvalidArgumentException`` 예외가 발생합니다.

        Example
        
        .. literalinclude:: caching/012.php

*******
Drivers
*******

파일 기반 캐싱
==============

출력 클래스의 캐싱과 달리 드라이버 파일 기반 캐싱을 사용하면 뷰 파일을 캐시할 수 있습니다.
디스크 I/O가 캐슁을 통해 얻는 긍정적인 이점을 없앨 수 있으므로 이를 주의하여 사용하고, 어플리케이션을 벤치마킹해야 합니다.
어플리케이션이 캐시 디렉토리에 실제로 쓰기 가능해야 합니다.

Memcached 캐싱
==============

캐시 구성 파일에 Memcached 서버를 지정할 수 있습니다. 

.. literalinclude:: caching/013.php

Memcached에 대한 자세한 내용은 다음을 참조하십시오.
`https://www.php.net/memcached <https://www.php.net/memcached>`_.

WinCache 캐싱
=============

Windows에서는 WinCache 드라이버를 사용할 수 있습니다.

WinCache에 대한 자세한 내용은 다음을 참조하십시오.
`https://www.php.net/wincache <https://www.php.net/wincache>`_.

Redis 캐싱
==========

Redis는 LRU 캐시 모드에서 작동할 수 있는 메모리 key-value 저장소입니다.
이를 사용하려면 `Redis 서버 및 phpredis PHP 확장 <https://github.com/phpredis/phpredis>`_\ 이 필요합니다.

캐시 구성 파일에 저장된 redis 서버 연결 구성 옵션입니다.

.. literalinclude:: caching/014.php

Redis에 대한 자세한 내용은 다음을 참조하십시오.
`https://redis.io <https://redis.io>`_.

Predis 캐싱
===========

Predis는 Redis 키-값 저장소를 위한 유연하고 기능이 완전한 PHP 클라이언트 라이브러리입니다.
이를 사용하려면 프로젝트 루트 내의 명령줄에서 다음을 수행합니다.

::

    > composer require predis/predis

Redis에 대한 자세한 내용은 `https://github.com/nrk/predis <https://github.com/nrk/predis>`_\ 을 참조하시기 바랍니다.

Dummy 캐시
==========

이것은 항상 'miss'\ 되는 캐싱 백엔드입니다. 
데이터를 저장하지 않지만 캐시를 지원하지 않는 환경에서 캐싱 코드를 유지할 수 있습니다.