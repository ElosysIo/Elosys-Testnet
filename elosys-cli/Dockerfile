FROM node:20-bookworm as build
ENV PATH="/root/.cargo/bin:${PATH}"

RUN \
    --mount=type=cache,target=/var/cache/apt \
    apt-get update && \
    apt-get install jq rsync -y

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

COPY ./ /usr/src/elosys

RUN /usr/src/elosys/elosys-cli/scripts/build.sh

FROM node:20-bookworm-slim

EXPOSE 8020:8020
EXPOSE 9033:9033
VOLUME /root/.elosys
ENV NODE_ENV production

COPY --from=build /usr/src/elosys/elosys-cli/build.cli/elosys-cli /usr/share/elosys
COPY --from=build --chmod=755 /usr/src/elosys/elosys-cli/scripts/docker-entrypoint.sh /usr/bin/elosys

ENTRYPOINT ["/usr/bin/elosys"]
CMD ["start", "--rpc.ipc", "--rpc.tcp"]
