# bootc-hackery

This repository demonstrates the building of a bootc image using GitHub actions.

It: 

- Starts with Fedora's bootc image
- adds in some build metadata from the GitHub Actions pipeline
- Adds a script `build-meta` to print it out.
- Should work in a fork, publishing packages to your own GHCR space.

Use https://github.com/osbuild/bootc-image-builder to build an image as a
starting point for your virtual machine. Modify the included config.toml the
generation of your image to your liking. 

## Example **bootc-image-builder** execution

Build out your config.toml as you like. The included one adds a demo user. Then,
From the base of this repository:

```
GITHUB_NS=komish
sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/config.toml:/config.toml:ro \
    -v $(pwd)/output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type qcow2 \
    --local \
    --rootfs xfs \
    ghcr.io/${GITHUB_NS}/bootc-hackery:1731103809
```

Refer to documentation https://github.com/osbuild/bootc-image-builder as this
project changes for updated commands. Swap our your own GitHub namespace as
needed.

Laucnh the VM using the same documentation

## Validating and Observing updates

Access the VM and look at the build-meta that we added in:

```
# build-meta
BUILD_DATE=Fri Nov  8 22:10:44 UTC 2024
BUILD_URL=https://github.com/komish/bootc-hackery/actions/runs/11750277815
BUILD_TRIGGER=push
BUILD_REF=refs/heads/main
BUILD_SOURCE_COMMIT=93970623372a0ccd90894e36ca89c13606ff308a
```

Check out the currently booted image

```
# bootc status
No staged image present
Current booted image: ghcr.io/komish/bootc-hackery:1731103809
    Image version: 41.20241107.0 (2024-11-08 22:10:44.631431147 UTC)
    Image digest: sha256:3952d8e85abcaa5995d6b7e460d080939828b4490e779c80e533e35032df3e75
No rollback image present
```

Each image gets its own tag, so we can explicitly switch to a new image

```
# bootc switch ghcr.io/komish/bootc-hackery:1731105338
[root@fedora ~]# bootc switch ghcr.io/komish/bootc-hackery:1731105338
layers already present: 65; layers needed: 1 (10.7 MB)
Fetched layers: 10.20 MiB in 10 seconds (1013.92 KiB/s)
Queued for next boot: ghcr.io/komish/bootc-hackery:1731105338
  Version: 41.20241107.0
  Digest: sha256:935aeb26271ba091673473bfebbea9862c85ae90b151c8b6f98510bc631995a3
```

Run `reboot` now to observe the change.

```
# reboot
# bootc status
[root@fedora ~]# bootc status
No staged image present
Current booted image: ghcr.io/komish/bootc-hackery:1731105338
    Image version: 41.20241107.0 (2024-11-08 22:36:18.339835487 UTC)
    Image digest: sha256:935aeb26271ba091673473bfebbea9862c85ae90b151c8b6f98510bc631995a3
Current rollback image: ghcr.io/komish/bootc-hackery:1731103809
    Image version: 41.20241107.0 (2024-11-08 22:10:44.631431147 UTC)
    Image digest: sha256:3952d8e85abcaa5995d6b7e460d080939828b4490e779c80e533e35032df3e75
```

Switch to `latest` which may allow for automated updates

```
# bootc switch ghcr.io/komish/bootc-hackery:latest
layers already present: 65; layers needed: 1 (10.7 MB)
Fetched layers: 10.20 MiB in 11 seconds (941.95 KiB/s)
Queued for next boot: ghcr.io/komish/bootc-hackery:latest
  Version: 41.20241107.0
  Digest: sha256:cf06b71f549d39f3953218591275eec470e463d5d53c753d550bfc0255644f45
```