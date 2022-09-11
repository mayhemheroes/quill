FROM fuzzers/libfuzzer:12.0

RUN apt-get update
RUN apt install -y  build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev
RUN  git clone https://github.com/odygrd/quill.git
WORKDIR /quill
RUN cmake -DBUILD_SHARED_LIBS=ON .
RUN make
RUN make install
COPY fuzzers/fuzz.cpp .
RUN clang++ -I/usr/local/include -L/usr/local/lib -fsanitize=fuzzer,address fuzz.cpp -o /fuzz -lquill -std=c++17
ENV LD_LIBRARY_PATH=/usr/local/lib

ENTRYPOINT []
CMD  ["/fuzz"]
