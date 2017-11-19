# -*- coding: utf-8 -*-

try:
        import Image
except ImportError:
        from PIL import Image
import pytesseract
import datetime
import os

# Create your views here.

from django.http import HttpResponse
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes, authentication_classes, parser_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticatedOrReadOnly
from rest_framework.parsers import FileUploadParser
from rest_framework.views import APIView

class FileUploadView(APIView):
    parser_classes = (FileUploadParser, )
    permission_classes= (AllowAny, )

    def post(self, request, filename, format='jpg'):

        src_img = request.data['file']
        dest_img = '/srv/t4ct/tmp/'+datetime.datetime.now().isoformat()+src_img.name
        
        with open(dest_img, 'wb+' ) as dest:
            for c in src_img.chunks():
                dest.write(c)
        
        lines = open(dest_img).readlines()
        open(dest_img, 'wb+').writelines(lines[4:-1])

        to_ocr = Image.open(dest_img)

        if os.path.isfile(dest_img):
            os.remove(dest_img)
        else:
            print("Error: temp file not found")
        return Response(pytesseract.image_to_string(to_ocr), status.HTTP_201_CREATED)
