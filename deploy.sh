# building the images.
docker build -t brennobiwan/multi-client:latest -t brennobiwan/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t brennobiwan/multi-server:latest -t brennobiwan/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t brennobiwan/multi-worker:latest -t brennobiwan/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

# pushing the images with the tag "latest" to DockerHub.
docker push brennobiwan/multi-client:latest
docker push brennobiwan/multi-server:latest
docker push brennobiwan/multi-worker:latest

# pushing the images with the tag "$GIT_SHA" to DockerHub.
docker push brennobiwan/multi-client:$GIT_SHA
docker push brennobiwan/multi-server:$GIT_SHA
docker push brennobiwan/multi-worker:$GIT_SHA

# PS: the same image is being pushed twice into DockerHub, one with the tag "latest" and another with the value of "$GIT_SHA" as tag.

# applying the kubernetes config files to the cluster. The files here will deploy the images from DockerHub, which have the ":latest" label implicitly applied.
kubectl apply -f k8s
# PS: we already configured gcloud to install kubectl, so we can just enter kubectl commands.

# these commands will set the deployments image to the one with the ":$GIT_SHA" tag to make sure that new commits will trigger the deployment process.
kubectl set image deployments/server-deployment server=brennobiwan/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=brennobiwan/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=brennobiwan/multi-worker:$GIT_SHA
