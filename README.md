1.Zameniti svako korišćenje LIMIT 1 sa WHERE ROWNUM=1, jer se LIMIT 1 koristi u MySQL, a ne u Oracle-u.
U SQL upitima gde se kasnije koristi kreirani pogled, umesto korišćenja formata (RELACIJA).(ATRIBUT), pravilno je koristiti samo (ATRIBUT). Na primer, umesto TRENER.ID, koristiti samo ID, ili umesto KLUB.NAZIV, koristiti samo NAZIV.

