In this part, you will be creating a pod that will be running a simple web-server and JavaScript code.

## Create the JavaScript code
Create the `server.js`{{open}} JavaScript file and paste the following code into it:

<pre class="file" data-filename="server.js" data-target="replace">
var os = require("os");
var http = require('http');
var hostname = os.hostname();

var handleRequest = function(request, response) {
    console.log('Received request for URL: ' + request.url);
    response.writeHead(200);
    if (request.url.includes('bye')) {
        respoonse.end(1/0); 
    }
    response.end('Hello World from ' + hostname + "!\n");
};
var www = http.createServer(handleRequest);
www.listen(8080);
</pre>

## Creating the Dockerfile
To utilize the k8s clusters and containers, the web-server will be containerized and running in a Docker image. To use that, you will need to  create a `Dockerfile`{{open}} with the following content to put the `server.js` file into it:

<pre class="file" data-filename="Dockerfile" data-target="replace">
FROM node:6.9.2
EXPOSE 8080
COPY server.js .
CMD node server.js
</pre>

## Creating the Docker Image
Now that the Dockerfile and the the web-server code is ready, the Docker image can be created with the `docker build --tag hello-node:v1 .`{{execute}}.

It will pull the base NodeJS container image and modify it according to the Dockerfile. After it is finished, the image is available locally with the `hello-node:v1` name.