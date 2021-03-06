# Generated by Django 2.1.1 on 2018-10-05 17:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('klasses', '0002_auto_20180919_2005'),
    ]

    operations = [
        migrations.AddField(
            model_name='klass',
            name='course_number',
            field=models.SlugField(default=None, max_length=60, unique=True),
        ),
        migrations.AddField(
            model_name='klass',
            name='name',
            field=models.CharField(default='New Course', max_length=60),
        ),
    ]
