FILE_NAME=ActionsGradleDemo-$VERSION
MAIN_JAR=$FILE_NAME.jar
JAVA_VERSION=19

# create installers and runtime (options are set in build.gradle)
echo "creating installers and runtime"

# create fat jar of project (see build.gradle)
echo "creating jar"
./gradlew fatJar

tree

echo "jlinking"
./gradlew jlink

tree

for type in "deb" "rpm"
do
  echo "Creating installer of type ... $type"

  $JAVA_HOME/bin/jpackage \
  --type $type \
  --dest ./build/releases \
  --name ActionsDemo \
  --main-class com.javafx.actionsgradledemo.Main \
  --java-options '-Djdk.gtk.version=2' \
#  --runtime-image ./build/image \
  --icon src/main/resources/com/javafx/actionsgradledemo/icons/logo.png \
  --linux-shortcut \
  --linux-menu-group "ActionsDemo" \
  --app-version ${VERSION} \
  --vendor "DarkDeveloper" \
  --description "description" \

done


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

