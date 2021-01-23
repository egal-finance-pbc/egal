from django.contrib import admin

from . import models


class AccountAdmin(admin.ModelAdmin):
    list_display = ('public_key', 'user')


admin.site.register(models.Account, AccountAdmin)
