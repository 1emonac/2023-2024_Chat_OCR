from django.urls import path
from todo import views

urlpatterns = [
    # path("", views.TodoAPI), # FBV 버전
    path("", views.TodoAPI.as_view()), #> .as_view()가 중요!
    # path("<int:id>/", views.TododetailAPI), # FBV 버전
    path("<int:id>/", views.TododetailAPI.as_view()), # CBV 버전
#     path("", views.TodoAPIViews.as_view()),
    # path("<int:id>/", views.TodoEditAPI.as_view()),
    path("done/", views.TodoCompleteAPI.as_view()),
    path("done/<int:id>/", views.TodoFinishAPI.as_view()),
]