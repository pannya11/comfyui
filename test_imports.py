import importlib, sys
mods = ["einops","safetensors","huggingface_hub","torch","torchvision"]
errs = 0
for m in mods:
    try:
        importlib.import_module(m)
        print("OK:", m)
    except Exception as e:
        print("ERR:", m, "->", e)
        errs += 1
if errs:
    sys.exit(2)
print("ALL IMPORTS OK")
