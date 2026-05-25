{
  flake.modules.nixos.haos = {


    networking.tapInterfaces."vm-haos" = {
      user = "root";
      group = "root";
    };

   # ? networking.bridges.microbr.interfaces = [ "vm-haos" ];

    systemd.services.haos-vm = {
  description = "Home Assistant OS VM (Cloud-Hypervisor)";
  after = [ "network-online.target" ];
  wants = [ "network-online.target" ];
  wantedBy = [ "multi-user.target" ];

  serviceConfig = {
    Type = "simple";
    ExecStart = ''
      /run/current-system/sw/bin/cloud-hypervisor \
        --cpus boot=2 \
        --memory size=4096M \
        --disk path=/persist/vms/haos/haos.img \
        --net tap=vm-haos,mac=02:00:00:00:00:01 \
        --serial tty \
        --console off \
        --api-socket /run/haos-vm.sock
    '';
    ExecStop = "/run/current-system/sw/bin/ch-remote --api-socket /run/haos-vm.sock shutdown";
    Restart = "always";
  };
};
