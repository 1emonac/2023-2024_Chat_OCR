# Generated by Django 5.0.1 on 2024-02-19 10:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('cal', '0009_delete_restaurant'),
    ]

    operations = [
        migrations.CreateModel(
            name='Restaurant',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('rank', models.CharField(max_length=1)),
                ('information', models.CharField(max_length=2)),
                ('title', models.CharField(max_length=20)),
                ('address', models.CharField(max_length=50)),
            ],
        ),
    ]
