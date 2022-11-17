/interface/bridge/add name=dockers
/ip/address/add address=172.20.0.254/24 interface=dockers

/interface/veth/add name=veth91 address=172.20.0.91/24 gateway=172.20.0.254
/interface/bridge/port add bridge=dockers interface=veth91

/container/config/set registry-url=https://registry-1.docker.io tmpdir=disk1/pull

/container/envs/add name=rustdesk_envs key=TZ value="Asia/Jerusalem"

/container/envs/add name=rustdesk_envs key=IP value="172.20.0.91"
/container/envs/add name=rustdesk_envs key=DOMAIN value="172.20.0.91"
/container/envs/add name=rustdesk_envs key=RELAY value="172.20.0.91"

/container/envs/add name=rustdesk_envs key=HTTP_ADMIN_USER value="admin"
/container/envs/add name=rustdesk_envs key=HTTP_ADMIN_PASS value="73245937-be70-4921-955d-6cba7e872b18"
/container/envs/add name=rustdesk_envs key=HTTP_PORT value="80"
/container/envs/add name=rustdesk_envs key=ENCRYPTED_ONLY value="0"

/container mounts add dst=/data name=rustdesk_data src=/disk1/rustdesk_data
/container mounts add dst=/public name=rustdesk_public_http src=/disk1/rustdesk_public_http

/container/add mounts=rustdesk_data,rustdesk_public_http dns=172.20.0.254 remote-image=elicro/rustdesk-server:latest interface=veth91 root-dir=disk1/rustdesk envlist=rustdesk_envs start-on-boot=yes

