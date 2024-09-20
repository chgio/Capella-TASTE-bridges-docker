# python4capella-docker

Docker image for [Python4Capella](https://github.com/ylussaud/python4capella).

Patchwork of [materpillar/Capella-HTML-exporter](https://github.com/materpillar/Capella-HTML-exporter), [jamilraichouni/ease-ipython](https://github.com/jamilraichouni/ease-ipython), and own work.

## Installation

```sh
$ docker pull chgio/python4capella-docker:latest
```

## Usage

Run a sample Python4Capella script on a sample Capella model with:

```sh
$ docker run -it chgio/python4capella-docker:latest sample/scripts/Python4Capella-Scripts/List_logical_components_in_console.py sample/models/In-Flight\ Entertainment\ System/In-Flight\ Entertainment\ System.aird
```
