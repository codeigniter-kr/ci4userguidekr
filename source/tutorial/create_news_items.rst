#################
Create news items
#################

You now know how you can read data from a database using CodeIgniter, but
you haven't written any information to the database yet. In this section
you'll expand your news controller and model created earlier to include
this functionality.
CodeIgniter를 사용하여 데이터베이스에서 데이터를 읽는 방법을 알았지 만 아직 데이터베이스에 정보를 쓰지 않았습니다. 이 섹션에서는 이전에 만든 뉴스 컨트롤러와 모델을 확장하여이 기능을 포함합니다.

.. note:: This section of the tutorial cannot be completed as certain
    portions of the framework, like the form helper and the validation
    library have not been completed yet.
    양식 도우미 및 유효성 검증 라이브러리와 같은 프레임 워크의 특정 부분이 아직 완료되지 않았으므로이 자습서의 섹션을 완료 할 수 없습니다.

Create a form
-------------

To input data into the database you need to create a form where you can
input the information to be stored. This means you'll be needing a form
with two fields, one for the title and one for the text. You'll derive
the slug from our title in the model. Create the new view at
*application/Views/news/create.php*.
데이터베이스에 데이터를 입력하려면 저장할 정보를 입력 할 수있는 양식을 만들어야합니다. 즉 제목과 텍스트 중 하나에 두 개의 필드가있는 양식이 필요합니다. 모델의 제목에서 슬러그를 유도합니다. application / Views / news / create.php 에서 새보기를 만듭니다 .

::

    <h2><?= esc($title); ?></h2>

    <?= validation_errors(); ?>

    <?= form_open('news/create'); ?>

        <label for="title">Title</label>
        <input type="input" name="title" /><br />

        <label for="text">Text</label>
        <textarea name="text"></textarea><br />

        <input type="submit" name="submit" value="Create news item" />

    </form>

There are only two things here that probably look unfamiliar to you: the
``form_open()`` function and the ``validation_errors()`` function.
아마도 당신에게 익숙하지 않은 두 가지, 즉 form_open()기능과 validation_errors()기능 만 있습니다.

The first function is provided by the :doc:`form
helper <../helpers/form_helper>` and renders the form element and
adds extra functionality, like adding a hidden :doc:`CSRF prevention
field <../libraries/security>`. The latter is used to report
errors related to form validation.
첫 번째 기능은 양식 도우미에 의해 제공되며 양식 요소를 렌더링하고 숨겨진 CSRF 방지 필드 추가와 같은 추가 기능을 추가 합니다 . 후자는 양식 유효성 검사와 관련된 오류를보고하는 데 사용됩니다.

Go back to your news controller. You're going to do two things here,
check whether the form was submitted and whether the submitted data
passed the validation rules. You'll use the :doc:`form
validation <../libraries/validation>` library to do this.
뉴스 컨트롤러로 돌아가십시오. 양식을 제출했는지 여부와 제출 된 데이터가 유효성 검사 규칙을 통과했는지 여부를 확인하려면 여기에서 두 가지 작업을 수행해야합니다. 이 작업을 수행 하려면 양식 유효성 검사 라이브러리를 사용하십시오 .

::

    public function create()
    {
        helper('form');
        $model = new NewsModel();

        if (! $this->validate($this->request, [
            'title' => 'required|min[3]|max[255]',
            'text'  => 'required'
        ]))
        {
            echo view('templates/header', ['title' => 'Create a news item']);
            echo view('news/create');
            echo view('templates/footer');

        }
        else
        {
            $model->save([
                'title' => $this->request->getVar('title'),
                'slug'  => url_title($this->request->getVar('title')),
                'text'  => $this->request->getVar('text'),
            ]);
            echo view('news/success');
        }
    }

The code above adds a lot of functionality. The first few lines load the
form helper and the NewsModel. After that, the Controller-provided helper
function is used to validate the $_POST fields. In this case the title and
text fields are required.
위의 코드는 많은 기능을 추가합니다. 처음 몇 줄은 양식 도우미와 NewsModel을로드합니다. 그런 다음 Controller 제공 헬퍼 함수를 사용하여 $ _POST 필드의 유효성을 검사합니다. 이 경우 제목과 텍스트 필드가 필요합니다.

CodeIgniter has a powerful validation library as demonstrated
above. You can read :doc:`more about this library
here <../libraries/validation>`.
CodeIgniter에는 위에서 설명한 강력한 유효성 검사 라이브러리가 있습니다. 당신이 읽을 수 있습니다 여기에이 라이브러리에 대한 자세한 .

Continuing down, you can see a condition that checks whether the form
validation ran successfully. If it did not, the form is displayed, if it
was submitted **and** passed all the rules, the model is called. This
takes care of passing the news item into the model.
This contains a new function, url\_title(). This function -
provided by the :doc:`URL helper <../helpers/url_helper>` - strips down
the string you pass it, replacing all spaces by dashes (-) and makes
sure everything is in lowercase characters. This leaves you with a nice
slug, perfect for creating URIs.
계속 진행하면 양식 유효성 검사가 성공적으로 실행되었는지 확인하는 조건을 볼 수 있습니다. 그렇지 않으면 양식이 표시되고 모든 규칙 이 제출 되고 전달되면 모델이 호출됩니다. 이렇게하면 뉴스 항목을 모델로 전달합니다. 여기에는 새로운 함수 url_title ()이 포함되어 있습니다. URL 도우미가 제공하는이 함수는 전달하는 문자열을 제거하고 모든 공백을 대시 (-)로 바꾸고 모든 것이 소문자로되어 있는지 확인합니다. 이렇게하면 멋진 슬러그가 만들어지며 URI 생성에 적합합니다.

After this, a view is loaded to display a success message. Create a view at
**application/Views/news/success.php** and write a success message.
이 후 뷰가로드되어 성공 메시지가 표시됩니다. application / Views / news / success.php 에서 뷰를 만들고 성공 메시지를 작성하십시오.

Model
-----

The only thing that remains is ensuring that your model is setup
to allow data to be saved properly. The ``save()`` method that was
used will determine whether the information should be inserted
or if the row already exists and should be updated, based on the presence
of a primary key. In this case, there is no ``id`` field passed to it,
so it will insert a new row into it's table, **news**.
남아있는 유일한 것은 데이터를 올바르게 저장할 수 있도록 모델이 설정되어 있는지 확인하는 것입니다. 사용 된 save()메소드는 정보가 삽입되어야하는지 또는 행이이 L 존재하고 기본 키가 있는지에 따라 갱신되어야하는지 여부를 판별합니다. 이 경우 id전달 된 필드 가 없으므로 테이블, 뉴스에 새 행을 삽입합니다 .

However, by default the insert and update methods in the model will
not actually save any data because it doesn't know what fields are
safe to be updated. Edit the model to provide it a list of updatable
fields in the ``$allowedFields`` property.
그러나 기본적으로 모델의 삽입 및 업데이트 메소드는 실제로 업데이트 할 필드가 무엇인지 모르기 때문에 데이터를 저장하지 않습니다. 모델을 편집하여 $allowedFields속성 의 업데이트 할 수있는 필드 목록을 제공하십시오 .

::

    <?php
    class NewsModel extends \CodeIgniter\Model
    {
        protected $table = 'news';

        protected $allowedFields = ['title', 'slug', 'text'];
    }

This new property now contains the fields that we allow to be saved to the
database. Notice that we leave out the ``id``? That's because you will almost
never need to do that, since it is an auto-incrementing field in the database.
This helps protect against Mass Assignment Vulnerabilities. If your model is
handling your timestamps, you would also leave those out.
이 새 속성에는 이제 데이터베이스에 저장할 수있는 필드가 포함됩니다. 우리가 밖으로 나가는 것에주의해라 id. 그것은 데이터베이스에서 자동으로 증가하는 필드이기 때문에 거의 그렇게 할 필요가 없기 때문입니다. 이렇게하면 대량 할당 취약점으로부터 보호 할 수 있습니다. 모델에서 타임 스탬프를 처리하는 경우 해당 타임 스탬프도 남겨 두십시오.

Routing
-------

Before you can start adding news items into your CodeIgniter application
you have to add an extra rule to *Config/Routes.php* file. Make sure your
file contains the following. This makes sure CodeIgniter sees 'create'
as a method instead of a news item's slug.
CodeIgniter 애플리케이션에 뉴스 항목을 추가하기 전에 Config / Routes.php 파일에 추가 규칙을 추가 해야 합니다. 파일에 다음 내용이 포함되어 있는지 확인하십시오. 이렇게하면 CodeIgniter는 뉴스 항목의 슬러그 대신 '생성'을 메서드로 간주합니다.

::

    $routes->post('news/create', 'News::create');
    $routes->add('news/(:segment)', 'News::view/$1');
    $routes->get('news', 'News::index');
    $routes->add('(:any)', 'Pages::view/$1');

Now point your browser to your local development environment where you
installed CodeIgniter and add index.php/news/create to the URL.
Congratulations, you just created your first CodeIgniter application!
Add some news and check out the different pages you made.
이제 CodeIgniter를 설치 한 로컬 개발 환경으로 브라우저를 가리키고 index.php / news / create를 URL에 추가하십시오. 첫 번째 CodeIgniter 애플리케이션을 만들었습니다. 뉴스를 추가하고 작성한 다른 페이지를 확인하십시오.