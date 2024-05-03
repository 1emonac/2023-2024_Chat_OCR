from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework.generics import get_object_or_404

from todo.models import Todo
from todo import serializers

# # Create your views here.
class TodoAPI(APIView):
    def get(self, request):
        todo = Todo.objects.filter(complete=False)
        serializer = serializers.TodoSimpleSerializer(todo, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    # post 요청으로 전달받은 데이터를 시리얼라이저에서 유효성 검사를 하고 todo 리스트 생성 데이터 추가
    def post(self, request):
        serializer = serializers.TodoAPISerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
# CBV 버전
class TododetailAPI(APIView):
    def get(self, request, id):
        todo = get_object_or_404(Todo, id=id)
        serializer = serializers.TododetailSerializer(todo)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def put(self, request, id):
        todo = Todo.objects.get(id=id)
        serializer = serializers.TodoEditSerializer(todo, data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class TodoCompleteAPI(APIView):
    def get(self, request):
        todo = Todo.objects.filter(complete=True)
        serializer = serializers.TodoSimpleSerializer(todo, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class TodoFinishAPI(APIView):
    def get(self, request, id):
        todo = get_object_or_404(Todo, id=id)
        todo.complete = True
        todo.save()
        serializer = serializers.TodoFinishSerializer(todo)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
# FBV 버전
# @api_view(["GET"]) # decorator 데코레이터
# def TodoAPI(request):
#     if request.method == "GET":
#        todos = Todo.objects.filter(complete=False)

#        serializer = serializers.TodoSimpleSerializer(todos, many=True)
#        return Response(serializer.data, status=status.HTTP_200_OK)

#     elif request.method == "POST":
#         serializer = serializers.TodoAPISerializer(data = request.data)

#         if serializer.is_valid():
#             serializer.save()
#             return Response(serializer.data, status=status.HTTP_201_CREATED)

#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# # FBV 버전
# def TododetailAPI(request, id):
#     todo = get_object_or_404(Todo, id=id)
#     serializer = serializers.TododetailSerializer(todo)
#     return Response(serializer.data, status=status.HTTP_200_OK)

