# The script will help you to build an .aab, .apk and/or a .ipa file with version name
# and version number from git

VERSION_NAME=$(git describe --tags --abbrev=0)

# Use commit count to generate a progressive VERSION_CODE
VERSION_CODE=$(git rev-list --all --count)

# VERSION_NUMBER (the commit) is an hex string BUT flutter accept only number for the build number,
# so we will convert later to int and after in the dart code to hex again
VERSION_NUMBER=$(git rev-parse --short HEAD)

ANSWER="y";

while [ "$ANSWER" = "y"  ]; do

  printf "What would you like to do?\n"
  select platform in "Generate Signed Bundle (Google Play Store)" "Generate APK" "Generate IPA"; do
    echo "Preparing build version \"$VERSION_NAME ($VERSION_CODE)\" - commit $VERSION_NUMBER"
    case $platform in
        "Generate Signed Bundle (Google Play Store)" ) flutter build appbundle --build-name="$VERSION_NAME-$VERSION_NUMBER" --build-number=$VERSION_CODE --target-platform android-arm,android-arm64,android-x64; open "build/app/outputs/bundle/release/"; break;;
        "Generate APK" ) flutter build apk --build-name="$VERSION_NAME-$VERSION_NUMBER" --build-number=$VERSION_CODE; open "build/app/outputs/apk/release/"; break;;
        "Generate IPA" ) flutter build ios --build-name="$VERSION_NAME-$VERSION_NUMBER" --build-number=$VERSION_CODE; cd build/ios/iphoneos/; [ ! -d Payload ] && mkdir Payload; mv Runner.app Payload/; zip -r Payload.zip Payload; mv Payload.zip SafectoryConfig-$VERSION_NAME-${VERSION_NUMBER}"("$(date '+%Y-%m-%d')")-"release.ipa; rm -r Payload; open ""; break;;
    esac

  done

  printf "Would you like to continue with building operation?(y/n)\n"
  read -r ANSWER
done
