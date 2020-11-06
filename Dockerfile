FROM confluxchain/conflux-rust-builder:0.1.0 as builder

WORKDIR /usr/src
ADD conflux /usr/src/conflux
WORKDIR /usr/src/conflux
# RUN mkdir $HOME/.cargo
# ADD misc/cargo-config.toml $HOME/.cargo/config
RUN cargo clean
RUN cargo install --path .

FROM debian:buster-slim
RUN apt-get update && apt-get install -y curl build-essential
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs

WORKDIR /root
COPY --from=builder /usr/local/cargo/bin/conflux /usr/local/bin/conflux
COPY --from=builder /usr/local/cargo/bin/cfxkey /usr/local/bin/cfxkey
COPY . .
RUN cd scripts && npm i

EXPOSE 12535 12536 12537 12538 12539 32323 32525
# CMD ["conflux", "--config", "default.toml"]
RUN chmod +x start.sh
RUN chmod +x conflux.sh
RUN chmod +x gene_account.sh
ENTRYPOINT [ "./start.sh" ]