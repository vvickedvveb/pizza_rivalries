This folder contains scripts to get stock quote data
---
`scrape_yahoo_finance_ca.py`
## Install
```shell
# Setup your envirionment
python3 venv -m tools
cd tools
source bin/activate

# Prerequisites
pip install beautifulsoup4
pip install requests
pip install lxml

# Run
python scrape_yahoo_finance_ca.py
```

## Setup
Add the `TICKER`, `START_DATE` & `END_DATE` values e.g:
```python
TICKER = 'PZZA'
START_DATE = get_epoch('01/01/2000')
END_DATE = get_epoch('02/01/2000')
```