# Docker contaienr for optimization with pyomo

This is repository of docker container for optimization with pyomo and some of MINLP solvers.

## Solvers

* Bonmin
* CBC
* Couenne
* GLPK
* IpOpt
* SCIP

## How to use

### Requirement

* Source code of SCIP
* Docker

### Check license status

Although this repository is distributed under BSD-3-Clause lisence, some of solvers have restriction to use.

* The solvers distributed on Coin-OR were under [Eclipse Public Lisence](https://opensource.org/licenses/eclipse-1.0). You can use them by free.
* As SCIP is distributed under [ZIP Academic lisence](https://scip.zib.de/academic.txt), you cannot use it by free if it is commercial usage. Then, please consult to [official support](https://scip.zib.de/index.php#license).

### Prepare third party software

This container requires source code of SCIP solver. Please [download it](https://scip.zib.de) and place into the repository.
When you want to put out SCIP, please comment out the related procedure in Dockerfile.

### Setting library version

The default version of solvers are

* BOMIN: 1.8.7
* COUENE: 0.5.7
* IPOPT: 3.12.12
* SCIP: 6.0.1
* CBC and GLPK: Latest version by apt-get

When you use different version, you have to tell them to docker. Mainly, there are three solutions.

1. Modify `docker-compose.yml`
2. Pass environment variable when you run
3. Place `.env` file i nthe directory.

See [official document of docker](https://docs.docker.com/compose/environment-variables/).

### Running container

```
docker-compose up -d
```

And you can access jupyter lab in [your browser](http://localhost:8888)!
