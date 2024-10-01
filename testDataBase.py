import requests
from urllib.parse import urlencode as urlen

def query(func, parameters):
    url = f'http://o91816ut.beget.tech/SQL/{func}.php?'
    head = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'}
    data = requests.get(url, params=urlen(parameters), headers=head)
    try:
        res = data.json()
        if len(res) > 1:
            res = res['result']
    except:
        res = data.text
    return res


print(query('select', {
    'table': "dump",
    'params': "dump"
    })[0]['dump'])