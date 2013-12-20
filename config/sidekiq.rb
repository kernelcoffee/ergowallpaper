# Options here can still be overridden by cmd line args.
# sidekiq -C config.yml
---
:verbose: false
:concurrency: 25
:queues:
  - [similars, 5]
  - [default, 5]
