# HW-7. "ArgoCD для Helm-деплою"

## 🎯 Мета

 - Розгорнути ArgoCD у Kubernetes через Terraform;
 - Створити Git-репозиторій з Helm-деплоєм (MLflow);
 - Створити ArgoCD Application, який автоматично підхопить цей застосунок;
 - Переконатися, що кластер розгортає поди автоматично з Git.

## 1. Завдання: розгорніть ArgoCD через Terraform

### 1.1. Підключення до k8s кластера

В цій роботі було вирішено використати `minikube` замість `AWS`. Це додасть більше практичного досвіду у роботі з різними іниструментами.

1. Отримуємо список доступних конфігурацій у `kubectl`
```bash
kubectl config get-clusters
```
2. Активуємо локальний minicube конфіг (імʼя конфігу беремо з виводу попередньої команди)
```bash
kubectl config use-context amd2-minikube
```
3. Перевіряємо наявність нодів
```bash
kubectl get nodes
```
Бачимо вивід команди:
```
NAME       STATUS   ROLES           AGE     VERSION
minikube   Ready    control-plane   3h17m   v1.34.0
```
K2s кластер піднятий і підлючений до `kubectl`, все готово до подальшої роботи.


### 1.2. Запуск ArgoCD

Варто зазначити, всі подальші команди виконуємо з директорії `./goit-mlops/terraform/minikube/argocd`

#### 1.2.1. Ініціалізуємо `terraform` проєкт
```bash
terraform init
```
#### 1.2.2. Встановлюємо `ArgoCD` додаток через `helm`. При встановленні ігноруємо запуск апплікай, щоб уникнути помилок синхронізації.
```bash
terraform apply -var="init_argocd_only=true"
```
Можна подивитися на запущені поди в неймспейсі `infra-tools` (в цьому неймспейсі ми запустили `ArgoCD`)
```bash
kubectl get pods -n infra-tools
```
#### 1.2.3. Запускаємо додатки в `ArgoCD`
```bash
terraform apply
```
В якості підказок вкінці виконання команди отримаємо маленьку шпаргалку
```
...
Outputs:

argocd_login = "admin"
argocd_password = "kubectl -n infra-tools get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d ; echo"
argocd_port_forward = "kubectl port-forward svc/argocd-server -n infra-tools 8080:80"
```
#### 1.2.4. Прокидаємо порт 80 від `ArgoCD` на наш `localhost:8080`
```bash
kubectl port-forward svc/argocd-server -n infra-tools 8080:80
```
#### 1.2.5. Дізнаємося пароль адміна
```bash
kubectl -n infra-tools get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d ; echo
```
#### 1.2.6. Відкриваємо `ArgoCD` GUI в нашому браузері за адресою [http://localhost:8080](http://localhost:8080)

## 2. Завдання: створіть окремий Git-репозиторій з Helm-деплоєм

Створено git-репозиторій [https://github.com/maximus-ms/goit-argo.git](https://github.com/maximus-ms/goit-argo) зі спеціальною гілкою [hw-lesson-7](https://github.com/maximus-ms/goit-argo/tree/hw-lesson-7) саме для виконання цоьго домашнього завдання.

В git-репозиторії у віповідній гілці додано апплікації `demo-nginx` та `mlflow`.

### 2.1. Перевіримо порти цих апплікацій (використовуємо неймспейс `application`)
```bash
kubectl get service -n application
```
Отирмали вивід:
```bash
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
demo-nginx   ClusterIP   10.106.165.104   <none>        80/TCP    146m
mlflow       ClusterIP   10.110.0.167     <none>        80/TCP    137m
```
### 2.2. Прокинемо порти до наших застосунків

**Nginx:**
```bash
kubectl port-forward -n application deployment/demo-nginx 8800:80
```
**MLFlow:**
```bash
kubectl port-forward -n application svc/mlflow 8880:80
```