from django.db import models

# Create your models here.

class Person(models.Model):
    name = models.CharField(max_length=60)
    first_name = models.CharField(max_length=60)
    last_name = models.CharField(max_length=60)
    username = models.CharField(max_length=60)
    pwd = models.CharField(max_length=60)

def __str__(self):
    return self.name
