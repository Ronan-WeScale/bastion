.PHONY: prepare
prepare: ### Install workspace env dependencies
	@echo "—————————————————————————————— PYTHON REQUIREMENTS ———————————————————————————"
	@pip3 install -U pip --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} PIP3" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} PIP3"

	@pip3 install -U wheel --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} WHEEL" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} WHEEL"

	@pip3 install -U setuptools --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} SETUPTOOLS" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} SETUPTOOLS"

	@pip3 install -U --no-cache-dir -q -r requirements.txt &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} PIP REQUIREMENTS" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} PIP REQUIREMENTS"

	@echo "————————————————————————————— ANSIBLE REQUIREMENTS ———————————————————————————"
	@ansible-galaxy collection install -fr ${PWD}/requirements.yml
	@ansible-galaxy role install -fr ${PWD}/requirements.yml

system:
	ansible-playbook playbooks/00_system.yml -i inventory --limit="localhost,$(name)"

docker:
	ansible-playbook playbooks/01_docker.yml -i inventory --limit=$(name)

bastion:
	ansible-playbook playbooks/02_bastion.yml -i inventory --limit=$(name)

new: system docker bastion

.PHONY: new-bastion
new-bastion:
	@ [ -n  "$(name)" ] || \
	( \
	echo ----------------------------------- BASTION HOST --------------------------------- && \
	echo && \
	echo "Usage:\n\tmake new-bastion name=HOSTNAME \n" && \
	exit 1 \
	)
	make new

new-user:
	ansible-playbook playbooks/02_bastion.yml -i inventory --tags="adduser"

new-admin:
	ansible-playbook playbooks/00_system.yml -i inventory --tags="addadmin"

update-bastion:
	ansible-playbook playbooks/02_bastion.yml -i inventory --tags="update-bastion"

update-docker:
	ansible-playbook playbooks/02_bastion.yml -i inventory --tags="update-docker"