# Terminal Server
## Heroku Deployment
```bash
# Create new application and repository
heroku create -a APP_NAME
# Add existing remote repository
heroku git:remote -a APP_NAME
# Set stack to container
heroku stack:set container
```