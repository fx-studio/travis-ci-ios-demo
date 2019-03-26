#!/bin/bash

KEY_CHAIN=ios-build.keychain
security create-keychain -p travis $KEY_CHAIN
# Make the keychain the default so identities are found
security default-keychain -s $KEY_CHAIN
# Unlock the keychain
security unlock-keychain -p travis $KEY_CHAIN
# Set keychain locking timeout to 3600 seconds
security set-keychain-settings -t 3600 -u $KEY_CHAIN

# Add certificates to keychain and allow codesign to access them
#security import ./scripts/certs/dis.cer -k $KEY_CHAIN -T /usr/bin/codesign
#security import ./scripts/certs/dev.cer -k $KEY_CHAIN -T /usr/bin/codesign

security import ./scripts/certs/dis.p12 -k $KEY_CHAIN -P 12345678  -T /usr/bin/codesign
security import ./scripts/certs/dev.p12 -k $KEY_CHAIN -P 12345678  -T /usr/bin/codesign

security set-key-partition-list -S apple-tool:,apple: -s -k travis ~/Library/Keychains/ios-build.keychain

echo "list keychains: "
security list-keychains
echo " ****** "

echo "find indentities keychains: "
security find-identity -p codesigning  ~/Library/Keychains/ios-build.keychain
echo " ****** "

# Put the provisioning profile in place
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

uuid=`grep UUID -A1 -a ./scripts/profiles/TheLastProject_Dev.mobileprovision | grep -io "[-A-F0-9]\{36\}"`
cp ./scripts/profiles/TheLastProject_Dev.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/$uuid.mobileprovision

uuid=`grep UUID -A1 -a ./scripts/profiles/TheLastProject_AdHoc.mobileprovision | grep -io "[-A-F0-9]\{36\}"`
cp ./scripts/profiles/TheLastProject_AdHoc.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/$uuid.mobileprovision

#cp ./scripts/profiles/TheLastProject_Dev.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
#cp ./scripts/profiles/TheLastProject_AdHoc.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/

echo "show provisioning profile"
ls ~/Library/MobileDevice/Provisioning\ Profiles
echo " ****** "