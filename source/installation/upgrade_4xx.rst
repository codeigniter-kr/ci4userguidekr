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

모든 CI3 라이브러리가 CI4용으로 포팅되거나 재 작성되지 않았습니다!
최신 목록은 `CodeIgniter 4 로드맵 <https://forum.codeigniter.com/forum-33.html>`_ 하위 포럼의 스레드를 참조하십시오!

프로젝트 변환을 시작하기 전에 **사용자 가이드를 읽어야 합니다**\ !

**Downloads**

- CI4는 사용 설명서('docs' 하위 폴더에 있음)가 포함된 즉시 실행 가능한 zip 또는 tarball로 계속 사용할 수 있습니다.
- Composer를 사용하여 설치할 수도 있습니다

**Namespaces**

- CI4는 PHP7.3+ 용으로 제작되었으며, 프레임워크의 모든 항목은 헬퍼를 제외하고 네임스페이스(namespace)가 지정됩니다.

**Application Structure**

- ``application`` 폴더의 이름이 ``app``\ 으로 바뀌고, 프레임워크에는 ``system`` 폴더가 있으며 이전과 동일하게 해석됩니다.
- 이제 프레임워크는 앱의 문서 루트로 사용되는 ``public`` 폴더를 제공합니다.
- 캐시 데이터, 로그 및 세션 데이터를 보관할 수있는 ``writable`` 폴더도 있습니다.
- ``app`` 폴더는 CI3의 ``application``\ 폴더와 매우 유사하지만, 이름이 일부 변경되고, 하위 폴더의 일부가 ``writable`` 폴더로 이동되었습니다.
- 프레임워크 구성 요소를 확장하는 메커니즘이 다르기 때문에 더 이상 중첩된 ``application/core`` 폴더는 없습니다 (아래 참조).

**Class loading**

- 더 이상 CodeIgniter "superobject"\ 가 없으며 프레임워크 컴포넌트 참조가 컨트롤러의 속성으로 마법처럼 주입됩니다.
- 필요한 경우 클래스를 인스턴스화되고 ``Services``\ 를 통해 컴포넌트를 관리합니다.
- 클래스 로더는 ``App`` (application) 과 ``CodeIgniter`` (예 : system) 최상위 네임스페이스 내에서 PSR4 스타일 클래스 찾기를 자동으로 처리합니다. 
  Composer 자동 로딩 지원하며, 네임스페이스가 지정되어 있지 않아도 올바른 폴더에 위치한 모델과 라이브러리를 찾을 수 있습니다.
- "HMVC" 스타일을 포함하여 가장 편한 어플리케이션 구조를 지원하도록 클래스 로딩을 구성할 수 있습니다.

**Controllers**

- 컨트롤러는 CI_Controller 대신 \\CodeIgniter\\Controller를 확장합니다.
- 사용자가 만드는 기본 컨트롤러의 일부가 아닌 경우 생성자를 더 이상 사용하지 않습니다. (CI "magic"을 호출).
- CI는 CI3-way보다 강력한 ``Request``\ 와 ``Response`` 개체를 제공합니다.
- 사용자 정의 기본 컨트롤러(CI3의 MY_Controller)를 원하는 경우, 원하는 위치에 BaseController를 확장한 컨트롤러를 작성합니다.

**Models**

- 모델은 CI_Model 대신 \\CodeIgniter\\Model을 확장합니다.
- CI4 모델에는 자동 데이터베이스 연결, 기본 CRUD, 모델내 유효성 검사 및 자동 페이지네이션을 포함한 훨씬 더 많은 기능이 있습니다.
- CI4에는 데이터베이스 테이블에 대한 풍부한 데이터 매핑을 위해 구축할 수 있는 ``Entity`` 클래스도 있습니다.
- CI3의 ``$this->load->model(x);`` 대신 구성 요소에 대한 네임스페이스 규칙에 따라 ``$this->x = new X();``\ 를 사용합니다.

**Views**

- 뷰는 이전과 비슷하지만 CI3의 ``$this->load->view(x);`` 대신 다르게 호출됩니다 . ``echo view(x);``
- CI4는 뷰 "셀"\ 을 지원하여 응답을 조각으로 만듭니다.
- 템플릿 파서가 여전히 있지만 대폭 향상되었습니다.

**Libraries**

- 앱 클래스는 여전히 ``app/Libraries`` 안에 있을 수 있지만 반드시 그럴 필요는 없습니다.
- CI3의 ``$this->load->library(x);`` 대신 구성 요소에 대한 네임스페이스 규칙에 따라 ``$this->x = new X();``\ 를 사용할 수 있습니다.

**Helpers**

- 헬퍼는 이전과 거의 동일하지만 일부는 단순화되었습니다.

**Events**

- 훅(Hook)은 이벤트로 대체 되었습니다.
- CI3의 ``$hook['post_controller_constructor']`` 대신 이제 네임스페이스가 ``CodeIgniter\Events\Events;``\ 인 ``Events::on('post_controller_constructor', ['MyClass', 'MyFunction']);``\ 를 사용합니다. 
- 이벤트는 항상 활성화되어 있으며 전역적으로 사용 가능합니다.

**Extending the framework**

- ``MY _...`` 프레임워크 구성 요소 확장 또는 대체를 위해 ``core`` 폴더가 필요하지 않습니다.
- CI4를 부분 확장하거나 교체하기 위해 라이브러리 폴더 내에 ``MY_x`` 클래스가 필요하지 않습니다.
- 원하는 위치에 필요한 클래스를 만들고 ``app/Config/Services.php``\ 에 적절한 서비스 메소드를 추가하면 기본 클래스 대신 새로운 컴포넌트를 로드합니다.