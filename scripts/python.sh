# Python
RUN apt install pip python3-venv -y\
    && mkdir /root/.virtualenvs\
    && cd /root/.virtualenvs\
    && python3 -m venv debugpy\
    && debugpy/bin/python -m pip install debugpy\
    && sed -i -e 's/python = false/python = true/g' /root/.config/nvim/lua/plugins/config/local_config.lua
