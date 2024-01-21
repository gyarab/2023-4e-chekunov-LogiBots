from django.urls import path, include
from . import views

from rest_framework.urlpatterns import format_suffix_patterns
urlpatterns = [
    path('players/', views.PlayerList.as_view()),
    path('players/<str:passwd>', views.SinglePlayer.as_view()),
]
urlpatterns = format_suffix_patterns(urlpatterns)
