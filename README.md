# docker-lambda

Manage DockerHub builds for lambda-node at ZOL

The intended purpose of this repository is to provide branches and tags for a docker image with node to emulate an aws lambda.

See [CHANGELOG](CHANGELOG.md) for all available versions.

This image is based on [AWS Official Images](https://hub.docker.com/r/amazon/aws-lambda-nodejs), RIC and RIE.
Instead of letting the container expose the port and having to make a curl request against it, the container accept directly a json file and will make the curl itself.

## How to update

If you want to apply updates on this repository, checkout to the current tag you want to start with, 
create a new branch and apply your updates. Finally, tag the changes with a comprehensive changelog.

Before pushing your changes, make sure it works by building the image locally :

    docker build -t zolweb/docker-lambda:latest .

## Rules to follow

- Each change must come with an updated [CHANGELOG](CHANGELOG.md)

## Notable facts

Installed packages : this image should be used for **development** only, it contains multiple packages that may not be needed for production. 
Use it at your own risk.

This image is not designed to run in an AWS lambda. Please see the official documentation to build your own aws lambda image to do this.

## Dockerhub

This project is built on [dockerhub, on zolweb account](https://hub.docker.com/repository/docker/zolweb/docker-lambda). 
Images are free to use and come AS IS. ZOL is not responsible for any mis-usage or any problem it may cause.

Automatic building is enabled, any tag push or master push trigger a build as following :

|   Source   | Type | Tag docker |
|:----------:|:----:|:----------:|
|    main    | branch | latest |
| /^[0-9.]+/ | tag | {sourceref} |

Examples :
- Pushing the tag `16.0.16` gives the image `zolweb/docker-lambda:16.0.16`
- Pushing to `main` updates the image `zolweb/docker-lambda:latest`

You should not use `latest` tag, as the push order on this repository is done following our own needs, not node versions. Use tag instead.

## How to use it

Assuming your directory structure look like :

```
your-lambda/
|---- events/
|---- | ---- example-event1.json
|---- | ---- example-event2.json
|---- src/
|---- | ---- index.js
|---- | ---- package.json
```

From the `your-lambda` directory, you may use this image like this :

```bash
docker run \
        --rm \
        -v $(PWD)/src:/var/task:ro,delegated \
        -v $(PWD)/events:/var/events:ro,delegated \
        -i \
        zolweb/docker-lambda:18.14 example-event1.json
```

You may see info and warning at each execution :
```
10 Mar 2023 11:19:54,322 [INFO] (rapid) exec '/var/runtime/bootstrap' (cwd=/var/task, handler=)
10 Mar 2023 11:19:54,326 [INFO] (rapid) extensionsDisabledByLayer(/opt/disable-extensions-jwigqn8j) -> stat /opt/disable-extensions-jwigqn8j: no such file or directory
10 Mar 2023 11:19:54,326 [WARNING] (rapid) Cannot list external agents error=open /opt/extensions: no such file or directory
```

The warning comes from AWS Lambda RIE / RIC, we don't know how to get rid of it (by fixing it, not hiding).
There are some articles or stackoverflow posts ([1](https://www.srvrlss.io/blog/Amazon-Lambda-docker/), [2](https://stackoverflow.com/questions/68090955/test-an-aws-lambda-locally-using-docker-container-image), [3](https://mdneuzerling.com/post/r-on-aws-lambda-with-containers/)) where it doesn't seem to bother anyone.
Even if it's stressful for us to not understand why it appears, we can't do much about it.
