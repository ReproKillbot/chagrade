from django.contrib.auth import get_user_model
from rest_framework.permissions import IsAdminUser
from rest_framework.viewsets import ModelViewSet

from apps.api.mixins import OwnerPermissionCheckMixin
from apps.api.serializers.homework import DefinitionSerializer, QuestionSerializer, CriteriaSerializer, \
    SubmissionSerializer, GradeSerializer
from apps.homework.models import Definition, Question, Criteria, Submission, Grade

from apps.homework.tasks import calculate_new_grade

User = get_user_model()


class GradeViewSet(ModelViewSet):
    queryset = Grade.objects.all()
    serializer_class = GradeSerializer
    permission_classes = ()

    def perform_create(self, serializer):
        new_obj = serializer.save()
        # grade = Grade.objects.get(pk=grade_pk)
        total = 0
        total_possible = 0
        # Average should be total points scored over total points possible
        for criteria_answer in new_obj.criteria_answers.all():
            total_possible += criteria_answer.criteria.upper_range
            total = criteria_answer.score
        if total_possible == 0 or total == 0:
            print("0")
            # return 0
            new_obj.overall_grade = 0
        else:
            print("Returning an actual grade")
            # return total / total_possible
            new_obj.overall_grade = total / total_possible
            print(new_obj.overall_grade)
        print("Calling save")
        new_obj.save()
        print(new_obj.overall_grade)


class SubmissionViewSet(ModelViewSet):
    queryset = Submission.objects.all()
    serializer_class = SubmissionSerializer
    permission_classes = ()


class DefinitionViewSet(ModelViewSet):
    queryset = Definition.objects.all()
    serializer_class = DefinitionSerializer
    permission_classes = ()


class QuestionViewSet(ModelViewSet):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer
    permission_classes = ()


class CriteriaViewSet(ModelViewSet):
    queryset = Criteria.objects.all()
    serializer_class = CriteriaSerializer
    permission_classes = ()
