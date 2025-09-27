import torch
import torchvision.models as models


model = models.mobilenet_v2(weights="DEFAULT")
model.eval()

dummy_input = torch.rand(1, 3, 224, 224)

traced_model = torch.jit.trace(model, dummy_input)

traced_model.save("./model.pt")
print("✅ Model saved to model.pt")
