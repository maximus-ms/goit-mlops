# HW-10 "Автоматизоване тренування моделей"

## 🎯 Мета
- Створити Step Function в AWS, яка запускає пайплайн тренування з кількох кроків;
- Створити Lambda-функції для окремих етапів (наприклад, валідація та логування);
- Розгорнути інфраструктуру через Terraform;
- Налаштувати GitLab CI для автоматичного запуску Step Function при push.


## 1. Завдання: Створити Lambda-функції

Створено відповідні файли:
- [validate.py](./terraform/lambda/validate.py)
- [train.py](./terraform/lambda/train.py)
- [log_metrics.py](./terraform/lambda/log_metrics.py)

А також відповідні архіви:
```bash
zip log_metrics.zip log_metrics.py
zip train.zip train.py
zip validate.zip validate.py
```
Тож маємо файли в директорії `./terraform/lambda`
```bash
log_metrics.py
log_metrics.zip
train.py
train.zip
validate.py
validate.zip
```

## 2. Завдання: Написати Terraform конфігурацію

Маємо файл з `Terrarorm` конфігурацією
-  [main.tf](./terraform/main.tf)

Запуск створення інфраструктури в `AWS` задопомогою `Terraform`
```bash
terraform init
terraform apply
```

### Перевіримо створені ресурси на AWS

Загальний список лямбда-функцій

![Lambda functions](./images/aws_lambda_functions.png)

Переглянемо функцію `trainModel`

![trainModel](./images/aws_lambda_train.png)

Відкриємо нашу step-функцію `MLOpsPipeline`

![MLOpsPipeline](./images/aws_step_function.png)

Пробуємо запустити пайплайн вручну і перевіримо що все працює. Звертаємо увагу, що `State input` в даному випадку пустий.

![MLOpsPipeline manual trigger](./images/aws_step_function_manual_run.png)

## 3. Завдання: Налаштувати GitLab CI

Маємо файл для конфігурації CI/CD в 
- [.gitlab-ci.yml](./.gitlab-ci.yml)

Створимо [GitLab репозиторій](https://gitlab.com/goit-mds2/mlops-hw10) і запушимо в нього цей файл.

В репозиторії бачимо, що одразу нам додався пайплайн, але він завершився з помилкою

![GitLab create pipeline](./images/gitlab_first_commit.png)

Причина помилки: відсутність ключів доступу до AWS

![GitLab no credantials](./images/gitlab_no_credentials.png)

Тому додаємо змінні `AWS_ACCESS_KEY_ID`, `AWS_ACCESS_KEY_ID` до проєкту

![GitLab variables](./images/gitlab_variables.png)

Пушаємо ще одни коміт в `GitLab` репозиторій і перевіряємо роботу CI/CD

![GitLab good flow](./images/gitlab_good_flow.png)

Перевіряємо результати роботи на AWS, бачимо 2 запуски нашого пайплайну. Перший, той що ми робили вручну одразу після створення. Другий - автоматично запущений з GitLab.

![AWS good flow](./images/aws_cicd_run.png)

Відкриємо детальну інформацію про запуск що було ініційовано автоматично і перевіримо його вхідні параметри.

![AWS pipeline input data](./images/aws_pipeline_input_data.png)