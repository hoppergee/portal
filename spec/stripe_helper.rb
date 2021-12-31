class StripeFixtures
  def self.subscription
    # Copied from an interactive session in 'rails console' and formatted with lots of coffee ☕
    {
      id: 'sub_2KC1LV2LsKuf8PTnvJLzsyyW',
      object: 'subscription',
      application_fee_percent: nil,
      automatic_tax: { enabled: false },
      billing_cycle_anchor: 1_640_869_625,
      billing_thresholds: nil,
      cancel_at: nil,
      cancel_at_period_end: false,
      canceled_at: nil,
      collection_method: 'charge_automatically',
      created: 1_640_869_625,
      current_period_end: 1_643_548_025,
      current_period_start: 1_640_869_625,
      customer: 'cus_KlkMhiXwXBECSW',
      days_until_due: nil,
      default_payment_method: nil,
      default_source: nil,
      default_tax_rates: [],
      discount: nil,
      ended_at: nil,
      items: { object: 'list',
               data: [{ id: 'si_Ks8cmxDUSgtHga',
                        object: 'subscription_item',
                        billing_thresholds: nil,
                        created: 1_640_869_625,
                        metadata: { link_to_service_id: '123' },
                        plan: { id: 'price_1KC3FQ2LsKuf8PTnt6V2lJid',
                                object: 'plan',
                                active: true,
                                aggregate_usage: nil,
                                amount: 6000,
                                amount_decimal: '6000',
                                billing_scheme: 'per_unit',
                                created: 1_640_788_524,
                                currency: 'usd',
                                interval: 'month',
                                interval_count: 1,
                                livemode: false,
                                metadata: {},
                                nickname: nil,
                                product: 'prod_KrmporjD4p1DrA',
                                tiers_mode: nil,
                                transform_usage: nil,
                                trial_period_days: nil,
                                usage_type: 'licensed' },
                        price: { id: 'price_1KC3FQ2LsKuf8PTnt6V2lJid',
                                 object: 'price',
                                 active: true,
                                 billing_scheme: 'per_unit',
                                 created: 1_640_788_524,
                                 currency: 'usd',
                                 livemode: false,
                                 lookup_key: nil,
                                 metadata: {},
                                 nickname: nil,
                                 product: 'prod_KrmporjD4p1DrA',
                                 recurring: { aggregate_usage: nil,
                                              interval: 'month',
                                              interval_count: 1,
                                              trial_period_days: nil,
                                              usage_type: 'licensed' },
                                 tax_behavior: 'unspecified',
                                 tiers_mode: nil,
                                 transform_quantity: nil,
                                 type: 'recurring',
                                 unit_amount: 6000,
                                 unit_amount_decimal: '6000' },
                        quantity: 1,
                        subscription: 'sub_2KC1LV2LsKuf8PTnvJLzsyyW',
                        tax_rates: [] },
                      { id: 'si_Ks8gTNKLLZ0AGY',
                        object: 'subscription_item',
                        billing_thresholds: nil,
                        created: 1_640_869_828,
                        metadata: { link_to_service_id: '456' },
                        plan: { id: 'price_1KC3EB2LsKuf8PTnh6fKuOrr',
                                object: 'plan',
                                active: true,
                                aggregate_usage: nil,
                                amount: 4000,
                                amount_decimal: '4000',
                                billing_scheme: 'per_unit',
                                created: 1_640_788_447,
                                currency: 'usd',
                                interval: 'month',
                                interval_count: 1,
                                livemode: false,
                                metadata: {},
                                nickname: nil,
                                product: 'prod_Krmnc7Bas2ayeT',
                                tiers_mode: nil,
                                transform_usage: nil,
                                trial_period_days: nil,
                                usage_type: 'licensed' },
                        price: { id: 'price_1KC3EB2LsKuf8PTnh6fKuOrr',
                                 object: 'price',
                                 active: true,
                                 billing_scheme: 'per_unit',
                                 created: 1_640_788_447,
                                 currency: 'usd',
                                 livemode: false,
                                 lookup_key: nil,
                                 metadata: {},
                                 nickname: nil,
                                 product: 'prod_Krmnc7Bas2ayeT',
                                 recurring: { aggregate_usage: nil,
                                              interval: 'month',
                                              interval_count: 1,
                                              trial_period_days: nil,
                                              usage_type: 'licensed' },
                                 tax_behavior: 'unspecified',
                                 tiers_mode: nil,
                                 transform_quantity: nil,
                                 type: 'recurring',
                                 unit_amount: 4000,
                                 unit_amount_decimal: '4000' },
                        quantity: 2,
                        subscription: 'sub_2KC1LV2LsKuf8PTnvJLzsyyW',
                        tax_rates: [] }],
               has_more: false,
               total_count: 2,
               url: '/v1/subscription_items?subscription=sub_2KC1LV2LsKuf8PTnvJLzsyyW' },
      latest_invoice: 'in_2KC1LV2LsKuf8PTncbMNfYG8',
      livemode: false,
      metadata: {},
      next_pending_invoice_item_invoice: nil,
      pause_collection: nil,
      payment_settings: { payment_method_options: nil, payment_method_types: nil },
      pending_invoice_item_interval: nil,
      pending_setup_intent: nil,
      pending_update: nil,
      plan: nil,
      quantity: nil,
      schedule: nil,
      start_date: 1_640_869_625,
      status: 'active',
      transfer_data: nil,
      trial_end: nil,
      trial_start: nil
    }
  end
end
