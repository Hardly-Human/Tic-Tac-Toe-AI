#!/bin/bash
# This script needs ANTHROPIC_API_KEY & OPENAI_API_KEY as ENV vars
docker build  \
             --build-arg ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY} \
             --build-arg OPENAI_API_KEY=${OPENAI_API_KEY} \
             -t rshaik921/tic-tac-toe-ai:latest \
             -f application-code/Dockerfile ./application-code
