class OffsetSequencedModel
  include Mongoid::Document
  include Mongoid::Sequence

  field :auto_increment, :type => Integer
  sequence :auto_increment, :offset => 5
end
