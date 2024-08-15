1.Zameniti svako korišćenje LIMIT 1 sa WHERE ROWNUM=1, jer se LIMIT 1 koristi u MySQL, a ne u Oracle-u.

2.U SQL upitima gde se kasnije koristi kreirani pogled, umesto korišćenja formata (RELACIJA).(ATRIBUT), pravilno je koristiti samo (ATRIBUT). Na primer, umesto TRENER.ID, koristiti samo ID, ili umesto KLUB.NAZIV, koristiti samo NAZIV.

3.Ne mogu garantovati potpunu tačnost rešenja; preporučujem da kodove proverite samostalno.

