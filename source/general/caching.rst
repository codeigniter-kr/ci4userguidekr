################
웹 페이지 캐싱
################

CodeIgniter lets you cache your pages in order to achieve maximum
performance.
CodeIgniter를 사용하면 성능을 극대화하기 위해 페이지를 캐시 할 수 있습니다.

Although CodeIgniter is quite fast, the amount of dynamic information
you display in your pages will correlate directly to the server
resources, memory, and processing cycles utilized, which affect your
page load speeds. By caching your pages, since they are saved in their
fully rendered state, you can achieve performance much closer to that of
static web pages.
CodeIgniter는 매우 빠르지 만 페이지에 표시되는 동적 정보의 양은 사용 된 서버 리소스, 메모리 및 처리 사이클과 직접적으로 관련되어 있으므로 페이지로드 속도에 영향을줍니다. 페이지를 캐싱하면 완전히 렌더링 된 상태로 저장되기 때문에 정적 웹 페이지에 훨씬 더 근접한 성능을 얻을 수 있습니다.

캐싱은 어떻게 작동합니까?
=========================

Caching can be enabled on a per-page basis, and you can set the length
of time that a page should remain cached before being refreshed. When a
page is loaded for the first time, the file will be cached using the
currently configured cache engine. On subsequent page loads the cache file
will be retrieved and sent to the requesting user's browser. If it has
expired, it will be deleted and refreshed before being sent to the
browser.
캐싱은 페이지 단위로 활성화 할 수 있으며 페이지를 새로 고치기 전에 캐싱해야하는 기간을 설정할 수 있습니다. 페이지가 처음으로로드되면 파일은 현재 구성된 캐시 엔진을 사용하여 캐시됩니다. 후속 페이지로드시 캐시 파일이 검색되어 요청한 사용자의 브라우저로 전송됩니다. 만료되면 브라우저로 보내기 전에 삭제되고 새로 고쳐집니다.

.. note:: The Benchmark tag is not cached so you can still view your page
	load speed when caching is enabled.
	벤치 마크 태그는 캐싱되지 않으므로 캐싱을 사용할 때 페이지로드 속도를 계속 볼 수 있습니다.

캐싱 사용
================

To enable caching, put the following tag in any of your controller
methods
캐싱을 사용하려면 컨트롤러 메서드에 다음 태그를 넣습니다.

::

	$this->cachePage($n);

Where ``$n`` is the number of **seconds** you wish the page to remain
cached between refreshes.
페이지가 새로 고침 사이에서 캐시 된 상태로 유지되기를 원하는 시간 **seconds** ``$n`` 은 어디 입니까?

The above tag can go anywhere within a method. It is not affected by
the order that it appears, so place it wherever it seems most logical to
you. Once the tag is in place, your pages will begin being cached.
위의 태그는 메소드 내 어디에서나 이동할 수 있습니다. 그것은 나타나는 순서에 영향을받지 않으므로 그것이 가장 논리적으로 보이는 곳이면 어디든지 놓으십시오. 태그가 제자리에 있으면 페이지가 캐시되기 시작합니다.

.. important:: If you change configuration options that might affect
	your output, you have to manually delete your cache files.
	출력에 영향을 줄 수있는 구성 옵션을 변경하면 캐시 파일을 수동으로 삭제해야합니다.

.. note:: Before the cache files can be written you must set the cache
	engine up by editing **app/Config/Cache.php**.
	캐시 파일을 작성하기 전에 **app/Config/Cache.php** 를 편집하여 캐시 엔진을 설정해야합니다 .

캐시 삭제
===============

If you no longer wish to cache a file you can remove the caching tag and
it will no longer be refreshed when it expires.
더 이상 파일을 캐시하지 않으려면 캐싱 태그를 제거하면 만료시 더 이상 새로 고쳐지지 않습니다.

.. note:: Removing the tag will not delete the cache immediately. It will
	have to expire normally.
	태그를 제거해도 즉시 캐시가 삭제되지는 않습니다. 정상적으로 만료되어야합니다.
