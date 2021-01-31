from django.shortcuts import render
from rest_framework import viewsets
import json
from rest_framework.views import APIView
from django.http import HttpResponse

from api.serializers import RegistrationSerializer
from ledger.models import Account
from ledger.core import Gateway

# Create your views here.
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = RegistrationSerializer

class UserAPI(APIView):
	serializer = RegistrationSerializer

	def get(self, request, format=None):
		list = User.objects.all()
		response = self.serializer(list, many=True)

		return HttpResponse(json.dumps(response.data), content_type='application/json')
