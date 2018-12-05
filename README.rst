######################
코드 이그나이터 사용자 가이드
######################

******************
설정 지시사항
******************

코드이그나이터 사용자 가이드는 는 문서관리와  다양한 형식으로 문서를 
출력하기 위해 Sphinx를 사용하고 있습니다. 페이지들은 사람이 읽을수 있는 
'Restructed Text <http://sphinx.pocoo.org/rest.html>'_형식으로 쓰여졌습니다.


전제 조건
=============

Sphinx는 파이썬이 필요하고, OS X를 사용하고 있다면, 이미 설치되어 있을 것입니다.
터미널 창에서 다른 파라미터들 없이 ''python''명령을 실행해서 확인해볼 수 있습니다.
어떤 버전이 설치되어 있나 나온 것을 확인해야 합니다. 2.7 버전 이상이 아니라면, 
아래 링크에서 2.7.2를 설치하세요.
http://python.org/download/releases/2.7.2/

설치
============

1.`easy_install <http://peak.telecommunity.com/DevCenter/EasyInstall#installing-easy-install>`_ 를 설치하세요.
2. ``easy_install "sphinx==1.4.5"``
3. ``easy_install sphinxcontrib-phpdomain``
4. 코드 예제에서  PHP, HTML, CSS, and JavaScript 문법들이 강조되는  CI Lexer를 설치하세요. ( *cilexer/README*를 참고하세요.)
5. ``cd user_guide_src``
6. ``make html``

문서 만들고 편집하기
==================================

많은 소스 파일들이 *source/* 밑에 존재하고 이 디렉토리는 당신이 새로운 문서를 
추가하거나 기존의 문서를 수정할 경로입니다. #코드 변경과 마찬가지로,
우리는 특정 브랜치에서 작업하고, 이 저장소(repo)의 *develp* 브랜치에 
pull 요청을 보낼 것을 추천합니다.
#Just as with code changes,
we recommend working from feature branches and making pull requests to
the *develop* branch of this repo.

HTML은 어디 있나요?
====================

확실히, HTML문서는 우리가 가장 신경쓰는 것이고, 우리 사용자가 마주할 가장 중요한
문서입니다. 만들어진 파일을 수정하는 것은 가치가 없기 때문에, 
그것들은 소스 통제 하에 있지 않습니다. 이 점은 당신의 작업을 "미리보기" 하고 싶다면
필요에 따라 재생산 할 수 있도록 해줍니다. HTML을 생성하는 것은 매우 간답합니다.
사용자 가이드 저장소를 포크한 루트디렉토리에서 설치 소개의 마지막에 사용한 명령을 보내세요::

	make html

당신은 그것이 쩌-는 편집을 하는 것을 볼수 있습니다, 어느 순간부터는 
완전히 렌더링된 유저가이드와 이미지들이 *buld/html/*에 만들어져 있을 겁니다.
HTML이 만들어졌으면,  각각의 연이은 빌드들은 바뀐 파일들만 리빌드하고, 상당한 시간동안
저장할 것입니다. 어떤 이유로든 당신의 빌드 파일들을 "리셋" 하고 싶다면 간단하게
*build* 폴더의 컨텐츠들을 지우고 다시만드세요.

***************
스타일 가이드
***************

CodeIgniter작성에 Spinx를 사용하기 위한 일반 가이드는
source/countributing/documentation.rst 를 보세요.
