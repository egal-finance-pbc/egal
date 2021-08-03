from rest_framework import serializers


class SignUp(serializers.Serializer):
    first_name = serializers.CharField(max_length=24)
    last_name = serializers.CharField(max_length=24)
    username = serializers.CharField(max_length=12)
    phone_number = serializers.CharField(min_length=10)
    passwcode = serializers.CharField(min_length=12)

    def create(self, validated_data):
        pass

    def update(self, instance, validated_data):
        pass


class PaymentSerializer(serializers.Serializer):
    destination = serializers.CharField(max_length=56)
    description = serializers.CharField(max_length=28, required=False)
    amount = serializers.DecimalField(max_digits=None, decimal_places=2)

    def create(self, validated_data):
        pass

    def update(self, instance, validated_data):
        pass


class AccountQuerySerializer(serializers.Serializer):
    q = serializers.CharField(min_length=3, max_length=512)

    def create(self, validated_data):
        pass

    def update(self, instance, validated_data):
        pass
