<snippet-begin 1_mispCoreInstall.sh>
installCore () {
  debug "Installing ${LBLUE}MISP${NC} core"
  # Download MISP using git in the /var/www/ directory.
  if [[ ! -d ${PATH_TO_MISP} ]]; then
    sudo mkdir ${PATH_TO_MISP}
    sudo chown ${WWW_USER}:${WWW_USER} ${PATH_TO_MISP}
    false; while [[ $? -ne 0 ]]; do checkAptLock; ${SUDO_WWW} git clone https://github.com/MISP/MISP.git ${PATH_TO_MISP}; done
    false; while [[ $? -ne 0 ]]; do checkAptLock; ${SUDO_WWW} git -C ${PATH_TO_MISP} submodule update --progress --init --recursive; done
    # Make git ignore filesystem permission differences for submodules
    ${SUDO_WWW} git -C ${PATH_TO_MISP} submodule foreach --recursive git config core.filemode false

    # Make git ignore filesystem permission differences
    ${SUDO_WWW} git -C ${PATH_TO_MISP} config core.filemode false

    # Create a python3 virtualenv
    ${SUDO_WWW} virtualenv -p python3 ${PATH_TO_MISP}/venv

    # make pip happy
    sudo mkdir /var/www/.cache/
    sudo chown ${WWW_USER}:${WWW_USER} /var/www/.cache

    for dependency in CybOXProject/python-cybox STIXProject/python-stix MAECProject/python-maec CybOXProject/mixbox; do
      false; while [[ $? -ne 0 ]]; do checkAptLock; ${SUDO_WWW} git clone https://github.com/${dependency}.git ${PATH_TO_MISP_SCRIPTS}/${dependency##*/}; done
      ${SUDO_WWW} git -C ${PATH_TO_MISP_SCRIPTS}/${dependency##*/} config core.filemode false
      ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install ${PATH_TO_MISP_SCRIPTS}/${dependency##*/}
    done

    debug "Install python-stix2"
    ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install ${PATH_TO_MISP}/cti-python-stix2

    debug "Install PyMISP"
    ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install ${PATH_TO_MISP}/PyMISP

    # FIXME: Remove libfaup etc once the egg has the library baked-in
    sudo apt-get install cmake libcaca-dev liblua5.3-dev -y
    cd /tmp
    false; while [[ $? -ne 0 ]]; do [[ ! -d "faup" ]] && ${SUDO_CMD} git clone https://github.com/stricaud/faup.git faup; done
    false; while [[ $? -ne 0 ]]; do [[ ! -d "gtcaca" ]] && ${SUDO_CMD} git clone https://github.com/stricaud/gtcaca.git gtcaca; done
    sudo chown -R ${MISP_USER}:${MISP_USER} faup gtcaca
    cd gtcaca
    ${SUDO_CMD} mkdir -p build
    cd build
    ${SUDO_CMD} cmake .. && ${SUDO_CMD} make
    sudo make install
    cd ../../faup
    ${SUDO_CMD} mkdir -p build
    cd build
    ${SUDO_CMD} cmake .. && ${SUDO_CMD} make
    sudo make install
    sudo ldconfig

    # install pydeep
    false; while [[ $? -ne 0 ]]; do checkAptLock; ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install git+https://github.com/kbandla/pydeep.git; done

    # install lief
    ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install lief

    # install zmq needed by mispzmq
    ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install zmq redis

    # install python-magic
    ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install python-magic

    # install plyara
    ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install plyara
  else
    debug "Trying to git pull existing install"
    ${SUDO_WWW} git pull -C ${PATH_TO_MISP}
    false; while [[ $? -ne 0 ]]; do ${SUDO_WWW} git -C ${PATH_TO_MISP} submodule update --progress --init --recursive; done

    ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install -U setuptools pip lief zmq redis python-magic plyara
    for dependency in CybOXProject/python-cybox STIXProject/python-stix MAECProject/python-maec CybOXProject/mixbox; do
      false; while [[ $? -ne 0 ]]; do checkAptLock; ${SUDO_WWW} git -C ${PATH_TO_MISP_SCRIPTS}/${dependency##*/} pull; done
      ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install -U ${PATH_TO_MISP_SCRIPTS}/${dependency##*/}
    done

    ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install -U ${PATH_TO_MISP}/cti-python-stix2
    ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install -U ${PATH_TO_MISP}/PyMISP
    false; while [[ $? -ne 0 ]]; do checkAptLock; ${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install -U git+https://github.com/kbandla/pydeep.git; done
fi
}
# <snippet-end 1_mispCoreInstall.sh>
