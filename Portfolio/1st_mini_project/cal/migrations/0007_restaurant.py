# Generated by Django 5.0.1 on 2024-02-19 07:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('cal', '0006_today_weather_delete_weather_value'),
    ]

    operations = [
        migrations.CreateModel(
            name='Restaurant',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('information', models.CharField(max_length=2)),
                ('title', models.CharField(max_length=15)),
                ('address', models.CharField(max_length=50)),
            ],
        ),
    ]
