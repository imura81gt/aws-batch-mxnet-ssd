# https://github.com/dmlc/mxnet/blob/master/docker/cuda/7.5/Dockerfile
FROM nvidia/cuda:7.5-cudnn5-devel

RUN apt-get update && apt-get install -y \
  git \
  libopenblas-dev \
  libopencv-dev \
  python-dev \
  python-numpy \
  python-setuptools \
  python-opencv \
  python-matplotlib \
  wget \
  python-pip \
  unzip

RUN pip install easydict

RUN cd /root && git clone --recursive https://github.com/dmlc/mxnet && cd mxnet && \
  cp make/config.mk . && \
  sed -i 's/USE_BLAS = atlas/USE_BLAS = openblas/g' config.mk && \
  sed -i 's/USE_CUDA = 0/USE_CUDA = 1/g' config.mk && \
  sed -i 's/USE_CUDA_PATH = NONE/USE_CUDA_PATH = \/usr\/local\/cuda/g' config.mk && \
  sed -i 's/USE_CUDNN = 0/USE_CUDNN = 1/g' config.mk && \
  sed -i 's/EXTRA_OPERATORS =$/EXTRA_OPERATORS = example\/ssd\/operator/g' config.mk && \
  make -j"$(nproc)"

RUN pip install awscli

ENV PYTHONPATH /root/mxnet/python

WORKDIR /root/mxnet
