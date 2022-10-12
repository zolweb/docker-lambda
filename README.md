# docker-lambda

Manage DockerHub builds for lambda-node at ZOL

The intended purpose of this repository is to provide branches and tags for a docker image with node to emulate an aws lambda.

See [CHANGELOG](CHANGELOG.md) for all available versions.

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
- Pushing to `master` updates the image `zolweb/docker-lambda:latest`

You should not use `latest` tag, as the push order on this repository is done following our own needs, not node versions. Use tag instead.

## How to use it

The docker image open a light web server on port 8080 (This is all included in 
[the AWS Lambda Runtime Interface Emulator (RIE)](https://docs.aws.amazon.com/lambda/latest/dg/images-test.html) tool). 

###  Start a lambda locally

Example:
```

	docker run \
		--rm -d \
		-p 9000\:8080 \
		--name my-lambda \
		--network reverseproxy \
		-v $(PWD)/src:/function:ro,delegated \
		--env-file=$(PWD)/../../../.env \
		--entrypoint /aws-lambda/aws-lambda-rie \
		zolweb/docker-lambda \
		/usr/local/bin/npx aws-lambda-ric index.handler
```

The code is mounted in volume on `/function`. 

### View logs
```
	docker logs -f my-lambda
```

To invoke the lambda, make a simple http call:

```
http://localhost:9000/2015-03-31/functions/function/invocations
{
    "var1": 3
}

```

NOTE: you can only make one call at the same time.

### Stop the container
```

	docker stop my-lambda

```
