# The Consumer Contract Wallet version 3

This repository contains the Smart Contracts needed to power the Monolith Card, written in Solidity, for execution in the EVM.

The Monolith Card is the world's first non-custodial position to VISA debit card. The Consumer Contract Wallet allows people to hold their own assets, whilst being able to seamlessly move funds to a VISA debit card. 1% of all loads to the Monolith Cards are sent, by the user themselves, to the TKN Holder contract. This is used to back the Community Chest (aka the Asset Contract). The purpose of this onchain infrastructure is provide the most seemless user experience whilst maintaining a decentralised position.

| [High Level Architecture](https://github.com/tokencard/contracts/blob/master/README.md/#high-level-architecture) | [Security Features](https://github.com/tokencard/contracts/blob/master/README.md/#security-features) | [Solidity Code](https://github.com/tokencard/contracts/blob/master/README.md/#solidity-code-in-the-contracts-folder) | [Running Contract Tests](https://github.com/tokencard/contracts/blob/master/README.md/#running-contract-tests) | [Resources](https://github.com/tokencard/contracts/blob/master/README.md/#resources) |
|---|---|---|---|---|

## Overview

The functionality encoded in the Smart Contracts found in this repository have been designed to help users protect their tokens, by holding them within their own instance of a *Consumer Contract Wallet* which they can configure to their liking. The functionality within the *Consumer Contract Wallet* has been designed to limit a user's exposure to loss of tokens in the event that a user has had their Private Key compromised.

We believe there are three major problems facing the adoption and use of decentralised finances:
 - The issue that users with compromised private keys could end up losing all of their assets.
 - The issue that people are generally not good at keeping digital secrets safe, the potential loss of private keys.
 - The UX of decentralised finances and real-world payments.

This, third version, of the *Consumer Contract Wallet* protects users by limiting their exposure to theft in the event that their private key gets compromised. This version also brings batched meta-transactions to the experience. Batched meta-transactions are flexible to the point where gas can be removed from equation or can be approximately paid for in any ERC20 token. By batching up meta-transactions we will be able to build a more compelling user experience, by utilising the composability of Smart Contract calls on Ethereum.

Each user deploys their own instance of the *Consumer Contract Wallet* ([wallet.sol](/contracts/wallet.sol)) to the Ethereum Network which interacts with the *TokenWhitelist* ([tokenWhitelist.sol](/contracts/tokenWhitelist.sol])) to get exchange rates between tokens to enforce a user-definted daily spend limit. The exchange rates in the *TokenWhitelist* contract are periodically updated using an exchange rate *Oracle* ([oracle.sol](/contracts/oracle.sol)). 

The individual *Consumer Contract Wallet* contracts use the [Ethereum Name Service (ENS)](https://ens.domains/) to resolve the location of the *TokenWhitelist* contract, as well as to resolve the location of the *Controller* ([controller.sol](contracts/controller.sol)) contract. The *TokenWhitelist* is a whitelist of tokens and their exchange rates that are used to secure a user's tokens within their wallet, it also determines which tokens can be used to load the TokenCard and which are "cash 'n' burnable" by the TKN ERC-20 Contract in conjunction with the *TKN Holder* Contract. This *Controller* contract is used for administrative purposes only, rest assured this has no access to user's funds. The controllers are used to perform 2FA functionality as well as administrative tasks on the *Oracle* and on the *TokenWhitelist*.


### High-level Architecture

![High Level Architecture](docs/high_level_architecture.svg)

### Assumptions
- Every user will have their own Public and Private key pair, aka the `Owner Address`.
- Users SHOULD NEVER have to share the Private Key of their `Owner Address` with anyone.
- There are a number of different "pots of tokens" for a given user:
     - The user’s entire ETH and ERC20 token assets stored within the *Consumer Contract Wallet*.
     - An amount of ETH used to pay for the gas - *Gas Tank*. The *Gas Tank* is a representation of the ETH on the user's `Owner Address`. It should be noted that this ETH is NOT protected by the security features in the *Consumer Contract Wallet* as it resides outside of the Smart Contract. Note: in the current version (v3) meta-transactions are also supported i.e. the users can send trasnactions without having to top-up their *Gas Tank*. The way it works is the following: they sign the transsaction with their private key, a controller broadcasts it, the signature is validated by their contract and the original transaction is executed consecutively. The *Gas Tank* has been kept mainly for convenience and is gonna be removed entirely in the upcoming version.

### Requirements
- This `Owner Address` will own all of the user’s Smart Contracts and will be referred to as the *Owner*, this is sometimes referred to as an *Externally Owned Address (EOA)*
- The *Controller* - Is a key hierarchy of administrative addresses, owned and operated by Token Group Ltd. These are used to provide convenience to our users.
- The *Consumer Contract Wallet* needs to allow its *Owner* to configure how they wish to secure their tokens in their wallet.
- There needs to be a convenient way to "top-up" the amount of ETH that lives on our user’s `Owner Address` aka *Gas Tank* via the Smart Contracts
- The wallet's design is intended to be as decentralised as possible. This will be achieved by eliminating access to user assets by third-parties and minimising reliance of third-party infrastructure in running the *Consumer Contract Wallet*.
- Must help user protect their funds by minimising the risk in the event of their `Owner Address`'s private key being compromised.
- Provide the best UX possible.

### Security Features

In order to help users protect their tokens in the event that their Private Key gets compromised, we present the following security features:

- *A Whitelist of Addresses* - akin to a whitelist of payees in a banking application, this whitelist should be configured with a list of trusted addresses for each *Owner* of the *Consumer Contract Wallet*.
- *Daily Spending Limit* - denominated in ETH. This is used to define how much can a user transfer in a given day if transferring assets to addresses outside their *Whitelist*.
- *Daily Gas Tank Top-up Limit* - (*Gas Tank*) top-up daily limit denominated in ETH. This is used to define the daily limit of ETH that can be sent from a user's *Consumer Contract Wallet* to their `Address`; this ETH is what is used to pay the network for gas.
- *Daily Card Load Limit* - (*Card Load Limit*) card loading daily limit denominated in USD (technically speaking in a stablecoin like USDC). This is used to define the daily limit of tokens or ETH that can be sent from a user's *Consumer Contract Wallet* for loading of the user's TokenCard. This is currently set to 10K USD.

### Configuration

There are three ways to configure a Consumer Contract Wallet:

- via Constructor: Upon deployment of a new *Consumer Contract Wallet* the above security features are configured: a) by passing the desired value for the *Daily Spending Limit* to the constructor b2) by setting default values for the *Daily Gas Tank Top-up Limit* and *Daily Card Load Limit*, when deploying the *Consumer Contract Wallet* smart contract the to the Ethereum network. This is how the values are set when deploying a new instance of the *Consumer Contract Wallet*.
- via a 1-time write pattern: Aside from default values and values passed in via the Constructor the user may do a 1-time write to the aforementioned `Security Features`. These allow the `Address` to change the values that power the security features. It is advised that users of the *Consumer Contract Wallet* set their security settings so that they can not longer be tampered with in the event that a user's private key is compromised. Users should set these values once, otherwise an attacker would be able to configure their Smart Contract.
- via a 2FA pattern: Where a user can *submitChange* a new value for one of the Security Features, then one of the `Controller` addresses needs to either OK the value change or not. It should be noted that due to the nature of the user *AddressWhitelist* where a user may add or remove items from their whitelist via the 2FA pattern, only one pending change to the user's address whitelist can be in flight at a given point in time.

## Naming convention

This section details the naming convention adopted in this codebase:

 - *Contracts* - should be Nouns
 - *Functions* - should be Verbs
 - *Ables* - Smart Contracts that are meant to be inherited and not standalone, i.e. they are Mixins, Snippets, Decorators ...
 - *Private contract scoped variables* - all start with an underscore `_`
 - *Private / internal functions* - all start with an underscore `_`
 - *Constructor parameters* - all start with an underscore `_` and end in one too, e.g. `_ens_` this is to avoid shadowing
 - *Function parameters* - all start with an underscore `_`
 - *Local variables* - to functions should start without an underscore
 - *Public contract scoped variables* - should start without an underscore
 - *Public functions* - should start without an underscore
 - *Crud functions* - when there exist multiple actions on the same variable we will use the suffix to illustrate the action, for example : `dailySpendLimitSet`, and `dailySpendLimitUpdate`


### Solidity code in the `/contracts/` folder

It should be noted that this codebase makes heavy use of inheritance.

[wallet.sol](/contracts/wallet.sol) is the primary *Consumer Contract Wallet* contract that helps user's secure their funds. The Wallet communicates with the *TokenWhitelist*, the *Controller*, the *TKN licence*, and other ERC20 contracts. It should noted that the *Consumer Contract Wallet* only protects the ERC20 tokens supported by the *TokenWhitelist* in its Security Features, tokens not listed as `available` by the *TokenWhitelist* will not be secured by the *Consumer Contract Wallet*'s daily spend limit; see([wallet inheritance digram](/docs/wallet.inheritance.png)).

[controller.sol](/contracts/controller.sol) the *Controller* is used to perform tasks on behalf of Token Group Ltd. These tasks range from operational tasks, such as updating the token exchange rates via the *Oracle*, adding/removing tokens from the *TokenWhitelist* to signing 2FA functions on behalf of our users. The *Controller* contract implements a key hierarchy of: `controllers` used for operational tasks, `admin` used for administrative tasks, and the `owner` which is used to change out the `admins`; see([controller inheritance diagram](/docs/controllers.inheritance.png)).

[holder.sol](/contracts/holder.sol) is the *TKN Holder* contract, this is the `Asset Contract` as defined in the TokenCard whitepaper. This contract is used to hold 1% of all loads made onto TokenCards. The *TokenWhitelist* is used to define the set of tokens that are cash 'n' burnable (aka redeemable) by TKN holders who wish to burn their TKN. Users may burn their TKN on the TKN ERC20 contract which will call out to the `burn` method on the *TKN Holder* contract; see([holder inheritance diagram](/docs/holder.inheritance.png)).

[licence.sol](/contracts/licence.sol) is the *TKN Licence* contract, and it is used to take a 1% fee of all loads of the user's TokenCard so that it can be sent to the *TKN Holder* contract. This contract is aware of the CryptoFloat where the remaining tokens are to be kept for Token Group Ltd for the loading of the TokenCards. It is also aware of the address of the *TKN Holder* contract that is used to back TKN. The *TKN Licence* contract has been created in a way to allow for a DAO to change some of its configured features, this is there to future proof the implementation; see ([licence inheritance diagram](/docs/licence.inheritance.png)).

[oracle.sol](/contracts/oracle.sol) is an exchange rate *Oracle* contract that gets exchange rates for a set of supported ERC20 tokens. Exchange rates are updated periodically by using the signed Crypto Compare API through the [Provable](https://provable.xyz/) oracle service. The list of tokens is managed by the *TokenWhitelist*, the *Oracle* merely updates exchange rates; see ([oracle inheritance diagram](/docs/oracle.inheritance.png)).

[tokenWhitelist.sol](/contracts/tokenWhitelist.sol) The list of tokens used in this system is managed in the *TokenWhitelist*. The *Controller* can be used to add and remove tokens from the *TokenWhitelist*, they also have the ability to set flags on the specific tokens, e.g. `loadable` (means that a token is loadable on the TokenCard) or `redeemable` (means that a token is redeemable in the *TKN Holder* contract); see ([tokenWhitelist inheritance diagram](/docs/tokenWhitelist.inheritance.png)).

[walletCache.sol](/contracts/walletCache.sol) The *WalletCache* is a factory contract that is used to pre-deploy and cache *Consumer Contract Wallets* when network prices are low; see ([walletCache inheritance diagram](/docs/walletCache.inheritance.png)).

[walletDeployer.sol](/contracts/walletDeployer.sol) The *WalletDeployer* contract accesses the *WalletCache* via ENS and allows the pre-cached wallets to be assigned new owners in a single contract call in order to satisfy requests for new  *Consumer Contract Wallets*. This contract also has the ability to configure a contract with set security features, this will be used to migrate users between contracts; see ([walletDeployer inheritance diagram](/docs/walletDeployer.inheritance.png)).

### Solidity code in the `/contracts/internals/` folder
[balanceable.sol](/contracts/internals/balanceable.sol) is an inheritable contract that checks the ETH or ERC20 balance of an address.

[burner.sol](/contracts/internals/burner.sol) defines the Burner interface used for burning TKN for the cash n' burn functionality. 

[bytesUtils.sol](/contracts/internals/bytesUtils.sol) includes a set of utils for parsing bytes to things like ints and addresses.

[controllable.sol](/contracts/internals/controllable.sol) is an inheritable contract that integrates with the list of controllers and provides control functionality to the child contract.

[date.sol](/contracts/internals/date.sol) is a simple date parsing contract with a single method, used to parse out a comparable number from the date in an HTTP header.

[ensResolvable.sol](/contracts/internals/ensResolvable.sol) implements a inheritable contract that allows contracts to looked up others via ENS.

[ownable.sol](/contracts/internals/ownable.sol) is an inheritable contract that provides owner authentication functionality to the owned contract.

[parseIntScientific.sol](/contracts/internals/parseIntScientific.sol) provides floating point in scientific notation (e.g. e-5) parsing functionality. This has been built to support floating point scientific notation returned in JSON.

[tokenWhitelistable.sol](/contracts/internals/tokenWhitelistable.sol) is an inheritable contract that interfaces with the tokenWhitelist.

[transferrable.sol](/contracts/internals/transferrable.sol) is an inheritable contract that allows for tokens or ETH to be transferred.

### Solidity code in the `/contracts/mocks/` folder

[base64Exporter.sol](/contracts/mocks/base64Exporter.sol) is a mocked out version of a contract that pulls in the base64 encoder for unit testing purposes.

[burnerToken.sol](/contracts/mocks/burnerToken.sol) is version of the TKN contract used for testing the Cash n' Burn functionality.

[bytesUtilsExporter.sol](/contracts/mocks/bytesUtilsExporter.sol) used to export methods on the bytesUtils contract for testing purposes.

[nonCompliantToken.sol](/contracts/mocks/nonCompliantToken.sol) a version of a non-compliant ERC20 token, used to test the SafeERC20 stuff. 

[oraclize.sol](/contracts/mocks/oraclize-connector.sol) is a mocked out version of the oraclize, this is for testing purposes only.

[parseIntScientific-exporter.sol](/contracts/mocks/parseIntScientific-exporter.sol) is a mocked out version of a contract that pulls in the parseIntScientific contract used to parse floating points that include scientific notation out of JSON.

[token.sol](/contracts/mocks/token.sol) is a partial compliant implementation of the ERC20 token standard used for testing and development purposes.

[tokenWhitelistableExporter.sol](/contracts/mocks/tokenWhitelistableExporter.sol) exports the tokenWhitelist for testing purposes.

### Solidity code in the `/contracts/externals/` folder

All of the third-party code we rely on can be found in this folder. The below table details the third-party code used and their licenses.


| File            | License       |
| --------------- | ------------- |
| [Address.sol](https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/2f9ae975c8bdc5c7f7fa26204896f6c717f07164/contracts/utils/Address.sol)    | [MIT](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE) |
| [SafeMath.sol](https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/2f9ae975c8bdc5c7f7fa26204896f6c717f07164/contracts/math/SafeMath.sol)    | [MIT](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE) |
| [SafeERC20.sol](https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/2f9ae975c8bdc5c7f7fa26204896f6c717f07164/contracts/token/ERC20/SafeERC20.sol)    | [MIT](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE) |
| base64.sol      | [GPLv3](https://github.com/vcealicu/melonport-price-feed/blob/master/LICENSE) |
| [ENS Pubic Resolver](https://raw.githubusercontent.com/ensdomains/resolvers/797c8b63617d1bfe4d046274b58c05e991fbae76/contracts/PublicResolver.sol)             | [BSD2](https://github.com/ensdomains/ens/blob/master/LICENSE) |
| [ENS Registry](https://raw.githubusercontent.com/ensdomains/ens/aa30b7eae4efdb2089893b7a461c76dbbc011783/contracts/ENSRegistry.sol)            | [BSD2](https://github.com/ensdomains/ens/blob/master/LICENSE) |
| [strings.sol](https://github.com/Arachnid/solidity-stringutils/pull/37)     | [Apache v2](https://github.com/Arachnid/solidity-stringutils/blob/master/LICENSE) |
| [oraclizeAPI](https://raw.githubusercontent.com/provable-things/ethereum-api/d02497b4d84e02a8649af3822950873d305f7659/oraclizeAPI_0.5.sol)     | [MIT](https://github.com/oraclize/ethereum-api/blob/master/LICENSE) |
| [gnosis MultiSig](https://github.com/gnosis/MultiSigWallet) | [GPLv3](https://github.com/gnosis/MultiSigWallet/blob/master/LICENSE) |


## Building contracts

To build all contracts and generate corresponding Go bindings:

```sh
./build.sh
```

## Running contract unit tests

- go version >1.11 is required.
- go modules (experimental in go 1.11) are needed. `export GO111MODULE=on`

```sh
go modules download
```

To test the contracts using the `go` command run:

```sh
go test -v ./test/...
```

To test the contracts using the `ginkgo` command run:

```sh
SILENT=true ginkgo -nodes=16 -r -p ./test/...
```

## Running validation tools

To run all validation tools locally using Docker run:

```sh
./tools/run-all.sh
```

To run a specific validation tool, use the provided scripts:

```sh
./tools/prettier/format.sh
./tools/slither/flatten.sh
./tools/slither/slither.sh
./tools/echidna/echidna.sh
./tools/mythril/mythril.sh
./tools/manticore/manticore.sh
```

## Resources

[🎮 Discord](https://discord.gg/GN6gGEP) | [🗞️Blog](https://medium.com/@Monolith) | [👽 Reddit](https://www.reddit.com/r/Monolith_Web3/) | [🕸️ Website ](https://monolith.xyz/) | [🐦 Twitter](https://twitter.com/monolith_web3) |
|---|---|---|---|---| 
