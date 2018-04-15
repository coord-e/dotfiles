#!/bin/bash

. .bashrc

sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev

mkdir ~/tmp ~/bin ~/lib

cd ~/tmp

git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-192.0.0-linux-x86_64.tar.gz
tar xf google-cloud-sdk-192.0.0-linux-x86_64.tar.gz
mv google-cloud-sdk ~/.google-cloud-sdk

. ~/.bashrc

pyenv install 3.6.5
pyenv global 3.6.5

pip install pipenv
pip install awscli

rbenv install 2.5.1
rbenv global 2.5.1
gem install travis -v 1.8.8 --no-rdoc --no-ri

brew install git-secrets
git secrets --install ~/.git-templates/git-secrets
git secrets --register-aws ~/.git-templates/git-secrets

brew install fzf
$(brew --prefix)/opt/fzf/install


