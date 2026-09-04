#!/bin/sh
#
# Gradle Wrapper startup script for POSIX shells.
# Licensed under the Apache License, Version 2.0
#

# Resolve the real path of this script, following symlinks.
PRG="$0"
while [ -h "$PRG" ]; do
    ls=$(ls -ld "$PRG")
    link=$(expr "$ls" : '.*-> \(.*\)$')
    case $link in
        /*) PRG="$link" ;;
        *)  PRG=$(dirname "$PRG")/"$link" ;;
    esac
done
APP_HOME=$(cd "$(dirname "$PRG")" > /dev/null && pwd -P)
CLASSPATH="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"

# Locate the java command.
if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
    JAVACMD="$JAVA_HOME/bin/java"
elif [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/jre/sh/java" ]; then
    JAVACMD="$JAVA_HOME/jre/sh/java"
else
    JAVACMD=$(command -v java)
    if [ -z "$JAVACMD" ]; then
        echo "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH." >&2
        echo "Please install a Java 17 JDK (or set JAVA_HOME) and try again." >&2
        exit 1
    fi
fi

if [ ! -f "$CLASSPATH" ]; then
    echo "ERROR: $CLASSPATH is missing." >&2
    echo "The Gradle wrapper JAR must be committed to the repository." >&2
    exit 1
fi

exec "$JAVACMD" -Xmx64m -Xms64m $JAVA_OPTS $GRADLE_OPTS \
    "-Dorg.gradle.appname=$(basename "$0")" \
    -classpath "$CLASSPATH" \
    org.gradle.wrapper.GradleWrapperMain \
    "$@"
