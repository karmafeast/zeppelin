FROM apache/zeppelin:0.8.1

RUN add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install software-properties-common -y && \
    apt install python3 -y

RUN conda update -n base conda -y
RUN conda update --all -y
RUN conda install -c anaconda python=3.7 -y
RUN pip install --upgrade numpy && \
    pip install --upgrade pandas && \
	pip install --upgrade beautifulsoup4 && \
	pip install --upgrade networkx && \
	pip install --upgrade awscli && \
	pip install --upgrade spark-nlp

RUN conda install -c johnsnowlabs spark-nlp -y

RUN wget http://apache.mirror.triple-it.nl/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz \
&&  tar -xzf spark-2.4.4-bin-hadoop2.7.tgz \
&&  mv spark-2.4.4-bin-hadoop2.7 /opt/spark

ENV SPARK_HOME=/opt/spark

EXPOSE 8080