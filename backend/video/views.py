from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from .models import Profile, Video
from .serializers import (
    ProfileSerializer, 
    VideoSerializer,
    VideoCreateSerializer,
    ProfileUpdateSerializer
)

class ProfileViewSet(viewsets.ModelViewSet):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]
    
    def get_serializer_class(self):
        if self.action in ['update', 'partial_update']:
            return ProfileUpdateSerializer
        return ProfileSerializer

    @action(detail=False, methods=['GET', 'PUT'], permission_classes=[permissions.IsAuthenticated])
    def me(self, request):
        """Get or update the current user's profile"""
        profile = get_object_or_404(Profile, user=request.user)
        
        if request.method == 'GET':
            serializer = ProfileSerializer(profile)
            return Response(serializer.data)
            
        elif request.method == 'PUT':
            serializer = ProfileUpdateSerializer(profile, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class VideoViewSet(viewsets.ModelViewSet):
    queryset = Video.objects.all()
    serializer_class = VideoSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get_serializer_class(self):
        if self.action == 'create':
            return VideoCreateSerializer
        return VideoSerializer

    def perform_create(self, serializer):
        """Set the uploader to the current user when creating a video"""
        serializer.save(uploader=self.request.user)

    def get_queryset(self):
        """Optionally filter videos by user"""
        queryset = Video.objects.all()
        username = self.request.query_params.get('username', None)
        if username is not None:
            queryset = queryset.filter(uploader__username=username)
        return queryset

    @action(detail=True, methods=['POST'])
    def like(self, request, pk=None):
        """Toggle like status for a video"""
        video = self.get_object()
        user = request.user
        
        if video.likes.filter(id=user.id).exists():
            video.likes.remove(user)
            liked = False
        else:
            video.likes.add(user)
            liked = True
            
        return Response({
            'status': 'liked' if liked else 'unliked',
            'like_count': video.likes.count()
        })

    @action(detail=True, methods=['POST'])
    def increment_view(self, request, pk=None):
        """Increment the view count for a video"""
        video = self.get_object()
        video.views += 1
        video.save()
        return Response({'views': video.views})

    @action(detail=False, methods=['GET'])
    def my_videos(self, request):
        """Get all videos uploaded by the current user"""
        videos = Video.objects.filter(uploader=request.user)
        serializer = self.get_serializer(videos, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['GET'])
    def liked_videos(self, request):
        """Get all videos liked by the current user"""
        videos = Video.objects.filter(likes=request.user)
        serializer = self.get_serializer(videos, many=True)
        return Response(serializer.data)