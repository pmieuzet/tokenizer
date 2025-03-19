# Creation du smart contract 
_TUTORIAL:_
https://hardhat.org/tutorial/writing-and-compiling-contracts

https://ethereum.org/en/developers/docs/smart-contracts/composability/

Docu Solidity : https://docs.soliditylang.org/en/latest/

## Caractéristiques du token ERC-20
### Les fonctions :

- totalSupply() public view returns (uint256 totalSupply)
- balanceOf(address _owner) public view returns (uint256 balance)
- transfer(address _to, uint256 _value) public returns (bool success)
- transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
- approve(address _spender, uint256 _value) public returns (bool success)
- allowance(address _owner, address _spender) public view returns (uint256 remaining)

### Les événements :

- Transfer(address indexed _from, address indexed _to, uint256 _value)
- Approval(address indexed _owner, address indexed _spender, uint256 _value)