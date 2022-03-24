echo "Downloading and converting docker image in sif format"
singularity pull idep.sif docker://gexijin/idep:latest 

echo 'Sif images have been built. Start downloading data. This step can take hours'

# Download and unzip database files; this can take 2 hours
# use Amazon server for faster download
wget http://18.235.92.206:8080/data104.tar.gz

#slower server
#wget --no-check-certificate https://mft.sdstate.edu/public/file/3Y66fppA0Eym0G41taPtRw/data104.tar.gz .
tar xvzf data104.tar.gz
rm data104.tar.gz

echo 'Data has been downloaded and unziped'
