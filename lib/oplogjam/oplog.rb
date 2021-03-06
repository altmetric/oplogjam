require 'oplogjam/operation'

module Oplogjam
  class Oplog
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def operations(query = {})
      Enumerator.new do |yielder|
        cursor = client.use(LOCAL)[OPLOG].find(query, cursor_type: :tailable_await).no_cursor_timeout

        cursor.each do |document|
          yielder << Operation.from(document)
        end
      end
    end
  end
end
