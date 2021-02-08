from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import viewsets, status

from api.serializers import RegistrationSerializer
from ledger.core import Gateway

# Create your views here.
# Global variable used for the sake of simplicity.
# In real life, you'll be using your own interface to a data store
# of some sort, being caching, NoSQL, LDAP, external API or anything else
users = {
    1: user(username='jorge23', password='jegm.2310', first_name='jorge', last_name='minguer'),
    2: user(username='alexistuz', password='1234', first_name='allexis', last_name='tuz'),
    3: user(username='omarkhd', password='secr3t', first_name='Omar', last_name='Cornejo'),
}


class GatewayViewSet(viewsets.ViewSet):
    # Required for the Browsable API renderer to have a nice form.
    serializer_class = serializers.RegistrationSerializer

    def list(self, request):
        serializer = serializers.RegistrationSerializer(
            instance=users.values(), many=True)
        return Response(serializer.data)

    def create(self, request):
        serializer = serializers.RegistrationSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            user.id = get_next_user_id()
            user[user.id] = user
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def retrieve(self, request, pk=None):
        try:
            user = users[int(pk)]
        except KeyError:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except ValueError:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        serializer = serializers.RegistrationSerializer(instance=user)
        return Response(serializer.data)

    def update(self, request, pk=None):
        try:
            user = users[int(pk)]
        except KeyError:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except ValueError:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        serializer = serializers.RegistrationSerializer(
            data=request.data, instance=user)
        if serializer.is_valid():
            user = serializer.save()
            users[user.id] = user
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def partial_update(self, request, pk=None):
        try:
            user = users[int(pk)]
        except KeyError:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except ValueError:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        serializer = serializers.RegistrationSerializer(
            data=request.data,
            instance=user,
            partial=True)
        if serializer.is_valid():
            user = serializer.save()
            users[user.id] = user
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def destroy(self, request, pk=None):
        try:
            user = users[int(pk)]
        except KeyError:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except ValueError:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        del users[users.id]
        return Response(status=status.HTTP_204_NO_CONTENT)