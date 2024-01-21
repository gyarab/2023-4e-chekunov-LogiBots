from django.shortcuts import render
from django.contrib.auth.models import User
# Create your views here.
from .serializers import PlayerSerializer, PlayerGetSerializer
from django.http import Http404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework import mixins
from rest_framework import generics
from rest_framework import permissions
from .models import Player
class PlayerList(APIView):
    """
    List all snippets, or create a new snippet.
    """
    def get(self, request, format=None):
        players = Player.objects.all().order_by('-points')
        serializer = PlayerGetSerializer(players, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = PlayerSerializer(data=request.data)
        if serializer.is_valid():

            if not Player.objects.filter(password=request.data['password']).exists():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)


            player = Player.objects.filter(password=request.data['password'])[0]
            print(player)
            player.username = request.data['username']
            player.points = request.data['points']
            player.save()
            print("update!")
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        print(request.data)
        print(serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class SinglePlayer(APIView):
    def get_object(self, passwd):
        try:
            print("takoj jest!")
            return Player.objects.get(password=passwd)
        except Player.DoesNotExist:
            raise Http404

    def get(self, request, passwd, format=None):
        snippet = self.get_object(passwd)
        serializer = PlayerGetSerializer(snippet)
        return Response(serializer.data)

class SnippetDetail(APIView):
    """
    Retrieve, update or delete a snippet instance.
    """


    def get(self, request, pk, format=None):
        snippet = self.get_object(pk)
        serializer = SnippetSerializer(snippet)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        snippet = self.get_object(pk)
        serializer = SnippetSerializer(snippet, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        snippet = self.get_object(pk)
        snippet.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)