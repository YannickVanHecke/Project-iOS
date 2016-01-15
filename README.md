# Project-iOS

Dit project iOS bevat een mobiele applicatie voor een iPhone / iPad waar iOS 9 op geïnstalleerd is. 
De applicatie heeft als doel bezoekers van de Gentse Feesten informatie te geven over welke activiteiten of bezienwaardigen er op welke 
dag plaats vinden. Hierbij wordt gebruikt gemaakt van de informatie die de stad Gent te beschikking stelt op het datatank-platform 
http://datatank.stad.gent/4/toerisme/gentsefeestenevents.json. Hierbij is het de bedoeling dat de gebruiker een overzicht van de data 
voorop er evenementen plaats vinden, met ook meer info over waar en op welk tijdstip deze doorgaan.

Om dit project tot stand te brengen heb ik gebruik gemaakt van Xcode 7 en Swift 2.0 om de code te schrijven en te schermen of storyboards 
te ontwerpen. Uiteraard heb ik hier gebruik gemaakt van de Foundation voor de basiszaken zoals NSString en dergelijke. Ook van UIKit heb
ik gebruik gemaakt voor het ontwerpen van de schermen in mijn app. Ook van JSON en NSDate heb ik gebruik in mijn project om respectievelijk
data van het open-data platform van de stad Gent heeft binnen te halen in de app en om NSDate heb ik gebruikt om in een zelf-geschreven
klasse de datum op te slaan. De zelf-geschreven datum klasse heb ik gemaakt om de datum in unix-formaat afkomstig van het opendata-platform
om te zetten naar een datum in de vorm dd/MM/YYYY HH:MM.

Een andere framework binnen swift dat ik gebruikt om de locatie van het event op de kaart te tonen is MapKit. Dit zit standaard in xcode, maar dient wel geïmporteerd te worden in de klasse voor men het wenst te gebruiken. 
