import {expect} from "chai";
import {ethers} from "hardhat";
import {ERC20} from "../typechain-types";
import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";


describe("MyERC20Contract",()=>{
    let myERC20Contact: ERC20;
    let someAddress:SignerWithAddress;
    let someOtherAddress:SignerWithAddress;
    
    beforeEach(async ()=>{
        const REC20ContactFactory = await ethers.getContractFactory("ERC20");
        const myERC20Contact = await REC20ContactFactory.deploy("hello","SYM")
        await myERC20Contact.deployed(); 
        someAddress = (await ethers.getSigner())[1];
        someOtherAddress = (await ethers.getSigner())[2];
    });
    describe("when l have 10 tokens",()=>{
        beforeEach(async ()=>{
            await myERC20Contact.transfer(someAddress.address,10)
        });

        describe("when transfer 10 tokens",()=>{
            it("should transfor token correctly",async ()=>{
                await myERC20Contact.connect(someAddress).transfer(someOtherAddress.address,10);
                // expect(await myERC20Contact.balanceOf(someOtherAddress.address)).to.equal(10);
            })
        });
    });

    // describe("when l have 15 tokens",()=>{
    //     describe("when transfer 15 tokens",()=>{
    //         it("should transfor token correctly",async ()=>{
    //             await expect(myERC20Contact.connect(someAddress).transfer(someOtherAddress.address,15)).to.be.revertedWith("ECR20:transfer amount exceeds balance");
    //         })
    //     });
    // });
});