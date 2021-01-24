from django.shortcuts import render
from rest_framework import viewsets

from .serializers import PersonSerializer
from .models import Person

class PersonViewSet(viewsets.ModelViewSet):
    queryset = Person.objects.all().order_by('name')
    serializer_class = PersonSerializer

