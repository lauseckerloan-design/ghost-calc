<!DOCTYPE html>
<html lang="fr"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>GHOST · Sentiment</title>
<style>
:root{--bg:#0a1226;--card:#111c38;--line:#1f2d52;--tx:#e8eeff;--mu:#8a98c0;--bu:#2ecc8f;--be:#ff5d6c;--ac:#4d8dff}
*{box-sizing:border-box}
body{margin:0 auto;background:var(--bg);color:var(--tx);font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;padding:16px;max-width:900px}
h1{font-size:20px;margin:4px 0;letter-spacing:2px}h1 span{color:var(--ac)}
#st{color:var(--mu);font-size:13px;margin-bottom:14px}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:10px}
.c{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:12px}
.t{display:flex;justify-content:space-between;font-weight:700;margin-bottom:8px}
.b{height:10px;border-radius:5px;background:var(--be);overflow:hidden}
.b u{display:block;height:10px;background:var(--bu)}
.n{display:flex;justify-content:space-between;font-size:12px;margin:6px 0;color:var(--mu)}
.n .l{color:var(--bu)}.n .s{color:var(--be)}
.k{font-size:12px;font-weight:600}
.warn{color:#ffb84d}
</style></head><body>
<h1>GHOST <span>· SENTIMENT</span></h1>
<div id="st">Chargement…</div>
<div class="grid" id="g"></div>
<script>
var G=document.getElementById("g"),ST=document.getElementById("st");
function bias(l){if(l>=65)return["Foule acheteuse → biais contrarian BAISSIER","var(--be)"];
if(l<=35)return["Foule vendeuse → biais contrarian HAUSSIER","var(--bu)"];return["Foule partagée → pas de signal","var(--mu)"]}
function fmt(p){return p.slice(0,3)+"/"+p.slice(3)}
function draw(d){var a=[],k;for(k in d.pairs)a.push(k);
a.sort(function(x,y){return Math.abs(d.pairs[y].long-50)-Math.abs(d.pairs[x].long-50)});
var h="",i;for(i=0;i<a.length;i++){var p=d.pairs[a[i]],bs=bias(p.long);
h+='<div class="c"><div class="t"><span>'+fmt(a[i])+'</span><span>'+p.lots+' lots</span></div>'+
'<div class="b"><u style="width:'+p.long+'%"></u></div>'+
'<div class="n"><span class="l">Acheteurs '+p.long+'%</span><span class="s">Vendeurs '+p.short+'%</span></div>'+
'<div class="k" style="color:'+bs[1]+'">'+bs[0]+'</div></div>'}
G.innerHTML=h;
var m=Math.round((new Date().getTime()-new Date(d.updated).getTime())/60000);
ST.innerHTML="Foule retail Myfxbook · mis à jour il y a "+m+" min"+(m>60?' <span class="warn">(données anciennes)</span>':"")}
function load(){var x=new XMLHttpRequest();x.open("GET","sentiment-data.json?t="+new Date().getTime(),true);
x.onreadystatechange=function(){if(x.readyState!==4)return;
if(x.status===200){try{draw(JSON.parse(x.responseText))}catch(e){ST.textContent="Fichier de données illisible"}}
else ST.textContent="Pas encore de données : lance le workflow GitHub une première fois."};x.send()}
load();setInterval(load,300000);
</script></body></html>
