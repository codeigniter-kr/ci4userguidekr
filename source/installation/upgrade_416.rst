#############################
Upgrading from 4.1.5 to 4.1.6
#############################

설치 방법에 해당하는 업그레이드 지침을 참조하십시오.

- :ref:`Composer 설치 - App Starter 업그레이드 <app-starter-upgrading>`
- :ref:`Composer 설치 - 기존 프로젝트의 CodeIgniter4 업그레이드 <adding-codeigniter4-upgrading>`
- :ref:`수동 설치 업그레이드 <installing-manual-upgrading>`

.. contents::
    :local:
    :depth: 2

Breaking Changes
****************

검증 결과 변경
=========================

Due to a bug fix, the Validation now might change the validation results when you validate an array item (see :ref:`Changelog <changelog-v416-validation-changes>`). So check the validation results for all the code that validates the array. Validating multiple fields like ``contacts.*.name`` is not affected.
버그 수정으로 인해 배열 항목의 유효성을 검사할 때, 유효성 검사가 유효성 검사 결과를 변경할 수 있습니다(:ref:`Changelog <changelog-v416-validation-changes>` 참조). 
배열의 유효성을 검사하는 모든 코드에 대한 유효성 검사 결과를 확인하십시오. 
``contact.*.name``\ 과 같은 다중 필드의 유효성 검사는 영향을 받지 않습니다.

다음과 같은 양식(form)에 대해

::

    <input type='text' name='invoice_rule[1]'>
    <input type='text' name='invoice_rule[2]'>

다음과 같은 유효성 검사 규칙을 사용한 경우

::

    'invoice_rule' =>  ['rules' => 'numeric', 'errors' => ['numeric' => 'Not numeric']]

키 ``invoice_rule``\ 를 ``invoice_rule.*``\ 로 변경하면 유효성 검사가 작동합니다.

Breaking Enhancements
*********************

없음.

Project Files
*************

프로젝트 공간에 있는 수많은 파일(root, app, public, writable)이 업데이트를 받았습니다.
이러한 파일은 **시스템** 범위를 벗어났기 때문에 사용자의 개입 없이는 변경되지 않습니다.
프로젝트 공간의 변경 사항을 병합하는 데 도움이 되는 타사 CodeIgniter 모듈은 `Packagist <https://packagist.org/explore/?query=codeigniter4%20updates>`_\ 에서 찾을 수 있습니다.

.. note:: 버그 수정에 대한 매우 드문 경우를 제외하고 프로젝트 공간의 파일을 변경해도 응용 프로그램이 손상되지 않습니다.
    여기에 명시된 모든 변경 사항은 다음 주요 버전까지 선택 사항이며, 필수 변경 사항은 위의 섹션에서 다룹니다.

Content Changes
===============

다음 파일에는 중요한 변경 사항(더 이상 사용되지 않음 또는 시각적 조정 포함)이 있으므로 업데이트된 버전을 응용 프로그램과 병합하는 것이 좋습니다.

* ``app/Config/Filters.php``
* ``app/Config/Mimes.php``
* ``app/Config/Security.php``
* ``app/Config/Toolbar.php``

All Changes
===========

다음은 프로젝트 공간에서 변경사항이 있는 모든 파일의 목록입니다. 대부분은 런타임에 영향을 미치지 않는 간단한 주석 또는 형식입니다.

* ``app/Config/Filters.php``
* ``app/Config/Mimes.php``
* ``app/Config/Security.php``
* ``app/Config/Toolbar.php``
* ``app/Views/errors/html/error_exception.php``
