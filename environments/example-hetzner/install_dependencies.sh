rm -rf venv
python3 -m venv venv
source venv/bin/activate

pip3 install ansible==6.5.0
pip3 install hcloud==1.18.0
pip3 install yq
pip3 install https://github.com/neuroforgede/docker-stack-deploy/archive/refs/tags/0.2.3.zip
ansible-galaxy collection install hetzner.hcloud:==1.8.2

rm -rf swarmsible
mkdir -p swarmsible
cd swarmsible
git clone https://github.com/neuroforgede/swarmsible.git
git clone https://github.com/neuroforgede/swarmsible-hetzner.git
