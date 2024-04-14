FROM python:3.12.3-alpine3.18

WORKDIR /app

ARG ANTHROPIC_API_KEY
ARG OPENAI_API_KEY

ENV ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
    OPENAI_API_KEY=$OPENAI_API_KEY


COPY requirements.txt /app
COPY src/tic-tac-toe-2-AI.py /app

RUN pip install -r requirements.txt

CMD ["python", "tic-tac-toe-2-AI.py"]