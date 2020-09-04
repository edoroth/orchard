FROM ubuntu:16.04
WORKDIR /root
RUN apt-get update && apt-get install -y \
  bzip2 \
  doxygen \
  g++ \
  gcc \
  git \
  libgmp3-dev \
  m4 \
  make \
  patch \
  python \
  python-tk \
  python-pip \
  tmux \
  vim \
  wget \
  yasm \ 
  && wget -qO- https://get.haskellstack.org/ | sh

RUN pip install --upgrade pip
RUN pip install numpy
RUN pip install haversine
RUN pip install matplotlib

ADD source/ /root/source
ADD config/ /root/config
ADD depends.sh .
RUN ["bash", "depends.sh"]

ADD SMtweaks/ /root/SMtweaks
ADD test/ /root/test
ADD install.sh .
RUN ["bash", "install.sh"]

ADD dockerFiles/Programs/ /root/SCALE-MAMBA/Programs

ADD README.md .

ADD robustness/ /root/robustness

RUN git clone https://github.com/hengchu/cps-fuzz.git && \
    cd cps-fuzz && \
    stack run

CMD ["/bin/bash"]
