# Generated by Django 5.0.2 on 2024-02-07 06:43

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("blog", "0002_post_created_at"),
    ]

    operations = [
        migrations.AddField(
            model_name="post",
            name="update_at",
            field=models.DateTimeField(auto_now=True),
        ),
        migrations.AlterField(
            model_name="post",
            name="created_at",
            field=models.DateTimeField(auto_now_add=True),
        ),
    ]
