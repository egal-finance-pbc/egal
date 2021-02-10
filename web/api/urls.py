from django.urls import path

from . import views

urlpatterns = [
    path('accounts/', views.Accounts.as_view()),
]
