## Available Languages

- [English](README.md)
- [বাংলা](README.bn.md)

# Kandari OS
[![Build Kandari Images](https://github.com/tazihad/kandari/actions/workflows/build-kandari.yml/badge.svg)](https://github.com/tazihad/kandari/actions/workflows/build-kandari.yml)

Kandarai OS based on Fedora Atomic.

**NOTE**: Replace `latest` with `40` or `41` to stay with Fedora Release.

## Installation  
There's two images. `Kandari` and `Kandari NVIDIA`. Use one according to your hardware.  
#### Simple method
To rebase an existing atomic Fedora installation to the latest build:  

**Unsigned build:** ⚠️    
- First rebase to the unsigned **Kandari** image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/tazihad/kandari-kde:latest
  ```
- **Nvidia Kandari** unsigned build:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/tazihad/kandari-kde-nvidia:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```  
**Signed build:** ✔️  
- Then rebase to the signed **Kandari** image, like so:

  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/tazihad/kandari-kde:latest
  ```
- Or rebase to **Nvidia Kandari** Signed image:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/tazihad/kandari-kde-nvidia:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```
#### Advanced method  
Install **signed** image without rebasing to **unsigned** image.  
- Install the public key:
  ```
  sudo mkdir -p /etc/pki/containers
  curl -O "https://raw.githubusercontent.com/tazihad/kandari/main/kandari.pub" -o kandari.pub
  sudo cp kandari.pub /etc/pki/containers/
  sudo restorecon -RFv /etc/pki/containers
  ```
- Configure the registry to get sigstore signatures:  
  Create and edit the configuration file for your registry:
  ```
  sudo mkdir -p /etc/containers/registries.d
  sudo nano /etc/containers/registries.d/ghcr.io-tazihad-kandari.yaml
  ```
  Add the following content:
  ```
  docker:
    ghcr.io/tazihad/kandari:
      use-sigstore-attachments: true
  ```
  Save the file and then run:
  ```
  sudo restorecon -RFv /etc/containers/registries.d/ghcr.io-tazihad-kandari.yaml
  ```
- Set up the policy:
  Create a policy file and add the following content:
  ```
  sudo cp /etc/containers/policy.json /etc/containers/policy.json.bak # Backup existing policy
  sudo nano /etc/containers/policy.json
  ```
  Add the following content, replacing the placeholders with your actual paths:
  ```
  {
      "default": [
          {
              "type": "reject"
          }
      ],
      "transports": {
          "docker": {
              "ghcr.io/tazihad/kandari": [
                  {
                      "type": "sigstoreSigned",
                      "keyPath": "/etc/pki/containers/kandari.pub",
                      "signedIdentity": {
                          "type": "matchRepository"
                      }
                  }
              ],
              "": [
                  {
                      "type": "insecureAcceptAnything"
                  }
              ]
          }
      }
  }
  ```
  Save the file and then run:
  ```
  sudo restorecon -RFv /etc/containers/policy.json
  ```
  Now, your setup for verifying `kandari` container images using `cosign` with the renamed public key `kandari.pub` should be complete.


## Verification  
These images are signed with Sigstore's cosign. You can verify the signature by downloading the `kandari.pub` file from this repo and running the following command:
```
cosign verify --key https://raw.githubusercontent.com/tazihad/kandari/main/kandari.pub ghcr.io/tazihad/kandari-kde:latest
```

