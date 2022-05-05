FROM ubuntu:20.04
RUN apt-get -qq update && \
    apt-get -qq upgrade && \
    apt-get -qq install software-properties-common -y && \
    apt-get -qq install python3 -y && \
    apt-get -qq install python3-pip -y && \
    apt-get -qq install python3-lxml -y && \
    apt-get -qq install aria2 -y \
    apt-get -qq install git -y
WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN git clone https://github.com/meganz/sdk.git --depth=1 -b v$MEGA_SDK_VERSION ~/home/sdk \
    && cd ~/home/sdk && rm -rf .git \
    && autoupdate -fIv && ./autogen.sh     && ./configure --disable-silent-rules --enable-python --with-sodium --disable-examples \
    && make -j$(nproc --all) \
    && cd bindings/python/ \
    && python3 setup.py bdist_wheel \
    && cd dist/ \
    && pip3 install --no-cache-dir megasdk-*.whl
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt-get -y update && apt-get -y upgrade && apt-get -y autoremove && apt-get -y autoclean
ENV TZ=Asia/Kolkata
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en
CMD ["bash","start.sh"]
