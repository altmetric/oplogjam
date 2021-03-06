require 'bson'
require 'oj'
require 'sequel'
require 'oplogjam/oplog'
require 'oplogjam/sanitizer'
require 'oplogjam/schema'

module Oplogjam
  # Enable Sequel extensions for JSONB
  Sequel.extension :pg_array, :pg_json, :pg_json_ops

  # Operation types
  APPLY_OPS = 'applyOps'.freeze
  C = 'c'.freeze
  D = 'd'.freeze
  U = 'u'.freeze
  I = 'i'.freeze
  N = 'n'.freeze
  UNKNOWN = 'unknown'.freeze

  # Operation fields
  H = 'h'.freeze
  MSG = 'msg'.freeze
  NS = 'ns'.freeze
  O = 'o'.freeze
  O2 = 'o2'.freeze
  OP = 'op'.freeze
  TS = 'ts'.freeze

  # BSON fields
  ID = '_id'.freeze
  SET = '$set'.freeze
  UNSET = '$unset'.freeze
  FIELD_SEPARATOR = '.'.freeze
  NUMERIC_INDEX = /\A\d+\z/

  # SQL
  ARRAY_TYPE = 'array'.freeze
  EMPTY_OBJECT = Sequel.pg_jsonb({}.freeze)
  NULL = 'null'.freeze
  TABLE = 'table'.freeze
  SCHEMA = 'schema'.freeze
  PUBLIC = 'public'.freeze

  # Recursive updates
  UPDATE_COLUMN = proc { |column, node| node.update(column) }

  # Database & collection names
  LOCAL = 'local'.freeze
  OPLOG = 'oplog.rs'.freeze

  # Strict type coercion for BSON types
  def self.Timestamp(ts)
    raise TypeError, "#{ts} is not a BSON Timestamp" unless ts.is_a?(BSON::Timestamp)

    ts
  end

  def self.Document(document)
    raise TypeError, "#{document} is not a BSON Document" unless document.is_a?(BSON::Document)

    document
  end

  # Override JSONB serialization to sanitize data first
  def Sequel.object_to_json(obj, *args, &blk)
    Oj.dump(Sanitizer.sanitize(obj), mode: :rails)
  end
end
