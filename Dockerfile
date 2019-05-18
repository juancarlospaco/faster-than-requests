FROM nimlang/nim
RUN : \
    && apt-get update -y --quiet \
    && apt-get install -y curl python3-pycurl wget python3-wget python3-pip \
    && apt-get clean -y --quiet
RUN pip3 install --upgrade pip==19.1.1
RUN pip3 install --upgrade requests==2.22.0
RUN pip3 install --upgrade urllib3==1.25.2
RUN nimble -y refresh ; nimble -y install nimpy@0.1.0
ADD src/faster_than_requests.nim /tmp/
RUN nim c -d:release -d:ssl --app:lib --passL:"-s" --gc:markAndSweep --passC:"-march=native" --passC:"-flto" --passC:"-ffast-math" --out:/tmp/faster_than_requests.so /tmp/faster_than_requests.nim
ADD server4benchmarks.nim /tmp/
RUN nim c -d:release /tmp/server4benchmarks.nim
ADD benchmark.py /tmp/
RUN rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/nimblecache/* /var/log/journal/*
EXPOSE 5000
