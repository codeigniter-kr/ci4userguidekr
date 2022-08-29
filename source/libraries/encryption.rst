##################
암호화 서비스
##################

.. important:: 암호 저장에 이 라이브러리나 다른 *encryption* 라이브러리를 사용하지 마십시오! 암호는 *hashed* 이어야 하며, PHP의 `암호 해싱 확장 <https://www.php.net/password>`_\ 을 통해 암호를 입력해야 합니다

암호화 서비스는 양방향 대칭(비밀 키) 데이터 암호화를 제공합니다.
이 서비스는 아래 설명된대로 매개 변수에 맞게 암호화 **핸들러**\ 를 인스턴스화 또는 초기화합니다.

암호화 서비스 핸들러는 CodeIgniter의 간단한 ``EncrypterInterface``\ 를 구현해야 합니다.
적절한 PHP 암호화 확장 또는 타사 라이브러리를 사용하려면 서버에 추가 소프트웨어가 설치되어 있어야 하거나 PHP 인스턴스에서 명시적으로 사용하도록 설정해야 할 수 있습니다.

다음 PHP 확장이 현재 지원됩니다 :

- `OpenSSL <https://www.php.net/openssl>`_
- `Sodium <https://www.php.net/manual/en/book.sodium>`_

.. note:: ``MCrypt`` 확장에 대한 지원은 PHP 7.2에서 더 이상 사용되지 않으므로 제거되었습니다.

이것은 완전한 암호화 솔루션이 아닙니다. 
더 많은 기능(예 : 공개 키 암호화)이 필요한 경우 위의 확장을 직접 사용하거나, 다음과 같은 보다 포괄적인 패키지를 살펴보십시오.

- `Halite <https://github.com/paragonie/halite>`_, libsodium으로 구축된 O-O 패키지, or
- `Sodium_compat <https://github.com/paragonie/sodium_compat>`_, 이전 버전의 PHP(5.2.4+)에 libsodium 지원을 추가하는 순수한 PHP 구현

.. contents::
	:local:
	:depth: 2

.. _usage:

****************************
암호화 라이브러리 사용
****************************

CodeIgniter의 모든 서비스와 마찬가지로 ``Config\Services``\ 를 통해 로드할 수 있습니다

.. literalinclude:: encryption/001.php

암호화 키를 설정했다고 가정하면 (참조 :ref:`configuration`) 데이터 암호화 및 암호 해독은 간단합니다 - 적절한 문자열을 ``encrypt()`` 또는 ``decrypt()`` 메소드에 전달하십시오.

.. literalinclude:: encryption/002.php

이걸로 끝입니다! 
암호화 라이브러리는 전체 프로세스를 암호로 안전하게 보호하는데 필요한 모든 것을 수행합니다.
당신은 그것에 대해 걱정할 필요가 없습니다.

.. _configuration:

라이브러리 구성
=======================

위의 예는 ``app/Config/Encryption.php``\ 에 있는 구성 설정을 사용합니다.

========== ====================================================
Option     사용 가능한 값(기본값은 괄호).
========== ====================================================
key        암호화 키 스타터
driver     선호하는 핸들러, ``OpenSSL`` or ``Sodium`` (``OpenSSL``)
blockSize  SodiumHandler의 패딩 바이트 길이 (``16``)
digest     메시지 다이제스트 알고리즘 (``SHA512``)
========== ====================================================

자신의 구성 객체를 ``Services`` 호출에 전달하여 구성 파일의 설정을 바꿀 수 있습니다.
``$config`` 변수는 ``Config\Encryption`` 클래스의 인스턴스여야 합니다.

.. literalinclude:: encryption/003.php

기본 행동
================

기본적으로 암호화 라이브러리는 구성된 *key*\ 와 SHA512 HMAC 인증을 사용하여 AES-256-CTR 암호와 함께 OpenSSL 핸들러를 사용합니다.

제공한 *key*\ 는 구성된 키에서 두 개의 개별 키를 파생시키는 데 사용됩니다.
하나는 암호화 용이고 다른 하나는 인증 용입니다.
이는 `HMAC 기반 키 파생 함수(HKDF) <https://en.wikipedia.org/wiki/HKDF>`_\ 라는 기술을 통해 수행됩니다.

암호화 키 설정
===========================

사용중인 암호화 알고리즘의 암호화 키는 **반드시** 있어야합니다.
AES-256의 경우 길이는 256 비트 또는 32 바이트 (문자)입니다.

키는 가능한 랜덤해야 하며 일반 텍스트 문자열이거나 해시 함수의 출력이 아니어야 합니다.
적절한 키를 만들려면 암호화 라이브러리의 ``createKey()`` 메소드를 사용하십시오.

.. literalinclude:: encryption/004.php

키는 ``app/Config/Encryption.php``\ 에 저장되거나, 직접 저장 메커니즘을 설계하고 암호화/암호 해독시 동적으로 키를 전달할 수 있습니다.

``app/Config/Encryption.php``\ 에 키를 저장하려면 파일을 열고 다음을 설정하십시오.

.. literalinclude:: encryption/005.php

인코딩 키 또는 결과
------------------------

``createKey()`` 메소드는 처리하기 어려운 이진 데이터를 출력하므로 (복사-붙여 넣기로 인해 손상 될 수 있음) ``bin2hex()`` 또는 ``base64_encode``\ 으로 키를 문자열로 전환하여 작업합니다.

.. literalinclude:: encryption/006.php

암호화 결과에 동일한 기술이 유용할 수 있습니다.

.. literalinclude:: encryption/007.php

Using Prefixes in Storing Keys
------------------------------

암호화 키를 저장할 때 두 가지 특수 접두사 ``hex2bin:``\ 와 ``base64:``\ 를 활용할 수 있습니다.
접두사가 키 값 바로 앞에 있으면 ``Encryption``\ 는 지능적으로 키를 구문 분석하여 이에 해당하는 바이너리 문자열을 라이브러리에 전달합니다.

.. literalinclude:: encryption/008.php

``.env`` 파일에서도 이 접두사를 사용할 수 있습니다!

::

	// hex2bin 사용
	encryption.key = hex2bin:<your-hex-encoded-key>

	// 또는
	encryption.key = base64:<your-base64-encoded-key>

패딩(Padding)
=============

때때로, 메시지의 길이는 메시지의 본질에 대한 많은 정보를 제공할 수 있습니다.
메시지가 "예", "아니오" 또는 "아마도" 중 하나일 경우, 메시지를 암호화하는 것은 도움이 되지 않습니다. 메시지의 길이를 아는 것만으로도 메시지가 무엇인지 알 수 있습니다.

패딩은 길이를 지정된 블록 크기의 배수로 만들어 이를 완화하기 위한 기술입니다.

패딩(Padding)은 libsodium의 ``sodium_pad`` 와 ``sodium_unpad`` 함수를 사용하여 ``sodiumHandler``\ 에서 구현됩니다.
이를 위해서는 암호화 전 일반 텍스트 메시지에 추가되고 암호 해독 후 제거되는 패딩 길이(바이트)를 사용해야 합니다.
패딩은 ``Config\Encryption``\ 의 ``$blockSize`` 속성을 통해 구성 할 수 있으며, 이 값은 0보다 커야합니다.

.. important:: 자신만의 패딩 구현을 고안하지 않는 것이 좋습니다. 
    항상 안전한 라이브러리 구현을 사용해야 합니다. 
    또한 암호를 채워서는 안됩니다.
    암호 길이를 숨기기 위해 패딩을 사용하지 않는 것이 좋습니다. 
    서버에 암호를 보내려는 클라이언트는 해시 함수의 단일 반복을 통해 암호를 해시해야 합니다.
    이렇게 하면 전송되는 데이터의 길이가 일정하게 유지되고 서버가 암호 복사본을 쉽게 얻을 수 없습니다.

암호화 처리기 노트
========================

OpenSSL 노트
------------------

`OpenSSL <https://www.php.net/openssl>`_ 확장은 오랫동안 PHP의 표준이었습니다.

CodeIgniter의 OpenSSL 핸들러는 AES-256-CTR 암호를 사용합니다.

구성이 제공하는 *key*\ 는 다른 하나의 키(암호화와 인증을위한 키)를 파생시키는 데 사용됩니다. 
이것은 `HMAC 기반 키 파생 함수 <http://en.wikipedia.org/wiki/HKDF>`_ (HKDF)로 알려진 기술을 통해 달성됩니다.

Sodium Notes
------------

`Sodium <https://www.php.net/manual/en/book.sodium>`_ 확장은 PHP 7.2.0부터 기본적으로 PHP에 번들로 제공됩니다.

Sodium은 XSalsa20, MAC의 경우 Poly1305를 사용하여 암호화하고, 엔드 투 엔드 시나리오에서 비밀 메시지를 보낼 때 키 교환을 위해 XS25519 알고리즘을 사용합니다.
대칭 암호화와 같은 공유 키를 사용하여 문자열을 암호화 또는 인증하기 위해 Sodium은 XSalsa20 알고리즘을 사용하여 암호화하고 HMAC-SHA512를 인증에 사용합니다.

.. note:: CodeIgniter의 ``SodiumHandler``\ 는 모든 암호화 또는 복호화 세션에서 ``sodium_memzero``\ 를 사용합니다.
    각 세션이 끝나면 메시지(일반 텍스트 또는 암호 텍스트)와 시작 키가 버퍼에서 지워집니다.
    새 세션을 시작하기 전에 키를 다시 제공해야 할 수 있습니다.

메시지 길이
==============

암호화된 문자열은 일반적으로 암호에 따라 원래의 일반 텍스트 문자열보다 깁니다.

이는 암호 알고리즘 자체, 암호 텍스트 앞에 붙는 초기화 벡터(IV)와 앞에 붙는 HMAC 인증 메시지의 영향을 받습니다.
또한 암호화된 메시지는 Base64로 인코딩되어 사용 가능한 문자 세트에 관계없이 저장 및 전송에 안전합니다.

데이터 저장 메커니즘을 선택할 때 이를 명심하십시오.
쿠키를 예로 들자면 4K의 정보만 저장할 수 있습니다.

암호화 관리자를 직접 사용
=====================================

:ref:`usage`\ 에 설명된대로 ``Services`` 를 사용하는 대신 (또는 그에 추가하여) ``Encrypter``\ 를 직접 만들거나 기존 인스턴스의 설정을 변경할 수 있습니다.

.. literalinclude:: encryption/009.php

``$config``\ 는 ``Config\Encryption`` 클래스의 인스턴스여야 합니다.

***************
Class Reference
***************

.. php:namespace:: CodeIgniter\Encryption

.. php:class:: Encryption

	.. php:staticmethod:: createKey([$length = 32])

		:param int $length: 출력 길이
		:returns: 지정된 길이의 의사 난수 암호화 키, 실패시 FALSE
		:rtype:	string

		운영 체제 소스(*i.e.* ``/dev/urandom``)에서 임의의 데이터를 가져와서 암호화 키를 작성합니다.


	.. php:method:: initialize([Encryption $config = null])

		:param Config\\Encryption $config: 구성 매개 변수
		:returns: ``CodeIgniter\Encryption\EncrypterInterface`` 인스턴스
		:rtype:	``CodeIgniter\Encryption\EncrypterInterface``
		:throws: ``CodeIgniter\Encryption\Exceptions\EncryptionException``

		다른 설정을 사용하도록 라이브러리를 초기화(구성)합니다.

		.. literalinclude:: encryption/010.php

		자세한 정보는 :ref:`configuration` 섹션을 참조하십시오.

.. php:interface:: CodeIgniter\\Encryption\\EncrypterInterface

	.. php:method:: encrypt($data[, $params = null])

		:param string $data: 암호화할 데이터
		:param array|string|null $params: 구성 매개 변수 (key)
		:returns: 암호화된 데이터
		:rtype: string
		:throws: ``CodeIgniter\\Encryption\\Exceptions\\EncryptionException``

		입력 데이터를 암호화하고 암호문을 리턴합니다.

		두 번째 인수로 전달되는 매개 변수 ``$params``\ 가 배열인 경우 ``key`` 요소가 암호화 키로 사용됩니다. 
		암호화 키는 문자열로 전달될 수 있습니다.

		SodiumHandler를 사용중이고 런타임에 다른 ``blockSize``\ 를 전달하려면 ``$params`` 배열의 ``blockSize``\ 키를 통하여 전달합십시오.

		.. literalinclude:: encryption/011.php

	.. php:method:: decrypt($data[, $params = null])

		:param string $data: 해독할 데이터
		:param array|string|null $params: 구성 매개 변수 (key)
		:returns: 암호 해독된 데이터
		:rtype:	string
		:throws: ``CodeIgniter\\Encryption\\Exceptions\\EncryptionException``

		입력 데이터를 해독하여 일반 텍스트로 반환합니다.

		두 번째 인수로 전달되는 매개 변수 ``$params``\ 가 배열인 경우 ``key`` 요소가 암호화 키로 사용됩니다. 
		암호화 키는 문자열로 전달될 수 있습니다.

		SodiumHandler를 사용중이고 런타임에 다른 ``blockSize``\ 를 전달하려면 ``$params`` 배열의 ``blockSize``\ 키를 통하여 전달합십시오.

		.. literalinclude:: encryption/012.php
