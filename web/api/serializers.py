from rest_framework import serializers


class SignUp(serializers.Serializer):
    names = serializers.CharField(max_length=24)
    daddy_last_name = serializers.CharField(max_length=24)
    mom_last_name = serializers.CharField(max_length=24, required=False)
    username = serializers.CharField(min_length=6, max_length=12)
    password = serializers.CharField(min_length=8, max_length=12)
    phone = serializers.CharField(min_length=10, max_length=15)
    country = serializers.CharField(max_length=50)

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


class UserSerializer(serializers.Serializer):
    first_name = serializers.CharField(max_length=24)
    last_name = serializers.CharField(max_length=24)

    def create(self, validated_data):
        pass

    def update(self, instance, validated_data):
        pass


class AccountImageProfileSerializer(serializers.Serializer):
    photo = serializers.ImageField(max_length=254, required=False)

    def create(self, validated_data):
        pass

    def update(self, instance, validated_data):
        pass


class AccountUpdateSerializer(serializers.Serializer):
    phone = serializers.CharField(min_length=10, max_length=15)
    city = serializers.CharField(max_length=60)
    country = serializers.CharField(max_length=50)
    state = serializers.CharField(max_length=30)

    def create(self, validated_data):
        pass

    def update(self, instance, validated_data):
        pass
