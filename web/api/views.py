from rest_framework.views import APIView
from rest_framework.exceptions import APIException
from rest_framework import status


class Accounts(APIView):
    """
    View to manage a collection of accounts.
    """

    def post(self, request, fmt=None):
        raise APIException(code=status.HTTP_501_NOT_IMPLEMENTED)
