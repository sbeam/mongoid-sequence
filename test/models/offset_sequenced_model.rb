class OffsetSequencedModel
  include Mongoid::Document
  include Mongoid::Sequence

  field :auto_increment, :type => Integer
  sequence :auto_increment, :offset => 200_000

  field :string_seq, :type => String
  sequence :string_seq, :offset => 100
end
