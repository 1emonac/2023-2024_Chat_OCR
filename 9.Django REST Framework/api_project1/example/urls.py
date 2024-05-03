from django.urls import path
from example.views import (helloAPI, HelloAPI, booksAPI, bookAPI, BookAPI, BooksAPI, 
                           BooksAPIMixins, BookAPIMixins, BooksAPIGenerics, BookAPIGenerics, 
                           BookViewSet)

from rest_framework import routers

# urlpatterns = [
#     path("hello/", helloAPI),
#     path("cbv/hello/", HelloAPI.as_view()),
#     path("fbv/books/", booksAPI), # 함수형 뷰의 booksAPI와 연결
#     path("fbv/book/<int:bid>/", bookAPI), # 함수형 뷰의 bookAPI와 연결
#     path("cbv/books/", BooksAPI.as_view()),
#     path("cbv/book/<int:bid>/", BookAPI.as_view()),
#     path("mixin/books/", BooksAPIMixins.as_view()),
#     path("mixin/book/<int:bid>/", BookAPIMixins.as_view()),
#     path("generic/books/", BooksAPIGenerics.as_view()),
#     path("generic/book/<int:bid>/", BookAPIGenerics.as_view()),
# ]

router = routers.SimpleRouter()
router.register("books", BookViewSet)

urlpatterns = router.urls