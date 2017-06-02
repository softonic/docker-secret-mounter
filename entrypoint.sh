#!/usr/bin/env sh

function usage() {
    cat <<EOF
You need to define the environment variables: GIT_REPO, GIT_PK, PROJECT and ENVIRONMENT
EOF
    exit 1;
}

if [[ -z $GIT_REPO ]] || [[ -z $GIT_PK ]] || [[ -z $PROJECT ]] || [[ -z $ENVIRONMENT ]]; then
    usage
fi

tmp1=${GIT_REPO/:*/}
repo_domain=${tmp1/git@/}

mkdir ~/.ssh/

ssh-keyscan ${repo_domain} >> domainKey
cat domainKey >> ~/.ssh/known_hosts

echo $GIT_PK > /tmp/pk
base64 -d /tmp/pk > ~/.ssh/id_rsa
chmod 0600 ~/.ssh/id_rsa

mkdir /tmp/secrets
cd /tmp/secrets
git init
git remote add -f origin $GIT_REPO
git config core.sparseCheckout true

echo "$PROJECT/$ENVIRONMENT/" >> .git/info/sparse-checkout
git pull origin master

mv /tmp/secrets/$PROJECT/$ENVIRONMENT/* /secrets

echo Secrets of $PROJECT for environment $ENVIRONMENT available in secrets dir or mounted path in host
