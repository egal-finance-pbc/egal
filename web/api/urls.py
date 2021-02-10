from django.urls import path
from rest_framework.authtoken import views as fviews

from . import views

urlpatterns = [
    path('accounts/', views.Accounts.as_view()),
    path('accounts/tokens/', fviews.obtain_auth_token)
]
