from rest_framework import serializers
from todo.models import Todo

class TodoSimpleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Todo
        fields = ("id", "title", "complete", "important")

class TododetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Todo
        fields = ("id", "title", "description", "created", "complete", "important")

class TodoAPISerializer(serializers.ModelSerializer):
    class Meta:
        model = Todo
        fields = ("title", "description", "important")

class TodoEditSerializer(serializers.ModelSerializer):
    class Meta:
        model = Todo
        fields = ("title", "description", "important")

class TodoCompleteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Todo
        fields = ("id", "title", "complete", "important")

class TodoFinishSerializer(serializers.ModelSerializer):
    class Meta:
        model = Todo
        fields = ("id", "title", "description", "created", "complete", "important")