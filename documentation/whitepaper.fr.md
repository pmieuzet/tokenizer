# White paper version francaise : Community42 (COMM42)

L'équité sociale par l'échange de services décentralisés.

## le problème

La monétisation systématique et centralisée des interactions humaines a érodé le tissu social local. Les communautés informelles d'entraide sont devenues dépendantes de systèmes transactionnels.De plus, il existe des asymétries financières importantes. Pour les populations marginalisées ou diposant de faibles revenus, l'accès à certains services est ainsi devenu compliqué voire impossible, créant une fracture socio-économique grandissante. 

Aujourd'hui, le modèle de consommation se restructure de comportements individuels vers des systèmes collectifs, c'est pourquoi il est temps de construire un nouveau système d'échanges de services basé sur une monnaie de confiance fiable et équitable.

## La solution

Dans les années 1980, une réponse à cette asymétrie financière et sociale est apparue avec la création du *time banking* par Edgar Cahn aux États-Unis. Cette initiative a cependant rencontré des limites structurelles : la tenue des registres reposait sur des coordinateurs humains (chronophage), le système manquait de transparence et l'absence d'interfaces numériques limitait son adoption.

COMM42 est une réponse moderne à ces problématiques : un jeton utilitaire social non-négociable en monnaie fiduciaire.
Cette solution fusionne la philosophie égalitaire des échanges basés sur le temps avec la confiance en la sécurité décentralisée de la blockchain et des contrats intelligents.

Contrairement aux cryptomonnaies spéculatives conçues pour l'accumulation de capital financier, ce jeton est architecturé exclusivement pour quantifier, faciliter et sécuriser l'échange de temps, de compétences et d'énergie sociale entre les utilisateurs de la communauté.

### Fonctionnalités

Les utilisateurs peuvent créer des services : des événements.
Les utilisateurs peuvent participer à des événements créés par d'autres utilisateurs.
Les utilisateurs peuvent contribuer à des événements existants.
Les utilisateurs peuvent effectuer des dons à d'autres membres (philantropie intra-communautaire).

## Choix techniques

### Blockchain : Ethereum

La blockchain Ethereum est pionnière en terme de smart contrat, elle jouit donc d'une notoriété importante et indispensable à la création d'un token d'échange tel que COMM42. 

Depuis 2022, Ethereum a modifié son mécanisme de consensus et fonctionne aujourd'hui en proof-of-stake. Ce passage offre des avantages intéressants dans le cadre du développement de notre token COMM42. Moins energivore que le proof-of-work, il est également fondé sur le principe de l'équité ce qui le rend attractif et inclusif.

#### Standard ERC-20

Développé en 2015, le standard ERC20 permet de standardiser les tokens de la blockchain Ethereum afin de générer des tokens fongibles à partir d'un ensemble de règles communes à respecter lors de l'écriture du smart contrat.
Cela permet entre autres une compatibilité de tous les outils et jetons appartenant à l'écosystème Ethereum. Cela permet notamment d'utiliser le même portefeuille pour manipuler différents tokens sur la blockchain.

### Solidity et Hardhat

Solidity est le principal langage pour développer des contrats intelligents sur la blockchain Ethereum.

Hardhat est un framework dédié au développement de contrats intelligents sur Ethereum. Il offre un environnement facilitant leur déploiement et permet de les tester efficacement.

## Le modèle économique

Le propriétaire du projet et du contrat intelligent est une association loi 1901, à but non lucratif.

La blockchain est souvent utilisée à des fins financières, les assets se valorisant eux-mêmes grâces aux investissements des utilisateurs. Ce projet à la vocation inverse : valoriser l'humain, à des fins sociales.
La blockchain devient un facilitateur de confiance pour les échanges de services, l'aspect financier se concentrant non pas sur la valeur du token, mais sur la récompense pour la coopération et le partage.

COMM42 ne peut être acheté, c'est une économie circulaire : chaque activité implique un transfert de tokens.
COMM42 est transférable à titre gratuit.
COMM42 est inflationniste : émis uniquement lorsque l'identité d'un utilisateur qui a créé un compte est vérifiée.

La participation et l'organisation d'événements n'impliquent aucune transaction financière : seulement la transaction de tokens.

La dotation initiale automatique de 5 jetons par utilisateur à la vérification du compte contourne l'écueil du démarrage à froid. Cela permet aux nouveaux utilisateurs de participer sans investissement préalable.

### Sécurité

La mise en place d'un contrat MultiSig permet de renforcer la sécurité, notamment pour les transactions risquées qui demandent de créer de nouveaux jetons (`mint`). Le contrat peut etre déployer avec deux adresses de signataires ou plus. Chaque transaction doit être demandée à l'initiative de l'un d'entre eux et signée par deux d'entres eux avant d'être effectuée. Lors du déploiement du contrat de multi-signatures, le propriétaire du contrat COMM42 cède ses droits de `owner` au contrat. Les demandes de création de nouveaux jetons passeront donc exclusivement par le contrat MultiSig.

Cela permet de sécuriser COMM42 d'une attaque éventuelle et de multiplier la responsabilité de l'action. Les décisions deviennent collectives et favorisent la confiance de la communauté.

### COMM42 2.0 

- Développée une interface numérique accessible et moderne pour faciliter les échanges.
- Prévoir le transfert automatisé de tokens du créateur de l'événement aux contributeurs (à la différence des participants).
- Le fonctionnement et l'animation de l'Association ainsi que le gas seront exclusivement financés par les soutiens financiers de particuliers, entreprises, associations et entités publiques (dons, mécénat, et subventions, etc...)
- Prévoir la mise en séquestre des tokens jusqu'à la confirmation de la participation.
- Prévoir l'automatisation de la vérification d'identité des nouveaux utilisateurs, tout en garantissant une anonymisation parfaite au sein de la blockchain (hash de l'identité sur la base d'un document officiel).
- Gamification de l'expérience : attribution de titres de récompense par la réalisation de succès définis tels que le don de points.