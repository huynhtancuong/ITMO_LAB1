

str = "US{} = UltrasonicSensor(INPUT_{})"

for i in range(4, 16+1+4):
    print(str.format(i, i))

US_count = 4
angle = 0

while angle<=90:
    print("{}:US{},".format(90-angle, US_count))
    angle+=180/16
    US_count+=1

angle = -10
while angle>=-90:
    print("{}:US{},".format(angle, US_count))
    angle-=180/16
    US_count+=1
