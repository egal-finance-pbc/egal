from django.contrib.auth.models import User
from django.db import models


class Account(models.Model):
    user = models.OneToOneField(User, on_delete=models.DO_NOTHING)
    public_key = models.CharField(max_length=56, unique=True)
    secret = models.CharField(max_length=56)
