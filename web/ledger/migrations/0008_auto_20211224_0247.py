# Generated by Django 3.1.3 on 2021-12-24 02:47

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ledger', '0007_account_state'),
    ]

    operations = [
        migrations.AddField(
            model_name='account',
            name='maternal_surname',
            field=models.CharField(default='', max_length=24),
        ),
        migrations.AddField(
            model_name='account',
            name='names',
            field=models.CharField(default='', max_length=24),
        ),
        migrations.AddField(
            model_name='account',
            name='paternal_surname',
            field=models.CharField(default='', max_length=24),
        ),
    ]