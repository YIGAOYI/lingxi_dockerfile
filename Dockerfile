# ==================================================================
# module list
# ------------------------------------------------------------------
# python        3.6    (apt)
# pytorch       1.3    (pip)
# torchvision   0.4    (pip)
# ==================================================================

FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ENV LANG C.UTF-8

RUN rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN  apt-get clean

# ==================================================================
# tools
# ------------------------------------------------------------------

RUN rm -rf /var/lib/apt/lists/* /tmp/* ~/* && \
    apt-get -y update && \
    APT_INSTALL="apt-get install -y --no-install-recommends" && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        apt-utils \
        build-essential \
        cmake \
        ca-certificates \
        wget \
        git \
        vim \
        libssl-dev \
        curl \
        unzip \
        unrar


# ==================================================================
# python
# ------------------------------------------------------------------

RUN rm -rf /var/lib/apt/lists/* /tmp/* ~/* && \
    apt-get install -f && \
    apt-get -y update && \
    APT_INSTALL="apt-get install -y --no-install-recommends" && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        software-properties-common

RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        python3.6 \
        python3.6-dev \
        python3-distutils-extra \
        python-pip \
        python3-pip

COPY pip.conf /etc/pip.conf


RUN ln -s /usr/bin/python3.6 /usr/local/bin/python3
RUN ln -s /usr/bin/python3.6 /usr/local/bin/python

RUN PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    $PIP_INSTALL \
        setuptools \
        && \
    $PIP_INSTALL \
        numpy \
        scipy \
        pandas \
        cloudpickle \
        scikit-image>=0.14.2 \
        scikit-learn \
        matplotlib \
        Cython

# ==================================================================
# pytorch
# ------------------------------------------------------------------

# RUN PIP_INSTALL="python  -m pip --default-timeout=1000 --no-cache-dir install --upgrade"
RUN python -m pip --default-timeout=1000 --no-cache-dir install --upgrade pillow==6.2.1
RUN python -m pip --default-timeout=1000 --no-cache-dir install --upgrade torch==1.3.1
RUN python -m pip --default-timeout=10000 --no-cache-dir install  -U --upgrade torchvision==0.4.2
RUN python -m pip --default-timeout=1000 --no-cache-dir install --upgrade future
RUN python -m pip --default-timeout=1000 --no-cache-dir install --upgrade numpy
RUN python -m pip --default-timeout=1000 --no-cache-dir install --upgrade protobuf
RUN python -m pip --default-timeout=1000 --no-cache-dir install --upgrade enum34
RUN python -m pip --default-timeout=1000 --no-cache-dir install --upgrade pyyaml
RUN python -m pip --default-timeout=1000 --no-cache-dir install --upgrade typing



# ==================================================================
# config & cleanup
# ------------------------------------------------------------------

RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*