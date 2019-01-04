##############
캐싱 드라이버
##############

CodeIgniter features wrappers around some of the most popular forms of
fast and dynamic caching. All but file-based caching require specific
server requirements, and a Fatal Exception will be thrown if server
requirements are not met.
CodeIgniter는 가장 널리 사용되는 빠르고 동적인 캐싱에 대한 래퍼를 제공합니다. 파일 기반 캐싱을 제외하고는 모두 특정 서버 요구 사항이 필요하며 서버 요구 사항이 충족되지 않으면 치명적인 예외가 발생합니다.

.. contents::
    :local:
    :depth: 2

*************
사용 예
*************

The following example shows a common usage pattern within your controllers.
다음 예제는 컨트롤러 내의 일반적인 사용 패턴을 보여줍니다.

::

	if ( ! $foo = cache('foo'))
	{
		echo 'Saving to the cache!<br />';
		$foo = 'foobarbaz!';

		// Save into the cache for 5 minutes
		cache()->save('foo', $foo, 300);
	}

	echo $foo;

You can grab an instance of the cache engine directly through the Services class
Services 클래스를 통해 캐시 엔진의 인스턴스를 직접 가져올 수 있습니다.

::

    $cache = \Config\Services::cache();

    $foo = $cache->get('foo');

=====================
캐시 구성
=====================

All configuration for the cache engine is done in **app/Config/Cache.php**. In that file,
the following items are available.
캐시 엔진의 모든 구성은 **app/Config/Cache.php** 에서 수행됩니다. 이 파일에는 다음 항목이 있습니다.

**$handler**

The is the name of the handler that should be used as the primary handler when starting up the engine.
Available names are: dummy, file, memcached, redis, wincache.
엔진을 시작할 때 기본 처리기로 사용해야하는 핸들러의 이름입니다. 사용 가능한 엔진: dummy, file, memcached, redis, wincache

**$backupHandler**

In the case that the first choice $hanlder is not available, this is the next cache handler to load.
This is commonly the **file** handler since the file system is always available, but may not fit
more complex, multi-server setups.
첫 번째 선택 $hanlder 를 사용할 수 없는 경우 로드할 다음 캐시 드라이버입니다. 파일 시스템은 항상 사용할 수 있기 때문에 **file** 핸들러가 지정되어 있지만 다중 서버 설정에는 적합하지 않을 수 있습니다.

**$prefix**

If you have more than one application using the same cache storage, you can add a custom prefix
here that is prepended to all key names.
동일한 캐시 저장소를 사용하는 둘 이상의 응용 프로그램이있는 경우 여기에 모든 키 이름 앞에 추가 된 사용자 정의 접두사를 추가할 수 있습니다.

**$path**

This is used by the ``file`` handler to show where it should save the cache files to.
``file`` 핸들러가 캐시 파일을 저장할 위치를 지정할 때 사용됩니다 .

**$memcached**

This is an array of servers that will be used when using the ``Memcache(d)`` handler.
``Memcache(d)`` 핸들러를 사용할 때 사용할 서버 설정입니다 .

**$redis**

The settings for the Redis server that you wish to use when using the ``Redis`` handler.
``Redis`` 핸들러를 사용할 때 사용할 Redis 서버의 설정 .

===============
클래스 참조
===============

.. php:method:: isSupported()

	:returns:	TRUE if supported, FALSE if not
	:rtype:	bool

.. php:method:: get($key)

	:param	string	$key: Cache item name
	:returns:	Item value or FALSE if not found
	:rtype:	mixed

	This method will attempt to fetch an item from the cache store. If the
	item does not exist, the method will return FALSE.
	이 메서드는 캐시 저장소에서 항목을 가져 오려고 시도합니다. 항목이 없으면 메서드는 FALSE를 반환합니다.

	Example::

		$foo = $cache->get('my_cached_item');

.. php:method:: save($key, $data[, $ttl = 60[, $raw = FALSE]])

	:param	string	$key: Cache item name
	:param	mixed	$data: the data to save
	:param	int	$ttl: Time To Live, in seconds (default 60)
	:param	bool	$raw: Whether to store the raw value
	:returns:	TRUE on success, FALSE on failure
	:rtype:	string

	This method will save an item to the cache store. If saving fails, the
	method will return FALSE.
	이 메서드는 항목을 캐시 저장소에 저장합니다. 저장에 실패하면 FALSE를 반환합니다.

	Example::

		$cache->save('cache_item_id', 'data_to_cache');

.. note:: The ``$raw`` parameter is only utilized by Memcache,
		  in order to allow usage of ``increment()`` and ``decrement()``.
		  ``$raw`` 매개 변수는 사용을 허용하기 위해, Memcache를하여 활용 ``increment()`` 하고 ``decrement()``.

.. php:method:: delete($key)

	:param	string	$key: name of cached item
	:returns:	TRUE on success, FALSE on failure
	:rtype:	bool

	This method will delete a specific item from the cache store. If item
	deletion fails, the method will return FALSE.
	이 메서드는 캐시 저장소에서 특정 항목을 삭제합니다. 항목 삭제가 실패하면 메서드는 FALSE를 반환합니다.

	Example::

		$cache->delete('cache_item_id');

.. php:method:: increment($key[, $offset = 1])

	:param	string	$key: Cache ID
	:param	int	$offset: Step/value to add
	:returns:	New value on success, FALSE on failure
   	:rtype:	mixed

	Performs atomic incrementation of a raw stored value.
	원시 저장된 값의 원자 증분을 수행합니다.

	Example::

		// 'iterator' has a value of 2

		$cache->increment('iterator'); // 'iterator' is now 3

		$cache->increment('iterator', 3); // 'iterator' is now 6

.. php:method:: decrement($key[, $offset = 1])

	:param	string	$key: Cache ID
	:param	int	$offset: Step/value to reduce by
	:returns:	New value on success, FALSE on failure
	:rtype:	mixed

	Performs atomic decrementation of a raw stored value.
	원시 저장된 값의 원자 감소를 수행합니다.

	Example::

		// 'iterator' has a value of 6

		$cache->decrement('iterator'); // 'iterator' is now 5

		$cache->decrement('iterator', 2); // 'iterator' is now 3

.. php:method:: clean()

	:returns:	TRUE on success, FALSE on failure
	:rtype:	bool

	This method will 'clean' the entire cache. If the deletion of the
	cache files fails, the method will return FALSE.
	이 메서드는 전체 캐시를 '정리'합니다. 캐시 파일 삭제가 실패하면이 메소드는 FALSE를 리턴합니다.

	Example::

			$cache->clean();

.. php:method:: cache_info()

	:returns:	Information on the entire cache database
	:rtype:	mixed

	This method will return information on the entire cache.
	이 메서드는 전체 캐시에 대한 정보를 반환합니다.

	Example::

		var_dump($cache->cache_info());

.. note:: The information returned and the structure of the data is dependent
		  on which adapter is being used.

.. php:method:: getMetadata($key)

	:param	string	$key: Cache item name
	:returns:	Metadata for the cached item
	:rtype:	mixed

	This method will return detailed information on a specific item in the
	cache.
	이 메서드는 캐시의 특정 항목에 대한 자세한 정보를 반환합니다.

	Example::

		var_dump($cache->getMetadata('my_cached_item'));

.. note:: The information returned and the structure of the data is dependent
          on which adapter is being used.

*******
Drivers
*******

==================
파일 기반 캐싱
==================

Unlike caching from the Output Class, the driver file-based caching
allows for pieces of view files to be cached. Use this with care, and
make sure to benchmark your application, as a point can come where disk
I/O will negate positive gains by caching.
출력 클래스의 캐싱과 달리 드라이버 파일 기반 캐싱을 사용하면 뷰 파일 조각을 캐시 할 수 있습니다. 캐시를 사용하여 디스크 I / O가 긍정적 인 이익을 무효화 할 수 있으므로주의해서 사용해야하며 응용 프로그램을 벤치마킹해야합니다.

=================
Memcached 캐싱
=================

Multiple Memcached servers can be specified in the cache configuration file.
여러대의 Memcached 서버를 캐시 구성 파일에 지정할 수 있습니다.

Memcached에 대한 자세한 내용은 `http://php.net/memcached <http://php.net/memcached>`_ 를 참조 하십시오.

================
WinCache 캐싱
================

Windows에서는 WinCache 드라이버를 사용할 수도 있습니다.

Memcached에 대한 자세한 내용은 `http://php.net/wincache <http://php.net/wincache>`_ 를 참조 하십시오.

=============
Redis 캐싱
=============

Redis is an in-memory key-value store which can operate in LRU cache mode.
To use it, you need `Redis server and phpredis PHP extension <https://github.com/phpredis/phpredis>`_.
Redis는 LRU 캐시 모드에서 작동 할 수있는 in-memory key-value 저장소입니다. 그것을 사용하려면 `Redis server and phpredis PHP extension <https://github.com/phpredis/phpredis>`_ 이 필요 합니다 .

redis 서버 연결 구성 옵션은 application/config/redis.php 파일에 저장해야합니다.
사용 가능한 옵션은 다음과 같습니다.

::

	$config['host'] = '127.0.0.1';
	$config['password'] = NULL;
	$config['port'] = 6379;
	$config['timeout'] = 0;

For more information on Redis, please see
`http://redis.io <http://redis.io>`_.
Redis에 대한 자세한 내용은 `http://redis.io <http://redis.io>`_ 를 참조하십시오 .

===========
더미 캐시
===========

This is a caching backend that will always 'miss.' It stores no data,
but lets you keep your caching code in place in environments that don't
support your chosen cache.
이것은 캐싱 백엔드 결과는 항상 'miss.' 입니다. 데이터를 저장하지 않지만 선택한 캐시를 지원하지 않는 환경에서 캐싱 코드를 유지할 수 있습니다.