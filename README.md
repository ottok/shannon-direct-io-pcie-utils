# Shannon Direct-IO PCIe device utils

Build:
```
# Start a Docker container for clean builds
docker run -it -v ${PWD}/..:/build -w /build/shannon-direct-io-pcie-utils ubuntu:bionic bash

# Install build tools, includes mk-build-deps
apt update && apt install devscripts equivs  --no-install-recommends --yes

# Automatically install all build dependencies from debian/control
mk-build-deps debian/control -r -i

# Build package
dpkg-buildpackage -us -uc

# View result
ls -la ../
dpkg-deb -c ../*.deb

# Exit Docker
exit

# Ensure any files written by Docker are again user owned
sudo chown -R $USER ../

# Upload to Launchpad PPA
COMMIT_ID="$(git log -n 1 --oneline | cut -d ' ' -f 1)"
PPA=ppa:otto/shannon-direct-io-pcie
cd ..
backportpackage -u $PPA -d trusty -S ~`date '+%s'`.$COMMIT_ID shannon-utils_*.dsc -y
backportpackage -u $PPA -d xenial -S ~`date '+%s'`.$COMMIT_ID shannon-utils_*.dsc -y
backportpackage -u $PPA -d bionic -S ~`date '+%s'`.$COMMIT_ID shannon-utils_*.dsc -y
