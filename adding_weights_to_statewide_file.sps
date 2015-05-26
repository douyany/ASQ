/* this SPSS do-file */
/* add weights to the statewide file */
/* of initial and followup screenings */

/* counties 9, 21, and 44 have observations in the data */
/* but do not have both first and follow-up data */

compute InflatedSEWgt=$sysmis.
if (CountyID=1) InflatedSEWgt=6.65056617343331.
if (CountyID=2) InflatedSEWgt=16.5555458121351.
if (CountyID=3) InflatedSEWgt=3.20262391631631.
if (CountyID=4) InflatedSEWgt=2.48543198234429.
if (CountyID=5) InflatedSEWgt=0.33023884050696.
if (CountyID=6) InflatedSEWgt=2.49847812347835.
if (CountyID=7) InflatedSEWgt=0.
if (CountyID=11) InflatedSEWgt=0.12512776712523.
if (CountyID=12) InflatedSEWgt=0.
if (CountyID=13) InflatedSEWgt=12.3621891086952.
if (CountyID=14) InflatedSEWgt=0.693076337048412.
if (CountyID=15) InflatedSEWgt=6.15994487547754.
if (CountyID=16) InflatedSEWgt=0.0609057377242535.
if (CountyID=18) InflatedSEWgt=0.561642153363474.
if (CountyID=19) InflatedSEWgt=11.2786938494795.
if (CountyID=23) InflatedSEWgt=7.63738949041071.
if (CountyID=24) InflatedSEWgt=0.321798194433585.
if (CountyID=27) InflatedSEWgt=0.0718448636126042.
if (CountyID=28) InflatedSEWgt=2.53097202647983.
if (CountyID=29) InflatedSEWgt=0.149385030425819.
if (CountyID=31) InflatedSEWgt=0.112970868747458.
if (CountyID=34) InflatedSEWgt=0.
if (CountyID=35) InflatedSEWgt=2.48177691387911.
if (CountyID=36) InflatedSEWgt=16.0870597584498.
if (CountyID=38) InflatedSEWgt=30.1725691764072.
if (CountyID=39) InflatedSEWgt=9.70960313944617.
if (CountyID=40) InflatedSEWgt=0.432118983477113.
if (CountyID=41) InflatedSEWgt=23.2677417036701.
if (CountyID=42) InflatedSEWgt=0.38857874286383.
if (CountyID=43) InflatedSEWgt=0.208318613249089.
if (CountyID=45) InflatedSEWgt=0.352582622077045.
if (CountyID=46) InflatedSEWgt=1.57973403572949.
if (CountyID=48) InflatedSEWgt=56.409391320593.
if (CountyID=49) InflatedSEWgt=0.0778170041956085.
if (CountyID=50) InflatedSEWgt=0.152027407784159.
if (CountyID=51) InflatedSEWgt=6.87417594163082.
if (CountyID=53) InflatedSEWgt=3.49824708185244.
if (CountyID=54) InflatedSEWgt=0.900483719339498.
if (CountyID=55) InflatedSEWgt=0.412264010878222.
if (CountyID=56) InflatedSEWgt=0.266257433755806.
if (CountyID=57) InflatedSEWgt=0.070261157781398.
if (CountyID=58) InflatedSEWgt=0.219399124545557.
if (CountyID=59) InflatedSEWgt=0.0311687111615313.
if (CountyID=60) InflatedSEWgt=14.5904595697074.
if (CountyID=61) InflatedSEWgt=0.
if (CountyID=62) InflatedSEWgt=0.622107037435303.
if (CountyID=63) InflatedSEWgt=6.30992610892023.
if (CountyID=64) InflatedSEWgt=0.146124526502002.
if (CountyID=65) InflatedSEWgt=0.580578078313635.
if (CountyID=66) InflatedSEWgt=0.238827123212761.
if (CountyID=67) InflatedSEWgt=1.53369514033815.

frequencies variables=InflatedSEWgt.

compute InflatedCommWgt=$sysmis.
if (CountyID=1) InflatedCommWgt=6.34581868702208.
if (CountyID=2) InflatedCommWgt=9.82919749141473.
if (CountyID=3) InflatedCommWgt=2.7163295629507.
if (CountyID=4) InflatedCommWgt=0.934244038224523.
if (CountyID=5) InflatedCommWgt=0.226230218667834.
if (CountyID=6) InflatedCommWgt=1.46707131639358.
if (CountyID=7) InflatedCommWgt=8.39476963084076.
if (CountyID=11) InflatedCommWgt=0.0762485455011431.
if (CountyID=12) InflatedCommWgt=0.506775222621717.
if (CountyID=13) InflatedCommWgt=2.62127091848485.
if (CountyID=14) InflatedCommWgt=0.356901587119061.
if (CountyID=15) InflatedCommWgt=3.35867372856007.
if (CountyID=16) InflatedCommWgt=0.0335225237501177.
if (CountyID=18) InflatedCommWgt=0.238180508365037.
if (CountyID=19) InflatedCommWgt=2.39152725509914.
if (CountyID=23) InflatedCommWgt=4.09118484658045.
if (CountyID=24) InflatedCommWgt=0.204701669244741.
if (CountyID=27) InflatedCommWgt=0.0457018210871164.
if (CountyID=28) InflatedCommWgt=0.751332036279992.
if (CountyID=29) InflatedCommWgt=0.0604714268194083.
if (CountyID=31) InflatedCommWgt=0.0628799666454631.
if (CountyID=34) InflatedCommWgt=0.505731267351722.
if (CountyID=35) InflatedCommWgt=1.1668676691035.
if (CountyID=36) InflatedCommWgt=9.09624048793365.
if (CountyID=38) InflatedCommWgt=19.1933186159865.
if (CountyID=39) InflatedCommWgt=4.11763646643417.
if (CountyID=40) InflatedCommWgt=0.272901179712633.
if (CountyID=41) InflatedCommWgt=7.40051629978886.
if (CountyID=42) InflatedCommWgt=0.258952558409004.
if (CountyID=43) InflatedCommWgt=0.109890694302272.
if (CountyID=45) InflatedCommWgt=0.196820830441832.
if (CountyID=46) InflatedCommWgt=0.95154008997974.
if (CountyID=48) InflatedCommWgt=5.12614816372721.
if (CountyID=49) InflatedCommWgt=0.0427100834825716.
if (CountyID=50) InflatedCommWgt=0.0757347046035919.
if (CountyID=51) InflatedCommWgt=0.650009030211128.
if (CountyID=53) InflatedCommWgt=2.2252984307329.
if (CountyID=54) InflatedCommWgt=0.41913221679186.
if (CountyID=55) InflatedCommWgt=0.262248616232436.
if (CountyID=56) InflatedCommWgt=0.143534901532575.
if (CountyID=57) InflatedCommWgt=0.048132427622201.
if (CountyID=58) InflatedCommWgt=0.0881455346903023.
if (CountyID=59) InflatedCommWgt=0.0180554996220276.
if (CountyID=60) InflatedCommWgt=15.4687600315473.
if (CountyID=61) InflatedCommWgt=6.88154653401091.
if (CountyID=62) InflatedCommWgt=0.0688232299484715.
if (CountyID=63) InflatedCommWgt=3.01039385005046.
if (CountyID=64) InflatedCommWgt=0.17308389506415.
if (CountyID=65) InflatedCommWgt=0.489455268336206.
if (CountyID=66) InflatedCommWgt=0.145316949758541.
if (CountyID=67) InflatedCommWgt=0.617223476553681.

frequencies variables=InflatedCommWgt.

compute InflatedEitherWgt=$sysmis.
if (CountyID=1) InflatedEitherWgt=6.60332367961472.
if (CountyID=2) InflatedEitherWgt=10.228053423494.
if (CountyID=3) InflatedEitherWgt=2.82655465107326.
if (CountyID=4) InflatedEitherWgt=0.891141565395357.
if (CountyID=5) InflatedEitherWgt=0.211057549779008.
if (CountyID=6) InflatedEitherWgt=1.5266031446876.
if (CountyID=7) InflatedEitherWgt=8.73541836321433.
if (CountyID=11) InflatedEitherWgt=0.0782457089296436.
if (CountyID=12) InflatedEitherWgt=0.52733949594617.
if (CountyID=13) InflatedEitherWgt=2.72763865159203.
if (CountyID=14) InflatedEitherWgt=0.371384185043794.
if (CountyID=15) InflatedEitherWgt=3.49496429976134.
if (CountyID=16) InflatedEitherWgt=0.0339205389677383.
if (CountyID=18) InflatedEitherWgt=0.247845560751057.
if (CountyID=19) InflatedEitherWgt=2.48857229191509.
if (CountyID=23) InflatedEitherWgt=4.25719975743322.
if (CountyID=24) InflatedEitherWgt=0.181056965141965.
if (CountyID=27) InflatedEitherWgt=0.0475563409971441.
if (CountyID=28) InflatedEitherWgt=0.80877941802364.
if (CountyID=29) InflatedEitherWgt=0.0669849732941512.
if (CountyID=31) InflatedEitherWgt=0.0669532171804886.
if (CountyID=34) InflatedEitherWgt=0.736754449678306.
if (CountyID=35) InflatedEitherWgt=1.32985740149012.
if (CountyID=36) InflatedEitherWgt=9.46535398691473.
if (CountyID=38) InflatedEitherWgt=19.9721582916529.
if (CountyID=39) InflatedEitherWgt=5.14166969915923.
if (CountyID=40) InflatedEitherWgt=0.253029141281655.
if (CountyID=41) InflatedEitherWgt=7.70081953707739.
if (CountyID=42) InflatedEitherWgt=0.217641183835177.
if (CountyID=43) InflatedEitherWgt=0.114349914430981.
if (CountyID=45) InflatedEitherWgt=0.19872416847527.
if (CountyID=46) InflatedEitherWgt=0.940228690524361.
if (CountyID=48) InflatedEitherWgt=5.33416052746349.
if (CountyID=49) InflatedEitherWgt=0.0462810794072231.
if (CountyID=50) InflatedEitherWgt=0.0797689916936648.
if (CountyID=51) InflatedEitherWgt=0.650032859923808.
if (CountyID=53) InflatedEitherWgt=2.3155981200534.
if (CountyID=54) InflatedEitherWgt=0.458506208494717.
if (CountyID=55) InflatedEitherWgt=0.272890320843138.
if (CountyID=56) InflatedEitherWgt=0.146870036771079.
if (CountyID=57) InflatedEitherWgt=0.0500855783549297.
if (CountyID=58) InflatedEitherWgt=0.102513231230693.
if (CountyID=59) InflatedEitherWgt=0.0191837084774352.
if (CountyID=60) InflatedEitherWgt=9.65787720529987.
if (CountyID=61) InflatedEitherWgt=7.16079065942067.
if (CountyID=62) InflatedEitherWgt=0.0695986345539819.
if (CountyID=63) InflatedEitherWgt=3.13255168094524.
if (CountyID=64) InflatedEitherWgt=0.0932699099567822.
if (CountyID=65) InflatedEitherWgt=0.297699209957677.
if (CountyID=66) InflatedEitherWgt=0.144913149130683.
if (CountyID=67) InflatedEitherWgt=0.648890931076133.


frequencies variables=InflatedEitherWgt.

