FROM python:2.7.13

ADD . /srv/t4ct/

ADD ./requirements.txt /srv/t4ct/

RUN apt-get update \
 && apt-get install -y tesseract-ocr \
 && pip install -r /srv/t4ct/requirements.txt \
 && rm -rf /var/lib/apt/lists/*

ADD . /srv/t4ct/

CMD [ "python", "-u", "/srv/t4ct/manage.py", "runserver", "0.0.0.0:8000"]
