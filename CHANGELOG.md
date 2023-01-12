# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0-beta] - 2023-01-30

We're super excited to announce `Reward` 0.4.0!

### Major changes

This release is a major milestone for the project, and we're proud to share it with you.
The project was rewritten from scratch so this release can contain unexpected bugs and breaking changes.

### New Features

- Introducing a new plugin system. You can now write your own plugins and use them with `Reward`. For more information,
  see the [sample plugin repository](https://github.com/rewardenv/reward-plugin-template).
- Introducing a new shortcut system. You can define your own shortcuts to automate `Reward` commands.
- Add support for bootstrapping Shopware.

### Improvements

- Some varying command line flags are now only shown for the relevant environment types. For example for the `bootstrap`
  command the `--magento-type` flag is only available when the environment type is `magento`.
- Requirements (docker API access, version requirements, etc.) are now checked before running any command instead of
  only running before specific commands.
- Default Magento version is now v2.4.5-p1.
- Default Node version is now 16 globally. You can change it by setting `NODE_VERSION` in your `.env` file.

### Breaking changes

- `REWARD_MUTAGEN_ENABLED` option is removed. Use `REWARD_SYNC_ENABLED` instead.
- `REWARD_WSL2_DIRECT_MOUNT` option is removed. Use `REWARD_SYNC_ENABLED=false` instead.
- Instead of using `1` and `0` for enabling and disabling options, use `true` and `false` everywhere.