FROM python:3.10

COPY requirements.txt .
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt

RUN apt update && apt install -y coreutils

WORKDIR /app
COPY . /app