from rest_framework import serializers
from .models import Player


class PlayerSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    points = serializers.IntegerField()
    username = serializers.CharField()
    password = serializers.CharField()

    def create(self, validated_data):
        """
        Create and return a new `Snippet` instance, given the validated data.
        """
        return Player.objects.create(**validated_data)

    def update(self, instance, validated_data):
        """
        Update and return an existing `Snippet` instance, given the validated data.
        """
        instance.points = validated_data.get('points', instance.points)
        instance.save()
        return instance

class PlayerGetSerializer(serializers.Serializer):
    points = serializers.IntegerField()
    username = serializers.CharField()


# tutorial


from django.contrib.auth.models import User

class UserSerializer(serializers.ModelSerializer):
    score = serializers.PrimaryKeyRelatedField(many=True, queryset=Player.objects.all())

    class Meta:
        model = User
        fields = ['id', 'username', 'score']