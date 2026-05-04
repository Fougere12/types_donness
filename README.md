Le groupe est composé de Yannis GILBERT, Robin SIEVIC et Anaïs PERTOLDI BLANC.C'est un groupe composé essentiellement de DLMI.

Yannis GILBERT s'est chargé de la vérification des types en python. Il a récupéré le résultat du parseur qui est une liste statements. il a observé chaque statement un par un à l'aide de tp_stmt (qui vérifie le type du statement). Si il a un block, il lance récursivement tp_stmt sur la liste de statement contenus dans le block grace à List.map. Si il a une assignation il met à jour l'environnement local et global. Si il a une condition il vérifie que l'expression de condition soit bien typée avec tp_expr puis lance récursivement tp_stmt sur le block à l'intérieur du 'if' et sur celui à l'intérieur du 'else' à la recherche d'une ligne innateignable ou d'une non compatibilité des types retour.
Si c'est un while, on vérifie que l'expression est bien un UnionT([BoolT]) puis on lance récursivement tp_stmt sur les statements à l'intérieur du while pour trouver de potentielles erreurs. Si c'est un return on évalue le type de l'expression et on renvoie, on mets à jour l'environnement des fonctions pour le fonction courante (qu'on vérifie). Si c'esrt un CallS, ici on met à jour l'environnement des fonctions avec une nouvelle fonction qui n'a pas de type de retour.  


Robin SIEVIC a eu pour objectif de pouvoir recevoir un code python et de le transcrire en JS. Il a pris les types définis en Lang et pour chaque type, les défini en syntaxe JavaScript. Il a fait des fonctions pour adapter la syntaxe reçue en python à JavaScript (exemple: définition de fonction, if...else..., etc.).

Anaïs PERTOLDI BLANC a eu pour mission de gérer le GitHub et de vérifier le bon fonctionnement de l'ensemble du code.
