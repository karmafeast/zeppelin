FROM apache/zeppelin:0.8.1

RUN echo "user      soft      nofile      500000" >> /etc/security/limits.conf && \
    echo "user      hard      nofile      500000" >> /etc/security/limits.conf && \
    echo "root      soft      nofile      500000" >> /etc/security/limits.conf && \
    echo "root      hard      nofile      500000" >> /etc/security/limits.conf && \
    echo "session required                        pam_limits.so" >> /etc/pam.d/common-session

RUN add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install software-properties-common -y && \
    apt install python3 -y

COPY requirements.txt /

RUN conda update -n base conda -y
RUN conda update --all -y
RUN conda install -c anaconda python=3.7 -y
RUN pip install -r /requirements.txt
RUN python -m nltk.downloader -d /usr/local/share/nltk_data all
RUN conda install -c johnsnowlabs spark-nlp -y

RUN wget http://apache.mirror.triple-it.nl/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz \
&&  tar -xzf spark-2.4.4-bin-hadoop2.7.tgz \
&&  mv spark-2.4.4-bin-hadoop2.7 /opt/spark

COPY spark-defaults.conf /opt/spark/conf/
COPY interpreter.json /zeppelin/conf/

ENV SPARK_HOME=/opt/spark
ENV SPARK_SUBMIT_OPTIONS="--packages com.johnsnowlabs.nlp:spark-nlp_2.11:2.3.2"

EXPOSE 8080