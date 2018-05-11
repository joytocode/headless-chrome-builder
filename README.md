# joytocode/headless-chrome-builder

A script to build Headless Chrome at any release version.

## Prebuilt stable Headless Chrome for AWS EC2 and Lambda

| Version | Release Date |
| ------- | ------------ |
| [66.0.3359.170](https://s3-us-west-2.amazonaws.com/joytocode-public/headless-chrome/66.0.3359.170.zip) | May 10, 2018 |
| [66.0.3359.139](https://s3-us-west-2.amazonaws.com/joytocode-public/headless-chrome/66.0.3359.139.zip) | April 26, 2018 |
| [66.0.3359.117](https://s3-us-west-2.amazonaws.com/joytocode-public/headless-chrome/66.0.3359.117.zip) | April 17, 2018 |

We track stable desktop releases by this blog [https://chromereleases.googleblog.com/search/label/Stable%20updates](https://chromereleases.googleblog.com/search/label/Stable%20updates).

## Build instructions

We tested the script on AWS only. You can still make it work on GCP or Azure with some small changes (or none).

We use the following setup:

- AMI: Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type - ami-6b8cef13
- Instance type: `c5.4xlarge` (16 vCPUs, 32 GiB Memory) (`c5.2xlarge` still works but takes 20 minutes longer)
- Root storage: 30 GiB

The build will take about 45 minutes and cost $0.50 (On-Demand pricing of `c5.4xlarge` at US West is $0.68 per hour).

When the EC2 instance is ready, SSH to it and run commands in next sections.

> If you want to run a long command in background, do it by **`nohup bash -c './builder.sh fetch' &`** or **`nohup bash -c './builder.sh build' &`**. Then, you can terminate and reconnect SSH anytime and also watch the log by **`tail -f -n 50 ./nohup.out`**.

### 1. Download the builder script

```bash
$ cd ~

$ wget https://rawgit.com/joytocode/headless-chrome-builder/master/builder.sh

$ chmod +x ./builder.sh
```

### 2. Fetch the source code (20 minutes)

```bash
$ ./builder.sh fetch
```

### 3. Sync the source code to a specific release tag

```bash
$ ./builder.sh sync RELEASE_TAG
```

Replace `RELEASE_TAG` with the tag you want to build, such as `66.0.3359.117`.

If you see error like:

> src/third_party/webrtc (ERROR)

> Error: Command 'git checkout --quiet b20aef0d47bf3924adfc7bfbee707f6f137670fb' returned non-zero exit status 128 in /home/ec2-user/chromium/src/third_party/webrtc

> fatal: reference is not a tree: b20aef0d47bf3924adfc7bfbee707f6f137670fb

Go to the submodule and fetch the required commit (https://groups.google.com/a/chromium.org/forum/#!msg/chromium-dev/h7nWEEE4ank/U7OyeqGBAQAJ):

```bash
$ cd ~/chromium/src/third_party/webrtc

$ git fetch origin b20aef0d47bf3924adfc7bfbee707f6f137670fb

$ cd ~
```

Remember to replace the commit id with the one in the error message. Repeat running sync and fixing errors until you see no error.

### 4. Build the source code (20 minutes)

```bash
$ ./builder.sh build
```

When it finishes, you can find the output file at `~/chromium/src/out/headless/headless_shell`.

## Credits

- [sambaiz/puppeteer-lambda-starter-kit](https://github.com/sambaiz/puppeteer-lambda-starter-kit): we inspire mostly from this project and also add tag handling
- [adieuadieu/serverless-chrome](https://github.com/adieuadieu/serverless-chrome): the first attempt to build Headless Chrome for Lambda
- Chromium documentation: [linux_build_instructions](https://chromium.googlesource.com/chromium/src/+/master/docs/linux_build_instructions.md) and [working-with-release-branches](https://www.chromium.org/developers/how-tos/get-the-code/working-with-release-branches)

## License

[MIT](LICENSE)
