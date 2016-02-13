

* 安裝gradle
[http://bgasparotto.com/install-gradle-on-windows-and-ubuntu/]



* 遇到 gradle build error
[http://stackoverflow.com/questions/29459590/gradle-project-sync-failed]

`gradle clean build --refresh-dependencies`

* 遇到 ERROR: JAVA_HOME is set to an invalid directory: /usr/lib/jvm/default-java
[http://stackoverflow.com/questions/22307516/gradle-finds-wrong-java-home-even-though-its-correctly-set]

`sudo vi /usr/bin/gradle`

`export JAVA_HOME=/usr/lib/jvm/default-java  # 取代`

