require File.expand_path(File.dirname(__FILE__) + '/../../../rails_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../arp_spec_helper')

describe Api::V1::StripeController do
  context 'handling POST /api/v1/stripe/webhook' do
    def do_post(opts = {})
      post :webhook, params: { }.merge(opts)
    end

    context 'with endpoint secret' do
      before :each do
        $STRIPE_ENDPOINT_SECRET = 'something'
      end

      context 'with valid payload' do
        before do
          @event = OpenStruct.new(type: 'invoice.finalized', data: OpenStruct.new(object: 'foo'))
          allow(Stripe::Webhook).to receive(:construct_event).and_return(@event)
        end

        it 'should return 200' do
          do_post
          expect(@response).to be_successful
          expect(@response.status).to eq 200
        end
      end

      context 'with invalid payload' do
        before do
          @body = { foo: 'bar' }
        end

        it 'should return 400' do
          do_post(@body)
          expect(@response).to_not be_successful
          expect(@response.status).to eq 400
        end
      end
    end

    context 'without endpoint secret' do
      before do
        @save_it = $STRIPE_ENDPOINT_SECRET
        $STRIPE_ENDPOINT_SECRET = nil
      end

      after do
        $STRIPE_ENDPOINT_SECRET = @save_it
      end

      it 'should return 400' do
        do_post
        expect(@response).to_not be_successful
        expect(@response.status).to eq 400
      end
    end
  end
end
