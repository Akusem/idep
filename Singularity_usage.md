1. Be in this folder

2. Create local singularity image from remote docker image 
```zsh
singularity pull idep.sif docker://gexijin/idep:latest 
```

3. Set tmp folder
```zsh
export SINGULARITY_TMPDIR="/path/with/space"
```

4. Set the Volumes
```zsh
export SINGULARITY_BIND="./shinyapps/:/srv/shiny-server/,./data/:/srv/data/,./countsData/:/srv/countsData/,./shinylog/:/var/log/shiny-server/,./config/:/etc/shiny-server/,./classes/:/usr/local/src/myscripts/"
```

5. Launch iDEP
```zsh
singularity run idep.sif R -e "library('shiny'); runApp('/srv/shiny-server/idep94/')"
```
