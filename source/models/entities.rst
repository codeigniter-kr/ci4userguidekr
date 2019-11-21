#####################
엔터티 작업
#####################

CodeIgniter는 데이터베이스 계층에서 Entity 클래스를 1급 시민으로 지원하며, 완전히 선택적으로 사용할 수 있도록 유지합니다.
일반적으로 리포지토리 패턴의 일부로 사용되지만 필요에 따라 :doc:`모델 </models/model>`\ 과 함께 직접 사용할 수 있습니다.

.. contents::
    :local:
    :depth: 2

엔터티 사용법
=================

기본적으로 Entity 클래스는 단일 데이터베이스 행을 나타내는 클래스입니다.
여기에는 데이터베이스 열을 나타내는 클래스 속성이 있으며, 해당 행에 대한 비즈니스 논리를 구현하기 위한 추가 방법을 제공합니다.
여기에서 핵심은 지속 방법에 대해 전혀 모른다는 것입니다.
지속방법에 대해서는 모델 또는 저장소 클래스의 책임입니다.
이렇게하면 객체 저장 방법에 변화가 생길 경우 응용 프로그램 전체에서 객체가 사용되는 방식을 변경할 필요가 없습니다.
따라서 빠른 프로토 타이핑 단계에서 JSON 또는 XML 파일을 사용하여 객체를 저장한 다음 개념이 작동하는 것이 입증되면 데이터베이스로 쉽게 전환할 수 있습니다.

매우 간단한 User Entity를 살펴보고이를 명확하게하는 데 도움이되는 방법을 살펴 보겠습니다.

다음 스키마를 가진 ``users``\ 라는 데이터베이스 테이블이 있다고 가정하십시오.

::

    id          - integer
    username    - string
    email       - string
    password    - string
    created_at  - datetime

엔터티 클래스 만들기
-------------------------

이제 새 엔티티 클래스를 작성합니다.
이러한 클래스를 저장할 기본 위치는 없으며, 기존 디렉토리 구조와 맞지 않기 때문에 **app/Entities**\ 에 새 디렉토리를 작성합니다.
**app/Entities/User.php**\ 에 엔티티를 작성하십시오.

::

    <?php namespace App\Entities;

    use CodeIgniter\Entity;

    class User extends Entity
    {
        //
    }

간단하지만 이것은 당신이 해야 할 모든 것입니다. 우리는 잠시 후 이를 더 유용하게 사용할 것입니다.

모델 만들기
----------------

먼저 상호 작용을 위해 모델을 **app/Models/UserModel.php**\ 에 작성합니다.

::

    <?php namespace App\Models;

    use CodeIgniter\Model;

    class UserModel extends Model
    {
        protected $table         = 'users';
        protected $allowedFields = [
            'username', 'email', 'password'
        ];
        protected $returnType    = 'App\Entities\User';
        protected $useTimestamps = true;
    }

모델은 모든 활동은 데이터베이스의 ``users`` 테이블을 사용합니다.
``$allowedFields`` 속성을 클래스 외부에서 변경하려는 모든 필드를 포함하도록 설정했습니다.
``id``, ``created_at``, ``updated_at`` 필드는 클래스 또는 데이터베이스에서 자동으로 처리되므로 변경하지 않습니다.
마지막으로 Entity 클래스를 ``$returnType``\ 으로 설정했습니다.
이를 통해 데이터베이스에서 행을 반환하는 모델의 모든 메소드가 일반 객체나 배열 대신 User Entity 클래스의 인스턴스를 반환합니다.

Working With the Entity Class
-----------------------------

Now that all of the pieces are in place, you would work with the Entity class as you would any other class::

    $user = $userModel->find($id);

    // Display
    echo $user->username;
    echo $user->email;

    // Updating
    unset($user->username);
    if (! isset($user->username)
    {
        $user->username = 'something new';
    }
    $userModel->save($user);

    // Create
    $user = new App\Entities\User();
    $user->username = 'foo';
    $user->email    = 'foo@example.com';
    $userModel->save($user);

You may have noticed that the User class has not set any properties for the columns, but you can still
access them as if they were public properties. The base class, **CodeIgniter\Entity**, takes care of this for you, as
well as providing the ability to check the properties with **isset()**, or **unset()** the property, and keep track
of what columns have changed since the object was created or pulled from the database.

When the User is passed to the model's **save()** method, it automatically takes care of reading the  properties
and saving any changes to columns listed in the model's **$allowedFields** property. It also knows whether to create
a new row, or update an existing one.

Filling Properties Quickly
--------------------------

The Entity class also provides a method, ``fill()`` that allows you to shove an array of key/value pairs into the class
and populate the class properties. Any property in the array will be set on the Entity. However, when saving through
the model, only the fields in $allowedFields will actually be saved to the database, so you can store additional data
on your entities without worrying much about stray fields getting saved incorrectly.

::

    $data = $this->request->getPost();

    $user = new App\Entities\User();
    $user->fill($data);
    $userModel->save($user);

You can also pass the data in the constructor and the data will be passed through the `fill()` method during instantiation.

::

    $data = $this->request->getPost();

    $user = new App\Entities\User($data);
    $userModel->save($user);

Handling Business Logic
=======================

While the examples above are convenient, they don't help enforce any business logic. The base Entity class implements
some smart ``__get()`` and ``__set()`` methods that will check for special methods and use those instead of using
the attributes directly, allowing you to enforce any business logic or data conversion that you need.

Here's an updated User entity to provide some examples of how this could be used::

    <?php namespace App\Entities;

    use CodeIgniter\Entity;
    use CodeIgniter\I18n\Time;

    class User extends Entity
    {
        public function setPassword(string $pass)
        {
            $this->password = password_hash($pass, PASSWORD_BCRYPT);

            return $this;
        }

        public function setCreatedAt(string $dateString)
        {
            $this->attributes['created_at'] = new Time($dateString, 'UTC');

            return $this;
        }

        public function getCreatedAt(string $format = 'Y-m-d H:i:s')
        {
            // Convert to CodeIgniter\I18n\Time object
            $this->attributes['created_at'] = $this->mutateDate($this->attributes['created_at']);

            $timezone = $this->timezone ?? app_timezone();

            $this->attributes['created_at']->setTimezone($timezone);

            return $this->attributes['created_at']->format($format);
        }
    }

The first thing to notice is the name of the methods we've added. For each one, the class expects the snake_case
column name to be converted into PascalCase, and prefixed with either ``set`` or ``get``. These methods will then
be automatically called whenever you set or retrieve the class property using the direct syntax (i.e. $user->email).
The methods do not need to be public unless you want them accessed from other classes. For example, the ``created_at``
class property will be accessed through the ``setCreatedAt()`` and ``getCreatedAt()`` methods.

.. note:: This only works when trying to access the properties from outside of the class. Any methods internal to the
    class must call the ``setX()`` and ``getX()`` methods directly.

In the ``setPassword()`` method we ensure that the password is always hashed.

In ``setCreatedAt()`` we convert the string we receive from the model into a DateTime object, ensuring that our timezone
is UTC so we can easily convert the viewer's current timezone. In ``getCreatedAt()``, it converts the time to
a formatted string in the application's current timezone.

While fairly simple, these examples show that using Entity classes can provide a very flexible way to enforce
business logic and create objects that are pleasant to use.

::

    // Auto-hash the password - both do the same thing
    $user->password = 'my great password';
    $user->setPassword('my great password');

Data Mapping
============

At many points in your career, you will run into situations where the use of an application has changed and the
original column names in the database no longer make sense. Or you find that your coding style prefers camelCase
class properties, but your database schema required snake_case names. These situations can be easily handled
with the Entity class' data mapping features.

As an example, imagine you have the simplified User Entity that is used throughout your application::

    <?php namespace App\Entities;

    use CodeIgniter\Entity;

    class User extends Entity
    {
        protected $attributes = [
            'id' => null;
            'name' => null;        // Represents a username
            'email' => null;
            'password' => null;
            'created_at' => null;
            'updated_at' => null;
        ];
    }

Your boss comes to you and says that no one uses usernames anymore, so you're switching to just use emails for login.
But they do want to personalize the application a bit, so they want you to change the name field to represent a user's
full name now, not their username like it does currently. To keep things tidy and ensure things continue making sense
in the database you whip up a migration to rename the `name` field to `full_name` for clarity.

Ignoring how contrived this example is, we now have two choices on how to fix the User class. We could modify the class
property from ``$name`` to ``$full_name``, but that would require changes throughout the application. Instead, we can
simply map the ``full_name`` column in the database to the ``$name`` property, and be done with the Entity changes::

    <?php namespace App\Entities;

    use CodeIgniter\Entity;

    class User extends Entity
    {
        protected $attributes = [
            'id' => null;
            'name' => null;        // Represents a username
            'email' => null;
            'password' => null;
            'created_at' => null;
            'updated_at' => null;
        ];

        protected $datamap = [
            'full_name' => 'name'
        ],
    }

By adding our new database name to the ``$datamap`` array, we can tell the class what class property the database column
should be accessible through. The key of the array is the name of the column in the database, where the value in the array
is class property to map it to.

In this example, when the model sets the ``full_name`` field on the User class, it actually assigns that value to the
class' ``$name`` property, so it can be set and retrieved through ``$user->name``. The value will still be accessible
through the original ``$user->full_name``, also, as this is needed for the model to get the data back out and save it
to the database. However, ``unset`` and ``isset`` only work on the mapped property, ``$name``, not on the original name,
``full_name``.

Mutators
========

Date Mutators
-------------

By default, the Entity class will convert fields named `created_at`, `updated_at`, or `deleted_at` into
:doc:`Time </libraries/time>` instances whenever they are set or retrieved. The Time class provides a large number
of helpful methods in an immutable, localized way.

You can define which properties are automatically converted by adding the name to the **options['dates']** array::

    <?php namespace App\Entities;

    use CodeIgniter\Entity;

    class User extends Entity
    {
        protected $dates = ['created_at', 'updated_at', 'deleted_at'];
    }

Now, when any of those properties are set, they will be converted to a Time instance, using the application's
current timezone, as set in **app/Config/App.php**::

    $user = new App\Entities\User();

    // Converted to Time instance
    $user->created_at = 'April 15, 2017 10:30:00';

    // Can now use any Time methods:
    echo $user->created_at->humanize();
    echo $user->created_at->setTimezone('Europe/London')->toDateString();

Property Casting
----------------

You can specify that properties in your Entity should be converted to common data types with the **casts** property.
This option should be an array where the key is the name of the class property, and the value is the data type it
should be cast to. Casting only affects when values are read. No conversions happen that affect the permanent value in
either the entity or the database. Properties can be cast to any of the following data types:
**integer**, **float**, **double**, **string**, **boolean**, **object**, **array**, **datetime**, and **timestamp**.
Add a question mark at the beginning of type to mark property as nullable, i.e. **?string**, **?integer**.

For example, if you had a User entity with an **is_banned** property, you can cast it as a boolean::

    <?php namespace App\Entities;

    use CodeIgniter\Entity;

    class User extends Entity
    {
        protected $casts = [
            'is_banned' => 'boolean',
            'is_banned_nullable' => '?boolean'
        ],
    }

Array/Json Casting
------------------

Array/Json casting is especially useful with fields that store serialized arrays or json in them. When cast as:

* an **array**, they will automatically be unserialized,
* a **json**, they will automatically be set as an value of json_decode($value, false),
* a **json-array**, they will automatically be set as an value of json_decode($value, true),

when you read the property's value.
Unlike the rest of the data types that you can cast properties into, the:

* **array** cast type will serialize,
* **json** and **json-array** cast will use json_encode function on

the value whenever the property is set::

    <?php namespace App\Entities;

    use CodeIgniter\Entity;

    class User extends Entity
    {
        protected $casts => [
            'options' => 'array',
		    'options_object' => 'json',
		    'options_array' => 'json-array'
        ];
    }

    $user    = $userModel->find(15);
    $options = $user->options;

    $options['foo'] = 'bar';

    $user->options = $options;
    $userModel->save($user);

Checking for Changed Attributes
-------------------------------

You can check if an Entity attribute has changed since it was created. The only parameter is the name of the
attribute to check::

    $user = new User();
    $user->hasChanged('name');      // false

    $user->name = 'Fred';
    $user->hasChanged('name');      // true

Or to check the whole entity for changed values omit the parameter:
    $user->hasChanged();            // true
