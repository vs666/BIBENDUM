<!-- [![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url] -->



<br />
<p align="center">
  <a href="https://github.com/vs666/Sentinel">
    <img src="./icon.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">BIBENDUM</h3>

  <p align="center">
    Trustless Decentralized lottery system on Ethereum.
    <br />
    <br />
    <br />
    <!-- <a href="https://github.com/vs666/Sentinel">View Demo</a> -->
    ·
    <a href="https://github.com/vs666/BIBENDUM/issues">Report Bug</a>
    ·
    <a href="https://github.com/vs666/BIBENDUM/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
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
    <li><a href="#challenges">Challenges</a></li>
    <li><a href="#preview">Application Preview</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#future-work">Future Work</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

BIBENDUM is a trustless decentralized lottery system, that can be used to nominate and draw lotteries. 

The amazing feature of the project is its random lottery draw feature, which is completely trustless and decentralized.

### The problem it solves 

* `Why :` A decentralized lottery system that is trustless, is a necessity. This is because lottery should be a zero sum game, but the fact that the organizers profit from it, shows that it is not the case.         
In the pre-blockchain age, we had to suffer this tradeoff of fairness, because there was a need of trust in the organizers. But now, a trustless escrow contract can do what the organizers of lottery do, for free. Thus we need to upgrade to a `decentralized trustless lottery system`.

* `How : ` We make use of escrow contracts, a virtual entity that holds all the money on wage for a particular round of the lottery. The first version requires a moderator, however, it is still a zero sum game, because the moderator has no more stake or chance of winning than any other participant.



### Built With

* [Solidity](https://docs.soliditylang.org/en/v0.5.3/solidity-by-example.html)
* [Truffle](https://www.trufflesuite.com/truffle)
* [Ganache](https://www.trufflesuite.com/ganache)
* [Vanilla Js](http://vanilla-js.com/)
* [CSS](https://developer.mozilla.org/en-US/docs/Web/CSS)
* [Html](https://developer.mozilla.org/en-US/docs/Web/HTML)
* :heart:


## Getting Started

```shell
npm install 
npm install truffle -g
```
* Download [GANACHE](https://github.com/trufflesuite/ganache/releases/download/v2.5.4/ganache-2.5.4-linux-x86_64.AppImage)


### Prerequisites

This is an example of how to list things you need to use the software and how to install them.
* npm
  ```sh
  npm install npm@latest -g
  ```

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/vs666/BIBENDUM.git
   ```


## Usage

First we need to run the ganachse server.
```
./ganache-2.5.4-linux-x86_64.AppImage
```

The solidity script deployment : 
```
truffle compile
truffle migrate --reset
```
Now, we need to deploy the frontend ( we use [lite-server](https://www.npmjs.com/package/lite-server))

```shell
npm run dev
```

## Preview

The application is a simple web interface that allows you to draw lotteries. The following screenshots from the application explain the usage and shows the interface.

1. ![Homepage](./homepage.png)    
This is the homepage of the application that is meant for the explaining of the interface. The left console displays the `account details`, the right console displays the `current round of lottery` and `actions that can be taken`. Further, the middle panel is for information regarding the accounts of the participants of the current round of lottery.

2. ![Buy Ticket](./buying.png)      
This image shows the process of buying a ticket using the `meta-mask` extension.

Now, after multiple people have bought stakes, we have the account details as follows :     

3. ![Account Details](./pre-roll.png)

The screen looks like this : 

4. ![Screen view](./screen-mid.png)

Now, the lottery round is closed by the initiator of the lottery, and roll is done by any one of the members.
After the draw, the screen goes back to the image similar to (1), and the account details looks as follows: 

5. ![Account Details](./post-rolling.png)

## Future Work 

In future we aim to release subsequent versions with the following changes : 

v1.0 The first version is simple, one contract with a need for a controlling authority to decide status of rounds (started, ended, etc).

v1.1 In this, we plan to resolve potential issue of asynchrony in the system. If the controlling authority has closed a round and message delay allows some person to participate in the round, this should bot be allowed.

v2.0 In this version, we plan to make modifications to the architecture to disallow a controlling authority to close rounds. This will solve asynchrony problems.

v2.1 In this version, after true decentralized system, we plan to allow any user to roll out the round.


## Roadmap

See the [open issues](https://github.com/vs666/BIBENDUM/issues) for a list of proposed features (and known issues).

# Challenges

1. `Kicking off Blockchain Journey :` This was the first time we coded in Solidity, so the biggest challenge was to get a working understanding of the Blockchain (esp. Ethereum). We had to learn how to use the Ethereum client, how to create a contract, how to deploy a contract, how to interact with the blockchain and how to use the web3 js.

2. `Deciding a winner :` The major challenge was that the winner needed to be **out of the state**, which was challenging. So we devised a clever method. If a person wished to meddle with the winner selection method so that he himself becomes the winner, he would have to increase his stake in the lottery. The proper way to attack would be to find a desired hash value (calculated in the contract) that makes the particular person the winner. So, for this he would have to increase his stake. For n people already in the contract, his chance of being winner will be 1/n. So he would have to keep adding stake (on average around n times), so he is the expected winner. This is after the assumption that other people have stopped betting, and the organizer has not closed the round yet.       
Thus, we notice this attack has been **heavily disincentivised**, and though possible with a low probability, the expected return is very highly negative.

3. `Asynchronous Nature : ` This is currently an open problem and the primary reason we have a host for the lottery. While the host himself will have equal expectation of reward, a rational adversary being a host might cause freezing of stakes, and a few related attacks. We have minimized the problem by designing the protocol such that any potentially destructive action will require a high stake.



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- LICENSE -->
## License

Distributed under a License with specific instructions for commercial use or distribution. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Varul Srivastava    
[@VarulSrivastava](https://twitter.com/VarulSrivastava)   



Project Link: [BIBENDUM](https://github.com/vs666/BIBENDUM)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/vs666/BIBENDUM.svg?style=for-the-badge
[contributors-url]: https://github.com/vs666/BIBENDUM/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/vs666/BIBENDUM.svg?style=for-the-badge
[forks-url]: https://github.com/vs666/BIBENDUM/network/members
[stars-shield]: https://img.shields.io/github/stars/vs666/repo.svg?style=for-the-badge
[stars-url]: https://github.com/vs666/repo/stargazers
[issues-shield]: https://img.shields.io/github/issues/vs666/repo.svg?style=for-the-badge
[issues-url]: https://github.com/vs666/BIBENDUM/issues
[license-shield]: https://img.shields.io/github/license/vs666/Sentinel.svg?style=for-the-badge
[license-url]: https://github.com/vs666/BIBENDUM/blob/main/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/varul-srivastava-497547198/