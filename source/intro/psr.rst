**************
PSR 준수
**************

`PHP-FIG <http://www.php-fig.org/>`_\ 는 인터페이스, 스타일 가이드 등을 승인하여 프레임워크간의 상호 운용성을 높이기 위해 2009년에 만들어졌으며, 회원들이 이를 자유롭게 구현할 수 있도록 하였습니다.
CodeIgniter는 FIG의 회원은 아니지만 여러 제안과 호환됩니다.
이 안내서는 승인된 다양한 제안과 일부 초안을 준수하는지 여부를 명시하기 위한 것입니다.

**PSR-1: Basic Coding Standard**

이 권장 사항에는 기본 클래스, 메서드 및 파일 이름 지정 표준이 포함됩니다. 
저희의 `스타일 가이드 <https://github.com/codeigniter4/CodeIgniter4/blob/develop/contributing/styleguide.md>`_\ 는 PSR-1을 충족하고 그 위에 자체 요구 사항을 추가합니다.

**PSR-12: Extended Coding Style**

우리의 `style guide <https://github.com/codeigniter4/CodeIgniter4/blob/develop/contributing/styleguide.md>`_\ 는 권장 사항과 더불어 자체 스타일링 컨벤션 세트를 따르고 있습니다.

**PSR-3: Logger Interface**

CodeIgniter의 :doc:`Logger </general/logging>` 는 이 PSR에서 제공하는 모든 인터페이스를 구현합니다.

**PSR-4: Autoloading Standard**

이 PSR은 파일과 네임스페이스를 구성하여 표준 자동로드 클래스 방법을 허용하는 방법을 제공합니다.
우리의 :doc:`Autoloader </concepts/autoloader>`\ 는 PSR-4 권장 사항을 충족합니다.

**PSR-6: Caching Interfaces**
**PSR-16: SimpleCache Interface**

프레임워크 캐시 구성요소는 PSR-6 또는 PSR-16을 준수하지 않지만, CodeIgniter4 조직에서는 별도의 어댑터 집합을 보조 모듈로 사용할 수 있습니다.
어댑터는 타사 라이브러리와의 호환성만을 위한것이므로 프로젝트는 기본 캐시 드라이버를 직접 사용하는 것이 좋습니다.
자세한 내용은 `CodeIgniter4 Cache repo <https://github.com/codeigniter4/cache>`_\ 를 참조하십시오.

**PSR-7: HTTP Message Interface**

이 PSR은 HTTP 상호 작용을 나타내는 방법을 표준화합니다. 
많은 개념들이 우리의 HTTP 계층의 일부가 되었지만, CodeIgniter는 이 권고사항과의 호환성을 위해 노력하지 않습니다.

---

PSR을 충족한다고 주장하고 있지만, PSR을 올바르게 실행하지 못한 부분을 발견하였다면 저희에게 알려주십시오. 
수정을 요청하거나 필요한 변경 사항이있는 풀 리퀘스트(pull request)를 제출하십시오.