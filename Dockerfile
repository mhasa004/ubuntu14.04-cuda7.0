FROM ubuntu:14.04
MAINTAINER Mahmudul Hasan <mhasa004@ucr.edu>

# A docker container with the Nvidia kernel module, CUDA drivers, and torch7 installed

ENV CUDA_RUN http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run

# The one inside the cuda_7.0.28_linux.run does not mathces with the driver of the host machine
# Following driver version matches our host machine driver. 
ENV CUDA_DRIVER http://us.download.nvidia.com/XFree86/Linux-x86_64/352.21/NVIDIA-Linux-x86_64-352.21.run

RUN apt-get update && apt-get install -q -y \
  wget \
  build-essential

RUN wget $CUDA_DRIVER && chmod +x *.run && \
  ./NVIDIA-Linux-x86_64-352.21.run -s -N --no-kernel-module

RUN wget $CUDA_RUN && chmod +x *.run
RUN ./cuda_7.0.28_linux.run -extract=/
RUN chmod +x *.run && ./cuda-linux64-rel-*.run -noprompt

RUN rm *.run

# Ensure the CUDA libs and binaries are in the correct environment variables
ENV LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-7.0/lib64
ENV PATH=$PATH:/usr/local/cuda-7.0/bin
