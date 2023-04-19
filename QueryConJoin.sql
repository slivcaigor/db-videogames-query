﻿---1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
SELECT DISTINCT players.*
FROM players
JOIN reviews ON players.id = reviews.player_id;

---2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
SELECT DISTINCT videogames.id
FROM videogames
JOIN tournament_videogame ON videogames.id = tournament_videogame.videogame_id
JOIN tournaments ON tournament_videogame.tournament_id = tournaments.id
WHERE tournaments.year = 2016;

---3- Mostrare le categorie di ogni videogioco (1718)
SELECT videogames.*, categories.*
FROM videogames
JOIN category_videogame ON videogames.id = category_videogame.videogame_id
JOIN categories ON category_videogame.category_id = categories.id;

---4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT DISTINCT software_houses.*
FROM software_houses
JOIN videogames ON software_houses.id = videogames.software_house_id
WHERE YEAR(videogames.release_date) > 2020;

--5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
SELECT software_houses.*, awards.*
FROM software_houses
JOIN videogames ON software_houses.id = videogames.software_house_id
JOIN award_videogame ON videogames.id = award_videogame.videogame_id
JOIN awards ON award_videogame.award_id = awards.id;

---6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
SELECT DISTINCT videogames.name, categories.name, pegi_labels.name 
FROM videogames
    JOIN category_videogame
        ON category_videogame.videogame_id  = videogames.id
    JOIN categories
        ON category_videogame.category_id = categories.id
    JOIN pegi_label_videogame
        ON pegi_label_videogame.videogame_id  = videogames.id
    JOIN pegi_labels
        ON pegi_label_videogame.pegi_label_id = pegi_labels.id
    JOIN reviews
        ON reviews.videogame_id = videogames.id
WHERE reviews.rating >= 4

---7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
SELECT DISTINCT v.id, v.name
FROM videogames v
JOIN tournament_videogame tv ON v.id = tv.videogame_id
JOIN tournaments t ON tv.tournament_id = t.id
JOIN player_tournament pt ON t.id = pt.tournament_id
JOIN players p ON pt.player_id = p.id
WHERE p.name LIKE 'S%';

---8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
SELECT DISTINCT t.city
FROM tournaments t
JOIN tournament_videogame tv ON t.id = tv.tournament_id
JOIN videogames v ON tv.videogame_id = v.id
JOIN award_videogame av ON v.id = av.videogame_id
JOIN awards a ON av.award_id = a.id
WHERE a.name LIKE '%Gioco dell''anno%' AND av.year = 2018;

---9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
SELECT players.name 
FROM tournaments
    JOIN tournament_videogame
        ON tournament_videogame.tournament_id  = tournaments.id
    JOIN player_tournament
        ON player_tournament.tournament_id  = tournaments.id
    JOIN players
        ON player_tournament.player_id = players.id
    JOIN videogames
        ON tournament_videogame.videogame_id  = videogames.id
    JOIN award_videogame
        ON award_videogame.videogame_id  = videogames.id
    JOIN awards
        ON award_videogame.award_id = awards.id
WHERE award_videogame.year = 2018 AND awards.name LIKE 'Gioco più atteso' AND tournaments.year  = 2019

---10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)
SELECT software_houses.*, videogames.*
FROM software_houses
    JOIN videogames
        ON videogames.software_house_id = software_houses.id 
WHERE videogames.release_date = (SELECT MIN(videogames.release_date) FROM videogames)

---11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : 398)
SELECT TOP 1 v.id, v.name, COUNT(r.id) as total_reviews
FROM videogames v
JOIN reviews r ON v.id = r.videogame_id
GROUP BY v.id, v.name
ORDER BY total_reviews DESC;

---12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : 1)
SELECT TOP 1 sh.id, sh.name, COUNT(a.id) AS total_awards
FROM software_houses sh
JOIN videogames v ON sh.id = v.software_house_id
JOIN award_videogame av ON v.id = av.videogame_id
JOIN awards a ON av.award_id = a.id
WHERE av.year BETWEEN 2015 AND 2016
GROUP BY sh.id, sh.name
ORDER BY total_awards DESC;

---13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 2 (10)
SELECT DISTINCT c.id AS category_id, c.name AS category_name
FROM videogames v
INNER JOIN reviews r ON v.id = r.videogame_id
INNER JOIN category_videogame cv ON v.id = cv.videogame_id
INNER JOIN categories c ON cv.category_id = c.id
GROUP BY v.id, c.id, c.name
HAVING AVG(r.rating) < 2
