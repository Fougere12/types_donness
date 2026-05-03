Le groupe est composé de Yannis GILBERT, Robin SIEVIC et Anaïs PERTOLDI BLANC.C'est un groupe composé essentiellement de DLMI.

Yannis GILBERT s'est chargé de la vérification des types en python. Il a reçut des types et a vérifié leur cohérance avec l'environnement courant (dynamique et statique).
prend le résultat ud parseur -) donne un prog qui est une lsite de statement -) on observe les statement avec tp_stmt un par un. si c'est un block on lance récursivement tp-stmt (vérifie type de statement) sur la liste de statement grace à liste.map. si c'est une assignation on met à jour l'environement global et local. si on a une condition on vérifie quie l'expression de condition est bien typée avec tp_expr puis on lance recursivement tp_stmt sur le then puis le else à la recherche de ligne innateignable ou d'une non comptaibilité des types de retour. Si c'est un while, on vérifie que l'expression est bien un UnionT([BoolT]) puis on lance récursivement tp_stmt sur les statements à l'intérieur du while pour trouver de potentielles erreurs. Si c'est un return on évalue le type de l'expression et on renvoie, on mets à jour l'environnement des fonctions pour le fonction courante (qu'on vérifie). Si c'esrt un CallS, ici on met à jour l'environnement des fonctions avec une nouvelle fonction qui n'a pas de type de retour.  


Robin SIEVIC a eu pour objectif de pouvoir recevoir un code python et de le transcrire en JS. Il a pris les types définis en Lang et pour chaque type, les défini en syntaxe JavaScript. Il a fait des fonctions pour adapter la syntaxe reçue en python à JavaScript (exemple: définition de fonction, if...else..., etc.).

Anaïs PERTOLDI BLANC a eu pour mission de gérer le GitHub et de vérifier le bon fonctionnement de l'ensemble du code.
