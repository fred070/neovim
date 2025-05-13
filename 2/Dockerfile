FROM redhat/ubi9

ARG KUBECTL_VERSION=v1.29.0 \
    TMUX_VERSION=3.5 \
		USER=fred

ENV TERM=xterm-256color \
		USER_HOME=/home/$USER

RUN dnf update -y \
	&& dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y \
	&& dnf --disablerepo="*" --enablerepo="epel" list available

RUN dnf install -y --allowerasing \
		gcc make autoconf automake pkgconfig \
		ncurses-devel libevent-devel \
	&& dnf clean all

RUN dnf install -y --allowerasing \
			 bat \
			 bind-utils \
			 coreutils \
			 curl \
			 file \
			 fontconfig \
			 gcc \
			 git \
			 iproute \
			 iputils \
			 lsof \
			 nc \
			 ncurses \
			 neovim \
			 procps \
			 ripgrep \
			 sudo \
			 util-linux \
			 util-linux-user \ 
			 wget \
			 zsh && \
     dnf clean all

RUN useradd -m -s /bin/zsh $USER \
		&& mkdir -p /etc/sudoers.d/ \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER

RUN cd /tmp \
	&& wget https://invisible-island.net/datafiles/release/byacc.tar.gz \
	&& tar -xvzf byacc.tar.gz \
	&& cd byacc-* \
	&& ./configure && make && make install 

RUN cd /tmp && \
    wget https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz && \
    tar -xvzf tmux-$TMUX_VERSION.tar.gz && \
    cd tmux-$TMUX_VERSION && \
    ./configure && make && make install

RUN curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

RUN rm -rfd /tmp/*

USER $USER 
WORKDIR $USER_HOME

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    $USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k

RUN git clone --depth 1 https://github.com/junegunn/fzf.git $USER_HOME/.fzf \
	&& $USER_HOME/.fzf/install

RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git \
 	   	$USER_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    	$USER_HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
		&& git clone https://github.com/MichaelAquilina/zsh-you-should-use.git \
    	$USER_HOME/.oh-my-zsh/custom/plugins/you-should-use \
		&& git clone https://github.com/z-shell/F-Sy-H.git \
    	$USER_HOME/.oh-my-zsh/custom/plugins/F-Sy-H \
		&& git clone https://github.com/fdellwing/zsh-bat \
    	$USER_HOME/.oh-my-zsh/custom/plugins/zsh-bat


CMD ["/bin/zsh"]
  
# how to use fzf 
# 
# fzf integration
#     nvim
# 
# neovim current line 1
    # basic commands for
    # 1. autojump
    # 2. fzf (done)
    # 
# lazy vim
# 	z.lua
