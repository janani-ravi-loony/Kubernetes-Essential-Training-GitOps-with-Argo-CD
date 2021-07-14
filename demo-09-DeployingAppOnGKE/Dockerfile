FROM python:3.7

RUN mkdir /app
WORKDIR /app
COPY . /app/
RUN pip install -r requirements.txt

EXPOSE 5000
ENTRYPOINT ["python"]
CMD ["/app/main.py"]