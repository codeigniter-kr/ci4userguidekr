#############################
페이지네이션(Pagination)
#############################

CodeIgniter는 간단한 테마와 모델과 함께 작동하며, 단일 페이지에서 여러 페이지네이션(Pagination)을 지원할 수있는 매우 단순하지만 유연한 페이지네이션 라이브러리를 제공합니다.

*******************
라이브러리 로드
*******************

CodeIgniter의 다른 서비스와 마찬가지로 ``Config\Services``\ 를 통해 로드할 수 있지만, 수동으로 로드할 필요는 없습니다.

::

    $pager = \Config\Services::pager();

********************************
데이터베이스 결과 페이지네이션
********************************

대부분의 경우 데이터베이스에서 검색한 결과를 페이지 매기기 위해 Pager 라이브러리를 사용하게 됩니다.
:doc:`모델 </models/model>` 클래스를 사용할 때 내장 된 ``paginate()`` 메소드를 사용하여 현재 배치 결과를 자동으로 검색하고 Pager 라이브러리를 컨트롤러에서 사용할 수 있도록 설정합니다.
``page=X`` 쿼리 변수를 통해 현재 URL에서 표시해야 하는 현재 페이지를 읽습니다.

애플리케이션에서 페이지네이션된 사용자 목록을 제공하기 위한 컨트롤러의 메소드는 다음과 같습니다.

::

    <?php namespace App\Controllers;

    use CodeIgniter\Controller;

    class UserController extends Controller
    {
        public function index()
        {
            $model = new \App\Models\UserModel();

            $data = [
                'users' => $model->paginate(10),
                'pager' => $model->pager
            ];

            echo view('users/index', $data);
        }
    }

먼저 UserModel의 새 인스턴스를 만듭니다. 
그런 다음 뷰로 전송할 데이터를 채웁니다.
첫 번째 요소는 데이터베이스 **users**\ 의 결과이며 올바른 페이지를 검색하여 페이지 당 10명의 사용자를 리턴합니다.
뷰로 보내야하는 두 번째 항목은 Pager 인스턴스 자체입니다.
편의상 Model은 사용된 인스턴스를 유지하고 이를 공용 클래스 변수 **$pager**\ 에 저장합니다.
그래서 우리는 Pager 인스턴스를 뷰의 $pager 변수에 할당합니다.

뷰에서 링크를 표시합니다.

::

    <?= $pager->links() ?>

이것이 전부입니다. Pager 클래스는 첫 페이지와 마지막 페이지 링크와 현재 페이지의 양쪽에 두 페이지 이상의 페이지에 대한 다음 및 이전 링크를 렌더링합니다.

더 간단한 출력을 선호하는 경우 세부 정보 페이지 링크 대신 "Older"와 "Newer" 링크만 사용하는 ``simpleLinks()`` 메서드를 사용할 수 있습니다

::

    <?= $pager->simpleLinks() ?>

라이브러리의 링크 형식을 결정하는 뷰 파일을 로드하여 필요에 따라 간단하게 수정할 수 있습니다.
출력을 완전히 사용자 정의하는 방법에 대한 자세한 내용은 아래를 참조하십시오.

여러 결과 페이지네이션
===========================

서로 다른 두 개의 결과 집합에서 링크를 제공해야 하는 경우 그룹 이름 페이지네이션 메소드에 전달하여 데이터를 별도로 유지할 수 있습니다

::

    // In the Controller
    public function index()
    {
        $userModel = new \App\Models\UserModel();
        $pageModel = new \App\Models\PageModel();

        $data = [
            'users' => $userModel->paginate(10, 'group1'),
            'pages' => $pageModel->paginate(15, 'group2'),
            'pager' => $userModel->pager
        ];

        echo view('users/index', $data);
    }

    // In the views:
    <?= $pager->links('group1') ?>
    <?= $pager->simpleLinks('group2') ?>

수동 페이지네이션
====================

알려진 데이터를 기반으로 페이지네이션을 만들어야 하는 경우가 있습니다.
현재 페이지, 페이지당 결과 수 및 총 항목 수를 각각 첫 번째, 두 번째 및 세 번째 매개 변수로 사용하는 ``makeLinks()`` 메소드를 사용하여 링크를 수동으로 작성할 수 있습니다.

::

    <?= $pager->makeLinks($page, $perPage, $total) ?>

기본적으로 링크는 일반적인 방식으로 일련의 링크를 표시하지만, 템플릿을 네 번째 매개 변수로 전달하여 페이지네이션에 사용되는 템플릿를 변경할 수 있습니다.
자세한 내용은 다음 섹션에서 확인할 수 있습니다.

::

    <?= $pager->makeLinks($page, $perPage, $total, 'template_name') ?>

페이지 쿼리 매개 변수 대신 페이지 번호에 URI 세그먼트를 사용할 수 있습니다. 
``makeLinks()``\ 의 다섯 번째 매개 변수로 사용할 세그먼트 번호를 지정하십시오. 
Pager에 의해 생성된 URI는 ``https://domain.tld/model?page=[pageNumber]`` 대신 ``https://domain.tld/model/[pageNumber]``\ 처럼 보입니다.

::

    <?= $pager->makeLinks($page, $perPage, $total, 'template_name', $segment) ?>

.. note:: ``$segment`` 값은 URI 세그먼트 수에 1을 더한 값보다 클 수 없습니다.

한 페이지에 많은 Pager를 표시해야 하는 경우 그룹을 정의하는 추가 매개 변수가 도움됩니다.

::

	$pager = service('pager');
	$pager->setPath('path/for/my-group', 'my-group'); // Additionally you could define path for every group.
	$pager->makeLinks($page, $perPage, $total, 'template_name', $segment, 'my-group'); 

예상 쿼리만으로 페이지네이션
=====================================

기본적으로 모든 GET 쿼리는 페이지네이션 링크에 표시됩니다.

예를 들어 URL ``http://domain.tld?search=foo&order=asc&hello=i+am+here&page=2``\ 에 액세스할 때 다음과 같이 다른 링크와 함께 페이지 3의 링크를 생성할 수 있습니다.

::

    echo $pager->links();
    // Page 3 link: http://domain.tld?search=foo&order=asc&hello=i+am+here&page=3

``only()`` 메소드는 이미 예상한 쿼리로만 이것을 제한할 수 있습니다

::

    echo $pager->only(['search', 'order'])->links();
    // Page 3 link: http://domain.tld?search=foo&order=asc&page=3

*page* 쿼리는 기본적으로 활성화되어 있으며, ``only()``\ 는 모든 페이지네이션 링크에서 작동합니다.

*********************
링크 사용자 정의
*********************

뷰 구성
==================

링크가 페이지에 렌더링되면 뷰 파일을 사용하여 HTML을 표시합니다. 
**app/Config/Pager.php**\ 를 편집하여 사용되는 뷰를 쉽게 변경할 수 있습니다

::

    public $templates = [
        'default_full'   => 'CodeIgniter\Pager\Views\default_full',
        'default_simple' => 'CodeIgniter\Pager\Views\default_simple'
    ];

이 설정은 사용해야 하는 뷰의 별명과 :doc:`네임스페이스 뷰 경로 </outgoing/views>`\ 를 저장합니다.
``default_full`` 과 ``default_simple`` 뷰는 각각 ``links()`` 와 ``simpleLinks()`` 메소드에서 사용됩니다.
애플리케이션 전체에 표시되는 방식을 변경하려면 여기에 새로운 뷰를 할당하십시오.

예를 들어 Foundation CSS 프레임워크에서 작동하는 새로운 뷰 파일을 작성하고 해당 파일을 **app/Views/Pagers/foundation_full.php**\ 에 저장한다고 가정하십시오.

**application** 디렉토리는 네임스페이스가 ``App``\ 이고 그 아래의 모든 디렉토리는 네임스페이스의 세그먼트에 직접 맵핑되므로 네임스페이스를 통해 뷰 파일을 다음과 같이 찾을 수 있습니다.

::

    'default_full'   => 'App\Views\Pagers\foundation_full',

표준 **app/Views** 디렉토리에 있기 때문에 ``view()`` 메소드가 파일 이름으로 찾을 수 있으므로, 네임스페이스를 지정할 필요가 없이, 하위 디렉토리와 파일 이름을 간단히 지정할 수 있습니다.

::

    'default_full'   => 'Pagers/foundation_full',

뷰를 작성하고 구성에서 설정하면 자동으로 사용됩니다.
기존 템플릿을 교체하지 않아도 됩니다. 
구성 파일에 필요한만큼 추가 템플릿을 만들 수 있습니다.
일반적인 상황에서 애플리케이션의 프런트 엔드와 백엔드에 서로 다른 스타일이 필요합니다.

::

    public $templates = [
        'default_full'   => 'CodeIgniter\Pager\Views\default_full',
        'default_simple' => 'CodeIgniter\Pager\Views\default_simple',
        'front_full'     => 'App\Views\Pagers\foundation_full',
    ];

일단 구성되면 ``links()``, ``simpleLinks()``, ``makeLinks()`` 메소드의 마지막 매개 변수로 지정할 수 있습니다

::

    <?= $pager->links('group1', 'front_full') ?>
    <?= $pager->simpleLinks('group2', 'front_full') ?>
    <?= $pager->makeLinks($page, $perPage, $total, 'front_full') ?>

뷰 생성
=================

새로운 뷸를 작성할 때 페이지네이션 링크 자체를 작성하는데 필요한 코드만 작성하면 됩니다.
불필요한 줄 바꿈 div는 여러 곳에서 사용의 유용성을 제한하기 때문에 만들지 않아야 합니다.
기존 ``default_full`` 템플릿를 복사하여 새로운 뷰를 작성하는 것이 가장 쉽습니다.

::

    <?php $pager->setSurroundCount(2) ?>

    <nav aria-label="Page navigation">
        <ul class="pagination">
        <?php if ($pager->hasPrevious()) : ?>
            <li>
                <a href="<?= $pager->getFirst() ?>" aria-label="First">
                    <span aria-hidden="true">First</span>
                </a>
            </li>
            <li>
                <a href="<?= $pager->getPrevious() ?>" aria-label="Previous">
                    <span aria-hidden="true">&laquo;</span>
                </a>
            </li>
        <?php endif ?>

        <?php foreach ($pager->links() as $link) : ?>
            <li <?= $link['active'] ? 'class="active"' : '' ?>>
                <a href="<?= $link['uri'] ?>">
                    <?= $link['title'] ?>
                </a>
            </li>
        <?php endforeach ?>

        <?php if ($pager->hasNext()) : ?>
            <li>
                <a href="<?= $pager->getNext() ?>" aria-label="Previous">
                    <span aria-hidden="true">&raquo;</span>
                </a>
            </li>
            <li>
                <a href="<?= $pager->getLast() ?>" aria-label="Last">
                    <span aria-hidden="true">Last</span>
                </a>
            </li>
        <?php endif ?>
        </ul>
    </nav>

**setSurroundCount()**

첫 번째 줄의 ``setSurroundCount()`` 메소드는 현재 페이지 링크의 양쪽에 두 개의 링크를 표시할 것을 지정합니다.
허용되는 단일 매개 변수는 표시할 링크 수입니다.

**hasPrevious()** & **hasNext()**

이 두개의 메소드는 ``setSurroundCount``\ 에 전달된 값을 기준으로 현재 페이지의 양쪽에 표시할 수 있는 링크가 더 있으면 부울 true를 리턴합니다. 
예를 들어 20 페이지의 데이터가 있다고 가정해 봅시다.
현재 페이지는 3 페이지입니다. 
주변 수가 2이면 다음 링크가 목록에 나타납니다 : 1, 2, 3, 4, 5
표시되는 첫 번째 링크는 1 페이지이므로 ``hasPrevious()``\ 는 페이지 0이 없기 때문에 **false**\ 를 반환합니다.
그러나 ``hasNext()``\ 는 5 페이지 이후 15개의 추가 결과 페이지가 있으므로 **true**\ 를 반환합니다.

**getPrevious()** & **getNext()**

이 메소드는 번호가 매겨진 링크의 양쪽에 이전 또는 다음 결과 페이지의 URL을 리턴합니다.
자세한 설명은 이전 단락을 참조하십시오.

**getFirst()** & **getLast()**

``getPrevious()``, ``getNext()``\ 와 마찬가지로 첫 페이지와 마지막 페이지에 대한 링크를 리턴합니다.

**links()**

번호가 매겨진 모든 링크에 대한 데이터 배열을 반환합니다.
각 링크의 배열에는 링크의 URI, 제목, 숫자 및 링크가 현재/활성 링크인지 여부를 나타내는 부울(bool)이 포함됩니다.

::

	$link = [
		'active' => false,
		'uri'    => 'http://example.com/foo?page=2',
		'title'  => 1
	];
