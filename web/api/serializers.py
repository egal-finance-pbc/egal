from rest_framework import serializers


class SignUp(serializers.Serializer):
    first_name = serializers.CharField(max_length=150)
    last_name = serializers.CharField(max_length=150)
    username = serializers.CharField(max_length=150)
    password = serializers.CharField(min_length=8)

    def create(self, validated_data):
        pass

    def update(self, instance, validated_data):
        pass
