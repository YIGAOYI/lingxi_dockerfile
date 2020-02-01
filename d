RUN GIT_CLONE="git clone --depth=1" && \
    git config --global http.lowSpeedLimit 0 && \
    git config --global http.lowSpeedTime 999999 && \
    git config --global http.postBuffer 524288000 && \
    $GIT_CLONE https://github.com/Kitware/CMake ~/cmake && \
    cd ~/cmake && \
    ./bootstrap && \
    make -j"$(nproc)" install
RUN wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py
RUN python3.6  ~/get-pip.py