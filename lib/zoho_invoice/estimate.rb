module ZohoInvoice
  class Estimate < Base

    READ_ATTRIBUTES = [
      :estimate_id,
      :customer_name,
      :customer_id,
      :status,
      :estimate_number,
      :reference_number,
      :date,
      :currency_id,
      :currency_code,
      :total,
      :created_time,
      :accepted_date,
      :declined_date,
      :expiry_date,
      :line_items,
      :contact_persons,
      :exchange_rate,
      :discount,
      :taxes,
      :billing_address,
      :shipping_address,
      :custom_fields,
      :salesperson_id,
      :salesperson_name,
      :last_modified_time,
      :notes,
      :terms
    ]

    CREATE_UPDATE_ATTRIBUTES = READ_ATTRIBUTES - [:estimate_id]

    define_object_attrs(*READ_ATTRIBUTES)

    has_many :line_items
    has_many :custom_fields

    def self.all(client)
      retrieve(client, '/api/v3/estimates')
    end

    def self.find(client, id, options={})
      retrieve(client, "/api/v3/estimates/#{id}", false)
    end

    def self.create_and_send(client, options = {})
      self.new(client, options).save(send: true)
    end

    def send_email(params = {})
      params[:to_mail_ids] ||= []
      result = client.post("/api/v3/estimates/#{estimate_id}/email", params)
      self
    rescue Faraday::Error::ClientError => e
      if e.response && e.response[:body]
        raise ZohoInvoice::Error::ClientError.from_response(e.response)
      end
    end

  end
end