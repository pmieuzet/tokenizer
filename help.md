# Creation du smart contract 

## Règles:
- Il y a une offre totale fixe de jetons qui ne peuvent pas être changés.
- L'ensemble de la fourniture est affecté à l'adresse qui déploie le contrat.
- N'importe qui peut recevoir des jetons.
- Toute personne avec au moins un jeton peut transférer des jetons.
- Le jeton n'est pas divisible. Vous pouvez transférer 1, 2, 3 ou 37 jetons mais pas 2,5.

_TUTORIAL:_
https://hardhat.org/tutorial/writing-and-compiling-contracts

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