from django.contrib.auth.models import User
from django.db import models
# Create your models here.
class Player(models.Model):
    username = models.CharField(max_length=100, unique=True,blank=False, default="Anonymous")
    points = models.IntegerField(default=0)
    password = models.CharField(max_length=600)
    def __str__(self):
        return f"{self.username}+({self.points})"