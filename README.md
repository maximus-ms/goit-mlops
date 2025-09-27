# GoIT-MLOps
## HW. Lesson-3. «Контейнеризація ML-моделей»

### 1. Bash-скрипт для підготовки середовища

Підготували bash-скрипт, який перевіряє чи встановлені docker, docker-compouse, python (>=3.9), pip. Якщо пакет не встановлено або не задовільняє мінімальним вимогам по версії - встановлюю.
Всі зміни в системі логуються в файл `install.log`, також вкінці скрипт друкує версії всіх пакетів.

[install_dev_tools.sh](./install_dev_tools.sh)

### 2. Контейнеризація ML-сервісу

#### 2.1 Завантаження моделі
Скрипт [export_model.py](./export_model.py) завантажить модель mobilenet_v2 з дефолтними вагами та збереже її в файл `model.pt`

#### 2.2 Inference
Файл [inference.py](./inference.py) приймає на вхід імʼя файлу і проганаяє її через модель. На виході отримуємо 3 найбільш релевантні класи. Скрипт одразу адаптований під запуск в докері, очікується що юзер копіює файл в директорію, яка змонтована в докер за шляхом `/data`, тому вхідний параметр парситься, виокремлюється імʼя файлу і формується внутрішній шлях у вигляді `/data/<file_name>`. Приклад виконання скрипта ми побачимо вже в результаті запуску докер контейнера.

### 3. Створення Docker образів
#### 3.1 Fat-образ
Створюємо docker image на базі файлу [Dockerfile.fat](./Dockerfile.fat)
```bash
$ docker build -f Dockerfile.fat -t pythorch-inter-fat .
```
Запускаємо
```bash
$ docker run --rm -v ./data:/data pythorch-inter-fat cat.jpeg
🧠 Analyzing cat.jpeg...
🧠 Predicted 3 most relevant classes: [281, 282, 285]
```
#### 3.2 Slim-образ
Створюємо docker image на базі файлу [Dockerfile.slim](./Dockerfile.slim)
```bash
$ docker build -f Dockerfile.slim -t pythorch-inter-slim .
```
Запускаємо
```bash
$ docker run --rm -v ./data:/data pythorch-inter-slim cat.jpeg
🧠 Analyzing cat.jpeg...
🧠 Predicted 3 most relevant classes: [281, 282, 285]
```

### Аналіз
Підготуємо результати роботи і зберемо їх в окремому [репорті](./report.md).