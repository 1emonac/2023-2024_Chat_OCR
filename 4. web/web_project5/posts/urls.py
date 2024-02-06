from django.urls import path
from posts import views

app_name = "posts"
urlpatterns = [
    path("feeds/", views.feeds, name="feeds"),
    path("comment_add/", views.comment_add, name="comment_add"),
    path("comment_delete/<int:comment_id>/", views.comment_delete, name="comment_delete"),
    path("post_add/", views.post_add, name="post_add"),
    path("tags/<str:tag_name>/", views.tags, name="tags"), 
    path("<int:post_id>/", views.post_detail, name="post_detail"),
    path("<int:post_id>/like/", views.post_like, name="post_like"),
]