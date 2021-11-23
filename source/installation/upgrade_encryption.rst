Upgrade Encryption
##################

.. contents::
    :local:
    :depth: 1


Documentations
==============

- `Codeigniter 3.X Encryption 문서 <http://codeigniter.com/userguide3/libraries/encryption.html>`_
- :doc:`Codeigniter 4.X Encryption 문서 </libraries/encryption>`


변경된 사항
=====================
- PHP 7.2에서 더 이상 사용되지 않는 ``MCrypt``\ 에 대한 지원이 중단되었습니다.

Upgrade Guide
=============
1. Within your configs the ``$config['encryption_key'] = 'abc123';`` moved from ``application/config/config.php`` to ``public $key = 'abc123';`` in ``app/Config/Encryption.php``.
2. Wherever you have used the encryption library you have to replace ``$this->load->library('encryption');`` with ``$encrypter = service('encrypter');`` and change the methods for encryption and decrypting like in the following code example.

1. ``application/config/config.php``\ 의 ``$config['encryption_key'] = 'abc123';``\ 는  ``app/Config/Encryption.php``\ 의 ``public $key = 'abc123';``\ 로  이동되었습니다.
2. 암호화 라이브러리를 사용한 곳은 ``$this->load->library('encryption');``\ 를 ``$encrypter = service('encrypter');``\ 로 바꾸고 암호화 및 암호 해독 방법을 다음 예제와 같이 변경합니다.

Code Example
============

Codeigniter Version 3.11
------------------------
::

    $this->load->library('encryption');

    $plain_text = 'This is a plain-text message!';
    $ciphertext = $this->encryption->encrypt($plain_text);

    // Outputs: This is a plain-text message!
    echo $this->encryption->decrypt($ciphertext);


Codeigniter Version 4.x
-----------------------
::

    $encrypter = service('encrypter');

    $plainText = 'This is a plain-text message!';
    $ciphertext = $encrypter->encrypt($plainText);

    // Outputs: This is a plain-text message!
    echo $encrypter->decrypt($ciphertext);
