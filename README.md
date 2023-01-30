# Kind-Cluster mit Spring Boot Microservice

!/usr/bin/env make

 **WICHTIG:** bei Verwendung von WINDOWS: in der host-Datei im Verzeichnis C:\Windows\System32\drivers\etc
 folgenden Eintrag anfügen: 127.0.0.1 project.com
  Entsprechend muss in der host-Datei für LINUX-Betriebssysteme der Eintrag eingefügt werden.
  
Unter der **URL** https://github.com/kubernetes-sigs/kind/releases sind die entsprechenden **Kind-Releases** für jedes
Betriebssystem für die neueste Version v0.17.0 aufgeführt. Im Makefile entsprechend bei sich anpassen.

** Voraussetzungen: **
 application.properties: server.port=80
 in der IDE: java version: jdk 17

Das Makefile beinhaltet alle Befehle, die der Reihe nach ausgeführt werden müssen.
Als Kontrolle immer die als Kommentar im Makefile beschriebenen Tests ausführen.

Hier die **make-Befehle** :
Falls erforderlich vorher: make delete_kind_cluster
  1.  make build_project
  2.  make run_image
  3.  make stop_website
  4.  make tagging_image
  5.  make create_kind_cluster_with_registry
  6.  make get_clusters
  7.  make apply_deployment
  8.  make port_forward_deployment
  9.  make apply_service
 10.  make port_forward_service
 11. make install_ingress_controller
 12. make get_all_ingress_nginx
 13. make apply_ingress# mvc-springboot
