from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Profile, Video

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email']
        read_only_fields = ['email']

class ProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    email = serializers.EmailField(source='user.email', read_only=True)
    profile_picture = serializers.SerializerMethodField()
    class Meta:
        model = Profile
        fields = [
            'id', 
            'username',
            'email', 
            'bio', 
            'profile_picture',
            'created_at'
        ]
    def get_profile_picture(self, obj):
        if obj.profile_picture:
            return obj.profile_picture.url
        return None

class VideoSerializer(serializers.ModelSerializer):
    uploader = UserSerializer(read_only=True)
    like_count = serializers.SerializerMethodField()
    is_liked = serializers.SerializerMethodField()
    video_file = serializers.SerializerMethodField()
    thumbnail = serializers.SerializerMethodField()

    class Meta:
        model = Video
        fields = [
            'id',
            'title',
            'description',
            'video_file',
            'thumbnail',
            'uploader',
            'views',
            'like_count',
            'is_liked',
            'created_at'
        ]
        read_only_fields = ['uploader', 'views', 'like_count']

    def get_like_count(self, obj):
        return obj.likes.count()
    
    def get_is_liked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.likes.filter(id=request.user.id).exists()
        return False
    def get_video_file(self, obj):
        if obj.video_file:
            return obj.video_file.url
        return None
    def get_thumbnail(self, obj):
        if obj.thumbnail:
            return obj.thumbnail.url
        return None
        
class VideoCreateSerializer(serializers.ModelSerializer):
    """Separate serializer for video creation with minimal fields"""
    class Meta:
        model = Video
        fields = ['title', 'description', 'video_file', 'thumbnail']

class ProfileUpdateSerializer(serializers.ModelSerializer):
    """Separate serializer for profile updates"""
    class Meta:
        model = Profile
        fields = ['bio', 'profile_picture']