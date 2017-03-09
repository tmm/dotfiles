
# startup virtualenv-burrito
if [ -f $HOME/.venvburrito/startup.sh ]; then
    . $HOME/.venvburrito/startup.sh
fi

# NVM
export NVM_DIR="/Users/tom/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home

# Postgres
export POSTGRES_HOME=/Applications/Postgres.app/Contents/Versions/9.6
export PATH=$POSTGRES_HOME/bin:$PATH

# Apache Spark
export SPARK_HOME=/usr/local/Cellar/apache-spark/2.1.0/libexec
export PATH=$SPARK_HOME/bin:$PATH
export PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
export PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH