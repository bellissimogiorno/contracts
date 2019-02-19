/**
 *  The Consumer Contract Wallet
 *  Copyright (C) 2018 The Contract Wallet Company Limited
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.or/licenses/>.
 */

pragma solidity ^0.4.25;

import "./licence.sol";
import "./internals/ownable.sol";
import "./internals/controllable.sol";
import "./internals/tokenWhitelistable.sol";
import "./externals/ens/PublicResolver.sol";
import "./externals/SafeMath.sol";
import "./externals/ERC20.sol";
import "./externals/ERC165.sol";

/// @title Whitelist provides payee-whitelist functionality.
contract Whitelist is Controllable, Ownable {
    event AddedToWhitelist(address _sender, address[] _addresses);
    event SubmittedWhitelistAddition(address[] _addresses, bytes32 _hash);
    event CancelledWhitelistAddition(address _sender, bytes32 _hash);

    event RemovedFromWhitelist(address _sender, address[] _addresses);
    event SubmittedWhitelistRemoval(address[] _addresses, bytes32 _hash);
    event CancelledWhitelistRemoval(address _sender, bytes32 _hash);

    mapping(address => bool) public isWhitelisted;
    address[] private _pendingWhitelistAddition;
    address[] private _pendingWhitelistRemoval;
    bool public submittedWhitelistAddition;
    bool public submittedWhitelistRemoval;
    bool public initializedWhitelist;

    /// @dev Check if the provided addresses contain the owner or the zero-address address.
    modifier hasNoOwnerOrZeroAddress(address[] _addresses) {
        for (uint i = 0; i < _addresses.length; i++) {
            require(_addresses[i] != owner(), "provided whitelist contains the owner address");
            require(_addresses[i] != address(0), "provided whitelist contains the zero address");
        }
        _;
    }

    /// @dev Check that neither addition nor removal operations have already been submitted.
    modifier noActiveSubmission() {
        require(!submittedWhitelistAddition && !submittedWhitelistRemoval, "whitelist operation has already been submitted");
        _;
    }

    /// @dev Getter for pending addition array.
    function pendingWhitelistAddition() external view returns (address[]) {
        return _pendingWhitelistAddition;
    }

    /// @dev Getter for pending removal array.
    function pendingWhitelistRemoval() external view returns (address[]) {
        return _pendingWhitelistRemoval;
    }

    /// @dev Getter for pending addition/removal array hash.
    function pendingWhitelistHash(address[] _pendingWhitelist) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_pendingWhitelist));
    }

    /// @dev Add initial addresses to the whitelist.
    /// @param _addresses are the Ethereum addresses to be whitelisted.
    function initializeWhitelist(address[] _addresses) external onlyOwner hasNoOwnerOrZeroAddress(_addresses) {
        // Require that the whitelist has not been initialized.
        require(!initializedWhitelist, "whitelist has already been initialized");
        // Add each of the provided addresses to the whitelist.
        for (uint i = 0; i < _addresses.length; i++) {
            isWhitelisted[_addresses[i]] = true;
        }
        initializedWhitelist = true;
        // Emit the addition event.
        emit AddedToWhitelist(msg.sender, _addresses);
    }

    /// @dev Add addresses to the whitelist.
    /// @param _addresses are the Ethereum addresses to be whitelisted.
    function submitWhitelistAddition(address[] _addresses) external onlyOwner noActiveSubmission hasNoOwnerOrZeroAddress(_addresses) {
        // Require that the whitelist has been initialized.
        require(initializedWhitelist, "whitelist has not been initialized");
        // Set the provided addresses to the pending addition addresses.
        _pendingWhitelistAddition = _addresses;
        // Flag the operation as submitted.
        submittedWhitelistAddition = true;
        // Emit the submission event.
        emit SubmittedWhitelistAddition(_addresses, pendingWhitelistHash(_pendingWhitelistAddition));
    }

    /// @dev Confirm pending whitelist addition.
    function confirmWhitelistAddition(bytes32 _hash) external onlyController {
        // Require that the whitelist addition has been submitted.
        require(submittedWhitelistAddition, "whitelist addition has not been submitted");

        // Require that confirmation hash and the hash of the pending whitelist addition match
        require(_hash == pendingWhitelistHash(_pendingWhitelistAddition), "hash of the pending whitelist addition do not match");

        // Whitelist pending addresses.
        for (uint i = 0; i < _pendingWhitelistAddition.length; i++) {
            isWhitelisted[_pendingWhitelistAddition[i]] = true;
        }
        // Emit the addition event.
        emit AddedToWhitelist(msg.sender, _pendingWhitelistAddition);
        // Reset pending addresses.
        delete _pendingWhitelistAddition;
        // Reset the submission flag.
        submittedWhitelistAddition = false;
    }

    /// @dev Cancel pending whitelist addition.
    function cancelWhitelistAddition(bytes32 _hash) external onlyController {
        // Require that confirmation hash and the hash of the pending whitelist addition match
        require(_hash == pendingWhitelistHash(_pendingWhitelistAddition), "hash of the pending whitelist addition does not match");
        // Reset pending addresses.
        delete _pendingWhitelistAddition;
        // Reset the submitted operation flag.
        submittedWhitelistAddition = false;
        // Emit the cancellation event.
        emit CancelledWhitelistAddition(msg.sender, _hash);
    }

    /// @dev Remove addresses from the whitelist.
    /// @param _addresses are the Ethereum addresses to be removed.
    function submitWhitelistRemoval(address[] _addresses) external onlyOwner noActiveSubmission {
        // Add the provided addresses to the pending addition list.
        _pendingWhitelistRemoval = _addresses;
        // Flag the operation as submitted.
        submittedWhitelistRemoval = true;
        // Emit the submission event.
        emit SubmittedWhitelistRemoval(_addresses, pendingWhitelistHash(_pendingWhitelistRemoval));
    }

    /// @dev Confirm pending removal of whitelisted addresses.
    function confirmWhitelistRemoval(bytes32 _hash) external onlyController {
        // Require that the pending whitelist is not empty and the operation has been submitted.
        require(submittedWhitelistRemoval, "whitelist removal has not been submitted");
        require(_pendingWhitelistRemoval.length > 0, "pending whitelist removal is empty");
        // Require that confirmation hash and the hash of the pending whitelist removal match
        require(_hash == pendingWhitelistHash(_pendingWhitelistRemoval), "hash of the pending whitelist removal does not match the confirmed hash");
        // Remove pending addresses.
        for (uint i = 0; i < _pendingWhitelistRemoval.length; i++) {
            isWhitelisted[_pendingWhitelistRemoval[i]] = false;
        }
        // Emit the removal event.
        emit RemovedFromWhitelist(msg.sender, _pendingWhitelistRemoval);
        // Reset pending addresses.
        delete _pendingWhitelistRemoval;
        // Reset the submission flag.
        submittedWhitelistRemoval = false;
    }

    /// @dev Cancel pending removal of whitelisted addresses.
    function cancelWhitelistRemoval(bytes32 _hash) external onlyController {
        // Require that confirmation hash and the hash of the pending whitelist removal match
        require(_hash == pendingWhitelistHash(_pendingWhitelistRemoval), "hash of the pending whitelist removal does not match");
        // Reset pending addresses.
        delete _pendingWhitelistRemoval;
        // Reset the submitted operation flag.
        submittedWhitelistRemoval = false;
        // Emit the cancellation event.
        emit CancelledWhitelistRemoval(msg.sender, _hash);
    }
}

contract DailyLimit {
    using SafeMath for uint256;

    uint private _spendLimitDay;
    uint private _limit;
    uint private _available;

    /// @dev Constructor initializes the daily spend limit in wei.
    constructor(uint _spendLimit) public {
        _limit = _spendLimit;
        _available = _spendLimit;
        _spendLimitDay = now;
    }

    /// @dev Returns the available daily balance - accounts for daily limit reset.
    /// @return amount of ether in wei.
    function available() public view returns (uint) {
        if (now > _spendLimitDay + 24 hours) {
            return _limit;
        } else {
            return _available;
        }
    }

    // @dev Setter method for the available daily spend limit.
    function setAvailable(uint _amount) public {
        _available = _amount;
    }

    /// @dev Update available spend limit based on the daily reset.
    function updateAvailable() public {
        if (now > _spendLimitDay.add(24 hours)) {
            // Advance the current day by how many days have passed.
            uint extraDays = now.sub(_spendLimitDay).div(24 hours);
            _spendLimitDay = _spendLimitDay.add(extraDays.mul(24 hours));
            // Set the available limit to the current spend limit.
            _available = _limit;
            //TODO i guess we need to do this twice
        }
    }

    /// @dev Modify the spend limit and spend available based on the provided value.
    /// @dev _amount is the daily limit amount in wei.
    function modifyLimit(uint _amount) public {
        // Account for the spend limit daily reset.
        updateAvailable();
        // Set the daily limit to the provided amount.
        _limit = _amount;
        // Lower the available limit if it's higher than the new daily limit.
        if (_available > _limit) {
            _available = _limit;
        }
    }


    function limit() public view returns (uint) {
        return _limit;
    }

}


//// @title SpendLimit provides daily spend limit functionality.
contract SpendLimit is Controllable, Ownable {
    event SetSpendLimit(address _sender, uint _amount);
    event SubmittedSpendLimitChange(uint _amount);
    event CancelledSpendLimitChange(address _sender, uint _amount);

    using SafeMath for uint256;

    /* enum SpendLimitChoices { Spend, Load } */

    uint private _spendLimitDay;

    uint public pendingSpendLimit;
    bool public submittedSpendLimit;
    bool public initializedSpendLimit;

    DailyLimit internal _spendLimit;

    /// @dev Constructor initializes the daily spend limit in wei.
    constructor(uint spendLimit) internal {
        _spendLimit = new DailyLimit(spendLimit);
        /* _topupLimit = new DailyLimit(loadLimit); */
    }

    /// @dev Initialize a daily spend (aka transfer) limit for non-whitelisted addresses.
    /// @param _amount is the daily limit amount in wei.
    function initializeSpendLimit(uint _amount) external onlyOwner {
        // Require that the spend limit has not been initialized.
        require(!initializedSpendLimit, "spend limit has already been initialized");
        // Modify spend limit based on the provided value.
        _spendLimit.modifyLimit(_amount);
        // Flag the operation as initialized.
        initializedSpendLimit = true;
        // Emit the set limit event.
        emit SetSpendLimit(msg.sender, _amount);
    }

    /// @dev Set a daily transfer limit for non-whitelisted addresses.
    /// @param _amount is the daily limit amount in wei.
    function submitSpendLimit(uint _amount) external onlyOwner {
        // Require that the spend limit has been initialized.
        require(initializedSpendLimit, "spend limit has not been initialized");
        // Require that the operation has been submitted.
        require(!submittedSpendLimit, "spend limit has already been submitted");
        // Assign the provided amount to pending daily limit change.
        pendingSpendLimit = _amount;
        // Flag the operation as submitted.
        submittedSpendLimit = true;
        // Emit the submission event.
        emit SubmittedSpendLimitChange(_amount);
    }

    /// @dev Confirm pending set daily limit operation.
    function confirmSpendLimit(uint _amount) external onlyController {
        // Require that the operation has been submitted.
        require(submittedSpendLimit, "spend limit has not been submitted");
        // Require that pending and confirmed spend limit are the same
        require(pendingSpendLimit == _amount, "confirmed and submitted spend limits dont match");
        // Modify spend limit based on the pending value.
        _spendLimit.modifyLimit(pendingSpendLimit);
        // Emit the set limit event.
        emit SetSpendLimit(msg.sender, pendingSpendLimit);
        // Reset the submission flag.
        submittedSpendLimit = false;
        // Reset pending daily limit.
        pendingSpendLimit = 0;
    }

    /// @dev Cancel pending set daily limit operation.
    function cancelSpendLimit(uint _amount) external onlyController {
        // Require that pending and confirmed spend limit are the same
        require(pendingSpendLimit == _amount, "pending and cancelled spend limits dont match");
        // Reset pending daily limit.
        pendingSpendLimit = 0;
        // Reset the submitted operation flag.
        submittedSpendLimit = false;
        // Emit the cancellation event.
        emit CancelledSpendLimitChange(msg.sender, _amount);
    }

    function spendAvailable() public view returns (uint) {
        return _spendLimit.available();
    }

    function spendLimit() public view returns (uint) {
        return _spendLimit.limit();
    }

}


//// @title Asset store with extra security features.
contract Vault is Whitelist, SpendLimit, ERC165, TokenWhitelistable {
    event Received(address _from, uint _amount);
    event Transferred(address _to, address _asset, uint _amount);

    using SafeMath for uint256;

    /// @dev Supported ERC165 interface ID.
    bytes4 private constant _ERC165_INTERFACE_ID = 0x01ffc9a7; // solium-disable-line uppercase

    /// @dev Constructor initializes the vault with an owner address and spend limit. It also sets up the oracle and controller contracts.
    /// @param _owner is the owner account of the wallet contract.
    /// @param _transferable indicates whether the contract ownership can be transferred.
    /// @param _ens is the ENS public registry contract address.
    /// @param _tokenWhitelistName is the ENS name of the Token whitelist.
    /// @param _controllerName is the ENS name of the controller.
    /// @param _spendLimit is the initial spend limit.
    constructor(address _owner, bool _transferable, address _ens, bytes32 _tokenWhitelistName, bytes32 _controllerName, uint _spendLimit) SpendLimit(_spendLimit) Ownable(_owner, _transferable) Controllable(_ens, _controllerName) TokenWhitelistable(_ens, _tokenWhitelistName) public {
    }

    /// @dev Checks if the value is not zero.
    modifier isNotZero(uint _value) {
        require(_value != 0, "provided value cannot be zero");
        _;
    }

    /// @dev Ether can be deposited from any source, so this contract must be payable by anyone.
    function() public payable {
        require(msg.data.length == 0);
        emit Received(msg.sender, msg.value);
    }

    /// @dev Returns the amount of an asset owned by the contract.
    /// @param _asset address of an ERC20 token or 0x0 for ether.
    /// @return balance associated with the wallet address in wei.
    function balance(address _asset) external view returns (uint) {
        if (_asset != address(0)) {
            return ERC20(_asset).balanceOf(this);
        } else {
            return address(this).balance;
        }
    }

    /// @dev Convert ERC20 token amount to the corresponding ether amount (used by the wallet contract).
    /// @param _token ERC20 token contract address.
    /// @param _amount amount of token in base units.
    function convert(address _token, uint _amount) public view returns (uint) {
        // Store the token in memory to save map entry lookup gas.
        ( , uint256 magnitude, uint256 rate, bool available, , ) = _getTokenInfo(_token);
        // If the token exists require that its rate is not zero
        if (available) {
            require(rate != 0, "token rate is 0");
            // Safely convert the token amount to ether based on the exchange rate.
            // return the value, the token is, AT LEAST, protected
            return _amount.mul(rate).div(magnitude);
        }
        // this returns a 0/'false' to imply that the token is not protected
        return 0;
    }


    /// @dev Transfers the specified asset to the recipient's address.
    /// @param _to is the recipient's address.
    /// @param _asset is the address of an ERC20 token or 0x0 for ether.
    /// @param _amount is the amount of assets to be transferred in base units.
    function transfer(address _to, address _asset, uint _amount) external onlyOwner isNotZero(_amount) {
        // Checks if the _to address is not the zero-address
        require(_to != address(0), "_to address cannot be set to 0x0");

        // If address is not whitelisted, take daily limit into account.
        if (!isWhitelisted[_to]) {
            // Update the available spend limit.
            // _updateSpendAvailable();

            //initialize ether value in case the asset is ETH
            uint etherValue = _amount;
            // Convert token amount to ether value if asset is an ERC20 token.
            if (_asset != address(0)) {
                etherValue = convert(_asset, _amount);
            }

            // Check against the daily spent limit and update accordingly
            // Require that the value is under remaining limit.
            require(etherValue <= spendAvailable(), "transfer amount exceeded available spend limit");
            // Update the available limit.
            // _setSpendAvailable(spendAvailable().sub(etherValue));
        }
        // Transfer token or ether based on the provided address.
        if (_asset != address(0)) {
            require(ERC20(_asset).transfer(_to, _amount), "ERC20 token transfer was unsuccessful");
        } else {
            _to.transfer(_amount);
        }
        // Emit the transfer event.
        emit Transferred(_to, _asset, _amount);
    }

    /// @dev Checks for interface support based on ERC165.
    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return interfaceID == _ERC165_INTERFACE_ID;
    }
}


//// @title Asset wallet with extra security features, gas top up management and card integration.
contract Wallet is Vault {
    event SetTopUpLimit(address _sender, uint _amount);
    event SubmittedTopUpLimitChange(uint _amount);
    event CancelledTopUpLimitChange(address _sender, uint _amount);

    event ToppedUpGas(address _sender, address _owner, uint _amount);

    event LoadedTokenCard(address _asset, uint _amount);

    using SafeMath for uint256;


    uint constant private MINIMUM_TOPUP_LIMIT = 1 finney; // solium-disable-line uppercase
    uint constant private MAXIMUM_TOPUP_LIMIT = 500 finney; // solium-disable-line uppercase

    uint public pendingTopUpLimit;
    bool public submittedTopUpLimit;
    bool public initializedTopUpLimit;

    /// @dev Is the registered ENS name of the oracle contract.
    bytes32 private _licenceNode;

    DailyLimit internal _topupLimit;
    /// @dev ENS points to the ENS registry smart contract.
    ENS internal _ENS;


    /// @dev Constructor initializes the wallet top up limit and the vault contract.
    /// @param _owner is the owner account of the wallet contract.
    /// @param _transferable indicates whether the contract ownership can be transferred.
    /// @param _ens is the address of the ENS.
    /// @param _oracleName is the ENS name of the Oracle.
    /// @param _controllerName is the ENS name of the Controller.
    /// @param _licenceName is the ENS name of the licence.
    /// @param _spendLimit is the initial spend limit.
    constructor(address _owner, bool _transferable, address _ens, bytes32 _oracleName, bytes32 _controllerName, bytes32 _licenceName, uint _spendLimit) Vault(_owner, _transferable, _ens, _oracleName, _controllerName, _spendLimit) public {
        _topupLimit = new DailyLimit(MAXIMUM_TOPUP_LIMIT);
        _licenceNode = _licenceName;
        _ENS = ENS(_ens);
    }

    /// @dev Returns the available daily gas top up balance - accounts for daily limit reset.
    /// @return amount of gas in wei.
    function topUpAvailable() external view returns (uint) {
        return _topupLimit.available();
    }

    /// @dev Initialize a daily gas top up limit.
    /// @param _amount is the gas top up amount in wei.
    function initializeTopUpLimit(uint _amount) external onlyOwner {
        // Require that the top up limit has not been initialized.
        require(!initializedTopUpLimit, "top up limit has already been initialized");
        // Require that the limit amount is within the acceptable range.
        require(MINIMUM_TOPUP_LIMIT <= _amount && _amount <= MAXIMUM_TOPUP_LIMIT, "top up amount is outside of the min/max range");
        // Modify spend limit based on the provided value.
        _topupLimit.modifyLimit(_amount);
        // Flag operation as initialized.
        initializedTopUpLimit = true;
        // Emit the set limit event.
        emit SetTopUpLimit(msg.sender, _amount);
    }

    /// @dev Set a daily top up top up limit.
    /// @param _amount is the daily top up limit amount in wei.
    function submitTopUpLimit(uint _amount) external onlyOwner {
        // Require that the top up limit has been initialized.
        require(initializedTopUpLimit, "top up limit has not been initialized");
        // Require that the operation has not been submitted.
        require(!submittedTopUpLimit, "top up limit has already been submitted");
        // Require that the limit amount is within the acceptable range.
        require(MINIMUM_TOPUP_LIMIT <= _amount && _amount <= MAXIMUM_TOPUP_LIMIT, "top up amount is outside of the min/max range");
        // Assign the provided amount to pending daily limit change.
        pendingTopUpLimit = _amount;
        // Flag the operation as submitted.
        submittedTopUpLimit = true;
        // Emit the submission event.
        emit SubmittedTopUpLimitChange(_amount);
    }

    /// @dev Confirm pending set top up limit operation.
    function confirmTopUpLimit(uint _amount) external onlyController {
        // Require that the operation has been submitted.
        require(submittedTopUpLimit, "top up limit has not been submitted");
        // Assert that the pending top up limit amount is within the acceptable range.
        require(MINIMUM_TOPUP_LIMIT <= pendingTopUpLimit && pendingTopUpLimit <= MAXIMUM_TOPUP_LIMIT, "top up amount is outside the min/max range");
        // Assert that confirmed and pending topup limit are the same.
        require(_amount == pendingTopUpLimit, "confirmed and pending topup limit are not same");
        // Modify top up limit based on the pending value.
        _topupLimit.modifyLimit(pendingTopUpLimit);
        // Emit the set limit event.
        emit SetTopUpLimit(msg.sender, pendingTopUpLimit);
        // Reset pending daily limit.
        pendingTopUpLimit = 0;
        // Reset the submission flag.
        submittedTopUpLimit = false;
    }

    /// @dev Cancel pending set top up limit operation.
    function cancelTopUpLimit(uint _amount) external onlyController {
        // Require that pending and confirmed spend limit are the same
        require(pendingTopUpLimit == _amount, "pending and cancelled top up limits dont match");
        // Reset pending daily limit.
        pendingTopUpLimit = 0;
        // Reset the submitted operation flag.
        submittedTopUpLimit = false;
        // Emit the cancellation event.
        emit CancelledTopUpLimitChange(msg.sender, _amount);
    }

    /// @dev Refill owner's gas balance, revert if the transaction amount is too large
    /// @param _amount is the amount of ether to transfer to the owner account in wei.
    function topUpGas(uint _amount) external isNotZero(_amount) {
        // Require that the sender is either the owner or a controller.
        require(_isOwner() || _isController(msg.sender), "sender is neither an owner nor a controller");
        // Account for the top up limit daily reset.
        _topupLimit.updateAvailable();
        // Make sure the available top up amount is not zero.
        require(_topupLimit.available() != 0, "available top up limit cannot be zero");
        // Fail if there isn't enough in the daily top up limit to perform topUp
        require(_amount <= _topupLimit.available(), "available top up limit less than amount passed in");

        _topupLimit.setAvailable(_topupLimit.available().sub(_amount));

        owner().transfer(_amount);

        // Emit the gas top up event.
        emit ToppedUpGas(tx.origin, owner(), _amount);
    }

    function topUpLimit() public view returns (uint) {
        return _topupLimit.limit();
    }

    /// @dev Load a token card with the specified asset amount.
    /// the amount send should be inclusive of the percent licence.
    /// @param _asset is the address of an ERC20 token or 0x0 for ether.
    /// @param _amount is the amount of assets to be transferred in base units.
    function loadTokenCard(address _asset, uint _amount) external payable onlyOwner {
        address licenceAddress = PublicResolver(_ENS.resolver(_licenceNode)).addr(_licenceNode);
        if (_asset != address(0)) {
            require(ERC20(_asset).approve(licenceAddress, _amount), "ERC20 token approval was unsuccessful");
            ILicence(licenceAddress).load(_asset, _amount);
        } else {
            ILicence(licenceAddress).load.value(_amount)(_asset, _amount);
        }
        emit LoadedTokenCard(_asset, _amount);
    }

}
