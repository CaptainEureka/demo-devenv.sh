# `devenv` Demo

---

## What is `devenv`?

- A tool built on [nix](https://nixos.org) 💪
- Aims to make *dev* environments easy to setup and maintain (cross-platform)
- Brought to you by the guys behind [cachix](https://cachix.org) (Enterprise build cache for nix builds)

---

## Dev environments on the fly with `devenv`

- Creating a new devenv from scratch is easy

```bash
$ devenv init .
```

```shell
$ ls .
./
├── devenv.lock
├── devenv.nix
└── devenv.yaml
```

---

### Devenv project file structure

#### `devenv.nix`
> Contains your project definition in the form of a nix expression

```nix
{pkgs, ...}: {
    # Defines a minimal environment for python-latest which only contains
    # python (and maybe it's build dependencies)
    languages.python.enable = true;
}
```

> **Corrolary**: `devenv.lock`
> Locks your dependencies to the latest run of `devenv update`

#### `devenv.yaml`

`nix` is a functional language operating on `inputs` and delivering `outputs`.

In a devenv project `devenv.yaml` is the home of special `inputs` such as the Nixpkgs repository.

```devenv.yaml
inputs:
  nixpkgs:
    url: github:NixOS/nixpkgs/nixpkgs-unstable
```

---

## Installing Packages

Installing packages is easy!

Just add them to the packages list in your `devenv.nix` file.

```devenv.nix
# the pkgs `input` is a reference to the Nixpkgs repository where build definitions are stored for all packaged in the Nix store
{pkgs, ...}: {
    packages = [
        pkgs.git
    ];

    # Defines a minimal environment for python-latest which only contains
    # python (and maybe it's build dependencies)
    languages.python.enable = true;
}
```

This produces a dev environment with `python-latest` and `git`

```bash
$ python --version
Python 3.11.3

$ git --version
git version 2.40.1
```

---

## Scripts

You can define scripts relevant to your project using the `scripts` configurations.

e.g. a build script to build your python package/binary with poetry

```devenv.nix
# the pkgs `input` is a reference to the Nixpkgs repository where build definitions are stored for all packaged in the Nix store
{pkgs, ...}: {
    packages = [
        pkgs.git
    ];

    # Build scripts
    scripts.build.exec = ''
        poetry build
    '';

    # Defines a minimal environment for python-latest which only contains
    # python (and maybe it's build dependencies)
    languages.python = {
        enable = true;
        poetry.enable = true;
    };
}
```

---

## Languages

As we saw earlier adding a language is really simple we just need to add
it to the `languages` attribute-set (dictionary)

Lets enable **Javascript** with `node` version 18

```nix
{pkgs, ...}: {
    # ... the rest of your config
    languages.javascript = {
        enable = true;
        package = pkgs.nodejs_18;
    };
}
```

```bash
$ node --version
v18.16.0
```

--- 

## Services and Processes

Devenv also allows you to define services and processes relating to your project. 
Let's take for example we have a simple CRUD app with integration tests which 
need to run against a Postgres database. We can easily add this database in our CI 
by specifying it in our `devenv.nix` 

```devenv.nix
    # ... The rest of your config above this
    services.postgres = {
        enable = true;
        package = pkgs.postgresql_14;
    };
```

We can check that `postgres` is installed and properly started by running

```bash
devenv up
```

---


