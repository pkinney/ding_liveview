
FROM elixir:latest
ARG app_name=ding
ARG phoenix_subdir=.
ARG build_env=prod
ENV MIX_ENV=${build_env} TERM=xterm
WORKDIR /app
RUN apt-get update -y \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y -q --no-install-recommends nodejs \
  && mix local.rebar --force \
  && mix local.hex --force
COPY . .
RUN mix do deps.get, compile
RUN cd ${phoenix_subdir}/assets \
  && npm install \
  && ./node_modules/webpack/bin/webpack.js --mode production \
  && cd .. \
  && mix phx.digest
RUN mix release \
  && tar -cavf ${app_name}.tar.gz -C _build/${build_env}/rel/${app_name} .
