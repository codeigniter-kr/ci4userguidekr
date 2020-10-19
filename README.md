# CodeIgniter4 한국어 사용자 가이드
## 설치지침
CodeIgniter 사용자 가이드는 Sphinx를 사용하여 문서를 관리하고 다양한 형식으로 출력합니다.
소스 파일은 [ReStructured Text](https://en.wikipedia.org/wiki/ReStructuredText) 포맷으로 작성되었습니다.


### 설치전 확인
#### Python
Sphinx는 Python 3.5 이상이 필요하며 OS X 또는 Linux를 사용 중이라면 이미 설치되어 있을 수 있습니다. 
터미널 창에서 "python" 또는 "python3"를 실행하여 확인할 수 있습니다. 
```bash
python --version
Python 2.7.17

python3 --version
Python 3.6.9

# For Windows using the Python Launcher
py -3 --version
Python 3.8.1
```

3.5 이상이 아니라면 [Python.org](https://www.python.org/downloads/) 에서 최신 3.x 버전을 설치하십시오.
Linux 사용자는 운영체제에 내장된 패키지 관리자를 사용하여 업데이트해야 합니다.

#### pip
이제 Python 3.x가 설치되어 실행 중이므로 [pip](https://pip.pypa.io/en/stable/) (Python Package Installer) 를 설치합니다.

`pip` 또는 `pip3` 으로 pip가 설치되어 있는지 확인할 수 있습니다.
pip는 Python과 동일한 명명 규칙을 따릅니다.
맨 끝에 `python 3.x` 라고 표시되어 있습니다.

```bash
pip --version
pip 9.0.1 from /usr/lib/python2.7/dist-packages (python 2.7)

pip3 --version
pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)

# For Windows using the Python Launcher
py -3 -m pip --version
pip 20.0.2 from C:\Users\<username>\AppData\Local\Programs\Python\Python38\lib\site-packages\pip (python 3.8)
```

#### Linux
[Linux 패키지 관리자를 사용하여 pip/setuptools/wheel 설치](https://packaging.python.org/guides/installing-using-linux-tools/)

#### Others
[Python.org](https://www.python.org/downloads/) 에서 다운로드한 Python 3.5 이상을 사용중인 경우 pip가 이미 설치되어 있습니다.


### 설치방법
이제 우리는 Sphinx와 라이브러리를 설치해야 합니다. 
운영 체제에 따라 `pip` 또는 `pip3` 를 선택하십시오. 
이 단계 후에는 Python이 방금 설치한 다른 애플리케이션을 모두 찾을 수 없으므로 터미널 창을 다시 시작해야 합니다.

```bash
pip install -r user_guide_src/requirements.txt

pip3 install -r user_guide_src/requirements.txt

# For Windows using the Python Launcher
py -3 -m pip install -r user_guide_src/requirements.txt
```

이제 모든것을 정리하고 문서를 생성합니다.

```bash
cd user_guide_src
make html
```

### 문서 편집 및 작성
사용자 가이드의 모든 소스 파일은 *source/* 아래에 있으며 새 문서를 추가하거나 기존 문서를 수정할 수 있습니다.

### So where's the HTML?
HTML 문서는 사용자가 사용하는 문서이기 때문에 중요합니다.
빌드 된 파일은 관리할 필요가 없으므로 소스와 함께 관리 하지 않습니다.
작업된 결과를 미리보기 위해 필요에 따라 재생성 할 수 있습니다.
HTML 생성은 매우 간단합니다.
사용자 가이드 레파지토리를 복사한 디렉터리로 이동하여 다음 명령을 입력하십오.

```
make html
```
렌더링된 사용자 가이드와 이미지는 *build/html/* 에서 확인할 수 있습니다.
HTML이 빌드 된 후, 각 후속 빌드는 변경된 파일만 다시 빌드하므로 상당한 시간이 절약됩니다.
빌드 파일을 다시 만들고 싶다면 *build* 폴더의 내용을 삭제하고 다시 빌드하십시오.

### Style Guideline
CodeIgniter를 문서화하기 위해 Sphinx를 사용하기 위한 일반적인 지침은 /contributing/documentation.rst를 참조하십시오.


# Thanks to 👍
<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/hoksi"><img src="https://avatars3.githubusercontent.com/u/4138634?v=4" width="100px;" alt=""/><br /><sub><b>Daeseung Han</b></sub></a><br /><a href="https://github.com/codeigniter-kr/ci4userguidekr/commits?author=hoksi" title="Documentation">📖</a> <a href="#translation-hoksi" title="Translation">🌍</a></td>
    <td align="center"><a href="https://z9n.net"><img src="https://avatars1.githubusercontent.com/u/5427199?v=4" width="100px;" alt=""/><br /><sub><b>Terrorboy</b></sub></a><br /><a href="https://github.com/codeigniter-kr/ci4userguidekr/commits?author=Terrorboy" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->
