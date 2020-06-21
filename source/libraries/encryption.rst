##################
암호화 서비스
##################

.. important:: 암호 저장에 이 라이브러리나 다른 *encryption* 라이브러리를 사용하지 마십시오! 암호는 *hashed* 이어야 하며, PHP의 `암호 해싱 확장 <https://www.php.net/password>`_\ 을 통해 암호를 입력해야 합니다

암호화 서비스는 양방향 대칭(비밀 키) 데이터 암호화를 제공합니다.
이 서비스는 아래 설명된대로 매개 변수에 맞게 암호화 **핸들러**\ 를 인스턴스화 또는 초기화합니다.

암호화 서비스 핸들러는 CodeIgniter의 간단한 ``EncrypterInterface``\ 를 구현해야 합니다.
적절한 PHP 암호화 확장 기능 또는 타사 라이브러리를 사용하려면 서버에 추가 소프트웨어가 설치되어 있거나 PHP 인스턴스에서 명시적으로 활성화해야 할 수도 있습니다.

다음 PHP 확장이 현재 지원됩니다 :

- `OpenSSL <https://www.php.net/openssl>`_

.. note:: ``MCrypt`` 확장에 대한 지원은 PHP 7.2에서 더 이상 사용되지 않으므로 제거되었습니다.

이것은 완전한 암호화 솔루션이 아닙니다. 
더 많은 기능(예 : 공개 키 암호화)이 필요한 경우 위의 확장을 직접 사용하거나, 다음과 같은 보다 포괄적인 패키지를 살펴보십시오.

- `Halite <https://github.com/paragonie/halite>`_, libsodium으로 구축된 O-O 패키지, or
- `Sodium_compat <https://github.com/paragonie/sodium_compat>`_, 이전 버전의 PHP(5.2.4+)에 libsodium 지원을 추가하는 순수한 PHP 구현

.. contents::
  :local:

.. raw:: html

  <div class="custom-index container"></div>

.. _usage:

****************************
암호화 라이브러리 사용
****************************

CodeIgniter의 모든 서비스와 마찬가지로 ``Config\Services``\ 를 통해 로드할 수 있습니다

::

    $encrypter = \Config\Services::encrypter();

암호화 키를 설정했다고 가정하면 (참조 :ref:`configuration`) 데이터 암호화 및 암호 해독은 간단합니다 - 적절한 문자열을 ``encrypt()`` 또는 ``decrypt()`` 메소드에 전달하십시오.

::

	$plainText = 'This is a plain-text message!';
	$ciphertext = $encrypter->encrypt($plainText);

	// Outputs: This is a plain-text message!
	echo $encrypter->decrypt($ciphertext);

이걸로 끝입니다! 
암호화 라이브러리는 전체 프로세스를 암호로 안전하게 보호하는데 필요한 모든 것을 수행합니다.
당신은 그것에 대해 걱정할 필요가 없습니다.

.. _configuration:

라이브러리 구성
=======================

위의 예는 ``app/Config/Encryption.php``\ 에 있는 구성 설정을 사용합니다.

두 가지 설정만 있습니다.

======== ===============================================
Option   Possible values (default in parentheses)
======== ===============================================
key      Encryption key starter
driver   Preferred handler (OpenSSL)
======== ===============================================

자신의 구성 객체를 ``Services`` 호출에 전달하여 구성 파일의 설정을 바꿀 수 있습니다.
``$config`` 변수는 `Config\\Encryption` 클래스의 인스턴스이거나 `CodeIgniter\\Config\\BaseConfig`\ 를 확장하는 객체여야 합니다.

::

	$config         = new \Config\Encryption();
    $config->key    = 'aBigsecret_ofAtleast32Characters';
    $config->driver = 'OpenSSL';

    $encrypter = \Config\Services::encrypter($config);

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

::

	// $key will be assigned a 32-byte (256-bit) random key
	public $key = Encryption::createKey(32);

키는 *application/Config/Encryption.php*\ 에 저장되거나, 직접 저장 메커니즘을 설계하고 암호화/암호 해독시 동적으로 키를 전달할 수 있습니다.

*application/Config/Encryption.php*\ 에 키를 저장하려면 파일을 열고 다음을 설정하십시오.

::

	$key = 'YOUR KEY';

인코딩 키 또는 결과
------------------------

``createKey()`` 메소드는 처리하기 어려운 이진 데이터를 출력하므로 (복사-붙여 넣기로 인해 손상 될 수 있음) ``bin2hex()``, ``hex2bin()`` 또는 Base64 인코딩으로 키를 문자열로 전환하여 작업합니다.

::

	// Get a hex-encoded representation of the key:
	$encoded = bin2hex(Encryption::createKey(32));

	// Put the same value in your config with hex2bin(),
	// so that it is still passed as binary to the library:
	$key = hex2bin(<your hex-encoded key>);

암호화 결과에 동일한 기술이 유용할 수 있습니다.

::

	// Encrypt some text & make the results text
	$encoded = base64_encode($encrypter->encrypt($plaintext));

암호화 처리기 노트
========================

OpenSSL 노트
------------------

`OpenSSL <https://www.php.net/openssl>`_ 확장은 오랫동안 PHP의 표준이었습니다.

CodeIgniter의 OpenSSL 핸들러는 AES-256-CTR 암호를 사용합니다.

구성이 제공하는 *key*\ 는 다른 하나의 키(암호화와 인증을위한 키)를 파생시키는 데 사용됩니다. 
이것은 `HMAC 기반 키 파생 함수 <http://en.wikipedia.org/wiki/HKDF>`_ (HKDF)로 알려진 기술을 통해 달성됩니다.

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

::

    // create an Encrypter instance
    $encryption = new \Encryption\Encryption();

    // reconfigure an instance with different settings
    $encrypter = $encryption->initialize($config);

``$config``\ 는 `Config\\Encryption` 클래스의 인스턴스 또는 `CodeIgniter\\Config\\BaseConfig`\ 를 확장하는 객체의 인스턴스여야 합니다.

***************
Class Reference
***************

.. php:class:: CodeIgniter\\Encryption\\Encryption

	.. php:staticmethod:: createKey($length)

		:param	int	$length: 출력 길이
		:returns:	지정된 길이의 의사 난수 암호화 키, 실패시 FALSE
		:rtype:	string

		운영 체제 소스(i.e. /dev/urandom)에서 임의의 데이터를 가져와서 암호화 키를 작성합니다.


	.. php:method:: initialize($config)

		:param	BaseConfig	$config: 구성 매개 변수
		:returns:	CodeIgniter\\Encryption\\EncrypterInterface instance
		:rtype:	CodeIgniter\\Encryption\\EncrypterInterface
		:throws:	CodeIgniter\\Encryption\\Exceptions\\EncryptionException

		다른 설정을 사용하도록 라이브러리를 초기화(구성)합니다.

		::

			$encrypter = $encryption->initialize(['cipher' => '3des']);

		자세한 정보는 :ref:`configuration` 섹션을 참조하십시오.

.. php:interface:: CodeIgniter\\Encryption\\EncrypterInterface

	.. php:method:: encrypt($data, $params = null)

		:param	string	$data: 암호화할 데이터
		:param		$params: 구성 매개 변수 (key)
		:returns:	암호화된 데이터, 실패시 FALSE
		:rtype:	string
		:throws:	CodeIgniter\\Encryption\\Exceptions\\EncryptionException

		입력 데이터를 암호화하고 암호문을 리턴합니다.

		두 번째 인수로 전달되는 매개 변수 ``$params``\ 가 배열인 경우 ``key`` 요소가 암호화 키로 사용됩니다. 
		암호화 키는 문자열로 전달될 수 있습니다.

		::

			$ciphertext = $encrypter->encrypt('My secret message');
			$ciphertext = $encrypter->encrypt('My secret message', ['key' => 'New secret key']);
			$ciphertext = $encrypter->encrypt('My secret message', 'New secret key');

	.. php:method:: decrypt($data, $params = null)

		:param	string	$data: 해독할 데이터
		:param		$params: 구성 매개 변수 (key)
		:returns:	암호 해독된 데이터, 실패시 FALSE
		:rtype:	string
		:throws:	CodeIgniter\\Encryption\\Exceptions\\EncryptionException

		입력 데이터를 해독하여 일반 텍스트로 반환합니다.

		두 번째 인수로 전달되는 매개 변수 ``$params``\ 가 배열인 경우 ``key`` 요소가 암호화 키로 사용됩니다. 
		암호화 키는 문자열로 전달될 수 있습니다.


		Examples::

			echo $encrypter->decrypt($ciphertext);
			echo $encrypter->decrypt($ciphertext, ['key' => 'New secret key']);
			echo $encrypter->decrypt($ciphertext, 'New secret key');
