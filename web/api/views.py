from rest_framework import status
from rest_framework.exceptions import ParseError, APIException
from rest_framework.response import Response
from rest_framework.views import APIView

from ledger.core import Gateway, LedgerError
from . import serializers


class Accounts(APIView):
    """
    View to manage a collection of accounts.
    """

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.ledger = Gateway()

    def post(self, request):
        payload = serializers.SignUp(data=request.data)
        if not payload.is_valid():
            raise ParseError()

        try:
            account = self.ledger.create_account(
                first_name=payload.validated_data['first_name'],
                last_name=payload.validated_data['last_name'],
                username=payload.validated_data['username'],
                password=payload.validated_data['password'],
            )
            return Response(data={
                'id': account.id,
                'public_key': account.public_key,
                'username': account.user.username,
                'first_name': account.user.first_name,
                'last_name': account.user.last_name,
            }, status=status.HTTP_201_CREATED)

        except LedgerError as e:
            raise APIException(detail=e.message, code=status.HTTP_500_INTERNAL_SERVER_ERROR)
