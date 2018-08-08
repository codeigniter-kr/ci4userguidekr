##########
View Cells
##########

View Cells allow you to insert HTML that is generated outside of your controller. It simply calls the specified
class and method, which must return a string of valid HTML. This method could be in any callable method, found in any class
that the autoloader can locate. The only restriction is that the class can not have any constructor parameters.
This is intended to be used within views, and is a great aid to modularizing your code.
셀보기를 사용하면 컨트롤러 외부에서 생성 된 HTML을 삽입 할 수 있습니다. 유효한 HTML 문자열을 반환해야하는 지정된 클래스와 메서드를 호출하기 만하면됩니다. 이 메소드는 자동 로더가 찾을 수있는 모든 클래스에서 찾을 수있는 호출 가능 메소드에있을 수 있습니다. 유일한 제한은 클래스가 생성자 매개 변수를 가질 수 없다는 것입니다. 이는 뷰 내에서 사용하기위한 것이며 코드를 모듈화하는 데 큰 도움이됩니다.

::

    <?= view_cell('\App\Libraries\Blog::recentPosts') ?>

In this example, the class ``App\Libraries\Blog`` is loaded, and the method ``recentPosts()`` is run. The method
must return the generated HTML as a string. The method can be either a static method or not. Either way works.
이 예제에서는 클래스 App\Libraries\Blog가로드되고 메서드 recentPosts()가 실행됩니다. 메서드는 생성 된 HTML을 문자열로 반환해야합니다. 이 방법은 정적 방법 일 수도 있고 그렇지 않을 수도 있습니다. 어느 쪽이든 작동합니다.

Cell Parameters
---------------

You can further refine the call by passing a list of parameters in the second parameter to the method. The values passed 
can be an array of key/value pairs, or a comma-separated string of key/value pairs
메서드에 두 번째 매개 변수의 매개 변수 목록을 전달하여 호출을 더 구체화 할 수 있습니다. 전달 된 값은 키 / 값 쌍의 배열이거나 키 / 값 쌍의 쉼표로 구분 된 문자열 일 수 있습니다.

::

    // Passing Parameter Array
    <?= view_cell('\App\Libraries\Blog::recentPosts', ['category' => 'codeigniter', 'limit' => 5]) ?>

    // Passing Parameter String
    <?= view_cell('\App\Libraries\Blog::recentPosts', 'category=codeigniter, limit=5') ?>

    public function recentPosts(array $params=[])
    {
        $posts = $this->blogModel->where('category', $params['category'])
                                 ->orderBy('published_on', 'desc')
                                 ->limit($params['limit'])
                                 ->get();

        return view('recentPosts', ['posts' => $posts]);
    }

Additionally, you can use parameter names that match the parameter variables in the method for better readability.
When you use it this way, all of the parameters must always be specified in the view cell call
또한 메서드의 매개 변수 변수와 일치하는 매개 변수 이름을 사용하여 가독성을 높일 수 있습니다. 이 방법을 사용하면 모든 매개 변수가 항상 뷰 셀 호출에 지정되어야합니다.

::

    <?= view_cell('\App\Libraries\Blog::recentPosts', 'category=codeigniter, limit=5') ?>

    public function recentPosts(int $limit, string $category)
    {
        $posts = $this->blogModel->where('category', $category)
                                 ->orderBy('published_on', 'desc')
                                 ->limit($limit)
                                 ->get();

        return view('recentPosts', ['posts' => $posts]);
    }

Cell Caching
------------

You can cache the results of the view cell call by passing the number of seconds to cache the data for as the
third parameter. This will use the currently configured cache engine.
세 번째 매개 변수로 데이터를 캐시하는 데 걸리는 시간 (초)을 전달하여 뷰 셀 호출의 결과를 캐시 할 수 있습니다. 현재 구성된 캐시 엔진을 사용합니다.

::

    // Cache the view for 5 minutes
    <?= view_cell('\App\Libraries\Blog::recentPosts', 'limit=5', 300) ?>

You can provide a custom name to use instead of the auto-generated one if you like, by passing the new name
as the fourth parameter
새 이름을 네 번째 매개 변수로 전달하여 원하는 경우 자동 생성 된 이름 대신 사용할 사용자 정의 이름을 제공 할 수 있습니다.

::

    // Cache the view for 5 minutes
    <?= view_cell('\App\Libraries\Blog::recentPosts', 'limit=5', 300, 'newcacheid') ?>
