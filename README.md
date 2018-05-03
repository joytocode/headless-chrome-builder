# joytocode/headless-chrome-builder

A script to build Headless Chrome at any release version.

## Prebuilt Stable Headless Chrome for AWS EC2 and Lambda

TODO

## Build instructions

We tested the script in AWS only. You can still make it work in GCP or Azure with some small (or none) tweaks.

We use the following setup in AWS EC2:

- AMI: Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type - ami-6b8cef13
- Instance type: `c5.4xlarge` (16 vCPUs, 32 GiB Memory) (`c5.2xlarge` still works but takes 20 minutes longer)
- Root storage: 30 GiB

The build will take about 45 minutes and cost you $0.50 (On-Demand pricing of `c5.4xlarge` at US West is $0.68 per Hour).

### Fetch the source code (20 minutes)

```
$ ./builder.sh fetch
```

### Sync the source code to a specific release tag (5 minutes)

```
$ ./builder.sh sync RELEASE_TAG
```

Replace `RELEASE_TAG` with the tag you want to build, such as `66.0.3359.117`.

If you see the error `reference is not a tree`. TODO

### Build the source code (20 minutes)

```
$ ./builder.sh build
```

You can find the output file at `~/chromium/src/out/headless/headless_shell`.

## License

[MIT](LICENSE)
