from django.contrib import admin
from django.http.request import HttpRequest
from posts.models import Post, PostImage, Comment, HashTag
import admin_thumbnails
from django.db.models import ManyToManyField
from django.forms import CheckboxSelectMultiple

# Register your models here.
class CommentInline(admin.TabularInline):
    model = Comment
    extra = 1

@admin_thumbnails.thumbnail("photo")
class PostImageInline(admin.TabularInline):
    model = PostImage
    extra = 1

class LikeUserInline(admin.TabularInline):
    model = Post.like_users.through
    verbose_name = "좋아요 한 User"
    verbose_name_plural = f"{verbose_name} 목록"
    def has_change_permission(self, request, obj=None):
        return False

@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display =[
        "id",
        "content",
        "created",
    ]
    inlines = [
        CommentInline, 
        PostImageInline,
        LikeUserInline,
    ]
    # Post 변경화면에서 ManyToManyField 를 Checkbox 로 출력
    formfield_overrides = {ManyToManyField: {"widget": CheckboxSelectMultiple}}
    
@admin.register(PostImage)
class PostImageAdmin(admin.ModelAdmin):
    list_display = [
        "id",
        "post",
        "photo",
    ]

@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = [
        "id",
        "post",
        "content",
        "created",
    ]

@admin.register(HashTag)
class HashTagAdmin(admin.ModelAdmin):
    pass