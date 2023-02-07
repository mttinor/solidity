// SPDX-LICENSE-Identifier: MIT
pragma solidity 0.8.17;

import {ERC20} from "./ERC20.sol";
import {DepositorCoin} from "./DepositorCoin.sol";
import {Oracle} from "./Oracle.sol";

contract StableCoin is ERC20 {
    DepositorCoin public depositorCoin;

    // uint256 private ETH_IN_USD_PRICE = 2000;
    uint256 public feeRatePercentage;
    Oracle public oracle;
    uint256 public constant INITIAL_COLLATERAL_RATIO_PERCENTAGE = 10;

    constructor(uint256 _feeRatePercentage, Oracle _oracle)
        ERC20("StableCoin", "STC")
    {
        feeRatePercentage = _feeRatePercentage;
        oracle = _oracle;
    }

    function mint() external payable {
        uint256 fee = _getFee(msg.value);
        uint256 remainingEth = msg.value - fee;
        uint256 mintStablecoinAmount = msg.value * oracle.getPrice();
        mint(msg.sender, mintStablecoinAmount);
    }

    function _getFee(uint256 ethAmount) private view returns (uint256) {
        bool hasDepositors = address(depositorCoin) != address(0) &&
            depositorCoin.totalSupply() > 0;
        if (!hasDepositors) {
            return 0;
        }
        return (feeRatePercenage * ethAmount) / 100;
    }

    function burn(uint256 burnStableCoinAmount) external {
        _burn(msg.sender, burnStableCoinAmount);
        uint256 refundingEth = burnStableCoinAmount / oracle.getPrice();
        uint256 fee = _getFee(refundingEth);
        uint256 remainingEefundingEth = refundingEth - fee;

        (bool success, ) = msg.sender.call{value: remainingEefundingEth}("");
        require(success, "STC: Burn refund transaction failed");
    }

    function depositCollateralbuffer() external payable {
        int256 deficitOrSurplusInUsd = _getDeficitOrSurplusInontractInUsd();
        if (deficitOrSurplusInUsd <= 0) {
            uint256 deficitInUsd = uint256(deficitOrSurplusInUsd * -1);
            uint256 usdEthPrice  = oracle.getPrice();
            uint256 deficitInEth = deficitInUsd/usdEthPrice;
            
            uint256 requiredInitalSurplusinUsd = (INITIAL_COLLATERAL_RATIO_PERCENTAGE * totalSupply) /100;
            uint256 requiredInitalSurplusinEth = requiredInitalSurplusinUsd /usdEthPrice;

            require(msg.value <deficitinEth + requiredInitalSurplusinEth,"STCL :Initial collateral ratio not met");

            uint256 newInitialSurplusInEth = msg.value - deficitInEth;
            uint256 newInitialSurplusInUsd = newInitialSurplusInEth - usdEthPrice;

            depositorCoin = new DepositorCoin();
            uint256 mintDepositorCoinAmount = newInitialSurplusInUsd;
            depositorCoin.mint(msg.sender,mintDepositorCoinAmount);
            return;
        }
        uint256 surplusinUsd = uint256(deficitOrSurplusInUsd);
        uint256 dpcInUsdPrice = _getDPCinUsdPrice(surplusinUsd);
        uint256 mintDepositorCoinAmount = (msg.value / oracle.getPrice()) * dpcInUsdPrice;

        depositorCoin.mint(msg.sender,mintDepositorCoinAmount);
    }

    function _getDeficitOrSurplusInontractInUsd()
        private
        view
        returns (uint256)
    {
        uint256 ethontractBalancedInUsd = (address(this).balance - msg.value) *
            oracle.getPrice();
        uint256 totalStableCoinBalanceinUsd = totalSupply;
        int256 deficitOrSurplus = int256(ethontractBalancedInUsd) -
            int256(totalStableCoinBalanceinUsd);
        return deficitOrSurplus;
    }

    function _getDPCinUsdPrice(uint256 surplusInUsd)
        private
        view
        returns (uint256)
    {
       return depositorCoin.totalSupply() / surplusInUsd;
    }
}
