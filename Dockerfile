FROM ocaml/opam:alpine as builder

WORKDIR btd6_teams

# Install dependencies
ADD btd6_teams.opam .
RUN opam pin add -yn btd6_teams . && \
    opam depext btd6_teams && \
    opam install --deps-only btd6_teams && \
    opam install dune

RUN sudo apk update && \
    sudo apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing ocaml-base

ADD bin/ bin/
ADD lib/ lib/
ADD test/ test/
ADD dune-project .
ADD Makefile .

RUN eval $(opam env) && \
    sudo chown -R opam:nogroup . && \
    dune build && \
    opam depext -ln btd6_teams | egrep -o "\-\s.*" | sed "s/- //" > depexts
    
# Let's create the production image!
FROM alpine
WORKDIR /app
COPY --from=builder /home/opam/btd6_teams/_build/default/bin/main.exe btd6_teams.exe

RUN apk update && apk add --no-cache libev

# Don't forget to install the dependencies, noted from
# the previous build.
COPY --from=builder /home/opam/btd6_teams/depexts depexts
RUN cat depexts | xargs apk --update add && rm -rf /var/cache/apk/*

EXPOSE 3000
CMD ./btd6_teams.exe
