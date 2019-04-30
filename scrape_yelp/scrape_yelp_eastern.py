import requests
import json
import pandas as pd

API_KEY = '9zugF8ss_jbQwpd-Ms-NtO2oarzoDG6UDyx7cZqEitL-jZnX3YS5XaIogtgRGOezaezIv-eQTaf6O0a538NZdG-FQL710MZ6NAs2jAUXE7KqlAII_mGLlifMgsCiXHYx'
URL = 'https://api.yelp.com/v3/businesses/search'
HEADERS = {'Authorization': 'bearer %s' % API_KEY}

def search_yelp(terms):
    business_data_eastern = []

    # Yelp API allows for max limit of 50 results and max 1000 results total using offset
    for term in terms:
        cuisine = term.split(' ')[0]
        for offset in range(0, 1000, 50):
            parameters = {
                'term': term,
                'limit': 50,
                'location': 'New York',
                'offset': offset
                }

            # Make a request to the Yelp API
            response = requests.get(URL, headers=HEADERS, params=parameters)
            if response.status_code == 200:
                results = response.json()['businesses']
                for item in results:
                    # Add cuisine to resulting
                    item['cuisine'] = cuisine
                business_data_eastern.extend(results)   
            elif response.status_code == 400:
                print('400 Bad Request')
                break
    return business_data_eastern

def output_total_data(df):
    df.to_csv('business_data_eastern.csv', index=False)
    data = df.to_json(orient='records')
    with open('business_data_eastern.json', 'w') as outfile:
        json.dump(json.loads(data), outfile, indent=4)

def main():
    categories = ['chinese', 'korean', 'japanese', 'indian', 'thai']
    # Added 'food' to query options 
    terms = ['restaurants', 'food']
    queries = ['%s %s' % (cat, term) for term in terms for cat in categories]
    business_data_eastern = search_yelp(queries)

    df = pd.DataFrame(business_data_eastern)
    df.drop_duplicates(['id'], keep='first', inplace=True)

    output_total_data(df)

if __name__ == '__main__':
    main()
