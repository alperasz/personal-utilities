AA = 4
BA = 3.5
BB = 3
CB = 2.5
CC = 2
DC = 1.5
DD = 1
FD = 0.5
FF = 0

onay = input("Gecen doneme ait notlarinizla baslamak istiyorsaniz e istemiyorsaniz h yazin: ")
if(onay == "e"):
    gecen_donem_agno = float(input("Gecen doneme ait AGNO: "))
    gecen_donem_kredi = int(input("Gecen doneme ait toplam kredi: "))
    top_kredi = gecen_donem_kredi
    top_not = gecen_donem_agno * gecen_donem_kredi
else:
    top_kredi = 0
    top_not = 0

ders_sayisi = int(input("Eklenecek Ders Sayisi: "))

for i in range(0, ders_sayisi):
    kredi_i = int(input("Dersin kredisi: "))
    harf_i = input("Dersin notu: ")
    if harf_i == "AA":
        not_i = AA
    elif harf_i == "BA":
        not_i = BA
    elif harf_i == "BB":
        not_i = BB
    elif harf_i == "CB":
        not_i = CB
    elif harf_i == "CC":
        not_i = CC
    elif harf_i == "DC":
        not_i = DC
    elif harf_i == "DD":
        not_i = DD
    elif harf_i == "FD":
        not_i = FD
    elif harf_i == "FF":
        not_i = FF
    print("\n")

for i in range(0, ders_sayisi):
    top_kredi = top_kredi + kredi_i
    top_not = top_not + not_i*kredi_i

yukseltme_onay = input("Yukseltme ya da alttan alacaginiz bi ders var mi? (e/h): ")
if(yukseltme_onay == "e"):
    for i in range(0, int(input("Kac dersten yukseltme alacaksiniz?: "))):
        kredi_yukseltme_i = int(input("Yukseltme dersinin kredisi: "))
        harf_onceki_i = input("Onceki notunuz: ")
        if harf_onceki_i == "AA":
            not_onceki_i = AA
        elif harf_onceki_i == "BA":
            not_onceki_i = BA
        elif harf_onceki_i == "BB":
            not_onceki_i = BB
        elif harf_onceki_i == "CB":
            not_onceki_i = CB
        elif harf_onceki_i == "CC":
            not_onceki_i = CC
        elif harf_onceki_i == "DC":
            not_onceki_i = DC
        elif harf_onceki_i == "DD":
            not_onceki_i = DD
        elif harf_onceki_i == "FD":
            not_onceki_i = FD
        elif harf_onceki_i == "FF":
            not_onceki_i = FF
        harf_yukseltme_i = input("Yukseltme dersinin alinacak notu: ")
        if harf_yukseltme_i == "AA":
            not_yukseltme_i = AA
        elif harf_yukseltme_i == "BA":
            not_yukseltme_i = BA
        elif harf_yukseltme_i == "BB":
            not_yukseltme_i = BB
        elif harf_yukseltme_i == "CB":
            not_yukseltme_i = CB
        elif harf_yukseltme_i == "CC":
            not_yukseltme_i = CC
        elif harf_yukseltme_i == "DC":
            not_yukseltme_i = DC
        elif harf_yukseltme_i == "DD":
            not_yukseltme_i = DD
        elif harf_yukseltme_i == "FD":
            not_yukseltme_i = FD
        elif harf_yukseltme_i == "FF":
            not_yukseltme_i = FF
        
        top_not = top_not - not_onceki_i*kredi_yukseltme_i + not_yukseltme_i*kredi_yukseltme_i
        print("\n")
        
agno = top_not / top_kredi
print("AGNO: ", agno)

