from django.db import models
from django.urls import reverse

# Create your models here.
class Post(models.Model):
    title = models.CharField(max_length = 30)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"[{self.id}]{self.title}"
    
    def get_absolute_url(self):
        return f"/blog/{self.pk}/"
        # return reverse("blog:sigle_post", kwargs={"pk":self.pk})