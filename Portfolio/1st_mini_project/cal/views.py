from django.shortcuts import render, redirect
from datetime import datetime, timedelta, date
from django.views import generic
from django.utils.safestring import mark_safe
import calendar
from django.contrib.auth import authenticate, login, logout
from django.utils import timezone

from cal.forms import EventForm
from users.forms import *
from .models import *
from .utils import Calendar

# Create your views here.

# generic.ListView 클래스를 상속받아, class_contents 모델을 이용하여 DB에서 달력에 보여줄 이벤트들을 가져옴

class CalendarView(generic.ListView):
    model = class_contents
    template_name = 'cal/calendar.html'
 
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        
        # 요청에서 날짜 정보 추출
        d = get_date(self.request.GET.get('day', None))
        cal = Calendar(d.year, d.month)
        html_cal = cal.formatmonth(withyear=True)
        
        # 달력과 이전/다음 달 정보를 컨텍스트에 추가
        context['calendar'] = mark_safe(html_cal)
        context['prev_month'] = prev_month(d)
        context['next_month'] = next_month(d)

        # EventForm 인스턴스 생성 및 컨텍스트에 추가
        form = EventForm()
        context["form"] = form 

        # 지역(시) 정보를 컨텍스트에 추가
        areas = Area.objects.all()
        area_list = [area.Area for area in areas]
        area_list2 = []
        for area in area_list:
            if area not in area_list2:
                area_list2.append(area)

        context['area_si3'] = area_list2

        # 지역(군,구) 정보를 컨텍스트에 추가
        areas = Area.objects.all()
        context['area_details'] = [area.Area_detail for area in areas]

        return context


# get_daye()는 URL에서 전달된 년도와 월 정보를 추출하여, datatime 객체로 변환하는 함수
# 위에서 선언한 get_context_data() 내에서 호출    
def get_date(req_day):
    try:
        if req_day: 
            year, month, day = (int(x) for x in req_day.split('-'))
            return date(year, month, day=1)
    except (ValueError, TypeError):
        pass
    return datetime.today().date()
# req_day는 URL 매개변수 day의 값을 받아오는 변수
# req_day 값이 존재하면 해당 날짜로부터 date 객체를 생성
# req_day 값이 존재하지 않을 경우 현재 날짜를 사용해 date 객체를 생성

def prev_month(d):
    first = d.replace(day=1)
    prev_month = first - timedelta(days=1)
    a = 'day=' + str(prev_month.year) + '-' + str(prev_month.month) + '-' + str(prev_month.day)
    return a

def next_month(d):
    days_in_month = calendar.monthrange(d.year, d.month)[1]
    last = d.replace(day=days_in_month)
    next_month = last + timedelta(days=1)
    a = 'day=' + str(next_month.year) + '-' + str(next_month.month) + '-' + str(next_month.day)
    return a

serviceKey = "MjYQcO8eIAXD%""2FYqKy8IocJ0HYo4S3%""2FZ4rjNjoz%2B9XaZQvF4j%""2FB8QAhmJqh6mC6dHeMmkCYrg0Pi2xI6OfxMq7A%3D%3D"

def post_detail(request):
    today_W = today_weather.objects.all()
    han = Restaurant.objects.filter(information="한식")
    yang = Restaurant.objects.filter(information="양식")
    joong = Restaurant.objects.filter(information="중식")
    ill = Restaurant.objects.filter(information="일식")
    
    travel = Travel.objects.all()
    today = datetime.now()
    today_date = str("%02d"%(today.month)) + "/" + str("%2d"%(today.day)) + "/" + str("%04d"%(today.year))
    
    post = EventModel.objects.filter(user_id=request.user, edate_s=today_date)
    
    context = {"today_weather" : today_W, "han" : han, "yang" : yang, "joong" : joong, "ill" : ill, "travel" : travel, "post":post, "today_date" : today_date}
    return render(request, 'cal/post_detail.html', context)

def index(request):
    if request.user.is_authenticated:
        return redirect("cal:calendar")
    
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
                return redirect("cal:calendar")
            # 사용자가 없다면 form에 에러 추가
            else: 
                form.add_error(None, "입력한 자격증명에 해당하는 사용자가 없습니다(이걸 틀리네 낄낄)")

        # 실패한 경우 다시 LoginForm 을 사용한 로그 페이지 렌더링
        context = {"form" : form}

    else:
        # LoginForm 인스턴스를 생성
        form = LoginForm()

        # 생성한 LoginForm 인스턴스를 템플릿에 "form" 이라는 키로 전달
        context = {
            "form" : form,
        }
    return render(request, 'cal/index.html', context)

def save_event(request):
    if request.method == 'POST':
        form = EventForm(data=request.POST)
        
        # 로그인 되어있는 유저여야함(추가)
        if form.is_valid():
            event = form.save(commit=False)
            event.user_id = request.user
            event.save()
            return redirect("cal:calendar")  # 성공 페이지로 리다이렉션
    
    return redirect("cal:calendar")

