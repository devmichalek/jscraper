# JSCRAPER


## Build dependencies
1. [Docker engine](https://docs.docker.com/engine/install/)
2. [Make](https://www.gnu.org/software/make/)

## Ideas
1. run `cargo --version` and `rustc --version` in jenkins
2. run `rustfmt <sources>` to format files
3. run `cargo check` and then `cargo build`
4. how to benchamark the binary? use `RUST_BACKTRACE=1 cargo run`
5. build release version `cargo build --release`