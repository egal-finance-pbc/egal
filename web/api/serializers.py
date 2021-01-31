from rest_framework import serializers

from ledger.core import Gateway

class RegistrationSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ['first_name','last_name','username','password']
        extra_kwargs = {
                'password': {write_only:true}
        }

    def create(self, validated_data):
        user = User(
            first_name=validated_data['first_name']
            last_name=validated_data['last_name']
            username=validated_data['username']
        )
        user.set_password(validated_data['password'])
        user.save()
        return user

    def update(self, instance, validated_data):
        instance.first_name = validated_data.get('first_name', instance.first_name)
        instance.last_name = validated_data.get('last_name', instance.last_name)
        instance.username = validated_data.get('username', instance.username)
        instance.password = validated_data.get('password', instance.password)
        instance.save()
        return instance