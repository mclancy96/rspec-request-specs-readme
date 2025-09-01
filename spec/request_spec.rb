# Example RSpec file for request specs (pure Ruby)
#
# Instructions:
# 1. This lesson is about request specs, but here is a Ruby example.
# 2. Try simulating your own request/response logic!

RSpec.describe 'Request Specs Example' do
  it 'simulates a request' do
    response = 'OK'
    expect(response).to eq('OK')
  end
end
