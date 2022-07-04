
import time
from datetime import datetime
from bs4 import BeautifulSoup
import requests
import csv

"""
*** IMPORTANT LEGAL DISCLAIMER [Taken from yfinance] ***
Yahoo!, Y!Finance, and Yahoo! finance are registered trademarks of Yahoo, Inc.

This script is not affiliated, endorsed, or vetted by Yahoo, Inc. It's an open-source tool that uses Yahoo's publicly available APIs, and is intended for research and educational purposes.

You should refer to Yahoo!'s terms of use for details on your rights to use the actual data downloaded. Remember - the Yahoo! finance API is intended for personal use only.

---

Scrape quotes from Yahoo Finance (CA) site and write daily price rows to CSV.
Note: Since I live in Canada Yahoo! Finance redirects to CA site (ca.finance.yahoo.com).

Instructions:
    Fill in the 'TICKER' (stock ticker e.g: PZZA, MSFT etc...),
    'START_DATE' (MM/DD/YYYY), and 'END_DATE' (MM/DD/YYYY) variables with your needs.
"""


def get_epoch(date_string):
    """Calculate epoch from human readable string date format.
    Args:
        date_string (str): Date string in MM/DD/YYYY.
    Returns:
        int: date in Epoch.
    """
    try:
        pattern = '%m/%d/%Y'
        epoch = int(time.mktime(time.strptime(date_string, pattern)))
        return epoch
    except ValueError as dateError:
        print(dateError)


# Add your info below...
TICKER = 'PZZA'
START_DATE = get_epoch('06/07/1993')
END_DATE = get_epoch('06/01/2022')


def main():
    # Requests header
    REQ_USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.164 Safari/537.36'
    REQ_HEADERS = {
        'User-Agent': REQ_USER_AGENT
    }

    # Yahoo! URL
    QUOTE_URL = f'https://ca.finance.yahoo.com/quote/{TICKER}/history?period1={START_DATE}&period2={END_DATE}&interval=1d&filter=history&frequency=1d&includeAdjustedClose=true'

    quotes_req_html_text = requests.get(QUOTE_URL, headers=REQ_HEADERS).text

    # Soup
    soup = BeautifulSoup(quotes_req_html_text, 'lxml')
    soup_quotes = soup.find_all('tr', class_='BdT Bdc($seperatorColor) Ta(end) Fz(s) Whs(nw)')

    # Open CSV and cursor
    csv_file = open(f'{TICKER}_{START_DATE}_{END_DATE}.csv', 'w')
    writer = csv.writer(csv_file)
    # writer.writerow(['Date', 'Open', 'High', 'Low', 'Close', 'Adjust_Close', 'Volume']) # Header
    for soup_quote in soup_quotes:
        # Date
        quote_dates = soup_quote.find_all('td', class_='Py(10px) Ta(start) Pend(10px)')

        # Quote/day
        quotes_for_day = soup_quote.find_all('td', class_='Py(10px) Pstart(10px)')
        try:
            str_date = quote_dates[0].get_text()
            str_date = str_date.replace('.', '')
            date = datetime.strptime(str_date, '%b %d, %Y').strftime('%Y-%m-%d')
            open_quote = quotes_for_day[0].get_text()
            high_quote = quotes_for_day[1].get_text()
            low_quote = quotes_for_day[2].get_text()
            close_quote = quotes_for_day[3].get_text()
            adj_close_quote = quotes_for_day[4].get_text()

            volume_quote = quotes_for_day[5].get_text()
            volume_quote = volume_quote.replace(',', '')

            print(f'{date} - {open_quote} - {high_quote} - {low_quote} - {close_quote} - {adj_close_quote} - {volume_quote}')
            writer.writerow([date, open_quote, high_quote, low_quote, close_quote, adj_close_quote, volume_quote])
            time.sleep(0.1)
        except IndexError as iError:
            print(iError)

    csv_file.close()


if __name__ == '__main__':
    main()
