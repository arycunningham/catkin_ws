from gpiozero import Servo
from time import sleep

servo = Servo(13)

for x in range(6):
    servo.min()
    sleep(1.0)
    servo.mid()
    sleep(2.0)
    servo.max()
    sleep(1.0)
    print("Testing servo loop" + str(x))
print("Finished testing servo")