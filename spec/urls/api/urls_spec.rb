require 'rails_helper'

RSpec.describe 'Urls API', type: :request do
  let(:valid_url) { { url: { original_url: 'https://example.com' } } }
  let(:invalid_url) { { url: { original_url: 'invalid-url' } } }
  let!(:api_token) { ApiToken.create!(token: SecureRandom.hex(16)) }
  let(:headers) { { 'Authorization' => "Bearer #{api_token.token}" } }

  describe 'POST /api/urls' do
    context 'with valid attributes' do
      it 'creates a shortened URL' do
        post '/api/urls', params: valid_url, headers: headers

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('short_url')
      end
    end

    context 'with invalid attributes' do
      it 'returns an error' do
        post '/api/urls', params: invalid_url, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'GET /api/urls/:short_url' do
    let!(:url) { Url.create!(original_url: 'https://example.com', short_url: 'abc123') }

    context 'with a valid short_url' do
      it 'returns the original URL' do
        get "/api/urls/#{url.short_url}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq('original_url' => url.original_url)
      end
    end

    context 'with an invalid short_url' do
      it 'returns not found' do
        get '/api/urls/invalid', headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
