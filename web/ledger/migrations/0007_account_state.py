# Generated by Django 3.1.3 on 2021-11-04 19:31

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ledger', '0006_account_saving_key'),
    ]

    operations = [
        migrations.AddField(
            model_name='account',
            name='state',
            field=models.CharField(default='', max_length=30),
        ),
    ]
