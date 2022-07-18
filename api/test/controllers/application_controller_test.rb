# frozen_string_literal: true

require 'test_helper'

class ApplicationControllerTest < ControllerTest
  test 'should get index' do
    get root_path, xhr: true

    assert_response :ok
    assert_equal 'Hello World from Backend!', JSON.parse(response.body)['text']
    assert_equal 'application/json', response.media_type
  end
end
