FROM openkbs/jdk11-mvn-py3

MAINTAINER DrSnowbird@openkbs.org

#################################
#### ---- X11 & Firefox ---- ####
#################################
RUN sudo apt-get update && \
    sudo apt-get install -qqy x11-apps && \
    sudo apt-get install -y firefox

#################################
#### ---- Google-Chrome ---- ####
#################################
WORKDIR ${HOME}
ARG CHROME_DEB=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN wget -q ${CHROME_DEB} && \
    sudo apt-get install -y fonts-liberation libgbm1 xdg-utils && \
    sudo dpkg -i $(basename ${CHROME_DEB}) && \
    rm -f $(basename ${CHROME_DEB}) 
    
############################################
#### ---- More lib modules install ---- ####
############################################
RUN sudo apt install -y libcanberra-gtk0 libcanberra-gtk-module

COPY scripts ${HOME}/scripts
COPY bin ${HOME}/bin
RUN sudo chown -R ${USER}:${USER} ${HOME}/scripts ${HOME}/bin && \
    chmod +x ${HOME}/scripts/*.sh ${HOME}/bin/*.sh
    
###########################################
#### ---- entrypoint script setup ---- ####
###########################################
#RUN ln -s ${INSTALL_DIR}/scripts/docker-entrypoint.sh /docker-entrypoint.sh
#COPY docker-entrypoint.sh /docker-entrypoint.sh
#RUN chmod +x /docker-entrypoint.sh

#############################################
#### ---- USER as Owner for scripts ---- ####
#############################################
#RUN chown ${USER}:${USER} -R ${INSTALL_DIR}/scripts /docker-entrypoint.sh


############################################
#### ---- Volumes: data, workspace ---- ####
############################################
ENV WORKSPACE=${HOME}/workspace
ENV DATA=${HOME}/data

RUN mkdir -p ${WORKSPACE} ${DATA}

VOLUME ${DATA}
VOLUME ${WORKSPACE}

##############################
#### ---- Entrypoint ---- ####
##############################
USER ${USER}
WORKDIR ${HOME}

#ENTRYPOINT ["/docker-entrypoint.sh"]
#CMD ["/bin/bash"]
#CMD ["/usr/bin/xeyes"]
## -- firefox having audio issue (no sound) but video ok -- #
#CMD ["/usr/bin/firefox"]
CMD ["/usr/bin/google-chrome","--no-sandbox", "https://github.com/DrSnowbird/jdk11-mvn-py3", "https://music.youtube.com/"]
#CMD ["/usr/bin/google-chrome","--no-sandbox","--disable-gpu", "https://github.com/DrSnowbird/jdk11-mvn-py3"]
#CMD ["/usr/bin/google-chrome","--no-sandbox","--disable-gpu", "https://www.google.com/"]
