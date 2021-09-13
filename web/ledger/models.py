from django.contrib.auth.models import User
from django.db import models


class Account(models.Model):
    user = models.OneToOneField(User, on_delete=models.DO_NOTHING)
    public_key = models.CharField(max_length=56, unique=True)
    secret = models.CharField(max_length=56)
    phone = models.CharField(max_length=15, default='')
    city = models.CharField(max_length=60, default='')
    country = models.CharField(max_length=50, default='')
    photo = models.ImageField(upload_to='uploads/photos/', null=True, blank=True)

    @property
    def photo_url(self):
        """
        Return self.photo.url if self.photo is not None,
        'url' exist and has a value, else, return None.
        """
        if self.photo:
            return getattr(self.photo, 'url', None)
        return None


class Payment(models.Model):
    source = models.ForeignKey(Account, on_delete=models.DO_NOTHING, related_name='sent_payments')
    destination = models.ForeignKey(Account, on_delete=models.DO_NOTHING, related_name='received_payments')
    description = models.CharField(max_length=1024, null=True)
    amount = models.DecimalField(max_digits=20, decimal_places=2)
    date = models.DateField(auto_now_add=True)
    transaction_url = models.TextField(null=True)
