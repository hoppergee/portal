require 'rails_helper'
require 'arp_spec_helper'

RSpec.describe StripeEvent, type: :model do
  context 'with event' do
    before :each do
      @stripe_event = StripeEvent.new
    end

    describe 'go!()' do
      context 'with event' do
        context 'with status: processed' do
          before :each do
            @stripe_event.status = 'processed'
          end

          it 'should raise error' do
            expect { @stripe_event.go! }.to raise_error StandardError, /Attempt to handle event already processed/
          end
        end

        context 'with status: received' do
          before :each do
            @stripe_event.status = 'received'
          end

          context 'with event_type invoice.finalized' do
            before :each do
              @stripe_event.event_type = 'invoice.finalized'
            end

            it 'should call proper event handler' do
              expect(@stripe_event).to receive('handle_invoice_finalized!')
              @stripe_event.go!
            end
          end

          context 'with event_type bogus_event' do
            before :each do
              @stripe_event.event_type = 'bogus.event'
            end

            it 'should raise error' do
              expect { @stripe_event.go! }.to raise_error ArgumentError, /Unsupported event/
            end
          end
        end
      end
    end

    describe 'processed?()' do
      context 'when event status is empty' do
        before :each do
          @stripe_event.status = ''
        end

        it 'should return false' do
          expect(@stripe_event.processed?).to eq false
        end
      end

      context 'when event status is nil' do
        before :each do
          @stripe_event.status = nil
        end

        it 'should return false' do
          expect(@stripe_event.processed?).to eq false
        end
      end

      context 'when event status is processed' do
        before :each do
          @stripe_event.status = 'processed'
        end

        it 'should return true' do
          expect(@stripe_event.processed?).to eq true
        end
      end
    end

    describe 'self.process!()' do
      context 'with event and payload' do
        before do
          @stripe_event = mock_model(StripeEvent)
          @event_id = 'evt_1K3eKD2LsKuf8PTnlLJ7FoI8'
          @event_type = 'invoice.finalized'
          @data = OpenStruct.new(object: 'foo')

          @event = OpenStruct.new(
            id: @event_id,
            type: @event_type,
            data: @data
          )

          @payload = 'foo'
        end

        it 'should create a StripeEvent' do
          expect(StripeEvent).to receive(:create).with(
            event_id: @event_id,
            event_type: @event_type,
            status: 'received',
            body: @payload
          ).and_return @stripe_event
          allow(@stripe_event).to receive(:go!)

          StripeEvent.process!(@event, @payload)
        end

        it 'should handle event' do
          allow(StripeEvent).to receive(:create).and_return(@stripe_event)
          expect(@stripe_event).to receive(:go!)
          StripeEvent.process!(@event, @payload)
        end
      end
    end
  end

  describe 'Handlers' do
    describe 'handle_invoice_finalized!' do
      context 'with event' do
        before :each do
          @stripe_event = build(:stripe_event, :invoice_finalized)
          @invoice_id = 'in_1K411S2LsKuf8PTn6WkcBmOf' # Taken from factories.rb
        end

        context 'with incorrect event type' do
          before :each do
            @stripe_event.event_type = 'foo'
          end

          it 'should raise error' do
            expect { @stripe_event.handle_invoice_finalized! }.to raise_error StandardError
          end
        end

        context 'with valid customer' do
          before :each do
            @account = build(:account)
            allow(Account).to receive(:find_by).and_return(@account)
          end

          it 'should create invoice for customer' do
            expect(Invoice).to receive(:create).with(account: @account,
                                                     stripe_invoice_id: @invoice_id)
            @stripe_event.handle_invoice_finalized!
          end

          context 'with invoice' do
            before :each do
              # TODO
            end

            it 'should create line items'
          end
        end

        context 'without valid customer' do
          before :each do
            # No such account given this Stripe customer_id
            allow(Account).to receive(:find_by).and_return(nil)
          end

          it 'should raise error' do
            expect { @stripe_event.handle_invoice_finalized! }.to raise_error StandardError
          end
        end
      end
    end
  end
end
