# Readme

## Docker image

### Test locally

```sh
docker network create app
docker run --network app --name mongo -d mongo
docker build -t practical .
docker run --network app -p 80:3000 -e NODE_ENV=development -e MONGODB_URL=mongodb://mongo:27017/database -d practical npm start
```
