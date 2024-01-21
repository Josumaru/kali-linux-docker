build:
	docker buildx build --load -f Dockerfile -t kali-linux .
run:
	docker run -it --name kali-linux --hostname josu -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix kali-linux
