--1. Liste des potions : Numéro, libellé, formule et constituant principal. (5 lignes)
SELECT * FROM potion;
--2. Liste des noms des trophées rapportant 3 points. (2 lignes)
SELECT nom_categ FROM categorie WHERE nb_points = 3;
--3. Liste des villages (noms) contenant plus de 35 huttes. (4 lignes)
SELECT nom_village FROM village WHERE nb_huttes > 35;
--4. Liste des trophées (numéros) pris en mai / juin 52. (4 lignes)
SELECT num_trophee FROM trophee WHERE date_prise BETWEEN '2052-05-01' AND '2052-06-30';
--5. Noms des habitants commençant par 'a' et contenant la lettre 'r'. (3 lignes)
SELECT nom FROM habitant WHERE (nom LIKE 'A%') and (nom LIKE '%r%');
--6. Numéros des habitants ayant bu les potions numéros 1, 3 ou 4. (8 lignes)
SELECT DISTINCT num_hab FROM absorber WHERE num_potion = 1 OR num_potion = 3 OR num_potion  =  4;
--7. Liste des trophées : numéro, date de prise, nom de la catégorie et nom du preneur. (10lignes)
SELECT num_trophee, date_prise, code_cat, nom 
FROM trophee 
INNER JOIN habitant ON num_preneur = num_hab;
--8. Nom des habitants qui habitent à Aquilona. (7 lignes)
SELECT nom 
FROM habitant 
INNER JOIN village ON habitant.num_village = village.num_village AND nom_village = 'Aquilona';
--9. Nom des habitants ayant pris des trophées de catégorie Bouclier de Légat. (2 lignes)
SELECT nom 
FROM habitant 
INNER JOIN trophee  ON num_hab = num_preneur 
INNER JOIN categorie ON trophee.code_cat = categorie.code_cat AND categorie.nom_categ = 'Bouclier de Légat';
--10. Liste des potions (libellés) fabriquées par Panoramix : libellé, formule et constituantprincipal. (3 lignes) 
SELECT lib_potion, formule, constituant_principal 
FROM potion 
INNER JOIN fabriquer ON fabriquer.num_potion = potion.num_potion 
INNER JOIN habitant ON fabriquer.num_hab = habitant.num_hab AND nom = 'Panoramix';
--11. Liste des potions (libellés) absorbées par Homéopatix. (2 lignes)
SELECT DISTINCT lib_potion 
FROM potion 
INNER JOIN absorber ON absorber.num_potion = potion.num_potion 
INNER JOIN habitant ON absorber.num_hab = habitant.num_hab AND nom = 'Homéopatix';
--12. Liste des habitants (noms) ayant absorbé une potion fabriquée par l'habitant numéro 3. (4 lignes)
SELECT DISTINCT nom 
FROM habitant 
INNER JOIN absorber ON habitant.num_hab = absorber.num_hab 
INNER JOIN fabriquer ON absorber.num_potion = fabriquer.num_potion AND fabriquer.num_hab  = 3;
--13. Liste des habitants (noms) ayant absorbé une potion fabriquée par Amnésix. (7 lignes)
SELECT DISTINCT h.nom 
FROM habitant h 
INNER JOIN absorber ON h.num_hab = absorber.num_hab 
INNER JOIN fabriquer ON absorber.num_potion = fabriquer.num_potion 
INNER JOIN habitant h2 ON fabriquer.num_hab = h2.num_hab AND h2.nom ='Amnésix';
--14. Nom des habitants dont la qualité n'est pas renseignée. (2 lignes)
SELECT nom 
FROM habitant 
LEFT JOIN qualite ON habitant.num_qualite = qualite.num_qualite 
WHERE qualite.num_qualite IS NULL;
--15. Nom des habitants ayant consommé la Potion magique n°1 (c'est le libellé de lapotion) en février 52. (3 lignes)
SELECT nom 
FROM habitant 
INNER JOIN absorber ON habitant.num_hab = absorber.num_hab 
INNER JOIN potion ON absorber.num_potion = potion.num_potion 
WHERE potion.lib_potion ='Potion magique n°1' AND absorber.date_a BETWEEN '2052-02-01' AND '2052-02-29';
--16. Nom et âge des habitants par ordre alphabétique. (22 lignes)
SELECT nom, age FROM habitant ORDER BY nom;
--17. Liste des resserres classées de la plus grande à la plus petite : nom de resserre et nom du village. (3 lignes)
SELECT nom_resserre, nom_village 
FROM resserre 
INNER JOIN village ON resserre.num_village = village.num_village ORDER BY resserre.superficie DESC ;
--***

--18. Nombre d'habitants du village numéro 5. (4)
SELECT count(nom) AS villageois
FROM habitant 
WHERE num_village = 5;
--19. Nombre de points gagnés par Goudurix. (5)
SELECT sum(nb_points) AS somme_points
FROM categorie 
INNER JOIN trophee ON categorie.code_cat  = trophee.code_cat 
INNER JOIN habitant ON trophee.num_preneur = habitant.num_hab AND habitant.nom = 'Goudurix';
--20. Date de première prise de trophée. (03/04/52)
SELECT DISTINCT min(date_prise) AS premiere_prise FROM trophee;
--21. Nombre de louches de Potion magique n°2 (c'est le libellé de la potion) absorbées. (19)
SELECT sum(quantite) AS louches_avalees
FROM absorber 
INNER JOIN potion ON absorber.num_potion = potion.num_potion AND potion.lib_potion ='Potion magique n°2';
--22. Superficie la plus grande. (895)
SELECT max(superficie) FROM resserre;
--***

--23. Nombre d'habitants par village (nom du village, nombre). (7 lignes)
SELECT nom_village, count(habitant.nom) AS nbr_habitants 
FROM village 
INNER JOIN habitant ON village.num_village = habitant.num_village GROUP BY village.nom_village; 
--24. Nombre de trophées par habitant (6 lignes)
SELECT nom, count(trophee.num_preneur) AS nbr_trophees
FROM habitant 
INNER JOIN trophee ON habitant.num_hab  = trophee.num_preneur GROUP BY habitant.nom  ;
--25. Moyenne d'âge des habitants par province (nom de province, calcul). (3 lignes)
SELECT nom_province, avg(habitant.age) AS moyenne_age
FROM province 
INNER JOIN village ON province.num_province = village.num_province 
INNER JOIN habitant ON village.num_village = habitant.num_village  GROUP BY province.nom_province ;
--26. Nombre de potions différentes absorbées par chaque habitant (nom et nombre). (9lignes)
SELECT nom, count(distinct absorber.num_potion) AS types_potions_absorbees 
FROM habitant 
INNER JOIN absorber ON habitant.num_hab = absorber.num_hab GROUP BY habitant.nom;

--27. Nom des habitants ayant bu plus de 2 louches de potion zen. (1 ligne)
SELECT nom, sum(absorber.quantite) AS louches_avalees
FROM habitant 
INNER JOIN absorber ON habitant.num_hab = absorber.num_hab 
INNER JOIN potion ON absorber.num_potion = potion.num_potion 
WHERE potion.lib_potion ='Potion Zen' GROUP BY habitant.num_hab HAVING sum(absorber.quantite) > 2 ;

--***
--28. Noms des villages dans lesquels on trouve une resserre (3 lignes)
SELECT nom_village 
FROM village 
INNER JOIN resserre ON village.num_village = resserre.num_village; 
--29. Nom du village contenant le plus grand nombre de huttes. (Gergovie)
SELECT nom_village 
FROM village 
WHERE nb_huttes = (SELECT max(nb_huttes) FROM village); 
--30. Noms des habitants ayant pris plus de trophées qu'Obélix (3 lignes).
SELECT nom 
FROM habitant 
INNER JOIN trophee ON habitant.num_hab = trophee.num_preneur GROUP BY habitant.nom HAVING count(trophee.num_trophee) > (SELECT count(trophee.num_trophee) FROM trophee INNER JOIN habitant ON trophee.num_preneur = habitant.num_hab WHERE habitant.nom = 'Obélix');
