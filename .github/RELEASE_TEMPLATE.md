Get it from [DockerHub](https://hub.docker.com/r/chgio/python4capella-docker/tags):

```sh
docker pull chgio/python4capella-docker:${{ env.version_nov }}
```

| Dependency      | Version                |
| --------------- | ---------------------- |
| Capella         | ${{ env.capella_ver }} |
| Py4J            | ${{ env.py4j_ver }}    |
| EASE            | ${{ env.ease_ver }}    |
| Python4Capella  | ${{ env.py4c_ver }}    |
| Requirements-VP | ${{ env.reqvp_ver }}   |
