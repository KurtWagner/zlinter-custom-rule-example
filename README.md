# zlinter - custom rule example

[![Zig 0.14.x](https://img.shields.io/github/actions/workflow/status/KurtWagner/zlinter-custom-rule-example/ci.yml?branch=0.14.x&label=Zig%200.14.x&style=flat)](https://github.com/KurtWagner/zlinter/actions/workflows/ci.yml)
[![Zig 0.15.x](https://img.shields.io/github/actions/workflow/status/KurtWagner/zlinter-custom-rule-example/ci.yml?branch=0.15.x&label=Zig%200.15.x&style=flat)](https://github.com/KurtWagner/zlinter/actions/workflows/ci.yml)
[![Zig master](https://img.shields.io/github/actions/workflow/status/KurtWagner/zlinter-custom-rule-example/ci.yml?branch=master&label=Zig%200.16.x&style=flat)](https://github.com/KurtWagner/zlinter/actions/workflows/ci.yml)

A tiny zig master (0.16-dev) project with a custom [zlinter](https://github.com/KurtWagner/zlinter) rule to poke around.

1. Edit rule [`src/example_rule.zig`](src/example_rule.zig)

2. Edit file being linted [`src/example_rule.zig`](src/main.zig)

3. Run linter with custom rule

    ```shell
    zig build lint
    ```

## All version branches

* [0.14.x example](https://github.com/KurtWagner/zlinter-custom-rule-example/tree/0.15.x)
* [0.15.x example](https://github.com/KurtWagner/zlinter-custom-rule-example/tree/0.14.x)
* [master (0.16-dev) example](https://github.com/KurtWagner/zlinter-custom-rule-example/tree/master)
