from django.shortcuts import render, redirect, get_object_or_404
from users.forms import LoginForm, SignupForm
from django.contrib.auth import authenticate, login, logout
from users.models import User
from django.http import HttpResponseRedirect
from django.urls import reverse

# Create your views here.
def login_view(request):
        # LoginForm 인스턴스를 생성
        form = LoginForm()
        form2 = SignupForm()
        context = {"form":form, "form2":form2}
        return render(request, "users/login.html", context)

def login_view2(request):
    if request.method == "POST":
        form = LoginForm(data=request.POST)
        if form.is_valid():
            # username과 password 값을 가져와 변수에 할당
            username = form.cleaned_data["username"]
            password = form.cleaned_data["password"]

            # username, password 에 해당하는 사용자가 있는지 검사
            user = authenticate(username=username, password=password)

            # 해당 사용자가 존재한다면
            if user:
                # 로그인 처리 후, 피드페이지로 redirect
                login(request, user)
                return redirect("/cal")
        form2 = SignupForm
        # 실패한 경우 다시 LoginForm 을 사용한 로그 페이지 렌더링
        context = {"form" : form, "form2" : form2}

    else:
        # LoginForm 인스턴스를 생성
        form = LoginForm()

        # 생성한 LoginForm 인스턴스를 템플릿에 "form" 이라는 키로 전달
        context = {
            "form" : form,
            "form2" : form2,
        }
    return render(request, "users/login.html", context)



def login_view3(request):
    if request.method == "POST":
        form = LoginForm(data=request.POST)
        if form.is_valid():
            # username과 password 값을 가져와 변수에 할당
            username = form.cleaned_data["username"]
            password = form.cleaned_data["password"]

            # username, password 에 해당하는 사용자가 있는지 검사
            user = authenticate(username=username, password=password)

            # 해당 사용자가 존재한다면
            if user:
                # 로그인 처리 후, 피드페이지로 redirect
                login(request, user)
                return render("cal.calendar.html")
        # 실패한 경우 다시 LoginForm 을 사용한 로그 페이지 렌더링
        context = {"form" : form,}

    else:
        # LoginForm 인스턴스를 생성
        form = LoginForm()

        # 생성한 LoginForm 인스턴스를 템플릿에 "form" 이라는 키로 전달
        context = {
            "form" : form,
        }
        return redirect("/cal", context)

def logout_view(request):
    # logout 함수 호출에 request를 전달
    logout(request)

    # logout 처리 후, 캘린더 페이지로 이동
    return redirect("/cal")

def signup(request):
    if request.method == "POST":
        form = SignupForm(data=request.POST)
        # Form에 에러가 없다면 form의 save() 메서드로 사용자를 생성
        if form.is_valid():
            user = form.save()
            login(request, user)
            return render(request, "users/login.html")
    
    # GET 요청에서는 빈 Form을 보여줌
    else:
    # SignupForm 인스턴스를 생성, Template에 전달
        form = SignupForm()
    
    # context로 전달되는 form 은 두 가지 경우가 존재
    # 1. POST 요청에서 생성된 form이 유효하지 않은 경우
        # -> 에러를 포함한 form이 사용자에게 보여짐
    # 2. GET 요청으로 빈 form이 생성되는 경우
        # -> 빈 form이 사용자에게 보여짐
    return render(request, "users/login.html")

