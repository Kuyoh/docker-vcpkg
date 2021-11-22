<div id="top"></div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

This repository contains a set of base docker images, intended to be used for developing and building C++ projects for linux using an up-to-date version of vcpkg.

It is mainly targeted at development using Visual Studio Code, but it should work as a basis for any docker image (e.g. for CI builds).

<p align="right">(<a href="#top">back to top</a>)</p>


### Built With

* [Docker](https://www.docker.com) - docker itself is sufficient to build the project
* [VCPKG](https://vcpkg.io/en/index.html) - installed from source as part of the docker build
* [CMake](https://cmake.org) - installed as part of the docker build
* [Ninja](https://ninja-build.org) - installed as part of the docker build
* [GCC](https://gcc.gnu.org) - installed as part of the docker build
* [Visual Studio Code](https://code.visualstudio.com) - IDE for testing the dockerfiles  
  Note: the [C/C++ extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) for VSCode currently does not support alpine-linux/musl (see [Issue #4827](https://github.com/microsoft/vscode-cpptools/issues/4827)).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

Only [Docker](https://www.docker.com) is a prerequisite, although I recommend [Visual Studio Code](https://code.visualstudio.com) for development and testing.

### Building

1. Clone the repo
   ```sh
   git clone https://github.com/Kuyoh/docker-vcpkg.git
   ```
2. Build image of your choice:
     - Alpine Linux
       ```sh
       docker build -f Dockerfile.alpine --build-args BASE_IMAGE=alpine:3.14 -t vcpkg:2021.05.12-alpine3.14 .
       ```
     - Debian Linux
       ```sh
       docker build -f Dockerfile.debian --build-args BASE_IMAGE=debian:11 -t vcpkg:2021.05.12-debian11 .
       ```
     - Ubuntu Linux
       ```sh
       docker build -f Dockerfile.debian --build-args BASE_IMAGE=ubuntu:20.04 -t vcpkg:2021.05.12-ubuntu20.04  -
       ```
      The specified base images were tested, but other (especially newer) versions of the respective base images should work, too.


### Updating vcpkg

The version of vcpkg used when building the image can be updated by specifying the build arguments `VCPKG_VERSION_TAG` and `VCPKG_SHA256`.
Note that the default URI for downloading vcpkg is https://github.com/microsoft/vcpkg/archive/refs/tags/${VCPKG_VERSION_TAG}.tar.gz (although that can be overridden with the build argument `VCPKG_URI`), and the SHA hash needs to be specified for the corresponding file, otherwise the build will fail.


<p align="right">(<a href="#top">back to top</a>)</p>


<!-- USAGE EXAMPLES -->
## Usage

The basic use of the image should be relatively straight-forward. It can be used directly to build source code, as a development container for VSCode, or as a base image for a custom docker build.

In all images, vcpkg is installed in `/opt/vcpkg`, and added to `PATH`. There is also an environment variable `VCPKG_ROOT` pointing to the same directory.

### Use as base docker image

The following example is based on vcpkg [manifest mode](https://vcpkg.io/en/docs/users/manifests.html). See the testproject folder in this repository for an example of a setup using this mode.
```docker
FROM kuyoh/vcpkg:2021.05.12 AS base

WORKDIR /workspace

# copy source files
COPY . .

# generate and build
RUN cmake -DCMAKE_TOOLCHAIN_FILE:STRING=${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake \
    -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=Release \
    -H/workspace -B/workspace/build -G Ninja
RUN cmake --build /workspace/build --config Release --target all -j 6 --
```


### Use as Development Container in Visual Studio Code

First, make sure to have the [Remote - Container](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension installed in you Visual Studio Code instance.

Create a devcontainer configuration in your project (typically `.devcontainer/devcontainer.json`).
```json
{
	"name": "VCPKG Docker",
	"image": "kuyoh/vcpkg:2021.05.12",
	"extensions": [ // these are optional, but i'd recommend them
		"ms-vscode.cmake-tools",
		"fredericbonnet.cmake-test-adapter",
		"twxs.cmake",
		"ms-vscode.cpptools-extension-pack",
		"eamodio.gitlens"
	]
}
```

It is also possible to configure the devcontainer to build a custom Dockerfile that uses vcpkg as a base image.
See [VSCode's devcontainer.json reference](https://code.visualstudio.com/docs/remote/devcontainerjson-reference) for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Create Ubuntu base image
- [x] Add Alpine/musl flavor
- [ ] Set up CI/CD
- [ ] Add clang-based flavors
- [ ] Add libc++ flavors

See the [open issues](https://github.com/Kuyoh/docker-vcpkg/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>


