---
name: sources-java-jars-reading
description: Поиск и чтение исходного кода из .sources/ (внутренние библиотеки EPK)
version: 1.0.0
triggers:
  - импорты ru.alfabank.epk.*
  - импорты ru.alfa.epk.*
  - поиск в .sources/
  - исходный код библиотеки
  - анализ зависимостей
auto_apply: true
---

# Навык: Чтение исходного кода из .sources

## Назначение
Поиск и чтение исходного кода классов, которые отсутствуют в `src/main/java/`, но находятся в библиотеках (jar-файлах) в папке `.sources/`.

## Автоматическое применение
**Этот навык должен применяться АВТОМАТИЧЕСКИ без явного запроса пользователя в следующих ситуациях:**

### 1. При чтении кода с импортами внутренних библиотек EPK
Когда ты читаешь файл (через `read_file`) и встречаешь импорты **`ru.alfabank.epk.*`**, **`ru.alfa.epk*`** которые отсутствуют в `src/main/java/` проекта:

**Искать в .sources/:**
- `import ru.alfabank.epk.*` — внутренние классы платформы EPK из подключаемых библиотек (epk-common-lib, epk-subject-lib, etc.)

**НЕ искать в .sources/ (внешние библиотеки):**
- `import org.*` (Apache Commons, Spring, Hibernate, etc.)
- `import com.*` (внешние библиотеки)
- `import net.*` (Guava, etc.)
- `import io.*` (Netty, etc.)
- Эти классы не нужно искать в .sources/

**Действие:** Если класс из импорта `ru.alfabank.epk.*`, `ru.alfa.epk.*` отсутствует в `src/main/java/` — автоматически искать его в `.sources/` через `glob`.

### 2. При анализе зависимостей проекта
Когда анализируешь `build.gradle`, `pom.xml`, `gradle.properties` и видишь зависимости.

**Действие:** Предложить поискать исходный код этих зависимостей в `.sources/`.

### 3. При явном запросе пользователя
- "найди в .sources"
- "посмотри исходный код библиотеки"
- "где класс X"
- и т.п.

## Инструкция по поиску

### Шаг 1: Извлечь информацию о классе
Из импорта определить:
- **Полное имя класса** (например: `com.example.library.MyService`)
- **Пакет** (например: `com/example/library/`)
- **Имя файла** (например: `MyService.java`)

### Шаг 2: Поиск в папке .sources
Искать файл одним из способов:

**Важно:** При использовании `glob` обязательно указывать `file_filtering_options: {respect_git_ignore: false}`, так как `.sources/` добавлен в `.gitignore`.  
**Способ А — Прямой поиск по пути:**
```
.sources/**/com/example/library/MyService.java
glob: pattern=".sources/**/com/example/library/MyService.java", file_filtering_options: {respect_git_ignore: false}  
```

**Способ Б — Поиск по имени файла:**
```
.sources/**/MyService.java
glob: pattern=".sources/**/MyService.java", file_filtering_options: {respect_git_ignore: false}   
```

**Способ В — Поиск в распакованных jar:**
Если в `.sources/` есть папки с названиями jar-файлов:
```
.sources/<имя-jar>/com/example/library/MyService.java
glob: pattern=".sources/<имя-jar>/com/example/library/MyService.java", file_filtering_options: {respect_git_ignore: false}   
```

### Шаг 3: Прочитать найденный файл
Использовать команду чтения файла для получения исходного кода.

### Шаг 4: Если файл не найден
1. Проверить, существует ли папка `.sources/` в корне проекта
2. Сообщить пользователю, что класс не найден
3. Предложить пользователю добавить sources.jar нужной библиотеки в `.sources/`

## Примеры использования

### Пример 1: Поиск по полному пути
Класс: `org.apache.commons.lang3.StringUtils`
Путь для поиска: `.sources/**/org/apache/commons/lang3/StringUtils.java`

### Пример 2: Поиск по имени
Класс: `com.mycompany.lib.DataProcessor`
Путь для поиска: `.sources/**/DataProcessor.java`

## Команды для использования
- `glob` — поиск файлов по паттерну
- `read_file` — чтение содержимого найденного файла
- `list_directory` — просмотр содержимого `.sources/`

## Важные замечания
- Искать нужно именно `.java` файлы, а не `.class`
- Если в `.sources/` лежат jar-файлы — предложить пользователю распаковать их
- Приоритет поиска: точное совпадение пути → поиск по имени файла
