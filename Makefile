#!/usr/bin/env make
# Voraussetzungen:
# application.properties: server.port=80
# in der IDE: java version: jdk 17
#
# Die make-Befehle schrittweise ausführen und dabei nicht die Tests vergessen
# Falls erforderlich: make delete_kind_cluster
#  1.  make build_project
#  2.  make run_image
#  3.  make stop_website
#  4.  make tagging_image
#  5.  make create_kind_cluster_with_registry
#  6.  make get_clusters
#  7.  make apply_deployment
#  8.  make port_forward_deployment
#  9.  make apply_service
# 10.  make port_forward_service
# WICHTIG bei Verwendung von WINDOWS: in der host-Datei im Verzeichnis C:\Windows\System32\drivers\etc
# folgenden Eintrag machen: 127.0.0.1 project.com
# Entsprechend müssen in der host-Datei für LINUX-Betriebssysteme die Einträge angepasst werden.
# 11. make install_ingress_controller
# 12. make get_all_ingress_nginx
# 13. make apply_ingress


.PHONY: delete_kind_cluster delete_docker_registry \
        build_project run_image stop_website tagging_image \
        install_kind create_kind_cluster create_docker_registry \
        connect_registry_to_kind_network connect_registry_to_kind \
        create_kind_cluster_with_registry get_clusters \
        apply_deployment port_forward_deployment \
        apply_service port_forward_service \
        install_ingress_controller get_all_ingress_nginx apply_ingress


# Falls erforderlich:
delete_kind_cluster: delete_docker_registry
	kind delete cluster --name project.com
	
delete_docker_registry:
	docker stop local-registry && docker rm local-registry        



build_project:
	docker build -t project.com .
	
run_image:
	docker run --rm --name project.com -p 5000:80 -d project.com

# TEST:
# in der Adressleiste des Browsers folgende URL eingeben: 127.0.0.1:5000/projects oder localhost:5000/projects  
    
stop_website:
	docker stop project.com

tagging_image:	   
	docker tag project.com:latest 127.0.0.1:5000/project.com

# unter der URL https://github.com/kubernetes-sigs/kind/releases sind die entsprechenden Kind-Releases für jedes
# Betriebssystem aufgeführt, für die neueste Version v0.17.0 hier für Windows 11. Entsprechend bei sich anpassen.
install_kind:
	curl --location --output ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.17.0/kind-windows-amd64
	   ./kind --version

create_kind_cluster: install_kind create_docker_registry
	kind create cluster --name project.com --config ./Kubernetes/kind_config.yaml || true && \
		kubectl get nodes

create_docker_registry:
	if docker ps | grep -q 'local-registry'; \
	then echo "---> local-registry already created; skipping"; \
#	then docker run -d -p 5000:5000 --name local-registry --restart=always registry:2; \
#	else echo "---> local-registry is already running. There's nothing to do here."; \
	else docker run --name local-registry -d --restart=always -p 5000:5000 registry:2; \
	fi

connect_registry_to_kind_network:
	docker network connect kind local-registry || true;

connect_registry_to_kind: connect_registry_to_kind_network
	kubectl apply -f ./Kubernetes/kind_configmap.yaml;

create_kind_cluster_with_registry:
	$(MAKE) create_kind_cluster && $(MAKE) connect_registry_to_kind

	
# TEST in der Konsole manuell eingeben:
# curl http://localhost:5000/v2  ---> href="/v2/">Moved Permanently</a>.
# curl --location http://localhost:5000/v2   ---> in der letzten Zeile ganz zum Schluss: {}


#  TEST, ob lokale Registry funktioniert, daher manuell ausführen:	
#  docker push 127.0.0.1:5000/project.com
#  docker image rm 127.0.0.1:5000/project.com		
#  docker pull 127.0.0.1:5000/project.com


get_clusters:
	kind get clusters

apply_deployment:
	kubectl apply -f ./Kubernetes/deployment.yaml && \
	sleep 15 && \
	kubectl get pods -l app=project.com
	
port_forward_deployment:
	kubectl port-forward deployment/project.com 8080:80
# TEST im Browser: localhost:8080/projects
# mit <STRG> und <C> abbrechen


apply_service:
	kubectl apply -f ./Kubernetes/service.yaml && \
	sleep 15 && \
	kubectl get all -l app=project.com

port_forward_service:	
	kubectl port-forward service/project-svc 8080:80
# TEST im Browser: localhost:8080/projects
# mit <STRG> und <C> abbrechen


install_ingress_controller:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml && \
	sleep 5 && \
	kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

get_all_ingress_nginx:
	kubectl get all -n ingress-nginx

apply_ingress:
	kubectl apply -f ./Kubernetes/ingress.yaml
	
#TEST:
# Unter der URL project.com/projects sollte jetzt die Website angezeigt werden.
#TEST:
# In der host-Datei im Verzeichnis C:\Windows\System32\drivers\etc den Eintrag project.com z.B. in projecttest.com umbenennen.
# Unter der alten URL project.com/projects sollte jetzt ein PAGE NOT FOUND angezeigt werden.
# Ausführen von: kubectl delete -f ./Kubernetes/ingress.yaml. In der ingress.yaml - Datei 
# den Parameter unter - host: von project.com auf projecttest.com ändern und speichern.
# Ausführen von: kubectl apply -f ./Kubernetes/ingress.yaml.
# In der Adresszeile im Browser jetzt projecttest.com/projects eingeben und die Website sollte wieder zu sehen sein.
# Nach dem Test den Originalzustand wiederherstellen.






