{pkgs, ...}: {
  env.DBNAME = "testdb";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    slides
  ];

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    ${pkgs.gum}/bin/gum style --border="rounded" --bold -- "Hello from devenv!"
  '';
  scripts.run.exec = ''
    poetry run python src/main.py
  '';

  enterShell = ''
    hello
  '';

  # https://devenv.sh/languages/
  languages.python = {
    enable = true;
    version = "3.11";
    poetry.enable = true;
  };

  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_18;
  };

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    # Shell linting
    shellcheck.enable = true;
    # Python linting, static analysis
    black = {
      enable = true;
    };
    flake8.enable = true;
    isort.enable = true;
    ruff.enable = true;
    # Toml formatting
    taplo.enable = true;
  };

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
  services.postgres = {
    enable = true;
    initialDatabases = [
      {
        name = "userdb";
        schema = ./db/userdb.sql;
      }
    ];
    initialScript = ''
      CREATE USER postgres SUPERUSER;
    '';
    listen_addresses = "127.0.0.1";
    port = 5432;
  };
}
