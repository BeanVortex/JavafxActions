# JavafxActions
Github Actions for javafx (gradle)

It is just a simple plain javafx project. 
the files and folders you should take a loot are:
- build.gradle
- .guthub
- builders

in order to actions work properly, I used RELEASE_TOKEN in ci_cd.yml file. you should create a personal access token through settings of your account:

Settings > Developer Settings > Personal access tokens > fine-grained tokens 
here you create new token and select your repo and permisions you need are:
- Actions
- Contents
- Deployments
- Secrets (READ ONLY)

after creating the token, copy it and go to your repo's settings:
Secrets and variables > Actions > New repository secret

the name you choose here is accessable through actions environment
