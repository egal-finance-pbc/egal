from rest_framework import status
from rest_framework.exceptions import (
    ParseError, APIException, ValidationError, NotFound, PermissionDenied
)
from rest_framework.response import Response
from rest_framework.throttling import AnonRateThrottle
from rest_framework.views import APIView

from conellas.logging import get_logger
from ledger.core import Gateway, LedgerError
from . import serializers

SIGNUP_THROTTLE_SCOPE = 'signup'

logger = get_logger(__name__)


class SignUpThrottle(AnonRateThrottle):
    rate = '60/minute'
    scope = SIGNUP_THROTTLE_SCOPE


class Accounts(APIView):
    """View to manage a collection of accounts."""

    throttle_classes = [SignUpThrottle]
    throttle_scope = SIGNUP_THROTTLE_SCOPE

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.ledger = Gateway()

    def get(self, request):
        if request.user.is_anonymous:
            raise PermissionDenied()

        payload = serializers.AccountQuerySerializer(data=request.query_params)
        if not payload.is_valid():
            raise ParseError(payload.errors)

        accounts = self.ledger.search_accounts(payload.validated_data['q'])
        return Response(data=[{
            'username': a.user.username,
            'names': a.names,
            'paternal_surname': a.paternal_surname,
            'maternal_surname': a.maternal_surname,
            'public_key': a.public_key,
            'saving_key': a.saving_key,
            'phone': a.phone,

        } for a in accounts])

    def post(self, request):
        logger.info('Received signup request', remote_addr=request.META.get('REMOTE_ADDR'),
                    x_forwarded_for=request.META.get('HTTP_X_FORWARDED_FOR'))

        payload = serializers.SignUp(data=request.data)
        if not payload.is_valid():
            raise ParseError(payload.errors)

        try:
            account = self.ledger.create_account(
                names=payload.validated_data['names'],
                paternal_surname=payload.validated_data['paternal_surname'],
                maternal_surname=payload.validated_data.get('maternal_surname'),
                username=payload.validated_data['username'],
                password=payload.validated_data['password'],
                phone=payload.validated_data['phone'],
                country=payload.validated_data['country'],
            )
            return Response(status=status.HTTP_201_CREATED)

        except LedgerError as e:
            raise APIException(detail=e.message, code=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def put(self, request, pubkey=None):
        if request.user.is_anonymous:
            raise PermissionDenied()

        photo_payload = serializers.AccountImageProfileSerializer(data=request.data)
        if not photo_payload.is_valid():
            raise ParseError(photo_payload.errors)

        try:
            account = self.ledger.get_account(pubkey)
            if account is None:
                raise NotFound()

            if account.user.id != request.user.id:
                raise PermissionDenied()

            account = self.ledger.uploading_photo(
                pubkey,
                photo=photo_payload.validated_data.get('photo')
            )
            print(account)
            return Response(status=status.HTTP_200_OK)

        except LedgerError as e:
            raise APIException(detail=e.message, code=status.HTTP_400_BAD_REQUEST)


class Account(APIView):
    """View to manage a single account resource."""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.ledger = Gateway()

    def get(self, request, pubkey=None):
        if request.user.is_anonymous:
            raise PermissionDenied()

        if not pubkey:
            raise ValidationError()

        try:
            account = self.ledger.get_account(pubkey)
            if account is None:
                raise NotFound()

            if account.user.id != request.user.id:
                raise PermissionDenied()

            balance = self.ledger.get_account_balance(pubkey)
            return Response(data={
                'balance': balance,
            })

        except LedgerError as e:
            raise APIException(detail=e.message)

    def put(self, request, pubkey=None):
        if request.user.is_anonymous:
            raise PermissionDenied()

        account_payload = serializers.AccountUpdateSerializer(data=request.data)
        if not account_payload.is_valid():
            raise ParseError(account_payload.errors)

        try:
            account = self.ledger.get_account(pubkey)
            if account is None:
                raise NotFound()

            if account.user.id != request.user.id:
                raise PermissionDenied()

            account = self.ledger.update_account(
                pubkey,
                city=account_payload.validated_data['city'],
                state=account_payload.validated_data['state'],
            )
            print(account)
            return Response(status=status.HTTP_200_OK)

        except LedgerError as e:
            raise APIException(detail=e.message, code=status.HTTP_400_BAD_REQUEST)


class Me(APIView):
    """View to inspect user information."""

    def get(self, request):
        if request.user.is_anonymous:
            raise PermissionDenied()

        account = getattr(request.user, 'account')
        if account is None:
            raise NotFound()

        return Response(data={
            'username': request.user.username,
            'names': account.names,
            'paternal_surname': account.paternal_surname,
            'maternal_surname': account.maternal_surname,
            'public_key': account.public_key,
            'saving_key': account.saving_key,
            'phone': account.phone,
            'country': account.country,
            'city': account.city,
            'state': account.state,
            'photo': account.photo_url,
        })


class Payments(APIView):
    """Endpoint to manage payments."""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.ledger = Gateway()

    def get(self, request):
        if request.user.is_anonymous:
            raise PermissionDenied()

        payments = self.ledger.search_payments(request.user.account)
        return Response(data=[{
            'amount': str(p.amount),
            'description': p.description,
            'date': p.date.strftime("%d-%b-%Y"),
            'source': {
                'username': p.source.user.username,
                'names': p.source.names,
                'paternal_surname': p.source.paternal_surname,
                'maternal_surname': p.source.maternal_surname,
                'public_key': p.source.public_key,
            },
            'destination': {
                'username': p.destination.user.username,
                'names': p.destination.names,
                'paternal_surname': p.destination.paternal_surname,
                'maternal_surname': p.destination.maternal_surname,
                'public_key': p.destination.public_key,
            },
        } for p in payments])

    def post(self, request):
        if request.user.is_anonymous:
            raise PermissionDenied()

        payload = serializers.PaymentSerializer(data=request.data)
        if not payload.is_valid():
            raise ParseError(payload.errors)

        try:
            payment = self.ledger.make_payment(
                src=request.user.account,
                dst=payload.validated_data['destination'],
                amount=payload.validated_data['amount'],
                desc=payload.validated_data.get('description'),
            )
            return Response(headers={
                'Location': payment.transaction_url,
            }, status=status.HTTP_201_CREATED)

        except LedgerError as e:
            raise APIException(detail=e.message)
