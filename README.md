# Terminal Server

## Local build

```bash
docker build -t terminal-server:latest .
docker run --rm --name terminal-server -d -p 3000:3000 \
    --env PORT=3000 \
    --env USERNAME=potaesm \
    --env PASSWORD=aabbccdd \
    terminal-server:latest
```

## Heroku Deployment

```bash
# Create new application and repository
heroku create -a APP_NAME
# Add existing remote repository
heroku git:remote -a APP_NAME
# Set stack to container
heroku stack:set container
```

# Config Vars

```bash
USERNAME    potaesm
PASSWORD    aabbccdd
```
