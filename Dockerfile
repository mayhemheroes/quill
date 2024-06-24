FROM fuzzers/libfuzzer:12.0 as builder

RUN apt-get update
RUN apt install -y  build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev
ADD . /quill
WORKDIR /quill
RUN cmake -DBUILD_SHARED_LIBS=ON .
RUN make
RUN make install
ADD fuzzers/fuzz_trace.cpp .
RUN clang++ -I/usr/local/include -L/usr/local/lib -fsanitize=fuzzer,address fuzz_trace.cpp -o fuzz_trace -lquill -std=c++17

FROM fuzzers/libfuzzer:12.0
COPY --from=builder /quill/fuzz_trace /
COPY --from=builder /usr/local/lib/* /usr/local/lib/
# Find deps shared objects
ENV LD_LIBRARY_PATH=/usr/local/lib

ENTRYPOINT []
CMD  ["/fuzz_trace"]
