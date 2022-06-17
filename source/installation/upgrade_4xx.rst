#############################
3.x에서 4.x로 업그레이드
#############################

CodeIgniter4는 프레임워크를 다시 작성하였으며 이전 버전과 호환되지 않습니다.
앱을 업그레이드하는 대신 앱을 변환하는 것이 좋습니다.
변환이 완료되었다면 CodeIgniter4의 한 버전에서 다음 버전으로 업그레이드하는 것은 간단할 것입니다.

"간결하고 의미 있고 단순한" 철학은 유지되었지만 CodeIgniter3에 비해 구현에 많은 차이가 있습니다.

업그레이드를 위한 12단계 점검 목록은 없습니다. 
대신, 새 프로젝트 폴더인 :doc:`설치 및 사용 </installation/index>`\ 에서 CodeIgniter 4 사본으로 시작한 다음 앱 구성 요소를 변환 및 통합하십시오.
여기서 가장 중요한 고려사항들을 짚어보도록 하겠습니다.

프로젝트를 업그레이드하려면 두 가지 주요 작업을 수행해야 합니다.
우선, 모든 프로젝트에 중요하며 처리해야 하는 몇 가지 일반적인 조정이 있습니다.
두 번째, 라이브러리는 CodeIgniter가 빌드되고 가장 중요한 기능 중 일부를 포함하는 라이브러리입니다.
이 라이브러리들은 서로 분리되어 운영되기 때문에 하나하나 살펴봐야 합니다.

프로젝트 변환을 시작하기 전에 **사용자 가이드를 읽어야 합니다**\ !

.. contents::
    :local:
    :depth: 2

일반적인 조정
*******************

Downloads
=========

- CI4는 즉시 실행 가능한 zip 또는 tarball로 계속 사용할 수 있습니다.
- Composer를 사용하여 설치할 수도 있습니다

Namespaces
==========

- CI4는 PHP7.3+ 용으로 제작되었으며, 프레임워크의 모든 항목은 헬퍼를 제외하고 네임스페이스(namespace)가 지정됩니다.

Application Structure
=====================

- **application** 폴더의 이름이 **app**\ 으로 바뀌고, 프레임워크에는 **system** 폴더가 있으며 이전과 동일하게 해석됩니다.
- 이제 프레임워크는 앱의 문서 루트로 사용되는 **public** 폴더를 제공합니다.
- 캐시 데이터, 로그 및 세션 데이터를 보관할 수있는 **writable** 폴더도 있습니다.
- **app** 폴더는 CI3의 **application**\ 폴더와 매우 유사하지만, 이름이 일부 변경되고, 하위 폴더의 일부가 **writable** 폴더로 이동되었습니다.
- 프레임워크 구성 요소를 확장하는 메커니즘이 다르기 때문에 더 이상 중첩된 **application/core** 폴더는 없습니다 (아래 참조).

Routing
=======

- 자동 라우팅(Auto Routing)은 기본적으로 비활성화되어 있습니다. 자동 라우팅을 CI3와 같은 방식으로 사용하려면 :ref:`auto-routing`\ 을 활성화해야 합니다.
- CI4에는 새로운 더 안전한 옵션인 :ref:`auto-routing-improved`\ 도 있습니다.

Model, View and Controller
==========================

- CodeIgniter는 MVC 개념을 기반으로 합니다. 따라서 모델, 뷰 및 컨트롤러의 변경 사항은 사용자가 처리해야 하는 가장 중요한 사항 중 하나입니다.
- CodeIgniter 4의 모델은 **app/Models**\ 에 위치하며 ``<?php`` 태그 바로 뒤에 ``namespace App\Models;``\ 와 함께 ``use CodeIgniter\Model;``\ 를 추가해야 합니다.  마지막 단계는 ``extends CI_Model``\ 을 ``extends Model``\ 으로 대체하는 것입니다.
- CodeIgniter 4의 뷰는 **app/Views**\ 로 이동되었습니다. 뷰를 로드하는 구문을 ``$this->load->view('directory_name/file_name')`` 에서 ``echo view('directory_name/file_name');``\ 로 변경해야 합니다.
- CodeIgniter 4의 컨트롤러는 **app/Controllers**\ 로 이동해야 합니다. 그런 다음 ``<?php`` 태그 바로 뒤에 ``namespace App\Controllers;``\ 를 추가합니다. 마지막으로 ``extends CI_Controller``\ 을 ``extends BaseController``\ 로 바꿉니다.
- 자세한 내용은 CodeIgniter4에서 MVC 클래스를 변환하는 몇 가지 단계별 지침을 제공하는 다음 업그레이드 가이드를 참조하십시오.

.. toctree::
    :titlesonly:

    upgrade_models
    upgrade_views

Class Loading
=============

- 더 이상 CodeIgniter "superobject"\ 가 없으며 프레임워크 컴포넌트 참조가 컨트롤러의 속성으로 마법처럼 주입됩니다.
- 필요한 경우 클래스를 인스턴스화되고 ``Services``\ 를 통해 컴포넌트를 관리합니다.
- 클래스 로더는 ``App`` (**app**) 과 ``CodeIgniter`` (예 : **system**) 최상위 네임스페이스 내에서 PSR-4 스타일 클래스 찾기를 자동으로 처리하며, Composer 자동 로딩도 지원합니다.
- "HMVC" 스타일을 포함하여 가장 편한 어플리케이션 구조를 지원하도록 클래스 로딩을 구성할 수 있습니다.

Libraries
=========

- 앱 클래스(class)는 여전히 **app/Libraries**\ 에 있을 수 있지만 반드시 그럴 필요는 없습니다.
- CI3의 ``$this->load->library(x);`` 대신 구성 요소에 대한 네임스페이스 규칙에 따라 ``$this->x = new X();``\ 를 사용할 수 있습니다.

Helpers
=======

- 헬퍼는 이전과 거의 동일하지만 일부는 단순화되었습니다.
- CI4에서 ``redirect()``\ 는 스크립트 실행을 리디렉션하고 종료하는 대신 ``RedirectResponse`` 인스턴스를 반환합니다.
    - `redirect() CodeIgniter 3.X <https://codeigniter.com/userguide3/helpers/url_helper.html#redirect>`_
    - `redirect() CodeIgniter 4.X <../general/common_functions.html#redirect>`_

Events
======

- 훅(Hook)은 이벤트로 대체 되었습니다.
- CI3의 ``$hook['post_controller_constructor']`` 대신 이제 네임스페이스가 ``CodeIgniter\Events\Events;``\ 인 ``Events::on('post_controller_constructor', ['MyClass', 'MyFunction']);``\ 를 사용합니다. 
- 이벤트는 항상 활성화되어 있으며 전역적으로 사용 가능합니다.

Extending the Framework
=======================

- ``MY _...`` 프레임워크 구성 요소 확장 또는 대체를 위해 **core** 폴더가 필요하지 않습니다.
- CI4를 부분 확장하거나 교체하기 위해 라이브러리 폴더 내에 ``MY_x`` 클래스가 필요하지 않습니다.
- 원하는 위치에 필요한 클래스를 만들고 **app/Config/Services.php**\ 에 적절한 서비스 메소드를 추가하면 기본 클래스 대신 새로운 컴포넌트를 로드합니다.

라이브러리 업데이트
********************

- 앱 클래스는 **app/Libraries**\ 에 들어갈 수 있지만, 반드시 그럴 필요는 없습니다.
- CI3의 ``$this->load->library(x);`` 이제 구성 요소에 대해 다음 이름 지정 규칙을 따르는 ``$this->x = new X();``\ 를 사용할 수 있습니다.
- CodeIgniter 3의 일부 라이브러리는 버전 4에 더 이상 존재하지 않습니다. 이러한 모든 라이브러리에 대해 기능을 구현하는 새로운 방법을 찾아야 합니다. 
  이 라이브러리들은 `Calendaring <http://codeigniter.com/userguide3/libraries/calendar.html>`_, 
  `FTP <http://codeigniter.com/userguide3/libraries/ftp.html>`_, 
  `Javascript <http://codeigniter.com/userguide3/libraries/javascript.html>`_, 
  `Shopping Cart <http://codeigniter.com/userguide3/libraries/cart.html>`_, 
  `Trackback <http://codeigniter.com/userguide3/libraries/trackback.html>`_, 
  `XML-RPC /-Server <http://codeigniter.com/userguide3/libraries/xmlrpc.html>`_, 
  `Zip Encoding <http://codeigniter.com/userguide3/libraries/zip.html>`_ 
- CI3의 `Input <http://codeigniter.com/userguide3/libraries/input.html>`_\ 는 CI4의 :doc:`IncomingRequest </incoming/incomingrequest>`\ 에 해당합니다.
- CI3의 `Output <http://codeigniter.com/userguide3/libraries/output.html>`\ 는 to CI4의 :doc:`Responses </outgoing/response>`\ 에 해당합니다.
- CodeIgniter3의 다른 모든 라이브러리는 일부 조정을 통해 업그레이드할 수 있습니다. 가장 중요하고 주로 사용되는 라이브러리는 업그레이드 안내서가 제공되어 간단한 단계와 예제를 통해 코드를 조정할 수 있습니다.

.. toctree::
    :titlesonly:

    upgrade_configuration
    upgrade_controllers
    upgrade_database
    upgrade_emails
    upgrade_encryption
    upgrade_file_upload
    upgrade_html_tables
    upgrade_localization
    upgrade_migrations
    upgrade_pagination
    upgrade_responses
    upgrade_routing
    upgrade_security
    upgrade_sessions
    upgrade_validations
    upgrade_view_parser

.. note::
    더 많은 업그레이드 가이드가 곧 출시됩니다.