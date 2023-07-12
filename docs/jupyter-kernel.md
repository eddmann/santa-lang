# Jupyter Kernel

[![Rust](https://img.shields.io/badge/rust-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)](https://github.com/eddmann/santa-lang-rs/tree/main/runtime/jupyter)

This runtime exposes the language as a [kernel](https://docs.jupyter.org/en/latest/projects/kernels.html) which can be used within a [Jupyter Notebook](https://jupyter.org/).
Evaluation of the language (and built-ins) is exposed at this time, the AoC Runner is currently not present.

Similiar to other kernels (i.e. [IPython](https://ipykernel.readthedocs.io/en/stable/)), the notebook uses a shared _variable environment_ across all the evaluated code blocks.
This allows you to define variables within one block and access them in subsquently evaluated blocks.

## Release

The kernel is released as a standalone platform binary, which can be installed automatically with the host Jupyter Notebook instance by running `./santa-lang-jupyter-* install`.

| Platform     | Release                                                                                                                                                                   |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux/GNU    | [`santa-lang-jupyter-0.0.3-x86_64-unknown-linux-gnu`](https://github.com/eddmann/santa-lang-rs/releases/download/0.0.3/santa-lang-jupyter-0.0.3-x86_64-unknown-linux-gnu) |
| Apple/Darwin | [`santa-lang-jupyter-0.0.3-x86_64-apple-darwin`](https://github.com/eddmann/santa-lang-rs/releases/download/0.0.3/santa-lang-jupyter-0.0.3-x86_64-apple-darwin)           |

## Docker

In addition to the above binaries, a [Dockerfile](https://github.com/eddmann/santa-lang-rs/blob/main/runtime/jupyter/build.Dockerfile) is provided alongside the source to run a containerized JupyterLab instance locally with the kernel pre-installed.
This eases the process of getting up and running with the Notebook environment.

<figure markdown>
  ![Jupyter Kernel](assets/jupyter-kernel.png){ width="650" }
</figure>

## External Functions

There are currently no external functions (i.e. `read`, `puts`) which are registered with the runtime.
