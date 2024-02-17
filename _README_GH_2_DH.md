[source] https://docs.docker.com/language/golang/configure-ci-cd/

# 1. Create Repo

1. GH: push gs-ping-db 
> git remote set-url origin https://github.com/your-username/your-repository.git
> git add -A; git commit -m "my commit"; git push -u origin main
2. GH: create DH secret (DockerID/PAT in repo > secrets and variables > Actions > Org/ lvl.. = karbproton-github-org )

# 2. Create Workflow
1. GH Actions: [set up a workflow yourself] -> .github/workflows/main.yml
2. cp / paste 

# 3. Run Workflow

