FROM eclipse/ubuntu_jre
# Use asdf-vm to install erlang and elixir

MAINTAINER sunder.narayanaswamy@gmail.com


ENV ERLANG_VER 19.3
ENV ELIXIR_VER 1.4.5

# Install asdf dependencies 
# Install postgres & node required for Phoenix framework
RUN sudo apt-get update && sudo apt-get install -y \
	automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev \
	postgresql postgresql-contrib \
	nodejs npm \
	nginx

ENV HOME /home/user

WORKDIR $HOME

RUN git clone https://github.com/asdf-vm/asdf.git ./.asdf --branch v0.3.0 && \
	echo -e '\n. $HOME/.asdf/asdf.sh' >> ./.bashrc && \
	echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ./.bashrc

ENV PATH $HOME/.asdf/bin:$PATH

RUN bash -c "asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git" && \	
	bash -c "asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git" && \
	bash -c "asdf install erlang $ERLANG_VER" && \
	bash -c "asdf install elixir $ELIXIR_VER" 

RUN sudo apt-get -y autoremove && \
    sudo apt-get -y clean  && \
    sudo apt-get -y autoclean  && \
    sudo rm -rf /var/lib/apt/lists/* 
    
CMD sudo service postgresql start && tail -f /dev/null