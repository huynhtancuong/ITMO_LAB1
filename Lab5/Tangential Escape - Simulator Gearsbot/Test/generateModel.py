import json
import math

num_sensor = 16
angle_per_sensor = 180/num_sensor
radius = 10

a_file = open("18laserrange.json", "r")

listObj = []
listObj = json.load(a_file)

angle = 0

sample = listObj["components"][3]

# if len(listObj["components"]) > num_sensor+3:
#     for i in range(num_sensor+3, len(listObj["components"])):
#         listObj["components"].pop(i)

for i in range(num_sensor-len(listObj["components"])+3+1):
    listObj["components"].append(sample)

for i in range(3, num_sensor+3+1):
    listObj["components"][i]["position"][0] = -radius * math.cos(math.radians(angle))
    listObj["components"][i]["position"][2] = radius * math.sin(math.radians(angle))
    listObj["components"][i]["rotation"][1] = math.radians(angle)
    angle+=angle_per_sensor

print(len(listObj["components"]))
with open('json_data.json', 'w') as outfile:
    json.dump(listObj, outfile, indent=6)
