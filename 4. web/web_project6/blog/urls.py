from django.urls import path
from . import views

app_name = "blog"

urlpatterns = [
    path("", views.index, name="post_list"), # FBV 방식 게시글 목록페이지
    # path("", views.PostList.as_view(), name="post_list"),
    path("<int:pk>/", views.single_post_page, name="post_detail"),
]