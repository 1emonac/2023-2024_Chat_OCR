from django.urls import path
from users import views
from django.contrib.auth.views import LogoutView

app_name = "users"
urlpatterns = [
    path("login/", views.login_view, name="login"),
    path("login2/", views.login_view2, name="login2"),
    path("login3/", views.login_view3, name="login3"),
    path('logout/', views.logout_view, name='logout'),
    path("signup/", views.signup, name="signup"),
]