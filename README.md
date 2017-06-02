# softonic/secret-mounter

Mounts the specified secrets in a predefined folder that should be mounted as a volume

## Description

This image is designed to obtain in runtime a list of files (usually secrets) from a remote repository.
In this case the structure of the repository needs to follow the convention of:

- PROJECT/ENVIRONMENT

For example

```
gitroot
  |- project1
  |    |- staging
  |    |    |- secret1
  |    |    |- secret2
  |    |- production
  |         |- secret1
  |         |- secret2
  |- project2
       |- staging
            |- secret1
            |- secret2
...
```

## Usage

You'll need to launch the container with the needed parameters.

### Parameters

- PROJECT: project name
- ENVIRONMENT: Project environment where the secrets are valid
- GIT_REPO: Repository that contains the secrets
- GIT_PK: Private key to get access to the repo

### Execution

```
docker run \
  -ti \
  --rm \
  -v $PWD/sec:/secrets \
  -e PROJECT=project2 \
  -e ENVIRONMENT=staging \
  -e GIT_REPO=git@bitbucket.org:softonic-development/secrets.git \
  -e GIT_PK=$(base64 ~/.ssh/id_rsa_secrets) \
  softonic/secret-mounter
```

