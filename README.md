[![Build Kandari Images](https://github.com/kandari-os/kandari/actions/workflows/build-kandari.yml/badge.svg)](https://github.com/kandari-os/kandari/actions/workflows/build-kandari.yml)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kandari)](https://artifacthub.io/packages/search?repo=kandari)

<div align="center">
  <img src="https://raw.githubusercontent.com/kandari-os/kandari/refs/heads/main/assets/logo.png" 
       alt="Kandari OS Logo" width="100">
</div>


## Available Languages

- [English](README.md)
- [বাংলা](README.bn.md)

# Kandari OS

Kandarai OS based on Fedora Atomic.

**NOTE**: Replace `latest` with `41` or `42` to stay with Fedora Release.

## Installation  
There's two images. `Kandari` and `Kandari NVIDIA`. Use one according to your hardware.  

#### Easiest method. 
Switch using `bootc`. (Supported from Fedora 42):

```
sudo bootc switch ghcr.io/kandari-os/kde-nvidia:41
```
Reboot. Than switch to signed build
```
sudo bootc switch --enforce-container-sigpolicy ghcr.io/kandari-os/kde-nvidia:41
```


#### Advanced method  
Install **signed** image without rebasing to **unsigned** image.  
- Install the public key:
  ```
  sudo mkdir -p /etc/pki/containers
  curl -O "https://raw.githubusercontent.com/kandari-os/kandari/main/kandari.pub" -o kandari.pub
  sudo cp kandari.pub /etc/pki/containers/
  sudo restorecon -RFv /etc/pki/containers
  ```
- Configure the registry to get sigstore signatures:  
  Create and edit the configuration file for your registry:
  ```
  sudo mkdir -p /etc/containers/registries.d
  sudo nano /etc/containers/registries.d/ghcr.io-kandari.yaml
  ```
  Add the following content:
  ```
  docker:
    ghcr.io/kandari-os/kandari:
      use-sigstore-attachments: true
  ```
  Save the file and then run:
  ```
  sudo restorecon -RFv /etc/containers/registries.d/ghcr.io-kandari.yaml
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
              "ghcr.io/kandari-os/kandari": [
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
cosign verify --key https://raw.githubusercontent.com/kandari-os/kandari/main/kandari.pub ghcr.io/kandari-os/kandari-kde:latest
```

