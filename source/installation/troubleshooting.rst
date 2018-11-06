###############
문제 해결
###############

다음은 몇 가지 일반적인 설치 문제와 제안된 해결 방법 입니다.

URL에 index.php 가 없으면 접근할 수 없습니다.
---------------------------------------------

``/mypage/find/apple`` 로 접근되지 않지만, ``/index.php/mypage/find/apple`` 로 접근 가능할 경우, 
``.htaccess`` (for Apache)가 제대로 설정되어 있지 않은 경우 입니다 .

default page만 보입니다.
-------------------------

URL에 무엇을 넣든 기본 페이지 만로드하는 경우 서버가 검색 엔진 친숙한 URL
(serve search-engine friendly URLs)을 제공하는 데 필요한 REQUEST_URI 변수를 
지원하지 않을 수 있습니다. 첫 단계로 *application/Config/App.php* 파일을
열고 URI 프로토콜 정보를 찾으십시오. 몇 가지 대체 설정을 시도하는 것이
좋습니다. 이것을 시도한 후에도 여전히 작동하지 않는다면 URL에 물음표를 
추가하도록 CodeIgniter에 강요해야합니다. 이렇게하려면 
*application/Config/App.php* 파일을 열어 다음 과 같이 변경하십시오.::

	public $indexPage = 'index.php';

To this::

	public $indexPage = 'index.php?';

The tutorial gives 404 errors everywhere :(
-------------------------------------------

You can't follow the tutorial using PHP's built-in web server.
It doesn't process the ``.htaccess`` file needed to route
requests properly.

The solution: use Apache to server your site.