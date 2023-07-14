FILE_NAME=ActionsGradleDemo-$VERSION
MAIN_JAR=$FILE_NAME.jar
JAVA_VERSION=19

# create installers and runtime (options are set in build.gradle)
echo "creating installers and runtime"
./gradlew build

echo "detecting required modules"
detected_modules=`$JAVA_HOME/bin/jdeps \
  --multi-release ${JAVA_VERSION} \
  --ignore-missing-deps \
  --print-module-deps \
  --class-path "build/libs/*" \
    build/classes/java/main/com/javafx/actionsgradledemo/Main.class`
echo "detected modules: ${detected_modules}"

echo "creating java runtime image"
$JAVA_HOME/bin/jlink \
  --no-header-files \
  --no-man-pages  \
  --compress=2  \
  --strip-debug \
  --add-modules "${detected_modules}" \
  --include-locales=en \
  --output build/image

for type in "deb" "rpm"
do
  echo "Creating installer of type ... $type"

  $JAVA_HOME/bin/jpackage \
  --type $type \
  --dest build/releases \
  --input build/libs/ \
  --name ActionsDemo \
  --main-class com.javafx.actionsgradledemo.Main \
  --main-jar ${MAIN_JAR} \
  --java-options '-Djdk.gtk.version=2' \
  --runtime-image build/image \
  --icon src/main/resources/com/javafx/actionsgradledemo/icons/logo.png \
  --linux-shortcut \
  --linux-menu-group "ActionsDemo" \
  --app-version ${VERSION} \
  --vendor "DarkDeveloper" \
  --description "description" \

done


# create fat jar of project (see build.gradle)
echo "creating jar"
./gradlew fatJar

echo "creating releases folder"
mkdir ./build/releases/

echo "zipping runtime folder"
tar -czf ./build/releases/$FILE_NAME-linux-bin.tar.gz ./build/image/


echo "creating run file for other linux distributions"
mkdir ./builders/linux-installer/application
mv ./build/image/* ./builders/linux-installer/application
makeself ./builders/linux-installer $FILE_NAME-linux.run "Description" ./install.sh
chmod +x $FILE_NAME-linux.run

echo "moving files to releases"
#ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
#mv ./build/jpackage/$FILE_NAME* ./build/releases/
mv ./build/libs/*.jar ./build/releases/$FILE_NAME-linux.jar
mv ./*.run ./build/releases

