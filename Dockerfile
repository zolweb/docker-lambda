# Define custom function directory
ARG FUNCTION_DIR="/function"
FROM node:16-buster-slim

# Include global arg in this stage of the build
ARG FUNCTION_DIR

# Install aws-lambda-cpp and aws-lambda-rie build dependencies
RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev \
    autoconf \
    libtool \
    python3

RUN mkdir -p ${FUNCTION_DIR}

# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Install RIE
ADD bin/aws-lambda-rie /aws-lambda/aws-lambda-rie
RUN chmod +x /aws-lambda/aws-lambda-rie

# If the dependency is not in package.json uncomment the following line
RUN npm install -g aws-lambda-ric

# WITH RIE INSTALLED ON THE LOCAL HOST
ENTRYPOINT ["/usr/local/bin/npx", "aws-lambda-ric"]
CMD ["index.handler"]
