from datetime import datetime, timedelta # 날짜 및 시간 연산
from calendar import HTMLCalendar # HTML 형식의 달력 생성
from .models import class_contents

# HTMLCalendar 클래스를 상속받아 달력을 생성
class Calendar(HTMLCalendar):
	# Calendar 객체가 생성될 때 호출 (년도와 월을 지정, super 메서드 호출을 통해 HTMLCalendar 클래스를 초기화)
	def __init__(self, year=None, month=None):
		self.year = year
		self.month = month
		super(Calendar, self).__init__()

	# formatday() 달력에서 하루를 형식화하는 함수
	# 필터링한 class_contents 모델의 데이터를 contents로 받아 해당 날짜의 keyword를 출력
	def formatday(self, day, contents):
		contents_per_day = contents.filter(start_time__day=day)
		d = ''
		for event in contents_per_day:
			d += f'<li> {class_contents.keyword} </li>'

		if day != 0:
			return f"<td><span class='date'>{day}</span><ul> {d} </ul></td>"
		return '<td></td>'

	# formatweek() 달력에서 주를 형식화 하는 함수
	# theweek와 contents를 받아 각 날짜에 대해 formatday 함수를 호출하여 출력
	def formatweek(self, theweek, contents):
		week = ''
		for d, weekday in theweek:
			week += self.formatday(d, contents)
		return f'<tr> {week} </tr>'

	# formatmonnth() 달력에서 한 달을 형식화하는 함수
	# withyear가 True일 때, 연도를 포함한 형식으로 출력
	# class_contents 모델의 데이터를 필터링하여 해당 월에 대한 달력을 출력
	# formatmonthname, formatweekheader, monthdays2calendar, formatweek 메서드를 호출하여 달력 생성
	def formatmonth(self, withyear=True):
		contents = class_contents.objects.filter(start_time__year=self.year, start_time__month=self.month)

		cal = f'<table border="0" cellpadding="0" cellspacing="0" class="calendar">\n'
		cal += f'{self.formatmonthname(self.year, self.month, withyear=withyear)}\n'
		cal += f'{self.formatweekheader()}\n'
		for week in self.monthdays2calendar(self.year, self.month):
			cal += f'{self.formatweek(week, contents)}\n'
		return cal