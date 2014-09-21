Jdk 1.8 (un des 3 derniers)
http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

eclipse-JEE-luna 
https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/R/eclipse-jee-luna-R-win32-x86_64.zip

tomcat 8.0.9  (32-bit Windows zip ou 64-bit Windows zip)
http://tomcat.apache.org/download-80.cgi

wamp
http://www.clubic.com/telecharger-fiche27009-wampserver.html

Spring tool suit for eclipse luna à dl ac eclipse
aller sur Help -> marketpace
rechercher spring tool suit
dl la bonne version par rapport a son eclipse

Lancer eclipse.
Import project (General -> Existing Projects into workspace -> browse (your project path)
Cilque droit sur le projet : Run as -> Run on server -> Manually define a new server (choose Apache -> Tomcat v8.0 Server) + path du repertoir tomcat que vous avez dl auparavant. (Sommet du repertoir tomcat à mettre seulement)

Configurer Wamp, php Myadmin (noml utilisateur:  ‘root’ et mdp: ‘1234’) prendre le fichier initDB et l’importer sur la DB nommé : “project_handler”.
