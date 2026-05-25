{
  flake.modules.nixos.haos = {


    networking.tapInterfaces."vm-haos" = {
      user = "root";
      group = "root";
    };

   # ? networking.bridges.microbr.interfaces = [ "vm-haos" ];

    systemd.services.haos-vm = {
      description = "Home Assistant OS VM (Cloud-Hypervisor)";
      after = [
        "network-online.target"
        "network-addresses-vm-haos.service"
      ];
      wants = [
        "network-online.target"
        "network-addresses-vm-haos.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 5;
        TimeoutStopSec = 30;

        RuntimeDirectory = "haos-vm";

        ExecStart = ''
          /run/current-system/sw/bin/cloud-hypervisor \
          --cpus boot=2 \
          --memory size=4096M \
          --disk path=/persist/microvms/haos/haos.img \
          --net tap=vm-haos,mac=02:00:00:00:00:01 \
          --serial tty \
          --console off \
          --api-socket /run/haos-vm/ch.sock
          --fs tag=data,dir=/persist/microvms/haos/haos-data
        '';

        ExecStop = ''
          if [ -S /run/haos-vm/ch.sock ]; then
          /run/current-system/sw/bin/ch-remote \
          --api-socket /run/haos-vm/ch.sock shutdown || true
          sleep 10
          fi
        '';

        KillMode = "process";
      };
    };
  };
}
