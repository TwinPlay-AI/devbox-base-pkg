# Twinplay Scaffold

The Scaffold project allows TwinPlay projects to be initialised by adding unique, replicable base files to the project repository.

To initialise (or re-initialise) a project, simply run the following commands:

## Getting Started

This project uses [devbox](https://github.com/jetify-com/devbox) to manage its development environment.

1. Install devbox:

```sh
curl -fsSL https://get.jetpack.io/devbox | bash
```

2. Create `devbox.json` in your project root:

```json
{
  "$schema": "https://raw.githubusercontent.com/jetify-com/devbox/0.12.0/.schema/devbox.schema.json",
  "packages": [],
  "include": [
    "github:TwinPlay-AI/devbox-base-pkg?dir=plugins/docker",
    "github:TwinPlay-AI/devbox-base-pkg?dir=plugins/terraform",
    "github:TwinPlay-AI/devbox-base-pkg?dir=plugins/twinplay"
  ],
  "shell": {
    "init_hook": [],
    "scripts": {}
  }
}
```

3. Run `devbox shell`

## Requirements

|Name|Version|Docs|
|---|---|---|
|devbox| `>= 2.47`| [Installation](https://www.jetify.com/devbox/docs/installing_devbox/) |
