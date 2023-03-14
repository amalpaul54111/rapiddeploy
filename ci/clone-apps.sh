# !/bin/bash

# Use PAT or ssh for private repos.

## To use SSH keys place the private key as ssh-keys/ci and uncomment following
# mkdir -p repos ~/.ssh
# chown 0600 ssh-keys/ci
# chown 0700 ~/.ssh
# ssh-keyscan -t rsa git.example.com >> ~/.ssh/known_hosts
# eval $(ssh-agent -s)
# ssh-add ssh-keys/ci

## To clone private repos through ssh use following instead of https.
# git clone --depth 1 --branch master ssh://git@github.com/frappe/twilio-integration repos/twilio_integration

## To use PAT use PERSONAL_ACCESS_TOKEN environment variable which is set through CI secret.
# git clone --depth 1 --branch develop https://github.com/frappe/health repos/healthcare 
git clone --depth 1 --branch develop https://pythonpen:$PYTHONPEN_GITHUB_PASSWORD@github.com/pythonpen/healthcare repos/healthcare
#git clone --depth 1 --branch main https://pythonpen:$PYTHONPEN_GITHUB_PASSWORD@github.com/pythonpen/tac_core repos/tac_core
git clone --depth 1 --branch main https://pythonpen:$PYTHONPEN_GITHUB_PASSWORD@github.com/pythonpen/tacten_core repos/tacten_core

# Following are public repositories.


# git clone --depth 1 --branch develop https://github.com/frappe/health repos/healthcare
git clone --depth 1 --branch develop https://github.com/frappe/payments repos/payments
git clone --depth 1 --branch master https://github.com/frappe/wiki repos/wiki
git clone --depth 1 --branch version-14 https://github.com/resilient-tech/india-compliance repos/india_compliance
git clone --depth 1 --branch develop https://github.com/frappe/hrms repos/hrms
git clone --depth 1 --branch master https://github.com/Tacten/frappe-attachments-s3 repos/frappe_s3_attachment
git clone --depth 1 --branch develop https://github.com/yrestom/POS-Awesome repos/posawesome
git clone --depth 1 --branch main https://github.com/frappe/desk repos/frappedesk
# git clone --depth 1 --branch main https://github.com/frappe/drive repos/drive
