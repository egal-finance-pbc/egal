# Generated by Django 3.1.3 on 2021-08-17 19:17

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ledger', '0002_payment'),
    ]

    operations = [
        migrations.AddField(
            model_name='account',
            name='phone',
            field=models.CharField(default='', max_length=15),
        ),
    ]
