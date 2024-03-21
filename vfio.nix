let
  # RTX 3070 Ti
  gpuIDs = [
    "10de:2482" # Graphics RTX 3070 Ti
    "10de:228b" # Audio 
  ];
in { pkgs, lib, config, ... }: {


    boot = {
    
  loader.systemd-boot.enable = true;
  loader.efi.canTouchEfiVariables = true;

  initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  kernelModules = ["kvm-amd" "amdgpu"]; # "vfio_pci" "vfio" "vfio_iommu_type1"  ];
  extraModulePackages = [ ];
      initrd.kernelModules = [
        "kvm-amd" 
        "amdgpu"
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        #"vfio_virqfd"

#        "nvidia"
#        "nvidia_modeset"
#        "nvidia_uvm"
#        "nvidia_drm"
      ];
#      blacklistedKernelModules = [ "nouveau" "nvidia" ];
      extraModprobeConfig = ''
        options vfio-pci ids=${lib.concatStringsSep " " gpuIDs}
        '';
#    virtualisation.spiceUSBRedirection.enable = true;
  };
}

