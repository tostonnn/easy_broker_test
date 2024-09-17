require 'minitest/autorun'
require 'httparty'
require_relative 'app'  

# We use stub to mock responses 

class EasyBrokerTest < Minitest::Test
  def setup
    @broker = EasyBroker.new
  end

  def test_fetch_properties
    mock_response = {'content' => [{"title" => "Propiedad 1"}, {"title" => "Propiedad 2"}]}

    # We simulate httparty response
    HTTParty.stub :get, mock_response do
      # send so we can access the private method
      response = @broker.send(:fetch_properties) 
      assert_equal mock_response, response
    end
  end
  
  def test_extract_titles
    response = { 'content' => [{"title" => "Propiedad 1"}, {"title" => "Propiedad 2"}] }
    
    titles = @broker.send(:extract_titles, response)
    assert_equal ["Propiedad 1", "Propiedad 2"], titles
  end

  def test_print_titles
    titles = ["Propiedad 1", "Propiedad 2"]

    assert_output("Propiedad 1\nPropiedad 2\n") do
      @broker.send(:print_titles, titles)
    end
  end

  def test_consume_properties
    mock_response = {'content' => [{"title" => "Propiedad 1"}, {"title" => "Propiedad 2"}]}

    @broker.stub :fetch_properties, mock_response do
      @broker.stub :extract_titles, ["Propiedad 1", "Propiedad 2"] do
        titles = @broker.consume_properties
        assert_equal ["Propiedad 1", "Propiedad 2"], titles
      end
    end
  end
end
