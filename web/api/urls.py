from django.urls import path
from rest_framework.authtoken import views as fviews

from . import views

urlpatterns = [
    path('accounts/', views.Accounts.as_view()),
    path('accounts/<str:pubkey>/', views.Account.as_view()),
    path('tokens/', fviews.obtain_auth_token),
    path('me/', views.Me.as_view()),
]
