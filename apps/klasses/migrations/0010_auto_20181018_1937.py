# Generated by Django 2.1.1 on 2018-10-18 19:37

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('klasses', '0009_klass_active'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='klass',
            name='students',
        ),
        migrations.RemoveField(
            model_name='klass',
            name='teacher_assistants',
        ),
    ]