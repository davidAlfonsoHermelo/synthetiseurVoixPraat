
clearinfo

########variables
son = Read from file: "042_10mots2016_01_16.mp3"
segmentation = Read from file: "042_10mots2016_01_16.TextGrid"
fichierVierge=Create Sound from formula: "sineWithNoise", 1, 0.1, 1, 44100, "0"

########fenêtre de dialogue
form Synthèse vocale
    	comment Mot à chercher:
    	word motAChchrDico
	comment Mots à chercher conseillés:
	comment soda; olé ;durée
	comment Mots d'origine:
	comment verdure; cresson; rivière; lumière; haïllon; argent; soleil; souriant; rayon; soldat
endform

writeInfoLine: "motAChchrDico : ", motAChchrDico$

########préparation de l'input
dico=Read Table from tab-separated file: "028dico.txt"

select 'dico'
Extract rows where column (text): "orthographe", "is equal to", motAChchrDico$
motDico$ = Get value: 1, "phonetique"

motDico$ = "_" + motDico$ + "_"
print 'motDico$'


longMotRecherche = length (motDico$)

select 'fichierVierge'

########synthétiseur
for phon from 1 to longMotRecherche -1
	diphonesMot$ = mid$(motDico$, phon, 2)
	
	select 'segmentation'
	nombreIntervales = Get number of intervals: 1

	for i from 1 to nombreIntervales -1
		select 'segmentation'
		etiquette$ = Get label of interval: 1, i
		etiquetteSuivante$ = Get label of interval: 1, i+1
		i2 = i+1
		diphone$ = etiquette$+etiquetteSuivante$
		#printline 'diphone$'
		if diphone$ == diphonesMot$
			

			debutEtiquette = Get starting point: 1, i
			finEtiquette = Get end point: 1, i
			finEtiquetteSuivante = Get end point: 1, i2
		
			milieuEtiquette1 = (debutEtiquette+finEtiquette)/2
			milieuEtiquette2 = (finEtiquette+finEtiquetteSuivante)/2

			select 'son'
			zero = To PointProcess (zeroes): 1, "yes", "no"

			select 'zero'
				indexZero12 = Get nearest index: milieuEtiquette1
				indexZero13 = Get time from index: indexZero12
				indexZero22 = Get nearest index: milieuEtiquette2
				indexZero23 = Get time from index: indexZero22

			select 'son'
			Extract part: indexZero13, indexZero23, "rectangular", 1, "no"

			plus 'fichierVierge'

			fichierVierge = Concatenate

		
		endif
	endfor
endfor

########changement de l'intonation (prosodie)
select 'fichierVierge'

manipulation = To Manipulation: 0.01, 75, 600
efzero = Extract pitch tier

Remove points between: 0, 2
Add point: 0.5, 200

select 'manipulation'
plus 'efzero'
Replace pitch tier

select 'manipulation'
synthese = Get resynthesis (overlap-add)

########changement de la durée
select Manipulation chain
Extract duration tier
Remove points between: 0, 1
Add point: 0.5, 1.5

select Manipulation chain
plus DurationTier chain
Replace duration tier
select Manipulation chain
synthese = Get resynthesis (LPC)

########ouvrir le fichier

select Sound chain
Edit








