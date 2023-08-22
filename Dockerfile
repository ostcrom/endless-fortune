#Based off this Dockerfile: https://github.com/matthieubosquet/docker/blob/main/cowsay-fortune/cowsay-fortune.Dockerfile

FROM debian:latest
RUN apt-get update && apt-get install -y cowsay fortune
COPY endless-fortune.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/endless-fortune.sh
ENV PATH $PATH:/usr/games
ENV ENV_SLEEP 1
CMD ["/usr/local/bin/endless-fortune.sh"]
