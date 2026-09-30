from django.urls import path, include
from . import views

urlpatterns = [
    # Prometheus metrics endpoint (/metrics) provided by django-prometheus.
    path('', include('django_prometheus.urls')),
    path('', views.getBooks, name='api-root'),
    path('health/', views.health_check, name='health'),
    path('books/', views.getBooks, name='get-books'),
    path('books/<int:pk>/', views.getBook, name='get-book'),
    path('reader/', views.getBooks, name='reader-root'),
    path('reader/health/', views.health_check, name='reader-health'),
    path('reader/books/', views.getBooks, name='reader-get-books'),
    path('reader/books/<int:pk>/', views.getBook, name='reader-get-book'),
]