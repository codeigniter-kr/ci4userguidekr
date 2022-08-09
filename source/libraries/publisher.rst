####################
퍼블리셔(Publisher)
####################

퍼블리셔 라이브러리는 강력한 탐지 및 오류 검사를 사용하여 프로젝트의 파일을 복사할 수 있는 방법을 제공합니다.

.. contents::
    :local:
    :depth: 2

*******************
라이브러리 로드
*******************

퍼블리셔 인스턴스는 소스 및 대상에 한정되므로 이 라이브러리는 ``Services``\ 를 통해 사용할 수 없고, 직접 인스턴스화하거나 확장(extended)해야 합니다.

.. literalinclude:: publisher/001.php

*****************
컨셉 및 사용법
*****************

``Publisher``\ 는 백엔드 프레임워크 내에서 작업할 때 몇 가지 공통적인 문제를 해결합니다.

* 버전 종속성을 가진 프로젝트 자산(asset)을 어떻게 유지해야 합니까?
* 웹 액세스가 필요한 업로드 및 기타 "동적" 파일은 어떻게 관리합니까?
* 프레임워크나 모듈이 변경되었을 때 프로젝트를 업데이트하려면 어떻게 해야 합니까?
* 구성요소가 기존 프로젝트에 새로운 컨텐츠를 어떻게 주입할 수 있습니까?

출판은 기본적으로 파일을 프로젝트에 복사하는 것과 같습니다. 
``Publisher``\ 는 ``FileCollection``\ 을 확장하여 입력 파일을 읽고, 필터링하고, 처리하기 위해 유창한 스타일의 명령 체이닝한 다음 이를 대상에 복사하거나 병합합니다.
컨트롤러 또는 기타 구성 요소 요청 시 ``Publisher``\ 를 사용하거나 클래스를 확장하고 ``spark publish``\ 로 검색한 내용을 활용하여 출판을 준비할 수 있습니다.

On Demand
=========

클래스의 새 인스턴스를 인스턴스화하여 ``Publisher``\ 에 직접 액세스합니다.

.. literalinclude:: publisher/002.php

``Publisher``\ 는 기본적으로 필요한 자원을 프로젝트의 ``ROOTPATH``\ 에서 ``FCPATH``\ 로 가져와 웹에서 액세스할 수 있게 합니다.
생성자에 새 소스 및 대상을 전달할 수 있습니다.

.. literalinclude:: publisher/003.php

모든 파일이 준비되면 출력 명령(**copy()** 또는 **merge()**)중 하나를 사용하여 준비된 파일을 대상으로 가져갑니다.

.. literalinclude:: publisher/004.php

사용 가능한 메소드에 대한 전체 설명은 :ref:`reference`\ 를 참조하십시오.

자동화 및 검색
========================

응용 프로그램 배포 또는 유지 관리의 일부로 포함된 일반 게시 작업이 있을 수 있습니다.
``Publisher``\ 는 강력한 ``Autoloader``\ 를 활용하여 게시 준비가 된 모든 하위 클래스를 찾습니다.

.. literalinclude:: publisher/005.php

기본적으로 ``discover()``\ 는 모든 네임스페이스에서 "Publishers" 디렉토리를 검색하지만 다른 디렉토리를 지정할 수 있으며 발견된 모든 하위 클래스를 반환합니다.

.. literalinclude:: publisher/006.php

대부분의 경우 검색을 직접 처리할 필요가 없습니다. 제공된 "publish" 명령을 사용하십시오.

::

    > php spark publish

기본적으로 클래스 확장자 ``publish()`` 에서 ``$source``\ 의 모든 파일을 추가하고 충돌 시 덮어쓰기하여 대상에 병합합니다.

보안
========

모듈이 프로젝트에 악성 코드를 삽입하는 것을 방지하기 위해 ``Publisher``\ 에는 대상으로 허용되는 디렉토리와 파일 패턴을 정의하는 설정 파일이 포함되어 있습니다.
기본적으로 파일은 프로젝트에만 게시될 수 있으며 나머지 파일 시스템에 대한 액세스를 방지하기 위해 **public/**\ (``FCPATH``) 폴더는 다음 확장자를 가진 파일만 받습니다.

* 웹 자산(assets): css, scss, js, map
* 실행할 수 없는 웹 파일: htm, html, xml, json, webmanifest
* 폰트: tff, eot, woff, woff2
* 이미지: gif, jpg, jpeg, tif, tiff, png, webp, bmp, ico, svg

프로젝트의 보안을 추가하거나 조정해야 하는 경우 ``Config\Publisher``\ 의 ``$restrictions`` 속성을 변경하세요.

********
Examples
********

다음은 게시(publishing)를 시작하는 데 도움이 되는 몇 가지 사용 사례와 구현 사례입니다.

파일 동기화 예
=================

홈페이지에 "오늘의 사진"\ 을 표시하고 싶습니다.
오늘의 사진에 대한 피드가 있지만 프로젝트의 탐색 가능한 위치에서 **public/images/daily_photo.jpg**\ 로 실제 파일을 가져와야 합니다.
매일 실행하도록 :doc:`Custom Command </cli/cli_commands>`\ 를 설정하여 이를 처리할 수 있습니다.

.. literalinclude:: publisher/007.php

이제 ``spark publish:daily``\ 를 실행하면 홈페이지의 이미지가 최신 상태로 유지됩니다.
사진을 외부 API에서 가져온 경우에는 어떻게 됩니까?
``addPath()`` 대신 ``addUri()``\ 을 사용하여 원격 리소스를 다운로드하고 대신 게시할 수 있습니다.

.. literalinclude:: publisher/008.php

자산(Asset) 종속성 예
==========================

프론트엔드 라이브러리 "Bootstrap"\ 을 프로젝트에 통합하고 싶지만 잦은 업데이트로 인해 따라잡기가 번거롭습니다.
프로젝트에서 ``Publisher``\ 를 확장하여 프론트엔드 자산을 동기화하도록 프로젝트에서 발행물 정의를 생성할 수 있습니다.
**app/Publishers/BootstrapPublisher.php**\ 는 다음과 같습니다.

.. literalinclude:: publisher/009.php

이제 Composer를 통해 종속성을 추가하고 ``spark publish``\ 를 호출하여 게시를 실행합니다.

::

    > composer require twbs/bootstrap
    > php spark publish

... and you'll end up with something like this::

    public/.htaccess
    public/favicon.ico
    public/index.php
    public/robots.txt
    public/
        bootstrap/
            css/
                bootstrap.min.css
                bootstrap-utilities.min.css.map
                bootstrap-grid.min.css
                bootstrap.rtl.min.css
                bootstrap.min.css.map
                bootstrap-reboot.min.css
                bootstrap-utilities.min.css
                bootstrap-reboot.rtl.min.css
                bootstrap-grid.min.css.map
            js/
                bootstrap.esm.min.js
                bootstrap.bundle.min.js.map
                bootstrap.bundle.min.js
                bootstrap.min.js
                bootstrap.esm.min.js.map
                bootstrap.min.js.map

모듈 배포 예
=========================

널리 사용되는 인증 모듈을 사용하는 개발자가 마이그레이션, 컨트롤러 및 모델의 기본 동작을 확장할 수 있도록 허용하려고 합니다. 이러한 구성요소를 응용 프로그램에 주입하여 사용할 수 있도록 고유한 모듈 "publish" 명령을 만들 수 있습니다.

.. literalinclude:: publisher/010.php

이제 모듈 사용자가 ``php spark auth:publish``\ 를 실행하면 프로젝트에 다음이 추가됩니다.

::

    app/Controllers/AuthController.php
    app/Database/Migrations/2017-11-20-223112_create_auth_tables.php.php
    app/Models/LoginModel.php
    app/Models/UserModel.php

.. _reference:

*****************
Library Reference
*****************

.. note:: ``Publisher``\ 는 :doc:`FileCollection </libraries/files>`\ 의 확장이므로 파일을 읽고 필터링하는 모든 메소드에 액세스할 수 있습니다.

지원하는 메소드
================

[static] discover(string $directory = 'Publishers'): Publisher[]
----------------------------------------------------------------

지정된 네임스페이스 디렉터리에 있는 모든 게시자를 검색하여 반환합니다.
예를 들어 **app/Publishers/FrameworkPublisher.php**\ 와 **myModule/src/Publishers/AssetPublisher.php**\ 가 모두 존재하고 ``Publisher``\ 의 확장인 경우 ``Publisher::discover()``\ 는 각각의 인스턴스를 반환합니다.

publish(): bool
---------------

전체 입력-프로세스-출력 체인을 처리합니다. 
기본적으로 이것은 ``addPath($source)``\ 와 ``merge(true)``\ 를 호출하는 것과 동일하지만 일반적으로 자식 클래스는 자체 구현을 제공합니다.
``publish()``\ 는 ``spark publish``\ 를 실행할 때 검색된 모든 게시자에서 호출됩니다.
성공 또는 실패를 반환합니다.

getScratch(): string
--------------------

임시 작업공간을 반환하고 필요한 경우 작성합니다.
일부 작업에서는 중간 스토리지를 사용하여 파일 및 변경 사항을 스테이징하고, 이를 통해 사용 가능한 임시 쓰기 가능 디렉토리로 이동할 수 있습니다.

getErrors(): array<string, Throwable>
-------------------------------------

마지막 쓰기 작업에서 발생한 오류를 반환합니다. 
배열 키는 오류를 발생시킨 파일이며 값은 발견된 실행 파일입니다.
오류 메시지를 가져오려면 Drowable에서 ``getMessage()``\ 를 사용하십시오.

addPath(string $path, bool $recursive = true)
---------------------------------------------

상대 경로로 표시된 모든 파일을 추가합니다.
경로는 ``$source``\ 와 관련된 실제 파일 또는 디렉토리에 대한 참조입니다. 
상대 경로가 디렉토리로 확인되면 ``$recursive``\ 는 하위 디렉토리를 포함합니다.

addPaths(array $path, bool $recursive = true)
---------------------------------------------

상대 경로로 표시된 모든 파일을 추가합니다.
경로는 ``$source``\ 와 관련된 실제 파일 또는 디렉토리에 대한 참조입니다.
상대 경로가 디렉토리로 확인되면 ``$recursive``\ 는 하위 디렉토리를 포함합니다.

addUri(string $uri)
-------------------

``CURLRequest``\ 를 사용하여 URI의 내용을 스크래치 작업 공간으로 다운로드한 다음 결과 파일을 목록에 추가합니다.

addUris(array $uris)
--------------------

``CURLRequest``\ 를 사용하여 URI의 내용을 스크래치 작업 공간으로 다운로드한 다음 결과 파일을 목록에 추가합니다.

.. note:: CURL 요청은 ``GET``\ 이며 파일 내용에 대한 응답 본문을 사용합니다.
     일부 원격 파일은 제대로 처리하기 위해 사용자 지정 요청이 필요할 수 있습니다.

파일 출력
=========

wipe()
------

``$destination``\ 의 모든 파일, 디렉토리 및 하위 디렉토리를 제거합니다.

.. important:: 현명하게 사용하십시오.

copy(bool $replace = true): bool
--------------------------------

모든 파일을 ``$destination``\ 에 복사합니다.
이것은 디렉토리 구조를 다시 생성하지 않으므로 현재 목록의 모든 파일은 동일한 대상 디렉토리에 있게 됩니다.
``$replace``\ 를 사용하면 파일이 이미 존재한다면 파일을 덮어씁니다.
성공 또는 실패를 반환하고 ``getPublished()``\ 와 ``getErrors()``\ 를 사용하여 문제를 해결합니다.
이름이 중복되어 충돌한 예입니다.

.. literalinclude:: publisher/011.php

merge(bool $replace = true): bool
---------------------------------

모든 파일을 적절한 상대 하위 디렉토리의 ``$destination``\ 에 복사합니다.
``$source``\ 와 일치하는 모든 파일은 ``$destination``\ 의 해당 디렉토리에 배치되어 "mirror" 또는 "rsync" 작업을 효과적으로 수행합니다.
``$replace``\ 를 사용하면 파일이 이미 존재한다면 파일을 덮어씁니다.
디렉토리가 병합되기 때문에 대상의 다른 파일에는 영향을 미치지 않습니다.
성공 또는 실패를 반환하고 ``getPublished()``\ 와 ``getErrors()``\ 를 사용하여 문제를 해결합니다.

Example

.. literalinclude:: publisher/012.php
