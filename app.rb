require 'net/http'
require 'uri'
require 'json'

# this class interacts with the EasyBroker API. The api key is hardcoded for testing purposes only, using a playground (staging) environment

# the methods are modular to promote reusability and scalability, allowing for easy addition of new features
# sensitive operations are encapsulated and hidden in private methods to maintain a clean public api interface

# i opted to use a gem for http request since makes everything more fast and simple (don't reinvent the wheel)


class EasyBroker

    def initialize
        @key = 'l7u502p8v46ba3ppgvj5y2aad50lb9'
    end

    def consume_properties
        response = fetch_properties
        properties_title = extract_titles(response)
        print_titles(properties_title)
        properties_title
    end

    private

    def fetch_properties
      HTTParty.get(
      'https://api.stagingeb.com/v1/properties',
      headers: {
          'Country-Code' => 'MX',
          'X-Authorization' => @key,
          'accept' => 'application/json'
      }
      )
    end
      
      def extract_titles(response)
        response['content'].map { |property| property['title'] }
      end
    
      def print_titles(titles)
        titles.each { |title| puts title }
      end
end