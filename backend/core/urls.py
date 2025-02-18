from django.urls import path
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .views import SignupViewSet,test
from rest_framework.routers import DefaultRouter
router = DefaultRouter()
router.register(r'signup', SignupViewSet, basename='signup')
urlpatterns = [
  
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),  # Login
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),  # Refresh token
    path('test/', test.as_view(), name='test'),  # Test view

] + router.urls
