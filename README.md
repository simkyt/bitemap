Sprendžiamo uždavinio aprašymas
Projekto tikslas – suteikti galimybę bet kam labiau prižiūrėti savo mitybą ir sveikatą, teikiant mobiliąją aplikaciją, kurioje galima suvesti ir sekti savo suvalgomą maistą, taip skaičiuojant kalorijų, angliavandenių ir kitu maistinių medžiagų kiekius.
Veikimo principas – kuriama sistema bus sudaryta iš dviejų dalių: 
•	mobili aplikacija, kuria gali naudotis bet koks asmuo ir administratorius.
•	aplikacijų programavimo sąsaja (angl. API).

Asmuo, norintis naudotis šia aplikacija, ją parsisiųs ir galės suvesti maisto informaciją (kalorijų, angliavandenių ir kitų maistinių medžiagų kiekis per 100 gramų, ir t.t), sukurtą maistą priskirti tam tikros dienos pusryčiams, pietums ir/ar vakarienei ir matyti kiekvienos dienos bei jos atskirų valgymų (pusryčių ir t.t) suvartotas kalorijas ir maistines medžiagas. Neprisiregistravę naudotojai galės dirbti tik su savo lokaliais duomenimis, o prisiregistravę ir prisijungę naudotojai turės galimybę surasti ir maistą iš kitų naudotojų jau sukurtų maistų. Prisiregistravusių naudotojų sukurti maistai bus automatiškai kaupiami duomenų bazėje. Administratorius turės tokias papildomas prieigas, kaip maisto šalinimas ir redagavimas duomenų bazėje.



Funkciniai reikalavimai
Neregistruotas sistemos naudotojas galės:
1.	Sukurti, peržiūrėti, redaguoti ir pašalinti savo maistą;

2.	Priskirti maistą kiekvienos dienos pusryčiams, pietums ir vakarienei:
	2.1. Priskirti ir matyti galės tik lokaliai sukurtą maistą;

3.	Peržiūrėti, redaguoti ir šalinti priskirtą maistą pusryčiams, pietums ir vakarienei;

4.	Matyti suvartotus kalorijų ir maistinių medžiagų kiekius bet kurią pasirinktą dieną;

5.	Prisijungti (užsiregistruoti) mobilioje aplikacijoje.
 

Registruotas sistemos naudotojas galės:
1.	Atsijungti nuo mobilios aplikacijos;

2.	Prisijungti prie aplikacijos;

3.	Sukurti, peržiūrėti, redaguoti ir pašalinti savo maistą;
3.1.	Sukurtas maistas automatiškai bus kaupiamas duomenų bazėje.

4.	Priskirti maistą kiekvienos dienos pusryčiams, pietums ir vakarienei:
	4.1. Priskirti ir matyti galės ir lokaliai sukurtą maistą, ir duomenų bazėje esantį maistą;
4.2. Priskiriant maistą galės peržvelgti informaciją apie kitų naudotojų sukurtą maistą;

5.	Peržiūrėti, redaguoti ir šalinti priskirtą maistą pusryčiams, pietums ir vakarienei;

6.	Matyti suvartotus kalorijų ir maistinių medžiagų kiekius bet kurią pasirinktą dieną;

Administratorius galės:
1.	Peržvelgti visus duomenų bazėje esančius sukurtus maistus.

2.	Redaguoti ir šalinti duomenų bazėje esančius sukurtus maistus.

3.	Šalinti naudotojus.



Sistemos architektūra
Sistemos sudedamosios dalys:

•	Kliento pusė (angl. front-end) – realizuojama naudojant Swift programavimo kalbą ir SwiftUI karkasą;
•	Serverio pusė (angl. back-end) – realizuojama naudojant Python programavimo kalbą. Duomenų bazė – PostgreSQL.

Sistema talpinama DigitalOcean serveryje (2.1 pav.). Serverio pusės dalys yra diegiamios tame pačiame viename serveryje. Šios sistemos veikimui (darbui su duomenų baze ir kitiems veiksmams) yra reikalingas API. Mobili aplikacija su API susisiekia per HTTP protokolą. Pats API vykdo duomenų mainus su duomenų baze ORM sąsaja per TCP/IP protokolą.

