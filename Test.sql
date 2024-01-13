/* 
#Big data: ensembles de données issus de multiples sources hétérogènes constituant une très grande quantité de données difficilement
            traitable.
3v de big data: Volume, Variété, Vélosité
#NoSQL: not only SQL, bases de donnees non-relationnelles largement distribuees
Avantages: Evolutivité/disponibilité/tolérance aux fautes
Types: Orientée cle valeur/ colonnes/ document/ graphes
*/




/************************************ SHARDING :

Pour faire de la scalabilite horizontale avec MongoDB on utilise le sharding.
 => permet de distribuer les donnees sur plusieurs machines.
Creer un cluster MongoDB (shraded cluster) compose de plusieurs machins sur lesquelles
les donnees bont etre reparties.

##un sharded cluster est compose de :
- serveur de configuration: load balancer/ localisation des donnees/ stocke les metadonnees et les parametres de conf du cluster
- shards (ou noeuds): contient un sous ensemble de donnees/ s'il est sature il suffit d'ajouter dautres shards=> scalabilite horizontale
- routeur (mongos): role d'interface entre l'app cliente eet le sharded cluster/
                    communique avec le serveur de conf pour connaitre la repartition des donnees et choisir le bon shard/
                    permet de router les requetes vers le shard approprié
Avantages de cluster: load balancing/ temps de reponse plus rapides/ ajout de serveurs supplementaires sans interruption du service

*En cas de panne comment assurer la haute disponibilite?
=>Replica set: un groupe dinstances qui maintiennent la meme ensemble de donnees
=>il se compose d'un noeud primaire(master) et noeuds secondaires(slaves)
=>mecanisme de replication pour premunir contre la perte partielle de donnees et assurer la continuite du service
=>rapide/automatique/transparent pour l'utlisateur

*Election:
=>pour qu'un noeud soit elu primaire il doit obtenir une majotite qualifiee
=>replica set peut avoire 50 noeids mais seulement 7 peuvent voter.
=>si 2 serveurs tombnt enpanne, le noeud restant n'aure qu'un seul vote donc ne pourra pas etre elu.
les donnees ne seront plus accessibles
=====>la solution: ajouter un arbitre a notre replica set
Arbitre: un noeud qui ne contient pas de donnees et qui consomme tres peu de ram
il sert uniquement a s'assurer qu'un des noeuds aura la majorite qualifiee lors de l'eleection

chaque shard est un replica set forme de 2 instances et d'un arbitre.

*/



/************************************* Neo4j :
Neo4j est une base de données de graphe de type entreprise.
Caracteristiques:
Stockage grapthe natif
Native graph processing
Requete simple et performante
Scalabilite et gaure disponibilite
Haute integration des donnees

#Sharding:
S'il faut dépasser la capacité d'un cluster, nous pouvons partitionner le graphe surplusieurs
instances de la base via la construction d'une logique de sharding dans l'application

Ce graphe est base sur noeuds et des arcs
Neo4j stock toutes ses donnees dans un repertoire (neo4j/data/graph.db)

Languages : Cypher: inspire du SQL permet d'exprimer une requete complexe de facon elegante et compacte
            Gremlin: base sur groovy(un lnguage pour java) permet d'evoyer des scripts qui seront
                     executes du cote serveur a travers REST de Neo4j.
*/

/********************************* MongoShell : */
/* Demarrage */
> mongod
/* Connection */
> mongo
/* Arreter la base MongoDB */
> shutdown
/* Connection a la base admin */
> use admin
/* arreter le server */
> db.shutdownServer()
/* Afficher la base donnees courante */
> db 
/* Afficher la liste des bases de donnees */
> show dbs
/* Afficher les collections */
> show collections
/* Supprimer une base de donnees */
> db.runCommand({ dropDatabase: 1 })
/* Les commandes CRUD ont le syntaxe suivante */
> db.<collection>.<methode> /* example: db.people.insert({ name: "ons", etude: "master" }) */


/********************************* Types des donnees : */
/* INT / DOUBLE / .. */
{ a: 1 }
/* Boolean */
{ b: true }
/* String */
{ c:'hello' }
/* Array */
{ d: [1,2,3] }
/* Date */
{ e: ISODate( << 2021-12-19 >> )}
/* Object */
{ g: {a:1, b:true} }


/********************************* CRUD : */
/* CREATE */
> db.collection.insert(<document>)
> db.collection.update(<query>, <update>, {upsert: true})
/* READ */
> db.collection.find(<query>, <projection>)
> db.collection.findOne(<query>, <projection>)
/* UPDATE */
>db.collection.update(<query>, <update>, <options>)
/* DELETE */
> db.collection.remove(<query>, <junstOne>)


/********************************* INSERTION : */
> db.people.insert({nom:"ons", age:22, profession:"ingenieur"})
/* pour preciser le type d'un champ: age:NumberInt(22) */


/********************************* FIND() : */
/* B find() najmou nwariw les champs li n7bouhm yt affichew 
    just n7otou true or false wala 1 or 0 */
> db.poeple.find({nom:"ons"}, {nom:true, age:true, _id:false})
> db.poeple.find({nom:"ons"}, {nom:1, age:1, _id:0})
/* Bech naffichiw les documents lkol (la3bed lkol)
    n7otou l {} loula fergha
    ba3d n7otou chnouma les champs li n7ebou nwariyouhm
    w chnouwa le */
> db.poeple.find({}, {nom:true, age:true, _id:false})
> db.poeple.find({}, {nom:1, age:1, _id:0})
/* Pour un beau affichage, il suffit d'ajouter la fonction pretty() */
> db.people.find().pretty()

/********************************* FINDONE() : */
/* findOne() kima find() ama ta3tik resultat we7d bark quelconque */
> db.people.findOne()
==> /* resultat : */
{
    "_id": ObjectId("56314654ze6f4f46z54efz684684fze"),
    "nom": "ons",
    "age": 22,
    "profession": "ingenieur"
}
> db.people.find()
==> /* resultat : */
{"_id": ObjectId("56314654ze6f4f46z54efz684684fze"),"nom": "ons","age": 22,"profession": "ingenieur"}
{"_id": ObjectId("96768zefz4ef6z4ze68f4z6e8f4z6e4"),"nom": "arij","age": 20,"profession": "ingenieur"}


/********************************* UTILISATION D'OPERATEURS : */
$gt => Greater than >
$gte => Greater than or Equal >=
$lt => Lower than <
$lte => Lower than or Equal <=
/* examples : */
score: {$gt:95, $lte:98}
> db.people.find() /* Select * from people */
> db.people.find({age: {"$lte": 32,"$gte": 35}})
> db.people.find({"age" : 27}) /* Select * from people where age=27 */
> db.people.find({}, {"nom" : 1, "age" : 1}) /* Select nom,age from people */
> db.people.find({}, {"nom" : 0}) /* Select age,profession from people */
> db.people.find({"age" : {"$gte" : 18, "$lte" : 30}})  /* Select * from people where age between 18 and 30 */
> db.raffle.find({"ticket_no" : {"$in" : [725, 542,390]}}) /* Select * from raffle where ticket_no in (725,542,390) */

$exists => profession: {$exists: true}
$type => name: {$type: 2} /* de type string */
$regex => name: {$regex: "e$"}
$or => [{name:{$regex: "$e"}, age:{$exists: true}}]
$and => [{name:{$regex: "$e"}, age:{$exists: true}}]
/* examples */
/* Afficher les documents qui contiennent le champ age */
> db.people.find({age:{$exists:true}})
/* Afficher les document dont le type du champ nom est String */
> db.people.find({nom:{$type:2}})
/* Nom qui contient la lettre i : */
> db.people.find({nom:{$regex:"i"}})
/* Nom qui se termine par h : */
> db.people.find({nom:{$regex:"h$"}})
/* Nom qui commence par s : */
> db.people.find({nom:{$regex:"^s"}})
/* Afficher les documents représentant des personnes dont le nom se termine par e et dont le champ age existe */
> db.people.find({$and:[{name:{$regex:"e$"}},{age:{$exists:true}}]})
/* Afficher les documents représentant des personnes dont le nom se termine par e ou dont le champ age existe */
> db.people.find({$or:[{name:{$regex:"e$"}},{age:{$exists:true}}]})
/* Afficher les utilisateurs dont le nom est Smith ou Bob */
> db.users.find( { nom : { $in : [ "smith" , "Bob" ] }})
/* Afficher les utilisateurs dont leurs préférences sont running et pickles */
> db.users.find({favorites:{$all:["running","pickles"] }})

limit() => recuperer les n premiers resultats
> db.people.find().limit(1)

sort() => pour trier les resultats
> db.people.find().sort({nom:1})
> db.people.find().sort({nom:-1})

count() => retourne le nombre de documents
> db.people.find().count()
====> 2


/********************************* LECTURE D'UN SOUS DOCUMENTS : */
> db.article.insert(
    {
        "titre" : "azerty",
        "auteur": {
            "prenom": "khiari",
            "nom": "ons"
        }
    }
)
====> db.article.find({"auteur.nom":"ons"})


/********************************* MISE A JOURS DES DOCUMENTS : */
$inc => incrementer les valeurs des champs entiers
> db.people.update({nom: "ons"}, {$inc: {age: 1}})
{ ... "age": 23}

$unset => supprimer un champ d un document
> db.people.update({nom: "ons"}, {$unset: {salaire: 1}})
{ "nom": "ons", "prenom": "khiari", "age": 23 }

$multi => mettre a jour plusierus documents
> db.people.update({nom: "jean"}, {$set: {salaire: 5000}}, {$multi: true})
=====> lkolhom bch ywaliw esmhom jean w 3andhm salaire 5000


/********************************* MISE A JOURS DUN CHAMP DE TYP TABLEAU : */
$set activite.1 => modifier la deuxieme valeur du tableau
$push => ajouter valeur au tableau
$pop => retirer valeur du tableau if 1 la derniere valeur , if -1 la premiere valeur
$pull => specifier lelement a retirer

> db.people.insert({nom: "smith", age: 34, activite: ["sport", "musique"]}) /* ["sport", "musique"] */
> db.people.update({nom: "smith"}, {$set: {"activite.1":"camping"}}) /* ["sport", "camping"] */
> db.people.update({nom: "smith"}, {$push: {"activite": "musique"}}) /* ["sport", "camping", "musique"] */
> db.people.update({nom: "smith"}, {$pop: {"activite": 1}}) /* ["sport", "camping"] */
> db.people.update({nom: "smith"}, {$pull: {"activite": "camping"}}) /* ["sport", "musique"] */


/********************************* SUPPRESSION : */
/* Suppression de documents */
> db.people.remove({nom: "jean"})
/* Suppression de collections */
> db.article.drop()


/********************************* IMPORT : */
"mongoexport" et "mongoimport" sont deux commandes utilisées pour
limport et lexport de données à partir de fichiers JSON ou CSV.
/* Exemple */
" mongoimport --db mabase --collection personnes --type json --file "c:\notes.json " "
--db : nom de la base de données cible
--collection : nom de la collection cible
--type : type du fichier source à importer
--file : adresse du fichier source à importer


/********************************* EXPORT : */
" mongoexport --db test --collection people --out people.json "
--db : nom de la base de données source
--collection : nom de la collection à exporter
--out : fichier de sortie


/********************************* SAUVEGARDE : */
"mongodump" : permet de sauvegarder une partie ou la totalité de la base dans un
dossier dump.
mongodump --help : visualiser les options de mongodump
--db DBNAME sauvegarde de la base DBNAME
--collection COLLECTIONNAME sauvegarde la collection COLLECTIONNAME
/* Example */
" mongodump --db test --out backup "
sauvegarder la base test dans le répertoire backup


/********************************* RECUPERATION : */
"mongorestore" : récupère les données à partir dun fichier BSON
--db et --collection permettent de récupérer une base et une collection spécifique.
/* Exemple */
" mongorestore --db test --collection people backup/test/people.bson "
récupérer la collection people dans la base test à partir du fichier people.bson



/********************************* AGGREGATION : */
/* Mathalan 3ana tableau ta3 oders n7bou ntal3ou kol customer
    9adech spenda money */
/* Ken n7bou na3rfou 9adech men money spend 3ala each
    product we have to replace l $customer b $product */
> db.purchase_orders.aggregate(
    [
        {$match: {} },
        {$group: {_id: "$customer", total: {$sum: "$total"}}}
    ]
)
======> {"_id"; "mike", "total": 10.25}
        {"_id"; "karen", "total": 19.25}
        {"_id"; "dave", "total": 99.25}
/* Ken n7bou we do sorting b desc we have to add $sort -1
    wel Asc 1 */
> db.purchase_orders.aggregate(
    [
        {$match: {} },
        {$group: {_id: "$customer", total: {$sum: "$total"}}},
        {$sort: {total: -1}}
    ]
)
/* Ken n7bou just nchoufou mike w karen kahaw 9adeh they
    spend money we have to change el $match */
> db.purchase_orders.aggregate(
    [
        {$match: {customer: {$in ["mike", "karen"]}} },
        {$group: {_id: "$customer", total: {$sum: "$total"}}},
        {$sort: {total: -1}}
    ]
)
/* How To do the count : */
> db.purchase_orders.aggregate(
    [
        {$match: {} },
        {$group: {_id: "$customer"}},
        {$count: "customersCount"}
    ]
)
======>3


/********************************* INDEXATION : */
/* Creation d'un index : */
> db.students.createIndex({ "student_id": 1})
/* Creation d'un index sur plusieurs champs : */
> db.students.createIndex({"student_id" : 1,"type":1, "score":1},{name:"ind2"})
/* Affichage des index d'une collection : */
> db.students.getIndexes()
/* Information sur l index cree : */
> db.students.find({student_id: 50}).explain("executionStats")
/* Creation d'un unique index ensuring that each student_id is unique in the collection */
> db.students.createIndex({"student_id":1},{unique:true})

/* Suppression d'un index : */
> db.students.dropIndex("student_id": 1)
/* Suppression de tous les indexes : */
> db.students.dropIndexes()

/* Sparse permet d’indexer uniquement les documents contenant des valeurs non nulles d’un champ */
> db.scores.createIndex( { score: 1 } , { sparse: true } )

/* partialFilterExpression Defines a partial filter expression for the index : */
> db.students.createIndex({ score: 1 },{ partialFilterExpression: { score: { $gt: 50 } } })

/* hint force l’utilisation d’un index spécifique pour répondre à la requête : */
> db.students.find().hint({"student_id" : 1}).explain("executionStats")

