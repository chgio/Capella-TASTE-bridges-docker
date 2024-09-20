# python4capella-docker

Docker image for [Python4Capella](https://github.com/ylussaud/python4capella).

Patchwork of [materpillar/Capella-HTML-exporter](https://github.com/materpillar/Capella-HTML-exporter), [jamilraichouni/ease-ipython](https://github.com/jamilraichouni/ease-ipython), and own work.

## Installation

```sh
$ docker pull chgio/python4capella-docker:latest
```

## Usage

```sh
$ docker run -it python4capella-docker:latest sh
```

## Testing

Run a sample Python4Capella script on a sample Capella model with:

```sh
$ /workspace/sample/scripts/run-sample.sh
```
