#!/bin/bash
set -e

if [ "${SHOPWARE_SKIP_BOOTSTRAP:-false}" == "true" ]; then
  exit
fi

if [ "${SHOPWARE_SKIP_INSTALL:-false}" != "true" ]; then
  SHOPWARE_HOST=${SHOPWARE_HOST:-'shopware.test'}
  SHOPWARE_SCHEME=${SHOPWARE_SCHEME:-'https'}

  SHOPWARE_APP_URL=${SHOPWARE_APP_URL:-"$SHOPWARE_SCHEME://$SHOPWARE_HOST"}

  ARGS=()
  ARGS+=(
    "--app-env=${SHOPWARE_APP_ENV:-prod}"
    "--app-url=${SHOPWARE_APP_URL}"
    "--database-url=mysql://${SHOPWARE_DATABASE_USER:-app}:${SHOPWARE_DATABASE_PASSWORD:-app}@${SHOPWARE_DATABASE_HOST:-db}:${SHOPWARE_DATABASE_PORT:-3306}/${SHOPWARE_DATABASE_NAME:-shopware}"
    "--cdn-strategy=${SHOPWARE_CDN_STRATEGY:-physical_filename}"
    "--mailer-url=${SHOPWARE_MAILER_URL:-native://default}"
  )

  # Configure Elasticsearch
  if [ "${SHOPWARE_ELASTICSEARCH_ENABLED:-true}" == "true" ]; then
    ARGS+=(
      "--es-enabled=1"
      "--es-hosts=${SHOPWARE_ELASTICSEARCH_HOST:-elasticsearch}:${SHOPWARE_ELASTICSEARCH_PORT:-9200}"
    )

    if [ "${SHOPWARE_ELASTICSEARCH_INDEXING_ENABLED:-true}" == "true" ]; then
      ARGS+=(
        "--es-indexing-enabled=1"
      )
    fi
  fi

  php bin/console system:setup --no-interaction "${ARGS[@]}"

  php bin/console system:install --no-interaction --create-database --basic-setup

  if [ "${SHOPWARE_PUPPETEER_SKIP_CHROMIUM_DOWNLOAD:-true}" == "true" ]; then
    export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
  fi
  if [ "${SHOPWARE_CI:-true}" == "true" ]; then
    export CI=1
  fi
  if [ "${SHOPWARE_SKIP_BUNDLE_DUMP:-true}" == "true" ]; then
    export SHOPWARE_SKIP_BUNDLE_DUMP=1
  fi

  bin/build.sh

  php bin/console system:update:finish --no-interaction
fi

if [ "${SHOPWARE_DEPLOY_SAMPLE_DATA:-false}" == "true" ]; then
  APP_ENV="${SHOPWARE_APP_ENV:-prod}" php bin/console store:download -p SwagPlatformDemoData
fi