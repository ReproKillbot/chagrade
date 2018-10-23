from django.contrib import admin

# Register your models here.
from apps.homework.models import Grade, Criteria, Definition, Submission

admin.site.register(Grade)
admin.site.register(Criteria)
admin.site.register(Definition)
admin.site.register(Submission)
