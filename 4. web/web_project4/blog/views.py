from django.shortcuts import render
from .models import Post, Comment

# Create your views here.
def index(request):
    return render(request, "index.html")

def post_list(request):
    postlist = Post.objects.all()
    return render(request, "post_list.html", {"postlist" : postlist})