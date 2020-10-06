################
뷰 셀(View Cell)
################

뷰 셀을 사용하면 컨트롤러 외부에서 생성된 HTML을 삽입할 수 있습니다.
지정된 클래스와 메소드를 호출하기 때문에 유효한 HTML 문자열을 리턴해야 합니다.
오토로더가 찾을 수 있는 모든 클래스를 이 메소드를 사용하여 호출 가능합니다.
유일한 제한 사항은 클래스가 생성자 매개 변수를 가질 수 없다는 것입니다.
뷰 셀은 뷰 내에서 사용하기 위한 것이며 코드를 모듈화하는데 큰 도움이 됩니다.

::

    <?= view_cell('\App\Libraries\Blog::recentPosts') ?>

이 예제에서는 ``App\Libraries\Blog`` 클래스가 로드되고 ``recentPosts()`` 메소드가 실행됩니다.
메소드는 HTML을 문자열로 리턴해야합니다.
메소드는 정적 메소드(static method) 여부에 상관없이 실행됩니다.

셀 매개 변수
---------------

뷰 셀의 두 번째 매개 변수에 매개 변수 목록을 전달하여 메소드 호출을 세분화할 수 있습니다.
전달된 값은 키/값 쌍의 배열이거나 쉼표로 구분된 키/값 쌍의 문자열일 수 있습니다.

::

    // Passing Parameter Array
    <?= view_cell('\App\Libraries\Blog::recentPosts', ['category' => 'codeigniter', 'limit' => 5]) ?>

    // Passing Parameter String
    <?= view_cell('\App\Libraries\Blog::recentPosts', 'category=codeigniter, limit=5') ?>

    public function recentPosts(array $params = [])
    {
        $posts = $this->blogModel->where('category', $params['category'])
                                 ->orderBy('published_on', 'desc')
                                 ->limit($params['limit'])
                                 ->get();

        return view('recentPosts', ['posts' => $posts]);
    }

또한 가독성을 높이기 위해 메소드의 매개 변수와 일치하는 매개 변수 이름을 사용할 수 있습니다.
이 방법으로 사용하는 경우 모든 매개 변수는 항상 뷰 셀 호출에서 지정해야합니다.

::

    <?= view_cell('\App\Libraries\Blog::recentPosts', 'category=codeigniter, limit=5') ?>

    public function recentPosts(string $category, int $limit)
    {
        $posts = $this->blogModel->where('category', $category)
                                 ->orderBy('published_on', 'desc')
                                 ->limit($limit)
                                 ->get();

        return view('recentPosts', ['posts' => $posts]);
    }

셀 캐싱(Caching)
---------------------

뷰 셀의 세 번째 매개 변수로 캐싱 시간(초)을 전달하여 뷰 셀 호출 결과를 캐시(cache)할 수 있습니다.
구성(Config)에 정의된 캐시 엔진을 사용합니다.

::

    // Cache the view for 5 minutes
    <?= view_cell('\App\Libraries\Blog::recentPosts', 'limit=5', 300) ?>

뷰 셀의 네 번째 매개 변수로 자동 생성 이름 대신 사용자 지정 이름을 제공할 수 있습니다.

::

    // Cache the view for 5 minutes
    <?= view_cell('\App\Libraries\Blog::recentPosts', 'limit=5', 300, 'newcacheid') ?>
