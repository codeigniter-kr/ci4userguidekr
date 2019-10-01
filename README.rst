###############################
CodeIgniter 한국어 사용자 가이드
###############################

***********
설치지침
***********

CodeIgniter 사용자 가이드는 Sphinx를 사용하여 문서를 관리하고 다양한 형식으로 출력합니다.
소스 파일은 `ReStructured Text <http://sphinx.pocoo.org/rest.html>`_ 포맷으로 작성되었습니다.

설치전 확인
=============

Sphinx에는 Python이 필요하며, OS X를 사용하고 있다면 이미 설치되어 있습니다.
python 설치 여부는 터미널 창에서 ``python``\ 을 입력하여 확인할 수 있습니다.
설치된 버전이 2.7 이상이 아닌 경우 http://python.org/download/releases/2.7.2/ 에서 설치하십시오.

설치방법
============

1. `easy_install <http://peak.telecommunity.com/DevCenter/EasyInstall#installing-easy-install>`_ 설치
2. ``easy_install "sphinx==1.4.5"``
3. ``easy_install sphinxcontrib-phpdomain``
4. PHP, HTML, CSS, and JavaScript 코드 샘플의 구문 강조를 위해 CI Lexer를 설치 하십시오. (see *cilexer/README*)
5. ``cd user_guide_src``
6. ``make html``

문서 편집 및 작성
==================================

사용자 가이드의 모든 소스 파일은 *source/* 아래에 있으며 새 문서를 추가하거나 기존 문서를 수정할 수 있습니다.

So where's the HTML?
====================

HTML 문서는 사용자가 사용하는 문서이기 때문에 중요합니다.
빌드 된 파일은 관리할 필요가 없으므로 소스와 함께 관리 하지 않습니다.
작업된 결과를 미리보기 위해 필요에 따라 재생성 할 수 있습니다.
HTML 생성은 매우 간단합니다.
사용자 가이드 레파지토리를 복사한 디렉토리로 이동하여 다음 명령을 입력하십오.
::

	make html

렌더링된 사용자 가이드와 이미지는 *build/html/*\ 에서 확인할 수 있습니다.
HTML이 빌드 된 후, 각 후속 빌드는 변경된 파일만 다시 빌드하므로 상당한 시간이 절약됩니다.
빌드 파일을 다시 만들고 싶다면 *build* 폴더의 내용을 삭제하고 다시 빌드하십시오.

***************
Style Guideline
***************

CodeIgniter를 문서화하기 위해 Sphinx를 사용하기위한 일반적인 지침은 source/contributing/documentation.rst\ 를 참조하십시오.
