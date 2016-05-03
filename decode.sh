#! /bin/bash

message="Ev vek avwur mqjk ckutkjkr te nmk uqxn lkqgx vh nmk eteknkkenm skenwgl nmqn nmtx avgur aqx cktei aqnsmkr bbkkeul qer suvxkul cl tenkuutikeskx igkqnkg nmqe oqe'x qer lkn qx ovgnqu qx mtx vae; nmqn qx oke cwxtkr nmkoxkujkx qcvwn nmktg jqgtvwx sveskgex nmkl akgk xsgwntetxkr qer xnwrtkr, dkgmqdx quovxn qx eqggvaul qx q oqe atnm q otsgvxsvdk otimn xsgwntetxk nmk ngqextken sgkqnwgkx nmqn xaqgo qer owuntdul te q rgvd vh aqnkg. Atnm tehtetnk svoduqskesl oke aken nv qer hgv vjkg nmtx iuvck qcvwn nmktg utnnuk qhhqtgx, xkgkek te nmktg qxxwgqesk vh nmktg kodtgk vjkg oqnnkg. Tn tx dvxxtcuk nmqn nmk tehwxvgtq werkg nmk otsgvxsvdk rv nmk xqok. Ev vek iqjk q nmvwimn nv nmk vurkg avgurx vh xdqsk qx xvwgskx vh mwoqe rqeikg, vg nmvwimn vh nmko veul nv rtxotxx nmk trkq vh uthk wdve nmko qx todvxxtcuk vg todgvcqcuk. Tn tx swgtvwx nv gksquu xvok vh nmk okenqu mqctnx vh nmvxk rkdqgnkr rqlx. Qn ovxn nkggkxngtqu oke hqestkr nmkgk otimn ck vnmkg oke wdve Oqgx, dkgmqdx tehkgtvg nv nmkoxkujjkx qer gkqrl nv akusvok q otxxtveqgl kenkgdgtxk. Lkn qsgvxx nmk iwuh vh xdqsk, oterx nmqn qgk nv vwg oterx qx vwgx qgk nv nmvxk vh nmk ckqxnx nmqn dkgtxm, tenkuuksnx jqxn qer svvu qer wexlodqnmknts, gkiqgrkr nmtx kqgnm atnm kejtvwx klkx, qer xuvaul qer xwgkul rgka nmktg duqex qiqtexn wx. Qer kqgul te nmk nakentknm skenwgl sqok nmk igkqn rtxtuuwxtveoken.
Nmk duqekn Oqgx, T xsqgskul ekkr gkoter nmk gkqrkg, gkjvujkx qcvwn nmk xwe qn q okqe rtxnqesk vh 140,000,000 otukx, qer nmk utimn qer mkqn tn gksktjkx hgvo nmk xwe tx cqgkul mquh vh nmqn gksktjkr cl nmtx avgur. Tn owxn ck, th nmk ekcwuqg mldvnmkxtx mqx qel ngwnm, vurkg nmqe vwg avgur; qer uvei ckhvgk nmtx kqgnm skqxkr nv ck ovunke, uthk wdve tnx xwghqsk owxn mqjk ckiwe tnx svwgxk. Nmk hqsn nmqn tn tx xsqgskul vek xkjkenm vh nmk jvuwok vh nmk kqgnm owxn mqjk qsskukgqnkr tnx svvutei nv nmk nkodkgqnwgk qn amtsm uthk svwur ckite. Tn mqx qtg qer aqnkg qer quu nmqn tx ekskxxqgl hvg nmk xwddvgn vh qetoqnkr kpptxnkesk.
Lkn xv jqte tx oqe, qer xv cuterkr cl mtx jqetnl, nmqn ev agtnkg, wd nv nmk jkgl ker vh nmk eteknkkenm skenwgl, kpdgkxxkr qel trkq nmqn tenkuutiken uthk otimn mqjk rkjkuvdkr nmkgk hqg, vg terkkr qn quu, cklver tnx kqgnmul ukjku. Evg aqx tn ikekgquul werkgxnvvr nmqn xtesk Oqgx tx vurkg nmqe vwg kqgnm, atnm xsqgskul q fwqgnkg vh nmk xwdkghtstqu qgkq qer gkovnkg hgvo nmk xwe, tn ekskxxqgtul hvuuvax nmqn tn tx evn veul ovgk rtxnqen hgvo ntok'x ckiteetei cwn ekqgkg tnx ker."

letters=(e t a s r i n o h l d m u c f y p b w v g x k q)

messageLower=$(echo ${message,,} | sed 's|[^a-z]||g')
declare -A letterArr
for i in $(seq 0 $((${#messageLower}-1))) ; do
    letter=${messageLower:$i:1}
    if [ ! ${letterArr[$letter]+_} ] ; then
        letterArr[$letter]=0
    fi
    letterArr[$letter]=$((${letterArr[$letter]} + 1))
done

letterStr=()
for i in ${!letterArr[@]}; do
    letterStr=(${letterStr[@]} "$i:${letterArr[$i]}")
done

letterStrSorted=($(for a in ${letterStr[@]}; do echo $a; done | sort -V -t \: -k2 -r | awk -F":" '{print $1}'))

newMessage=$(echo ${message,,})
for i in $(seq 0 $((${#letterStrSorted[@]}-1))); do
    newMessage=$(echo $newMessage | sed "s|${letterStrSorted[$i]}|${letters[$i]^^}|g")
done

finalMessage=''
for i in $(seq 0 ${#newMessage}); do
    thisChar=${message:$i:1}
    if [ $thisChar == ${thisChar^^} ] ; then 
        newChar=${newMessage:$i:1}
        finalMessage=$finalMessage${newChar^^}
    else
        newChar=${newMessage:$i:1}
        finalMessage=$finalMessage${newChar,,}
    fi
done

echo $finalMessage
