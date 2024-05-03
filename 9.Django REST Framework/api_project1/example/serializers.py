from rest_framework import serializers
from example.models import Book

class BookSerializer(serializers.ModelSerializer):
    class Meta: # 모델 폼 만드는 것과 같음
        model = Book
        fields = ["bid", "title", "author", "category", "pages", "price", "published_date", "description"]