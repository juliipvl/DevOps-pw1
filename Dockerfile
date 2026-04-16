FROM python:3.13-slim

WORKDIR /api

COPY requirements.txt .
COPY api.py .
COPY run-api.sh .

RUN chmod +x run-api.sh
RUN pip install -r requirements.txt

CMD ["./run-api.sh"]