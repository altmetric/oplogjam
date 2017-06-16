module Oplogjam
  class Unset
    def self.from(operation)
      operation.each_with_object(new) do |(dotted_path, _), unset|
        path = dotted_path.split('.'.freeze)

        if path.last =~ /\A\d+\z/
          unset.unset_index(path)
        else
          unset.unset_field(path)
        end
      end
    end

    attr_reader :unsets

    def initialize(unsets = [])
      @unsets = unsets
    end

    def unset_field(path)
      unsets << UnsetField.new(path)
    end

    def unset_index(path)
      unsets << UnsetIndex.new(path)
    end

    def delete(column)
      unsets.inject(column) do |subject, unset|
        unset.delete(subject)
      end
    end
  end

  class UnsetField
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def delete(column)
      column.delete_path(path)
    end
  end

  class UnsetIndex
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def delete(column)
      Sequel.pg_jsonb_op(
        Sequel.case(
          { 'array' => Sequel.case([[Sequel.function(:jsonb_array_length, column[parent_path]) > index, column.set(path, 'null'.freeze)]], column.delete_path(path)) },
          column.delete_path(path),
          Sequel.function(:jsonb_typeof, column[parent_path])
        )
      )
    end

    def parent_path
      path[0...-1]
    end

    def index
      Integer(path.last, 10)
    end
  end
end
