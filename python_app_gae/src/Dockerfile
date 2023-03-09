FROM python:3.7
LABEL maintainer="jaichenchlani@gmail.com"
COPY . /main
WORKDIR /main
RUN pip3 install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["main.py"]