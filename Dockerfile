FROM golang:1.12 as go-build
ENV GO111MODULE on

# Copy the source from GitHub repository
# RUN git clone https://github.com/aws/amazon-kinesis-streams-for-fluent-bit /kinesis-streams

# Copy the source from current directory
COPY . /kinesis-streams


WORKDIR /kinesis-streams
RUN make release

# Get the latest aws-for-fluent-bit image from dockerhub
FROM amazon/aws-for-fluent-bit:2.5.0
COPY --from=go-build /kinesis-streams/bin/kinesis.so /fluent-bit/kinesis.so

# Entry point
CMD ["/fluent-bit/bin/fluent-bit", "-e", "/fluent-bit/kinesis.so", "-c", "/fluent-bit/etc/fluent-bit.conf"]