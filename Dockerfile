FROM nimlang/nim:2.0.0-regular

RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq-dev netcat-openbsd

WORKDIR /usr/src/app

RUN addgroup --system nim && adduser --system --group nim
RUN chown -R nim:nim /usr/src/app && chmod -R 755 /usr/src/app

ENV NIM_ENV=production
ENV NIMBLE_DIR=/home/nim/.nimble
ENV PATH=$PATH:/home/nim/.nimble/bin

COPY btd6teams.nimble btd6teams.nimble

RUN nimble refresh && nimble install

COPY src/*.nim .

RUN nimble c --mm:refc -d:release main.nim

USER nim

CMD ["./main"]
