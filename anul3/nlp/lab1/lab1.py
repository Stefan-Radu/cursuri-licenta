import json
import scrapy
# from scrapy.crawler import CrawlerRunner
from scrapy.crawler import CrawlerProcess


class IMDBSpider(scrapy.Spider):
    name = 'imdb.com/chart/top'

    custom_settings = {
        'COOKIES_ENABLED': True,
        # exports reviews to 'reviews.json'
        'FEED_FORMAT': 'json',
        'FEED_URI': './reviews.json',
    }

    start_urls = [
        'https://www.imdb.com/chart/top/'
    ]

    count = 2
    cookie = ''

    @staticmethod
    def GetCookie(response):
        li = [x.decode('utf-8') for x in response.headers.getlist('Set-Cookie')]
        li = [x.split(';')[0] for x in li]
        return '; '.join(li)

    def parse(self, response):
        XPATH = "//table[@data-caller-name='chart-top250movie']/tbody/tr/td[@class='titleColumn']/a"
        movies = response.xpath(XPATH)

        reviews_page = 'https://www.imdb.com/title/{}/reviews'

        IMDBSpider.cookie = IMDBSpider.GetCookie(response)

        review_links = []
        for i, movie in enumerate(movies, 1):
            title = movie.xpath(".//text()").get().strip()
            url = movie.xpath(".//@href").get().strip()
            movie_id = url.split('/')[-2]
            movie_reviews_url = reviews_page.format(movie_id)
            review_links.append({
                'index': i,
                'title': title,
                'reviews_url': movie_reviews_url
            })
            yield scrapy.Request(movie_reviews_url, self.parse_reviews, \
                                 headers={ 'Cookie': IMDBSpider.cookie })

        # can be output to a file
        # TASK 1 -> link catre pagina de recenzii
        with open('review_links.json', 'w') as f:
            data = json.dumps(review_links, indent=4)
            f.write(data)


    @staticmethod
    def GetTitle(response):
        return response.xpath('.//a[@class="title"]/text()').get().strip()


    @staticmethod
    def GetText(response):
        xp = './/div[@class="content"]/div/text()'
        return response.xpath(xp).get().strip()


    @staticmethod
    def GetRating(response):
        xpath = './/div[@class="ipl-ratings-bar"]/span/span/text()'
        return ''.join(response.xpath(xpath).getall())


    @staticmethod
    def GetDate(response):
        return response.xpath('.//span[@class="review-date"]/text()').get()


    @staticmethod
    def GetUser(response):
        xp = './/span[@class="display-name-link"]/a/text()'
        return response.xpath(xp).get()


    def parse_reviews(self, response):
        if IMDBSpider.count == 0:
            return

        """
        TASK 4 -> load more

        Am incercat sa "load more", dar nu am reusit sa impersonez browser-ul
        suficient de bine ca sa primesc ceva bun inapoi
        probabil as avea mai mult succes daca as folosi requests, dar deja nu
        mai am timp. mi-am sapat singur groapa cu scrapy, ar fi iesit din 2
        click-uri cu selenium. aiaie.


        load_more_button = response.xpath(".//div[@class='load-more-data']")
        data_key = load_more_button.xpath(".//@data-key").get()
        url = response.urljoin(f'_ajax?ref_=undefined&paginationKey={data_key}')
        IMDBSpider.count -= 1

        cookie = IMDBSpider.GetCookie(response)
        print(cookie)
        print(response.headers)
        print(IMDBSpider.cookie)

        yield scrapy.Request(url, self.parse_reviews,
            headers= {
                'accept': '*/*',
                'accept-encoding': 'gzip, deflate, br',
                'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8,ro;q=0.7',
                'referer': response.url,
                'sec-fetch-dest': 'empty',
                'sec-fetch-mode': 'cors',
                'sec-fetch-site': 'same-origin',
                'sec-gpc': 1,
                'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
                              '(KHTML, like Gecko) Chrome/98.0.4758.87 Safari/537.36',
                'x-requested-with': 'XMLHttpRequest',
                'Cookie': IMDBSpider.cookie,
            })

        """

        movie_name = response.xpath('.//h3[@itemprop="name"]/a/text()').get()

        reviews = response.xpath(".//div[@class='lister-item-content']")
        for review in reviews:
            # TASK 2 & 3 -> colectez date despre fiecare recenzie
            data = {
                'movie_name': movie_name,
                'title': IMDBSpider.GetTitle(review),
                'text': IMDBSpider.GetText(review),
                'rating': IMDBSpider.GetRating(review),
                'date': IMDBSpider.GetDate(review),
                'user': IMDBSpider.GetUser(review),
            }
            yield data

def run_spider():
    process = CrawlerProcess()
    process.crawl(IMDBSpider)
    process.start()

run_spider()
