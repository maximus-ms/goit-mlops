import torch
from torchvision import transforms
from PIL import Image
import sys
import os

data_dir = "/data"

model = torch.jit.load("model.pt")
model.eval()

preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor()
])

def predict(image_path):
    image = Image.open(image_path).convert("RGB")
    input_tensor = preprocess(image).unsqueeze(0)
    with torch.no_grad():
        output = model(input_tensor)
        top_classes = output.softmax(dim=1)
        return (top_classes.topk(3).indices).tolist()[0]

if __name__ == "__main__":
    file_name = os.path.basename(sys.argv[1])
    full_path = os.path.join(data_dir, file_name)
    print(f"🧠 Analyzing {file_name}...")
    top_classes = predict(full_path)
    print(f"🧠 Predicted 3 most relevant classes: {top_classes}")
