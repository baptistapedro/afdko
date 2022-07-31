FROM fuzzers/afl:2.52
RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev uuid uuid-dev  pkg-config libssl-dev curl
RUN curl -OL https://github.com/Kitware/CMake/releases/download/v3.20.1/cmake-3.20.1.tar.gz
RUN  tar xvfz cmake-3.20.1.tar.gz
WORKDIR /cmake-3.20.1
RUN cmake .
RUN make
RUN make install
WORKDIR /
RUN git clone https://github.com/adobe-type-tools/afdko.git
WORKDIR /afdko
RUN cmake -DCMAKE_C_COMPILER=afl-gcc -DCMAKE_CXX_COMPILER=afl-g++ .
RUN make
RUN make install
RUN mkdir /psCorpus
RUN cp ./tests/rotatefont_data/input/*.ps /psCorpus
RUN cp ./tests/makeotf_data/input/cidfont-noPSname.ps /psCorpus
RUN cp ./tests/fdkutils_data/input/*.ps /psCorpus
RUN cp ./tests/mergefonts_data/input/bug635/*.ps /psCorpus


ENTRYPOINT ["afl-fuzz", "-i", "/psCorpus", "-o", "/afdko-rotate-Out"]
CMD ["/afdko/bin/rotatefont", "-f", "@@"]
