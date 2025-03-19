# Idee du projet

# Choix du nom du token

## Community42

Car l'objectif de mon token serait de tendre à réduire les inégalités par rapport à l'accès à tout type de services et de promouvoir une économie collaborative.

# Choix de la blockchain

## Ethereum

# Choix du framework

## Hardhat

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