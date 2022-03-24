export SINGULARITY_TMPDIR="/mnt/data/"
export SINGULARITY_BIND="./shinyapps/:/srv/shiny-server/,./data/:/srv/data/,./countsData/:/srv/countsData/,./shinylog/:/var/log/shiny-server/,./config/:/etc/shiny-server/,./classes/:/usr/local/src/myscripts/"

singularity run --env DOB_URL='http://localhost:3000/' idep.sif R -e "library('shiny');runApp('/srv/shiny-server/idep94/', port=9000)"
