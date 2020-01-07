**************
PSR 준수
**************

`PHP-FIG <http://www.php-fig.org/>`_\ 는 인터페이스, 스타일 가이드 등을 승인하여 프레임워크간의 상호 운용성을 높이기 위해 2009년에 만들어졌으며, 회원들이 이를 자유롭게 구현할 수 있도록 하였습니다.
CodeIgniter는 FIG의 회원은 아니지만 여러 제안과 호환됩니다.
이 안내서는 승인된 다양한 제안과 일부 초안을 준수하는지 여부를 명시하기 위한 것입니다.

**PSR-1: Basic Coding Standard**

이 권장 사항에는 기본 클래스, 메서드 및 파일 이름 지정 표준이 포함됩니다. 
저희의 `스타일 가이드 https://github.com/codeigniter4/CodeIgniter4/blob/develop/contributing/styleguide.rst`\ 는 PSR-1을 충족하고 그 위에 자체 요구 사항을 추가합니다.

**PSR-2: Coding Style Guide**

이 PSR은 처음 나왔을 때 상당히 논란이 많았습니다. 
CodeIgniter는 많은 권장 사항을 충족하지만 모든 권장 사항을 충족하지는 않습니다.

**PSR-3: Logger Interface**

CodeIgniter의 :doc:`Logger </general/logging>` 는 이 PSR에서 제공하는 모든 인터페이스를 구현합니다.

**PSR-4: Autoloading Standard**

이 PSR은 파일과 네임스페이스를 구성하여 표준 자동로드 클래스 방법을 허용하는 방법을 제공합니다.
우리의 :doc:`Autoloader </concepts/autoloader>`\ 는 PSR-4 권장 사항을 충족합니다.

**PSR-6: Caching Interface**

CodeIgniter는 PSR을 충족시키려 하지 않을 것입니다. 
PSR은 필요 이상으로 발전한다고 믿습니다.
새로 제안된 `SimpleCache Interfaces <https://github.com/dragoonis/fig-standards/blob/psr-simplecache/proposed/simplecache.md>`_\ 는 우리가 고려할 만한 것으로 보입니다.

**PSR-7: HTTP Message Interface**

이 PSR은 HTTP 상호 작용을 나타내는 방법을 표준화합니다. 
많은 개념들이 우리의 HTTP 계층의 일부가 되었지만, CodeIgniter는 이 권고사항과의 호환성을 위해 노력하지 않습니다.

---

PSR을 충족한다고 주장하고 있지만, PSR을 올바르게 실행하지 못한 부분을 발견하였다면 저희에게 알려주십시오. 
수정을 요청하거나 필요한 변경 사항이있는 풀 리퀘스트(pull request)를 제출하십시오.