from django.db import models

# Create your models here.
class class_contents(models.Model):
    keyword = models.CharField(max_length=200)
    content = models.TextField()
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()

class Area(models.Model):
    ID = models.SmallIntegerField(null=False, primary_key=True)
    Area = models.CharField(max_length=6)
    Area_detail = models.CharField(max_length=5)
    address_code = models.CharField(max_length=10)
    Weather_forecast_code = models.CharField(max_length=8)
    Temperature_code = models.CharField(max_length=8)
    X = models.DecimalField(max_digits=10, decimal_places=6)
    Y = models.DecimalField(max_digits=10, decimal_places=6)
    
class Temperature(models.Model):
    ID = models.SmallIntegerField(null=False, primary_key=True)
    Date = models.CharField(max_length=8)
    regId = models.CharField(max_length=8)
    taMin3 = models.SmallIntegerField()
    taMax3 = models.SmallIntegerField()
    taMin4 = models.SmallIntegerField()
    taMax4 = models.SmallIntegerField()
    taMin5 = models.SmallIntegerField()
    taMax5 = models.SmallIntegerField()
    taMin6 = models.SmallIntegerField()
    taMax6 = models.SmallIntegerField()
    taMin7 = models.SmallIntegerField()
    taMax7 = models.SmallIntegerField()
    taMin8 = models.SmallIntegerField()
    taMax8 = models.SmallIntegerField()
    taMin9 = models.SmallIntegerField()
    taMax9 = models.SmallIntegerField()
    taMin10 = models.SmallIntegerField()
    taMax10 = models.SmallIntegerField()


class EventModel(models.Model):
    ename = models.CharField(max_length=100)  # 이벤트 이름 필드
    edate_s = models.CharField(max_length=10)
    edate_e = models.CharField(max_length=10)
    edesc = models.TextField()# 이벤트 설명 필드
    user_id = models.CharField(max_length=20)
    def __str__(self):
        return self.ename

class today_weather(models.Model):
    Date = models.CharField(max_length=8)
    information = models.CharField(max_length=10)
    value = models.FloatField()


class Restaurant(models.Model):
    rank = models.CharField(max_length=1, unique=False)
    information = models.CharField(max_length=2)
    title = models.CharField(max_length=20)
    address = models.CharField(max_length=50)

class Travel(models.Model):
    rank = models.CharField(max_length=1, unique=False)
    title = models.CharField(max_length=20)
    address = models.CharField(max_length=50)

