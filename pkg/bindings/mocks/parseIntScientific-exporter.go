// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package mocks

import (
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = abi.U256
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// ParseIntScientificExporterABI is the input ABI used to generate the binding from.
const ParseIntScientificExporterABI = "[{\"constant\":true,\"inputs\":[{\"name\":\"_a\",\"type\":\"string\"},{\"name\":\"_b\",\"type\":\"uint256\"}],\"name\":\"parseIntScientificDecimals\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"pure\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_a\",\"type\":\"string\"}],\"name\":\"parseIntScientific\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"pure\",\"type\":\"function\"}]"

// ParseIntScientificExporterBin is the compiled bytecode used for deploying new contracts.
const ParseIntScientificExporterBin = `608060405234801561001057600080fd5b50610d7e806100206000396000f30060806040526004361061004b5763ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166387c8da5e8114610050578063ba070695146100bd575b600080fd5b34801561005c57600080fd5b506040805160206004803580820135601f81018490048402850184019095528484526100ab94369492936024939284019190819084018382808284375094975050933594506101169350505050565b60408051918252519081900360200190f35b3480156100c957600080fd5b506040805160206004803580820135601f81018490048402850184019095528484526100ab9436949293602493928401919081908401838280828437509497506101299650505050505050565b6000610122838361013c565b9392505050565b600061013682600061013c565b92915050565b60008281808080808080808080805b8b518110156109b8578b517f3000000000000000000000000000000000000000000000000000000000000000908d908390811061018457fe5b90602001015160f860020a900460f860020a02600160f860020a031916101580156101fa57508b517f3900000000000000000000000000000000000000000000000000000000000000908d90839081106101da57fe5b90602001015160f860020a900460f860020a02600160f860020a03191611155b8015610204575083155b156102ce57841561026f576102208a600a63ffffffff610d0716565b8c51909a50610262906030908e908490811061023857fe5b90602001015160f860020a900460f860020a0260f860020a9004038b610d4090919063ffffffff16565b99506001909701966102c9565b600195506102848b600a63ffffffff610d0716565b8c51909b506102c6906030908e908490811061029c57fe5b90602001015160f860020a900460f860020a0260f860020a9004038c610d4090919063ffffffff16565b9a505b6109b0565b8b517f3000000000000000000000000000000000000000000000000000000000000000908d90839081106102fe57fe5b90602001015160f860020a900460f860020a02600160f860020a0319161015801561037457508b517f3900000000000000000000000000000000000000000000000000000000000000908d908390811061035457fe5b90602001015160f860020a900460f860020a02600160f860020a03191611155b801561037d5750835b156103dc5761039389600a63ffffffff610d0716565b8c519099506103d5906030908e90849081106103ab57fe5b90602001015160f860020a900460f860020a0260f860020a9004038a610d4090919063ffffffff16565b98506109b0565b8b517f2e00000000000000000000000000000000000000000000000000000000000000908d908390811061040c57fe5b90602001015160f860020a900460f860020a02600160f860020a031916141561053b57851515610486576040805160e560020a62461bcd02815260206004820152601560248201527f6d697373696e6720696e74656772616c20706172740000000000000000000000604482015290519081900360640190fd5b84156104dc576040805160e560020a62461bcd02815260206004820152601760248201527f6475706c696361746520646563696d616c20706f696e74000000000000000000604482015290519081900360640190fd5b8315610532576040805160e560020a62461bcd02815260206004820152601660248201527f646563696d616c206166746572206578706f6e656e7400000000000000000000604482015290519081900360640190fd5b600194506109b0565b8b517f2d00000000000000000000000000000000000000000000000000000000000000908d908390811061056b57fe5b90602001015160f860020a900460f860020a02600160f860020a031916141561069d5782156105e4576040805160e560020a62461bcd02815260206004820152600b60248201527f6475706c6963617465202d000000000000000000000000000000000000000000604482015290519081900360640190fd5b811561063a576040805160e560020a62461bcd02815260206004820152600a60248201527f6578747261207369676e00000000000000000000000000000000000000000000604482015290519081900360640190fd5b600187018114610694576040805160e560020a62461bcd02815260206004820152601e60248201527f2d207369676e206e6f7420696d6d6564696174656c7920616674657220650000604482015290519081900360640190fd5b600192506109b0565b8b517f2b00000000000000000000000000000000000000000000000000000000000000908d90839081106106cd57fe5b90602001015160f860020a900460f860020a02600160f860020a03191614156107ff578115610746576040805160e560020a62461bcd02815260206004820152600b60248201527f6475706c6963617465202b000000000000000000000000000000000000000000604482015290519081900360640190fd5b821561079c576040805160e560020a62461bcd02815260206004820152600a60248201527f6578747261207369676e00000000000000000000000000000000000000000000604482015290519081900360640190fd5b6001870181146107f6576040805160e560020a62461bcd02815260206004820152601e60248201527f2b207369676e206e6f7420696d6d6564696174656c7920616674657220650000604482015290519081900360640190fd5b600191506109b0565b8b517f4500000000000000000000000000000000000000000000000000000000000000908d908390811061082f57fe5b90602001015160f860020a900460f860020a02600160f860020a03191614806108a257508b517f6500000000000000000000000000000000000000000000000000000000000000908d908390811061088357fe5b90602001015160f860020a900460f860020a02600160f860020a031916145b15610960578515156108fe576040805160e560020a62461bcd02815260206004820152601560248201527f6d697373696e6720696e74656772616c20706172740000000000000000000000604482015290519081900360640190fd5b8315610954576040805160e560020a62461bcd02815260206004820152601960248201527f6475706c6963617465206578706f6e656e742073796d626f6c00000000000000604482015290519081900360640190fd5b600193508096506109b0565b6040805160e560020a62461bcd02815260206004820152600d60248201527f696e76616c696420646967697400000000000000000000000000000000000000604482015290519081900360640190fd5b60010161014b565b82806109c15750815b156109da576002870181116109d557600080fd5b6109ef565b83156109ef576001870181116109ef57600080fd5b8215610a7b578d8910610a7157604e8e8a0310610a56576040805160e560020a62461bcd02815260206004820152600d60248201527f6578706f6e656e74203e20373700000000000000000000000000000000000000604482015290519081900360640190fd5b8d8903600a0a8b811515610a6657fe5b049a508a9c50610cf5565b888e039d50610a8e565b610a8b8e8a63ffffffff610d4016565b9d505b878e10610bb457604e8810610b13576040805160e560020a62461bcd02815260206004820152602260248201527f6d6f7265207468616e20373720646563696d616c20646967697473207061727360448201527f6564000000000000000000000000000000000000000000000000000000000000606482015290519081900360840190fd5b610b278b600a8a900a63ffffffff610d0716565b9a50610b398b8b63ffffffff610d4016565b9a50604e888f0310610b95576040805160e560020a62461bcd02815260206004820152600d60248201527f6578706f6e656e74203e20373700000000000000000000000000000000000000604482015290519081900360640190fd5b610bad888f03600a0a8c610d0790919063ffffffff16565b9a50610cf1565b968d900396604e8810610c37576040805160e560020a62461bcd02815260206004820152602260248201527f6d6f7265207468616e20373720646563696d616c20646967697473207061727360448201527f6564000000000000000000000000000000000000000000000000000000000000606482015290519081900360840190fd5b87600a0a8a811515610c4557fe5b049950604e8e10610cc6576040805160e560020a62461bcd02815260206004820152602260248201527f6d6f7265207468616e20373720646563696d616c20646967697473207061727360448201527f6564000000000000000000000000000000000000000000000000000000000000606482015290519081900360840190fd5b610cdc8e600a0a8c610d0790919063ffffffff16565b9a50610cee8b8b63ffffffff610d4016565b9a505b8a9c505b50505050505050505050505092915050565b600080831515610d1a5760009150610d39565b50828202828482811515610d2a57fe5b0414610d3557600080fd5b8091505b5092915050565b600082820183811015610d3557600080fd00a165627a7a7230582040ecf989a398deadb07d2295f980168ed021bb07c061055abc406e2e752890730029`

// DeployParseIntScientificExporter deploys a new Ethereum contract, binding an instance of ParseIntScientificExporter to it.
func DeployParseIntScientificExporter(auth *bind.TransactOpts, backend bind.ContractBackend) (common.Address, *types.Transaction, *ParseIntScientificExporter, error) {
	parsed, err := abi.JSON(strings.NewReader(ParseIntScientificExporterABI))
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	address, tx, contract, err := bind.DeployContract(auth, parsed, common.FromHex(ParseIntScientificExporterBin), backend)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &ParseIntScientificExporter{ParseIntScientificExporterCaller: ParseIntScientificExporterCaller{contract: contract}, ParseIntScientificExporterTransactor: ParseIntScientificExporterTransactor{contract: contract}, ParseIntScientificExporterFilterer: ParseIntScientificExporterFilterer{contract: contract}}, nil
}

// ParseIntScientificExporter is an auto generated Go binding around an Ethereum contract.
type ParseIntScientificExporter struct {
	ParseIntScientificExporterCaller     // Read-only binding to the contract
	ParseIntScientificExporterTransactor // Write-only binding to the contract
	ParseIntScientificExporterFilterer   // Log filterer for contract events
}

// ParseIntScientificExporterCaller is an auto generated read-only Go binding around an Ethereum contract.
type ParseIntScientificExporterCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ParseIntScientificExporterTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ParseIntScientificExporterTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ParseIntScientificExporterFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ParseIntScientificExporterFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ParseIntScientificExporterSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ParseIntScientificExporterSession struct {
	Contract     *ParseIntScientificExporter // Generic contract binding to set the session for
	CallOpts     bind.CallOpts               // Call options to use throughout this session
	TransactOpts bind.TransactOpts           // Transaction auth options to use throughout this session
}

// ParseIntScientificExporterCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ParseIntScientificExporterCallerSession struct {
	Contract *ParseIntScientificExporterCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts                     // Call options to use throughout this session
}

// ParseIntScientificExporterTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ParseIntScientificExporterTransactorSession struct {
	Contract     *ParseIntScientificExporterTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts                     // Transaction auth options to use throughout this session
}

// ParseIntScientificExporterRaw is an auto generated low-level Go binding around an Ethereum contract.
type ParseIntScientificExporterRaw struct {
	Contract *ParseIntScientificExporter // Generic contract binding to access the raw methods on
}

// ParseIntScientificExporterCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ParseIntScientificExporterCallerRaw struct {
	Contract *ParseIntScientificExporterCaller // Generic read-only contract binding to access the raw methods on
}

// ParseIntScientificExporterTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ParseIntScientificExporterTransactorRaw struct {
	Contract *ParseIntScientificExporterTransactor // Generic write-only contract binding to access the raw methods on
}

// NewParseIntScientificExporter creates a new instance of ParseIntScientificExporter, bound to a specific deployed contract.
func NewParseIntScientificExporter(address common.Address, backend bind.ContractBackend) (*ParseIntScientificExporter, error) {
	contract, err := bindParseIntScientificExporter(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ParseIntScientificExporter{ParseIntScientificExporterCaller: ParseIntScientificExporterCaller{contract: contract}, ParseIntScientificExporterTransactor: ParseIntScientificExporterTransactor{contract: contract}, ParseIntScientificExporterFilterer: ParseIntScientificExporterFilterer{contract: contract}}, nil
}

// NewParseIntScientificExporterCaller creates a new read-only instance of ParseIntScientificExporter, bound to a specific deployed contract.
func NewParseIntScientificExporterCaller(address common.Address, caller bind.ContractCaller) (*ParseIntScientificExporterCaller, error) {
	contract, err := bindParseIntScientificExporter(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ParseIntScientificExporterCaller{contract: contract}, nil
}

// NewParseIntScientificExporterTransactor creates a new write-only instance of ParseIntScientificExporter, bound to a specific deployed contract.
func NewParseIntScientificExporterTransactor(address common.Address, transactor bind.ContractTransactor) (*ParseIntScientificExporterTransactor, error) {
	contract, err := bindParseIntScientificExporter(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ParseIntScientificExporterTransactor{contract: contract}, nil
}

// NewParseIntScientificExporterFilterer creates a new log filterer instance of ParseIntScientificExporter, bound to a specific deployed contract.
func NewParseIntScientificExporterFilterer(address common.Address, filterer bind.ContractFilterer) (*ParseIntScientificExporterFilterer, error) {
	contract, err := bindParseIntScientificExporter(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ParseIntScientificExporterFilterer{contract: contract}, nil
}

// bindParseIntScientificExporter binds a generic wrapper to an already deployed contract.
func bindParseIntScientificExporter(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ParseIntScientificExporterABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ParseIntScientificExporter *ParseIntScientificExporterRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _ParseIntScientificExporter.Contract.ParseIntScientificExporterCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ParseIntScientificExporter *ParseIntScientificExporterRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ParseIntScientificExporter.Contract.ParseIntScientificExporterTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ParseIntScientificExporter *ParseIntScientificExporterRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ParseIntScientificExporter.Contract.ParseIntScientificExporterTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ParseIntScientificExporter *ParseIntScientificExporterCallerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _ParseIntScientificExporter.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ParseIntScientificExporter *ParseIntScientificExporterTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ParseIntScientificExporter.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ParseIntScientificExporter *ParseIntScientificExporterTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ParseIntScientificExporter.Contract.contract.Transact(opts, method, params...)
}

// ParseIntScientific is a free data retrieval call binding the contract method 0xba070695.
//
// Solidity: function parseIntScientific(_a string) constant returns(uint256)
func (_ParseIntScientificExporter *ParseIntScientificExporterCaller) ParseIntScientific(opts *bind.CallOpts, _a string) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _ParseIntScientificExporter.contract.Call(opts, out, "parseIntScientific", _a)
	return *ret0, err
}

// ParseIntScientific is a free data retrieval call binding the contract method 0xba070695.
//
// Solidity: function parseIntScientific(_a string) constant returns(uint256)
func (_ParseIntScientificExporter *ParseIntScientificExporterSession) ParseIntScientific(_a string) (*big.Int, error) {
	return _ParseIntScientificExporter.Contract.ParseIntScientific(&_ParseIntScientificExporter.CallOpts, _a)
}

// ParseIntScientific is a free data retrieval call binding the contract method 0xba070695.
//
// Solidity: function parseIntScientific(_a string) constant returns(uint256)
func (_ParseIntScientificExporter *ParseIntScientificExporterCallerSession) ParseIntScientific(_a string) (*big.Int, error) {
	return _ParseIntScientificExporter.Contract.ParseIntScientific(&_ParseIntScientificExporter.CallOpts, _a)
}

// ParseIntScientificDecimals is a free data retrieval call binding the contract method 0x87c8da5e.
//
// Solidity: function parseIntScientificDecimals(_a string, _b uint256) constant returns(uint256)
func (_ParseIntScientificExporter *ParseIntScientificExporterCaller) ParseIntScientificDecimals(opts *bind.CallOpts, _a string, _b *big.Int) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _ParseIntScientificExporter.contract.Call(opts, out, "parseIntScientificDecimals", _a, _b)
	return *ret0, err
}

// ParseIntScientificDecimals is a free data retrieval call binding the contract method 0x87c8da5e.
//
// Solidity: function parseIntScientificDecimals(_a string, _b uint256) constant returns(uint256)
func (_ParseIntScientificExporter *ParseIntScientificExporterSession) ParseIntScientificDecimals(_a string, _b *big.Int) (*big.Int, error) {
	return _ParseIntScientificExporter.Contract.ParseIntScientificDecimals(&_ParseIntScientificExporter.CallOpts, _a, _b)
}

// ParseIntScientificDecimals is a free data retrieval call binding the contract method 0x87c8da5e.
//
// Solidity: function parseIntScientificDecimals(_a string, _b uint256) constant returns(uint256)
func (_ParseIntScientificExporter *ParseIntScientificExporterCallerSession) ParseIntScientificDecimals(_a string, _b *big.Int) (*big.Int, error) {
	return _ParseIntScientificExporter.Contract.ParseIntScientificDecimals(&_ParseIntScientificExporter.CallOpts, _a, _b)
}
