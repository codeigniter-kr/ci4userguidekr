##############################
Models, Views, and Controllers
##############################

Whenever you create an application, you have to find a way to organize the code to make it simple to locate
the proper files and make it simple to maintain. Like most of the web frameworks, CodeIgniter uses the Model,
View, Controller (MVC) pattern to organize the files. This keeps the data, the presentation, and flow through the
application as separate parts. It should be noted that there are many views on the exact roles of each element,
but this document describes our take on it. If you think of it differently, you're free to modify how you use
each piece as you need.
응용 프로그램을 만들 때마다 코드를 구성하여 적절한 파일을 찾고 유지 관리하기 쉽게 만드는 방법을 찾아야합니다. 대부분의 웹 프레임 워크와 마찬가지로 CodeIgniter는 Model, View, Controller (MVC) 패턴을 사용하여 파일을 구성합니다. 이렇게하면 응용 프로그램을 통해 데이터, 프리젠 테이션 및 플로우가 별도의 파트로 유지됩니다. 각 요소의 정확한 역할에 대한 많은 견해가 있지만,이 문서는 우리가 취하는 것을 설명합니다. 다르게 생각하면 필요에 따라 각 조각을 사용하는 방법을 자유롭게 수정할 수 있습니다.

**Models** manage the data of the application, and help to enforce any special business rules the application might need.
모델 은 응용 프로그램의 데이터를 관리하고 응용 프로그램에 필요할 수있는 특수한 비즈니스 규칙을 적용하는 데 도움을줍니다.

**Views** are simple files, with little to no logic, that display the information to the user.
뷰 는 사용자에게 정보를 표시하는 로직이 거의없는 단순한 파일입니다.

**Controllers** act as glue code, marshaling data back and forth between the view (or the user that's seeing it) and
the data storage.
컨트롤러 는 글루 코드 (glue code) 역할을하여 뷰 (또는 뷰잉하는 사용자)와 데이터 저장소간에 데이터를 마샬링합니다.

At their most basic, controllers and models are simply classes that have a specific job. They are not the only class
types that you can use, obviously, but the make up the core of how this framework is designed to be used. They even
have designated directories in the **/application** directory for their storage, though you're free to store them
wherever you desire, as long as they are properly namespaced. We will discuss that in more detail below.
가장 기본적인 컨트롤러와 모델은 특정 작업을 수행하는 클래스입니다. 분명히 사용할 수있는 유일한 클래스 유형은 아니지만이 프레임 워크가 어떻게 사용되도록 설계되었는지 핵심을 구성합니다. 심지어 / application 디렉토리에 자신의 스토리지를위한 디렉토리를 지정해 두었습니다. 네임 스페이스가 적절히 설정되어 있으면 원하는 위치에 자유롭게 저장할 수 있습니다. 아래에서 더 자세히 논의 할 것입니다.

Let's take a closer look at each of these three main components.
이 세 가지 주요 구성 요소 각각에 대해 자세히 살펴 보겠습니다.

**************
The Components
**************

Views
=====

Views are the simplest files and are typically HTML with very small amounts of PHP. The PHP should be very simple,
usually just displaying a variable's contents, or looping over some items and displaying their information in a table.
뷰는 가장 단순한 파일이며 일반적으로 매우 적은 양의 PHP가 포함 된 HTML입니다. PHP는 매우 간단해야합니다. 대개 변수의 내용을 표시하거나 일부 항목을 반복하고 테이블에 정보를 표시해야합니다.

Views get the data to display from the controllers, who pass it to the views as variables that can be displayed
with simple ``echo`` calls. You can also display other views within a view, making it pretty simple to display a
common header or footer on every page.
뷰는 컨트롤러에서 표시 할 데이터를 가져오고 간단한 echo호출 로 표시 할 수있는 변수로 뷰에 전달 합니다. 또한보기 내에서 다른보기를 표시 할 수 있으므로 모든 페이지에 공통 머리글이나 바닥 글을 표시하는 것이 매우 쉽습니다.

Views are generally stored in **/application/Views**, but can quickly become unwieldy if not organized in some fashion.
CodeIgniter does not enforce any type of organization, but a good rule of thumb would be to create a new directory in
the **Views** directory for each controller. Then, name views by the method name. This makes them very easy find later
on. For example, a user's profile might be displayed in a controller named ``User``, and a method named ``profile``.
You might store the view file for this method in **/application/Views/User/Profile.php**.
뷰는 일반적으로 / application / Views에 저장 되지만 일부 방식으로 구성되지 않으면 다루기 힘들어 질 수 있습니다. CodeIgniter는 어떤 유형의 조직도 시행하지 않지만, 각 컨트롤러 의 Views 디렉토리에 새로운 디렉토리를 생성하는 것이 좋습니다 . 그런 다음 메소드 이름별로 뷰의 이름을 지정하십시오. 이렇게하면 나중에 쉽게 찾을 수 있습니다. 예를 들어, 사용자 프로파일은 이름이 지정된 제어기 User와 이름 지정된 메소드에 표시 될 수 있습니다 profile. 이 메소드에 대한 뷰 파일을 /application/Views/User/Profile.php에 저장할 수 있습니다 .

That type of organization works great as a base habit to get into. At times you might need to organize it differently.
That's not a problem. As long as CodeIgniter can find the file, it can display it.
그런 유형의 조직은 기본적인 습관으로 잘 작동합니다. 때로는 다르게 구성해야 할 수도 있습니다. 그건 문제가되지 않습니다. CodeIgniter가 파일을 찾을 수있는 한, 파일을 표시 할 수 있습니다.

:doc:`Find out more about views </general/views>`
보기에 대해 자세히 알아보기

Models
======

A model's job is to maintain a single type of data for the application. This might be users, blog posts, transactions, etc.
In this case, the model's job has two parts: enforce business rules on the data as it is pulled from, or put into, the
database; and handle the actual saving and retrieval of the data from the database.
모델의 임무는 응용 프로그램에 대한 단일 유형의 데이터를 유지하는 것입니다. 이 경우 사용자 모델, 블로그 게시물, 트랜잭션 등이 될 수 있습니다.이 경우 모델의 작업은 두 부분으로 구성됩니다. 데이터베이스에서 가져 오거나 데이터베이스에 넣을 때 비즈니스 규칙을 적용합니다. 데이터베이스에서 데이터의 실제 저장 및 검색을 처리 할 수 있습니다.

For many developers, the confusion comes in when determining what business rules are enforced. It simply means that
any restrictions or requirements on the data is handled by the model. This might include normalizing raw data before
it's saved to meet company standards, or formatting a column in a certain way before handing it to the controller.
By keeping these business requirements in the model, you won't repeat code throughout several controllers and accidentally
miss updating an area.
많은 개발자들에게 적용되는 비즈니스 규칙을 결정할 때 혼란이 따릅니다. 이는 단순히 데이터에 대한 제한이나 요구 사항이 모델에 의해 처리된다는 것을 의미합니다. 여기에는 원시 데이터를 회사 표준에 맞게 저장하기 전에 정규화하거나 컨트롤러에 데이터를 전달하기 전에 특정 방식으로 열을 포맷하는 작업이 포함될 수 있습니다. 이러한 비즈니스 요구 사항을 모델에 유지함으로써 여러 컨트롤러에서 코드를 반복하지 않고 우연히 영역을 업데이트하지 않게됩니다.

Models are typically stored in **/application/Models**, though they can use a namespace to be grouped however you need.
모델은 전형적으로 / application / Models에 저장 됩니다. 그러나 필요한 경우 네임 스페이스를 그룹화하여 사용할 수 있습니다.

:doc:`Find out more about models </database/model>`
모델에 대해 자세히 알아보기

Controllers
===========

Controllers have a couple of different roles to play. The most obvious one is that they receive input from the user and
then determine what to do with it. This often involves passing the data to a model to save it, or requesting data from
the model that is then passed on to the view to be displayed. This also includes loading up other utility classes,
if needed, to handle specialized tasks that is outside of the purview of the model.
컨트롤러는 서로 다른 두 가지 역할을 수행합니다. 가장 확실한 것은 사용자로부터 사용자 입력을 수신 한 다음 사용자가이를 어떻게 처리할지 결정하는 것입니다. 여기에는 종종 모델에 데이터를 전달하여 모델을 저장하거나 모델에서 데이터를 요청한 다음 표시 할 뷰로 전달합니다. 여기에는 모델의 범위를 벗어난 특수한 작업을 처리하기 위해 필요한 경우 다른 유틸리티 클래스를로드하는 작업도 포함됩니다.

The other responsibility of the controller is to handles everything that pertains to HTTP requests - redirects,
authentication, web safety, encoding, etc. In short, the controller is where you make sure that people are allowed to
be there, and they get the data they need in a format they can use.
컨트롤러의 또 다른 책임은 리디렉션, 인증, 웹 안전, 인코딩 등의 HTTP 요청과 관련된 모든 것을 처리하는 것입니다. 간단히 말해서 컨트롤러는 사람이 거기에있게 할 수 있는지, 그리고 데이터를 가져 오는 지 확인하는 곳입니다 그들은 그들이 사용할 수있는 형식으로 필요합니다.

Controllers are typically stored in **/application/Controllers**, though they can use a namespace to be grouped however
you need.
컨트롤러는 일반적으로 / application / Controllers에 저장 되지만 필요에 따라 네임 스페이스를 그룹화하여 사용할 수 있습니다.

:doc:`Find out more about controllers </general/controllers>`
컨트롤러에 대해 자세히 알아보십시오.
