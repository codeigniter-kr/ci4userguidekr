#########################
User Agent 클래스
#########################

User Agent 클래스는 브라우저, 모바일 장치 또는 사이트를 방문하는 로봇에 대한 정보를 식별하는 데 도움이 되는 기능을 제공합니다.

.. contents::
    :local:
    :depth: 2

**************************
User Agent 클래스 사용
**************************

클래스 초기화
======================

User Agent 클래스는 언제든지 :doc:`IncomingRequest </incoming/incomingrequest>` 인스턴스에서 직접 사용할 수 있습니다.
기본적으로 컨트롤러는 User Agent 클래스를 검색할 수 있는 요청 인스턴스가 있습니다.

.. literalinclude:: user_agent/001.php

User Agent 정의
======================

User Agent 이름 정의는 구성 파일 **app/Config/UserAgents.php**\ 에 있습니다. 
필요한 경우 다양한 User Agent 배열에 항목을 추가할 수 있습니다.

Example
=======

User Agent 클래스가 초기화되면 사이트를 탐색하는 User Agent가 웹 브라우저, 모바일 장치 또는 로봇인지 확인하려고 시도합니다. 
사용 가능한 경우 플랫폼 정보도 수집합니다.

.. literalinclude:: user_agent/002.php

***************
Class Reference
***************

.. php:namespace:: CodeIgniter\HTTP

.. php:class:: UserAgent

	.. php:method:: isBrowser([$key = null])

		:param	string	$key: 선택적 브라우저 이름
    		:returns:	User Agent가 (지정된) 브라우저인 경우 true, 그렇지 않으면 false
    		:rtype:	bool

    		사용자 에이전트가 알려진 웹 브라우저인 경우 true/false (부울)를 리턴합니다.

    		.. literalinclude:: user_agent/003.php

		.. note:: 이 예에서 문자열 "Safari" 는 브라우저 정의 목록의 배열 키입니다. 새 브라우저를 추가하거나 문자열을 변경하려는 경우 **app/Config/UserAgents.php**\ 에서 이 목록을 찾을 수 있습니다.
				  

	.. php:method:: isMobile([$key = null])

		:param	string	$key: 선택적 모바일 장치 이름
    		:returns:	User Agent가 (지정된) 모바일 장치 인 경우 true, 그렇지 않으면 false
    		:rtype:	bool

    		User Agent가 알려진 모바일 장치인 경우 true/false (부울)를 반환합니다.

    		.. literalinclude:: user_agent/004.php

	.. php:method:: isRobot([$key = null])

		:param	string	$key: 선택적 로봇 이름
    		:returns:	User Agent가 (지정된) 로봇인 경우 true, 그렇지 않은 경우 false
    		:rtype:	bool

    		User Agent가 알려진 로봇인 경우 true / false (부울)를 리턴합니다.

    		.. note:: User Agent 라이브러리에는 가장 일반적인 로봇 정의만 포함됩니다. 전체 봇 목록이 아닙니다. 
				수백 개가 있으므로 각각을 검색하는 것은 그리 효율적이지 않습니다. 
				일반적으로 사이트를 방문하는 일부 봇이 목록에없는 경우 **app/Config/UserAgents.php** 파일에 봇을 추가할 수 있습니다.

	.. php:method:: isReferral()

		:returns:	User Agent가 추천인 경우 true, 그렇지 않으면 false
		:rtype:	bool

		User Agent가 다른 사이트에서 참조된 경우 true/false(부울)를 리턴합니다.

	.. php:method:: getBrowser()

		:returns:	감지된 브라우저 또는 빈 문자열
		:rtype:	string

		사이트를 방문한 웹 브라우저의 이름이 포함된 문자열을 반환합니다.

	.. php:method:: getVersion()

		:returns:	감지된 브라우저 버전 또는 빈 문자열
		:rtype:	string

		사이트를 방문한 웹 브라우저의 버전 번호가 포함된 문자열을 반환합니다.

	.. php:method:: getMobile()

		:returns:	감지된 모바일 장치 브랜드 또는 빈 문자열
		:rtype:	string

		사이트를 방문한 모바일 기기의 이름이 포함된 문자열을 반환합니다.

	.. php:method:: getRobot()

		:returns:	감지된 로봇 이름 또는 빈 문자열
		:rtype:	string

		사이트를 방문한 로봇 이름이 포함된 문자열을 반환합니다.

	.. php:method:: getPlatform()

		:returns:	감지된 운영 체제 또는 빈 문자열
		:rtype:	string

		사이트를 방문한 플랫폼이 포함된 문자열을 반환합니다 (Linux, Windows, OS X, etc.).

	.. php:method:: getReferrer()

		:returns:	감지 된 리퍼러(referrer) 또는 빈 문자열
		:rtype:	string

		User Agent가 다른 사이트에서 참조된 경우 리퍼러 일반적으로 다음과 같이 테스트합니다.

		.. literalinclude:: user_agent/005.php

	.. php:method:: getAgentString()

		:returns:	전체 User Agent 문자열 또는 빈 문자열
		:rtype:	string

		전체 User Agent 문자열이 포함된 문자열을 반환합니다. 
		일반적으로 다음과 같습니다
		
		::

			Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.0.4) Gecko/20060613 Camino/1.0.2

	.. php:method:: parse($string)

		:param	string	$string: 사용자 정의 User Agent 문자열
    		:rtype:	void

			현재 방문자가 보고한 것과 다른 사용자 정의 User Agent 문자열을 구문 분석합니다.
