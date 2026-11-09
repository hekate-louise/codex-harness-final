# 예시: Python 표준 라이브러리 + sqlite3 서버. 과제 스택에 맞게 고친다.
FROM python:3.11-slim

WORKDIR /app

# 외부 패키지가 있을 때만 쓴다.
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV HOST=0.0.0.0 \
    PORT=8000 \
    DB_PATH=/app/data/app.db

EXPOSE 8000

CMD ["python", "server.py"]
