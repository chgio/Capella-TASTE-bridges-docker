# python4capella-docker

Docker image to run [Python4Capella](https://github.com/ylussaud/python4capella) scripts on [Capella](https://github.com/eclipse-capella/capella) models, for continuous integration or containerised testing.

## Installation

```sh
$ docker pull chgio/python4capella-docker:latest
```

## Usage

### With sample content

The container comes pre-packaged with [a number of sample Python4Capella scripts](https://github.com/labs4capella/python4capella/tree/master/plugins/Python4Capella/sample_scripts) and the [sample *In-Flight Entertainment System* Capella model](https://github.com/eclipse-capella/capella/tree/master/samples/In-Flight%20Entertainment%20System), so you can get a taste of how it works with:

```sh
$ docker run chgio/python4capella-docker:latest \
  sample/scripts/Python4Capella-Scripts/List_logical_components_in_console.py \
  sample/models/In-Flight\ Entertainment\ System/In-Flight\ Entertainment\ System.aird
```

### With custom content

The container expects bind mounts at `/workspace/user/scripts` and `/workspace/user/models`, so you can run your custom Python4Capella script on your custom Capella model with:

```sh
$ docker run \
  -v <path to Python4Capella project>:/workspace/user/scripts/<name of Python4Capella project> \
  -v <path to Capella project>:/workspace/user/models/<name of Capella project> \
  chgio/python4capella-docker:latest \
  /user/scripts/<name of Python4Capella project>/<path to Python4Capella script>.py \
  /user/models/<name of Python4Capella project>/<path to Capella model>.aird
```

where:

| field                              | meaning                                                                                                |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `<path to Python4Capella project>` | local path to the directory containing the `.project` file for your Python4Capella project             |
| `<name of Python4Capella project>` | the name of your Python4Capella project, matching the one between `<name>` tags in its `.project` file |
| `<path to Capella project>`        | local path to the directory containing the `.project` file for your Capella project                    |
| `<name of Capella project>`        | the name of your Capella project, matching the one between `<name>` tags in its `.project` file        |
| `<path to Python4Capella script>`  | path to the `.py` script to run, relative to `<path to Python4Capella project>`                        |
| `<path to Capella model>`          | path to the `.aird` model to run the script on, relative to `<path to Capella project>`                |

## Acknowledgements

The following projects were taken as significant reference on installing, configuring, and executing Capella and Python4Capella in Docker:
- [materpillar/Capella-HTML-exporter](https://github.com/materpillar/Capella-HTML-exporter)
- [jamilraichouni/ease-ipython](https://github.com/jamilraichouni/ease-ipython)
