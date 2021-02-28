from django.contrib.auth.models import User
from django.db import models


class Account(models.Model):
    user = models.OneToOneField(User, on_delete=models.DO_NOTHING)
    public_key = models.CharField(max_length=56, unique=True)
    secret = models.CharField(max_length=56)


class Payment(models.Model):
    source = models.ForeignKey(Account, on_delete=models.DO_NOTHING, related_name='sent_payments')
    destination = models.ForeignKey(Account, on_delete=models.DO_NOTHING, related_name='received_payments')
    description = models.CharField(max_length=1024, null=True)
    amount = models.DecimalField(max_digits=20, decimal_places=2)
    transaction_url = models.TextField(null=True)
