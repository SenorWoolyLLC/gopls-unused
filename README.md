# Find Project-Wide Unused Code Using Golang's LSP

For the last year or so (as of 2023) Golang has only had one active project for linting unused code, namely: `unused` from https://github.com/dominikh/go-tools. It works really well, but only _within_ a package, not across packages, like within a traditional monolith. `unused` used to be part of another project called `staticcheck`, that did indeed have a flag for detecting project-wide unused code, but that is no longer supported. There are good reasons for that ([see this Github discussion](https://github.com/dominikh/go-tools/issues/1164)), mainly that it's computationally expensive.

So, as far as I know, there is no single tool to help with finding project-wide unused code, no matter how slow it might be. Hence this repo. It crudely piggybacks off of the official [Golang LSP server](https://github.com/golang/tools/tree/master/gopls) by searching for publicly exported symbols then searching for references to those symbols. It is slow, but it works.

## Usage

You will first need BASH and [gopls](https://github.com/golang/tools/tree/master/gopls).

To run, clone the repo and run `./gopls-unused.bash find_all path/to/golang/code`.

There are some more find-grained commands:

```
./gopls-unused.bash find_all_in_file path/to/golang/file.go
./gopls-unused.bash find_symbol_references_in_project path/to/symbol/file.go:1:1
```

An ignore regex flag, eg: `IGNORE_REGEX='.*gen\.go' ./gopls-unused.bash find_all path/to/golang/code`.

An CWD flag, eg: `CWD=path/to/golang/code ./gopls-unused.bash find_all`.

And a debugging flag, eg: `DEBUG=1 ./gopls-unused.bash find_all path/to/golang/code`.
