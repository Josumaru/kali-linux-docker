# Set the baseImage to use for subsequent instructions. 
FROM kalilinux/kali-rolling

# Define a variable with an optional default value that users can override at build-time when using docker build.
ARG USERNAME=josu
ARG PASSWORD=josu

# Execute any commands on top of the current image as a new layer and commit the results. for caching don't execute multiple command on RUN
# update repository and donwload kali linux matapackage
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y kali-linux-default kali-desktop-xfce sudo kitty neofetch alacritty && \
    useradd -m ${USERNAME} -p $(openssl passwd ${PASSWORD}) && \
    usermod -aG sudo ${USERNAME} && \
    chsh -s $(which zsh) ${USERNAME}

# Set the working directory for any subsequent ADD, COPY, CMD, ENTRYPOINT, or RUN instructions that follow it in the Dockerfile.
WORKDIR /home/${USERNAME}

# Set the user name or UID to use when running the image in addition to any subsequent CMD, ENTRYPOINT, or RUN instructions that follow it in the Dockerfile.
USER ${USERNAME}

# oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/${USERNAME}/.config/powerlevel10k && \
    echo 'source /home/${USERNAME}/.config/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# oh-my-zsh plugin
# autosuggestions
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins}/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

# syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

# Copy files or folders from source to the dest path in the image's filesystem.
COPY config/.zshrc /home/${USERNAME}/
COPY config/kitty.conf /home/${USERNAME}/.config/kitty/kitty.conf
COPY config/.p10k.zsh /home/${USERNAME}/