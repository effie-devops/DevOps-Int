from django.urls import path, include
from . import views

urlpatterns = [
    # Prometheus metrics endpoint (/metrics) provided by django-prometheus.
    path('', include('django_prometheus.urls')),
    path('', views.health_check, name='health-check'),
    path('health/', views.health_check, name='health'),
    path('books/create/', views.createBook, name='create-book'),
    path('books/<int:pk>/update/', views.updateBook, name='update-book'),
    path('books/<int:pk>/delete/', views.deleteBook, name='delete-book'),
    path('writer/', views.health_check, name='writer-root'),
    path('writer/health/', views.health_check, name='writer-health'),
    path('writer/books/create/', views.createBook, name='writer-create-book'),
    path('writer/books/<int:pk>/update/', views.updateBook, name='writer-update-book'),
    path('writer/books/<int:pk>/delete/', views.deleteBook, name='writer-delete-book'),
]
