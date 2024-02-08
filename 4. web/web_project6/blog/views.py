from django.shortcuts import render, redirect
from blog.models import Post
from django.views.generic import ListView

# Create your views here.
def index(request):
    posts = Post.objects.all().order_by("-pk")
    context = {
        "posts": posts,
    }
    return render(request, "blog_list.html", context)

# class PostList(ListView):
#     model = Post
#     template_name = "blog_list.html"

def single_post_page(request, pk):
    post = Post.objects.get(pk=pk)
    context = {
        "post":post
    }
    return render(request, "single_post_page.html", context)