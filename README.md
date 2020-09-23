# Assembly

<p>There are two assembly programs:</p>
<ol>
<li>first.asm counts the spaces in the given string</li>
  <p></p>
<li>sec.asm searches for the given substring in one file and outputs to another file the number of the lines where this substring was found, and the lines themselves. For instance, if <i>data.txt</i> file is:
  
```
a;lsdkjf
a a mk'adaBCdjk;anm 
abcdmavjnasjdbnlkasbv
xzcaabcdskdjbn, abcd
Szmbn>JSADhabcd
zxn.z,mv'wdaabcd
ncxzb[abcabcd


sad;fkahsdlfkj

abcd
sa;dlkfjas;ljk
;lsadkjf;lkj
```
the command 
```
sec.asm data.txt abcd res.txt
```
would create <i>res.txt</i>:
```
3: abcdmavjnasjdbnlkasbv
4: xzcaabcdskdjbn, abcd
5: Szmbn>JSADhabcd
6: zxn.z,mv'wdaabcd
7: ncxzb[abcabcd
12: abcd
```
</li>
