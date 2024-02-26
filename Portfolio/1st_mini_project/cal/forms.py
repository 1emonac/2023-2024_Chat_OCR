from django import forms
from .models import EventModel  # 이벤트 모델 임포트



class EventForm(forms.ModelForm):
    class Meta:
        model=EventModel  # 사용할 이벤트 모델 지정
        fields = ['ename', 'edate_s', 'edate_e', 'edesc']