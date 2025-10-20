import os
import time
import pickle
from collections import defaultdict
from dotenv import load_dotenv
load_dotenv()

import mlflow
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway
from sklearn.datasets import load_iris
from sklearn.linear_model import SGDClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, log_loss

BEST_MODEL_PATH = "../best_model/model.pkl"

# Параметри
learning_rate_list = [0.01, 0.05, 0.1]  # Розширюємо діапазон для більшої різноманітності
epochs_list = [50, 100]
experiment_name = f"Iris Classification [{time.strftime('%Y-%m-%d %H:%M:%S')}]"

# Підключаємося до MLflow
mlflow.set_tracking_uri(os.environ["MLFLOW_TRACKING_URI"])

# Конфігуруємо PushGateway
PUSHGATEWAY_URL = os.environ.get("PUSHGATEWAY_URL")

# Створюємо експеримент
experiment_id = mlflow.create_experiment(experiment_name)
results = defaultdict(dict)

best_accuracy = 0
best_model = None

# Створюємо Gauge для accuracy та loss один раз для всіх запусків
registry = CollectorRegistry()
g_accuracy = Gauge('model_accuracy', 'Model Accuracy', ['run_id', 'learning_rate', 'epochs', 'experiment_id'], registry=registry)
g_loss = Gauge('model_loss', 'Model Loss', ['run_id', 'learning_rate', 'epochs', 'experiment_id'], registry=registry)

# Завантажуємо Iris dataset
X, y = load_iris(return_X_y=True)

# Розділяємо на тренувальну та тестову вибірки з більшим test_size,
# щоб зменшити ймовірність отримання надто простих підвибірок
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.35, random_state=42
)

for learning_rate in learning_rate_list:
    for epochs in epochs_list:
        run_name = f"Learning Rate: {learning_rate}, Epochs: {epochs}"
        print("\n--------------------------------\n")
        print(f"🔍 Starting run: {run_name}")
        with mlflow.start_run(experiment_id=experiment_id, run_name=run_name):
            mlflow.log_param("learning_rate", learning_rate)
            mlflow.log_param("epochs", epochs)

            # Використовуємо SGDClassifier замість LogisticRegression, щоб мати можливість встановити learning_rate
            model = SGDClassifier(
                loss='log_loss',  # для логістичної регресії
                learning_rate='constant',
                eta0=learning_rate,  # встановлюємо learning_rate
                max_iter=epochs,
                random_state=42
            )
            model.fit(X_train, y_train)

            y_pred = model.predict(X_test)
            y_proba = model.predict_proba(X_test)

            acc = accuracy_score(y_test, y_pred)
            loss = log_loss(y_test, y_proba)

            mlflow.log_metric("accuracy", acc)
            mlflow.log_metric("loss", loss)
            
            # Додаємо signature та input_example при реєстрації моделі
            mlflow.sklearn.log_model(model, name="model")
            
            # Пушимо метрики в PushGateway з міткою run_id
            
            # Записуємо значення з мітками
            run_id = mlflow.active_run().info.run_id
            g_accuracy.labels(run_id=run_id, learning_rate=str(learning_rate), epochs=str(epochs), experiment_id=str(experiment_id)).set(acc)
            g_loss.labels(run_id=run_id, learning_rate=str(learning_rate), epochs=str(epochs), experiment_id=str(experiment_id)).set(loss)
            
            # Відправляємо метрики в PushGateway
            try:
                # Використовуємо унікальне ім'я job, яке включає experiment_id
                job_name = f"iris_classification_{experiment_id}"
                push_to_gateway(PUSHGATEWAY_URL, job=job_name, registry=registry)
                print(f"✅ Metrics pushed to PushGateway with run_id: {run_id}")
            except Exception as e:
                print(f"❌ Failed to push metrics to PushGateway: {e}")

            results[acc] = {
                "learning_rate": learning_rate,
                "epochs": epochs,
                "accuracy": acc,
                "loss": loss,
            }
            print(f"✅ Run {run_name} completed, results: {results[acc]}")

            if acc > best_accuracy:
                best_accuracy = acc
                best_model = model


# Зберігаємо найкращу модель у локальну директорію
os.makedirs("best_model", exist_ok=True)
model_path = BEST_MODEL_PATH
with open(model_path, 'wb') as f:
    pickle.dump(best_model, f)

# Реєструємо найкращу модель в MLflow Model Registry
print("\n--------------------------------\n")
print("Реєстрація найкращої моделі в MLflow...")
print(f"* Найкраща модель: {best_model}")
print(f"* Найкраща точність: {best_accuracy}\n")
with mlflow.start_run(experiment_id=experiment_id, run_name="Best Model Registration", nested=True):
    # Логуємо найкращу точність як метрику
    mlflow.log_metric("best_accuracy", best_accuracy)
    
    # Зберігаємо параметри найкращої моделі
    best_params = results[best_accuracy]
    for param_name, param_value in best_params.items():
        if param_name not in ["accuracy", "loss"]:
            mlflow.log_param(param_name, param_value)
    
    # Логуємо саму модель з сигнатурою та прикладом
    model_info = mlflow.sklearn.log_model(best_model, name="best_model", registered_model_name="iris_classifier")
    
    # Додаємо теги до запуску
    mlflow.set_tag("best_model_path", model_path)
    mlflow.set_tag("model_type", type(best_model).__name__)
    
    print(f"✅ Модель успішно зареєстрована в MLflow Model Registry")
    print(f"📊 Model URI: {model_info.model_uri}")
    print(f"🔗 Для доступу до моделі: mlflow.sklearn.load_model('{model_info.model_uri}')")
