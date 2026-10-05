import json, os, sys, datetime
import urllib.request, urllib.parse

B = "https://www.myfxbook.com/api/"
PAIRS = ["EURUSD","GBPUSD","USDJPY","USDCHF","AUDUSD","USDCAD","NZDUSD","EURGBP",
         "EURJPY","GBPJPY","AUDJPY","EURCHF","GBPCHF","CADJPY","EURAUD"]
q = urllib.parse.quote

def get(path):
    with urllib.request.urlopen(B + path, timeout=30) as r:
        return json.load(r)

login = get("login.json?email=%s&password=%s" % (q(os.environ["MYFXBOOK_EMAIL"]), q(os.environ["MYFXBOOK_PASSWORD"])))
if login.get("error"):
    sys.exit("Login Myfxbook refusé: " + str(login.get("message")))
ses = login["session"]

try:
    data = get("get-community-outlook.json?session=" + q(ses))
finally:
    try:
        get("logout.json?session=" + q(ses))
    except Exception:
        pass

if data.get("error"):
    sys.exit("Outlook erreur: " + str(data.get("message")))

out = {"updated": datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"), "pairs": {}}
for s in data.get("symbols", []):
    if s.get("name") in PAIRS:
        out["pairs"][s["name"]] = {
            "long": s.get("longPercentage"),
            "short": s.get("shortPercentage"),
            "lots": round(float(s.get("longVolume", 0)) + float(s.get("shortVolume", 0)), 1),
        }

if len(out["pairs"]) == 0:
    sys.exit("Aucune paire reçue, fichier non modifié")

with open("sentiment-data.json", "w") as f:
    json.dump(out, f, indent=1)
print("OK", len(out["pairs"]), "paires")
