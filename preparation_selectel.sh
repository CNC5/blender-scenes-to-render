apt-get update
apt-get install blender tmux htop awscli
wget https://mirrors.dotsrc.org/blender/release/Blender3.2/blender-3.2.0-linux-x64.tar.xz
tar -xpvf blender-3.2.0-linux-x64.tar.xz
rm blender-3.2.0-linux-x64.tar.xz
add-apt-repository ppa:graphics-drivers/ppa
apt-get update
apt-get install linux-headers-$(uname -r)
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-ubuntu2204-11-7-local_11.7.0-515.43.04-1_amd64.deb
dpkg -i cuda-repo-ubuntu2204-11-7-local_11.7.0-515.43.04-1_amd64.deb
cp /var/cuda-repo-ubuntu2204-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
apt-get update
apt-get install -y cuda
mkdir -p /render/output
cd /root
wget https://766730.selcdn.ru/scene_storage/highway_scene.blend
cd blender-3.2.0-linux-x64
./blender -b /root/highway_scene.blend -E CYCLES -o /render/output/ -noaudio -s 1 -e 2 -a -- --cycles-device CUDA+CPU
tar -zcvf render_output.tar.gz /render/output/
aws configure --endpoint-url=https://s3.storage.selcloud.ru
aws --endpoint-url=https://s3.storage.selcloud.ru s3 cp render_output.tar.xz s3://scene_storage/
