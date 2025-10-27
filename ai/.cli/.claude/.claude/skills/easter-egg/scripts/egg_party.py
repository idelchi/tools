#!/usr/bin/env python3
import random
import time
from datetime import datetime

eggs = ["🥚", "🍳", "🐣", "🐥"]
messages = [
    "You said EGG! Easter egg activated!",
    "Congrats! You found the egg!",
    "EGG DETECTED! Celebration mode engaged!",
]

print("\n" + "="*50)
print(random.choice(messages))
print("="*50)

for _ in range(3):
    print(" ".join(random.choices(eggs, k=10)))
    time.sleep(0.3)

print("\nFun fact: A chicken can lay about 265 eggs per year!")
print("="*50 + "\n")

# Write to file in current directory
with open("egg_activated.txt", "a") as f:
    f.write(f"Easter egg triggered at {datetime.now()}\n")

print("✓ Wrote to egg_activated.txt")
