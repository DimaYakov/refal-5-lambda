# Рефал-5λ

> English translation of README.md is available [here](README.en.md).

# О языке и компиляторе

Язык Рефал-5λ — точное надмножество [Рефала-5][3], основным расширением
которого являются функции высшего порядка.

Компилятор Рефала-5λ — оптимизирующий компилятор, поддерживающий возможность
как компиляции в промежуточный интерпретируемый код, так и в исходный код
на C++. Ключевая особенность компилятора — удобный интерфейс с языком C++.

## Цели
Цели написаны в порядке убывания приоритета. Т. е., например, если в чём-то
противоречат первая и третья цели, имеет приоритет первая.

1. **Язык — точное надмножество классического Рефала-5.**
   * Любая корректная программа на классическом Рефале-5 должна идентично
     выполняться на Рефале-5λ.
   * Следствие: синтаксис — точное надмножество языка.
   * Следствие: поддержка всех встроенных функций официальной реализации,
     включая поддержку их недокументированной семантики.
2. **Язык и компилятор для практического программирования.**
   * Синтаксические расширения должны позволять писать более выразительный
     код не в ущерб эффективности (например, синтаксис присваивания вместо
     условий в роли присваиваний).
   * Эффективная оптимизация на разных уровнях (преобразование синтаксического
     дерева, промежуточный императивный код, возможность прямой кодогенерации).
   * Предсказуемая производительность — классическое списковое представление
     не прячет временны́е затраты в стадию сборки мусора.
   * Переносимость компилятора — возможность его использовать как с любым
     компилятором C++, так и без оного.
   * Достаточно богатая стандартная библиотека (по сравнению со стандартной
     библиотекой классического Рефала-5). Библиотека `Library` предоставляет
     в дополнение ко всем возможностям Рефала-5 ещё и двоичный ввод/вывод,
     библиотека `LibraryEx` — удобные вспомогательные функции и функции высшего
     порядка: `Map`, `Reduce`, «гибрид» `MapReduce`, которые существенно
     упрощают написание циклических конструкций.
   * Инкапсуляция: поддержка именованных скобок — абстрактных типов данных.
     Содержимое таких скобок доступно только в той единице трансляции, где они
     созданы.
   * Инкапсуляция: статические ящики. В отличие от глобальной копилки
     классического Рефала-5, можно объявить статический ящик в локальной
     области видимости, недоступный извне (кстати, копилка реализована поверх
     такого статического ящика в библиотеке `Library`).
   * Утилита `SRMake`, позволяющая отслеживать зависимости между исходниками.
   * Целевой файл компиляции — исполнимый файл операционной системы. Для запуска
     отдельного интерпретатора не нужно.
3. **Компилятор должен служить учебным пособием по курсу «Проектирование
   компиляторов».**
   * Архитектура компилятора и алгоритмы трансляции должны быть максимально
     просты и ясны.
   * Приступать к работе над компилятором будут студенты, часто не знакомые
     с РЕФАЛом, поэтому язык должен быть удобен для программирования и иметь
     низкий порог вхождения.
   * Код должен быть организован таким образом, чтобы при внесении изменений
     требовалось изучать и изменять только небольшое количество компонентов.
   * Используется классическое списковое представление, поскольку оно наиболее
     простое (например, в нём не требуется сборка мусора).
   * Компилятор самоприменим, поскольку, во-первых, погружение в предметную
     область становится неизбежным (что улучшает понимание и, тем самым,
     повышает качество работы), во-вторых, разработка методом раскрутки
     интереснее и поучительнее.
4. **Компилятор должен быть легко переносим — должен собираться на любой машине,
   где есть какой-нибудь компилятор языка C++98.**
   * Должны поддерживаться как минимум операционные системы Windows, Linux
     и macOS.
   * Лучше не делать предположений относительно того, какие утилиты (IDE, make,
     CMake, autotools…) есть на машине разработчика. Поэтому сборка для Windows
     осуществляется при помощи командных файлов, под UNIX-like платформы —
     при помощи bash-скриптов (последний, как правило, есть на всех современных
     UNIX-like системах).
   * Следует ограничиваться стандартным подмножеством C++, одинаково реализованном
     на подавляющем большинстве платформ. «#ifdef-кошмара» следует избегать.
   * Компилятор в рамках текущей архитектуры потребляет много памяти (30 Мбайт).
     Перенос под DOS с сохранением лёгкой компиляции под другие платформы
     потребует много работы и неоправданно усложнит компилятор и рантайм.
     Поэтому DOS не поддерживается.
   * Должно поддерживаться максимальное количество различных компиляторов C++98,
     причём как код библиотек, так и сгенерированный код должны собираться
     с минимальным количеством предупреждений.
5. **Компилятор должен служить back-end’ом компилятора Модульного Рефала.**
   * Язык должен быть достаточно выразительным, чтобы эффективно выражать
     средства Модульного Рефала. Поэтому в языке есть, например, абстрактные типы
     данных и статические ящики.
   * В рантайме могут быть описаны средства, нигде в самом компиляторе
     не используемые. Дело в том, что они используются в Модульном Рефале.
   * Некоторые цели компилятора Модульного Рефала распространяются и на Простой
     Рефал, например, способность работать на слабых машинах.

### Историческое замечание

[Первоначальной целью][4] было написание минимального компилятора, который
мог бы генерировать код на императивном языке (конкретно — C++). Удобство
программирования, а также чистота, ясность и сопровождаемость кода высокого
приоритета не имели. Поэтому возникли такие артефакты, как необходимость
предобъявлений, пустые функции вместо идентификаторов, коряво написанная
библиотека Library.cpp. Следствием из этой цели было то, что каждая сущность
языка компилируется в эквивалентную сущность C++: `$EXTERN` и `$FORWARD` —
в объявления функций, функции — в определения функций, пустые функции —
в функции, состоящие из единственного оператора
`return refalrts::cRecognitionImpossible;`.

Позднее нарисовалась новая цель: компилятор должен стать одним из back-end’ов
Модульного Рефала. Соответственно, в язык добавились новые средства: статические
ящики, идентификаторы и абстрактные типы данных. Добавлены они в рамках той же
концепции независимой трансляции: статические ящики (которые являются
особого вида функциями) компилируются в специальные функции, идентификаторы
(также требующие предобъявления) — в хитрую конструкцию на C++.

Цель обеспечить максимальную переносимость ни разу явно не декларировалась,
но подразумевалась.

Несмотря на то, что компилятор как учебное пособие используется довольно
давно (примерно с 2009 года), явную цель я сформулировал только недавно,
когда осознал, что с текущим компилятором и языком студентам работать довольно
сложно. Можно считать, что все коммиты, начиная с апреля 2015 года, были
подчинены этой цели.

На данный момент первоначальная цель (минимальный компилятор РЕФАЛа
в императивный код) признана устаревшей, от её наследия код будет постепенно
очищаться.

Позднее, цель опять сменилась. Диалект «Простого Рефала», во-первых, перестал
быть простым, во-вторых, как самостоятельный ни с чем не совместимый диалект
он не нужен. Было решено конвергироваться в сторону классического Рефала-5,
к которому он близок по духу.

## Синтаксические и семантические расширения языка

Язык и реализация предоставляют ряд дополнительных возможностей, которых нет
в классическом [Рефале-5][3].

### Функции высшего порядка

Именно они и дали название диалекту — как известно, вложенные безымянные
функции на жаргоне называются лямбдами. Множество допустимых символов Рефала-5
было дополнено символом-замыканием, который может представлять собой как ссылку
на глобальную именованную функцию, так и объект безымянной функции.

    *$FROM LibraryEx
    $EXTERN Map;

    PrintEachLine {
      (e.Line) = <Prout e.Line>;
    }

    $ENTRY PrintLines-1 {
      e.Lines = <Map &PrintEachLine e.Lines>;
    }

    $ENTRY PrintLines-2 {
      e.Lines = <Map { (e.Line) = <Prout e.Line>; } e.Lines>;
    }

Вызвать такую функцию можно как при помощи `Mu`, так и непосредственно записав
s-переменную сразу после угловой скобки:

    Map-1 {
      s.Func t.Item e.Items = <Mu s.Func t.Item> <Map-1 s.Func e.Items>;
      s.Func /* пусто */ = /* пусто */;
    }

    Map-2 {
      s.Func t.Item e.Items = <s.Func t.Item> <Map-1 s.Func e.Items>;
      s.Func /* пусто */ = /* пусто */;
    }

(На самом деле, функция `Map` из `LibraryEx` богаче по возможностям.)

### Присваивания, блоки и сокрытие переменных

#### Блоки
Блок (и даже последовательность блоков) допустим после любого результатного
выражения, в том числе и в условии тоже.

    Foo {
      некоторый образец
        , условие
        : { …блок 1… }
        : { …блок 2… }
        : образец условия
        = результатное выражение;
    }

Вообще, блок считается синтаксическим сахаром, и запись

    Result : { …A… } : { …B… } : { …C… }

является эквивалентом для

    <{ …C… } <{ …B… } <{ …A… } Result>>>

т.е. обычной композицией безымянных вложенных функций.

#### Присваивания
Присваивание, в отличие от классического условия, записывается через знак `=`
(вместо `,`) и не допускает отката в левую часть или к следующему предложению.
Для предложения

    PatA , ResB : PatC = ResD : PatE , ResF : PatG = ResH;

неуспех сопоставления в `PatC` произведёт откат к `PatA`, либо к следующему
предложению. Неуспех в `PatE` аварийно остановит программу. Неуспех в `PatG`
откатится либо к `PatE`, либо (если `PatE` не допускает другого сопоставления)
тоже аварийно остановит программу.

Присваивания — тоже синтаксический сахар, они эквивалентны блокам из одного
предложения. Предыдущий пример в точности эквивалентен следующему предложению
классического Рефала:

    PatA , ResB : PatC , ResD : { PatE , ResF : PatG = ResH; };

либо Рефала-5λ (обратите внимание на знак равенства):

    PatA , ResB : PatC = ResD : { PatE , ResF : PatG = ResH; };

Основное преимущество присваивания перед условием в роли присваивания —
эффективность выполнения на списковой реализации. При построении результатной
части условия обязательно приходится копировать переменные, поскольку при
неуспехе нужно будет тот же аргумент функции передать в следующее предложение.
В присваиваниях откат невозможен, а значит компилятор может (и должен) просто
переносить значения переменных из аргумента.

#### Сокрытие переменных
При использовании расширенных конструкций (условия, блоки, присваивания) часто
в одном из подчинённых образцов строится новая сущность, по смыслу эквивалентная
предыдущей. И при этом предыдущая сущность уже становится ненужной. Логично ей
дать то же имя переменной, но синтаксис классического Рефала-5 не позволит это
сделать — переменная станет повторной и должна будет иметь точно такое же
значение.

Например, выполняется синтаксический анализ методом рекурсивного спуска,
и допустим, мы пишем функцию для обработки следующего правила

    Procedure → Header Declarations Body.

Пусть у нас функции-нетерминалы принимают на входе последовательность токенов,
возвращают синтаксическое дерево, список ошибок и остаток последовательности
токенов. Тогда функция обработки процедуры имела бы вид:

    ParseProcedure {
      e.Tokens

        = <ParseHeader e.Tokens>
        : (e.FuncName) (e.Parameters) (e.HeaderErrors) e.Tokens1

        = <ParseDeclarations e.Tokens1>
        : (e.Declarations) (e.DeclErrors) e.Tokens2

        = <ParseBody e.Tokens2> : (e.Body) (e.BodyErrors) e.Tokens3

        = ((e.FuncName) (e.Parameters) (e.Declarations) e.Body)
          (e.HeaderErrors e.DeclErrors e.BodyErrors)
          e.Tokens3;
    }

Здесь нам в каждом присваивании приходится к переменной `e.Tokens` приписывать
номер. `e.Tokens1` — токены, оставшиеся после считывания заголовка,
`e.Tokens2` — после считывания объявлений и `e.Tokens3` — после считывания тела
процедуры.

Рефал-5λ позволяет избежать введения этой нумерации. Если в образцовом выражении
после имени переменной указать знак `^`, то эта переменная _сокроет_ одноимённую,
связанную раньше. В данном образце она будет считаться новой (не повторной),
и в оставшейся части предложения переменная с этим именем будет связана уже
с новым значением (если позже её не сокроют опять). Предыдущий пример будет
выглядеть так:

    ParseProcedure {
      e.Tokens

        = <ParseHeader e.Tokens>
        : (e.FuncName) (e.Parameters) (e.HeaderErrors) e.Tokens^

        = <ParseDeclarations e.Tokens>
        : (e.Declarations) (e.DeclErrors) e.Tokens^

        = <ParseBody e.Tokens> : (e.Body) (e.BodyErrors) e.Tokens^

        = ((e.FuncName) (e.Parameters) (e.Declarations) e.Body)
          (e.HeaderErrors e.DeclErrors e.BodyErrors)
          e.Tokens^;
    }

### Инкапсуляция: статические ящики и абстрактные типы данных

#### Статические ящики
Тут всё просто. Статические ящики повторяют одноимённую концепцию[Рефала-2][5].
Статический ящик — это функция, которая при вызове возвращает предыдущий
аргумент своего вызова (на первом вызове возвращают пустоту). Иначе говоря,
это некоторая глобальная переменная, которая хранит объектное выражение. Его
чтение выполняется одновременно с записью — вызов статического ящика как функции
возвращает значение, которое в нём хранилось и при этом устанавливает новое.

Синтаксически это оформляется при помощи директив `$SWAP` — статический ящик
как локальная функция и `$ESWAP` — как entry-функция (можно обратиться в других
единицах трансляции при помощи `$EXTERN`).

    $SWAP G_LocalState, G_Flags;
    $ESWAP G_CommonOptions;

В отличие от копилки, при использовании статических ящиков не требуется
придумывать уникальное для всей программы имя, кроме того, никто извне
единицы трансляции не сможет уничтожить значение при помощи `<Dgall>`.

#### Пустые функции
В отличие от классического Рефала-5, язык допускает создание пустых функций,
не содержащих ни одного предложения. Их вызов всегда приводит к аварийному
останову программы. В ранней версии языка (когда он ещё был Простым Рефалом)
пустые функции использовались в роли идентификаторов и довольно часто, поэтому
для их записи был добавлен синтаксический сахар — ключевое слово `$ENUM` для
локальной функции и `$EENUM` для entry:

    /* запись */
    $ENUM Opened, Closed;
    $EENUM TkNumber, TkName;

    /* эквивалентна */
    Opened {}
    Closed {}
    $ENTRY TkNumber {}
    $ENTRY TkName {}

На данный момент они в языке присутствуют, но по прямому назначению
не используются (ведь есть идентификаторы). За исключением случая абстрактных
типов данных.

#### Абстрактные типы данных
Они же именованные скобки. Они же квадратные скобки. Они же инкапсулированные
скобки. Это в некотором смысле разновидность структурных скобок, только (а) они
квадратные, (б) после `[` обязательно должно располагаться имя функции.

Если функцию, которая пишется после `[`, определить как локальную,
то содержимое данного скобочного терма будет доступно только в той единице
трансляции, где он создан (в других файлах невозможно будет на эту локальную
функцию сослаться по имени). В других единицах трансляции на данный терм
можно ссылаться только как на t-переменную.

Для объявления такой функции-тега удобно воспользоваться ключевым словом `$ENUM`.

    $ENUM SymTable;

    /**
      <SymTable-Create> == t.SymTable
    */
    $ENTRY SymTable-Create {
      = [SymTable];
    }

    /**
      <SymTable-Lookup t.SymTable e.Name>
        == Success e.Value
        == Fails
    */
    $ENTRY SymTable-Lookup {
      [SymTable e.Names-B ((e.Name) e.Value) e.Names-E] e.Name
        = Success e.Value;

      [SymTable e.Names] e.Name = Fails;
    }

    /**
      <SymTable-Update t.SymTable (e.Name) e.Value> == t.SymTable
    */
    $ENTRY SymTable-Update {
      [SymTable e.Names-B ((e.Name) e.OldValue) e.Names-E]
      (e.Name) e.NewValue
        = [SymTable e.Names-B ((e.Name) e.NewValue) e.Names-E];

      [SymTable e.Names] (e.Name) e.Value
        = [SymTable e.Names ((e.Name) e.Value)];
    }

### Нативные вставки

Классическая реализация Рефала-5 (и некоторые другие реализации) закрыта для
расширения — множество примитивных встроенных функций языка можно расширить
только путём модификации интерпретатора.

В отличие от неё, реализация Рефала-5λ открыта — можно добавить в язык новые
возможности (работа с сетью, с базами данных), не меняя исходную реализацию.
Язык допускает т.н. «нативные вставки» (native insertions) — вставки кода
на языке C++. Выглядит это так:

    %%
    // это нативная вставка в глобальной области видимости
    #include <stdio.h>

    namespace {
      int g_next_number = 0;
    };
    %%

    $ENTRY NextNumber {
    %%
      // это нативная вставка внутри тела функции, т.е. функция
      // целиком пишется на C++.

      refalrts::Iter content_b = 0, content_e = 0;
      refalrts::Iter pfunc_name =
        refalrts::call_left(content_b, content_e, arg_begin, arg_end);

      if (! refalrts::empty_seq(content_b, content_e)) {
        return refalrts::cRecognitionImpossible;
      }

      ++g_next_number;
      printf("Generating next number %d\n", g_next_number);

      refalrts::reinit_number(arg_begin, g_next_number);
      refalrts::splice_to_free_list(pfunc_name, arg_end);
      return refalrts::cSuccess;
    %%
    }

Функция `NextNumber` написана на C++. Вообще, вся стандартная библиотека
языка, `Library`, целиком написана на Рефале-5λ с такими нативными вставками —
а ведь в ней есть и арифметика, и ввод-вывод, и многое другое.

### Включение файлов

Язык поддерживает ключевое слово `$INCLUDE`, позволяющее, по аналогии с C++,
включать в текущую единицу трансляции содержимое другого текстового файла
(он должен иметь расширение `.refi`). После ключевого слова должно располагаться
имя файла в виде составного символа в кавычках.

    $INCLUDE "LibraryEx";

    /* дальше в коде можно использовать Map, Sort, LoadFile и т.д. */


## Установка

Установить компилятор в систему можно, либо скачав его с репозитория
[simple-refal-distrib.git][1], либо с [simple-refal.git][2]. В первом случае
вам будут доступны только исполнимые файлы компилятора (в полускомпилированном
виде — как исходники C++), во втором — полный исходный текст. Но в обоих случаях
последующая установка будет одной и той же.

### Установка на Windows

1. Запустите `bootstrap.bat`. Скрипт создаст файл `c-plus-plus.conf.bat`,
   в котором предложит указать используемый компилятор C++.
2. Укажите в файле `c-plus-plus.conf.bat` ваш любимый компилятор C++
   (установите переменную среды `CPPLINEE` с префиксом командной строки,
   при желании, с опциями типа `-O3`, `-Wall` и др.; если необходимо,
   установите там же переменную `PATH`).
2. Запустите `bootstrap.bat` ещё раз для сборки компилятора. По умолчанию,
   скрипт также запустит полный набор автоматических тестов, что может
   потребовать несколько десятков минут (в зависимости от машины и компилятора
   C++). Для запуска без тестов выполните `bootstrap.bat --no-tests`.
3. Добавьте появившийся каталог `bin` к списку каталогов переменной среды `PATH`.
4. Можно использовать команды `srmake` или `srefc` для компиляции программ
   на Простом Рефале. Об использовании компилятора — см. раздел 5 [руководства
   пользователя](doc/manul.pdf) (**данное руководство несколько устарело**).

### Установка на UNIX-like (Linux, macOS, Cygwin, MinGW)

Установка аналогична установке на Windows с тем отличием, что в конфигурационном
файле по умолчанию указан GCC.

1. Запустите `bootstrap.sh` для сборки компилятора. Будет выполнена сборка для
   компилятора GCC и запуск всех тестов. Для пропуска тестов используйте
   `bootstrap.sh --no-tests`. В обоих случаях будет создан конфигурационный
   файл `c-plus-plus.conf.sh`, в котором по умолчанию будет указан GCC.
2. Если хотите использовать другой компилятор C++, подредактируйте файл
   `c-plus-plus.conf.sh` и, если надо, перезапустите сборку.
3. Добавьте появившийся каталог `bin` к списку каталогов переменной среды `PATH`.
4. Можно использовать команды `srmake` или `srefc` для компиляции программ
   на Простом Рефале. Об использовании компилятора — см. раздел 5 [руководства
   пользователя](doc/manul.pdf) (**данное руководство несколько устарело**).

## Лицензия

Компилятор распространяется по двухпунктной лицензии BSD с оговоркой
относительно компонентов стандартной библиотеки и рантайма — их можно
распространять в бинарной форме без указания копирайта. При отсутствии данной
оговорки для скомпилированных программ пришлось бы указывать копирайт самого
компилятора, что неразумно.

[1]: https://github.com/Mazdaywik/simple-refal-distrib.git
[2]: https://github.com/Mazdaywik/simple-refal.git
[3]: http://www.botik.ru/pub/local/scp/refal5/
[4]: doc/historical/note000.txt
[5]: http://refal.net/~belous/refal2-r.htm
