FROM nimlang/nim:2.2.2-regular

WORKDIR /usr/src/app

RUN addgroup --system nim && adduser --system --group nim
RUN chown -R nim:nim /usr/src/app && chmod -R 755 /usr/src/app

ENV NIM_ENV=production
ENV NIMBLE_DIR=/home/nim/.nimble
ENV PATH=$PATH:/home/nim/.nimble/bin

COPY btd6teams.nimble btd6teams.nimble

RUN nimble refresh && nimble install

COPY src/*.nim .

RUN nimble c -d:release --checks:off --opt:speed --assertions:off main.nim

USER nim

CMD ["./main"]
